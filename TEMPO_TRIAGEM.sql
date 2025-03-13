SELECT
--	'<span style="font-size: 95px;' || '">' || Nvl(Sum(Quant), 0) || '</span>' quantidade
	Nvl(Sum(Quant), 0) quantidade
FROM
	(
	SELECT
		sacr_tempo_processo.cd_triagem_atendimento,
		Count(*) quant
	FROM
		dbamv.sacr_tempo_processo,
		dbamv.triagem_atendimento
	WHERE
		sacr_tempo_processo.cd_triagem_atendimento = triagem_atendimento.cd_triagem_atendimento
		AND trunc(triagem_atendimento.dh_pre_atendimento) = trunc(SYSDATE)
		AND triagem_atendimento.cd_multi_empresa IN(1)
		AND triagem_atendimento.cd_fila_senha IN(1)
	GROUP BY
		sacr_tempo_processo.cd_triagem_atendimento
	HAVING
		Count(*) = 1) ;


-- Cadastramento de pre-atendimento para classificacao de risco
SELECT * FROM triagem_atendimento WHERE DS_SENHA = 'UR0012';


-- Armazena as filas para geração de senhas
SELECT * FROM FILA_SENHA ;

-- Armazena os tempos do processo de atendimento do paciente
SELECT * FROM sacr_tempo_processo ;


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





-- Query 'Tempo de Processo' do Painel HPC-CLINICA-Tempo Médio de Atendimento
SELECT
  stp.cd_triagem_atendimento,
  stp.cd_atendimento,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'CADASTRO NO TOTEM' THEN stp.dh_processo END) AS cad_totem,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO ADMINISTRATIVO CHAMADA' THEN stp.dh_processo END) AS adm_chamada,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO ADMINISTRATIVO INÍCIO' THEN stp.dh_processo END) AS adm_início,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO ADMINISTRATIVO FINAL' THEN stp.dh_processo END) AS adm_final,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO MÉDICO CHAMADA' THEN stp.dh_processo END) AS méd_chamada,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO MÉDICO INÍCIO' THEN stp.dh_processo END) AS méd_início,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO MÉDICO ALTA' THEN stp.dh_processo END) AS méd_alta,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO MÉDICO FINAL' THEN stp.dh_processo END) AS méd_final,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME IMAGEM CHAMADA' THEN stp.dh_processo END) AS img_chamada,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME DE IMAGEM INÍCIO' THEN stp.dh_processo END) AS img_início,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME DE IMAGEM FINAL' THEN stp.dh_processo END) AS img_final,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME LABORATORIAL INÍCIO' THEN stp.dh_processo END) AS lab_início,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME LABORATORIAL CHAMADA' THEN stp.dh_processo END) AS lab_chamada,
  MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME LABORATORIAL FINAL' THEN stp.dh_processo END) AS lab_final
FROM sacr_tempo_processo stp
LEFT JOIN sacr_tipo_tempo_processo sttp ON stp.cd_tipo_tempo_processo = sttp.cd_tipo_tempo_processo
WHERE stp.cd_atendimento IS NOT NULL
AND stp.cd_triagem_atendimento IS NOT NULL
GROUP BY stp.cd_triagem_atendimento, stp.cd_atendimento ;












