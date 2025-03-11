WITH source_repasse
    AS (
        SELECT
            CD_REPASSE,
            DT_COMPETENCIA,
            DT_REPASSE,
            TP_REPASSE
        FROM dbamv.repasse
),
source_item_repasse
    AS (
        SELECT
            CD_REPASSE,
            CD_REG_AMB,
            CD_LANCAMENTO_AMB,
            CD_REG_FAT,
            CD_LANCAMENTO_FAT,
            CD_ATI_MED,
            CD_PRESTADOR_REPASSE,
            VL_REPASSE
        FROM dbamv.it_repasse
),
source_item_repasse_sih
    AS (
        SELECT
           CD_REPASSE,
            CAST('' AS NUMERIC(10,0)) AS CD_REG_AMB,
            CAST('' AS NUMERIC(10,0)) AS CD_LANCAMENTO_AMB,
            CD_REG_FAT,
            CD_LANCAMENTO AS CD_LANCAMENTO_FAT,
            CD_ATI_MED,
            CD_PRESTADOR_REPASSE,
            VL_REPASSE
        FROM dbamv.it_repasse_sih
),
treats_repasse
    AS (
        SELECT
            ir.CD_REPASSE,
            ir.CD_REG_AMB,
            ir.CD_LANCAMENTO_AMB,
            CASE
                WHEN ir.CD_REG_AMB IS NULL AND ir.CD_LANCAMENTO_AMB IS NULL THEN
                    NULL
                ELSE CAST(CONCAT(
                    CAST(COALESCE(ir.CD_REG_AMB, 0) AS NUMERIC(10,0)),
                    CAST(COALESCE(ir.CD_LANCAMENTO_AMB, 0) AS NUMERIC(10,0))
                    ) AS NUMERIC(20,0))
            END AS CD_ITREG_AMB_KEY,
            ir.CD_REG_FAT,
            ir.CD_LANCAMENTO_FAT,
            CASE
                WHEN ir.CD_REG_FAT IS NULL AND ir.CD_LANCAMENTO_FAT IS NULL THEN
                    NULL
                ELSE CAST(CONCAT(
                    CAST(COALESCE(ir.CD_REG_FAT, 0) AS NUMERIC(10,0)),
                    CAST(COALESCE(ir.CD_LANCAMENTO_FAT, 0) AS NUMERIC(10,0))
                    ) AS NUMERIC(20,0))
            END AS CD_ITREG_FAT_KEY,
            ir.CD_ATI_MED,
            ir.CD_PRESTADOR_REPASSE,
            ir.VL_REPASSE,
            r.DT_COMPETENCIA,
            r.DT_REPASSE,
            r.TP_REPASSE
        FROM source_item_repasse ir
        LEFT JOIN source_repasse r ON ir.CD_REPASSE = r.CD_REPASSE
),
treats_repasse_sih
    AS (
        SELECT
            sih.CD_REPASSE,
            sih.CD_REG_AMB,
            sih.CD_LANCAMENTO_AMB,
            CAST('' AS NUMERIC(20,0)) AS CD_ITREG_AMB_KEY,
            sih.CD_REG_FAT,
            sih.CD_LANCAMENTO_FAT,
            CASE
                WHEN sih.CD_REG_FAT IS NULL AND sih.CD_LANCAMENTO_FAT IS NULL THEN
                    NULL
                ELSE CAST(CONCAT(
                    CAST(COALESCE(sih.CD_REG_FAT, 0) AS NUMERIC(10,0)),
                    CAST(COALESCE(sih.CD_LANCAMENTO_FAT, 0) AS NUMERIC(10,0))
                    ) AS NUMERIC(20,0))
            END AS CD_ITREG_FAT_KEY,
            sih.CD_ATI_MED,
            sih.CD_PRESTADOR_REPASSE,
            sih.VL_REPASSE,
            rish.DT_COMPETENCIA,
            rish.DT_REPASSE,
            rish.TP_REPASSE
        FROM source_item_repasse_sih sih
        LEFT JOIN source_repasse rish ON sih.CD_REPASSE = rish.CD_REPASSE
),
treats_repasse_consolidado
    AS (
        SELECT
            *
        FROM treats_repasse
        UNION ALL
        SELECT
            *
        FROM treats_repasse_sih
),
source_pro_fat
    AS (
        SELECT
            CD_PRO_FAT,
            CD_GRU_PRO,
            DS_PRO_FAT
        FROM dbamv.pro_fat
),
source_item_regra_ambulatorio
    AS (
        SELECT
            CASE
            WHEN CD_REG_AMB IS NULL AND CD_LANCAMENTO IS NULL THEN
                NULL
            ELSE CAST(CONCAT(
                CAST(COALESCE(CD_REG_AMB, 0) AS NUMERIC(10,0)),
                CAST(COALESCE(CD_LANCAMENTO, 0) AS NUMERIC(10,0))
                ) AS NUMERIC(20,0))
            END AS CD_ITREG_AMB_KEY,
            CD_PRO_FAT,
            CD_REG_AMB,
            CD_PRESTADOR,
            CD_ATI_MED,
            CD_LANCAMENTO,
            CD_GRU_FAT,
            CD_CONVENIO,
            CD_ATENDIMENTO,
            DT_PRODUCAO,
            DT_FECHAMENTO,
            SN_FECHADA,
            SN_REPASSADO,
            SN_PERTENCE_PACOTE,
            VL_UNITARIO,
            VL_TOTAL_CONTA,
            VL_BASE_REPASSADO
        FROM dbamv.itreg_amb
        WHERE SN_REPASSADO <> 'X'
),
source_regra_ambulatorio
    AS (
        SELECT
            CD_REG_AMB,
            CD_REMESSA,
            DT_REMESSA
        FROM dbamv.reg_amb
),
treats_regra_ambulatorio
    AS (
        SELECT
        	ia.CD_ITREG_AMB_KEY,
            pf.CD_PRO_FAT,
            ia.CD_REG_AMB,
            ia.CD_PRESTADOR,
            ia.CD_ATI_MED,
            ia.CD_LANCAMENTO,
            pf.CD_GRU_PRO,
            ia.CD_GRU_FAT,
            ia.CD_CONVENIO,
            ia.CD_ATENDIMENTO,
            ra.CD_REMESSA,
            pf.DS_PRO_FAT,
            ra.DT_REMESSA,
            ia.DT_PRODUCAO,
            ia.DT_FECHAMENTO,
            ia.SN_FECHADA,
            ia.SN_REPASSADO,
            ia.SN_PERTENCE_PACOTE,
            ia.VL_UNITARIO,
            ia.VL_TOTAL_CONTA,
            ia.VL_BASE_REPASSADO
        FROM source_pro_fat pf
        LEFT JOIN source_item_regra_ambulatorio ia ON pf.CD_PRO_FAT = ia.CD_PRO_FAT
        LEFT JOIN source_regra_ambulatorio ra ON ia.CD_REG_AMB = ra.CD_REG_AMB
),
source_item_regra_faturamento
    AS (
        SELECT
            CASE
            WHEN CD_REG_FAT IS NULL AND CD_LANCAMENTO IS NULL THEN
                NULL
            ELSE CAST(CONCAT(
                CAST(COALESCE(CD_REG_FAT, 0) AS NUMERIC(10,0)),
                CAST(COALESCE(CD_LANCAMENTO, 0) AS NUMERIC(10,0))
                ) AS NUMERIC(20,0))
            END AS CD_ITREG_FAT_KEY,
            CD_PRO_FAT,
            CD_REG_FAT,
            CD_PRESTADOR,
            CD_ATI_MED,
            CD_LANCAMENTO,
            CD_GRU_FAT,
            DT_PRODUCAO,
            SN_REPASSADO,
            SN_PERTENCE_PACOTE,
            VL_UNITARIO,
            VL_TOTAL_CONTA,
            VL_BASE_REPASSADO
        FROM dbamv.itreg_fat
        WHERE SN_REPASSADO <> 'X'
),
source_regra_faturamento
    AS (
        SELECT
            CD_REG_FAT,
            CD_CONVENIO,
            CD_ATENDIMENTO,
            CD_REMESSA,
            DT_REMESSA
        FROM dbamv.reg_fat
),
treats_regra_faturamento
    AS (
        SELECT
            irf.CD_ITREG_FAT_KEY,
            pf.CD_PRO_FAT,
            irf.CD_REG_FAT,
            irf.CD_PRESTADOR,
            irf.CD_ATI_MED,
            irf.CD_LANCAMENTO,
            pf.CD_GRU_PRO,
            irf.CD_GRU_FAT,
            rf.CD_CONVENIO,
            rf.CD_ATENDIMENTO,
            rf.CD_REMESSA,
            pf.DS_PRO_FAT,
            rf.DT_REMESSA,
            irf.DT_PRODUCAO,
            CAST('' AS DATE) AS DT_FECHAMENTO,
            CAST('' AS VARCHAR(1)) AS SN_FECHADA,
            irf.SN_REPASSADO,
            irf.SN_PERTENCE_PACOTE,
            irf.VL_UNITARIO,
            irf.VL_TOTAL_CONTA,
            irf.VL_BASE_REPASSADO
        FROM source_pro_fat pf
        LEFT JOIN source_item_regra_faturamento irf ON pf.CD_PRO_FAT = irf.CD_PRO_FAT
        LEFT JOIN source_regra_faturamento rf ON irf.CD_REG_FAT = rf.CD_REG_FAT
),
treats_repasse_regra_amb
    AS (
        SELECT
            trc.CD_REPASSE,
            trc.CD_REG_AMB AS CD_REG_trc,
            tra.CD_REG_AMB AS CD_REGRA,
            trc.CD_LANCAMENTO_AMB AS CD_LANC_trc,
            tra.CD_LANCAMENTO,
            trc.CD_ITREG_AMB_KEY AS CD_ITREG_KEY_trc,
            tra.CD_ITREG_AMB_KEY AS CD_ITREG_KEY,
            tra.CD_PRO_FAT,
            tra.CD_GRU_PRO,
            tra.CD_GRU_FAT,
            tra.CD_ATENDIMENTO,
            tra.CD_CONVENIO,
            trc.CD_ATI_MED,
            trc.CD_PRESTADOR_REPASSE,
            trc.DT_COMPETENCIA,
            trc.DT_REPASSE,
            tra.DT_PRODUCAO,
            tra.DT_FECHAMENTO,
            trc.TP_REPASSE,
            CAST('AMBULATORIO' AS VARCHAR(12)) AS TP_REGRA,
            tra.SN_FECHADA,
            tra.SN_REPASSADO,
            tra.SN_PERTENCE_PACOTE,
            trc.VL_REPASSE,
            tra.VL_UNITARIO,
            tra.VL_TOTAL_CONTA,
            tra.VL_BASE_REPASSADO
        FROM treats_repasse_consolidado trc
        LEFT JOIN treats_regra_ambulatorio tra ON trc.CD_ITREG_AMB_KEY = tra.CD_ITREG_AMB_KEY --ON trc.CD_REG_AMB = tra.CD_REG_AMB AND trc.CD_LANCAMENTO_AMB = tra.CD_LANCAMENTO
),
treats_repasse_regra_fat
    AS (
        SELECT
            trc.CD_REPASSE,
            trc.CD_REG_FAT AS CD_REG_trc,
            trf.CD_REG_FAT AS CD_REGRA,
            trc.CD_LANCAMENTO_FAT AS CD_LANC_trc,
            trf.CD_LANCAMENTO,
            trc.CD_ITREG_FAT_KEY  AS CD_ITREG_KEY_trc,
            trf.CD_ITREG_FAT_KEY  AS CD_ITREG_KEY,
            trf.CD_PRO_FAT,
            trf.CD_GRU_PRO,
            trf.CD_GRU_FAT,
            trf.CD_ATENDIMENTO,
            trf.CD_CONVENIO,
            trc.CD_ATI_MED,
            trc.CD_PRESTADOR_REPASSE,
            trc.DT_COMPETENCIA,
            trc.DT_REPASSE,
            trf.DT_PRODUCAO,
            trf.DT_FECHAMENTO,
            trc.TP_REPASSE,
            CAST('HOSPITALAR' AS VARCHAR(12)) AS TP_REGRA,
            trf.SN_FECHADA,
            trf.SN_REPASSADO,
            trf.SN_PERTENCE_PACOTE,
            trc.VL_REPASSE,
            trf.VL_UNITARIO,
            trf.VL_TOTAL_CONTA,
            trf.VL_BASE_REPASSADO
        FROM treats_repasse_consolidado trc
        LEFT JOIN treats_regra_faturamento trf ON trc.CD_ITREG_FAT_KEY = trf.CD_ITREG_FAT_KEY --ON trc.CD_REG_FAT = trf.CD_REG_FAT AND trc.CD_LANCAMENTO_FAT = trf.CD_LANCAMENTO
),
treats
    AS (
        SELECT
            *
        FROM treats_repasse_regra_amb
        UNION ALL
        SELECT
            *
        FROM treats_repasse_regra_fat
)
SELECT
    *
FROM treats WHERE CD_PRESTADOR_REPASSE = 366 AND TRUNC(DT_COMPETENCIA) = TO_DATE('2024-12-01', 'YYYY-MM-DD') AND CD_CONVENIO = 46 AND CD_ATI_MED = '01'
ORDER BY CD_ATENDIMENTO ;