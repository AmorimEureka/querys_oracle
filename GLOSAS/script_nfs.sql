/*
  Mapeamento NFS-e / RPS - MV SOUL + MVIntegra
  Validado em producao Oracle DBAMV/CDB1 em 03/07/2026.

  Fluxo do guia:
    1. SOUL gera o RPS.
    2. Usuario imprime/solicita conversao.
    3. MVIntegra envia para a prefeitura e recebe protocolo.
    4. Prefeitura autoriza ou rejeita.
    5. MV grava numero da NFS-e, codigo de verificacao, protocolo e historico.

  Tabelas principais encontradas:

  DBAMV.NOTA_FISCAL
    Cabecalho do RPS/NFS-e.
    Campos-chave:
      CD_NOTA_FISCAL              PK interna.
      NR_ID_NOTA_FISCAL          Numero do RPS.
      NR_NOTA_FISCAL_NFE         Numero da NFS-e autorizada.
      CD_VERIFICACAO_NFE         Codigo de verificacao da NFS-e.
      NR_PROTOCOLO / DT_PROTOCOLO
      CD_PROTOCOLO_NFE
      CD_TIPO_SITUACAO_NOTA_FISCAL
      CD_STATUS_NFE / VER_NFE
      DS_RETORNO_NFE
      DS_URL_ACESSO_NFES / DS_URL_NFE
      SN_ENVIA_RPS_NFSE
      SN_RPS_GERADA
      SN_NOTA_FISCAL_ENVIADA

  DBAMV.TIPO_SITUACAO_NOTA_FISCAL
    Dominio de situacoes do RPS/NFe.
    Exemplos:
      1  RPS Gravado
      2  RPS Impresso
      4  Solicitada conversao de RPS para NFe
      6  Protocolo de conversao de RPS em NFe recebido
      7  Consultando Protocolo de conversao de RPS em NFe
      9  NFe Gerada com sucesso
      10 Falha ao gerar NFe
      23 Reenvio do RPS
      24 RPS na fila de conversao

  DBAMV.HISTORICO_SITUACAO_NOTA_FISCAL
    Historico de alteracoes de situacao, protocolo e mensagens da NFe.

  DBAMV.ITFAT_NOTA_FISCAL
    Itens da nota e ligacao com contas/lancamentos:
      AMB: CD_REG_AMB + CD_LANCAMENTO_AMB -> DBAMV.ITREG_AMB
      FAT: CD_REG_FAT + CD_LANCAMENTO_FAT -> DBAMV.ITREG_FAT

  DBAMV.ITNOTA_FISCAL / ITNOTA_FISCAL_GRU_PRO / ITNOTA_FISCAL_TRIBUTO
    Quebra fiscal por grupo/servico/tributo. Em producao, ITNOTA_FISCAL_TRIBUTO estava sem linhas.

  DBAMV.CON_REC / DBAMV.ITCON_REC
    Contas a receber e parcelas geradas para a nota.

  DBAMV.REG_AMB / REG_FAT / REMESSA_FATURA / FATURA
    Origem da conta, remessa e competencia de faturamento.

  DBAMV.CONFIG_NOTA_FISCAL / CONFIG_NOTA_FISCAL_POR_TIPO
    Parametrizacao de uso de NFe/MVIntegra e validacoes por tipo de nota.

  Observacoes de grao:
    - NOTA_FISCAL e cabecalho; ITFAT_NOTA_FISCAL e item.
    - Nao somar VL_TOTAL_NOTA depois de join direto com itens.
    - A query abaixo agrega itens, historico e financeiro antes do SELECT final.
*/

WITH
params AS (
    SELECT
        ADD_MONTHS(TRUNC(SYSDATE), -3) dt_ini,
        TRUNC(SYSDATE) + 1 dt_fim
    FROM dual
),
notas_base AS (
    SELECT nf.*
    FROM dbamv.nota_fiscal nf
    CROSS JOIN params p
    WHERE nf.dt_emissao >= p.dt_ini
      AND nf.dt_emissao < p.dt_fim
      AND nf.sn_envia_rps_nfse = 'S'
),
itens_nf AS (
    SELECT
        inf.cd_nota_fiscal,
        COUNT(*) qtd_itens_nf,
        COUNT(DISTINCT inf.cd_atendimento) qtd_atendimentos,
        MIN(inf.cd_atendimento) min_cd_atendimento,
        MAX(inf.cd_atendimento) max_cd_atendimento,
        COUNT(DISTINCT inf.cd_reg_amb) qtd_contas_amb,
        COUNT(DISTINCT inf.cd_reg_fat) qtd_contas_fat,
        SUM(NVL(inf.vl_itfat_nf, 0)) vl_itens_nf,
        SUM(NVL(inf.vl_itfat_nf_liq, inf.vl_itfat_nf)) vl_itens_nf_liq,
        SUM(NVL(inf.vl_acrescimo, 0)) vl_acrescimo_itens,
        SUM(NVL(inf.vl_desconto, 0)) vl_desconto_itens,
        SUM(NVL(inf.vl_glosa, 0)) vl_glosa_itens,
        SUM(NVL(inf.vl_recurso, 0)) vl_recurso_itens,
        CASE
            WHEN COUNT(DISTINCT inf.cd_reg_amb) > 0
             AND COUNT(DISTINCT inf.cd_reg_fat) > 0 THEN 'AMB/FAT'
            WHEN COUNT(DISTINCT inf.cd_reg_amb) > 0 THEN 'AMB'
            WHEN COUNT(DISTINCT inf.cd_reg_fat) > 0 THEN 'FAT'
            ELSE 'NAO_IDENTIFICADO'
        END origem_itens
    FROM notas_base nb
    JOIN dbamv.itfat_nota_fiscal inf
      ON inf.cd_nota_fiscal = nb.cd_nota_fiscal
    GROUP BY inf.cd_nota_fiscal
),
grupos_nf AS (
    SELECT
        itnf.cd_nota_fiscal,
        COUNT(*) qtd_grupos_nf,
        SUM(NVL(itnf.vl_gru_fat, 0)) vl_grupos_nf
    FROM notas_base nb
    JOIN dbamv.itnota_fiscal itnf
      ON itnf.cd_nota_fiscal = nb.cd_nota_fiscal
    GROUP BY itnf.cd_nota_fiscal
),
historico AS (
    SELECT
        h.cd_nota_fiscal,
        h.cd_historico_situacao_nf,
        h.cd_tipo_situacao_nota_fiscal,
        ts.ds_situacao_nota_fiscal,
        ts.tp_acao_processamento,
        h.dt_ocorrencia,
        h.cd_usuario,
        h.nr_protocolo,
        h.ds_retorno_nfe,
        h.cd_seq_integra,
        h.tp_origem_nf,
        ROW_NUMBER() OVER (
            PARTITION BY h.cd_nota_fiscal
            ORDER BY h.dt_ocorrencia DESC NULLS LAST,
                     h.cd_historico_situacao_nf DESC
        ) rn
    FROM notas_base nb
    JOIN dbamv.historico_situacao_nota_fiscal h
      ON h.cd_nota_fiscal = nb.cd_nota_fiscal
    LEFT JOIN dbamv.tipo_situacao_nota_fiscal ts
      ON ts.cd_tipo_situacao_nota_fiscal = h.cd_tipo_situacao_nota_fiscal
),
historico_resumo AS (
    SELECT
        h.cd_nota_fiscal,
        COUNT(*) qtd_eventos_historico,
        MIN(h.dt_ocorrencia) dt_primeiro_evento,
        MAX(h.dt_ocorrencia) dt_ultimo_evento,
        MAX(CASE WHEN h.cd_tipo_situacao_nota_fiscal = 1 THEN h.dt_ocorrencia END) dt_rps_gravado,
        MAX(CASE WHEN h.cd_tipo_situacao_nota_fiscal = 2 THEN h.dt_ocorrencia END) dt_rps_impresso,
        MAX(CASE WHEN h.cd_tipo_situacao_nota_fiscal = 4 THEN h.dt_ocorrencia END) dt_solicitada_conversao,
        MAX(CASE WHEN h.cd_tipo_situacao_nota_fiscal = 6 THEN h.dt_ocorrencia END) dt_protocolo_recebido,
        MAX(CASE WHEN h.cd_tipo_situacao_nota_fiscal = 9 THEN h.dt_ocorrencia END) dt_nfse_autorizada,
        MAX(CASE WHEN h.cd_tipo_situacao_nota_fiscal = 10 THEN h.dt_ocorrencia END) dt_falha_geracao,
        MAX(CASE WHEN h.cd_tipo_situacao_nota_fiscal = 23 THEN h.dt_ocorrencia END) dt_reenvio_rps
    FROM historico h
    GROUP BY h.cd_nota_fiscal
),
contas_receber_base AS (
    SELECT DISTINCT
        nb.cd_nota_fiscal,
        cr.cd_con_rec,
        cr.dt_emissao,
        cr.dt_prevista_pagamento,
        cr.cd_remessa,
        cr.vl_previsto,
        cr.vl_recebido,
        cr.vl_imposto,
        cr.vl_desconto,
        cr.vl_acrescimo,
        cr.vl_glosa
    FROM notas_base nb
    JOIN dbamv.con_rec cr
      ON cr.cd_nota_fiscal = nb.cd_nota_fiscal

    UNION

    SELECT DISTINCT
        nb.cd_nota_fiscal,
        cr.cd_con_rec,
        cr.dt_emissao,
        cr.dt_prevista_pagamento,
        cr.cd_remessa,
        cr.vl_previsto,
        cr.vl_recebido,
        cr.vl_imposto,
        cr.vl_desconto,
        cr.vl_acrescimo,
        cr.vl_glosa
    FROM notas_base nb
    JOIN dbamv.con_rec cr
      ON cr.cd_con_rec = nb.cd_con_rec_nfa
),
contas_receber AS (
    SELECT
        cr.cd_nota_fiscal,
        COUNT(DISTINCT cr.cd_con_rec) qtd_con_rec,
        MIN(cr.cd_con_rec) min_cd_con_rec,
        MAX(cr.cd_con_rec) max_cd_con_rec,
        MIN(cr.dt_emissao) dt_emissao_con_rec,
        MIN(cr.dt_prevista_pagamento) dt_prevista_pagamento,
        SUM(NVL(cr.vl_previsto, 0)) vl_previsto_con_rec,
        SUM(NVL(cr.vl_recebido, 0)) vl_recebido_con_rec,
        SUM(NVL(cr.vl_imposto, 0)) vl_imposto_con_rec,
        SUM(NVL(cr.vl_desconto, 0)) vl_desconto_con_rec,
        SUM(NVL(cr.vl_acrescimo, 0)) vl_acrescimo_con_rec,
        SUM(NVL(cr.vl_glosa, 0)) vl_glosa_con_rec
    FROM contas_receber_base cr
    GROUP BY cr.cd_nota_fiscal
),
parcelas_receber AS (
    SELECT
        cr.cd_nota_fiscal,
        COUNT(*) qtd_parcelas,
        MIN(ir.dt_vencimento) dt_primeiro_vencimento,
        MAX(ir.dt_vencimento) dt_ultimo_vencimento,
        MIN(ir.dt_prevista_recebimento) dt_primeira_prev_receb,
        MAX(ir.dt_prevista_recebimento) dt_ultima_prev_receb,
        SUM(NVL(ir.vl_duplicata, 0)) vl_duplicata,
        SUM(NVL(ir.vl_soma_recebido, 0)) vl_soma_recebido,
        SUM(NVL(ir.vl_saldo_nota_fiscal, 0)) vl_saldo_nota_fiscal
    FROM contas_receber_base cr
    JOIN dbamv.itcon_rec ir
      ON ir.cd_con_rec = cr.cd_con_rec
    GROUP BY cr.cd_nota_fiscal
)
SELECT
    nf.cd_nota_fiscal,
    nf.nr_id_nota_fiscal nr_rps,
    nf.cd_serie,
    nf.nr_nota_fiscal_nfe nr_nfse,
    nf.cd_verificacao_nfe,
    nf.nr_protocolo,
    nf.dt_protocolo,
    nf.cd_protocolo_nfe,
    nf.nm_protocolo_autorizacao_uso,
    nf.nr_protocolo_cancelamento,
    nf.dt_emissao,
    nf.hr_emissao_nfe,
    nf.dt_cancelamento_nfe,
    nf.cd_multi_empresa,
    nf.cd_convenio,
    c.nm_convenio,
    nf.tp_nota_fiscal,
    CASE nf.tp_nota_fiscal
        WHEN 'P' THEN 'PARTICULAR'
        WHEN 'C' THEN 'CONVENIO'
        WHEN 'A' THEN 'AVULSA'
        ELSE nf.tp_nota_fiscal
    END ds_tipo_nota_fiscal,
    nf.cd_atendimento,
    nf.cd_remessa,
    rf.cd_fatura,
    f.dt_competencia,
    nf.cd_reg_amb,
    nf.cd_reg_fat,
    CASE
        WHEN nf.cd_reg_amb IS NOT NULL AND nf.cd_reg_fat IS NOT NULL THEN 'AMB/FAT'
        WHEN nf.cd_reg_amb IS NOT NULL THEN 'AMB'
        WHEN nf.cd_reg_fat IS NOT NULL THEN 'FAT'
        ELSE NVL(it.origem_itens, 'NAO_IDENTIFICADO')
    END origem_conta,
    nf.nm_cliente tomador_nome,
    nf.nr_cgc_cpf tomador_cpf_cnpj,
    nf.nr_inscricao_municipal tomador_inscricao_municipal,
    nf.nm_cidade tomador_cidade,
    nf.nm_uf tomador_uf,
    nf.nr_cep tomador_cep,
    nf.vl_total_nota,
    nf.vl_iss,
    nf.vl_perc_iss,
    nf.vl_ir,
    nf.tp_tributo_retido,
    nf.cd_cod_servico_nf,
    nf.cd_cnae,
    nf.ds_item_lista_servico,
    nf.cd_tributacao_municipal,
    nf.sn_optante_pelo_simples,
    nf.sn_incentivador_cultural,
    nf.tp_regime_especial_tributacao,
    nf.sn_envia_rps_nfse,
    nf.sn_rps_gerada,
    nf.sn_nota_fiscal_enviada,
    nf.cd_status_nfe,
    CASE nf.cd_status_nfe
        WHEN 'W' THEN 'Registro recem inserido'
        WHEN 'A' THEN 'Aguardando processamento da integracao'
        WHEN 'I' THEN 'Integracao iniciada'
        WHEN 'P' THEN 'Em processamento'
        WHEN 'R' THEN 'Retorno com falha/rejeicao'
        WHEN 'X' THEN 'RPS impresso/pendente de conversao'
        WHEN 'N' THEN 'Nao processado'
        ELSE nf.cd_status_nfe
    END ds_status_nfe,
    nf.ver_nfe,
    nf.cd_tipo_situacao_nota_fiscal,
    ts.ds_situacao_nota_fiscal,
    ts.tp_acao_processamento,
    CASE
        WHEN nf.cd_tipo_situacao_nota_fiscal = 9 THEN 'NFSE_AUTORIZADA'
        WHEN nf.cd_tipo_situacao_nota_fiscal IN (8, 10, 13, 15, 17, 20) THEN 'FALHA_OU_REJEICAO'
        WHEN nf.cd_tipo_situacao_nota_fiscal IN (4, 5, 6, 7, 11, 14, 19, 24) THEN 'EM_PROCESSAMENTO'
        WHEN nf.cd_tipo_situacao_nota_fiscal IN (1, 2, 22, 23) THEN 'RPS_PENDENTE_OU_REENVIO'
        WHEN nf.cd_tipo_situacao_nota_fiscal = 3 THEN 'RPS_CANCELADO'
        WHEN nf.cd_tipo_situacao_nota_fiscal = 12 THEN 'NFSE_CANCELADA'
        WHEN nf.cd_tipo_situacao_nota_fiscal = 18 THEN 'NFSE_SUBSTITUIDA'
        WHEN nf.cd_tipo_situacao_nota_fiscal = 21 THEN 'CARTA_CORRECAO_ENVIADA'
        ELSE 'NAO_CLASSIFICADO'
    END ds_fluxo_nfse,
    nf.ds_retorno_nfe retorno_atual_nfe,
    nf.ds_url_acesso_nfes,
    nf.ds_url_nfe,
    h.cd_tipo_situacao_nota_fiscal cd_ultima_situacao_hist,
    h.ds_situacao_nota_fiscal ds_ultima_situacao_hist,
    h.dt_ocorrencia dt_ultima_ocorrencia_hist,
    h.cd_usuario cd_usuario_ultima_ocorrencia,
    h.nr_protocolo nr_protocolo_ultimo_hist,
    h.ds_retorno_nfe retorno_ultimo_hist,
    hr.qtd_eventos_historico,
    hr.dt_primeiro_evento,
    hr.dt_ultimo_evento,
    hr.dt_rps_gravado,
    hr.dt_rps_impresso,
    hr.dt_solicitada_conversao,
    hr.dt_protocolo_recebido,
    hr.dt_nfse_autorizada,
    hr.dt_falha_geracao,
    hr.dt_reenvio_rps,
    it.qtd_itens_nf,
    it.qtd_atendimentos,
    it.min_cd_atendimento,
    it.max_cd_atendimento,
    it.qtd_contas_amb,
    it.qtd_contas_fat,
    it.vl_itens_nf,
    it.vl_itens_nf_liq,
    ROUND(NVL(nf.vl_total_nota, 0) - NVL(it.vl_itens_nf, 0), 2) dif_total_cabecalho_x_itens,
    it.vl_acrescimo_itens,
    it.vl_desconto_itens,
    it.vl_glosa_itens,
    it.vl_recurso_itens,
    gn.qtd_grupos_nf,
    gn.vl_grupos_nf,
    cr.qtd_con_rec,
    cr.min_cd_con_rec,
    cr.max_cd_con_rec,
    cr.dt_emissao_con_rec,
    cr.dt_prevista_pagamento,
    cr.vl_previsto_con_rec,
    cr.vl_recebido_con_rec,
    cr.vl_imposto_con_rec,
    cr.vl_desconto_con_rec,
    cr.vl_acrescimo_con_rec,
    cr.vl_glosa_con_rec,
    pr.qtd_parcelas,
    pr.dt_primeiro_vencimento,
    pr.dt_ultimo_vencimento,
    pr.dt_primeira_prev_receb,
    pr.dt_ultima_prev_receb,
    pr.vl_duplicata,
    pr.vl_soma_recebido,
    pr.vl_saldo_nota_fiscal
FROM notas_base nf
LEFT JOIN dbamv.tipo_situacao_nota_fiscal ts
  ON ts.cd_tipo_situacao_nota_fiscal = nf.cd_tipo_situacao_nota_fiscal
LEFT JOIN dbamv.convenio c
  ON c.cd_convenio = nf.cd_convenio
LEFT JOIN dbamv.remessa_fatura rf
  ON rf.cd_remessa = nf.cd_remessa
LEFT JOIN dbamv.fatura f
  ON f.cd_fatura = rf.cd_fatura
LEFT JOIN itens_nf it
  ON it.cd_nota_fiscal = nf.cd_nota_fiscal
LEFT JOIN grupos_nf gn
  ON gn.cd_nota_fiscal = nf.cd_nota_fiscal
LEFT JOIN historico h
  ON h.cd_nota_fiscal = nf.cd_nota_fiscal
 AND h.rn = 1
LEFT JOIN historico_resumo hr
  ON hr.cd_nota_fiscal = nf.cd_nota_fiscal
LEFT JOIN contas_receber cr
  ON cr.cd_nota_fiscal = nf.cd_nota_fiscal
LEFT JOIN parcelas_receber pr
  ON pr.cd_nota_fiscal = nf.cd_nota_fiscal
ORDER BY nf.dt_emissao DESC, nf.cd_nota_fiscal DESC
;
