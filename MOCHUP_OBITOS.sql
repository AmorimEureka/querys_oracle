


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
LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT ;
WHERE EXTRACT(YEAR FROM a.DT_ATENDIMENTO)= 2024 AND ma.TP_MOT_ALTA = 'O' ;

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
        WHERE ma.TP_MOT_ALTA = 'O'
),
PAINEL 
    AS (
        SELECT 
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
        WHERE a.SN_OBITO = 'S'
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
SELECT CD_ATENDIMENTO, DT_ATENDIMENTO, ANO, MES, HR_ATENDIMENTO, DT_ALTA, HR_ALTA, TP_MOT_ALTA, TP_ATENDIMENTO, CAST('CHECK' AS VARCHAR2(5)) AS ORIGEM FROM CHECK_MENUS_ALTA WHERE ANO = 2024
MINUS
SELECT CD_ATENDIMENTO, DT_ATENDIMENTO, ANO, MES, HR_ATENDIMENTO, DT_ALTA, HR_ALTA, TP_MOT_ALTA, TP_ATENDIMENTO, CAST('PAINEL' AS VARCHAR2(6)) AS ORIGEM FROM ALTA_MENUS_CHECKK WHERE ANO = 2024 ;



SELECT CD_ATENDIMENTO, DT_ATENDIMENTO, ANO, MES, HR_ATENDIMENTO, DT_ALTA, HR_ALTA, TP_MOT_ALTA, TP_ATENDIMENTO  FROM CHECK_MENUS_ALTA WHERE ANO = 2023
INTERSECT
SELECT CD_ATENDIMENTO, DT_ATENDIMENTO, ANO, MES, HR_ATENDIMENTO, DT_ALTA, HR_ALTA, TP_MOT_ALTA, TP_ATENDIMENTO FROM ALTA_MENUS_CHECKK WHERE ANO = 2023 ;


-- INTERSECT -> 29
SELECT * FROM PAINEL WHERE ANO = 2023
INTERSECT
SELECT * FROM CHECK_ALTA WHERE ANO = 2023 ;


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


