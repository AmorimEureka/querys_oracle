


-- QUERY ORIGINAL PAINEL HPC-DIRETORIA-Altas e Óbitos
SELECT
	a.CD_ATENDIMENTO Cod_Atend,
	a.CD_PACIENTE Cod_Paciente,
	pa.DT_NASCIMENTO dt_nascimento,
	trunc((months_between(a.DT_ALTA, pa.DT_NASCIMENTO)/12)) IDADE,
	a.TP_ATENDIMENTO,
	INITCAP(pa.NM_PACIENTE) Paciente,
	a.CD_CID Cod_CID,
	INITCAP(p.NM_PRESTADOR) Medico_Alta,
	INITCAP(co.NM_CONVENIO) Convenio,
	a.SN_OBITO SN_Obito,
	a.SN_OBITO_INFEC SN_Obito_Infec,
	s.NM_SETOR Setor_Obito,
	a.DT_ALTA D_Alta_Atend,
	a.DS_OBS_ALTA Ds_Alta,
	INITCAP(c.DS_CID) Ds_Obito
FROM atendime a
	LEFT JOIN PW_REGISTRO_ALTA ra ON a.CD_ATENDIMENTO = ra.CD_ATENDIMENTO
	LEFT JOIN PRESTADOR p ON ra.CD_PRESTADOR = p.CD_PRESTADOR
	LEFT JOIN PACIENTE pa ON a.CD_PACIENTE = pa.CD_PACIENTE
	LEFT JOIN CID c ON c.CD_CID = a.CD_CID_OBITO
	LEFT JOIN SETOR s ON s.CD_SETOR = a.CD_SETOR_OBITO
	LEFT JOIN CONVENIO co ON co.CD_CONVENIO = a.CD_CONVENIO
;



/* ************************************************************************************************************************* */


-- 9377 - AJUSTAR PAINEL HPC-DIRETORIA-Altas e Óbitos QUERY CONSULTA OBTITOS
-- QUERY FINAL AJUSTADA
--  a.SN_OBITO    = 'S'  -> RETORNA 'TP_ATENDIMENTO' IN('I', 'U')
-- ma.TP_MOT_ALTA = 'O'  -> RETORNA APENAS 'TP_ATENDIMENTO' = 'I'
--  a.DT_ALTA            -> CAMPO QUE FILTRA OS OBITOS CORRETAMENTE
-- M_CONTR_DECLARA_OBITO -> TELA DE VALIDACAO
SELECT
	a.CD_ATENDIMENTO Cod_Atend,
	a.CD_PACIENTE Cod_Paciente,
	pa.DT_NASCIMENTO dt_nascimento,
	trunc((months_between(a.DT_ALTA, pa.DT_NASCIMENTO)/12)) IDADE,
	a.TP_ATENDIMENTO,
	INITCAP(pa.NM_PACIENTE) Paciente,
	a.CD_CID Cod_CID,
	INITCAP(p.NM_PRESTADOR) Medico_Alta,
	INITCAP(co.NM_CONVENIO) Convenio,
	a.SN_OBITO SN_Obito,
	a.SN_OBITO_INFEC SN_Obito_Infec,
	s.NM_SETOR Setor_Obito,
	a.DT_ALTA D_Alta_Atend,
	a.DS_OBS_ALTA Ds_Alta,
	INITCAP(c.DS_CID) Ds_Obito,
    a.NR_DECLARACAO_OBITO,
    ma.TP_MOT_ALTA
FROM DBAMV.ATENDIME a
LEFT JOIN PRESTADOR p ON a.CD_PRESTADOR = p.CD_PRESTADOR
LEFT JOIN PACIENTE pa ON a.CD_PACIENTE = pa.CD_PACIENTE
LEFT JOIN CID c ON c.CD_CID = a.CD_CID_OBITO
LEFT JOIN SETOR s ON s.CD_SETOR = a.CD_SETOR_OBITO
LEFT JOIN CONVENIO co ON co.CD_CONVENIO = a.CD_CONVENIO
LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT
WHERE EXTRACT(YEAR FROM a.DT_ALTA) = 2025 AND a.SN_OBITO = 'S';


-- QUERY PARA DASHBOARD KPI GESTAO A VISTA
WITH OBITOS
    AS (
        SELECT
            a.CD_ATENDIMENTO ,
            a.TP_ATENDIMENTO ,
            a.SN_OBITO ,
            CASE
                WHEN s.NM_SETOR LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE s.NM_SETOR
            END AS LOCAL,
            a.DT_ALTA ,
            MAX(a.DT_ALTA) OVER( PARTITION BY CASE WHEN s.NM_SETOR LIKE '%POSTO%' THEN 'POSTO' ELSE s.NM_SETOR END, EXTRACT(YEAR FROM a.DT_ALTA) ) AS ULTIMO_OBITO,
            EXTRACT(MONTH FROM a.DT_ALTA) AS MES ,
            EXTRACT(YEAR FROM a.DT_ALTA) AS ANO ,
            ma.TP_MOT_ALTA
        FROM DBAMV.ATENDIME a
        LEFT JOIN SETOR s ON s.CD_SETOR = a.CD_SETOR_OBITO
        LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT
        WHERE EXTRACT(YEAR FROM a.DT_ALTA) = EXTRACT(YEAR FROM SYSDATE) AND a.SN_OBITO = 'S'
        ORDER BY
            CASE
                WHEN s.NM_SETOR LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE s.NM_SETOR
            END,
            EXTRACT(MONTH FROM a.DT_ALTA),
            EXTRACT(YEAR FROM a.DT_ALTA),
            a.DT_ALTA
),
MOVIMENTACAO_UNIDADES
    AS (
        SELECT
            EXTRACT(MONTH FROM mi.DT_MOV_INT) AS MES,
            EXTRACT(YEAR FROM mi.DT_MOV_INT) AS ANO,
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END AS LOCAL,
            COUNT(*)             AS SAI_TRANSFPARA
        FROM
        DBAMV.MOV_INT mi
        JOIN DBAMV.LEITO l ON mi.CD_LEITO_ANTERIOR = l.CD_LEITO
        JOIN DBAMV.LEITO l1 ON mi.CD_LEITO = l1.CD_LEITO
        JOIN DBAMV.UNID_INT ui ON l.CD_UNID_INT = ui.CD_UNID_INT
        JOIN DBAMV.UNID_INT ui1 ON l1.CD_UNID_INT = ui1.CD_UNID_INT
        JOIN DBAMV.ATENDIME a ON a.CD_ATENDIMENTO = mi.CD_ATENDIMENTO
        WHERE
            mi.TP_MOV = 'O'
            AND ui.CD_UNID_INT <> ui1.CD_UNID_INT
            AND a.TP_ATENDIMENTO IN ('I')
            AND EXTRACT(YEAR FROM mi.DT_MOV_INT) = EXTRACT(YEAR FROM SYSDATE)
        GROUP BY
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END,
            EXTRACT(MONTH FROM mi.DT_MOV_INT),
            EXTRACT(YEAR FROM mi.DT_MOV_INT)
)
SELECT
    o.MES,
    CASE
        WHEN o.MES = 1 THEN 'Jan'
        WHEN o.MES = 2 THEN 'Fev'
        WHEN o.MES = 3 THEN 'Mar'
        WHEN o.MES = 4 THEN 'Abr'
        WHEN o.MES = 5 THEN 'Mai'
        WHEN o.MES = 6 THEN 'Jun'
        WHEN o.MES = 7 THEN 'Jul'
        WHEN o.MES = 8 THEN 'Ago'
        WHEN o.MES = 9 THEN 'Set'
        WHEN o.MES = 10 THEN 'Out'
        WHEN o.MES = 11 THEN 'Nov'
        WHEN o.MES = 11 THEN 'Dez'
    END AS NOME_MES,
    o.ULTIMO_OBITO,
    o.ANO,
    o.LOCAL,
    COUNT(o.CD_ATENDIMENTO) AS QTD_OBITOS,
    m.SAI_TRANSFPARA AS QTD_TRANSFER
FROM OBITOS o
JOIN MOVIMENTACAO_UNIDADES m ON o.MES = m.MES AND o.ANO = m.ANO AND o.LOCAL = m.LOCAL
GROUP BY
    o.MES,
    CASE
        WHEN o.MES = 1 THEN 'Jan'
        WHEN o.MES = 2 THEN 'Fev'
        WHEN o.MES = 3 THEN 'Mar'
        WHEN o.MES = 4 THEN 'Abr'
        WHEN o.MES = 5 THEN 'Mai'
        WHEN o.MES = 6 THEN 'Jun'
        WHEN o.MES = 7 THEN 'Jul'
        WHEN o.MES = 8 THEN 'Ago'
        WHEN o.MES = 9 THEN 'Set'
        WHEN o.MES = 10 THEN 'Out'
        WHEN o.MES = 11 THEN 'Nov'
        WHEN o.MES = 11 THEN 'Dez'
    END,
    o.ULTIMO_OBITO,
    o.ANO,
    m.SAI_TRANSFPARA,
    o.LOCAL
ORDER BY
    o.MES,
    o.ANO,
    m.SAI_TRANSFPARA,
    o.LOCAL
;

/* ******************************************************************************************** */

 --- ENTRADAS EM TRANSFERENCIA
SELECT
    EXTRACT(MONTH FROM mov_int.DT_MOV_INT) AS MES,
    EXTRACT(YEAR FROM mov_int.DT_MOV_INT) AS ANO,
    unid_int.cd_unid_int       AS cd_unid_int,
    unid_int.ds_unid_int       AS ds_unidade,
    COUNT(*)                   AS ent_transf
FROM
dbamv.mov_int
JOIN dbamv.leito ON mov_int.cd_leito = leito.cd_leito
JOIN dbamv.leito leito1 ON mov_int.cd_leito_anterior = leito1.cd_leito
JOIN dbamv.unid_int unid_int ON leito.cd_unid_int = unid_int.cd_unid_int
JOIN dbamv.unid_int unid_int1 ON leito1.cd_unid_int = unid_int1.cd_unid_int
JOIN dbamv.atendime ON atendime.cd_atendimento = mov_int.cd_atendimento
WHERE
    mov_int.tp_mov = 'O'
    AND unid_int.cd_unid_int <> unid_int1.cd_unid_int
    AND atendime.tp_atendimento IN ('I')
    AND EXTRACT(YEAR FROM mov_int.DT_MOV_INT) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY
    unid_int.cd_unid_int,
    unid_int.ds_unid_int,
    EXTRACT(MONTH FROM mov_int.DT_MOV_INT),
    EXTRACT(YEAR FROM mov_int.DT_MOV_INT)
ORDER BY
    EXTRACT(MONTH FROM mov_int.DT_MOV_INT),
    unid_int.cd_unid_int
 ;


-- SAIDA EM TRANSFERENCIA
-- RELATORIO 'R_MOV_UNID_INT'
SELECT
    EXTRACT(MONTH FROM mi.DT_MOV_INT) AS MES,
    EXTRACT(YEAR FROM mi.DT_MOV_INT) AS ANO,
    ui.CD_UNID_INT       AS CD_UNID_INT,
    ui.DS_UNID_INT       AS DS_UNIDADE,
    COUNT(*)             AS SAI_TRANSFPARA
FROM
DBAMV.MOV_INT mi
JOIN DBAMV.LEITO l ON mi.CD_LEITO_ANTERIOR = l.CD_LEITO
JOIN DBAMV.LEITO l1 ON mi.CD_LEITO = l1.CD_LEITO
JOIN DBAMV.UNID_INT ui ON l.CD_UNID_INT = ui.CD_UNID_INT
JOIN DBAMV.UNID_INT ui1 ON l1.CD_UNID_INT = ui1.CD_UNID_INT
JOIN DBAMV.ATENDIME a ON a.CD_ATENDIMENTO = mi.CD_ATENDIMENTO
WHERE
    mi.TP_MOV = 'O'
    AND ui.CD_UNID_INT <> ui1.CD_UNID_INT
    AND a.TP_ATENDIMENTO IN ('I')
    AND EXTRACT(YEAR FROM mi.DT_MOV_INT) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY
    ui.CD_UNID_INT,
    ui.DS_UNID_INT,
    EXTRACT(MONTH FROM mi.DT_MOV_INT),
    EXTRACT(YEAR FROM mi.DT_MOV_INT)
ORDER BY
    EXTRACT(MONTH FROM mi.DT_MOV_INT),
    ui.CD_UNID_INT
;


 --- SAIDAS COM OBITOS
SELECT
    unid_int.cd_unid_int        AS cd_unid_int,
    unid_int.ds_unid_int        AS ds_unidade,
    COUNT(*)                    AS sai_obitos
FROM
    dbamv.atendime
JOIN dbamv.leito ON leito.cd_leito = atendime.cd_leito
JOIN dbamv.unid_int ON leito.cd_unid_int = unid_int.cd_unid_int
JOIN dbamv.mot_alt ON mot_alt.cd_mot_alt = atendime.cd_mot_alt
WHERE
    mot_alt.tp_mot_alta = 'O'
    AND atendime.tp_atendimento = 'I'
    AND unid_int.cd_unid_int = unid_int.cd_unid_int
    AND EXTRACT(YEAR FROM atendime.dt_alta) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY
    unid_int.cd_unid_int,
    unid_int.ds_unid_int
 ;

/* ******************************************************************************************** */


























PACIENTE_DIA
    AS (
        SELECT
            CASE
                WHEN ai.CD_LEITO = 1 THEN 'POSTO 1'
                WHEN ai.CD_LEITO = 3 THEN 'UTI 1'
                WHEN ai.CD_LEITO = 4 THEN 'UTI 2'
                WHEN ai.CD_LEITO = 5 THEN 'UTI 3'
                WHEN ai.CD_LEITO = 6 THEN 'UTI 4'
            END AS LOCAL,

            EXTRACT(MONTH FROM ai.DT_ALTA) AS MES ,
            EXTRACT(YEAR FROM ai.DT_ALTA) AS ANO ,
            SUM(CASE WHEN TRUNC( ai.DT_ALTA - ai.DT_ATENDIMENTO ) = 0 THEN 1 ELSE TRUNC( ai.DT_ALTA - ai.DT_ATENDIMENTO ) END ) AS PACIENTE_DIA
        FROM DBAMV.ATENDIME ai

        WHERE EXTRACT(YEAR FROM ai.DT_ALTA) = EXTRACT(YEAR FROM SYSDATE) AND ai.TP_ATENDIMENTO IN( 'I', 'U')

        GROUP BY
            CASE
                WHEN ai.CD_LEITO = 1 THEN 'POSTO 1'
                WHEN ai.CD_LEITO = 3 THEN 'UTI 1'
                WHEN ai.CD_LEITO = 4 THEN 'UTI 2'
                WHEN ai.CD_LEITO = 5 THEN 'UTI 3'
                WHEN ai.CD_LEITO = 6 THEN 'UTI 4'
            END ,
            EXTRACT(MONTH FROM ai.DT_ALTA) ,
            EXTRACT(YEAR FROM ai.DT_ALTA)
        ORDER BY
            CASE
                WHEN ai.CD_LEITO = 1 THEN 'POSTO 1'
                WHEN ai.CD_LEITO = 3 THEN 'UTI 1'
                WHEN ai.CD_LEITO = 4 THEN 'UTI 2'
                WHEN ai.CD_LEITO = 5 THEN 'UTI 3'
                WHEN ai.CD_LEITO = 6 THEN 'UTI 4'
            END ,
            EXTRACT(MONTH FROM ai.DT_ALTA) ,
            EXTRACT(YEAR FROM ai.DT_ALTA)

)
;





WITH CONTEXTO
    AS (
        SELECT DISTINCT
            ai.CD_PACIENTE,
            ai.CD_ATENDIMENTO,
            ai.DT_ATENDIMENTO,
            ai.DT_ALTA,
            ( ai.DT_ALTA - ai.DT_ATENDIMENTO ),
            CASE WHEN ( ai.DT_ALTA - ai.DT_ATENDIMENTO ) = 0 THEN 1 ELSE ( ai.DT_ALTA - ai.DT_ATENDIMENTO ) END AS PACIENTE_DIA,
            EXTRACT(MONTH FROM ai.DT_ALTA) AS MES ,
            EXTRACT(YEAR FROM ai.DT_ALTA) AS ANO ,
            TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') AS MES_ANO_INTERNACAO,
            COUNT(ai.CD_ATENDIMENTO) OVER(PARTITION BY TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') ) AS QTD_INTERNADOS
        FROM DBAMV.ATENDIME ai
        WHERE ai.TP_ATENDIMENTO = 'I'
)
SELECT * FROM CONTEXTO WHERE MES_ANO_INTERNACAO = '012025'
;





/* ************************************************************************************************************************* */


-- CRUZAMENTO DA QUERY CRIADA VS QUERY PAINEL
    -- INTERCECAO = 37
    -- (PAINEL - CHEC_ALTA) = 5
    -- (CHEC_ALTA - PAINEL)  = 1
WITH CHECK_ALTA AS (
        SELECT
            a.CD_ATENDIMENTO
            , a.DT_ATENDIMENTO
            , EXTRACT(YEAR FROM a.DT_ALTA) AS ANO
            , EXTRACT(MONTH FROM a.DT_ALTA) AS MES
            , a.HR_ATENDIMENTO
            , a.DT_ALTA
            , a.HR_ALTA
            , ma.TP_MOT_ALTA
            , a.TP_ATENDIMENTO
        FROM
            DBAMV.ATENDIME a
            LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT
        WHERE ma.TP_MOT_ALTA = 'O' AND EXTRACT(YEAR FROM a.DT_ALTA) = 2025
),
PAINEL
    AS (
        SELECT DISTINCT
            ra.CD_ATENDIMENTO
            , a.DT_ATENDIMENTO
            , EXTRACT(YEAR FROM a.DT_ALTA) AS ANO
            , EXTRACT(MONTH FROM a.DT_ALTA) AS MES
            , a.HR_ATENDIMENTO
            , a.DT_ALTA
            , a.HR_ALTA
            , mt.TP_MOT_ALTA
            , a.TP_ATENDIMENTO
            -- a.CD_PACIENTE Cod_Paciente,
            -- pa.DT_NASCIMENTO dt_nascimento,
            -- trunc((months_between(a.DT_ALTA, pa.DT_NASCIMENTO)/12)) IDADE,
            -- a.TP_ATENDIMENTO,
            -- INITCAP(pa.NM_PACIENTE) Paciente,
            -- a.CD_CID Cod_CID,
            -- INITCAP(p.NM_PRESTADOR) Medico_Alta,
            -- INITCAP(co.NM_CONVENIO) Convenio,
            -- a.SN_OBITO SN_Obito,
            -- a.SN_OBITO_INFEC SN_Obito_Infec,
            -- s.NM_SETOR Setor_Obito,
            -- a.DT_ALTA D_Alta_Atend,
            -- a.DS_OBS_ALTA Ds_Alta,
            -- INITCAP(c.DS_CID) Ds_Obito
        FROM atendime a
            LEFT JOIN PW_REGISTRO_ALTA ra ON a.CD_ATENDIMENTO = ra.CD_ATENDIMENTO
            LEFT JOIN PRESTADOR p ON ra.CD_PRESTADOR = p.CD_PRESTADOR
            LEFT JOIN PACIENTE pa ON a.CD_PACIENTE = pa.CD_PACIENTE
            LEFT JOIN CID c ON c.CD_CID = a.CD_CID_OBITO
            LEFT JOIN SETOR s ON s.CD_SETOR = a.CD_SETOR_OBITO
            LEFT JOIN CONVENIO co ON co.CD_CONVENIO = a.CD_CONVENIO
            LEFT JOIN MOT_ALT mt ON a.CD_MOT_ALT = mt.CD_MOT_ALT
        WHERE a.SN_OBITO = 'S' AND EXTRACT(YEAR FROM a.DT_ALTA) = 2025
),
CHECK_MENUS_ALTA AS (
        SELECT * FROM CHECK_ALTA --WHERE ANO = 2024
        MINUS
        SELECT * FROM PAINEL --WHERE ANO = 2024
),
ALTA_MENUS_CHECKK AS (
        SELECT * FROM PAINEL --WHERE ANO = 2024
        MINUS
        SELECT * FROM CHECK_ALTA --WHERE ANO = 2024
)
SELECT CD_ATENDIMENTO, DT_ATENDIMENTO, ANO, MES, HR_ATENDIMENTO, DT_ALTA, HR_ALTA, TP_MOT_ALTA, TP_ATENDIMENTO, CAST('CHECK' AS VARCHAR2(5)) AS ORIGEM FROM CHECK_MENUS_ALTA WHERE ANO = 2025
MINUS
SELECT CD_ATENDIMENTO, DT_ATENDIMENTO, ANO, MES, HR_ATENDIMENTO, DT_ALTA, HR_ALTA, TP_MOT_ALTA, TP_ATENDIMENTO, CAST('PAINEL' AS VARCHAR2(6)) AS ORIGEM FROM ALTA_MENUS_CHECKK WHERE ANO = 2025
;



SELECT CD_ATENDIMENTO, DT_ATENDIMENTO, ANO, MES, HR_ATENDIMENTO, DT_ALTA, HR_ALTA, TP_MOT_ALTA, TP_ATENDIMENTO  FROM CHECK_MENUS_ALTA WHERE ANO = 2025
INTERSECT
SELECT CD_ATENDIMENTO, DT_ATENDIMENTO, ANO, MES, HR_ATENDIMENTO, DT_ALTA, HR_ALTA, TP_MOT_ALTA, TP_ATENDIMENTO FROM ALTA_MENUS_CHECKK WHERE ANO = 2025
;


-- INTERSECT -> 29
SELECT * FROM PAINEL WHERE ANO = 2025
INTERSECT
SELECT * FROM CHECK_ALTA WHERE ANO = 2025
;


/* -------------------------------------------------------------------------------------------------------------------------- */


-- PADRÃO COM SUBTOTAL NAS LINHAS
SELECT
    chk.ANO,
    chk.MES,
    COUNT(*) AS QTD
FROM
    CHECK_ALTA chk
WHERE
    chk.ANO = '2024'
    AND chk.TP_MOT_ALTA = 'O'
GROUP BY
    chk.ANO,
    chk.MES
UNION ALL
SELECT
    'TOTAL_GERAL' AS ANO,
    NULL AS MES,
    SUM(COUNT(*)) OVER () AS QTD
FROM
    CHECK_ALTA chk
WHERE
    chk.ANO = '2024'
    AND chk.TP_MOT_ALTA = 'O'
ORDER BY
    ANO NULLS LAST,
    MES NULLS LAST;


/* ************************************************************************************************************************* */


-- TESTE PARA TRAZER PRESTADOR DO ÚLTIMO PROCEDIMENTO
SELECT * FROM DBAMV.ITREG_FAT if WHERE if.CD_PRESTADOR IS NULL AND if.CD_GRU_FAT = 6 ;



WITH PAINEL AS (
    SELECT
        a.CD_ATENDIMENTO Cod_Atend,
        a.CD_PACIENTE Cod_Paciente,
        pa.DT_NASCIMENTO dt_nascimento,
        trunc((months_between(a.DT_ALTA, pa.DT_NASCIMENTO)/12)) IDADE,
        a.TP_ATENDIMENTO,
        INITCAP(pa.NM_PACIENTE) Paciente,
        a.CD_CID Cod_CID,
        INITCAP(p.NM_PRESTADOR) Medico_Alta,
        INITCAP(co.NM_CONVENIO) Convenio,
        a.SN_OBITO SN_Obito,
        a.SN_OBITO_INFEC SN_Obito_Infec,
        s.NM_SETOR Setor_Obito,
        a.DT_ALTA D_Alta_Atend,
        a.DS_OBS_ALTA Ds_Alta,
        INITCAP(c.DS_CID) Ds_Obito,
        a.NR_DECLARACAO_OBITO,
        ma.TP_MOT_ALTA
    FROM DBAMV.ATENDIME a
    LEFT JOIN PRESTADOR p ON a.CD_PRESTADOR = p.CD_PRESTADOR
    LEFT JOIN PACIENTE pa ON a.CD_PACIENTE = pa.CD_PACIENTE
    LEFT JOIN CID c ON c.CD_CID = a.CD_CID_OBITO
    LEFT JOIN SETOR s ON s.CD_SETOR = a.CD_SETOR_OBITO
    LEFT JOIN CONVENIO co ON co.CD_CONVENIO = a.CD_CONVENIO
    LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT
),
ATENDIMENTO AS(
        SELECT DISTINCT CD_ATENDIMENTO FROM DBAMV.ATENDIME
),
ITEM AS (
    SELECT DISTINCT CD_REG_FAT, CD_PRESTADOR FROM DBAMV.ITREG_FAT WHERE CD_GRU_FAT = 6
),
REG AS (
    SELECT DISTINCT rf.CD_ATENDIMENTO, rf.CD_REG_FAT FROM DBAMV.REG_FAT rf
)
SELECT
    p.NM_PRESTADOR AS PRESTADOR_OBITO
    , pl.*
    -- COUNT(pl.Cod_Atend) AS QTDe
FROM ITEM i
LEFT JOIN REG r ON i.CD_REG_FAT = r.CD_REG_FAT
LEFT JOIN ATENDIMENTO a ON  r.CD_ATENDIMENTO = a.CD_ATENDIMENTO
LEFT JOIN DBAMV.PRESTADOR p ON i.CD_PRESTADOR = p.CD_PRESTADOR
LEFT JOIN PAINEL pl ON a.CD_ATENDIMENTO = pl.Cod_Atend
WHERE pl.TP_MOT_ALTA = 'O' -- OR pl.SN_OBITO = 'S'
ORDER BY pl.Cod_Paciente DESC
;


-- RETORNA OS 99 QUE APARECEM NO PAINEL
SELECT COUNT(*) FROM PAINEL pl WHERE pl.TP_MOT_ALTA = 'O' OR pl.SN_OBITO = 'S'
;


WITH PAINEL AS (
    SELECT
        a.CD_ATENDIMENTO Cod_Atend,
        a.CD_PACIENTE Cod_Paciente,
        pa.DT_NASCIMENTO dt_nascimento,
        trunc((months_between(a.DT_ALTA, pa.DT_NASCIMENTO)/12)) IDADE,
        a.TP_ATENDIMENTO,
        INITCAP(pa.NM_PACIENTE) Paciente,
        a.CD_CID Cod_CID,
        INITCAP(p.NM_PRESTADOR) Medico_Alta,
        INITCAP(co.NM_CONVENIO) Convenio,
        a.SN_OBITO SN_Obito,
        a.SN_OBITO_INFEC SN_Obito_Infec,
        s.NM_SETOR Setor_Obito,
        a.DT_ALTA D_Alta_Atend,
        a.DS_OBS_ALTA Ds_Alta,
        INITCAP(c.DS_CID) Ds_Obito,
        a.NR_DECLARACAO_OBITO,
        ma.TP_MOT_ALTA
    FROM DBAMV.ATENDIME a
    LEFT JOIN PRESTADOR p ON a.CD_PRESTADOR = p.CD_PRESTADOR
    LEFT JOIN PACIENTE pa ON a.CD_PACIENTE = pa.CD_PACIENTE
    LEFT JOIN CID c ON c.CD_CID = a.CD_CID_OBITO
    LEFT JOIN SETOR s ON s.CD_SETOR = a.CD_SETOR_OBITO
    LEFT JOIN CONVENIO co ON co.CD_CONVENIO = a.CD_CONVENIO
    LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT
),
ATENDIMENTO AS(
        SELECT DISTINCT CD_ATENDIMENTO FROM DBAMV.ATENDIME
),
ITEM AS (
    SELECT DISTINCT CD_REG_FAT, CD_PRESTADOR FROM DBAMV.ITREG_FAT WHERE CD_GRU_FAT = 6
),
REG AS (
    SELECT DISTINCT rf.CD_ATENDIMENTO, rf.CD_REG_FAT FROM DBAMV.REG_FAT rf
)
SELECT
    p.NM_PRESTADOR AS PRESTADOR_OBITO
    , pl.*
    -- COUNT(pl.Cod_Atend) AS QTDe
FROM ITEM i
LEFT JOIN REG r ON i.CD_REG_FAT = r.CD_REG_FAT
LEFT JOIN ATENDIMENTO a ON  r.CD_ATENDIMENTO = a.CD_ATENDIMENTO
LEFT JOIN DBAMV.PRESTADOR p ON i.CD_PRESTADOR = p.CD_PRESTADOR
LEFT JOIN PAINEL pl ON a.CD_ATENDIMENTO = pl.Cod_Atend
WHERE pl.TP_MOT_ALTA = 'O' -- OR pl.SN_OBITO = 'S'
ORDER BY pl.Cod_Paciente DESC
;



WITH PAINEL AS (
    SELECT
        a.CD_ATENDIMENTO CD_ATENDIMENTO,
        a.CD_PACIENTE Cod_Paciente,
        pa.DT_NASCIMENTO dt_nascimento,
        trunc((months_between(a.DT_ALTA, pa.DT_NASCIMENTO)/12)) IDADE,
        a.TP_ATENDIMENTO,
        INITCAP(pa.NM_PACIENTE) Paciente,
        a.CD_CID Cod_CID,
        INITCAP(p.NM_PRESTADOR) Medico_Alta,
        INITCAP(co.NM_CONVENIO) Convenio,
        a.SN_OBITO SN_Obito,
        a.SN_OBITO_INFEC SN_Obito_Infec,
        s.NM_SETOR Setor_Obito,
        a.DT_ALTA D_Alta_Atend,
        a.DS_OBS_ALTA Ds_Alta,
        INITCAP(c.DS_CID) Ds_Obito,
        a.NR_DECLARACAO_OBITO,
        ma.TP_MOT_ALTA
    FROM DBAMV.ATENDIME a
    LEFT JOIN PRESTADOR p ON a.CD_PRESTADOR = p.CD_PRESTADOR
    LEFT JOIN PACIENTE pa ON a.CD_PACIENTE = pa.CD_PACIENTE
    LEFT JOIN CID c ON c.CD_CID = a.CD_CID_OBITO
    LEFT JOIN SETOR s ON s.CD_SETOR = a.CD_SETOR_OBITO
    LEFT JOIN CONVENIO co ON co.CD_CONVENIO = a.CD_CONVENIO
    LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT
    WHERE ma.TP_MOT_ALTA = 'O' -- OR pl.SN_OBITO = 'S'
),
PROCEDIMENTO AS (
SELECT DISTINCT
    ca.CD_AVISO_CIRURGIA
    , ac.CD_ATENDIMENTO
    , ac.DT_REALIZACAO
    -- , ca.CD_CIRURGIA
    -- , c.DS_CIRURGIA
    , pa.CD_PRESTADOR
    , p.NM_PRESTADOR
FROM
    DBAMV.PRESTADOR_AVISO pa
LEFT JOIN DBAMV.CIRURGIA_AVISO ca ON ca.CD_CIRURGIA_AVISO = pa.CD_CIRURGIA_AVISO
LEFT JOIN DBAMV.CIRURGIA c ON ca.CD_CIRURGIA = c.CD_CIRURGIA
LEFT JOIN DBAMV.AVISO_CIRURGIA ac ON ca.CD_AVISO_CIRURGIA = ac.CD_AVISO_CIRURGIA
LEFT JOIN DBAMV.PRESTADOR p ON pa.CD_PRESTADOR = p.CD_PRESTADOR
WHERE ac.DT_REALIZACAO IS NOT NULL AND pa.SN_PRINCIPAL = 'S' AND ac.tp_situacao = 'R'
ORDER BY 1,2 DESC
)
SELECT DISTINCT pr.NM_PRESTADOR, p.* FROM PAINEL p LEFT JOIN PROCEDIMENTO pr ON p.CD_ATENDIMENTO = pr.CD_ATENDIMENTO WHERE p.SN_Obito != 'N'
;



-- QUERY PAINEL MV
SELECT PRESTADOR.NM_PRESTADOR MEDICO
     , COUNT(*) Qtde
  FROM DBAMV.AVISO_CIRURGIA
     , DBAMV.CIRURGIA_AVISO
     , DBAMV.PRESTADOR
     , dbamv.prestador_aviso
 WHERE aviso_cirurgia.cd_aviso_cirurgia = cirurgia_aviso.cd_aviso_cirurgia
   AND aviso_cirurgia.cd_aviso_cirurgia = prestador_aviso.cd_aviso_cirurgia
   AND cirurgia_aviso.cd_cirurgia_aviso = prestador_aviso.cd_cirurgia_aviso
   AND prestador.cd_prestador           = prestador_aviso.cd_prestador
   AND aviso_cirurgia.tp_situacao       = 'R'
   AND prestador_aviso.SN_PRINCIPAL     = 'S'
--    AND AVISO_CIRURGIA.DT_REALIZACAO BETWEEN  (SYSDATE - 30)  AND to_date(SYSDATE ,'dd/mm/yyyy')+.99999
--    AND aviso_cirurgia.cd_multi_empresa  IN ($pgmvCdEmpresa$)
 GROUP BY prestador.nm_prestador
 ORDER BY qtde DESC
;


