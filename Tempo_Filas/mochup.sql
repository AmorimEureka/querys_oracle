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
        SELECT
            sttp.CD_TIPO_TEMPO_PROCESSO ,
            sttp.DS_TIPO_TEMPO_PROCESSO
        FROM
            DBAMV.SACR_TIPO_TEMPO_PROCESSO sttp
),
TRIAGEM
    AS (
        SELECT
            ta.CD_TRIAGEM_ATENDIMENTO ,
            ta.CD_ATENDIMENTO ,
            ta.CD_FILA_SENHA ,
            ta.CD_FILA_PRINCIPAL ,
            ta.CD_SETOR ,
            ta.DH_PRE_ATENDIMENTO ,
            ta.DH_PRE_ATENDIMENTO_FIM ,
            ta.DH_CHAMADA_CLASSIFICACAO ,
            ta.DH_REMOVIDO
        FROM DBAMV.TRIAGEM_ATENDIMENTO ta
),
FILA
    AS (
        SELECT
            fs.CD_FILA_SENHA ,
            fs.DS_FILA ,
            fs.DS_IDENTIFICADOR_FILA
        FROM DBAMV.FILA_SENHA fs
),
CLASSIFICACAO_RISCO
    AS (
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
        SELECT
            sc.CD_CLASSIFICACAO ,
            sc.DS_TIPO_RISCO
        FROM DBAMV.SACR_CLASSIFICACAO sc
),
COR
    AS (
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
            LAG(tcam.DH_PROCESSO) OVER (PARTITION BY tcam.CD_TRIAGEM_ATENDIMENTO ORDER BY tcam.DH_PROCESSO) AS PREV_DH_PROCESSO,
            ROUND((tcam.DH_PROCESSO - LAG(tcam.DH_PROCESSO) OVER (PARTITION BY tcam.CD_TRIAGEM_ATENDIMENTO ORDER BY tcam.DH_PROCESSO)) * 24 * 60, 2) AS INTERVALO_TEMPO,
            tp.DS_TIPO_TEMPO_PROCESSO ,
            tri.DH_PRE_ATENDIMENTO ,
            tri.DH_PRE_ATENDIMENTO_FIM ,
            tri.DH_CHAMADA_CLASSIFICACAO ,
            tri.DH_REMOVIDO ,
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
),
FILTROS AS (
    SELECT
        NM_COR,
        ANO || '-' || MES AS ANO_MES,
        CLINICA,
        ATEND_AMBULATORIAL,
        COUNT(*) AS QTD
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
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */
/* ******************************************************************************************************* */







