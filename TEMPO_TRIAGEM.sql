-- Query 'Tempo de Processo' do Painel "HPC-CLINICA-Tempo Médio de Atendimento"
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

-- Query 'Triagem Desistentes' do Painel "HPC-CLINICA-Tempo Médio de Atendimento"
SELECT a.CD_ATENDIMENTO COD_ATEND,
a.CD_PACIENTE COD_PAC,
a.CD_CONVENIO COD_CONV,
a.DT_ATENDIMENTO D_ATENDIMENTO,
a.HR_ATENDIMENTO DH_ATENDIMENTO,
CASE
       WHEN A.TP_ATENDIMENTO = 'A' THEN 'AMBULATORIO'
       WHEN A.TP_ATENDIMENTO = 'E' THEN 'EXAMES'
       WHEN A.TP_ATENDIMENTO = 'U' THEN 'URGENCIA/EMERGENCIA'
       WHEN A.TP_ATENDIMENTO = 'I' THEN 'INTERNACAO'
       END AS tipo,
ac.DT_CHAMADA D_CHAMADA_CONSULT,
ta.QT_CHAMADAS QNT_CHAMADAS,
ta.SN_PRIORIDADE_OCTO SN_PRIORIDADE,
ta.DH_PRE_ATENDIMENTO DT_PRE_ATEND,
ta.NM_PACIENTE,
d.NM_USUARIO NM_ATENDENTE,
p.NM_PRESTADOR
FROM ATENDIME a
LEFT JOIN ATENDIME_CHAMADA_PAINEL ac ON a.CD_ATENDIMENTO = ac.CD_ATENDIMENTO
LEFT JOIN TRIAGEM_ATENDIMENTO ta ON a.CD_ATENDIMENTO = ta.CD_ATENDIMENTO
LEFT JOIN PRESTADOR p ON a.CD_PRESTADOR = p.CD_PRESTADOR
LEFT JOIN dbasgu.usuarios d ON a.NM_USUARIO = d.CD_USUARIO ;


-- Query 'Triagem Atendimento' do Painel "HPC-CLINICA-Tempo Médio de Atendimento"
SELECT DISTINCT
  a.cd_atendimento AS cod_atend,
  ta.cd_triagem_atendimento,
  a.cd_paciente AS cod_pac,
  a.cd_convenio AS cod_conv,
  c.nm_convenio,
  CASE
    WHEN a.tp_atendimento = 'A' THEN 'AMBULATORIO'
    WHEN a.tp_atendimento = 'E' THEN 'EXAMES'
    WHEN a.tp_atendimento = 'U' THEN 'URGENCIA/EMERGENCIA'
    WHEN a.tp_atendimento = 'I' THEN 'INTERNACAO'
  END AS tipo,
  ta.qt_chamadas AS qnt_chamadas,
  ta.sn_prioridade_octo AS sn_prioridade,
  INITCAP(ta.nm_paciente) AS nm_paciente,
  INITCAP(d.nm_usuario) AS nm_atendente,
  INITCAP(p.nm_prestador) AS nm_prestador,
  ta.nm_paciente || '_' || TO_CHAR(a.dt_atendimento, 'DD-MM-YYYY') AS paciente_hora
FROM atendime a
LEFT JOIN atendime_chamada_painel ac ON a.cd_atendimento = ac.cd_atendimento
LEFT JOIN triagem_atendimento ta ON a.cd_atendimento = ta.cd_atendimento
LEFT JOIN prestador p ON a.cd_prestador = p.cd_prestador
LEFT JOIN dbasgu.usuarios d ON a.nm_usuario = d.cd_usuario
LEFT JOIN convenio c ON c.cd_convenio = a.cd_convenio
WHERE ta.nm_paciente IS NOT NULL ;


-- Query 'Agendados' do Painel "HPC-CLINICA-Tempo Médio de Atendimento"
SELECT
    i.cd_atendimento,
    MIN(i.hr_agenda) hr_agenda,
    i.cd_paciente,
    INITCAP(i.nm_paciente) AS nm_paciente,
    --i.cd_convenio,
    --c.nm_convenio,
    --a.cd_prestador,
    --INITCAP(pr.nm_prestador) AS nm_prestador,
    i.nm_paciente || '_' || TO_CHAR(i.hr_agenda, 'DD-MM-YYYY') AS paciente_hora
FROM
    dbamv.it_agenda_central i
LEFT JOIN
    dbamv.agenda_central a ON i.cd_agenda_central = a.cd_agenda_central
LEFT JOIN
    dbamv.item_agendamento ia ON i.cd_item_agendamento = ia.cd_item_agendamento
LEFT JOIN
    dbamv.setor s ON s.cd_setor = a.cd_setor
LEFT JOIN
    dbamv.convenio c ON c.cd_convenio = i.cd_convenio
LEFT JOIN
    dbasgu.usuarios u ON u.cd_usuario = a.cd_usuario
LEFT JOIN
    dbamv.recurso_central r ON r.cd_recurso_central = a.cd_recurso_central
LEFT JOIN
    dbamv.tip_mar t ON t.cd_tip_mar = i.cd_tip_mar
LEFT JOIN
    dbamv.prestador pr ON pr.cd_prestador = a.cd_prestador
LEFT JOIN
    (
        SELECT a.cd_atendimento,
            p.nm_paciente ||'_'||TO_CHAR(a.dt_atendimento, 'DD-MM-YYYY') chave_atendimento,
            a.dt_atendimento
        FROM atendime a
        LEFT JOIN
            paciente p ON p.cd_paciente = a.cd_paciente
    ) at ON at.chave_atendimento = i.nm_paciente ||'_'||TO_CHAR(i.hr_agenda, 'DD-MM-YYYY')
LEFT JOIN
    atendime_chamada_painel acp ON acp.cd_atendimento = at.cd_atendimento
WHERE
    nm_paciente IS NOT NULL
    AND i.sn_atendido = 'S'
    AND i.cd_atendimento IS NOT NULL
GROUP BY
    i.cd_atendimento,
    i.cd_paciente,
    INITCAP(i.nm_paciente),
    --i.cd_convenio,
    --c.nm_convenio,
    --a.cd_prestador,
    --INITCAP(pr.nm_prestador),
    i.nm_paciente || '_' || TO_CHAR(i.hr_agenda, 'DD-MM-YYYY') ;


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

















