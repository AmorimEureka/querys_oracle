

/* ************************************************************************************************************************* */



-- QUERY OBTITOS - PAINEL HPC-DIRETORIA-Altas e Óbitos
-- AO FILTRAR OS CAMPOS:
--      - a.SN_OBITO     = 'S'  -> RETORNA 'TP_ATENDIMENTO' IN('I', 'U')
--      - ma.TP_MOT_ALTA = 'O'  -> RETORNA APENAS 'TP_ATENDIMENTO' = 'I'
-- AO FILTRAR O CAMPO a.DT_ALTA:
--      - A QUANTIDADE DE PACIENTES MOVIMENTADOS NA QUERY BATE COM O
--      - RELATORIO 'M_CONTR_DECLARA_OBITO'
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
-- TAXA MORTALIDADE
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
/* ********************************** QUERY's DE MOVIMENTACAO ********************************* */



-- SAIDA TRANSFERENCIA DAS UNIDADES
-- VALIDADO C/ RELATORIO 'R_MOV_UNID_INT'
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



 --- ENTRADAS TRANSFERENCIA DAS UNIDADES
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


 --- SAIDAS COM OBITOS DAS UNIDADES
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
/* ******************************************************************************************** */


-- QUERY PARA DASHBOARD KPI GESTAO A VISTA
-- TEMPO MEDIO PERMANENCIA UTI
WITH PACIENTE_DIA
    AS (
        SELECT
            EXTRACT(MONTH FROM ai.DT_ALTA) AS MES ,
            EXTRACT(YEAR FROM ai.DT_ALTA) AS ANO ,
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END AS LOCAL,
            SUM( TRUNC( ai.DT_ALTA - ai.DT_ATENDIMENTO ) ) AS QTD_PACIENTE_DIA
            -- SUM(CASE WHEN TRUNC( ai.DT_ALTA - ai.DT_ATENDIMENTO ) = 0 THEN 1 ELSE TRUNC( ai.DT_ALTA - ai.DT_ATENDIMENTO ) END ) AS QTD_PACIENTE_DIA

        FROM DBAMV.ATENDIME ai
        JOIN DBAMV.LEITO l ON ai.CD_LEITO = l.CD_LEITO
        JOIN DBAMV.UNID_INT ui ON l.CD_UNID_INT = ui.CD_UNID_INT
        LEFT JOIN DBAMV.PACIENTE p ON ai.CD_PACIENTE = p.CD_PACIENTE

        WHERE EXTRACT(YEAR FROM ai.DT_ALTA) = EXTRACT(YEAR FROM SYSDATE) AND
              ai.TP_ATENDIMENTO IN( 'I', 'U') AND
              p.NM_PACIENTE NOT LIKE '%TEST%'
        GROUP BY
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END,
            EXTRACT(MONTH FROM ai.DT_ALTA) ,
            EXTRACT(YEAR FROM ai.DT_ALTA)
        ORDER BY
            EXTRACT(MONTH FROM ai.DT_ALTA) ,
            EXTRACT(YEAR FROM ai.DT_ALTA)

),
PACIENTE_ALTAS
    AS (
        SELECT

            EXTRACT(MONTH FROM ai.DT_ALTA) AS MES,
            EXTRACT(YEAR FROM ai.DT_ALTA) AS ANO,
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END AS LOCAL,
            COUNT(*) AS QTD_ALTAS

        FROM DBAMV.ATENDIME ai
        JOIN DBAMV.LEITO l ON ai.CD_LEITO = l.CD_LEITO
        JOIN DBAMV.UNID_INT ui ON l.CD_UNID_INT = ui.CD_UNID_INT
        LEFT JOIN DBAMV.PACIENTE p ON ai.CD_PACIENTE = p.CD_PACIENTE
        WHERE ai.DT_ALTA IS NOT NULL AND
              EXTRACT(YEAR FROM ai.dt_alta) = EXTRACT(YEAR FROM SYSDATE) AND
              p.NM_PACIENTE NOT LIKE '%TEST%'
        GROUP BY
            EXTRACT(MONTH FROM ai.DT_ALTA),
            EXTRACT(YEAR FROM ai.DT_ALTA),
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END
        ORDER BY EXTRACT(MONTH FROM ai.DT_ALTA)
),
MOVIMENTACAO_INTERNAS
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
        LEFT JOIN DBAMV.PACIENTE p ON a.CD_PACIENTE = p.CD_PACIENTE
        WHERE
            ui.CD_UNID_INT <> ui1.CD_UNID_INT AND
            a.TP_ATENDIMENTO IN ('I') AND
            EXTRACT(YEAR FROM mi.DT_MOV_INT) = EXTRACT(YEAR FROM SYSDATE) AND
            p.NM_PACIENTE NOT LIKE '%TEST%'
        GROUP BY
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END,
            EXTRACT(MONTH FROM mi.DT_MOV_INT),
            EXTRACT(YEAR FROM mi.DT_MOV_INT)

),
TREATS
    AS (
        SELECT
            pd.MES,
            pd.ANO,
            pd.LOCAL,
            (pa.QTD_ALTAS + SAI_TRANSFPARA ) AS QTD_PACIENTE_DIA,
            pa.QTD_ALTAS,
            TRUNC( (pa.QTD_ALTAS + SAI_TRANSFPARA ) / pa.QTD_ALTAS) AS TX

        FROM PACIENTE_DIA pd
        JOIN PACIENTE_ALTAS pa ON pd.MES = pa.MES AND pd.ANO = pa.ANO AND pd.LOCAL = pa.LOCAL
        JOIN MOVIMENTACAO_INTERNAS mi ON pd.MES = mi.MES AND pd.ANO = mi.ANO AND pd.LOCAL = mi.LOCAL
)
SELECT * FROM TREATS ORDER BY MES, LOCAL
;



/* ******************************************************************************************** */
/* ******************************************************************************************** */

-- OBITO COM TP_ATENDIMENTO = 'A'
SELECT
    *
    -- TP_ATENDIMENTO,
    -- CD_SETOR_OBITO,
    -- COUNT(*)
FROM DBAMV.ATENDIME
WHERE TP_ATENDIMENTO = 'A' AND CD_SETOR_OBITO = 56
-- GROUP BY TP_ATENDIMENTO, CD_SETOR_OBITO
;


/* ******************************************************************************************** */
/* ******************************************************************************************** */