

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








