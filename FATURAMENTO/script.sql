/*
  Reproducao das fontes reais do painel FATURAMENTO TOTAL.

  SUS Municipio/Estado:
    DBAMV.V_FFIS_VALOR_PRESTADOR_AIH, por DT_COMPETENCIA e VL_LINHA.

  Convenio/Particular:
    REG_FAT + REG_AMB, ligados a REMESSA_FATURA/FATURA, por DT_COMPETENCIA.

  Observacao: as consultas originais do painel nao possuem filtro SN_FECHADA.
*/
WITH sus
    AS (
        SELECT
            TRUNC(v.dt_competencia, 'MM') competencia,
            CASE
                WHEN ot.cd_ori_ate IN (26, 18, 3) AND s.cd_sub_plano = '300' THEN 'ESTADO'
                WHEN ot.cd_ori_ate IN (18, 3) AND s.cd_sub_plano = '200' THEN 'MUNICIPIO'
                WHEN ot.cd_ori_ate = 3  AND s.cd_sub_plano IS NULL THEN 'MUNICIPIO'
                WHEN ot.cd_ori_ate IN (18, 1) AND s.cd_sub_plano IS NULL THEN 'ESTADO'
                ELSE NVL(s.ds_sub_plano, c.nm_convenio)
            END sub_plano,
            NVL(v.vl_linha, 0) valor
        FROM dbamv.v_ffis_valor_prestador_aih v
        LEFT JOIN dbamv.reg_fat rf ON rf.cd_reg_fat = v.cd_reg_fat
        LEFT JOIN dbamv.atendime a ON a.cd_atendimento = rf.cd_atendimento
        LEFT JOIN dbamv.ori_ate ot ON ot.cd_ori_ate = a.cd_ori_ate
        LEFT JOIN dbamv.convenio c ON c.cd_convenio = a.cd_convenio
        LEFT JOIN dbamv.sub_plano s
        ON s.cd_convenio = a.cd_convenio
        AND s.cd_sub_plano = a.cd_sub_plano
        WHERE v.dt_competencia >= DATE '2026-01-01'
        AND v.dt_competencia < DATE '2026-08-01'
),
contas
    AS (
        SELECT DISTINCT
            TRUNC(f.dt_competencia, 'MM') competencia,
            rf.cd_atendimento,
            rf.cd_reg_fat conta,
            rf.cd_convenio,
            rf.cd_con_pla,
            c.nm_convenio,
            s.cd_sub_plano,
            s.ds_sub_plano,
            ot.cd_ori_ate,
            NVL(rf.vl_total_conta, 0) valor
        FROM dbamv.reg_fat rf
        LEFT JOIN dbamv.atendime a ON a.cd_atendimento = rf.cd_atendimento
        LEFT JOIN dbamv.ori_ate ot ON ot.cd_ori_ate = a.cd_ori_ate
        LEFT JOIN dbamv.remessa_fatura re ON re.cd_remessa = rf.cd_remessa
        LEFT JOIN dbamv.fatura f ON f.cd_fatura = re.cd_fatura
        LEFT JOIN dbamv.convenio c ON c.cd_convenio = rf.cd_convenio
        LEFT JOIN dbamv.sub_plano s
        ON s.cd_convenio = c.cd_convenio
        AND s.cd_con_pla = rf.cd_con_pla
        AND s.cd_sub_plano = a.cd_sub_plano
        WHERE rf.cd_atendimento IS NOT NULL
        AND f.dt_competencia >= DATE '2026-01-01'
        AND f.dt_competencia < DATE '2026-08-01'

        UNION ALL

        SELECT DISTINCT
            TRUNC(f.dt_competencia, 'MM'),
            ib.cd_atendimento,
            rb.cd_reg_amb,
            rb.cd_convenio,
            ib.cd_con_pla,
            c.nm_convenio,
            s.cd_sub_plano,
            s.ds_sub_plano,
            ot.cd_ori_ate,
            NVL(rb.vl_total_conta, 0)
        FROM dbamv.reg_amb rb
        LEFT JOIN dbamv.itreg_amb ib ON ib.cd_reg_amb = rb.cd_reg_amb
        LEFT JOIN dbamv.atendime a ON a.cd_atendimento = ib.cd_atendimento
        LEFT JOIN dbamv.ori_ate ot ON ot.cd_ori_ate = a.cd_ori_ate
        LEFT JOIN dbamv.remessa_fatura re ON re.cd_remessa = rb.cd_remessa
        LEFT JOIN dbamv.fatura f ON f.cd_fatura = re.cd_fatura
        LEFT JOIN dbamv.convenio c ON c.cd_convenio = a.cd_convenio
        LEFT JOIN dbamv.sub_plano s
        ON s.cd_convenio = a.cd_convenio
        AND s.cd_con_pla = ib.cd_con_pla
        AND s.cd_sub_plano = a.cd_sub_plano
        WHERE ib.cd_atendimento IS NOT NULL
        AND f.dt_competencia >= DATE '2026-01-01'
        AND f.dt_competencia < DATE '2026-08-01'
),
contas_classificadas
    AS (
        SELECT
            x.*,
            CASE
                WHEN cd_convenio = 3 THEN 'PARTICULAR'
                WHEN cd_sub_plano IN ('200', '300') THEN ds_sub_plano
                WHEN cd_convenio = 1 AND cd_ori_ate = 3 THEN 'MUNICIPIO'
                WHEN cd_convenio = 1 AND cd_ori_ate = 18 THEN 'ESTADO'
                ELSE nm_convenio
            END sub_plano
        FROM contas x
),
medidas_contas
    AS (
        SELECT
            competencia,
            SUM(CASE
                    WHEN sub_plano NOT IN ('PARTICULAR', 'MUNICIPIO', 'ESTADO', 'SUS - INTERNACAO', 'CORTESIA') THEN
                        valor
                    ELSE
                        0
                END) valor_convenio,
            SUM(CASE WHEN sub_plano = 'SUS - INTERNACAO' THEN valor ELSE 0 END) valor_sus,
            SUM(CASE WHEN sub_plano = 'PARTICULAR' THEN valor ELSE 0 END) valor_particular
        FROM contas_classificadas
        GROUP BY competencia
),
medidas_sus
    AS (
        SELECT
            competencia,
            SUM(CASE WHEN sub_plano = 'MUNICIPIO' THEN valor ELSE 0 END) vl_municipio,
            SUM(CASE WHEN sub_plano = 'ESTADO' THEN valor ELSE 0 END) vl_estado
        FROM sus
        GROUP BY competencia
),
competencias
    AS (
        SELECT competencia FROM medidas_contas
        UNION
        SELECT competencia FROM medidas_sus
)
SELECT
    TO_CHAR(c.competencia, 'MM/YYYY') competencia,
    ROUND(NVL(mc.valor_convenio, 0), 2) valor_convenio,
    ROUND(NVL(mc.valor_sus, 0), 2) valor_sus,
    ROUND(NVL(mc.valor_particular, 0), 2) valor_particular,
    ROUND(NVL(ms.vl_municipio, 0), 2) vl_municipio,
    ROUND(NVL(ms.vl_estado, 0), 2) vl_estado,
    ROUND(NVL(mc.valor_convenio, 0) + NVL(mc.valor_sus, 0)
        + NVL(mc.valor_particular, 0) + NVL(ms.vl_municipio, 0)
        + NVL(ms.vl_estado, 0), 2) faturamento_total
FROM competencias c
LEFT JOIN medidas_contas mc ON mc.competencia = c.competencia
LEFT JOIN medidas_sus ms ON ms.competencia = c.competencia
ORDER BY c.competencia
;
