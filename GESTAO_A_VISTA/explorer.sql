-- #########################################################################################################




/* *******************************************************************************************
 *   QUERY OBITOS - PAINEL HPC-DIRETORIA-Altas e Óbitos
 *   AO FILTRAR OS CAMPOS:
 *     -  a.SN_OBITO    = 'S'  -> RETORNA TODOS OBITOS OCORRIDOS DE QUALQUER 'TP_ATENDIMENTO'
 *     - ma.TP_MOT_ALTA = 'O'  -> RETORNA APENAS OBITOS COM 'TP_ATENDIMENTO' = 'I'

 *   AO FILTRAR PERIODO PELO CAMPO a.DT_ALTA:
 *     - A QUANTIDADE DE PACIENTES MOVIMENTADOS NA QUERY BATE COM O
 *     - RELATORIO 'M_CONTR_DECLARA_OBITO'
 * **************************************************************************************** */
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

-- #########################################################################################################




/* *******************************************************************************************
 *   QUERY PARA DASHBOARD KPI GESTAO A VISTA
 *   CALCULO TAXA MORTALIDADE
 *   RAZAO ENTRE:
 *      N OBITOS CUJO TEMPO DE INTERNACAO DO PERIODO SEJA >= 24H
 *      N DE SAIDAS INTERNAS (MOVIMENTACOES INTERNAS) + N DE SAIDAS EXTERNAS (ALTAS e OBITOS)
 *
 *
* **************************************************************************************** */
-- CONSOLIDADO EM querys.sql ✅
WITH OBITOS AS (
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
        MAX(a.DT_ALTA) OVER(
            PARTITION BY
                CASE
                    WHEN s.NM_SETOR LIKE '%POSTO%' THEN 'POSTO'
                    ELSE s.NM_SETOR
                END,
                EXTRACT(MONTH FROM a.DT_ALTA),
                EXTRACT(YEAR  FROM a.DT_ALTA)
        ) AS ULTIMO_OBITO,
        EXTRACT(MONTH FROM a.DT_ALTA) AS MES ,
        EXTRACT(YEAR  FROM a.DT_ALTA) AS ANO ,
        ma.TP_MOT_ALTA
    FROM DBAMV.ATENDIME a
    LEFT JOIN SETOR s        ON s.CD_SETOR    = a.CD_SETOR_OBITO
    LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT
    WHERE
        a.SN_OBITO = 'S'
        AND a.DT_ALTA >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)  -- início da janela (13 meses atrás)
        AND a.DT_ALTA <  ADD_MONTHS(TRUNC(SYSDATE, 'MM'),  1)   -- fim da janela (início do próximo mês)
),
MOVIMENTACAO_UNIDADES AS (
    SELECT
        EXTRACT(MONTH FROM mi.DT_MOV_INT) AS MES,
        EXTRACT(YEAR  FROM mi.DT_MOV_INT) AS ANO,
        CASE
            WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                'POSTO'
            ELSE ui.DS_UNID_INT
        END AS LOCAL,
        COUNT(*) AS SAI_TRANSFPARA
    FROM DBAMV.MOV_INT mi
    JOIN DBAMV.LEITO     l   ON mi.CD_LEITO_ANTERIOR = l.CD_LEITO
    JOIN DBAMV.LEITO     l1  ON mi.CD_LEITO          = l1.CD_LEITO
    JOIN DBAMV.UNID_INT  ui  ON l.CD_UNID_INT        = ui.CD_UNID_INT
    JOIN DBAMV.UNID_INT  ui1 ON l1.CD_UNID_INT       = ui1.CD_UNID_INT
    JOIN DBAMV.ATENDIME  a   ON a.CD_ATENDIMENTO     = mi.CD_ATENDIMENTO
    WHERE
        mi.TP_MOV = 'O'
        AND ui.CD_UNID_INT <> ui1.CD_UNID_INT
        AND a.TP_ATENDIMENTO IN ('I')
        AND mi.DT_MOV_INT >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)  -- últimos 13 meses
        AND mi.DT_MOV_INT <  ADD_MONTHS(TRUNC(SYSDATE, 'MM'),  1)
    GROUP BY
        CASE
            WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                'POSTO'
            ELSE ui.DS_UNID_INT
        END,
        EXTRACT(MONTH FROM mi.DT_MOV_INT),
        EXTRACT(YEAR  FROM mi.DT_MOV_INT)
)
SELECT
    o.ULTIMO_OBITO,
    o.LOCAL,
    'OBITOS' AS TIPO,
    m.SAI_TRANSFPARA AS QTD_TRANSFER,
    COUNT(o.CD_ATENDIMENTO) AS QTD_OBITOS
FROM OBITOS o
JOIN MOVIMENTACAO_UNIDADES m  ON o.MES = m.MES AND o.ANO = m.ANO AND o.LOCAL = m.LOCAL
WHERE o.LOCAL = '" & Unidade & "'
GROUP BY
    o.ULTIMO_OBITO,
    o.LOCAL,
    m.SAI_TRANSFPARA
ORDER BY
    o.LOCAL
;


-- ---------------------------------------------------------------------------------------------

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

-- ---------------------------------------------------------------------------------------------

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




 SELECT
        CD_UNID_INT
      , DS_UNIDADE
      , sum(PAC_INT_00H)    AS INTERNADOS
      , sum(ENT_INTERNADOS) AS INTERNACOES
      , sum(ENT_TRANSF)     AS TRANSF_ENTRADAS
      , sum(SAI_ALTAS)      AS ALTAS
      , sum(SAI_TRANSFPARA) AS TRANSF_SAIDAS
      , sum(SAI_OBITOS)     AS OBITOS
      , sum(SAI_OBITOS48)   AS OBITOS_48H
      , sum(SAI_OBITOS24)   AS OBITOS_24H
      , sum(HOSP_DIA)       AS HOSP_DIA
      , sum(OBITO_DIA)      AS OBITO_DIA
      , sum(PAC_INT_00H)+sum(ENT_INTERNADOS)+sum(ENT_TRANSF)-sum(SAI_ALTAS)-sum(SAI_TRANSFPARA)-sum(SAI_OBITOS) AS PAC_DIA
   FROM (
            SELECT
            CONTADOR.DATA  AS DATA_UNID,
            UNID_INT.CD_UNID_INT  AS CD_UNID_INT,
            UNID_INT.DS_UNID_INT  AS DS_UNIDADE,
            COUNT(*)              AS PAC_INT_00H,
            0                     AS ENT_INTERNADOS,
            0                     AS ENT_TRANSF,
            0                     AS SAI_ALTAS,
            0                     AS SAI_TRANSFPARA,
            0                     AS SAI_OBITOS,
            0                     AS SAI_OBITOS48,
            0                     AS SAI_OBITOS24,
            0                     AS HOSP_DIA,
            0                     AS OBITO_DIA
            From
            DBAMV.MOV_INT
            ,DBAMV.UNID_INT
            ,DBAMV.LEITO
            ,DBAMV.ATENDIME
            ,DBAMV.CONVENIO
            ,( SELECT trunc ((TO_DATE ( Nvl(NULL,To_Char(SYSDATE,'dd/mm/yyyy')), 'dd/mm/yyyy' ) - 1 ) + rownum ) DATA
                FROM dbamv.cid
                WHERE trunc ((TO_DATE ( Nvl(NULL,To_Char(SYSDATE,'dd/mm/yyyy')), 'dd/mm/yyyy' ) - 1 ) + rownum ) <= trunc ( TO_DATE ( Nvl(NULL,To_Char(SYSDATE,'dd/mm/yyyy')), 'dd/mm/yyyy' )) ) CONTADOR

            WHERE Trunc(DT_MOV_INT) <= CONTADOR.DATA - 1
            And  TRUNC(NVL(DT_LIB_MOV, SYSDATE)) > CONTADOR.DATA -  1
            And  TP_MOV IN('O', 'I')
            And  LEITO.CD_UNID_INT = UNID_INT.CD_UNID_INT
            And  MOV_INT.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO
            And  ATENDIME.TP_ATENDIMENTO IN ('I')
            And  MOV_INT.CD_LEITO = LEITO.CD_LEITO
            And  ATENDIME.CD_CONVENIO = CONVENIO.CD_CONVENIO
            AND  Unid_Int.Cd_Unid_Int = Nvl( 3, Unid_Int.Cd_Unid_Int)
            Group BY
            CONTADOR.DATA,
 UNID_INT.CD_UNID_INT,
 UNID_INT.DS_UNID_INT
   )
 GROUP BY
        CD_UNID_INT,
        DS_UNIDADE
 ;


-- #########################################################################################################


/* *******************************************************************************************
 *
 * QUERY PARA DASHBOARD KPI GESTAO A VISTA
 * TEMPO MEDIO DE PERMANENCIA NAS UTI's
 *
* **************************************************************************************** */

-- CONSOLIDADO EM querys.sql ✅
WITH UNIDADE_LEITOS
    AS (
        SELECT
            l.CD_LEITO,
            l.DS_LEITO,
            ui.CD_UNID_INT,
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END AS LOCAL
            /*+ MATERIALIZE */
        FROM DBAMV.LEITO l
        JOIN DBAMV.UNID_INT ui ON l.CD_UNID_INT = ui.CD_UNID_INT
),
ATENDIMENTO
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            p.CD_PACIENTE,
            a.CD_LEITO,

            CASE
                WHEN a.DT_ALTA IS NOT NULL AND TRUNC(a.DT_ALTA - a.DT_ATENDIMENTO ) = 0 THEN
                    'HOSPITAL-DIA'
                ELSE
                    'NORMAL'
            END AS CLASSIFICACAO,

            EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES ,
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) AS ANO ,

            TO_CHAR(a.DT_ATENDIMENTO, 'YYYYMM') AS ANO_MES,

            CASE
                WHEN a.DT_ATENDIMENTO IS NOT NULL AND a.HR_ATENDIMENTO IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ATENDIMENTO, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ATENDIMENTO, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ATENDIMENTO,

            a.TP_ATENDIMENTO,

            a.DT_ALTA AS DT_ALTA_SYS,

            CASE
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NULL THEN
                    TO_DATE(TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
                WHEN a.DT_ALTA IS NULL AND EXTRACT(MONTH FROM a.DT_ATENDIMENTO) <> EXTRACT(MONTH FROM SYSDATE) THEN
                    TO_DATE(TO_CHAR(LAST_DAY(a.DT_ATENDIMENTO), 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
                ELSE
                    SYSDATE
            END AS DH_ALTA
            /*+ MATERIALIZE */
        FROM DBAMV.ATENDIME a
        LEFT JOIN DBAMV.PACIENTE p ON a.CD_PACIENTE = p.CD_PACIENTE
        WHERE
            p.NM_PACIENTE NOT LIKE '%TEST%'

),
MOVIMENTACAO
    AS (
        SELECT -- MOVIMENTACAO DE INTERNACOES
            mi.CD_ATENDIMENTO,
            mi.CD_LEITO,
            EXTRACT(YEAR FROM mi.Dt_Mov_Int) AS ANO,
            EXTRACT(MONTH FROM mi.Dt_Mov_Int) AS MES,
            SUBSTR(TO_CHAR(mi.Dt_Mov_Int, 'FMMONTH', 'NLS_DATE_LANGUAGE=PORTUGUESE'), 1, 1)  AS NOME_MES,
            uL.LOCAL,
            COUNT(*) AS QTD_MOV
            /*+ MATERIALIZE */
        FROM DBAMV.MOV_INT mi
        JOIN UNIDADE_LEITOS ul ON mi.CD_LEITO = ul.CD_LEITO
        WHERE
            mi.TP_MOV IN ('I')
            -- AND ul.CD_UNID_INT = 3
        GROUP BY
            mi.CD_ATENDIMENTO,
            mi.CD_LEITO,
            EXTRACT(YEAR FROM mi.Dt_Mov_Int),
            EXTRACT(MONTH FROM mi.Dt_Mov_Int),
            SUBSTR(TO_CHAR(mi.Dt_Mov_Int, 'FMMONTH', 'NLS_DATE_LANGUAGE=PORTUGUESE'), 1, 1) ,
            ul.LOCAL

        UNION ALL

        SELECT -- MOVIMENTACAO - TRANSFERENCIA PARA [CONTEM TRANSF EXTERNAS | INTERNAS ]
            mi.CD_ATENDIMENTO,
            mi.CD_LEITO,
            EXTRACT(YEAR FROM mi.Dt_Mov_Int) AS ANO,
            EXTRACT(MONTH FROM mi.Dt_Mov_Int) AS MES,
            SUBSTR(TO_CHAR(mi.Dt_Mov_Int, 'FMMONTH', 'NLS_DATE_LANGUAGE=PORTUGUESE'), 1, 1)  AS NOME_MES,
            uL.LOCAL,
            COUNT(*) AS QTD_MOV
            /*+ MATERIALIZE */
        FROM DBAMV.MOV_INT mi
        JOIN UNIDADE_LEITOS ul ON mi.CD_LEITO_ANTERIOR = ul.CD_LEITO
        JOIN UNIDADE_LEITOS ul1 ON mi.CD_LEITO = ul1.CD_LEITO AND ul.CD_UNID_INT != ul1.CD_UNID_INT
        WHERE
            mi.TP_MOV IN ('O')
            -- AND ul.CD_UNID_INT = 3
        GROUP BY
            mi.CD_ATENDIMENTO,
            mi.CD_LEITO,
            EXTRACT(YEAR FROM mi.Dt_Mov_Int),
            EXTRACT(MONTH FROM mi.Dt_Mov_Int),
            SUBSTR(TO_CHAR(mi.Dt_Mov_Int, 'FMMONTH', 'NLS_DATE_LANGUAGE=PORTUGUESE'), 1, 1),
            ul.LOCAL
),
MEDIANA
    AS (
        SELECT
            a.MES,
            a.ANO,
            ul.LOCAL,

            MEDIAN(TO_NUMBER(DBAMV.fn_idade_paciente(a.CD_PACIENTE, NULL))) AS MEDIANA_IDADE

        FROM ATENDIMENTO a
        JOIN UNIDADE_LEITOS ul ON a.CD_LEITO = ul.CD_LEITO
        GROUP BY
            a.MES,
            a.ANO,
            ul.LOCAL
        ORDER BY
            a.MES,
            a.ANO,
            ul.LOCAL
),
PACIENTE_DIA
    AS (
        SELECT
            a.MES,
            a.ANO,
            a.ANO_MES,
            ul.LOCAL,

            SUM(
                CASE
                    WHEN a.DH_ALTA IS NOT NULL AND a.DH_ATENDIMENTO IS NOT NULL THEN
                        CASE
                            WHEN TRUNC(a.DH_ALTA) - TRUNC(a.DH_ATENDIMENTO) > 0 THEN
                                TRUNC(a.DH_ALTA) - TRUNC(a.DH_ATENDIMENTO)
                            ELSE
                                1
                        END
                    WHEN a.DH_ALTA IS NULL AND a.DH_ATENDIMENTO IS NOT NULL THEN
                        TRUNC(SYSDATE) - TRUNC(a.DH_ATENDIMENTO)
                    ELSE
                        1
                END
             ) AS QTD_PACIENTE_DIA

        FROM ATENDIMENTO a
        JOIN UNIDADE_LEITOS ul ON a.CD_LEITO = ul.CD_LEITO
        GROUP BY
            a.MES,
            a.ANO,
            a.ANO_MES,
            ul.LOCAL
        ORDER BY
            a.MES,
            a.ANO,
            ul.LOCAL
),
PACIENTE_ALTAS
    AS (
        SELECT
            EXTRACT(MONTH FROM a.DT_ALTA_SYS) AS MES,
            EXTRACT(YEAR FROM a.DT_ALTA_SYS) AS ANO,
            ul.LOCAL,
            COUNT(*) AS QTD_ALTAS

        FROM ATENDIMENTO a
        JOIN UNIDADE_LEITOS ul ON a.CD_LEITO = ul.CD_LEITO
        WHERE
            a.DT_ALTA_SYS IS NOT NULL AND
            EXTRACT(YEAR FROM a.DT_ALTA_SYS) = EXTRACT(YEAR FROM SYSDATE)
        GROUP BY
            EXTRACT(MONTH FROM a.DT_ALTA_SYS),
            EXTRACT(YEAR FROM a.DT_ALTA_SYS),
            ul.LOCAL
        ORDER BY
            EXTRACT(MONTH FROM a.DT_ALTA_SYS),
            EXTRACT(YEAR FROM a.DT_ALTA_SYS),
            ul.LOCAL
),
MOVI_INTERNA
    AS (
        SELECT
            m.MES,
            m.NOME_MES,
            m.ANO,
            m.LOCAL,
            SUM(m.QTD_MOV) AS QTD_MOV
        FROM MOVIMENTACAO m
        GROUP BY
            m.MES,
            m.NOME_MES,
            m.ANO,
            m.LOCAL
        ORDER BY
            m.MES
)
SELECT DISTINCT
    pd.MES,
    mi.NOME_MES,
    pd.ANO,
    pd.ANO_MES,
    pd.LOCAL,
    m.MEDIANA_IDADE,

    pd.QTD_PACIENTE_DIA,
    mi.QTD_MOV,
    COALESCE(pa.QTD_ALTAS, 0) AS QTD_ALTAS,

    CASE
        WHEN TRUNC( (pd.QTD_PACIENTE_DIA / COALESCE( (mi.QTD_MOV + COALESCE(pa.QTD_ALTAS, 0)), 1)) * 24 ) < 1 THEN
            '< 1'
        ELSE
            TO_CHAR(TRUNC( (pd.QTD_PACIENTE_DIA / COALESCE( (mi.QTD_MOV + COALESCE(pa.QTD_ALTAS, 0)), 1)) * 24 ))
    END AS CLASS_TEMPO_MED,

        CASE
            WHEN ROUND( (pd.QTD_PACIENTE_DIA / COALESCE( (mi.QTD_MOV + COALESCE(pa.QTD_ALTAS, 0)), 1)) * 24, 2 ) < 1 THEN
                1
            ELSE
                TRUNC( (pd.QTD_PACIENTE_DIA / COALESCE( (mi.QTD_MOV + COALESCE(pa.QTD_ALTAS, 0)), 1)) * 24 )
        END AS TEMPO_MEDIO,

        CASE
            WHEN TRUNC( (pd.QTD_PACIENTE_DIA / COALESCE( (mi.QTD_MOV + COALESCE(pa.QTD_ALTAS, 0)), 1)) * 24 ) < 1 THEN
                ROUND( (pd.QTD_PACIENTE_DIA / COALESCE( (mi.QTD_MOV + COALESCE(pa.QTD_ALTAS, 0)), 1)) * 24, 2 )
            ELSE
                ROUND( (pd.QTD_PACIENTE_DIA / COALESCE( (mi.QTD_MOV + COALESCE(pa.QTD_ALTAS, 0)), 1)) * 24, 2 )
        END AS TEMPO_MEDIO_REAL

FROM PACIENTE_DIA pd
LEFT JOIN PACIENTE_ALTAS pa ON pd.MES = pa.MES AND pd.ANO = pa.ANO AND pd.LOCAL = pa.LOCAL
JOIN MOVI_INTERNA mi ON pd.MES = mi.MES AND pd.ANO = mi.ANO AND pd.LOCAL = mi.LOCAL
JOIN MEDIANA m ON pd.MES = m.MES AND pd.ANO = m.ANO AND pd.LOCAL = m.LOCAL
WHERE pd.LOCAL = 'UTI 1' AND
      TO_DATE(pd.ANO || LPAD(pd.MES, 2, '0'), 'YYYYMM') BETWEEN
      ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -13) AND TRUNC(SYSDATE, 'MM')
ORDER BY
    pd.MES,
    pd.LOCAL
;





/* ******************************************************************************************** */
/* ******************************************************************************************** */


-- QUERY PARA DASHBOARD KPI GESTAO A VISTA
-- QTD e TEMPO MEDIO DE ENTUBACAO


-- ANALISE:
-- PW_DOCUMENTO_CLINICO: Armazena dados basicos sobre todos os documentos gerados atraves do MVPEP ou de sistemas que geram
-- os mesmos documentos do MVPEP, esta tabela é populada e atualizada atraves de triggers nas tabelas
-- que representam os documentos cli­nicos, ex.: PRE_MED, RECEITA, AFERICAO, etc.
--      TABELA 'PW_DOCUMENTO_CLINICO':
--          - CD_ATENDIMENTO
--          - CD_PRESTADOR
--          - DH_CRIACAO | DH_FECHAMENTO | DH_REFERENCIA | DH_DOCUMENTO

-- PW_EDITOR_CLINICO: Tabela que armazena a associação do documento clinico com o novo editor

-- EDITOR_DOCUMENTO:Tabela para armazenar os documento do editor

-- EDITOR_REGISTRO_CAMPO: Tabela para armazenar as respostas de cada campo
--      O CAMPO 'LO_VALOR' ARMAZENA OS VALORES DOS CAMPOS PREENCHIDOS NO DOCUMENTO


SELECT
    erc.*
FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
INNER JOIN DBAMV.PW_EDITOR_CLINICO pec      ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
INNER JOIN DBAMV.PW_TIPO_DOCUMENTO ptd      ON pdc.CD_TIPO_DOCUMENTO = ptd.CD_TIPO_DOCUMENTO
LEFT JOIN  DBAMV.EDITOR_REGISTRO_CAMPO erc  ON erc.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
LEFT JOIN  DBAMV.EDITOR_DOCUMENTO doc       ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
LEFT JOIN  DBAMV.EDITOR_CAMPO eca           ON eca.CD_CAMPO = erc.CD_CAMPO
INNER JOIN DBAMV.ATENDIME a                 ON pdc.CD_ATENDIMENTO = a.CD_ATENDIMENTO
WHERE pdc.CD_ATENDIMENTO = 248529 AND
      ptd.CD_TIPO_DOCUMENTO NOT IN (36, 44) AND
	  doc.CD_DOCUMENTO IN ('935')
;

-- PROTOCOLOS COM TP_STATUS = 'ABERTO' e PACIENTES COM ALTA:
-- * ESSES PROTOCOLOS APÓS PACIENTE RECEBER ALTA NAO FICAM NO HISTORICO DO PEP

-- EM 2025
--      CD_ATENDIMENTO = 241034 - CICERA MOREIRA ALEXANDRE PERES  -  SEM CONSELHO-CE: 1093565
--      CD_ATENDIMENTO = 203340 - MARIA LINDONETE ALVES - CREFITO-CE: 277960
--      CD_ATENDIMENTO = 184142 - MARIA LINDONETE ALVES - CREFITO-CE: 277960
--      CD_ATENDIMENTO = 215780 - MARIA LINDONETE ALVES - CREFITO-CE: 277960
--      CD_ATENDIMENTO = 192150 - YANDRA QUIXADA DIAS CARLOS - CREFITO-CE: 309644


-- CONSOLIDADO EM querys.sql ✅
WITH PRESCRICAO_VM
    AS     (
            SELECT DISTINCT

                pm.CD_ATENDIMENTO,
                pm.CD_UNID_INT,

                MIN(ipm.DH_REGISTRO)
                OVER (
                      PARTITION BY
                        pm.CD_ATENDIMENTO
                    ) AS DT_START,

                MAX(ipm.DH_REGISTRO)
                OVER (
                      PARTITION BY
                        pm.CD_ATENDIMENTO
                    ) AS DT_END,

                tp.CD_TIP_PRESC,
                tp.DS_TIP_PRESC,

                te.CD_TIP_ESQ,
                te.DS_TIP_ESQ

            FROM DBAMV.ITPRE_MED ipm
            JOIN DBAMV.PRE_MED pm       ON ipm.CD_PRE_MED = pm.CD_PRE_MED
            JOIN TIP_PRESC tp           ON ipm.CD_TIP_ESQ = tp.CD_TIP_ESQ
            JOIN DBAMV.TIP_ESQ te       ON ipm.CD_TIP_ESQ = te.CD_TIP_ESQ AND ipm.CD_TIP_PRESC = tp.CD_TIP_PRESC
            WHERE
                te.CD_TIP_ESQ IN( 'PME' ) AND
                tp.CD_TIP_PRESC IN(488) AND
                EXTRACT(YEAR FROM ipm.DH_REGISTRO) = EXTRACT(YEAR FROM SYSDATE)
                -- AND pm.CD_ATENDIMENTO = 265514
                -- AND pm.CD_ATENDIMENTO = 187202 -- 183178 --198862 -- 183314--187202 --184846
            -- ORDER BY ipm.DH_REGISTRO DESC
),
PROTOCOLO_EXTUBACAO
    AS (
        SELECT

            pdc.CD_ATENDIMENTO,
            er.CD_CAMPO,
            REGEXP_SUBSTR(DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1), '[0-9]+') AS REGX,
            DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1) AS SEM_REGX,
            MAX(pdc.DH_DOCUMENTO) AS HR_DOC_EXTUBACAO

        FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
        INNER JOIN DBAMV.PW_EDITOR_CLINICO pec    ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
        LEFT JOIN DBAMV.EDITOR_REGISTRO_CAMPO er  ON er.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
        LEFT JOIN DBAMV.EDITOR_DOCUMENTO doc      ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
        WHERE
            EXTRACT(YEAR FROM pdc.DH_DOCUMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
            doc.CD_DOCUMENTO IN ('935') AND
            er.CD_CAMPO IN(442178, 452571)
        GROUP BY
            pdc.CD_ATENDIMENTO,
            er.CD_CAMPO,
            REGEXP_SUBSTR(DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1), '[0-9]+'),
            DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1)
),
ATENDIMENTO
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            CASE
                WHEN a.DT_ATENDIMENTO IS NOT NULL AND a.HR_ATENDIMENTO IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ATENDIMENTO, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ATENDIMENTO, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ATENDIMENTO,
            CASE
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ALTA

        FROM DBAMV.ATENDIME a
        JOIN DBAMV.LEITO l                          ON a.CD_LEITO = l.CD_LEITO
        LEFT JOIN DBAMV.PACIENTE p                  ON a.CD_PACIENTE = p.CD_PACIENTE
        WHERE
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
            p.NM_PACIENTE NOT LIKE '%TEST%'
),
 UNIDADE_LEITOS
    AS (
        SELECT
            CD_UNID_INT,
            CASE
                WHEN DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE DS_UNID_INT
            END AS LOCAL
        FROM DBAMV.UNID_INT
),
OBITOS
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
            a.HR_ALTA AS HR_OBITO ,
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
TREATS
    AS (
        SELECT
            pvm.CD_ATENDIMENTO,
            a.DH_ATENDIMENTO,
            a.DH_ALTA,

            EXTRACT(MONTH FROM pvm.DT_START) AS MES,
            SUBSTR(TO_CHAR(pvm.DT_START, 'FMMONTH', 'NLS_DATE_LANGUAGE=PORTUGUESE'), 1, 3)  AS NOME_MES,

            EXTRACT(YEAR FROM pvm.DT_START) AS ANO,

            uil.CD_UNID_INT,
            uil.LOCAL,
            pvm.DT_START,

            pe.REGX,

            pe.HR_DOC_EXTUBACAO,

            CASE
                WHEN o.TP_MOT_ALTA = 'O' AND o.HR_OBITO IS NOT NULL THEN
                    o.HR_OBITO
                WHEN pe.REGX IS NOT NULL THEN
                    pvm.DT_START + NUMTODSINTERVAL(COALESCE(TO_NUMBER(pe.REGX), 0), 'HOUR')
                WHEN pvm.DT_END IS NOT NULL  THEN
                        CASE
                            WHEN pvm.DT_END = pvm.DT_START AND pe.HR_DOC_EXTUBACAO IS NOT NULL AND pe.REGX IS NULL THEN
                                pe.HR_DOC_EXTUBACAO
                            WHEN pvm.DT_END = pvm.DT_START AND pe.REGX IS NOT NULL THEN
                                pvm.DT_START + NUMTODSINTERVAL(COALESCE(TO_NUMBER(pe.REGX), 0), 'HOUR')
                            WHEN pvm.DT_END = pvm.DT_START AND a.DH_ALTA IS NOT NULL THEN
                                a.DH_ALTA
                            ELSE pvm.DT_END
                        END
                ELSE
                    SYSDATE
            END AS DT_END,

            o.TP_MOT_ALTA,
            o.HR_OBITO

        FROM PRESCRICAO_VM pvm
        LEFT JOIN ATENDIMENTO a ON pvm.CD_ATENDIMENTO = a.CD_ATENDIMENTO
        LEFT JOIN PROTOCOLO_EXTUBACAO pe ON pvm.CD_ATENDIMENTO = pe.CD_ATENDIMENTO
        LEFT JOIN OBITOS o ON pvm.CD_ATENDIMENTO = o.CD_ATENDIMENTO
        LEFT JOIN UNIDADE_LEITOS uil ON pvm.CD_UNID_INT = uil.CD_UNID_INT
        ORDER BY EXTRACT(MONTH FROM pvm.DT_START)
),
HORAS
    AS (
        SELECT
            CD_ATENDIMENTO,
            DH_ATENDIMENTO,
            DH_ALTA,
            MES,
            NOME_MES,
            ANO,
            CD_UNID_INT,
            LOCAL,
            DT_START,
            REGX,
            HR_DOC_EXTUBACAO,
            DT_END,
            (DT_END - DT_START) * 24 AS DIFF,
            TP_MOT_ALTA,
            HR_OBITO
        FROM TREATS
)
SELECT
    CD_ATENDIMENTO,
    DH_ATENDIMENTO,
    DH_ALTA,
    MES,
    NOME_MES,
    ANO,
    LOCAL,
    DT_START,
    REGX,
    HR_DOC_EXTUBACAO,
    DT_END,
    TP_MOT_ALTA,
    HR_OBITO,
    DIFF,
    CASE
        WHEN DIFF >= 0  AND DIFF <= 4   THEN 1
        WHEN DIFF > 4  AND DIFF <= 10  THEN 2
        WHEN DIFF > 10 AND DIFF <= 15  THEN 3
        WHEN DIFF > 15 AND DIFF <= 24  THEN 4
        WHEN DIFF > 24 AND DIFF <= 48  THEN 5
        WHEN DIFF > 48 AND DIFF <= 96  THEN 6
        WHEN DIFF > 96 AND DIFF <= 240 THEN 7
        ELSE 8
    END AS ORDEM,
    CASE
        WHEN DIFF >= 0  AND DIFF <= 4   THEN '< 4 hora'
        WHEN DIFF > 4  AND DIFF <= 10  THEN '4-10 horas'
        WHEN DIFF > 10 AND DIFF <= 15  THEN '10-15 horas'
        WHEN DIFF > 15 AND DIFF <= 24  THEN '15-24 horas'
        WHEN DIFF > 24 AND DIFF <= 48  THEN '1-2 dias'
        WHEN DIFF > 48 AND DIFF <= 96  THEN '2-5 dias'
        WHEN DIFF > 96 AND DIFF <= 240 THEN '5-10 dias'
        ELSE '> 10 dias'
    END AS FAIXA_TEMPO
FROM HORAS
WHERE LOCAL = :para  AND ANO = EXTRACT(YEAR FROM SYSDATE)
ORDER BY MES
;

/* ******************************************************************************************** */
/* ******************************************************************************************** */

-- ESBOCO [PARA BAGUNCAR]
WITH PACIENTE_DIA_PRESCRICAO
    AS     (
            SELECT DISTINCT

                ipm.CD_PRE_MED,
                ipm.CD_ITPRE_MED,

                pm.CD_ATENDIMENTO,
                pm.CD_UNID_INT,

                pm.HR_PRE_MED,

                -- CASE
                --     WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL THEN
                --         TO_DATE(
                --             TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),
                --             'DD/MM/YYYY HH24:MI:SS'
                --         )
                --     WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NULL THEN
                --         TO_DATE(TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
                --     ELSE NULL
                -- END AS DH_ALTA,

                MIN(ipm.DH_REGISTRO)
                OVER (
                      PARTITION BY
                        pm.CD_ATENDIMENTO
                    ) AS DT_START,

                MAX(ipm.DH_REGISTRO)
                OVER (
                      PARTITION BY
                        pm.CD_ATENDIMENTO
                    ) AS DT_END,

                tp.CD_TIP_PRESC,
                tp.DS_TIP_PRESC,

                te.CD_TIP_ESQ,
                te.DS_TIP_ESQ

            FROM DBAMV.ITPRE_MED ipm
            JOIN DBAMV.PRE_MED pm       ON ipm.CD_PRE_MED = pm.CD_PRE_MED
            JOIN TIP_PRESC tp           ON ipm.CD_TIP_ESQ = tp.CD_TIP_ESQ
            JOIN DBAMV.TIP_ESQ te       ON ipm.CD_TIP_ESQ = te.CD_TIP_ESQ AND ipm.CD_TIP_PRESC = tp.CD_TIP_PRESC
            -- LEFT JOIN DBAMV.ATENDIME a  ON pm.CD_ATENDIMENTO = a.CD_ATENDIMENTO
            WHERE
                -- te.CD_TIP_ESQ IN( 'PME' ) AND
                tp.CD_TIP_PRESC IN(488
                -- IN(
                --                     488,                       -- [PAVM] VENTILACAO MECANICA
                --                     42400,                     -- [IPCS] INSTALAR CATETER VENOSO CENTRAL
                --                     688, 743, 42724,           -- [ITU-AC] SONDA VESICAL
                --                     42566, 42631, 9042325,
                --                     42790, 9042327, 9040923,
                --                     7568, 7569                 -- [ISC] REVASCULARIZAÇÃO DO MIOCARDIO - PROTESE MAMARIA ???
                                ) AND
                -- EXTRACT(YEAR FROM ipm.DH_REGISTRO) = EXTRACT(YEAR FROM SYSDATE)
                ipm.DH_REGISTRO BETWEEN ADD_MONTHS(SYSDATE, -5) AND TRUNC(SYSDATE)
                AND pm.CD_ATENDIMENTO = 262558 --289010  --265514 --262558
            ORDER BY
                pm.CD_ATENDIMENTO,
                pm.HR_PRE_MED
),
ATENDIMENTO
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            CASE
                WHEN a.DT_ATENDIMENTO IS NOT NULL AND a.HR_ATENDIMENTO IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ATENDIMENTO, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ATENDIMENTO, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ATENDIMENTO,
            CASE
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ALTA

        FROM DBAMV.ATENDIME a
        JOIN DBAMV.LEITO l                          ON a.CD_LEITO = l.CD_LEITO
        LEFT JOIN DBAMV.PACIENTE p                  ON a.CD_PACIENTE = p.CD_PACIENTE
        WHERE
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
            p.NM_PACIENTE NOT LIKE '%TEST%'
),
 UNIDADE_LEITOS
    AS (
        SELECT
            CD_UNID_INT,
            CASE
                WHEN DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE DS_UNID_INT
            END AS LOCAL
        FROM DBAMV.UNID_INT
),
OBITOS
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
            a.HR_ALTA AS HR_OBITO ,
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
TREATS
    AS (
        SELECT
            pvm.CD_ATENDIMENTO,
            a.DH_ATENDIMENTO,
            a.DH_ALTA,

            EXTRACT(MONTH FROM pvm.DT_START) AS MES,
            SUBSTR(TO_CHAR(pvm.DT_START, 'FMMONTH', 'NLS_DATE_LANGUAGE=PORTUGUESE'), 1, 3)  AS NOME_MES,
            EXTRACT(YEAR FROM pvm.DT_START) AS ANO,

            uil.CD_UNID_INT,
            uil.LOCAL,
            pvm.DS_TIP_PRESC,
            pvm.DT_START,

            -- pe.REGX,

            -- pe.HR_DOC_EXTUBACAO,

            CASE
                WHEN o.TP_MOT_ALTA = 'O' AND o.HR_OBITO IS NOT NULL THEN
                    o.HR_OBITO
                -- WHEN pe.REGX IS NOT NULL THEN
                --     pvm.DT_START + NUMTODSINTERVAL(COALESCE(TO_NUMBER(pe.REGX), 0), 'HOUR')
                WHEN pvm.DT_END IS NOT NULL  THEN
                        CASE
                            -- WHEN pvm.DT_END = pvm.DT_START AND pe.HR_DOC_EXTUBACAO IS NOT NULL AND pe.REGX IS NULL THEN
                            --     pe.HR_DOC_EXTUBACAO
                            -- WHEN pvm.DT_END = pvm.DT_START AND pe.REGX IS NOT NULL THEN
                            --     pvm.DT_START + NUMTODSINTERVAL(COALESCE(TO_NUMBER(pe.REGX), 0), 'HOUR')
                            WHEN pvm.DT_END = pvm.DT_START AND a.DH_ALTA IS NOT NULL THEN
                                a.DH_ALTA
                            ELSE pvm.DT_END
                        END
                ELSE
                    SYSDATE
            END AS DT_END,

            o.TP_MOT_ALTA,
            o.HR_OBITO

        FROM PACIENTE_DIA_PRESCRICAO pvm
        LEFT JOIN ATENDIMENTO a ON pvm.CD_ATENDIMENTO = a.CD_ATENDIMENTO
        -- LEFT JOIN PROTOCOLO_EXTUBACAO pe ON pvm.CD_ATENDIMENTO = pe.CD_ATENDIMENTO
        LEFT JOIN OBITOS o ON pvm.CD_ATENDIMENTO = o.CD_ATENDIMENTO
        LEFT JOIN UNIDADE_LEITOS uil ON pvm.CD_UNID_INT = uil.CD_UNID_INT
        ORDER BY EXTRACT(MONTH FROM pvm.DT_START)
)
SELECT
    *
FROM TREATS
ORDER BY
    CD_ATENDIMENTO,
    DT_START
;


,
HORAS
    AS (
        SELECT
            CD_ATENDIMENTO,
            DH_ATENDIMENTO,
            DH_ALTA,
            MES,
            NOME_MES,
            ANO,
            CD_UNID_INT,
            LOCAL,
            DS_TIP_PRESC,
            DT_START,
            -- REGX,
            -- HR_DOC_EXTUBACAO,
            DT_END,
            (DT_END - DT_START) * 24 AS DIFF,
            TP_MOT_ALTA,
            HR_OBITO
        FROM TREATS
)
SELECT
    CD_ATENDIMENTO,
    DH_ATENDIMENTO,
    DH_ALTA,
    MES,
    NOME_MES,
    ANO,
    LOCAL,
    DS_TIP_PRESC,
    DT_START,
    -- REGX,
    -- HR_DOC_EXTUBACAO,
    DT_END,
    TP_MOT_ALTA,
    HR_OBITO,
    DIFF,
    CASE
        WHEN DIFF >= 0  AND DIFF <= 4   THEN 1
        WHEN DIFF > 4  AND DIFF <= 10  THEN 2
        WHEN DIFF > 10 AND DIFF <= 15  THEN 3
        WHEN DIFF > 15 AND DIFF <= 24  THEN 4
        WHEN DIFF > 24 AND DIFF <= 48  THEN 5
        WHEN DIFF > 48 AND DIFF <= 96  THEN 6
        WHEN DIFF > 96 AND DIFF <= 240 THEN 7
        ELSE 8
    END AS ORDEM,
    CASE
        WHEN DIFF >= 0  AND DIFF <= 4   THEN '< 4 hora'
        WHEN DIFF > 4  AND DIFF <= 10  THEN '4-10 horas'
        WHEN DIFF > 10 AND DIFF <= 15  THEN '10-15 horas'
        WHEN DIFF > 15 AND DIFF <= 24  THEN '15-24 horas'
        WHEN DIFF > 24 AND DIFF <= 48  THEN '1-2 dias'
        WHEN DIFF > 48 AND DIFF <= 96  THEN '2-5 dias'
        WHEN DIFF > 96 AND DIFF <= 240 THEN '5-10 dias'
        ELSE '> 10 dias'
    END AS FAIXA_TEMPO
FROM HORAS
WHERE LOCAL = :para  AND ANO = EXTRACT(YEAR FROM SYSDATE)
ORDER BY MES
;
-- SELECT
--     *
-- FROM PACIENTE_DIA_PRESCRICAO

-- ;



-- ============================================================================================================
-- ============================================================================================================


/* ******************************************************************************************** */
/* PACIENTE-DIA - ITU-AC | IPCS | PAVM                                                         */
/* ******************************************************************************************** */

-- CONSOLIDADO EM querys.sql ✅
WITH PRESCRICAO
    AS (
        SELECT
            pm.CD_ATENDIMENTO,
            pm.CD_UNID_INT,
            pm.HR_PRE_MED,
            im.DH_REGISTRO, -- Dt solicitacao exame/realizacao de prescricao do item
            im.CD_TIP_PRESC,
            CASE
                WHEN im.CD_TIP_PRESC IN (688, 42631, 743) THEN
                    'ITU-AC'
                WHEN im.CD_TIP_PRESC IN (42400, 41177, 35753, 35752,
                                         39669, 39668, 35751, 42230,
                                         42855, 9043509, 746) THEN
                    'IPCS'
                WHEN im.CD_TIP_PRESC =  488 THEN
                    'PAVM'
            END AS TIPO_INDICADOR
        FROM DBAMV.ITPRE_MED im
        JOIN DBAMV.PRE_MED pm ON im.CD_PRE_MED = pm.CD_PRE_MED
        WHERE
            im.CD_TIP_PRESC IN( 42631, 42400, 41177, 35753,
                                35752, 39669, 39668, 35751,
                                42230, 42855, 9043509, 746,
                                688, 743, 488) AND
            im.DH_REGISTRO BETWEEN ADD_MONTHS(SYSDATE, -5) AND TRUNC(SYSDATE)
),
ATENDIMENTO_ALTA
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            CASE
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NULL THEN
                    TO_DATE(TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
                ELSE NULL
            END AS DH_ALTA
        FROM DBAMV.ATENDIME a
),
PROTOCOLO_EXTUBACAO_PAVM
    AS (
        SELECT

            pdc.CD_ATENDIMENTO,
            er.CD_CAMPO,
            REGEXP_SUBSTR(DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1), '[0-9]+') AS REGX,
            DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1) AS SEM_REGX,
            MAX(pdc.DH_DOCUMENTO) AS HR_DOC_EXTUBACAO

        FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
        INNER JOIN DBAMV.PW_EDITOR_CLINICO pec    ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
        LEFT JOIN DBAMV.EDITOR_REGISTRO_CAMPO er  ON er.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
        LEFT JOIN DBAMV.EDITOR_DOCUMENTO doc      ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
        WHERE
            EXTRACT(YEAR FROM pdc.DH_DOCUMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
            doc.CD_DOCUMENTO IN ('935') AND
            er.CD_CAMPO IN(442178, 452571)
        GROUP BY
            pdc.CD_ATENDIMENTO,
            er.CD_CAMPO,
            REGEXP_SUBSTR(DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1), '[0-9]+'),
            DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1)
),
DT_INICIO
    AS (
        SELECT
            p.CD_ATENDIMENTO,
            p.CD_UNID_INT,
            p.HR_PRE_MED AS DT_START,
            p.TIPO_INDICADOR
        FROM PRESCRICAO p
        WHERE
            (p.TIPO_INDICADOR = 'ITU-AC' AND p.CD_TIP_PRESC IN(688, 42631)) OR
            (p.TIPO_INDICADOR = 'IPCS'   AND p.CD_TIP_PRESC IN(42400, 41177, 35753, 35752,
                                                               39669, 39668, 35751, 42230,
                                                               42855, 9043509))
),
DT_INICIO_PAVM
    AS (
        SELECT
            p.CD_ATENDIMENTO,
            p.CD_UNID_INT,
            p.TIPO_INDICADOR,
            a.DH_ALTA,
            MIN(p.HR_PRE_MED) AS DT_START

        FROM PRESCRICAO p
        LEFT JOIN ATENDIMENTO_ALTA a ON p.CD_ATENDIMENTO = a.CD_ATENDIMENTO
        WHERE
            p.TIPO_INDICADOR = 'PAVM' AND p.CD_TIP_PRESC = 488
        GROUP BY
            p.CD_ATENDIMENTO,
            p.CD_UNID_INT,
            p.TIPO_INDICADOR,
            a.DH_ALTA
),
TREATS_UNION
    AS (
        SELECT
            i.CD_ATENDIMENTO,
            i.CD_UNID_INT,
            i.DT_START,
            i.TIPO_INDICADOR,
            a.DH_ALTA,

            NULL AS DT_INICIAL_PAVM,
            NULL AS HR_DOC_EXTUBACAO,
            (
                SELECT
                    MIN(p2.HR_PRE_MED)
                FROM PRESCRICAO p2
                WHERE
                    p2.CD_ATENDIMENTO = i.CD_ATENDIMENTO AND
                    p2.TIPO_INDICADOR = i.TIPO_INDICADOR AND
                    (
                        (i.TIPO_INDICADOR = 'ITU-AC' AND p2.CD_TIP_PRESC = 743) OR
                        (i.TIPO_INDICADOR = 'IPCS'   AND p2.CD_TIP_PRESC = 746)
                    ) AND
                    p2.HR_PRE_MED > i.DT_START
            ) AS DT_PRIMEIRO_FIM,

            (
                SELECT
                    MIN(p3.HR_PRE_MED)
                FROM PRESCRICAO p3
                WHERE
                    p3.CD_ATENDIMENTO = i.CD_ATENDIMENTO AND
                    p3.TIPO_INDICADOR = i.TIPO_INDICADOR AND
                    (
                        (i.TIPO_INDICADOR = 'ITU-AC' AND p3.CD_TIP_PRESC IN(688, 42631)) OR
                        (i.TIPO_INDICADOR = 'IPCS'   AND p3.CD_TIP_PRESC IN(42400, 41177, 35753, 35752,
                                                                            39669, 39668, 35751, 42230,
                                                                            42855, 9043509))
                    ) AND
                    p3.HR_PRE_MED > i.DT_START
            ) AS DT_SEGUNDO_INICIO

        FROM DT_INICIO i
        LEFT JOIN ATENDIMENTO_ALTA a ON i.CD_ATENDIMENTO = a.CD_ATENDIMENTO

        UNION ALL

        SELECT
            di.CD_ATENDIMENTO,
            di.CD_UNID_INT,
            di.DT_START,
            di.TIPO_INDICADOR,
            di.DH_ALTA,
            di.DT_START AS DT_INICIAL_PAVM,
            (
                SELECT
                    MAX(p_pavm.HR_PRE_MED)
                FROM PRESCRICAO p_pavm
                WHERE
                    p_pavm.CD_ATENDIMENTO = di.CD_ATENDIMENTO AND
                    p_pavm.CD_UNID_INT = di.CD_UNID_INT AND
                    p_pavm.TIPO_INDICADOR = 'PAVM' AND
                    p_pavm.CD_TIP_PRESC = 488
            ) AS HR_DOC_EXTUBACAO,
            NULL AS DT_PRIMEIRO_FIM,
            NULL AS DT_SEGUNDO_INICIO
        FROM DT_INICIO_PAVM di
),
DT_FIM
    AS (
        SELECT
            p.TIPO_INDICADOR,
            p.CD_ATENDIMENTO,
            p.CD_UNID_INT,
            p.DT_START,
            p.DH_ALTA,
            CASE
                WHEN p.TIPO_INDICADOR = 'PAVM' AND p.HR_DOC_EXTUBACAO IS NOT NULL THEN
                    p.HR_DOC_EXTUBACAO
                WHEN p.DT_PRIMEIRO_FIM IS NOT NULL THEN
                    p.DT_PRIMEIRO_FIM
                WHEN p.DT_SEGUNDO_INICIO IS NOT NULL THEN
                    p.DT_SEGUNDO_INICIO
                WHEN p.DT_INICIAL_PAVM IS NOT NULL THEN
                    p.DT_INICIAL_PAVM
                ELSE p.DH_ALTA
            END AS DT_END

        FROM TREATS_UNION p
        ORDER BY
            p.TIPO_INDICADOR,
            p.CD_ATENDIMENTO,
            p.DT_START
),
 UNIDADE_LEITOS
    AS (
        SELECT
            CD_UNID_INT,
            CASE
                WHEN DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE DS_UNID_INT
            END AS LOCAL
        FROM DBAMV.UNID_INT
)
SELECT DISTINCT
    TRUNC(df.DT_START) AS DATA,
    ul.LOCAL,
    df.TIPO_INDICADOR AS TIPO,

    CASE
        WHEN df.DT_START IS NOT NULL AND df.DT_END IS NOT NULL THEN
            TRUNC(df.DT_END) - TRUNC(df.DT_START)
        ELSE 0
    END AS QTD_PACIENTE,

    0 AS QTD_OCORRENCIA

FROM DT_FIM df
JOIN UNIDADE_LEITOS ul ON df.CD_UNID_INT = ul.CD_UNID_INT
WHERE ul.LOCAL = 'UTI 1'
AND EXTRACT(YEAR FROM df.DT_START) = '2026'
AND EXTRACT(MONTH FROM df.DT_START) = '1'
AND df.TIPO_INDICADOR = 'ITU-AC'
 --'" & Unidade & "'
ORDER BY
    TRUNC(df.DT_START),
    ul.LOCAL,
    df.TIPO_INDICADOR
;