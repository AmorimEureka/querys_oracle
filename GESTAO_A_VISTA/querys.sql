-- #########################################################################################################

--  QUERY PARA DASHBOARD KPI GESTAO A VISTA
--  TAXA MORTALIDADE
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
    o.LOCAL;


-- #########################################################################################################

-- QUERY PARA DASHBOARD KPI GESTAO A VISTA
-- TEMPO MEDIO DE PERMANENCIA NAS UTI's
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
            /*+ MATERIALIZE */
        FROM DBAMV.ATENDIME a
        LEFT JOIN DBAMV.PACIENTE p ON a.CD_PACIENTE = p.CD_PACIENTE
        WHERE
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
            a.TP_ATENDIMENTO IN( 'I', 'U') AND
            p.NM_PACIENTE NOT LIKE '%TEST%'
),
MOVIMENTACAO
    AS (
        SELECT
            mi.CD_ATENDIMENTO,
            mi.CD_LEITO,
            mi.CD_LEITO_ANTERIOR,
            EXTRACT(MONTH FROM mi.DT_MOV_INT) AS MES,
            EXTRACT(YEAR FROM mi.DT_MOV_INT) AS ANO
            /*+ MATERIALIZE */
        FROM DBAMV.MOV_INT mi
        JOIN DBAMV.ATENDIME a ON a.CD_ATENDIMENTO = mi.CD_ATENDIMENTO
        WHERE
            EXTRACT(YEAR FROM mi.DT_MOV_INT) = EXTRACT(YEAR FROM SYSDATE) AND
            a.TP_ATENDIMENTO IN ('I')
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
            ul.LOCAL,
            a.CLASSIFICACAO,

            SUM(
                CASE
                    WHEN COALESCE(TRUNC(a.DH_ALTA), TRUNC(SYSDATE)) - TRUNC(a.DH_ATENDIMENTO) > 0 THEN
                        COALESCE(TRUNC(a.DH_ALTA), TRUNC(SYSDATE)) - TRUNC(a.DH_ATENDIMENTO)
                    ELSE
                        1
                END
             ) AS QTD_PACIENTE_DIA

        FROM ATENDIMENTO a
        JOIN UNIDADE_LEITOS ul ON a.CD_LEITO = ul.CD_LEITO
        GROUP BY
            a.MES,
            a.ANO,
            ul.LOCAL,
            a.CLASSIFICACAO
        ORDER BY
            a.MES,
            a.ANO,
            ul.LOCAL
),
PACIENTE_ALTAS
    AS (
        SELECT
            EXTRACT(MONTH FROM a.DH_ALTA) AS MES,
            EXTRACT(YEAR FROM a.DH_ALTA) AS ANO,
            ul.LOCAL,
            COUNT(*) AS QTD_ALTAS

        FROM ATENDIMENTO a
        JOIN UNIDADE_LEITOS ul ON a.CD_LEITO = ul.CD_LEITO
        WHERE
            a.DH_ALTA IS NOT NULL AND
            EXTRACT(YEAR FROM a.DH_ALTA) = EXTRACT(YEAR FROM SYSDATE)
        GROUP BY
            EXTRACT(MONTH FROM a.DH_ALTA),
            EXTRACT(YEAR FROM a.DH_ALTA),
            ul.LOCAL
        ORDER BY
            EXTRACT(MONTH FROM a.DH_ALTA),
            EXTRACT(YEAR FROM a.DH_ALTA),
            ul.LOCAL
),
MOVI_INTERNA
    AS (
        SELECT
            m.MES,
            m.ANO,
            ul1.LOCAL,
            count(*) QTD_TRANSFPARA

        FROM MOVIMENTACAO m
        JOIN UNIDADE_LEITOS ul ON m.CD_LEITO = ul.CD_LEITO
        JOIN UNIDADE_LEITOS ul1 ON m.CD_LEITO_ANTERIOR = ul1.CD_LEITO
        WHERE ul.CD_UNID_INT <> ul1.CD_UNID_INT
        GROUP BY
            m.MES,
            m.ANO,
            ul1.LOCAL
        ORDER BY
            m.MES
)
SELECT
    pd.MES,
    CASE
        WHEN pd.MES = 1 THEN 'Jan'
        WHEN pd.MES = 2 THEN 'Fev'
        WHEN pd.MES = 3 THEN 'Mar'
        WHEN pd.MES = 4 THEN 'Abr'
        WHEN pd.MES = 5 THEN 'Mai'
        WHEN pd.MES = 6 THEN 'Jun'
        WHEN pd.MES = 7 THEN 'Jul'
        WHEN pd.MES = 8 THEN 'Ago'
        WHEN pd.MES = 9 THEN 'Set'
        WHEN pd.MES = 10 THEN 'Out'
        WHEN pd.MES = 11 THEN 'Nov'
        WHEN pd.MES = 11 THEN 'Dez'
    END AS NOME_MES,
    pd.ANO,
    pd.LOCAL,
    pd.CLASSIFICACAO,
    m.MEDIANA_IDADE,

    pd.QTD_PACIENTE_DIA,
    mi.QTD_TRANSFPARA,
    pa.QTD_ALTAS,

    CASE
        WHEN pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1)  < 1 THEN
            '< 1'
        ELSE
            TO_CHAR(TRUNC( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1) ))
    END AS CLASS_TEMPO_MED,

    CASE
        WHEN TRUNC( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1) ) < 1 THEN
            1
        ELSE
            TRUNC( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1) )
    END AS TEMPO_MEDIO,

    CASE
        WHEN TRUNC( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1) ) < 1 THEN
            ROUND( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1), 2 )
        ELSE
            ROUND( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1), 2 )
    END AS TEMPO_MEDIO_REAL

FROM PACIENTE_DIA pd
JOIN PACIENTE_ALTAS pa ON pd.MES = pa.MES AND pd.ANO = pa.ANO AND pd.LOCAL = pa.LOCAL
JOIN MOVI_INTERNA mi ON pd.MES = mi.MES AND pd.ANO = mi.ANO AND pd.LOCAL = mi.LOCAL
JOIN MEDIANA m ON pd.MES = m.MES AND pd.ANO = m.ANO AND pd.LOCAL = m.LOCAL
ORDER BY
    pd.MES,
    pd.LOCAL
;


/* ******************************************************************************************** */

-- QUERY PARA DASHBOARD KPI GESTAO A VISTA
-- QTD e TEMPO MEDIO DE ENTUBACAO
WITH PRESCRICAO_VM
    AS     (
            SELECT

                pm.CD_ATENDIMENTO,
                pm.CD_UNID_INT,

                pm.HR_PRE_MED,
                pm.DT_VALIDADE,

                ipm.CD_PRE_MED,
                ipm.CD_ITPRE_MED,

                EXTRACT(MONTH FROM ipm.DH_REGISTRO) AS MES,
                CASE
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 1 THEN 'Jan'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 2 THEN 'Fev'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 3 THEN 'Mar'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 4 THEN 'Abr'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 5 THEN 'Mai'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 6 THEN 'Jun'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 7 THEN 'Jul'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 8 THEN 'Ago'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 9 THEN 'Set'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 10 THEN 'Out'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 11 THEN 'Nov'
                    WHEN EXTRACT(MONTH FROM ipm.DH_REGISTRO) = 11 THEN 'Dez'
                END AS NOME_MES,

                EXTRACT(YEAR FROM ipm.DH_REGISTRO) AS ANO,

                MAX(ipm.DH_REGISTRO)
                OVER (
                      PARTITION BY
                        pm.CD_ATENDIMENTO,
                        pm.CD_UNID_INT,
                        pm.HR_PRE_MED
                    ) AS DH_REGISTRO,


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

                ipm.DH_INICIAL,
                ipm.DH_FINAL,

                tp.CD_TIP_PRESC,
                tp.DS_TIP_PRESC,

                te.CD_TIP_ESQ,
                te.DS_TIP_ESQ,

                ipm.SN_CANCELADO,

                ROW_NUMBER()
                OVER (
                      PARTITION BY
                        pm.CD_ATENDIMENTO,
                        pm.CD_UNID_INT,
                        pm.HR_PRE_MED
                      ORDER BY ipm.DH_REGISTRO
                    ) AS RN

            FROM DBAMV.ITPRE_MED ipm
            JOIN DBAMV.PRE_MED pm       ON ipm.CD_PRE_MED = pm.CD_PRE_MED
            JOIN TIP_PRESC tp           ON ipm.CD_TIP_ESQ = tp.CD_TIP_ESQ
            JOIN DBAMV.TIP_ESQ te       ON ipm.CD_TIP_ESQ = te.CD_TIP_ESQ AND ipm.CD_TIP_PRESC = tp.CD_TIP_PRESC
            WHERE
                te.CD_TIP_ESQ IN( 'PME' ) AND
                tp.CD_TIP_PRESC IN(488) AND
                EXTRACT(YEAR FROM ipm.DH_REGISTRO) = EXTRACT(YEAR FROM SYSDATE)
            ORDER BY ipm.DH_REGISTRO DESC
),
-- PROTOCOLO_PAV
--     AS (
--         SELECT
--             pdc.CD_ATENDIMENTO,
--             pdc.CD_PACIENTE,

--             pdc.TP_STATUS,
--             MIN(pdc.DH_DOCUMENTO) AS DT_START,
--             MAX(pdc.DH_DOCUMENTO) AS DT_END,

--             EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) AS MES,
--             CASE
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 1 THEN 'Jan'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 2 THEN 'Fev'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 3 THEN 'Mar'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 4 THEN 'Abr'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 5 THEN 'Mai'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 6 THEN 'Jun'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 7 THEN 'Jul'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 8 THEN 'Ago'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 9 THEN 'Set'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 10 THEN 'Out'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 11 THEN 'Nov'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 11 THEN 'Dez'
--             END AS NOME_MES,

--             EXTRACT(YEAR FROM pdc.DH_DOCUMENTO) AS ANO

--         FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
--         INNER JOIN DBAMV.PW_EDITOR_CLINICO pec      ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
--         LEFT JOIN  DBAMV.EDITOR_DOCUMENTO doc       ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
--         WHERE
--             EXTRACT(YEAR FROM pdc.DH_DOCUMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
-- 	        doc.CD_DOCUMENTO IN ('939') AND
--             pdc.TP_STATUS = 'FECHADO'
--         GROUP BY
--             pdc.CD_ATENDIMENTO,
--             pdc.CD_PACIENTE,
--             pdc.TP_STATUS,
--             EXTRACT(MONTH FROM pdc.DH_DOCUMENTO),
--             CASE
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 1 THEN 'Jan'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 2 THEN 'Fev'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 3 THEN 'Mar'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 4 THEN 'Abr'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 5 THEN 'Mai'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 6 THEN 'Jun'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 7 THEN 'Jul'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 8 THEN 'Ago'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 9 THEN 'Set'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 10 THEN 'Out'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 11 THEN 'Nov'
--                 WHEN EXTRACT(MONTH FROM pdc.DH_DOCUMENTO) = 11 THEN 'Dez'
--             END,
--             EXTRACT(YEAR FROM pdc.DH_DOCUMENTO)
-- ),
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
            END AS DH_ALTA,

            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END AS LOCAL

        FROM DBAMV.ATENDIME a
        JOIN DBAMV.LEITO l                          ON a.CD_LEITO = l.CD_LEITO
        JOIN DBAMV.UNID_INT ui                      ON l.CD_UNID_INT = ui.CD_UNID_INT
        LEFT JOIN DBAMV.PACIENTE p                  ON a.CD_PACIENTE = p.CD_PACIENTE
        WHERE
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
            p.NM_PACIENTE NOT LIKE '%TEST%'

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
            a.CD_ATENDIMENTO,
            a.DH_ATENDIMENTO,
            a.DH_ALTA,
            pvm.MES,
            pvm.NOME_MES,
            pvm.ANO,
            a.LOCAL,
            pvm.DT_START,

            pe.REGX,

            pe.HR_DOC_EXTUBACAO,

            CASE
                WHEN pvm.DT_START = pvm.DT_END AND (pe.REGX IS NULL OR TRIM(pe.REGX) = '') THEN
                    pe.HR_DOC_EXTUBACAO
                WHEN pvm.DT_START = pvm.DT_END AND pe.REGX IS NOT NULL THEN
                    pvm.DT_START + NUMTODSINTERVAL(COALESCE(TO_NUMBER(pe.REGX), 0), 'HOUR')
                WHEN a.DH_ALTA IS NOT NULL AND pvm.DT_START <> pvm.DT_END THEN
                    pvm.DT_END
                WHEN a.DH_ALTA IS NOT NULL AND o.TP_MOT_ALTA = 'O' THEN
                    o.HR_OBITO
                ELSE
                    SYSDATE
            END AS DT_END,

            o.TP_MOT_ALTA,
            o.HR_OBITO

        FROM PRESCRICAO_VM pvm
        LEFT JOIN ATENDIMENTO a ON pvm.CD_ATENDIMENTO = a.CD_ATENDIMENTO
        LEFT JOIN PROTOCOLO_EXTUBACAO pe ON pvm.CD_ATENDIMENTO = pe.CD_ATENDIMENTO
        LEFT JOIN OBITOS o ON pvm.CD_ATENDIMENTO = o.CD_ATENDIMENTO
        ORDER BY pvm.MES
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
SELECT DISTINCT
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
;


-- #########################################################################################################
