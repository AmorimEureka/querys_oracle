
-- "Serviços da Conta" + "Dados da Conta" da tela "M_LAN_HOS" e "M_LAN_AMB_PARTICULAR"

SELECT
    *
FROM (
  SELECT
        it.cd_reg_fat AS cd_reg,
        it.cd_lancamento,
        rf.cd_atendimento,
        a.cd_paciente,
        p.nm_paciente,
        rf.cd_remessa,
        rf.cd_regra,
        r.ds_regra,
        rf.cd_convenio,
        c.nr_cgc AS cnpj_convenio,
        -- c.nm_convenio,
        CASE
            WHEN rf.cd_convenio = 3 THEN 'PARTICULAR'
            WHEN s.cd_sub_plano IN ('200', '300') THEN 'SUS - INTERNACAO (' || s.ds_sub_plano || ')'
            WHEN rf.cd_convenio = 1 AND ot.cd_ori_ate = 3 THEN 'SUS - INTERNACAO (MUNICIPIO)'
            WHEN rf.cd_convenio = 1 AND ot.cd_ori_ate = 18 THEN 'SUS - INTERNACAO (ESTADO)'
            ELSE c.nm_convenio
        END nm_convenio,
        it.cd_gru_fat,
        gf.ds_gru_fat,
        it.cd_pro_fat,
        pf.ds_pro_fat AS descricao,
        g.nr_guia,
        g.cd_senha,
        f.ds_fatura,
        a.dt_atendimento,
        a.dt_alta,
        rf.dt_remessa,
        f.dt_competencia,
        rf.dt_fechamento,
        it.dt_lancamento,
        it.hr_lancamento,
        it.cd_prestador,
        pr.nm_prestador,
        rf.sn_fechada,
        it.sn_pertence_pacote,
        it.qt_lancamento,
        it.vl_unitario,
        it.vl_total_conta,
        it.vl_honorario_unitario,
        it.vl_acrescimo,
        it.vl_desconto,
        it.cd_ati_med,
        am.ds_ati_med,
        it.cd_usuario,
        u.nm_usuario,
        CASE
            WHEN a.tp_atendimento = 'A' THEN 'Ambulatório'
            WHEN a.tp_atendimento = 'E' THEN 'Externo'
            WHEN a.tp_atendimento = 'U' THEN 'Urgência'
            WHEN a.tp_atendimento = 'I' THEN 'Internação'
            ELSE NULL
        END AS tp_atendimento,
        TO_DATE(
            TO_CHAR(it.dt_lancamento, 'DD/MM/YYYY') ||
            TO_CHAR(it.hr_lancamento, 'HH24:MI:SS'),
            'DD/MM/YYYYHH24:MI:SS'
        ) AS dt_ordenacao
        FROM dbamv.itreg_fat it
        LEFT JOIN dbamv.reg_fat rf        ON it.cd_reg_fat     = rf.cd_reg_fat
        LEFT JOIN dbamv.pro_fat pf        ON it.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf        ON it.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr      ON it.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am        ON it.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u       ON it.cd_usuario     = u.cd_usuario
        LEFT JOIN dbamv.atendime a        ON rf.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c        ON rf.cd_convenio    = c.cd_convenio
        LEFT JOIN dbamv.guia g            ON it.cd_guia        = g.cd_guia
        LEFT JOIN dbamv.regra r           ON rf.cd_regra       = r.cd_regra
        LEFT JOIN dbamv.remessa_fatura re ON rf.cd_remessa     = re.cd_remessa
        LEFT JOIN dbamv.fatura f          ON re.cd_fatura      = f.cd_fatura
        LEFT JOIN dbamv.paciente p        ON a.cd_paciente     = p.cd_paciente
        LEFT JOIN dbamv.ori_ate ot        ON a.cd_ori_ate      = ot.cd_ori_ate
        LEFT JOIN dbamv.sub_plano s       ON s.cd_convenio     = a.cd_convenio
                                         AND s.cd_con_pla      = rf.cd_con_pla
                                         AND s.cd_sub_plano    = a.cd_sub_plano

    UNION ALL

    SELECT
        ia.cd_reg_amb AS cd_reg,
        ia.cd_lancamento,
        ia.cd_atendimento,
        a.cd_paciente,
        p.nm_paciente,
        ra.cd_remessa,
        ra.cd_regra,
        r.ds_regra,
        ra.cd_convenio,
        c.nr_cgc AS cnpj_convenio,
        -- c.nm_convenio,
        CASE
            WHEN ra.cd_convenio = 3 THEN 'PARTICULAR'
            WHEN s.cd_sub_plano IN ('200', '300') THEN 'SUS - INTERNACAO (' || s.ds_sub_plano || ')'
            WHEN ra.cd_convenio = 1 AND ot.cd_ori_ate = 3 THEN 'SUS - INTERNACAO (MUNICIPIO)'
            WHEN ra.cd_convenio = 1 AND ot.cd_ori_ate = 18 THEN 'SUS - INTERNACAO (ESTADO)'
            ELSE c.nm_convenio
        END nm_convenio,
        ia.cd_gru_fat,
        gf.ds_gru_fat,
        ia.cd_pro_fat,
        pf.ds_pro_fat AS descricao,
        g.nr_guia,
        g.cd_senha,
        f.ds_fatura,
        a.dt_atendimento,
        a.dt_alta,
        ra.dt_remessa,
        f.dt_competencia,
        ia.dt_fechamento,
        ra.dt_lancamento_final AS dt_lancamento,
        ia.hr_lancamento,
        ia.cd_prestador,
        pr.nm_prestador,
        ia.sn_fechada,
        ia.sn_pertence_pacote,
        ia.qt_lancamento,
        ia.vl_unitario,
        ia.vl_total_conta,
        ia.vl_honorario_unitario,
        ia.vl_acrescimo,
        ia.vl_desconto,
        ia.cd_ati_med,
        am.ds_ati_med,
        ia.cd_usuario,
        ia.nm_usuario,
        CASE
            WHEN a.tp_atendimento = 'A' THEN 'Ambulatório'
            WHEN a.tp_atendimento = 'E' THEN 'Externo'
            WHEN a.tp_atendimento = 'U' THEN 'Urgência'
            WHEN a.tp_atendimento = 'I' THEN 'Internação'
            ELSE NULL
        END AS tp_atendimento,
        TO_DATE(
            TO_CHAR(ra.dt_lancamento_final, 'DD/MM/YYYY') ||
            TO_CHAR(ia.hr_lancamento, 'HH24:MI:SS'),
            'DD/MM/YYYYHH24:MI:SS'
        ) AS dt_ordenacao
        FROM dbamv.itreg_amb ia
        LEFT JOIN dbamv.reg_amb ra        ON ia.cd_reg_amb     = ra.cd_reg_amb
        LEFT JOIN dbamv.pro_fat pf        ON ia.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf        ON ia.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr      ON ia.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am        ON ia.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u       ON ia.cd_usuario     = u.cd_usuario
        LEFT JOIN dbamv.atendime a        ON ia.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c        ON ra.cd_convenio    = c.cd_convenio
        LEFT JOIN dbamv.guia g            ON ia.cd_guia        = g.cd_guia
        LEFT JOIN dbamv.regra r           ON ra.cd_regra       = r.cd_regra
        LEFT JOIN dbamv.remessa_fatura re ON ra.cd_remessa     = re.cd_remessa
        LEFT JOIN dbamv.fatura f          ON re.cd_fatura      = f.cd_fatura
        LEFT JOIN dbamv.paciente p        ON a.cd_paciente     = p.cd_paciente
        LEFT JOIN dbamv.ori_ate ot        ON a.cd_ori_ate      = ot.cd_ori_ate
        LEFT JOIN dbamv.sub_plano s       ON s.cd_convenio     = a.cd_convenio
                                         AND s.cd_con_pla      = ia.cd_con_pla
                                         AND s.cd_sub_plano    = a.cd_sub_plano
)
ORDER BY dt_ordenacao DESC, sn_pertence_pacote ASC
;

SELECT * FROM DBAMV.NOTA_FISCAL WHERE CD_NOTA_FISCAL = 25114;
SELECT * FROM DBAMV.NOTA_FISCAL WHERE NR_ID_NOTA_FISCAL = 25114;
SELECT * FROM DBAMV.NOTA_FISCAL WHERE NR_NOTA_FISCAL_NFE = 25114;
SELECT * FROM dbamv.HPC_V_CONTA_ATENDIMENTO WHERE CD_ATENDIMENTO = 301886;
SELECT * FROM dbamv.HPC_V_CONTA_ATENDIMENTO WHERE CD_REMESSA = 17413;



CREATE OR REPLACE VIEW dbamv.HPC_V_CONTA_ATENDIMENTO AS
  SELECT
        it.cd_reg_fat AS cd_reg,
        it.cd_lancamento,
        rf.cd_atendimento,
        a.cd_paciente,
        p.nm_paciente,
        rf.cd_remessa,
        rf.cd_regra,
        r.ds_regra,
        rf.cd_convenio,
        c.nr_cgc AS cnpj_convenio,
        -- c.nm_convenio,
        CASE
            WHEN rf.cd_convenio = 3 THEN 'PARTICULAR'
            WHEN s.cd_sub_plano IN ('200', '300') THEN 'SUS - INTERNACAO (' || s.ds_sub_plano || ')'
            WHEN rf.cd_convenio = 1 AND ot.cd_ori_ate = 3 THEN 'SUS - INTERNACAO (MUNICIPIO)'
            WHEN rf.cd_convenio = 1 AND ot.cd_ori_ate = 18 THEN 'SUS - INTERNACAO (ESTADO)'
            ELSE c.nm_convenio
        END nm_convenio,
        it.cd_gru_fat,
        gf.ds_gru_fat,
        it.cd_pro_fat,
        pf.ds_pro_fat AS descricao,
        g.nr_guia,
        g.cd_senha,
        f.ds_fatura,
        a.dt_atendimento,
        a.dt_alta,
        rf.dt_remessa,
        f.dt_competencia,
        rf.dt_fechamento,
        it.dt_lancamento,
        it.hr_lancamento,
        it.cd_prestador,
        pr.nm_prestador,
        rf.sn_fechada,
        it.sn_pertence_pacote,
        it.qt_lancamento,
        it.vl_unitario,
        it.vl_total_conta,
        rf.vl_total_conta AS vl_total_registro,
        it.vl_honorario_unitario,
        it.vl_acrescimo,
        it.vl_desconto,
        it.cd_ati_med,
        am.ds_ati_med,
        it.cd_usuario,
        u.nm_usuario,
        CASE
            WHEN a.tp_atendimento = 'A' THEN 'Ambulatório'
            WHEN a.tp_atendimento = 'E' THEN 'Externo'
            WHEN a.tp_atendimento = 'U' THEN 'Urgência'
            WHEN a.tp_atendimento = 'I' THEN 'Internação'
            ELSE NULL
        END AS tp_atendimento,
        TO_DATE(
            TO_CHAR(it.dt_lancamento, 'DD/MM/YYYY') ||
            TO_CHAR(it.hr_lancamento, 'HH24:MI:SS'),
            'DD/MM/YYYYHH24:MI:SS'
        ) AS dt_ordenacao
        FROM dbamv.itreg_fat it
        LEFT JOIN dbamv.reg_fat rf        ON it.cd_reg_fat     = rf.cd_reg_fat
        LEFT JOIN dbamv.pro_fat pf        ON it.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf        ON it.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr      ON it.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am        ON it.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u       ON it.cd_usuario     = u.cd_usuario
        LEFT JOIN dbamv.atendime a        ON rf.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c        ON rf.cd_convenio    = c.cd_convenio
        LEFT JOIN dbamv.guia g            ON it.cd_guia        = g.cd_guia
        LEFT JOIN dbamv.regra r           ON rf.cd_regra       = r.cd_regra
        LEFT JOIN dbamv.remessa_fatura re ON rf.cd_remessa     = re.cd_remessa
        LEFT JOIN dbamv.fatura f          ON re.cd_fatura      = f.cd_fatura
        LEFT JOIN dbamv.paciente p        ON a.cd_paciente     = p.cd_paciente
        LEFT JOIN dbamv.ori_ate ot        ON a.cd_ori_ate      = ot.cd_ori_ate
        LEFT JOIN dbamv.sub_plano s       ON s.cd_convenio     = a.cd_convenio
                                         AND s.cd_con_pla      = rf.cd_con_pla
                                         AND s.cd_sub_plano    = a.cd_sub_plano

    UNION ALL

    SELECT
        ia.cd_reg_amb AS cd_reg,
        ia.cd_lancamento,
        ia.cd_atendimento,
        a.cd_paciente,
        p.nm_paciente,
        ra.cd_remessa,
        ra.cd_regra,
        r.ds_regra,
        ra.cd_convenio,
        c.nr_cgc AS cnpj_convenio,
        -- c.nm_convenio,
        CASE
            WHEN ra.cd_convenio = 3 THEN 'PARTICULAR'
            WHEN s.cd_sub_plano IN ('200', '300') THEN 'SUS - INTERNACAO (' || s.ds_sub_plano || ')'
            WHEN ra.cd_convenio = 1 AND ot.cd_ori_ate = 3 THEN 'SUS - INTERNACAO (MUNICIPIO)'
            WHEN ra.cd_convenio = 1 AND ot.cd_ori_ate = 18 THEN 'SUS - INTERNACAO (ESTADO)'
            ELSE c.nm_convenio
        END nm_convenio,
        ia.cd_gru_fat,
        gf.ds_gru_fat,
        ia.cd_pro_fat,
        pf.ds_pro_fat AS descricao,
        g.nr_guia,
        g.cd_senha,
        f.ds_fatura,
        a.dt_atendimento,
        a.dt_alta,
        ra.dt_remessa,
        f.dt_competencia,
        ia.dt_fechamento,
        ra.dt_lancamento_final AS dt_lancamento,
        ia.hr_lancamento,
        ia.cd_prestador,
        pr.nm_prestador,
        ia.sn_fechada,
        ia.sn_pertence_pacote,
        ia.qt_lancamento,
        ia.vl_unitario,
        ia.vl_total_conta,
        ra.vl_total_conta AS vl_total_registro,
        ia.vl_honorario_unitario,
        ia.vl_acrescimo,
        ia.vl_desconto,
        ia.cd_ati_med,
        am.ds_ati_med,
        ia.cd_usuario,
        ia.nm_usuario,
        CASE
            WHEN a.tp_atendimento = 'A' THEN 'Ambulatório'
            WHEN a.tp_atendimento = 'E' THEN 'Externo'
            WHEN a.tp_atendimento = 'U' THEN 'Urgência'
            WHEN a.tp_atendimento = 'I' THEN 'Internação'
            ELSE NULL
        END AS tp_atendimento,
        TO_DATE(
            TO_CHAR(ra.dt_lancamento_final, 'DD/MM/YYYY') ||
            TO_CHAR(ia.hr_lancamento, 'HH24:MI:SS'),
            'DD/MM/YYYYHH24:MI:SS'
        ) AS dt_ordenacao
        FROM dbamv.itreg_amb ia
        LEFT JOIN dbamv.reg_amb ra        ON ia.cd_reg_amb     = ra.cd_reg_amb
        LEFT JOIN dbamv.pro_fat pf        ON ia.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf        ON ia.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr      ON ia.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am        ON ia.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u       ON ia.cd_usuario     = u.cd_usuario
        LEFT JOIN dbamv.atendime a        ON ia.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c        ON ra.cd_convenio    = c.cd_convenio
        LEFT JOIN dbamv.guia g            ON ia.cd_guia        = g.cd_guia
        LEFT JOIN dbamv.regra r           ON ra.cd_regra       = r.cd_regra
        LEFT JOIN dbamv.remessa_fatura re ON ra.cd_remessa     = re.cd_remessa
        LEFT JOIN dbamv.fatura f          ON re.cd_fatura      = f.cd_fatura
        LEFT JOIN dbamv.paciente p        ON a.cd_paciente     = p.cd_paciente
        LEFT JOIN dbamv.ori_ate ot        ON a.cd_ori_ate      = ot.cd_ori_ate
        LEFT JOIN dbamv.sub_plano s       ON s.cd_convenio     = a.cd_convenio
                                         AND s.cd_con_pla      = ia.cd_con_pla
                                         AND s.cd_sub_plano    = a.cd_sub_plano
    ;





# -------------------------------------------------------------------------------------------------------


SELECT * FROM dbamv.HPC_V_CONVENIOS;

CREATE OR REPLACE VIEW dbamv.HPC_V_CONVENIOS AS
    SELECT
        CD_CONVENIO,
        NR_CGC AS cnpj_convenio,
        NM_CONVENIO
    FROM DBAMV.CONVENIO
    WHERE SN_ATIVO = 'S'
;



# -------------------------------------------------------------------------------------------------------

SELECT * FROM dbamv.HPC_V_CONTAS_BANCARIAS;

CREATE OR REPLACE VIEW dbamv.HPC_V_CONTAS_BANCARIAS AS
  SELECT
	cd_con_cor,
	ds_con_cor,
	cd_agencia,
	cd_digito_agencia,
	nr_conta,
	cd_digito_conta_corrente
FROM DBAMV.CON_COR
;


# -------------------------------------------------------------------------------------------------------


SELECT
    *
FROM DBAMV.NOTA_FISCAL
WHERE NR_NOTA_FISCAL_NFE = 5339
;



✅
-- CREATE OR REPLACE FORCE VIEW vw_zg_itens_nf_ambulatorio (
--         cd_remessa,
--         agrupador_envio,
--         valor_total_item,
--         conta,
--         cd_atendimento,
--         codigo_lancamento,
--         codigo_nota_fiscal,
--         nota_fiscal,
--         nota_fiscal_avulsa,
--         numero_nota_fiscal_eletronica,
--         codigo_convenio,
--         data_emissao_nota_fiscal,
--         data_vencimento_nota_fiscal
-- ) AS
    SELECT
        inf.cd_remessa,
        inf.id_it_envio,
        inf.vl_itfat_nf,
        inf.cd_reg_amb,
        inf.cd_atendimento,
        inf.cd_lancamento_amb,
        nf.cd_nota_fiscal,
        TO_CHAR(nf.nr_id_nota_fiscal) AS nota_fiscal,
        nf.nr_nota_fiscal_nfe,
        nf.cd_convenio,
        NVL(nf.dt_emissao, cr.dt_emissao) AS dt_emissao,
        NVL(ir.dt_vencimento,
            NVL(ir.dt_prevista_recebimento,
                (SELECT DT_VENCIMENTO
                 FROM dbamv.itcon_rec ir
                 JOIN dbamv.con_rec contas_a_receber
                    ON ir.cd_con_rec = cr.cd_con_rec
                 WHERE cr.cd_nota_fiscal = inf.cd_nota_fiscal
                    AND ROWNUM = 1))) AS data_vencimento_nota_fiscal
    FROM dbamv.itfat_nota_fiscal inf
    JOIN dbamv.nota_fiscal nf
        ON nf.cd_nota_fiscal = inf.cd_nota_fiscal
    LEFT JOIN dbamv.con_rec cr
        ON cr.cd_nota_fiscal = inf.cd_nota_fiscal
        AND cr.cd_remessa = inf.cd_remessa
    LEFT JOIN dbamv.itcon_rec ir
        ON ir.cd_con_rec = cr.cd_con_rec
WHERE inf.cd_reg_fat IS NULL
;


# -------------------------------------------------------------------------------------------------------

✅

-- CREATE OR REPLACE FORCE VIEW vw_zg_itens_nf_internacao (
--         cd_remessa,
--         agrupador_envio,
--         valor_total_item,
--         conta,
--         cd_atendimento,
--         codigo_lancamento,
--         codigo_nota_fiscal,
--         nota_fiscal,
--         nota_fiscal_avulsa,
--         numero_nota_fiscal_eletronica,
--         codigo_convenio,
--         data_emissao_nota_fiscal,
--         data_vencimento_nota_fiscal
-- ) AS
    SELECT
        inf.cd_remessa,
        inf.id_it_envio,
        inf.vl_itfat_nf,
        inf.cd_reg_fat,
        inf.cd_atendimento,
        inf.cd_lancamento_fat,
        nf.cd_nota_fiscal,
        TO_CHAR(nf.nr_id_nota_fiscal) AS nr_id_nota_fiscal,
        nf.nr_nota_fiscal_nfe,
        nf.cd_convenio,
        NVL(nf.dt_emissao, cr.dt_emissao) AS dt_emissao,
        NVL(ir.dt_vencimento,
            NVL(ir.dt_prevista_recebimento,
                (SELECT ir.DT_VENCIMENTO
                 FROM dbamv.itcon_rec ir
                 JOIN dbamv.con_rec cr
                    ON ir.cd_con_rec = cr.cd_con_rec
                 WHERE cr.cd_nota_fiscal = inf.cd_nota_fiscal
                    AND ROWNUM = 1))) AS data_vencimento_nota_fiscal
    FROM dbamv.itfat_nota_fiscal inf
    JOIN dbamv.nota_fiscal nf
        ON nf.cd_nota_fiscal = inf.cd_nota_fiscal
    LEFT JOIN dbamv.con_rec cr
        ON cr.cd_nota_fiscal = inf.cd_nota_fiscal
        AND cr.cd_remessa = inf.cd_remessa
    LEFT JOIN dbamv.itcon_rec ir
        ON ir.cd_con_rec = cr.cd_con_rec
WHERE inf.cd_reg_amb IS NULL
AND nf.nr_nota_fiscal_nfe = 22464
;

# -------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------

-- ✅

-- CREATE OR REPLACE FORCE VIEW vw_zg_valores_faturados (
-- 													  versao,
-- 													  remessa,
-- 													  identificador,
-- 													  status_remessa,
-- 													  data_remessa,
-- 													  data_envio_remessa,
-- 													  data_emissao,
-- 													  data_vencimento_remessa,
-- 													  data_fechamento_remessa,
-- 													  valor,
-- 													  tem_nota_fiscal,
-- 													  versao_tiss,
-- 													  protocolo,
-- 													  codigo_prestador_na_operadora,
-- 													  tem_xml,
-- 													  competencia,
-- 													  data_competencia,
-- 													  id_prestador_erp,
-- 													  cod_con,
-- 													  nome_convenio
-- 	) AS
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
			WHERE reg_amb.cd_remessa = remessa.cd_remessa)
;

# -------------------------------------------------------------------------------------------------------





SELECT *
FROM dbamv.atendime
WHERE dt_alta > TO_DATE('15/06/2026', 'DD/MM/YYYY') AND TP_ATENDIMENTO = 'I'
;



SELECT * FROM DBAMV.HPC_V_PACIENTES;

CREATE OR REPLACE VIEW dbamv.HPC_V_PACIENTES AS
    SELECT
        CD_PACIENTE,
        NM_PACIENTE AS PACIENTE,
        NM_MAE AS NOME_MAE,
        NR_CPF AS CPF,
        NR_CEP AS CEP,
        DS_ENDERECO AS RUA,
        NR_ENDERECO AS NUMERO_CASA,
        NM_BAIRRO AS BAIRRO,
        DS_COMPLEMENTO AS COMPLEMENTO,
        EMAIL,
        COALESCE(NR_FONE, NR_CELULAR) AS CONTATO,
        COALESCE(NR_DDD_CELULAR, NR_DDD_FONE) AS DDD
    FROM DBAMV.PACIENTE
;