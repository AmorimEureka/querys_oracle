


WITH mobile AS (
		-- DT_ENVIO DA DRMOBILE.DRMOBILE_MENSAGEM e DT_CONTATO DA DBAMV.REGISTRO_CONTATO REGISTRAM 
		-- OS CONTATOS DAS MARCAÇÕES DE AGENDA DOS PRÓXIMOS 2 DIAS NA AGENDA
		SELECT
			ic.cd_it_agenda_central,
			-- rc.cd_registro_vinculado,
			ac.cd_agenda_central,
			-- ic.cd_agenda_central,
			pa.cd_paciente,
			ic.nm_paciente AS nome_agenda,
			rc.nm_paciente AS nome_registro_contato,
    		p.nm_prestador,                                                                                                   
			ic.cd_atendimento,
			rc.cd_registro_vinculado,
			ic.hr_agenda AS dt_agenda,
			rc.dt_contato,
			rc.ds_assunto,
			ac.cd_setor,
			s.nm_setor,
			COALESCE(pa.nr_ddd_celular || pa.nr_celular, ic.nr_ddd_celular || ic.nr_celular, ic.nr_ddd_fone || ic.nr_fone) AS telefone,
			CASE
				WHEN ic.cd_paciente IS NOT NULL AND ic.nm_paciente IS NOT NULL THEN 
					'paciente antigo'
				WHEN ic.cd_paciente IS NULL	AND ic.nm_paciente IS NOT NULL THEN
					'novo paciente'
				ELSE ''
			END AS tipo_paciente,
			CASE
				WHEN p.nm_prestador IS NOT NULL THEN 
					'consulta'
				ELSE 'exames'
			END AS tipo_atendimento,
			CASE
				WHEN rc.ds_assunto LIKE '%Cancelamento pelo WhatsApp%' THEN 'cancelado'
				WHEN rc.ds_assunto LIKE '%Cancelamento pelo Whatsapp%' THEN 'cancelado'
				WHEN rc.ds_assunto LIKE '%CONFIMAÇÃO DE CONSULTA%'
				OR rc.ds_assunto LIKE '%CONFIMAÇÃO DE CONSULTA%' THEN 'confirmado'
				WHEN rc.ds_assunto LIKE '%Confirmacao pelo WhatsApp%'
				OR rc.ds_assunto LIKE '%Confirmacao pelo WhatsApp%' THEN 'confirmado'
				WHEN rc.ds_assunto LIKE '%Confirmação pelo WhatsApp%'
				OR rc.ds_assunto LIKE '%Confirmação pelo WhatsApp%' THEN 'confirmado'
				WHEN rc.ds_assunto LIKE '%Envio de notificacao ativa pelo WhatsAppp%'
				OR rc.ds_assunto LIKE '%Envio de notificacao ativa pelo WhatsApp%' THEN 'sem resposta'
				WHEN rc.ds_assunto LIKE '%Envio de notificação ativa pelo WhatsApp%'
				OR rc.ds_assunto LIKE '%Envio de notificação ativa pelo WhatsApp%' THEN 'sem resposta'
				ELSE 'Sem Envio'
			END AS tipo_confirmacao,
			CASE
				WHEN ic.nm_paciente IS NULL	OR TRIM(ic.nm_paciente) = '' THEN 
					'vago' 
				ELSE 'ocupado'
			END AS status_paciente,
			CASE
				WHEN (
						SELECT
							count(*)
						FROM
							dbamv.registro_contato subrc
						WHERE
							subrc.cd_registro_vinculado = ic.cd_it_agenda_central
							AND subrc.cd_usuario = 'DRMOBILE'
							AND subrc.nm_paciente = ic.nm_paciente) > 0 THEN 
					 'Enviado'
				ELSE 'Não Enviado'
			END AS status_envio,
			ic.hr_agenda
		FROM 	
			dbamv.it_agenda_central ic            -- Agendamentos (horários) de pacientes e procedimentos da Central de marcações
		LEFT JOIN dbamv.registro_contato rc ON    -- Tabela para registros de contatos com os pacientes - DR Mobile
			ic.cd_it_agenda_central = rc.cd_registro_vinculado
		LEFT JOIN dbamv.agenda_central ac ON      -- Agenda de Horários da Central de Marcações
			ac.cd_agenda_central = ic.cd_agenda_central
		LEFT JOIN dbamv.prestador p ON
			ac.cd_prestador = p.cd_prestador
		LEFT JOIN dbamv.setor s ON
			ac.cd_setor = s.cd_setor
		LEFT JOIN dbamv.paciente pa ON
			ic.cd_paciente = pa.cd_paciente
		WHERE
			ic.cd_it_agenda_pai IS NULL
			AND TO_CHAR(ic.hr_agenda, 'MM/YYYY') ='11/2024'
			AND (rc.cd_registro_contato, rc.nm_paciente) IN (
									SELECT
										Max(rcsub.cd_registro_contato),
										rcsub.nm_paciente
									FROM
										dbamv.registro_contato rcsub
									WHERE
										rcsub.nm_paciente = rc.nm_paciente
									GROUP BY
										rcsub.nm_paciente)
		ORDER BY
			ic.nm_paciente
)
SELECT
    *
	-- TRUNC(dt_agenda) AS COMP,
	-- TIPO_ATENDIMENTO,
	-- TIPO_CONFIRMACAO,
	-- COUNT(*) AS qtd
FROM
	mobile
WHERE
    TIPO_CONFIRMACAO = 'confirmado' AND hr_agenda BETWEEN TO_DATE('2024-11-14', 'YYYY-MM-DD') AND TO_DATE('2024-11-15', 'YYYY-MM-DD')
/*WHERE TIPO_ATENDIMENTO = 'exames'*/
-- GROUP BY TRUNC(dt_agenda), TIPO_ATENDIMENTO, TIPO_CONFIRMACAO
ORDER BY 1, 2 , 3
;



-- REGISTRA OS CONTATOS FEITOS NO 'DBAMV'
SELECT * FROM dbamv.registro_contato rc WHERE TO_DATE(rc.DT_CONTATO, 'YYYY-MM-DD') BETWEEN TO_DATE('2024-11-11', 'YYYY-MM-DD') AND TO_DATE('2024-11-12', 'YYYY-MM-DD') ;
SELECT * FROM dbamv.registro_contato rc WHERE rc.DT_CONTATO BETWEEN TRUNC(SYSDATE + 30) AND TRUNC(SYSDATE + 30) + 0.99999 ;

-- MENSAGENS ENVIADAS PELO DR_MOBILE NO 'DRMOBILE'
SELECT * FROM DRMOBILE.DRMOBILE_MENSAGEM rc WHERE TO_DATE(rc.DT_ENVIO, 'YYYY-MM-DD') BETWEEN TO_DATE('2024-11-11', 'YYYY-MM-DD') AND TO_DATE('2024-11-12', 'YYYY-MM-DD') ;
SELECT * FROM DRMOBILE.DRMOBILE_MENSAGEM rc WHERE rc.DT_ENVIO BETWEEN TRUNC(SYSDATE + 30) AND TRUNC(SYSDATE + 30) + 0.99999;

	








	
