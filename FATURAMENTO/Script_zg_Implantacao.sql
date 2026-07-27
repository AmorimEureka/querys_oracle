--ALTER SESSION SET CURRENT_SCHEMA = DBAMV;
-- 
CREATE OR REPLACE FORCE VIEW vw_zg_contas_bancarias
			(
			 versao,
			 cd_con_cor,
			 ds_con_cor,
			 cd_banco,
			 nm_banco,
			 cd_agencia,
			 digito_agencia,
			 nr_conta,
			 digito_conta_corrente,
			 cd_multi_empresa
				)
AS
SELECT '1.0.0'                                 AS versao,
	conta_corrente.cd_con_cor               AS cd_con_cor,
	conta_corrente.ds_con_cor               AS ds_con_cor,
	banco.cd_banco                          AS cd_banco,
	banco.nm_banco                          AS nm_banco,
	conta_corrente.cd_agencia               AS cd_agencia,
	conta_corrente.cd_digito_agencia        AS digito_agencia,
	conta_corrente.nr_conta                 AS nr_conta,
	conta_corrente.cd_digito_conta_corrente AS digito_conta_corrente,
	conta_corrente.cd_multi_empresa         AS cd_multi_empresa
FROM dbamv.con_cor conta_corrente
		 JOIN dbamv.banco
ON conta_corrente.cd_banco = banco.cd_banco;


CREATE OR REPLACE FORCE VIEW vw_zg_guias_tiss_ambulatorio (
        versao,
        versao_tiss,
        numero_lote,
        codigo_guia_tiss,
        remessa,
        codigo_convenio,
        cd_guia,
        numero_conta,
        codigo_atendimento,
        nome_hospital,
        matricula_beneficiario,
        nome_beneficiario,
        numero_guia_prestador,
        numero_guia_operadora,
        numero_guia_tiss,
        numero_guia_envio_operadora,
        numero_guia_principal,
        numero_guia_sol,
        senha_guia,
        data_emissao_guia,
        valor_total
) AS
SELECT
    '2.0.0'                                                                 AS versao,
    coalesce(mensagem_tiss.cd_versao, mensagem_tiss_remessa.cd_versao)        AS versao_tiss,
    coalesce(lote_tiss.nr_lote, mensagem_tiss_remessa.nr_lote)              AS numero_lote,
    guia_tiss.id                                                            AS codigo_guia_tiss,
    guia_tiss.cd_remessa                                                    AS remessa,
    guia_tiss.cd_convenio                                                   AS codigo_convenio,
    guia_tiss.cd_guia                                                       AS cd_guia,
    guia_tiss.cd_reg_amb                                                    AS numero_conta,
    guia_tiss.cd_atendimento                                                AS codigo_atendimento,
    guia_tiss.nm_prestador_contratado                                       AS nome_hospital,
    guia_tiss.nr_carteira                                                   AS matricula_beneficiario,
    guia_tiss.nm_paciente                                                   AS nome_beneficiario,
    LTRIM(COALESCE(guia_tiss.nr_guia,
                   guia_tiss.nr_guia_principal,
                   guia_tiss.nr_guia_sol), '0')                             AS numero_guia_prestador,
    LTRIM(COALESCE(guia_tiss.nr_guia_operadora,
                   guia_tiss.nr_guia_principal,
                   guia_tiss.nr_guia_sol), '0')                             AS numero_guia_operadora,
    guia_tiss.nr_guia                                                       AS numero_guia_tiss,
    guia_tiss.nr_guia_operadora                                             AS numero_guia_envio_operadora,
    guia_tiss.nr_guia_principal                                             AS numero_guia_principal,
    guia_tiss.nr_guia_sol                                                   AS numero_guia_sol,
    guia_tiss.cd_senha                                                      AS senha_guia,
    guia_tiss.dt_emissao                                                    AS data_emissao_guia,
    TO_NUMBER(REPLACE(TO_CHAR(NVL(guia_tiss.vl_tot_geral, '0')), '.', ',')) AS valor_total
FROM dbamv.tiss_guia guia_tiss
         LEFT JOIN dbamv.tiss_lote lote_tiss
                   ON lote_tiss.id = guia_tiss.id_pai
         LEFT JOIN dbamv.tiss_mensagem mensagem_tiss
                   ON mensagem_tiss.id = lote_tiss.id_pai
                       AND mensagem_tiss.tp_transacao = 'ENVIO_LOTE_GUIAS'
                       AND mensagem_tiss.ds_motivo_cancelamento IS NULL
         LEFT JOIN (select nr_documento as remessa, max(nr_lote) nr_lote, max(cd_versao) cd_versao
                    from dbamv.tiss_mensagem mensagem_tiss
                    where mensagem_tiss.tp_transacao = 'ENVIO_LOTE_GUIAS'
                      AND mensagem_tiss.ds_motivo_cancelamento IS NULL
                    group by nr_documento
) mensagem_tiss_remessa
                   ON (mensagem_tiss_remessa.remessa = to_char(guia_tiss.cd_remessa)
                       AND lote_tiss.id is null
                       )
WHERE
        NVL(mensagem_tiss.cd_status, 'PS') IN ('PS', 'ES', 'PE')
  AND guia_tiss.cd_reg_fat IS NULL;
 
CREATE OR REPLACE FORCE VIEW vw_zg_guias_tiss_internacao (
        versao,
        versao_tiss,
        numero_lote,
        codigo_guia_tiss,
        remessa,
        codigo_convenio,
        cd_guia,
        numero_conta,
        codigo_atendimento,
        nome_hospital,
        matricula_beneficiario,
        nome_beneficiario,
        numero_guia_prestador,
        numero_guia_operadora,
        numero_guia_tiss,
        numero_guia_envio_operadora,
        numero_guia_principal,
        numero_guia_sol,
        senha_guia,
        data_emissao_guia,
        valor_total
) AS
SELECT
    '2.0.0'                                                                 AS versao,
    coalesce(mensagem_tiss.cd_versao, mensagem_tiss_remessa.cd_versao)        AS versao_tiss,
    coalesce(lote_tiss.nr_lote, mensagem_tiss_remessa.nr_lote)              AS numero_lote,
    guia_tiss.id                                                            AS codigo_guia_tiss,
    guia_tiss.cd_remessa                                                    AS remessa,
    guia_tiss.cd_convenio                                                   AS codigo_convenio,
    guia_tiss.cd_guia                                                       AS cd_guia,
    guia_tiss.cd_reg_fat                                                    AS numero_conta,
    guia_tiss.cd_atendimento                                                AS codigo_atendimento,
    guia_tiss.nm_prestador_contratado                                       AS nome_hospital,
    guia_tiss.nr_carteira                                                   AS matricula_beneficiario,
    guia_tiss.nm_paciente                                                   AS nome_beneficiario,
    LTRIM(COALESCE(guia_tiss.nr_guia,
                   guia_tiss.nr_guia_principal,
                   guia_tiss.nr_guia_sol), '0')                             AS numero_guia_prestador,
    LTRIM(COALESCE(guia_tiss.nr_guia_operadora,
                   guia_tiss.nr_guia_principal,
                   guia_tiss.nr_guia_sol), '0')                             AS numero_guia_operadora,
    guia_tiss.nr_guia                                                       AS numero_guia_tiss,
    guia_tiss.nr_guia_operadora                                             AS numero_guia_envio_operadora,
    guia_tiss.nr_guia_principal                                             AS numero_guia_principal,
    guia_tiss.nr_guia_sol                                                   AS numero_guia_sol,
    guia_tiss.cd_senha                                                      AS senha_guia,
    guia_tiss.dt_emissao                                                    AS data_emissao_guia,
    TO_NUMBER(REPLACE(TO_CHAR(NVL(guia_tiss.vl_tot_geral, '0')), '.', ',')) AS valor_total
FROM dbamv.tiss_guia guia_tiss
         LEFT JOIN dbamv.tiss_lote lote_tiss
                   ON lote_tiss.id = guia_tiss.id_pai
         LEFT JOIN dbamv.tiss_mensagem mensagem_tiss
                   ON mensagem_tiss.id = lote_tiss.id_pai
                       AND mensagem_tiss.tp_transacao = 'ENVIO_LOTE_GUIAS'
                       AND mensagem_tiss.ds_motivo_cancelamento IS NULL
         LEFT JOIN (select nr_documento as remessa, max(nr_lote) nr_lote, max(cd_versao) cd_versao
                    from dbamv.tiss_mensagem mensagem_tiss
                    where mensagem_tiss.tp_transacao = 'ENVIO_LOTE_GUIAS'
                      AND mensagem_tiss.ds_motivo_cancelamento IS NULL
                    group by nr_documento
) mensagem_tiss_remessa
                   ON (mensagem_tiss_remessa.remessa = to_char(guia_tiss.cd_remessa)
                       AND lote_tiss.id is null
                       )
WHERE NVL(mensagem_tiss.cd_status, 'PS') IN ('PS', 'ES', 'PE')
  AND guia_tiss.cd_reg_amb IS NULL;
 
CREATE OR REPLACE FORCE VIEW vw_zg_itens_ambulatorio (
													  versao,
													  cd_guia,
													  numero_guia_primario,
													  data_emissao_guia,
													  data_atendimento_guia,
													  data_saida_guia,
													  cd_regra,
													  cd_multi_empresa,
													  remessa,
													  sn_fechada,
													  sn_fechada_item,
													  codigo_convenio,
													  numero_conta,
													  numero_conta_tab_tiss,
													  tp_atendimento,
													  tipo_guia,
													  numero_atendimento,
													  codigo_atendimento,
													  cd_solicitante,
													  matricula_beneficiario,
													  numero_guia_envio_ate,
													  cd_tab_fat,
													  fatura,
													  id_it_envio,
													  agrupador_envio,
													  codigo_lancamento,
													  cd_guia_item,
													  tp_pagamento,
													  sn_pertence_pacote,
													  data_atendimento_item,
													  hora_atendimento_item,
													  cd_item_mv_func,
													  ds_item_mv_func,
													  cd_gru_fat,
													  quantidade_item,
													  valor_unitario_item,
													  vl_nota,
													  valor_total_item,
													  cd_executante,
													  atividade_medica_executante,
													  id_it_envio_honorario,
													  cd_reg_fat_honorario,
													  eh_honorario,
													  grau_participacao,
													  cd_tuss,
													  ds_tuss,
													  cd_tabela_cb,
													  cd_simpro1,
													  ds_simpro1,
													  cd_simpro2,
													  ds_simpro2,
													  nome_tabela,
													  cd_tabela_tiss1,
													  cd_tabela_tiss2,
													  cd_brasindice,
													  ds_brasindice_medicamento,
													  ds_brasindice_apresentacao,
													  ds_brasindice_laboratorio,
													  ds_codigo_cobranca,
													  ds_nome_cobranca,
													  ds_brasindice,
													  codigo_item_sistema,
													  cd_gru_pro,
													  grupo_faturamento,
													  nome_produto,
													  ds_unidade,
													  tpservico,
													  plano_beneficiario,
													  nome_beneficiario,
													  codigo_cc,
													  descricao_cc,
													  codigo_medico_solicitante,
													  crm_solicitante,
													  nome_solicitante,
													  codigo_medico_executante,
													  crm_executante,
													  nome_executante
	) AS
SELECT
	'2.1.0'                                                                                                     AS versao,
	NVL(item_reg_amb.cd_guia, atendimento.cd_guia)                                                              AS cd_guia,
	guia.nr_guia                                                                                                AS numero_guia_primario,
	guia.dt_solicitacao                                                                                         AS data_emissao_guia,
	reg_amb.dt_lancamento                                                                                       AS data_atendimento_guia,
	reg_amb.dt_lancamento_final                                                                                 AS data_saida_guia,
	NVL(reg_amb.cd_regra, plano_convenio.cd_regra)                                                              AS cd_regra,
	reg_amb.cd_multi_empresa                                                                                    AS cd_multi_empresa,
	reg_amb.cd_remessa                                                                                          AS remessa,
	reg_amb.sn_fechada                                                                                          AS sn_fechada,
	item_reg_amb.sn_fechada                                                                                     AS sn_fechada_item,
	reg_amb.cd_convenio                                                                                         AS codigo_convenio,
	reg_amb.cd_reg_amb                                                                                          AS numero_conta,
	reg_amb.cd_reg_amb                                                                                          AS numero_conta_tab_tiss,
	atendimento.tp_atendimento                                                                                  AS tp_atendimento,
	DECODE(atendimento.tp_atendimento,
		   'A', 'Ambulatorial',
		   'E', 'Exame',
		   'I', 'Interno',
		   'U', 'Urgencia',
		   'Externo'
		)                                                                                                           AS tipo_guia,
	TO_CHAR(atendimento.cd_atendimento)                                                                         AS numero_atendimento,
	atendimento.cd_atendimento                                                                                  AS codigo_atendimento,
	atendimento.cd_prestador                                                                                    AS cd_solicitante,
	atendimento.nr_carteira                                                                                     AS matricula_beneficiario,
	LTRIM(atendimento.nr_guia_envio_principal, '0')                                                             AS numero_guia_envio_ate,
	item_regra.cd_tab_fat                                                                                       AS cd_tab_fat,
	item_reg_amb.cd_reg_amb                                                                                     AS fatura,
	item_reg_amb.id_it_envio                                                                                    AS id_it_envio,
	TO_CHAR(item_reg_amb.id_it_envio)                                                                           AS agrupador_envio,
	item_reg_amb.cd_lancamento                                                                                  AS codigo_lancamento,
	item_reg_amb.cd_guia                                                                                        AS cd_guia_item,
	item_reg_amb.tp_pagamento                                                                                   AS tp_pagamento,
	item_reg_amb.sn_pertence_pacote                                                                             AS sn_pertence_pacote,
	TO_DATE(TO_CHAR(reg_amb.dt_lancamento, 'dd-mm-yyyy'), 'dd-mm-yyyy')                                         AS data_atendimento_item,
	TO_DATE(TO_CHAR(item_reg_amb.hr_lancamento, 'HH24-Mi'), 'HH24-Mi')                                          AS hora_atendimento_item,
	dbamv.pkg_ffcv_tiss_pii.fnc_traduz_proc('C', item_reg_amb.cd_atendimento, reg_amb.cd_reg_amb,
											item_reg_amb.cd_lancamento, NULL, NULL, NULL, NULL, NULL)           AS cd_item_mv_func,
	dbamv.pkg_ffcv_tiss_pii.fnc_traduz_proc('D', item_reg_amb.cd_atendimento, reg_amb.cd_reg_amb,
											item_reg_amb.cd_lancamento, NULL, NULL, NULL, NULL, NULL)           AS ds_item_mv_func,
	item_reg_amb.cd_gru_fat                                                                                     AS cd_gru_fat,
	item_reg_amb.qt_lancamento                                                                                  AS quantidade_item,
	item_reg_amb.vl_unitario                                                                                    AS valor_unitario_item,
	item_reg_amb.vl_nota                                                                                        AS vl_nota,
	item_reg_amb.vl_total_conta                                                                                 AS valor_total_item,
	item_reg_amb.cd_prestador                                                                                   AS cd_executante,
	item_reg_amb.cd_ati_med                                                                                     AS atividade_medica_executante,
	NULL                                                                                                        AS id_it_envio_honorario,
	NULL                                                                                                        AS cd_reg_fat_honorario,
	'false'                                                                                                     AS eh_honorario,
	NULL                                                                                                        AS grau_participacao,
	procedimento_tuss.cd_pro_tuss                                                                               AS cd_tuss,
	procedimento_tuss.ds_pro_tuss                                                                               AS ds_tuss,
	pro_fat_hierarquizado.cd_pro_fat_hierarquizado                                                              AS cd_tabela_cb,
	tabela_simpro.cd_simpro                                                                                     AS cd_simpro1,
	simpro.ds_simpro                                                                                            AS ds_simpro1,
	(SELECT MAX(imp.cd_simpro)
	 FROM dbamv.imp_simpro imp
	 WHERE imp.cd_pro_fat = produto_faturado.cd_pro_fat)                                                        AS cd_simpro2,
	(SELECT MAX(smp.ds_simpro)
	 FROM dbamv.imp_simpro imp
			  JOIN dbamv.simpro smp
	 ON smp.cd_simpro = imp.cd_simpro
	 WHERE imp.cd_pro_fat = produto_faturado.cd_pro_fat)                                                        AS ds_simpro2,
	NVL(
			(SELECT MAX(config_tiss_convenio.tp_trad_apr_proced)
			 FROM dbamv.config_tiss_conv_aprs_pcd config_tiss_convenio
			 WHERE config_tiss_convenio.cd_convenio = reg_amb.cd_convenio
					 AND config_tiss_convenio.tp_gru_pro_apr_proced = tpservico.tp_gru_pro),
			(SELECT MAX(config_tiss_convenio.tp_trad_apr_proced)
			 FROM dbamv.config_tiss_conv_aprs_pcd config_tiss_convenio
			 WHERE config_tiss_convenio.cd_convenio = reg_amb.cd_convenio
					 AND config_tiss_convenio.tp_tab_tiss_apr_proced = tabela_faturamento.tp_tab_fat_tiss)
		)                                                                                                           AS nome_tabela,
	NVL(
			(SELECT MAX(config_tiss_convenio.tp_tab_tiss_apr_proced)
			 FROM dbamv.config_tiss_conv_aprs_pcd config_tiss_convenio
			 WHERE config_tiss_convenio.cd_convenio = reg_amb.cd_convenio
					 AND config_tiss_convenio.tp_gru_pro_apr_proced = tpservico.tp_gru_pro),
			(SELECT MAX(config_tiss_convenio.tp_tab_tiss_apr_proced)
			 FROM dbamv.config_tiss_conv_aprs_pcd config_tiss_convenio
			 WHERE config_tiss_convenio.cd_convenio = reg_amb.cd_convenio
					 AND config_tiss_convenio.tp_tab_tiss_apr_proced = tabela_faturamento.tp_tab_fat_tiss)
		)                                                                                                           AS cd_tabela_tiss1,
	tabela_faturamento.tp_tab_fat_tiss                                                                          AS cd_tabela_tiss2,
	tabela_brasindice.cd_tiss                                                                                   AS cd_brasindice,
	tabela_brasindice_medicamento.ds_medicamento                                                                AS ds_brasindice_medicamento,
	tabela_brasindice_apresentacao.ds_apresentacao                                                              AS ds_brasindice_apresentacao,
	tabela_brasindice_laboratorio.ds_laboratorio                                                                AS ds_brasindice_laboratorio,
	NVL(
			dados_produto_convenio.ds_codigo_cobranca,
			(SELECT MAX(cp.ds_codigo_cobranca)
			 FROM dbamv.cod_pro cp
			 WHERE item_reg_amb.cd_pro_fat = cp.cd_pro_fat
					 AND reg_amb.cd_convenio = cp.cd_convenio
					 AND reg_amb.cd_multi_empresa = cp.cd_multi_empresa
					 AND cp.tp_atendimento = 'T'
			)
		)                                                                                                           AS ds_codigo_cobranca,
	NVL(
			dados_produto_convenio.ds_nome_cobranca,
			(SELECT MAX(cp.ds_nome_cobranca)
			 FROM dbamv.cod_pro cp
			 WHERE item_reg_amb.cd_pro_fat = cp.cd_pro_fat
					 AND reg_amb.cd_convenio = cp.cd_convenio
					 AND reg_amb.cd_multi_empresa = cp.cd_multi_empresa
					 AND cp.tp_atendimento = 'T'
			)
		)                                                                                                           AS ds_nome_cobranca,
	(CASE WHEN tabela_brasindice.cd_tiss IS NULL
			  THEN NULL
		  ELSE tabela_brasindice_medicamento.ds_medicamento || ' - ' || tabela_brasindice_apresentacao.ds_apresentacao
			  || ' - ' || tabela_brasindice_laboratorio.ds_laboratorio || ' - ' || produto_faturado.ds_unidade END) AS ds_brasindice,
	produto_faturado.cd_pro_fat                                                                                 AS codigo_item_sistema,
	produto_faturado.cd_gru_pro                                                                                 AS cd_gru_pro,
	gru_fat.ds_gru_fat                                                                                          AS grupo_faturamento,
	produto_faturado.ds_pro_fat                                                                                 AS nome_produto,
	produto_faturado.ds_unidade                                                                                 AS ds_unidade,
	tpservico.tp_gru_pro                                                                                        AS tpservico,
	plano_convenio.ds_con_pla                                                                                   AS plano_beneficiario,
	dados_paciente.nm_paciente                                                                                  AS nome_beneficiario,
	centro_de_custos.cd_setor                                                                                   AS codigo_cc,
	centro_de_custos.nm_setor                                                                                   AS descricao_cc,
	medico_solicitante.cd_prestador                                                                             AS codigo_medico_solicitante,
	medico_solicitante.ds_codigo_conselho                                                                       AS crm_solicitante,
	medico_solicitante.nm_prestador                                                                             AS nome_solicitante,
	medico_executante.cd_prestador                                                                              AS codigo_medico_executante,
	medico_executante.ds_codigo_conselho                                                                        AS crm_executante,
	medico_executante.nm_prestador                                                                              AS nome_executante
FROM
	dbamv.atendime atendimento
		JOIN dbamv.itreg_amb item_reg_amb
	ON item_reg_amb.cd_atendimento = atendimento.cd_atendimento
		JOIN dbamv.reg_amb reg_amb
	ON reg_amb.cd_reg_amb = item_reg_amb.cd_reg_amb
		LEFT JOIN dbamv.con_pla plano_convenio
	ON (plano_convenio.cd_convenio = item_reg_amb.cd_convenio)
		AND (plano_convenio.cd_con_pla = item_reg_amb.cd_con_pla)
		LEFT JOIN dbamv.pro_fat produto_faturado
	ON produto_faturado.cd_pro_fat = item_reg_amb.cd_pro_fat
		LEFT JOIN dbamv.itregra item_regra
	ON item_regra.cd_regra = NVL(reg_amb.cd_regra, plano_convenio.cd_regra)
		AND (item_regra.cd_gru_pro = produto_faturado.cd_gru_pro)
		LEFT JOIN dbamv.guia guia
	ON guia.cd_guia = NVL(item_reg_amb.cd_guia, atendimento.cd_guia)
		LEFT JOIN dbamv.pro_fat_hierarquizado pro_fat_hierarquizado
	ON pro_fat_hierarquizado.cd_pro_fat = item_reg_amb.cd_pro_fat
		AND pro_fat_hierarquizado.cd_pro_fat_hierarquizado = item_reg_amb.cd_pro_fat
		LEFT JOIN dbamv.gru_pro tpservico
	ON tpservico.cd_gru_pro = produto_faturado.cd_gru_pro
		LEFT JOIN dbamv.gru_fat gru_fat
	ON gru_fat.cd_gru_fat = tpservico.cd_gru_fat
		LEFT JOIN dbamv.paciente dados_paciente
	ON dados_paciente.cd_paciente = NVL(guia.cd_paciente, atendimento.cd_paciente)
		LEFT JOIN dbamv.setor centro_de_custos
	ON centro_de_custos.cd_setor = NVL(item_reg_amb.cd_setor_produziu, item_reg_amb.cd_setor)
		LEFT JOIN dbamv.imp_simpro tabela_simpro
	ON tabela_simpro.cd_pro_fat = produto_faturado.cd_pro_fat
		AND item_regra.cd_tab_fat = tabela_simpro.cd_tab_fat
		LEFT JOIN dbamv.simpro simpro
	ON simpro.cd_simpro = tabela_simpro.cd_simpro
		LEFT JOIN dbamv.tab_fat tabela_faturamento
	ON tabela_faturamento.cd_tab_fat = item_regra.cd_tab_fat
		LEFT JOIN dbamv.imp_bra tabela_brasindice
	ON tabela_brasindice.cd_pro_fat = produto_faturado.cd_pro_fat
		AND tabela_brasindice.cd_tab_fat = item_regra.cd_tab_fat
		LEFT JOIN dbamv.b_medicame tabela_brasindice_medicamento
	ON tabela_brasindice_medicamento.cd_medicamento = tabela_brasindice.cd_medicamento
		LEFT JOIN dbamv.b_apres tabela_brasindice_apresentacao
	ON tabela_brasindice_apresentacao.cd_apresentacao = tabela_brasindice.cd_apresentacao
		LEFT JOIN dbamv.b_labora tabela_brasindice_laboratorio
	ON tabela_brasindice_laboratorio.cd_laboratorio = tabela_brasindice.cd_laboratorio
		LEFT JOIN dbamv.cod_pro dados_produto_convenio
	ON dados_produto_convenio.cd_pro_fat = produto_faturado.cd_pro_fat
		AND dados_produto_convenio.cd_convenio = reg_amb.cd_convenio
		AND dados_produto_convenio.tp_atendimento = atendimento.tp_atendimento
		AND dados_produto_convenio.cd_multi_empresa = reg_amb.cd_multi_empresa
		LEFT JOIN dbamv.procedimento_tuss procedimento_tuss
	ON procedimento_tuss.cd_pro_fat = produto_faturado.cd_pro_fat
		AND procedimento_tuss.cd_pro_fat IS NOT NULL
		LEFT JOIN dbamv.prestador medico_executante
	ON medico_executante.cd_prestador = item_reg_amb.cd_prestador
		LEFT JOIN dbamv.prestador medico_solicitante
            ON medico_solicitante.cd_prestador = atendimento.cd_prestador;
 
CREATE OR REPLACE FORCE VIEW vw_zg_itens_internacao
			(
			 versao,
			 cd_guia,
			 numero_guia_primario,
			 data_emissao_guia,
			 data_atendimento_guia,
			 data_saida_guia,
			 cd_regra,
			 cd_multi_empresa,
			 remessa,
			 sn_fechada,
			 sn_fechada_item,
			 codigo_convenio,
			 numero_conta,
			 numero_conta_tab_tiss,
			 tp_atendimento,
			 tipo_guia,
			 numero_atendimento,
			 codigo_atendimento,
			 cd_solicitante,
			 matricula_beneficiario,
			 numero_guia_envio_ate,
			 cd_tab_fat,
			 fatura,
			 id_it_envio,
			 agrupador_envio,
			 codigo_lancamento,
			 cd_guia_item,
			 tp_pagamento,
			 sn_pertence_pacote,
			 data_atendimento_item,
			 hora_atendimento_item,
			 cd_item_mv_func,
			 ds_item_mv_func,
			 cd_gru_fat,
			 quantidade_item,
			 valor_unitario_item,
			 vl_nota,
			 valor_total_item,
			 cd_executante,
			 atividade_medica_executante,
			 id_it_envio_honorario,
			 cd_reg_fat_honorario,
			 eh_honorario,
			 grau_participacao,
			 cd_tuss,
			 ds_tuss,
			 cd_tabela_cb,
			 cd_simpro1,
			 ds_simpro1,
			 cd_simpro2,
			 ds_simpro2,
			 nome_tabela,
			 cd_tabela_tiss1,
			 cd_tabela_tiss2,
			 cd_brasindice,
			 ds_brasindice_medicamento,
			 ds_brasindice_apresentacao,
			 ds_brasindice_laboratorio,
			 ds_codigo_cobranca,
			 ds_nome_cobranca,
			 ds_brasindice,
			 codigo_item_sistema,
			 cd_gru_pro,
			 grupo_faturamento,
			 nome_produto,
			 ds_unidade,
			 tpservico,
			 plano_beneficiario,
			 nome_beneficiario,
			 codigo_cc,
			 descricao_cc,
			 codigo_medico_solicitante,
			 crm_solicitante,
			 nome_solicitante,
			 codigo_medico_executante,
			 crm_executante,
			 nome_executante
				)
AS
SELECT '2.1.0'                                                                                                        AS versao,
	NVL(item_reg_fat.cd_guia, atendimento.cd_guia)                                                                 AS cd_guia,
	guia.nr_guia                                                                                                   AS numero_guia_primario,
	guia.dt_solicitacao                                                                                            AS data_emissao_guia,
	reg_fat.dt_inicio                                                                                              AS data_atendimento_guia,
	reg_fat.dt_final                                                                                               AS data_saida_guia,
	NVL(reg_fat.cd_regra, plano_convenio.cd_regra)                                                                 AS cd_regra,
	reg_fat.cd_multi_empresa                                                                                       AS cd_multi_empresa,
	reg_fat.cd_remessa                                                                                             AS remessa,
	reg_fat.sn_fechada                                                                                             AS sn_fechada,
	NULL                                                                                                           AS sn_fechada_item,
	CASE
		WHEN
			reg_fat.cd_conta_pai IS NOT NULL
			THEN (SELECT MAX(rf_pai.cd_convenio)
				  FROM dbamv.reg_fat rf_pai
				  WHERE rf_pai.cd_reg_fat = reg_fat.cd_conta_pai)
		ELSE
			reg_fat.cd_convenio
		END                                                                                                        AS codigo_convenio,
	reg_fat.cd_reg_fat                                                                                             AS numero_conta,
	NVL(reg_fat.cd_conta_pai, reg_fat.cd_reg_fat)                                                                  AS numero_conta_tab_tiss,
	atendimento.tp_atendimento                                                                                     AS tp_atendimento,
	DECODE(atendimento.tp_atendimento,
		   'A', 'Ambulatorial',
		   'E', 'Exame',
		   'I', 'Interno',
		   'U', 'Urgencia',
		   'Externo'
		)                                                                                                          AS tipo_guia,
	TO_CHAR(atendimento.cd_atendimento)                                                                            AS numero_atendimento,
	atendimento.cd_atendimento                                                                                     AS codigo_atendimento,
	atendimento.cd_prestador                                                                                       AS cd_solicitante,
	atendimento.nr_carteira                                                                                        AS matricula_beneficiario,
	LTRIM(atendimento.nr_guia_envio_principal, '0')                                                                AS numero_guia_envio_ate,
	item_regra.cd_tab_fat                                                                                          AS cd_tab_fat,
	item_reg_fat.cd_reg_fat                                                                                        AS fatura,
	item_reg_fat.id_it_envio                                                                                       AS id_it_envio,
	TO_CHAR(COALESCE(item_lancamento_medico.id_it_envio, item_reg_fat.id_it_envio))                                AS agrupador_envio,
	item_reg_fat.cd_lancamento                                                                                     AS codigo_lancamento,
	item_reg_fat.cd_guia                                                                                           AS cd_guia_item,
	item_reg_fat.tp_pagamento                                                                                      AS tp_pagamento,
	item_reg_fat.sn_pertence_pacote                                                                                AS sn_pertence_pacote,
	TO_DATE(TO_CHAR(item_reg_fat.dt_lancamento, 'dd-mm-yyyy'), 'dd-mm-yyyy')                                       AS data_atendimento_item,
	TO_DATE(TO_CHAR(item_reg_fat.hr_lancamento, 'HH24-Mi'), 'HH24-Mi')                                             AS hora_atendimento_item,
	dbamv.pkg_ffcv_tiss_pii.fnc_traduz_proc('C', reg_fat.cd_atendimento, reg_fat.cd_reg_fat,
											item_reg_fat.cd_lancamento, NULL, NULL, NULL, NULL, NULL)              AS cd_item_mv_func,
	dbamv.pkg_ffcv_tiss_pii.fnc_traduz_proc('D', reg_fat.cd_atendimento, reg_fat.cd_reg_fat,
											item_reg_fat.cd_lancamento, NULL, NULL, NULL, NULL, NULL)              AS ds_item_mv_func,
	item_reg_fat.cd_gru_fat                                                                                        AS cd_gru_fat,
	item_reg_fat.qt_lancamento                                                                                     AS quantidade_item,
	item_reg_fat.vl_unitario                                                                                       AS valor_unitario_item,
	CASE
		WHEN item_lancamento_medico.cd_lancamento IS NOT NULL
			THEN item_lancamento_medico.vl_nota
		ELSE item_reg_fat.vl_nota
		END                                                                                                        AS vl_nota,
	CASE
		WHEN
				COALESCE(item_lancamento_medico.vl_liquido, 0) > 0
			THEN item_lancamento_medico.vl_liquido
		ELSE
			item_reg_fat.vl_total_conta
		END                                                                                                        AS valor_total_item,
	COALESCE(item_lancamento_medico.cd_prestador, item_reg_fat.cd_prestador)                                       AS cd_executante,
	item_lancamento_medico.cd_ati_med                                                                              AS atividade_medica_executante,
	item_lancamento_medico.id_it_envio                                                                             AS id_it_envio_honorario,
	item_lancamento_medico.cd_reg_fat                                                                              AS cd_reg_fat_honorario,
	CASE
		WHEN item_lancamento_medico.cd_reg_fat IS NOT NULL
			THEN 'true'
		ELSE 'false' END                                                                                           AS eh_honorario,
	dados_grau_participacao.cd_ati_med                                                                             AS grau_participacao,
	procedimento_tuss.cd_pro_tuss                                                                                  AS cd_tuss,
	procedimento_tuss.ds_pro_tuss                                                                                  AS ds_tuss,
	pro_fat_hierarquizado.cd_pro_fat_hierarquizado                                                                 AS cd_tabela_cb,
	tabela_simpro.cd_simpro                                                                                        AS cd_simpro1,
	simpro.ds_simpro                                                                                               AS ds_simpro1,
	(SELECT MAX(imp.cd_simpro)
	 FROM dbamv.imp_simpro imp
	 WHERE imp.cd_pro_fat = produto_faturado.cd_pro_fat)                                                           AS cd_simpro2,
	(SELECT MAX(smp.ds_simpro)
	 FROM dbamv.imp_simpro imp
			  JOIN dbamv.simpro smp
	 ON smp.cd_simpro = imp.cd_simpro
	 WHERE imp.cd_pro_fat = produto_faturado.cd_pro_fat)                                                           AS ds_simpro2,
	NVL(
			(SELECT MAX(config_tiss_convenio.tp_trad_apr_proced)
			 FROM dbamv.config_tiss_conv_aprs_pcd config_tiss_convenio
			 WHERE config_tiss_convenio.cd_convenio = reg_fat.cd_convenio
					 AND config_tiss_convenio.tp_gru_pro_apr_proced = tpservico.tp_gru_pro),
			(SELECT MAX(config_tiss_convenio.tp_trad_apr_proced)
			 FROM dbamv.config_tiss_conv_aprs_pcd config_tiss_convenio
			 WHERE config_tiss_convenio.cd_convenio = reg_fat.cd_convenio
					 AND config_tiss_convenio.tp_tab_tiss_apr_proced = tabela_faturamento.tp_tab_fat_tiss)
		)                                                                                                          AS nome_tabela,
	NVL(
			(SELECT MAX(config_tiss_convenio.tp_tab_tiss_apr_proced)
			 FROM dbamv.config_tiss_conv_aprs_pcd config_tiss_convenio
			 WHERE config_tiss_convenio.cd_convenio = reg_fat.cd_convenio
					 AND config_tiss_convenio.tp_gru_pro_apr_proced = tpservico.tp_gru_pro),
			(SELECT MAX(config_tiss_convenio.tp_tab_tiss_apr_proced)
			 FROM dbamv.config_tiss_conv_aprs_pcd config_tiss_convenio
			 WHERE config_tiss_convenio.cd_convenio = reg_fat.cd_convenio
					 AND config_tiss_convenio.tp_tab_tiss_apr_proced = tabela_faturamento.tp_tab_fat_tiss)
		)                                                                                                          AS cd_tabela_tiss1,
	tabela_faturamento.tp_tab_fat_tiss                                                                             AS cd_tabela_tiss2,
	tabela_brasindice.cd_tiss                                                                                      AS cd_brasindice,
	tabela_brasindice_medicamento.ds_medicamento                                                                   AS ds_brasindice_medicamento,
	tabela_brasindice_apresentacao.ds_apresentacao                                                                 AS ds_brasindice_apresentacao,
	tabela_brasindice_laboratorio.ds_laboratorio                                                                   AS ds_brasindice_laboratorio,
	NVL(
			dados_produto_convenio.ds_codigo_cobranca,
			(SELECT MAX(cp.ds_codigo_cobranca)
			 FROM dbamv.cod_pro cp
			 WHERE cp.cd_pro_fat = item_reg_fat.cd_pro_fat
					 AND reg_fat.cd_convenio = cp.cd_convenio
					 AND reg_fat.cd_multi_empresa = cp.cd_multi_empresa
					 AND cp.tp_atendimento = 'T'
			)
		)                                                                                                          AS ds_codigo_cobranca,
	NVL(
			dados_produto_convenio.ds_nome_cobranca,
			(SELECT MAX(cp.ds_nome_cobranca)
			 FROM dbamv.cod_pro cp
			 WHERE cp.cd_pro_fat = item_reg_fat.cd_pro_fat
					 AND reg_fat.cd_convenio = cp.cd_convenio
					 AND reg_fat.cd_multi_empresa = cp.cd_multi_empresa
					 AND cp.tp_atendimento = 'T'
			)
		)                                                                                                          AS ds_nome_cobranca,
	(CASE
		WHEN tabela_brasindice.cd_tiss IS NULL
			THEN NULL
		ELSE tabela_brasindice_medicamento.ds_medicamento || ' - ' || tabela_brasindice_apresentacao.ds_apresentacao
			|| ' - ' || tabela_brasindice_laboratorio.ds_laboratorio || ' - ' || produto_faturado.ds_unidade END) AS ds_brasindice,
	produto_faturado.cd_pro_fat                                                                                    AS codigo_item_sistema,
	produto_faturado.cd_gru_pro                                                                                    AS cd_gru_pro,
	gru_fat.ds_gru_fat                                                                                             AS grupo_faturamento,
	produto_faturado.ds_pro_fat                                                                                    AS nome_produto,
	produto_faturado.ds_unidade                                                                                    AS ds_unidade,
	tpservico.tp_gru_pro                                                                                           AS tpservico,
	plano_convenio.ds_con_pla                                                                                      AS plano_beneficiario,
	dados_paciente.nm_paciente                                                                                     AS nome_beneficiario,
	centro_de_custos.cd_setor                                                                                      AS codigo_cc,
	centro_de_custos.nm_setor                                                                                      AS descricao_cc,
	medico_solicitante.cd_prestador                                                                                AS codigo_medico_solicitante,
	medico_solicitante.ds_codigo_conselho                                                                          AS crm_solicitante,
	medico_solicitante.nm_prestador                                                                                AS nome_solicitante,
	medico_executante.cd_prestador                                                                                 AS codigo_medico_executante,
	medico_executante.ds_codigo_conselho                                                                           AS crm_executante,
	medico_executante.nm_prestador                                                                                 AS nome_executante
FROM dbamv.atendime atendimento
		 JOIN dbamv.reg_fat reg_fat
ON reg_fat.cd_atendimento = atendimento.cd_atendimento
		 JOIN dbamv.itreg_fat item_reg_fat
ON item_reg_fat.cd_reg_fat = reg_fat.cd_reg_fat
		 LEFT JOIN dbamv.itlan_med item_lancamento_medico
ON
			item_reg_fat.cd_lancamento = item_lancamento_medico.cd_lancamento
		AND item_reg_fat.cd_reg_fat = item_lancamento_medico.cd_reg_fat
		AND (
						item_lancamento_medico.tp_pagamento IN ('P', 'F')
					OR (
								item_lancamento_medico.tp_pagamento IS NULL AND (NVL(item_lancamento_medico.cd_prestador, item_reg_fat.cd_prestador) IS NOT NULL)
							)
				)
		 LEFT JOIN dbamv.con_pla plano_convenio
ON (plano_convenio.cd_convenio = reg_fat.cd_convenio)
	AND (plano_convenio.cd_con_pla = reg_fat.cd_con_pla)
		 LEFT JOIN dbamv.pro_fat produto_faturado
ON produto_faturado.cd_pro_fat = item_reg_fat.cd_pro_fat
		 LEFT JOIN dbamv.itregra item_regra
ON item_regra.cd_regra = NVL(reg_fat.cd_regra, plano_convenio.cd_regra)
	AND (item_regra.cd_gru_pro = produto_faturado.cd_gru_pro)
		 LEFT JOIN dbamv.tiss_itguia_equ dados_grau_participacao
ON dados_grau_participacao.id_pai = item_lancamento_medico.id_it_envio
		 LEFT JOIN dbamv.guia guia
ON guia.cd_guia = NVL(item_reg_fat.cd_guia, atendimento.cd_guia)
		 LEFT JOIN dbamv.pro_fat_hierarquizado pro_fat_hierarquizado
ON pro_fat_hierarquizado.cd_pro_fat = item_reg_fat.cd_pro_fat
	AND pro_fat_hierarquizado.cd_pro_fat_hierarquizado = item_reg_fat.cd_pro_fat
		 LEFT JOIN dbamv.gru_pro tpservico
ON tpservico.cd_gru_pro = produto_faturado.cd_gru_pro
		 LEFT JOIN dbamv.gru_fat gru_fat
ON gru_fat.cd_gru_fat = tpservico.cd_gru_fat
		 LEFT JOIN dbamv.paciente dados_paciente
ON dados_paciente.cd_paciente = NVL(guia.cd_paciente, atendimento.cd_paciente)
		 LEFT JOIN dbamv.setor centro_de_custos
ON centro_de_custos.cd_setor = NVL(item_reg_fat.cd_setor_produziu, item_reg_fat.cd_setor)
		 LEFT JOIN dbamv.imp_simpro tabela_simpro
ON tabela_simpro.cd_pro_fat = produto_faturado.cd_pro_fat
	AND item_regra.cd_tab_fat = tabela_simpro.cd_tab_fat
		 LEFT JOIN dbamv.simpro simpro
ON simpro.cd_simpro = tabela_simpro.cd_simpro
		 LEFT JOIN dbamv.tab_fat tabela_faturamento
ON tabela_faturamento.cd_tab_fat = item_regra.cd_tab_fat
		 LEFT JOIN dbamv.imp_bra tabela_brasindice
ON tabela_brasindice.cd_pro_fat = produto_faturado.cd_pro_fat
	AND tabela_brasindice.cd_tab_fat = item_regra.cd_tab_fat
		 LEFT JOIN dbamv.b_medicame tabela_brasindice_medicamento
ON tabela_brasindice_medicamento.cd_medicamento = tabela_brasindice.cd_medicamento
		 LEFT JOIN dbamv.b_apres tabela_brasindice_apresentacao
ON tabela_brasindice_apresentacao.cd_apresentacao = tabela_brasindice.cd_apresentacao
		 LEFT JOIN dbamv.b_labora tabela_brasindice_laboratorio
ON tabela_brasindice_laboratorio.cd_laboratorio = tabela_brasindice.cd_laboratorio
		 LEFT JOIN dbamv.cod_pro dados_produto_convenio
ON dados_produto_convenio.cd_pro_fat = produto_faturado.cd_pro_fat
	AND dados_produto_convenio.cd_convenio = reg_fat.cd_convenio
	AND dados_produto_convenio.tp_atendimento = atendimento.tp_atendimento
	AND dados_produto_convenio.cd_multi_empresa = reg_fat.cd_multi_empresa
		 LEFT JOIN dbamv.procedimento_tuss procedimento_tuss
ON procedimento_tuss.cd_pro_fat = produto_faturado.cd_pro_fat
	AND procedimento_tuss.cd_pro_fat IS NOT NULL
		 LEFT JOIN dbamv.prestador medico_executante
ON medico_executante.cd_prestador = COALESCE(item_lancamento_medico.cd_prestador, item_reg_fat.cd_prestador)
		 LEFT JOIN dbamv.prestador medico_solicitante
                   ON medico_solicitante.cd_prestador = atendimento.cd_prestador;
 
CREATE OR REPLACE FORCE VIEW vw_zg_itens_nf_ambulatorio (
        versao,
        remessa,
        agrupador_envio,
        valor_total_item,
        numero_conta,
        codigo_atendimento,
        codigo_lancamento,
        codigo_nota_fiscal,
        nota_fiscal,
        nota_fiscal_avulsa,
        numero_nota_fiscal_eletronica,
        codigo_convenio,
        data_emissao_nota_fiscal,
        data_vencimento_nota_fiscal
) AS
    SELECT
        '1.4.0'                                                                                           AS versao,
        item_nota_fiscal.cd_remessa                                                                       AS remessa,
        item_nota_fiscal.id_it_envio                                                                      AS agrupador_envio,
        item_nota_fiscal.vl_itfat_nf                                                                      AS valor_total_item,
        item_nota_fiscal.cd_reg_amb                                                                       AS numero_conta,
        item_nota_fiscal.cd_atendimento                                                                   AS codigo_atendimento,
        item_nota_fiscal.cd_lancamento_amb                                                                AS codigo_lancamento,
        nota_fiscal.cd_nota_fiscal                                                                        AS codigo_nota_fiscal,
        TO_CHAR(nota_fiscal.nr_id_nota_fiscal)                                                            AS nota_fiscal,
        NULL                                                                                              AS nota_fiscal_avulsa,
        nota_fiscal.nr_nota_fiscal_nfe                                                                    AS numero_nota_fiscal_eletronica,
        nota_fiscal.cd_convenio                                                                           AS codigo_convenio,
        NVL(nota_fiscal.dt_emissao, contas_a_receber.dt_emissao)                                          AS data_emissao_nota_fiscal,
        NVL(contas_a_receber_detalhado.dt_vencimento,
            NVL(contas_a_receber_detalhado.dt_prevista_recebimento,
                (SELECT DT_VENCIMENTO
                 FROM dbamv.itcon_rec contas_a_receber_detalhado
                    JOIN dbamv.con_rec contas_a_receber
                        ON contas_a_receber_detalhado.cd_con_rec = contas_a_receber.cd_con_rec
                 WHERE contas_a_receber.cd_nota_fiscal = item_nota_fiscal.cd_nota_fiscal
                    AND ROWNUM = 1)))                                                                     AS data_vencimento_nota_fiscal
    FROM
        dbamv.itfat_nota_fiscal item_nota_fiscal
        JOIN dbamv.nota_fiscal nota_fiscal
            ON nota_fiscal.cd_nota_fiscal = item_nota_fiscal.cd_nota_fiscal
        LEFT JOIN dbamv.con_rec contas_a_receber
            ON contas_a_receber.cd_nota_fiscal = item_nota_fiscal.cd_nota_fiscal
                AND contas_a_receber.cd_remessa = item_nota_fiscal.cd_remessa
        LEFT JOIN dbamv.itcon_rec contas_a_receber_detalhado
            ON contas_a_receber_detalhado.cd_con_rec = contas_a_receber.cd_con_rec
WHERE item_nota_fiscal.cd_reg_fat IS NULL;
 
CREATE OR REPLACE FORCE VIEW vw_zg_itens_nf_internacao (
        versao,
        remessa,
        agrupador_envio,
        valor_total_item,
        numero_conta,
        codigo_atendimento,
        codigo_lancamento,
        codigo_nota_fiscal,
        nota_fiscal,
        nota_fiscal_avulsa,
        numero_nota_fiscal_eletronica,
        codigo_convenio,
        data_emissao_nota_fiscal,
        data_vencimento_nota_fiscal
) AS
    SELECT
        '1.4.0'                                                                                           AS versao,
        item_nota_fiscal.cd_remessa                                                                       AS remessa,
        item_nota_fiscal.id_it_envio                                                                      AS agrupador_envio,
        item_nota_fiscal.vl_itfat_nf                                                                      AS valor_total_item,
        item_nota_fiscal.cd_reg_fat                                                                       AS numero_conta,
        item_nota_fiscal.cd_atendimento                                                                   AS codigo_atendimento,
        item_nota_fiscal.cd_lancamento_fat                                                                AS codigo_lancamento,
        nota_fiscal.cd_nota_fiscal                                                                        AS codigo_nota_fiscal,
        TO_CHAR(nota_fiscal.nr_id_nota_fiscal)                                                            AS nota_fiscal,
        NULL                                                                                              AS nota_fiscal_avulsa,
        nota_fiscal.nr_nota_fiscal_nfe                                                                    AS numero_nota_fiscal_eletronica,
        nota_fiscal.cd_convenio                                                                           AS codigo_convenio,
        NVL(nota_fiscal.dt_emissao, contas_a_receber.dt_emissao)                                          AS data_emissao_nota_fiscal,
        NVL(contas_a_receber_detalhado.dt_vencimento,
            NVL(contas_a_receber_detalhado.dt_prevista_recebimento,
                (SELECT DT_VENCIMENTO
                 FROM dbamv.itcon_rec contas_a_receber_detalhado
                    JOIN dbamv.con_rec contas_a_receber
                        ON contas_a_receber_detalhado.cd_con_rec = contas_a_receber.cd_con_rec
                 WHERE contas_a_receber.cd_nota_fiscal = item_nota_fiscal.cd_nota_fiscal
                    AND ROWNUM = 1)))                                                                     AS data_vencimento_nota_fiscal
    FROM
        dbamv.itfat_nota_fiscal item_nota_fiscal
        JOIN dbamv.nota_fiscal nota_fiscal
            ON nota_fiscal.cd_nota_fiscal = item_nota_fiscal.cd_nota_fiscal
        LEFT JOIN dbamv.con_rec contas_a_receber
            ON contas_a_receber.cd_nota_fiscal = item_nota_fiscal.cd_nota_fiscal
                AND contas_a_receber.cd_remessa = item_nota_fiscal.cd_remessa
        LEFT JOIN dbamv.itcon_rec contas_a_receber_detalhado
            ON contas_a_receber_detalhado.cd_con_rec = contas_a_receber.cd_con_rec
WHERE item_nota_fiscal.cd_reg_amb IS NULL;
 
CREATE OR REPLACE FORCE VIEW vw_zg_itens_pgto_amb (
        versao,
        remessa,
        numero_protocolo,
        data_lancamento,
        pagamento_recurso,
        data_pagamento,
        numero_guia_prestador,
        numero_guia,
        cd_multi_empresa,
        sn_fechada,
        numero_atendimento,
        codigo_atendimento,
        numero_guia_envio_ate,
        numero_guia_primario,
        codigo_convenio,
        numero_conta,
        numero_conta_tab_tiss,
        fatura,
        data_atendimento_guia,
        data_saida_guia,
        quantidade_item,
        valor_unitario_item,
        valor_total_item,
        valor_pago_item,
        valor_glosa_item,
        codigo_motivo_glosa,
        descricao_motivo_glosa,
        agrupador_envio,
        eh_honorario,
        codigo_lancamento,
        tp_pagamento,
        sn_pertence_pacote,
        atividade_medica_executante,
        cd_executante,
        cd_usuario,
        nm_usuario
) AS
SELECT '1.1.3'                                                                           AS versao,

       reg_amb.cd_remessa                                                                AS remessa,

       (SELECT MIN(nr_protocolo_retorno) AS nr_protocolo_retorno
        FROM tiss_mensagem tiss_envio
        WHERE (tiss_envio.cd_status IN ('PS', 'ES', 'PE') OR tiss_envio.cd_status IS NULL)
          AND tiss_envio.tp_transacao = 'DEMONSTRATIVO_ANALISE_CONTA'
          AND tiss_envio.ds_motivo_cancelamento IS NULL
          AND TO_CHAR(item_nota_fiscal.cd_remessa) = nr_documento
       )                                                                                 AS numero_protocolo,
       (SELECT TO_DATE(MAX(tiss_envio.dt_transacao), 'YYYY-MM-DD')
        FROM tiss_mensagem tiss_envio
        WHERE (tiss_envio.cd_status IN ('PS', 'ES', 'PE') OR tiss_envio.cd_status IS NULL)
          AND tiss_envio.tp_transacao = 'DEMONSTRATIVO_ANALISE_CONTA'
          AND tiss_envio.ds_motivo_cancelamento IS NULL
          AND TO_CHAR(item_nota_fiscal.cd_remessa) = nr_documento
       )                                                                                 AS data_lancamento,
       CASE WHEN reccon_rec.cd_remessa_glosa IS NULL THEN 'false' ELSE 'true' END        AS pagamento_recurso,
       reccon_rec.dt_recebimento                                                         AS data_pagamento,
       COALESCE(TO_CHAR(guia_tiss_ambulatorio.numero_guia_prestador),
           (SELECT MIN(LTRIM(COALESCE(TO_CHAR(tiss_guia.nr_guia),
                                      TO_CHAR(tiss_guia.nr_guia_principal),
                                      TO_CHAR(tiss_guia.nr_guia_sol)), '0')) AS nr_guia
            FROM TISS_GUIA
            WHERE TISS_GUIA.cd_atendimento = item_reg_amb.cd_atendimento
              AND TISS_GUIA.cd_reg_fat = reg_amb.cd_reg_amb)
           )                                                                             as numero_guia_prestador,
       COALESCE(TO_CHAR(guia_tiss_ambulatorio.numero_guia_operadora),
           TO_CHAR(guia_tiss_ambulatorio.numero_guia_prestador),
               (SELECT MIN(LTRIM(TO_CHAR(tiss_guia.nr_guia_operadora), '0')) AS nr_guia
                    FROM TISS_GUIA
                    WHERE TISS_GUIA.cd_atendimento = item_reg_amb.cd_atendimento
                      AND TISS_GUIA.cd_reg_fat = reg_amb.cd_reg_amb),
                   TO_CHAR(guia.nr_guia),
                   LTRIM(TO_CHAR(atendimento.nr_guia_envio_principal), '0'))             AS numero_guia,
       reg_amb.cd_multi_empresa                                                          AS cd_multi_empresa,
       reg_amb.sn_fechada                                                                AS sn_fechada,
       TO_CHAR(atendimento.cd_atendimento)                                               AS numero_atendimento,
       atendimento.cd_atendimento                                                        AS codigo_atendimento,
       LTRIM(atendimento.nr_guia_envio_principal, '0')                                   AS numero_guia_envio_ate,
       guia.nr_guia                                                                      AS numero_guia_primario,

       reg_amb.cd_convenio                                                               AS codigo_convenio,
       reg_amb.cd_reg_amb                                                                AS numero_conta,
       reg_amb.cd_reg_amb                                                                AS numero_conta_tab_tiss,
       item_reg_amb.cd_reg_amb                                                           AS fatura,
       reg_amb.dt_lancamento                                                             AS data_atendimento_guia,
       reg_amb.dt_lancamento_final                                                       AS data_saida_guia,

       item_reg_amb.qt_lancamento                                                        AS quantidade_item,
       item_reg_amb.vl_unitario                                                          AS valor_unitario_item,
       item_reg_amb.vl_total_conta                                                       AS valor_total_item,
       recebimento.vl_recebido                                                           AS valor_pago_item,
       recebimento.vl_glosa                                                              AS valor_glosa_item,
       motivo_glosa.cd_glosa_tiss                                                        AS codigo_motivo_glosa,
       motivo_glosa.ds_motivo_glosa                                                      AS descricao_motivo_glosa,
       TO_CHAR(COALESCE(item_reg_amb.id_it_envio, item_nota_fiscal.id_it_envio))         AS agrupador_envio,

       'false'                                                                           AS eh_honorario,
       item_reg_amb.cd_lancamento                                                        AS codigo_lancamento,
       item_reg_amb.tp_pagamento                                                         AS tp_pagamento,
       item_reg_amb.sn_pertence_pacote                                                   AS sn_pertence_pacote,
       item_reg_amb.cd_ati_med                                                           AS atividade_medica_executante,
       item_reg_amb.cd_prestador                                                         AS cd_executante,
       usuarios.cd_usuario                                                               AS cd_usuario,
       usuarios.nm_usuario                                                               AS nm_usuario
FROM atendime atendimento
         JOIN itreg_amb item_reg_amb
              ON item_reg_amb.cd_atendimento = atendimento.cd_atendimento
         JOIN reg_amb reg_amb
              ON reg_amb.cd_reg_amb = item_reg_amb.cd_reg_amb
         JOIN itfat_nota_fiscal item_nota_fiscal
              ON reg_amb.cd_reg_amb = item_nota_fiscal.cd_reg_amb
                  AND reg_amb.cd_remessa = item_nota_fiscal.cd_remessa
                  AND item_reg_amb.cd_atendimento = item_nota_fiscal.cd_atendimento
                  AND item_reg_amb.cd_lancamento = item_nota_fiscal.cd_lancamento_amb
         JOIN it_recebimento recebimento
              ON recebimento.cd_itfat_nf = item_nota_fiscal.cd_itfat_nf
         JOIN reccon_rec reccon_rec
              ON recebimento.cd_reccon_rec = reccon_rec.cd_reccon_rec
         LEFT JOIN GLOSAS glosa
                   ON glosa.cd_itfat_nf = item_nota_fiscal.cd_itfat_nf
         LEFT JOIN MOTIVO_GLOSA motivo_glosa
                   ON motivo_glosa.cd_motivo_glosa = glosa.cd_motivo_glosa
         LEFT JOIN guia guia
                   ON guia.cd_guia = NVL(item_reg_amb.cd_guia, atendimento.cd_guia)
         LEFT JOIN dbasgu.usuarios usuarios
                   ON usuarios.cd_usuario = reccon_rec.nm_usuario
         LEFT JOIN VW_ZG_GUIAS_TISS_AMBULATORIO guia_tiss_ambulatorio
                   ON reg_amb.cd_reg_amb = guia_tiss_ambulatorio.numero_conta
                       AND LTRIM(TO_CHAR(guia.nr_guia), '0') = LTRIM(TO_CHAR(guia_tiss_ambulatorio.numero_guia_operadora), '0')
                       AND guia_tiss_ambulatorio.valor_total > 0 ;
 
CREATE OR REPLACE FORCE VIEW vw_zg_itens_pgto_int (
        versao,
        remessa,
        numero_protocolo,
        data_lancamento,
        pagamento_recurso,
        data_pagamento,
        numero_guia_prestador,
        numero_guia,
        cd_multi_empresa,
        sn_fechada,
        numero_atendimento,
        codigo_atendimento,
        numero_guia_envio_ate,
        numero_guia_primario,
        codigo_convenio,
        numero_conta,
        numero_conta_tab_tiss,
        fatura,
        data_atendimento_guia,
        data_saida_guia,
        quantidade_item,
        valor_unitario_item,
        valor_total_item,
        valor_pago_item,
        valor_glosa_item,
        codigo_motivo_glosa,
        descricao_motivo_glosa,
        agrupador_envio,
        eh_honorario,
        codigo_lancamento,
        tp_pagamento,
        sn_pertence_pacote,
        atividade_medica_executante,
        cd_executante,
        cd_usuario,
        nm_usuario
) AS
SELECT '1.1.3'                                                                                                       AS versao,

       reg_fat.cd_remessa                                                                                            AS remessa,

       (SELECT MIN(nr_protocolo_retorno) AS nr_protocolo_retorno
        FROM tiss_mensagem tiss_envio
        WHERE (tiss_envio.cd_status IN ('PS', 'ES', 'PE') OR tiss_envio.cd_status IS NULL)
          AND tiss_envio.tp_transacao = 'DEMONSTRATIVO_ANALISE_CONTA'
          AND tiss_envio.ds_motivo_cancelamento IS NULL
          AND TO_CHAR(item_nota_fiscal.cd_remessa) = nr_documento
       )                                                                                                             AS numero_protocolo,
       (SELECT TO_DATE(MAX(tiss_envio.dt_transacao), 'YYYY-MM-DD')
        FROM tiss_mensagem tiss_envio
        WHERE (tiss_envio.cd_status IN ('PS', 'ES', 'PE') OR tiss_envio.cd_status IS NULL)
          AND tiss_envio.tp_transacao = 'DEMONSTRATIVO_ANALISE_CONTA'
          AND tiss_envio.ds_motivo_cancelamento IS NULL
          AND TO_CHAR(item_nota_fiscal.cd_remessa) = nr_documento
       )                                                                                                             AS data_lancamento,
       CASE
           WHEN reccon_rec.cd_remessa_glosa IS NULL
               THEN 'false'
           ELSE 'true' END                                                                                           AS pagamento_recurso,
       reccon_rec.dt_recebimento                                                                                     AS data_pagamento,
       COALESCE(TO_CHAR(guia_tiss_internacao.numero_guia_prestador),
           (SELECT MIN(LTRIM(COALESCE(TO_CHAR(tiss_guia.nr_guia),
                                      TO_CHAR(tiss_guia.nr_guia_principal),
                                      TO_CHAR(tiss_guia.nr_guia_sol)), '0')) AS nr_guia
            FROM TISS_GUIA
            WHERE TISS_GUIA.cd_atendimento = reg_fat.cd_atendimento
              AND TISS_GUIA.cd_reg_fat = reg_fat.cd_reg_fat)
           )                                                                                                         as numero_guia_prestador,
       COALESCE(TO_CHAR(guia_tiss_internacao.numero_guia_operadora),
           TO_CHAR(guia_tiss_internacao.numero_guia_prestador),
               (SELECT MIN(LTRIM(TO_CHAR(tiss_guia.nr_guia_operadora), '0')) AS nr_guia
                    FROM TISS_GUIA
                    WHERE TISS_GUIA.cd_atendimento = reg_fat.cd_atendimento
                      AND TISS_GUIA.cd_reg_fat = reg_fat.cd_reg_fat),
                   TO_CHAR(guia.nr_guia),
                   LTRIM(TO_CHAR(atendimento.nr_guia_envio_principal), '0'))                                         AS numero_guia,
       reg_fat.cd_multi_empresa                                                                                      AS cd_multi_empresa,
       reg_fat.sn_fechada                                                                                            AS sn_fechada,
       TO_CHAR(atendimento.cd_atendimento)                                                                           AS numero_atendimento,
       atendimento.cd_atendimento                                                                                    AS codigo_atendimento,
       LTRIM(atendimento.nr_guia_envio_principal, '0')                                                               AS numero_guia_envio_ate,
       guia.nr_guia                                                                                                  AS numero_guia_primario,

       CASE
           WHEN
               reg_fat.cd_conta_pai IS NOT NULL
               THEN (SELECT MAX(rf_pai.cd_convenio)
                     FROM reg_fat rf_pai
                     WHERE rf_pai.cd_reg_fat = reg_fat.cd_conta_pai)
           ELSE
               reg_fat.cd_convenio
           END                                                                                                       AS codigo_convenio,
       reg_fat.cd_reg_fat                                                                                            AS numero_conta,
       NVL(reg_fat.cd_conta_pai, reg_fat.cd_reg_fat)                                                                 AS numero_conta_tab_tiss,
       item_reg_fat.cd_reg_fat                                                                                       AS fatura,
       reg_fat.dt_inicio                                                                                             AS data_atendimento_guia,
       reg_fat.dt_final                                                                                              AS data_saida_guia,

       item_reg_fat.qt_lancamento                                                                                    AS quantidade_item,
       item_reg_fat.vl_unitario                                                                                      AS valor_unitario_item,
       CASE
           WHEN
               COALESCE(item_lancamento_medico.vl_liquido, 0) > 0
               THEN item_lancamento_medico.vl_liquido
           ELSE
               item_reg_fat.vl_total_conta
           END                                                                                                       AS valor_total_item,
       recebimento.vl_recebido                                                                                       AS valor_pago_item,
       recebimento.vl_glosa                                                                                          AS valor_glosa_item,
       motivo_glosa.cd_glosa_tiss                                                                                    AS codigo_motivo_glosa,
       motivo_glosa.ds_motivo_glosa                                                                                  AS descricao_motivo_glosa,
       TO_CHAR(COALESCE(item_lancamento_medico.id_it_envio, item_reg_fat.id_it_envio, item_nota_fiscal.id_it_envio)) AS agrupador_envio,

       CASE
           WHEN item_lancamento_medico.cd_reg_fat IS NOT NULL
               THEN 'true'
           ELSE 'false' END                                                                                          AS eh_honorario,
       item_reg_fat.cd_lancamento                                                                                    AS codigo_lancamento,
       item_reg_fat.tp_pagamento                                                                                     AS tp_pagamento,
       item_reg_fat.sn_pertence_pacote                                                                               AS sn_pertence_pacote,
       item_lancamento_medico.cd_ati_med                                                                             AS atividade_medica_executante,
       COALESCE(item_lancamento_medico.cd_prestador, item_reg_fat.cd_prestador)                                      AS cd_executante,
       usuarios.cd_usuario                                                                                           AS cd_usuario,
       usuarios.nm_usuario                                                                                           AS nm_usuario

FROM atendime atendimento
         JOIN reg_fat reg_fat
              ON reg_fat.cd_atendimento = atendimento.cd_atendimento
         JOIN itreg_fat item_reg_fat
              ON item_reg_fat.cd_reg_fat = reg_fat.cd_reg_fat
         LEFT JOIN dbamv.itlan_med item_lancamento_medico
                   ON
                               item_reg_fat.cd_lancamento = item_lancamento_medico.cd_lancamento
                           AND item_reg_fat.cd_reg_fat = item_lancamento_medico.cd_reg_fat
                           AND (
                                           item_lancamento_medico.tp_pagamento IN ('P', 'F')
                                       OR (
                                               item_lancamento_medico.tp_pagamento IS NULL AND (NVL(item_lancamento_medico.cd_prestador, item_reg_fat.cd_prestador) IS NOT NULL)
                                               )
                                   )
         JOIN itfat_nota_fiscal item_nota_fiscal
              ON item_reg_fat.cd_reg_fat = item_nota_fiscal.cd_reg_fat
                  AND reg_fat.cd_remessa = item_nota_fiscal.cd_remessa
                  AND nvl(item_reg_fat.cd_lancamento, item_reg_fat.cd_lancamento) = item_nota_fiscal.cd_lancamento_fat
                  AND reg_fat.cd_atendimento = item_nota_fiscal.cd_atendimento
                  AND CASE
                          WHEN item_lancamento_medico.cd_ati_med = item_nota_fiscal.cd_ati_med
                              THEN 1
                          WHEN item_lancamento_medico.cd_ati_med IS NULL
                              THEN 2
                          ELSE 3
                          END IN (1, 2)
         JOIN it_recebimento recebimento
              ON recebimento.cd_itfat_nf = item_nota_fiscal.cd_itfat_nf
         JOIN reccon_rec reccon_rec
              ON recebimento.cd_reccon_rec = reccon_rec.cd_reccon_rec
         LEFT JOIN GLOSAS glosa
                   ON glosa.cd_itfat_nf = item_nota_fiscal.cd_itfat_nf
         LEFT JOIN MOTIVO_GLOSA motivo_glosa
                   ON motivo_glosa.cd_motivo_glosa = glosa.cd_motivo_glosa
         LEFT JOIN guia guia
                   ON guia.cd_guia = NVL(item_reg_fat.cd_guia, atendimento.cd_guia)
         LEFT JOIN dbasgu.usuarios usuarios
                   ON usuarios.cd_usuario = reccon_rec.nm_usuario
         LEFT JOIN VW_ZG_GUIAS_TISS_INTERNACAO guia_tiss_internacao
                   ON NVL(reg_fat.cd_conta_pai, reg_fat.cd_reg_fat) = guia_tiss_internacao.numero_conta
                       AND LTRIM(TO_CHAR(guia.nr_guia), '0') = LTRIM(TO_CHAR(guia_tiss_internacao.numero_guia_operadora), '0')
                       AND guia_tiss_internacao.valor_total > 0 ;
 
CREATE OR REPLACE FORCE VIEW vw_zg_itens_tiss (
        versao,
        agrupador_envio,
        codigo_guia_tiss,
        codigo_item,
        codigo_tabela_item,
        data_atendimento_item,
        hora_atendimento_item,
        quantidade_item,
        valor_unitario_item,
        valor_total_item,
        sequencial_item
) AS
    SELECT
        '1.2.1'                                                                AS versao,
        TO_CHAR(item_tiss.id)                                                  AS agrupador_envio,
        item_tiss.id_pai                                                       AS codigo_guia_tiss,
        item_tiss.cd_procedimento                                              AS codigo_item,
        item_tiss.tp_tab_fat                                                   AS codigo_tabela_item,
        item_tiss.dt_realizado                                                 AS data_atendimento_item,
        item_tiss.hr_inicio                                                    AS hora_atendimento_item,
        item_tiss.qt_realizada                                                 AS quantidade_item,
        TO_NUMBER(REPLACE(TO_CHAR(NVL(item_tiss.vl_unitario, '0')), '.', ',')) AS valor_unitario_item,
        TO_NUMBER(REPLACE(TO_CHAR(NVL(item_tiss.vl_total, '0')), '.', ','))    AS valor_total_item,
        item_tiss.sq_item                                                      AS sequencial_item
    FROM
        (SELECT
             id,
             id_pai,
             tp_tab_fat,
             cd_procedimento,
             ds_procedimento,
             dt_realizado,
             hr_inicio,
             qt_realizada,
             vl_unitario,
             vl_total,
             sq_item
         FROM dbamv.v_tiss_itguia_v3 tiss_itguia
         UNION ALL
         SELECT
             id,
             id_pai,
             tp_tab_fat,
             cd_procedimento,
             ds_procedimento,
             dt_realizado,
             hr_inicio,
             qt_realizada,
             vl_unitario,
             vl_total,
             sq_item
         FROM dbamv.v_tiss_itguia_out_v3 tiss_itguia_out
         UNION ALL
         SELECT
             id,
             id_pai,
             tp_tab_fat,
             cd_procedimento,
             ds_procedimento,
             NULL dt_realizado,
             NULL hr_inicio,
             qt_realizada,
             vl_unitario,
             vl_total,
             null               AS sq_item
         FROM dbamv.tiss_itguia_op tiss_itguia_op) item_tiss;
 
CREATE OR REPLACE FORCE VIEW vw_zg_lote_por_remessa (
													 versao,
													 id_guia_pai,
													 remessa,
													 numero_conta,
													 numero_lote,
													 numero_guia,
													 protocolo
	) AS
SELECT
	'1.1.0' AS versao,
	dados_tiss.id_guia_pai,
	dados_tiss.remessa,
	dados_tiss.numero_conta,
	dados_tiss.numero_lote,
	dados_tiss.numero_guia,
	dados_tiss.protocolo
FROM
	(SELECT
		 DISTINCT
		 guia_tiss.id_pai                                     AS id_guia_pai,
		 guia_tiss.cd_remessa                                 AS remessa,
		 COALESCE(guia_tiss.cd_reg_fat, guia_tiss.cd_reg_amb) AS numero_conta,
		 lote_tiss.nr_lote                                    AS numero_lote,
		 LTRIM(COALESCE(guia_tiss.nr_guia,
						guia_tiss.nr_guia_principal,
						guia_tiss.nr_guia_sol), '0')          AS numero_guia,
		 xml.nr_protocolo_retorno                             AS protocolo
	 FROM
		 dbamv.tiss_guia guia_tiss
			 LEFT JOIN dbamv.tiss_lote lote_tiss
		 ON lote_tiss.id = guia_tiss.id_pai
			 LEFT JOIN dbamv.tiss_mensagem xml
		 ON lote_tiss.id_pai = xml.id
	 UNION
	 SELECT
		 DISTINCT
		 guia_tiss.id_pai                                 AS id_guia_pai,
		 COALESCE(reg_fat.cd_remessa, reg_amb.cd_remessa) AS remessa,
		 COALESCE(reg_fat.cd_reg_fat, reg_amb.cd_reg_amb) AS numero_conta,
		 lote_tiss.nr_lote                                AS numero_lote,
		 LTRIM(COALESCE(guia_tiss.nr_guia,
						guia_tiss.nr_guia_principal,
						guia_tiss.nr_guia_sol), '0')      AS numero_guia,
		 xml.nr_protocolo_retorno                         AS protocolo
	 FROM
		 dbamv.tiss_guia guia_tiss
			 LEFT JOIN dbamv.reg_fat reg_fat
		 ON reg_fat.cd_reg_fat = guia_tiss.cd_reg_fat
			 LEFT JOIN dbamv.reg_amb reg_amb
		 ON reg_amb.cd_reg_amb = guia_tiss.cd_reg_amb
			 LEFT JOIN dbamv.tiss_lote lote_tiss
		 ON lote_tiss.id = guia_tiss.id_pai
			 LEFT JOIN dbamv.tiss_mensagem xml
		 ON lote_tiss.id_pai = xml.id
	) dados_tiss
WHERE
	dados_tiss.id_guia_pai IS NOT NULL;
 
CREATE OR REPLACE FORCE VIEW vw_zg_operadoras
			(
			 versao,
			 codigo_convenio,
			 codigo_fornecedor,
			 nome_convenio,
			 convenio,
			 cnpj_convenio,
			 registro_ans,
			 ativo,
			 data_ultimo_faturamento,
			 codigo_prestador_na_operadora
				) AS
SELECT '2.2.0'                            AS versao,
	convenio.cd_convenio               AS codigo_convenio,
	convenio.cd_fornecedor             AS codigo_fornecedor,
	convenio.nm_convenio               AS nome_convenio,
	convenio.nm_convenio               AS convenio,
	convenio.nr_cgc                    AS cnpj_convenio,
	convenio.nr_registro_operadora_ans AS registro_ans,
	CASE WHEN convenio.sn_ativo = 'S'
			 THEN 1
		 ELSE 0
		END                            AS ativo,
	CASE WHEN max(remessa.dt_abertura) > sysdate
			 THEN sysdate
		 ELSE max(remessa.dt_abertura)
		END                            AS data_ultimo_faturamento,
	pareamento_tiss_mensagem.cd_origem AS codigo_prestador_na_operadora
FROM dbamv.convenio convenio
		 LEFT JOIN dbamv.fatura fatura
ON fatura.cd_convenio = convenio.cd_convenio
		 LEFT JOIN dbamv.remessa_fatura remessa
ON remessa.cd_fatura = fatura.cd_fatura AND remessa.sn_fechada = 'S'
		 LEFT JOIN (
	SELECT tiss_mensagem.cd_convenio,
		min(cd_origem) KEEP (DENSE_RANK FIRST ORDER BY dt_transacao DESC, hr_transacao DESC) AS cd_origem
	FROM dbamv.tiss_mensagem
	WHERE tiss_mensagem.tp_transacao = 'ENVIO_LOTE_GUIAS' AND
		tiss_mensagem.ds_motivo_cancelamento IS NULL AND
		tiss_mensagem.cd_origem IS NOT NULL
	GROUP BY tiss_mensagem.cd_convenio
) pareamento_tiss_mensagem
ON convenio.cd_convenio = pareamento_tiss_mensagem.cd_convenio
GROUP BY convenio.cd_convenio, convenio.cd_fornecedor, convenio.nm_convenio, convenio.nr_cgc, convenio.nr_registro_operadora_ans, convenio.sn_ativo, pareamento_tiss_mensagem.cd_origem;
 
CREATE OR REPLACE FORCE VIEW vw_zg_prestadores (
												versao,
												codigo_prestador,
												nome_prestador,
												cnpj_prestador,
												numero_cnes,
												cd_fornecedor
	) AS
SELECT
	'1.0.0'                         AS versao,
	prestador.cd_multi_empresa      AS codigo_prestador,
	prestador.ds_razao_social       AS nome_prestador,
	LPAD(prestador.cd_cgc, 14, '0') AS cnpj_prestador,
	prestador.nr_cnes               AS numero_cnes,
	prestador.cd_fornecedor         AS cd_fornecedor
FROM
	dbamv.multi_empresas prestador;
 
CREATE OR REPLACE FORCE VIEW vw_zg_valores_faturados (
													  versao,
													  remessa,
													  identificador,
													  status_remessa,
													  data_remessa,
													  data_envio_remessa,
													  data_emissao,
													  data_vencimento_remessa,
													  data_fechamento_remessa,
													  valor,
													  tem_nota_fiscal,
													  versao_tiss,
													  protocolo,
													  codigo_prestador_na_operadora,
													  tem_xml,
													  competencia,
													  data_competencia,
													  id_prestador_erp,
													  cod_con,
													  nome_convenio
	) AS
SELECT '1.1.0'                                                  AS versao,
	remessa.cd_remessa                                       AS remessa,
	remessa.cd_remessa                                       AS identificador,
	remessa.sn_fechada                                       AS status_remessa,
	remessa.dt_entrega_da_fatura                             AS data_remessa,
	remessa.dt_entrega_da_fatura                             AS data_envio_remessa,
	remessa.dt_abertura                                      AS data_emissao,
	remessa.dt_prevista_para_pgto                            AS data_vencimento_remessa,
	remessa.dt_fechamento                                    AS data_fechamento_remessa,
	NVL(
			(SELECT min(vl_previsto) KEEP (DENSE_RANK FIRST ORDER BY cd_previsao DESC)
			 FROM dbamv.previsao
			 WHERE previsao.cd_remessa = remessa.cd_remessa)
		, 0)                                                 AS valor,
	CASE
		WHEN exists(
				SELECT item_nota_fiscal.cd_itfat_nf
				FROM dbamv.itfat_nota_fiscal item_nota_fiscal
				WHERE item_nota_fiscal.cd_remessa = remessa.cd_remessa)
			THEN 'true'
		ELSE 'false'
		END                                                      AS tem_nota_fiscal,
	(SELECT min(tiss_mensagem.cd_versao)
	 FROM dbamv.tiss_mensagem tiss_mensagem
	 WHERE tiss_mensagem.nr_documento = TO_CHAR(remessa.cd_remessa) AND
			 tiss_mensagem.tp_transacao = 'ENVIO_LOTE_GUIAS' AND
		 tiss_mensagem.ds_motivo_cancelamento IS NULL AND
			 tiss_mensagem.cd_convenio = convenio.cd_convenio) AS versao_tiss,
	(SELECT min(tiss_mensagem.nr_protocolo_retorno)
	 FROM dbamv.tiss_mensagem tiss_mensagem
	 WHERE tiss_mensagem.nr_documento = TO_CHAR(remessa.cd_remessa) AND
			 tiss_mensagem.tp_transacao = 'ENVIO_LOTE_GUIAS' AND
		 tiss_mensagem.ds_motivo_cancelamento IS NULL AND
			 tiss_mensagem.cd_convenio = convenio.cd_convenio) AS protocolo,
	COALESCE(
			(SELECT min(tiss_mensagem.cd_origem) KEEP (DENSE_RANK FIRST ORDER BY dt_transacao DESC, hr_transacao DESC)
			 FROM dbamv.tiss_mensagem tiss_mensagem
			 WHERE tiss_mensagem.nr_documento = TO_CHAR(remessa.cd_remessa) AND
					 tiss_mensagem.tp_transacao = 'ENVIO_LOTE_GUIAS' AND
				 tiss_mensagem.ds_motivo_cancelamento IS NULL AND
					 tiss_mensagem.cd_convenio = convenio.cd_convenio),
			(SELECT min(tiss_mensagem.cd_origem) KEEP (DENSE_RANK FIRST ORDER BY dt_transacao DESC, hr_transacao DESC)
			 FROM dbamv.tiss_mensagem tiss_mensagem
			 WHERE tiss_mensagem.tp_transacao = 'ENVIO_LOTE_GUIAS' AND
				 tiss_mensagem.ds_motivo_cancelamento IS NULL AND
					 tiss_mensagem.cd_convenio = convenio.cd_convenio)
		)                                                    AS codigo_prestador_na_operadora,
	CASE
		WHEN exists(
				SELECT tiss_mensagem.id
				FROM dbamv.tiss_mensagem tiss_mensagem
				WHERE tiss_mensagem.nr_documento = TO_CHAR(remessa.cd_remessa) AND
						tiss_mensagem.tp_transacao = 'ENVIO_LOTE_GUIAS' AND
					tiss_mensagem.ds_motivo_cancelamento IS NULL AND
						convenio.cd_convenio = tiss_mensagem.cd_convenio)
			THEN 'true'
		ELSE 'false'
		END                                                      AS tem_xml,
	TO_CHAR((fatura.dt_competencia), 'MM-yyyy')              AS competencia,
	fatura.dt_competencia                                    AS data_competencia,
	TO_CHAR(fatura.cd_multi_empresa)                         AS id_prestador_erp,
	convenio.cd_convenio                                     AS cod_con,
	convenio.nm_convenio                                     AS nome_convenio
FROM dbamv.remessa_fatura remessa
		 JOIN dbamv.fatura fatura
ON fatura.cd_fatura = remessa.cd_fatura
		 JOIN dbamv.convenio convenio
ON fatura.cd_convenio = convenio.cd_convenio
WHERE
	exists(
			SELECT reg_fat.cd_reg_fat
			FROM dbamv.reg_fat reg_fat
			WHERE reg_fat.cd_remessa = remessa.cd_remessa) OR
	exists(
			SELECT reg_amb.cd_reg_amb
			FROM dbamv.reg_amb reg_amb
			WHERE reg_amb.cd_remessa = remessa.cd_remessa);
 
CREATE OR REPLACE FORCE VIEW vw_zg_valores_pagos (
												  versao,
												  id_prestador_erp,
												  remessa,
												  codigo_convenio,
												  pagamento_recurso,
												  data_pagamento,
												  numero_protocolo,
												  chave_remessa_protocolo,
												  valor_pago
	) AS
SELECT '1.0.0'                                                                             AS versao,
	valores.id_prestador_erp,
	valores.remessa,
	valores.codigo_convenio,
	valores.pagamento_recurso,
	valores.data_pagamento,
	valores.numero_protocolo,
		valores.remessa||'#'||valores.numero_protocolo||'#'||valores.data_pagamento            AS chave_remessa_protocolo,
	SUM(valores.valor)                                                                     AS valor_pago
FROM (
	SELECT
		nota_fiscal.cd_multi_empresa                                                                                  AS id_prestador_erp,
		item_nota_fiscal.cd_remessa                                                                                   AS remessa,
		nota_fiscal.cd_convenio                                                                                       AS codigo_convenio,
		(SELECT
			 min(nr_protocolo_retorno) as nr_protocolo_retorno
		 from tiss_mensagem tiss_envio
		 WHERE (tiss_envio.cd_status IN ('PS', 'ES', 'PE') OR tiss_envio.cd_status IS NULL)
				 AND tiss_envio.tp_transacao = 'DEMONSTRATIVO_ANALISE_CONTA'
				 AND tiss_envio.ds_motivo_cancelamento IS NULL
				 AND TO_CHAR(item_nota_fiscal.cd_remessa) = nr_documento
		)                                                                                                       AS numero_protocolo,
		CASE WHEN reccon_rec.cd_remessa_glosa IS NULL
				 THEN 'false'
			 ELSE 'true' END                                                                                               AS pagamento_recurso,
		reccon_rec.dt_recebimento                                                                                     AS data_pagamento,
		recebimento.vl_recebido                                                                                       AS valor
	FROM nota_fiscal nota_fiscal
			 JOIN itfat_nota_fiscal item_nota_fiscal
	ON nota_fiscal.cd_nota_fiscal = item_nota_fiscal.cd_nota_fiscal
			 JOIN it_recebimento recebimento
	ON recebimento.cd_itfat_nf = item_nota_fiscal.cd_itfat_nf
			 JOIN reccon_rec reccon_rec
	ON recebimento.cd_reccon_rec = reccon_rec.cd_reccon_rec
			 JOIN itcon_rec it
	ON it.cd_itcon_rec = reccon_rec.cd_itcon_rec
	WHERE it.tp_quitacao IN ('Q', 'G')
) valores
GROUP BY valores.id_prestador_erp,
	valores.numero_protocolo,
	valores.pagamento_recurso,
	valores.data_pagamento,
	valores.remessa,
	valores.codigo_convenio;
 
CREATE OR REPLACE FORCE VIEW vw_zg_valores_recebidos (
        versao,
        valor_erp,
        observacao,
        data_recebimento,
        id_prestador_erp,
        codigo_fornecedor,
        codigo_banco,
        nome_banco,
        codigo_conta_bancaria,
        agencia,
        conta,
        digito,
        identificador_externo
) AS
    SELECT
        '1.2.0'                            AS versao,
        NVL(mov_concor.vl_movimentacao, 0) AS valor_erp,
        mov_concor.ds_movimentacao         AS observacao,
        mov_concor.dt_movimentacao         AS data_recebimento,
        mov_concor.cd_multi_empresa        AS id_prestador_erp,
        mov_concor.cd_fornecedor           AS codigo_fornecedor,
        banco.cd_banco                     AS codigo_banco,
        banco.nm_banco                     AS nome_banco,
        con_cor.cd_con_cor                 AS codigo_conta_bancaria,
        con_cor.cd_agencia                 AS agencia,
        con_cor.nr_conta                   AS conta,
        con_cor.cd_digito_conta_corrente      AS digito,
        mov_concor.cd_mov_concor           AS identificador_externo
    FROM dbamv.mov_concor mov_concor
        JOIN dbamv.con_cor con_cor
            ON mov_concor.cd_con_cor = con_cor.cd_con_cor
        JOIN dbamv.banco banco
            ON con_cor.cd_banco = banco.cd_banco;
 
GRANT SELECT ON dbamv.vw_zg_contas_bancarias TO zglosa;
GRANT SELECT ON dbamv.vw_zg_guias_tiss_ambulatorio TO zglosa;
GRANT SELECT ON dbamv.vw_zg_guias_tiss_internacao TO zglosa;
GRANT SELECT ON dbamv.vw_zg_itens_ambulatorio TO zglosa;
GRANT SELECT ON dbamv.vw_zg_itens_internacao TO zglosa;
GRANT SELECT ON dbamv.vw_zg_itens_nf_ambulatorio TO zglosa;
GRANT SELECT ON dbamv.vw_zg_itens_nf_internacao TO zglosa;
GRANT SELECT ON dbamv.vw_zg_itens_pgto_amb TO zglosa;
GRANT SELECT ON dbamv.vw_zg_itens_pgto_int TO zglosa;
GRANT SELECT ON dbamv.vw_zg_itens_tiss TO zglosa;
GRANT SELECT ON dbamv.vw_zg_lote_por_remessa TO zglosa;
GRANT SELECT ON dbamv.vw_zg_operadoras TO zglosa;
GRANT SELECT ON dbamv.vw_zg_prestadores TO zglosa;
GRANT SELECT ON dbamv.vw_zg_valores_faturados TO zglosa;
GRANT SELECT ON dbamv.vw_zg_valores_pagos TO zglosa;
GRANT SELECT ON dbamv.vw_zg_valores_recebidos TO zglosa;
GRANT EXECUTE ON dbamv.pkg_mv2000 TO zglosa;
 
