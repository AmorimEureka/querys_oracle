SELECT DISTINCT
	fs.DS_FILA ,
	ta.CD_ATENDIMENTO ,
--	stp.dh_processo ,
--	stp.dh_chamada_proc ,
	EXTRACT(MONTH FROM ta.DH_PRE_ATENDIMENTO) AS MES ,
	EXTRACT(YEAR FROM ta.DH_PRE_ATENDIMENTO)  AS ANO ,
	ta.DH_REMOVIDO ,
	ta.DS_OBSERVACAO_REMOVIDO ,
	ta.CD_PACIENTE ,
	ta.ds_senha,
	esp.NM_PRESTADOR ,
	esp.DS_ESPECIALID ,
	ta.DH_PRE_ATENDIMENTO AS DT_FICHA ,
	ta.dh_chamada_classificacao DT_CLASSIFICACAO,
	ROUND((ta.dh_chamada_classificacao - ta.DH_PRE_ATENDIMENTO)*24*60, 2) AS TEMPO_FICHA ,
	ta.DH_PRE_ATENDIMENTO_FIM AS FIM ,
	ROUND((ta.DH_PRE_ATENDIMENTO_FIM - ta.dh_chamada_classificacao)*24*60, 2) AS TEMPO_TRIAGEM ,
--	ta.TP_RASTREAMENTO ,
	cor.nm_cor ,
	stp.CD_MOTIVO_CANCELAMENTO
FROM sacr_tempo_processo stp
LEFT JOIN TRIAGEM_ATENDIMENTO ta              ON stp.CD_TRIAGEM_ATENDIMENTO = ta.CD_TRIAGEM_ATENDIMENTO
LEFT JOIN FILA_SENHA fs 		              ON  ta.CD_FILA_SENHA          = fs.CD_FILA_SENHA
LEFT JOIN PRESTADOR p 						  ON  ta.CD_PRESTADOR 			= p.CD_PRESTADOR
LEFT JOIN
		(	SELECT
				scr.CD_TRIAGEM_ATENDIMENTO,
				scr.NM_COR
			FROM SACR_CLASSIFICACAO_RISCO scr
			LEFT JOIN SACR_CLASSIFICACAO  sc  ON scr.CD_CLASSIFICACAO      = sc.CD_CLASSIFICACAO
			LEFT JOIN SACR_COR_REFERENCIA scr ON sc.CD_COR_REFERENCIA      = scr.CD_COR_REFERENCIA
) cor   						              ON ta.CD_TRIAGEM_ATENDIMENTO = cor.CD_TRIAGEM_ATENDIMENTO
LEFT JOIN
        (	SELECT
				a.CD_ATENDIMENTO ,
				e.DS_ESPECIALID ,
				p2.nm_prestador
			FROM DBAMV.ATENDIME a
			LEFT JOIN DBAMV.SERVICO s   	  ON a.CD_SERVICO    = s.CD_SERVICO
			LEFT JOIN DBAMV.ESPECIALID e 	  ON s.CD_ESPECIALID = e.CD_ESPECIALID
			LEFT JOIN DBAMV.PRESTADOR p2      ON a.cd_prestador  = p2.CD_PRESTADOR
) esp   						              ON ta.CD_ATENDIMENTO = esp.CD_ATENDIMENTO
WHERE fs.CD_FILA_SENHA = 1 AND ta.DH_PRE_ATENDIMENTO > TRUNC(ADD_MONTHS(SYSDATE, -3), 'MM') ;

--AND ta.ds_senha = 'UR0012';

/* ******************************************************************************************************* */

WITH TEMPO_TOTEM_CLASS_ADM_MED
    AS (
        -- Armazena os tempos do processo de atendimento do paciente
        SELECT
            stp.CD_TEMPO_PROCESSO ,
            stp.CD_TRIAGEM_ATENDIMENTO ,
            stp.CD_ATENDIMENTO ,
            stp.CD_TIPO_TEMPO_PROCESSO ,
            stp.DH_PROCESSO
        FROM
            DBAMV.SACR_TEMPO_PROCESSO stp
),
TIPO_PROCESSO
    AS (
        -- Armazena os tipos de tempos do processo de atendimento do paciente
        SELECT
            sttp.CD_TIPO_TEMPO_PROCESSO ,
            sttp.DS_TIPO_TEMPO_PROCESSO
        FROM
            DBAMV.SACR_TIPO_TEMPO_PROCESSO sttp
),
TRIAGEM
    AS (
        -- Cadastramento de pre-atendimento para classificacao de risco
        SELECT
            ta.CD_TRIAGEM_ATENDIMENTO ,
            ta.CD_ATENDIMENTO ,
            ta.CD_FILA_SENHA ,
            ta.CD_FILA_PRINCIPAL ,
            ta.CD_SETOR ,
            ta.DS_SENHA,
            ta.DH_PRE_ATENDIMENTO ,
            ta.DH_PRE_ATENDIMENTO_FIM ,
            ta.DH_CHAMADA_CLASSIFICACAO ,
            ta.DH_REMOVIDO
        FROM DBAMV.TRIAGEM_ATENDIMENTO ta
),
FILA
    AS (
        -- Armazena as filas para geração de senhas
        SELECT
            fs.CD_FILA_SENHA ,
            fs.DS_FILA ,
            fs.DS_IDENTIFICADOR_FILA
        FROM DBAMV.FILA_SENHA fs
),
CLASSIFICACAO_RISCO
    AS (
        -- Tabela que armazena a classificação de risco
        SELECT
            scr.CD_TRIAGEM_ATENDIMENTO ,
            scr.CD_CLASSIFICACAO_RISCO ,
            scr.CD_CLASSIFICACAO ,
            scr.CD_COR_REFERENCIA ,
            scr.DH_CLASSIFICACAO_RISCO
        FROM DBAMV.SACR_CLASSIFICACAO_RISCO scr
),
CLASSIFICACAO
    AS (
        -- Tabela que armazena um protocolo
        SELECT
            sc.CD_CLASSIFICACAO ,
            sc.DS_TIPO_RISCO
        FROM DBAMV.SACR_CLASSIFICACAO sc
),
COR
    AS (
        -- Tabela que armazena as cores de referência
        SELECT
            scr.CD_COR_REFERENCIA ,
            scr.NM_COR ,
            scr.DS_RGB_DECIMAL ,
            scr.DS_RGB_HEXADECIMAL
        FROM DBAMV.SACR_COR_REFERENCIA scr
),
TREATS
    AS (
        SELECT
            tcam.CD_TRIAGEM_ATENDIMENTO,
            tcam.CD_ATENDIMENTO ,
            tcam.DH_PROCESSO ,
            EXTRACT(MONTH FROM tcam.DH_PROCESSO) AS MES ,
            EXTRACT(YEAR FROM tcam.DH_PROCESSO)  AS ANO ,
            -- LAG(tcam.DH_PROCESSO) OVER (PARTITION BY tcam.CD_TRIAGEM_ATENDIMENTO ORDER BY tcam.DH_PROCESSO) AS PREV_DH_PROCESSO,
            ROUND((tcam.DH_PROCESSO - LAG(tcam.DH_PROCESSO) OVER (PARTITION BY tcam.CD_TRIAGEM_ATENDIMENTO ORDER BY tcam.DH_PROCESSO)) * 24 * 60, 2) AS INTERVALO_TEMPO,
            tp.CD_TIPO_TEMPO_PROCESSO ,
            tp.DS_TIPO_TEMPO_PROCESSO ,
            tri.DH_PRE_ATENDIMENTO ,
            tri.DH_PRE_ATENDIMENTO_FIM ,
            tri.DH_CHAMADA_CLASSIFICACAO ,
            tri.DH_REMOVIDO ,
            tri.DS_SENHA,
            fs.DS_FILA ,
            CASE WHEN fs.CD_FILA_SENHA IN(2, 21, 3, 20) THEN
                'CLINICA 1'
                WHEN fs.CD_FILA_SENHA IN(12, 22, 13, 19) THEN
                'CLINICA 2'
                WHEN fs.CD_FILA_SENHA = 1 THEN
                    'URGENCIA/EMERGENCIA'
            ELSE NULL END AS CLINICA ,
            CASE WHEN fs.CD_FILA_SENHA IN(2, 21, 12, 22) THEN
                'CONSULTA'
                WHEN fs.CD_FILA_SENHA IN(3, 20, 13, 19) THEN
                'EXAME'
            ELSE NULL END AS ATEND_AMBULATORIAL ,
            sc.DS_TIPO_RISCO ,
            co.NM_COR
        FROM TEMPO_TOTEM_CLASS_ADM_MED tcam
        INNER JOIN TIPO_PROCESSO tp ON tcam.CD_TIPO_TEMPO_PROCESSO = tp.CD_TIPO_TEMPO_PROCESSO
        INNER JOIN TRIAGEM tri ON tcam.CD_TRIAGEM_ATENDIMENTO = tri.CD_TRIAGEM_ATENDIMENTO
        LEFT JOIN FILA fs ON tri.CD_FILA_SENHA = fs.CD_FILA_SENHA
        LEFT JOIN CLASSIFICACAO_RISCO scr ON tri.CD_TRIAGEM_ATENDIMENTO = scr.CD_TRIAGEM_ATENDIMENTO
        LEFT JOIN CLASSIFICACAO sc ON scr.CD_CLASSIFICACAO = sc.CD_CLASSIFICACAO
        LEFT JOIN COR co ON scr.CD_COR_REFERENCIA = co.CD_COR_REFERENCIA
        ORDER BY tcam.CD_TRIAGEM_ATENDIMENTO desc, tcam.DH_PROCESSO
)
SELECT * FROM TREATS WHERE CD_ATENDIMENTO = 253330 ;

-- MENSURANDO A QUANTIDADE DE OCORRENCIAS POR PROCESSO
SELECT DISTINCT
    CD_TIPO_TEMPO_PROCESSO,
    DS_TIPO_TEMPO_PROCESSO,
    COUNT(*) OVER (PARTITION BY DS_TIPO_TEMPO_PROCESSO) AS QTD
FROM TREATS
WHERE DS_FILA LIKE '%ANGIO TC%'
ORDER BY CD_TIPO_TEMPO_PROCESSO
;




-- FILTROS PARA RESPONDER QUESTIONAMENTOS DE IMPLANTACAO - UP FLUX
,
FILTROS AS (
    SELECT
        NM_COR,
        ANO || '-' || MES AS ANO_MES,
        CLINICA,
        ATEND_AMBULATORIAL,
        COUNT( DISTINCT CD_TRIAGEM_ATENDIMENTO ) AS QTD
    FROM TREATS
    WHERE ((ANO = 2024 AND MES = 12) OR (ANO = 2025 AND MES IN (1, 2)))
          AND CLINICA = 'URGENCIA/EMERGENCIA'
    GROUP BY ANO || '-' || MES, NM_COR, CLINICA, ATEND_AMBULATORIAL
),
PIVOT_TABLE AS (
    SELECT * FROM FILTROS
    PIVOT (
        SUM(QTD)
        FOR NM_COR IN (
                        'AZUL' AS "AZUL",
                        'VERDE' AS "VERDE",
                        'AMARELO' AS "AMARELO",
                        'LARANJA' AS "LARANJA",
                        'VERMELHO' AS "VERMELHO"
                    )
    )
)
SELECT
    CAST(ANO_MES AS VARCHAR(20)) AS ANO_MES,
    AZUL,
    VERDE,
    AMARELO,
    LARANJA,
    VERMELHO,
    (NVL(AZUL, 0) + NVL(VERDE, 0) + NVL(AMARELO, 0) + NVL(LARANJA, 0) + NVL(VERMELHO, 0)) AS TOTAL_PERIODO
FROM PIVOT_TABLE

UNION ALL

SELECT
    'TOTAL GERAL' AS ANO_MES,
    SUM(AZUL),
    SUM(VERDE),
    SUM(AMARELO),
    SUM(LARANJA),
    SUM(VERMELHO),
    SUM(NVL(AZUL, 0) + NVL(VERDE, 0) + NVL(AMARELO, 0) + NVL(LARANJA, 0) + NVL(VERMELHO, 0)) AS TOTAL_PERIODO
FROM PIVOT_TABLE

ORDER BY ANO_MES;


/* ******************************************************************************************************* */


WITH TEMPO_TOTEM_CLASS_ADM_MED
    AS (
        -- Armazena os tempos do processo de atendimento do paciente
        SELECT
            stp.CD_TEMPO_PROCESSO,
            stp.CD_TRIAGEM_ATENDIMENTO,
            stp.CD_ATENDIMENTO,
            a.NM_USUARIO,
            a.CD_PRESTADOR,
            a.CD_PACIENTE,
            a.CD_CONVENIO,
            a.TP_ATENDIMENTO,
            stp.CD_TIPO_TEMPO_PROCESSO,
            CASE
                WHEN TO_CHAR(a.HR_ATENDIMENTO, 'YYYY-MM') != TO_CHAR(stp.DH_PROCESSO, 'YYYY-MM') THEN
                    TRUNC(a.HR_ATENDIMENTO) + (stp.DH_PROCESSO - TRUNC(stp.DH_PROCESSO))
                ELSE
                    stp.DH_PROCESSO
            END AS DH_PROCESSO,
            stp.DH_PROCESSO AS DH_PROCESSO_ANTIGO,
            a.HR_ATENDIMENTO
        FROM DBAMV.SACR_TEMPO_PROCESSO stp
        LEFT JOIN DBAMV.ATENDIME a ON stp.CD_ATENDIMENTO = a.CD_ATENDIMENTO

),
TIPO_PROCESSO
    AS (
        -- Armazena os tipos de tempos do processo de atendimento do paciente
        SELECT
            sttp.CD_TIPO_TEMPO_PROCESSO,
            sttp.DS_TIPO_TEMPO_PROCESSO
        FROM DBAMV.SACR_TIPO_TEMPO_PROCESSO sttp
),
TRIAGEM
    AS (
        -- Cadastramento de pre-atendimento para classificacao de risco
        SELECT
            ta.CD_TRIAGEM_ATENDIMENTO,
            ta.CD_ATENDIMENTO,
            ta.CD_FILA_SENHA,
            ta.CD_FILA_PRINCIPAL,
            ta.CD_SETOR,
            -- ta.CD_USUARIO,
            a.NM_USUARIO,
            a.CD_PRESTADOR,
            a.CD_CONVENIO,
            a.TP_ATENDIMENTO,
            ta.DS_SENHA,
            ta.DH_PRE_ATENDIMENTO,
            ta.DH_PRE_ATENDIMENTO_FIM,
            ta.DH_CHAMADA_CLASSIFICACAO,
            ta.DH_REMOVIDO
        FROM DBAMV.TRIAGEM_ATENDIMENTO ta
        LEFT JOIN DBAMV.ATENDIME a ON ta.CD_ATENDIMENTO = a.CD_ATENDIMENTO
),
FILA
    AS (
        SELECT
            fs.CD_FILA_SENHA,
            fs.DS_FILA
        FROM DBAMV.FILA_SENHA fs
),
CLASSIFICACAO_RISCO
    AS (
        SELECT
            scr.CD_TRIAGEM_ATENDIMENTO,
            scr.CD_CLASSIFICACAO_RISCO,
            scr.CD_CLASSIFICACAO,
            scr.CD_COR_REFERENCIA,
            scr.DH_CLASSIFICACAO_RISCO
        FROM DBAMV.SACR_CLASSIFICACAO_RISCO scr
),
CLASSIFICACAO
    AS (
        SELECT
            sc.CD_CLASSIFICACAO,
            sc.DS_TIPO_RISCO
        FROM DBAMV.SACR_CLASSIFICACAO sc
),
COR
    AS (
        SELECT
            scr.CD_COR_REFERENCIA,
            scr.NM_COR,
            scr.DS_RGB_DECIMAL,
            scr.DS_RGB_HEXADECIMAL
        FROM DBAMV.SACR_COR_REFERENCIA scr
),
USUARIO
    AS (
        SELECT
            CD_USUARIO,
            NM_USUARIO
        FROM DBASGU.USUARIOS
),
PRESTADORESS
    AS (
        SELECT
            CD_PRESTADOR,
            NM_PRESTADOR
        FROM DBAMV.PRESTADOR
),
CONVENIOS
    AS (
        SELECT
            CD_CONVENIO,
            NM_CONVENIO
        FROM DBAMV.CONVENIO
),
PROCESSO_COM_TRIAGEM
     AS (
        SELECT
            tcam.CD_TEMPO_PROCESSO,
            tcam.CD_TRIAGEM_ATENDIMENTO,
            tcam.CD_ATENDIMENTO,
            tcam.CD_PRESTADOR,
            tcam.CD_CONVENIO,
            tcam.TP_ATENDIMENTO,
            tcam.NM_USUARIO,
            tcam.CD_TIPO_TEMPO_PROCESSO,
            COALESCE(tcam.DH_PROCESSO, tri.DH_PRE_ATENDIMENTO) AS DH_PROCESSO

        FROM TEMPO_TOTEM_CLASS_ADM_MED tcam
        INNER JOIN TRIAGEM tri ON tri.CD_TRIAGEM_ATENDIMENTO = tcam.CD_TRIAGEM_ATENDIMENTO
),
PROCESSO_SEM_TRIAGEM
    AS (
        SELECT
            tcam.*
        FROM TEMPO_TOTEM_CLASS_ADM_MED tcam
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TRIAGEM tri
                WHERE tri.CD_TRIAGEM_ATENDIMENTO = tcam.CD_TRIAGEM_ATENDIMENTO
        )
),
TRIAGEM_SEM_PROCESSO
    AS (
        SELECT
            tri.*
        FROM TRIAGEM tri
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TEMPO_TOTEM_CLASS_ADM_MED tcam
                WHERE tcam.CD_TRIAGEM_ATENDIMENTO = tri.CD_TRIAGEM_ATENDIMENTO
        )
),
UNION_HIPOTESES
    AS (
        SELECT
            'PROCESSO_COM_TRIAGEM' AS TIPO,
            tcam.CD_TRIAGEM_ATENDIMENTO,
            tcam.CD_ATENDIMENTO,
            tcam.NM_USUARIO,
            tcam.CD_PRESTADOR,
            tcam.CD_CONVENIO,
            tcam.TP_ATENDIMENTO,
            tcam.CD_TIPO_TEMPO_PROCESSO,
            tcam.DH_PROCESSO
        FROM PROCESSO_COM_TRIAGEM tcam

        UNION ALL

        SELECT
            'PROCESSO_SEM_TRIAGEM' AS TIPO,
            tcam.CD_TRIAGEM_ATENDIMENTO,
            tcam.CD_ATENDIMENTO,
            tcam.NM_USUARIO,
            tcam.CD_PRESTADOR,
            tcam.CD_CONVENIO,
            tcam.TP_ATENDIMENTO,
            tcam.CD_TIPO_TEMPO_PROCESSO,
            tcam.DH_PROCESSO
        FROM PROCESSO_SEM_TRIAGEM tcam

        UNION ALL

        SELECT
            'TRIAGEM_SEM_PROCESSO' AS TIPO,
            tri.CD_TRIAGEM_ATENDIMENTO,
            tri.CD_ATENDIMENTO,
            tri.NM_USUARIO,
            tri.CD_PRESTADOR,
            tri.CD_CONVENIO,
            tri.TP_ATENDIMENTO,
            NULL AS CD_TIPO_TEMPO_PROCESSO,
            NULL AS DH_PROCESSO
        FROM TRIAGEM_SEM_PROCESSO tri
),
TREATS
    AS (
        SELECT

            tcam.TIPO,

            tcam.CD_TRIAGEM_ATENDIMENTO,
            tcam.CD_ATENDIMENTO,

            CASE
                WHEN tcam.TP_ATENDIMENTO = 'U' THEN 'EMERGÊNCIA'
                WHEN tcam.TP_ATENDIMENTO = 'I' THEN 'INTERNAÇÃO'
                WHEN tcam.TP_ATENDIMENTO = 'A' THEN 'AMBULATÓRIO'
                WHEN tcam.TP_ATENDIMENTO = 'E' THEN 'EXTERNO'
                ELSE NULL
            END AS TP_ATENDIMENTO,

            tri.NM_USUARIO AS CD_USUARIO,
            u.NM_USUARIO,
            p.CD_PRESTADOR,
            p.NM_PRESTADOR,

            c.NM_CONVENIO,

            tcam.DH_PROCESSO,
            -- EXTRACT(MONTH FROM COALESCE(tcam.DH_PROCESSO, tri.DH_PRE_ATENDIMENTO)) AS MES,
            SUBSTR(TO_CHAR(COALESCE(tcam.DH_PROCESSO, tri.DH_PRE_ATENDIMENTO), 'FMMONTH', 'NLS_DATE_LANGUAGE=PORTUGUESE'), 1, 3) AS MES,
            EXTRACT(YEAR  FROM COALESCE(tcam.DH_PROCESSO, tri.DH_PRE_ATENDIMENTO)) AS ANO,

            ROUND((tcam.DH_PROCESSO
                - LAG(tcam.DH_PROCESSO) OVER (
                        PARTITION BY tcam.CD_TRIAGEM_ATENDIMENTO
                        ORDER BY tcam.DH_PROCESSO
                    )) * 24 * 60, 2) AS INTERVALO_TEMPO,

            CASE
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 20 THEN
                    'TE Guiche'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(21, 22) THEN
                    'TA Guiche'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 30 THEN
                    'TE Consulta'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(31, 32, 90) THEN
                    'TA Consulta'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 50 THEN
                    'TE Exame Laboratorio'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(51, 52) THEN
                    'TA Exame Laboratorio'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 60 THEN
                    'TE Exame Imagem'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(61, 62) THEN
                    'TA Exame Imagem'
                ELSE NULL
            END AS CLASSIFICACAO_PROCESSO,

            CASE
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 20 THEN
                    1
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(21, 22) THEN
                    2
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 30 THEN
                    3
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(31, 32, 90) THEN
                    4
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 50 THEN
                    5
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(51, 52) THEN
                    6
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 60 THEN
                    7
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(61, 62) THEN
                    8
            END AS ORDEM_PROCESSO,

            tcam.CD_TIPO_TEMPO_PROCESSO,
            tp.DS_TIPO_TEMPO_PROCESSO,
            tri.DH_PRE_ATENDIMENTO,
            tri.DH_PRE_ATENDIMENTO_FIM,
            tri.DH_CHAMADA_CLASSIFICACAO,
            tri.DH_REMOVIDO,
            tri.DS_SENHA,
            -- fs.DS_FILA,

            COALESCE(
                CASE
                    WHEN fs.CD_FILA_SENHA IN (2, 21, 3, 20)       THEN 'CLINICA 1'
                    WHEN fs.CD_FILA_SENHA IN (12, 22, 13, 19)     THEN 'CLINICA 2'
                    WHEN fs.CD_FILA_SENHA = 1                  THEN 'URGENCIA/EMERGENCIA'
                    ELSE NULL
                END,
                CASE
                    WHEN REGEXP_LIKE(fs.DS_FILA, '2') THEN 'CLINICA 2'
                    ELSE 'CLINICA 1'
                END
            ) AS CLINICA,

            CASE
                WHEN fs.CD_FILA_SENHA IN (2, 21, 12, 22)   THEN 'CONSULTA'
                WHEN fs.CD_FILA_SENHA IN (3, 20, 13, 19)   THEN 'EXAME'
                WHEN fs.CD_FILA_SENHA IN (4, 14)           THEN 'MARCAÇÃO CONSULTA/EXAMES'
                WHEN fs.CD_FILA_SENHA IN (7, 17)           THEN 'RETIRADA MAPA e HOLTER'
                WHEN fs.CD_FILA_SENHA IN (6,16)            THEN 'SOLICITAÇÃO DE DOCUMENTOS'
                WHEN fs.CD_FILA_SENHA = 23                 THEN 'ASO'
                ELSE fs.DS_FILA
            END AS FILA,

            sc.DS_TIPO_RISCO,
            co.NM_COR

        FROM UNION_HIPOTESES tcam
        LEFT JOIN TIPO_PROCESSO tp        ON tcam.CD_TIPO_TEMPO_PROCESSO  = tp.CD_TIPO_TEMPO_PROCESSO
        LEFT JOIN TRIAGEM tri             ON tcam.CD_TRIAGEM_ATENDIMENTO  = tri.CD_TRIAGEM_ATENDIMENTO

        LEFT JOIN FILA fs                 ON tri.CD_FILA_SENHA            = fs.CD_FILA_SENHA
        LEFT JOIN CLASSIFICACAO_RISCO scr ON tri.CD_TRIAGEM_ATENDIMENTO   = scr.CD_TRIAGEM_ATENDIMENTO
        LEFT JOIN CLASSIFICACAO sc        ON scr.CD_CLASSIFICACAO         = sc.CD_CLASSIFICACAO
        LEFT JOIN COR co                  ON scr.CD_COR_REFERENCIA        = co.CD_COR_REFERENCIA

        LEFT JOIN USUARIO u               ON tcam.NM_USUARIO              = u.CD_USUARIO
        LEFT JOIN PRESTADORESS p          ON tcam.CD_PRESTADOR            = p.CD_PRESTADOR
        LEFT JOIN CONVENIOS c             ON tcam.CD_CONVENIO             = c.CD_CONVENIO
        WHERE
            tcam.DH_PROCESSO >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12) AND
            tcam.DH_PROCESSO <  ADD_MONTHS(TRUNC(SYSDATE, 'MM'),  1)
),
AGRUPAMENTOS
    AS (
        SELECT
            TIPO,
            TO_DATE(DH_PROCESSO) AS DT,
            MES,
            ANO,
            NM_CONVENIO,
            TP_ATENDIMENTO,
            NM_USUARIO,
            NM_PRESTADOR,
            CLINICA,
            FILA,
            ORDEM_PROCESSO,
            CLASSIFICACAO_PROCESSO,
            NM_COR,
            SUM(INTERVALO_TEMPO) AS TEMPO_MINUTOS,
            COUNT(DISTINCT CD_TRIAGEM_ATENDIMENTO) AS QTD
        FROM TREATS
        WHERE
            INTERVALO_TEMPO IS NOT NULL
        GROUP BY
            TIPO,
            TO_DATE(DH_PROCESSO),
            NM_USUARIO,
            NM_PRESTADOR,
            MES,
            ANO,
            NM_CONVENIO,
            TP_ATENDIMENTO,
            CLINICA,
            FILA,
            ORDEM_PROCESSO,
            CLASSIFICACAO_PROCESSO,
            NM_COR
)
SELECT
    TIPO,
    DT,
    MES,
    ANO,
    NM_CONVENIO,
    TP_ATENDIMENTO,
    NM_USUARIO,
    NM_PRESTADOR,
    CLINICA,
    FILA,
    ORDEM_PROCESSO,
    CLASSIFICACAO_PROCESSO,
    NM_COR,
    CASE
        WHEN TEMPO_MINUTOS <   5 THEN 'Até 5 min'
        WHEN TEMPO_MINUTOS <  10 THEN 'Até 10 min'
        WHEN TEMPO_MINUTOS <  15 THEN 'Até 15 min'
        WHEN TEMPO_MINUTOS <  20 THEN 'Até 20 min'
        WHEN TEMPO_MINUTOS <  30 THEN 'Até 30 min'
        WHEN TEMPO_MINUTOS <  40 THEN 'Até 40 min'
        WHEN TEMPO_MINUTOS <  60 THEN 'Até 1h'
        WHEN TEMPO_MINUTOS < 120 THEN 'Até 2h'
        WHEN TEMPO_MINUTOS < 180 THEN 'Até 3h'
        WHEN TEMPO_MINUTOS < 240 THEN 'Até 4h'
        WHEN TEMPO_MINUTOS < 300 THEN 'Até 5h'
        WHEN TEMPO_MINUTOS < 360 THEN 'Até 6h'
        ELSE '> 6h'
    END AS BUCKET_TEMP,
    TEMPO_MINUTOS,
    QTD
FROM AGRUPAMENTOS
ORDER BY
    TIPO,
    DT,
    TP_ATENDIMENTO,
    NM_CONVENIO,
    NM_USUARIO,
    NM_PRESTADOR,
    MES,
    ANO,
    ORDEM_PROCESSO
;



SELECT
    *
FROM TREATS
WHERE DS_SENHA = 'PEX0049'; --'PCS0116' ;



SELECT
    *
FROM TREATS
WHERE
DH_PROCESSO > TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
ORDER BY
    CD_TRIAGEM_ATENDIMENTO DESC,
    CD_ATENDIMENTO,
    CD_TIPO_TEMPO_PROCESSO ASC
;



SEU SELECT FINAL AQUI
SELECT DISTINCT
    CD_TIPO_TEMPO_PROCESSO,
    DS_TIPO_TEMPO_PROCESSO,
    COUNT(*) OVER (PARTITION BY DS_TIPO_TEMPO_PROCESSO) AS QTD
FROM TREATS
WHERE DS_FILA LIKE '%ANGIO TC%'
ORDER BY CD_TIPO_TEMPO_PROCESSO
;




/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */




