WITH source_produto
    AS (
        SELECT
            p."CD_PRODUTO",
            p."DS_PRODUTO"
        FROM staging.stg_produto p
),
source_snp_sol_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            isol."CD_PRODUTO",
            p."DS_PRODUTO",
            sc."CD_SETOR",
            sc."CD_ESTOQUE",
            sc."CD_MOT_PED",
            sc."CD_MOT_CANCEL" AS "CD_MOT_CANCEL_SC",
            sc."DT_SOL_COM",
            sc."DT_CANCELAMENTO",
            CASE
                WHEN sc."TP_SITUACAO" = 'A' THEN 'Aberta'
                WHEN sc."TP_SITUACAO" = 'F' THEN 'Fechada'
                WHEN sc."TP_SITUACAO" = 'P' THEN 'Parcialmente Atendida'
                WHEN sc."TP_SITUACAO" = 'S' THEN 'Solicitada'
                WHEN sc."TP_SITUACAO" = 'C' THEN 'Cancelada'
                WHEN sc."TP_SITUACAO" = 'N' THEN 'Lancamento'
            END AS "TP_SITUACAO_SC",
            sc."SN_APROVADA",
            sc."SN_URGENTE",
            sc."SN_OPME"
        FROM snapshots.snp_sol_com sc
        LEFT JOIN staging.stg_itsol_com isol ON sc."CD_SOL_COM" = isol."CD_SOL_COM"
        LEFT JOIN source_produto p ON isol."CD_PRODUTO" = p."CD_PRODUTO"
        WHERE sc.dbt_valid_to IS NULL
),
source_snp_ord_com
    AS (
        SELECT
            oc."CD_ORD_COM",
            oc."CD_SOL_COM",
            io."CD_PRODUTO",
            p."DS_PRODUTO",
            oc."CD_MOT_CANCEL" AS "CD_MOT_CANCEL_OC",
            oc."DT_ORD_COM",
            oc."DT_PREV_ENTREGA",
            oc."DT_AUTORIZACAO",
            CASE
                WHEN oc."TP_SITUACAO" = 'A' THEN 'Aberta'
                WHEN oc."TP_SITUACAO" = 'U' THEN 'Autorizada'
                WHEN oc."TP_SITUACAO" = 'N' THEN 'Não Autorizada'
                WHEN oc."TP_SITUACAO" = 'P' THEN 'Pendente'
                WHEN oc."TP_SITUACAO" = 'L' THEN 'Parcialmente Atendida'
                WHEN oc."TP_SITUACAO" = 'T' THEN 'Atendida'
                WHEN oc."TP_SITUACAO" = 'C' THEN 'Cancelada'
                WHEN oc."TP_SITUACAO" = 'D' THEN 'Adjudicação'
                WHEN oc."TP_SITUACAO" = 'O' THEN 'Aguard. Próximo Nível'
            END AS "TP_SITUACAO_OC",
            oc."SN_AUTORIZADO" AS "SN_AUTORIZADO_OC"
        FROM snapshots.snp_ord_com oc
        LEFT JOIN staging.stg_itord_pro io ON oc."CD_ORD_COM" = io."CD_ORD_COM"
        LEFT JOIN source_produto p ON io."CD_PRODUTO" = p."CD_PRODUTO"
        WHERE oc.dbt_valid_to IS NULL
),
treats_match_cod_sol_ord_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            oc."CD_ORD_COM",
            sc."CD_PRODUTO",
            sc."DS_PRODUTO",
            sc."CD_SETOR",
            sc."CD_ESTOQUE",
            sc."CD_MOT_PED",
            sc."CD_MOT_CANCEL_SC",
            oc."CD_MOT_CANCEL_OC",
            oc."DT_ORD_COM",
            sc."DT_SOL_COM",
            sc."DT_CANCELAMENTO",
            oc."DT_AUTORIZACAO",
            sc."SN_APROVADA",
            sc."SN_URGENTE",
            oc."SN_AUTORIZADO_OC",
            sc."SN_OPME",
            sc."TP_SITUACAO_SC",
            oc."TP_SITUACAO_OC",
            0 AS "MATCHING"
        FROM source_snp_sol_com sc
        LEFT JOIN source_snp_ord_com oc
            ON sc."CD_SOL_COM" = oc."CD_SOL_COM"
           AND sc."CD_PRODUTO" = oc."CD_PRODUTO"
),
dt_solicitacao
    AS (
        SELECT DISTINCT
            "CD_SOL_COM",
            "DT_SOL_COM"
        FROM source_snp_sol_com
),
treats_match_cod_ord_sol_com
    AS (
        SELECT
            oc."CD_SOL_COM",
            oc."CD_ORD_COM",
            oc."CD_PRODUTO",
            oc."DS_PRODUTO",
            NULL::BIGINT AS "CD_SETOR",
            NULL::BIGINT AS "CD_ESTOQUE",
            NULL::BIGINT AS "CD_MOT_PED",
            NULL::BIGINT AS "CD_MOT_CANCEL_SC",
            oc."CD_MOT_CANCEL_OC",
            oc."DT_ORD_COM",
            ds."DT_SOL_COM",
            sc."DT_CANCELAMENTO",
            oc."DT_AUTORIZACAO",
            NULL::VARCHAR(1) AS "SN_APROVADA",
            NULL::VARCHAR(1) AS "SN_URGENTE",
            oc."SN_AUTORIZADO_OC",
            NULL::VARCHAR(1) AS "SN_OPME",
            NULL::VARCHAR(1) AS "TP_SITUACAO_SC",
            oc."TP_SITUACAO_OC"
        FROM source_snp_ord_com oc
        LEFT JOIN source_snp_sol_com sc
            ON oc."CD_SOL_COM" = sc."CD_SOL_COM"
           AND oc."CD_PRODUTO" = sc."CD_PRODUTO"
        LEFT JOIN dt_solicitacao ds
            ON oc."CD_SOL_COM" = ds."CD_SOL_COM"
        WHERE NOT EXISTS (
            SELECT 1
            FROM treats_match_cod_sol_ord_com smc
            WHERE smc."CD_SOL_COM" = oc."CD_SOL_COM"
            AND   smc."CD_PRODUTO" = oc."CD_PRODUTO"
        )
),
treats_desc_sol_ord_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            oc."CD_ORD_COM",
            oc."CD_PRODUTO",
            oc."DS_PRODUTO",
            sc."CD_SETOR",
            sc."CD_ESTOQUE",
            oc."CD_MOT_PED",
            sc."CD_MOT_CANCEL_SC",
            oc."CD_MOT_CANCEL_OC",
            oc."DT_ORD_COM",
            sc."DT_SOL_COM",
            sc."DT_CANCELAMENTO",
            sc."DT_AUTORIZACAO",
            sc."SN_APROVADA",
            sc."SN_URGENTE",
            sc."SN_AUTORIZADO_OC",
            sc."SN_OPME",
            sc."TP_SITUACAO_SC",
            sc."TP_SITUACAO_OC",
           1 AS "MATCHING"
        FROM treats_match_cod_sol_ord_com sc
        INNER JOIN treats_match_cod_ord_sol_com oc
            ON sc."CD_SOL_COM" = oc."CD_SOL_COM"
           AND sc."DS_PRODUTO" = oc."DS_PRODUTO"
),
treats_itens_sol_original
    AS (
        SELECT
            tmc."CD_SOL_COM",
            tmc."CD_ORD_COM",
            tmc."CD_PRODUTO",
            tmc."DS_PRODUTO",
            tmc."CD_SETOR",
            tmc."CD_ESTOQUE",
            tmc."CD_MOT_PED",
            tmc."CD_MOT_CANCEL_SC",
            tmc."CD_MOT_CANCEL_OC",
            tmc."DT_ORD_COM",
            tmc."DT_SOL_COM",
            tmc."DT_CANCELAMENTO",
            tmc."DT_AUTORIZACAO",
            tmc."SN_APROVADA",
            tmc."SN_URGENTE",
            tmc."SN_AUTORIZADO_OC",
            tmc."SN_OPME",
            tmc."TP_SITUACAO_SC",
            tmc."TP_SITUACAO_OC",
            0 AS "MATCHING"
        FROM treats_match_cod_sol_ord_com tmc
        WHERE NOT EXISTS (
                SELECT
                    1
                FROM treats_desc_sol_ord_com tds
                WHERE tds."CD_SOL_COM" = tmc."CD_SOL_COM"
                AND   TRIM(UPPER(tds."DS_PRODUTO")) = TRIM(UPPER(tmc."DS_PRODUTO"))
            )
),
treats_itens_ord_totalmente_arbitrario
    AS (
        SELECT
            smc."CD_SOL_COM",
            smc."CD_ORD_COM",
            smc."CD_PRODUTO",
            smc."DS_PRODUTO",
            smc."CD_SETOR",
            smc."CD_ESTOQUE",
            smc."CD_MOT_PED",
            smc."CD_MOT_CANCEL_SC",
            smc."CD_MOT_CANCEL_OC",
            smc."DT_ORD_COM",
            smc."DT_SOL_COM",
            smc."DT_CANCELAMENTO",
            smc."DT_AUTORIZACAO",
            smc."SN_APROVADA",
            smc."SN_URGENTE",
            smc."SN_AUTORIZADO_OC",
            smc."SN_OPME",
            smc."TP_SITUACAO_SC",
            smc."TP_SITUACAO_OC",
            2 AS "MATCHING"
        FROM treats_match_cod_ord_sol_com smc
        WHERE NOT EXISTS (
                SELECT 1
                FROM treats_desc_sol_ord_com tds
                WHERE smc."CD_SOL_COM" = tds."CD_SOL_COM"
                AND TRIM(UPPER(smc."DS_PRODUTO")) = TRIM(UPPER(tds."DS_PRODUTO"))
            )
),
treats_sol_ord_com
    AS (
        SELECT
            a."CD_SOL_COM",
            a."CD_ORD_COM",
            a."CD_PRODUTO",
            a."DS_PRODUTO",
            a."CD_SETOR",
            a."CD_ESTOQUE",
            a."CD_MOT_PED",
            a."CD_MOT_CANCEL_SC",
            a."CD_MOT_CANCEL_OC",
            a."DT_ORD_COM",
            a."DT_SOL_COM",
            a."DT_CANCELAMENTO",
            a."DT_AUTORIZACAO",
            a."SN_APROVADA",
            a."SN_URGENTE",
            a."SN_AUTORIZADO_OC",
            a."SN_OPME",
            a."TP_SITUACAO_SC",
            a."TP_SITUACAO_OC",
            a."MATCHING"
        FROM treats_itens_sol_original a
        UNION ALL
        SELECT
            b."CD_SOL_COM",
            b."CD_ORD_COM",
            b."CD_PRODUTO",
            b."DS_PRODUTO",
            b."CD_SETOR",
            b."CD_ESTOQUE",
            b."CD_MOT_PED",
            b."CD_MOT_CANCEL_SC",
            b."CD_MOT_CANCEL_OC",
            b."DT_ORD_COM",
            b."DT_SOL_COM",
            b."DT_CANCELAMENTO",
            b."DT_AUTORIZACAO",
            b."SN_APROVADA",
            b."SN_URGENTE",
            b."SN_AUTORIZADO_OC",
            b."SN_OPME",
            b."TP_SITUACAO_SC",
            b."TP_SITUACAO_OC",
            b."MATCHING"
        FROM treats_desc_sol_ord_com b
        UNION ALL
        SELECT
            c."CD_SOL_COM",
            c."CD_ORD_COM",
            c."CD_PRODUTO",
            c."DS_PRODUTO",
            c."CD_SETOR",
            c."CD_ESTOQUE",
            c."CD_MOT_PED",
            c."CD_MOT_CANCEL_SC",
            c."CD_MOT_CANCEL_OC",
            c."DT_ORD_COM",
            c."DT_SOL_COM",
            c."DT_CANCELAMENTO",
            c."DT_AUTORIZACAO",
            c."SN_APROVADA",
            c."SN_URGENTE",
            c."SN_AUTORIZADO_OC",
            c."SN_OPME",
            c."TP_SITUACAO_SC",
            c."TP_SITUACAO_OC",
            c."MATCHING"
        FROM treats_itens_ord_totalmente_arbitrario c
),
source_itens_solicitacao
    AS (
        SELECT
            ic."CD_ITSOL_COM_KEY",
            ic."CD_SOL_COM",
            ic."CD_PRODUTO",
            ic."CD_UNI_PRO",
            ic."CD_MOT_CANCEL",
            ic."DT_CANCEL",
            ic."QT_SOLIC",
            ic."QT_COMPRADA",
            ic."QT_ATENDIDA"
        FROM staging.stg_itsol_com ic
),
source_itens_pedidos
    AS (
        SELECT
            io."CD_ITORD_PRO_KEY",
            io."CD_ORD_COM",
            io."CD_PRODUTO",
            io."CD_UNI_PRO",
            io."CD_MOT_CANCEL",
            io."DT_CANCEL",
            io."QT_COMPRADA",
            io."QT_ATENDIDA",
            io."QT_RECEBIDA",
            io."QT_CANCELADA",
            io."VL_UNITARIO",
            io."VL_TOTAL"
        FROM staging.stg_itord_pro io
),
source_itens_entradas
    AS (
        SELECT
            ip."CD_ITENT_PRO",
            ip."CD_ENT_PRO",
            ep."CD_ORD_COM",
            ep."CD_FORNECEDOR",
            ep."DT_ENTRADA",
            ep."NR_DOCUMENTO",
            ip."CD_PRODUTO",
            ip."DT_GRAVACAO",
            ip."QT_ENTRADA",
            ip."QT_ATENDIDA",
            ip."VL_UNITARIO",
            ip."VL_CUSTO_REAL",
            ip."VL_TOTAL_CUSTO_REAL",
            ip."VL_TOTAL"
        FROM staging.stg_itent_pro ip
        LEFT JOIN staging.stg_ent_pro ep ON ip."CD_ENT_PRO" = ep."CD_ENT_PRO"
),
treats_estoque
    AS (
        SELECT
            p."CD_PRODUTO",
            ep."CD_ESTOQUE",
            ROUND(COALESCE(( ep."QT_ESTOQUE_ATUAL" / up."VL_FATOR" ), 0), 1) AS "QT_ESTOQUE_ATUAL",
            ROUND(COALESCE(( ep."QT_CONSUMO_ATUAL" / up."VL_FATOR" ), 0), 1) AS "QT_CONSUMO_ATUAL",
            ep."DT_ULTIMA_MOVIMENTACAO",
            ep."TP_CLASSIFICACAO_ABC",
            up."VL_FATOR"
        FROM  staging.stg_produto p
        LEFT JOIN staging.stg_est_pro ep
            ON p."CD_PRODUTO" = ep."CD_PRODUTO"
        LEFT JOIN staging.stg_uni_pro up
            ON p."CD_PRODUTO" = up."CD_PRODUTO"
        WHERE up."TP_RELATORIOS" = 'G'
),
treats_qt_mov
    AS (
        SELECT
            itmve."CD_PRODUTO",
            -- mve."CD_ESTOQUE",
            up."VL_FATOR",
            up."TP_RELATORIOS",
            -- mve."TP_MVTO_ESTOQUE",
            COALESCE(
                SUM(
                    itmve."QT_MOVIMENTACAO" * up."VL_FATOR" * CASE
                        WHEN mve."TP_MVTO_ESTOQUE" IN ('D', 'C') THEN -1
                        ELSE 1
                    END
                ) / up."VL_FATOR",
                0
            ) AS "QT_MOVIMENTO"
        FROM staging.stg_itmvto_estoque itmve
        LEFT JOIN staging.stg_mvto_estoque mve ON itmve."CD_MVTO_ESTOQUE" = mve."CD_MVTO_ESTOQUE"
        LEFT JOIN staging.stg_uni_pro up ON itmve."CD_UNI_PRO" = up."CD_UNI_PRO"
        -- JOIN staging.stg_produto p ON itmve."CD_PRODUTO" = p."CD_PRODUTO"
        WHERE up."TP_RELATORIOS" = 'G' AND itmve."CD_PRODUTO" = 14328
            AND mve."TP_MVTO_ESTOQUE" IN ('S', 'P', 'D', 'C')
        GROUP BY
            itmve."CD_PRODUTO",
            -- mve."CD_ESTOQUE",
            up."VL_FATOR",
            up."TP_RELATORIOS"
            -- mve."TP_MVTO_ESTOQUE"
),
dt_previso
    AS (
        SELECT DISTINCT
            "CD_ORD_COM",
            "DT_PREV_ENTREGA"
        FROM source_snp_ord_com
),
source_suprimentos
    AS (
        SELECT
            CONCAT(
                COALESCE(isol."CD_ITSOL_COM_KEY", '0'),
                COALESCE(io."CD_ITORD_PRO_KEY", '0'),
                COALESCE(ie."CD_ITENT_PRO", '0')
            )::NUMERIC AS "CD_SUPRIMENTO_KEY",
            h."CD_SOL_COM",
            h."CD_SETOR",
            h."CD_ESTOQUE",
            h."CD_MOT_PED",
            isol."CD_MOT_CANCEL" AS "CD_MOT_CANCEL_SC",
            h."DT_SOL_COM",
            CASE
                WHEN isol."CD_MOT_CANCEL" IS NOT NULL THEN 'Cancelada'
                WHEN (io."QT_COMPRADA" - io."QT_RECEBIDA") = 0 THEN 'Atendida'
                WHEN (io."QT_COMPRADA" - io."QT_RECEBIDA") = io."QT_CANCELADA" THEN 'Cancelada'
                ELSE h."TP_SITUACAO_SC"
            END AS "TP_SITUACAO_SC",
            h."SN_APROVADA",
            h."SN_URGENTE",
            h."SN_OPME",
            h."CD_ORD_COM",
            h."DT_ORD_COM",
            dp."DT_PREV_ENTREGA",
            h."DT_AUTORIZACAO",
            io."CD_MOT_CANCEL" AS "CD_MOT_CANCEL_OC",
            CASE
                WHEN io."CD_MOT_CANCEL" IS NOT NULL THEN 'Cancelada'
                WHEN (io."QT_COMPRADA" - io."QT_RECEBIDA") = 0 THEN 'Atendida'
                WHEN (io."QT_COMPRADA" - io."QT_RECEBIDA") = io."QT_CANCELADA" THEN 'Cancelada'
                ELSE h."TP_SITUACAO_OC"
            END AS "TP_SITUACAO_OC",
            h."SN_AUTORIZADO_OC",
            ie."CD_FORNECEDOR",
            ie."NR_DOCUMENTO",
            ie."DT_ENTRADA",
            io."CD_UNI_PRO",
            h."CD_PRODUTO",
            isol."DT_CANCEL" AS "DT_CANCEL_SOL",
            COALESCE(isol."QT_SOLIC", 0) AS "QT_SOLIC_SOL",
            COALESCE(isol."QT_COMPRADA", 0) AS "QT_COMPRADA_SOL",
            COALESCE(isol."QT_ATENDIDA", 0) AS "QT_ATENDIDA_SOL",
            io."DT_CANCEL" AS "DT_CANCEL_ORD",
            COALESCE(io."QT_COMPRADA", 0) AS "QT_COMPRADA_ORD",
            COALESCE(io."QT_ATENDIDA", 0) AS "QT_ATENDIDA_ORD",
            COALESCE(io."QT_RECEBIDA", 0) AS "QT_RECEBIDA_ORD",
            COALESCE(io."QT_CANCELADA", 0) AS "QT_CANCELADA_ORD",
            COALESCE(io."VL_UNITARIO", 0) AS "VL_UNITARIO_ORD",
            ((COALESCE(io."QT_COMPRADA", 0) - COALESCE(ie."QT_ENTRADA", 0)) - COALESCE(io."QT_CANCELADA", 0)) AS "SALDO",
            COALESCE(ie."QT_ENTRADA", 0) AS "QT_ENTRADA_ENT",
            COALESCE(ie."QT_ATENDIDA", 0) AS "QT_ATENDIDA_ENT",
            COALESCE(ie."VL_UNITARIO", 0) AS "QT_UNITARIO_ENT",
            COALESCE(e."QT_ESTOQUE_ATUAL", 0) AS "QT_ESTOQUE_ATUAL",
            COALESCE(e."QT_CONSUMO_ATUAL", 0) AS "QT_CONSUMO_ATUAL",
            e."DT_ULTIMA_MOVIMENTACAO",
            COALESCE(tm."QT_MOVIMENTO", 0) AS "QT_MOVIMENTO",
            h."MATCHING"
        FROM treats_sol_ord_com h
        LEFT JOIN source_itens_solicitacao isol ON h."CD_SOL_COM" = isol."CD_SOL_COM" AND h."CD_PRODUTO" = isol."CD_PRODUTO"
        LEFT JOIN source_itens_pedidos io ON h."CD_ORD_COM" = io."CD_ORD_COM" AND h."CD_PRODUTO" = io."CD_PRODUTO"
        LEFT JOIN source_itens_entradas ie ON h."CD_ORD_COM" = ie."CD_ORD_COM" AND h."CD_PRODUTO" = ie."CD_PRODUTO"
        LEFT JOIN treats_qt_mov tm ON h."CD_PRODUTO" = tm."CD_PRODUTO"
        LEFT JOIN dt_previso dp ON h."CD_ORD_COM" = dp."CD_ORD_COM"
        LEFT JOIN treats_estoque e ON h."CD_PRODUTO" = e."CD_PRODUTO" AND h."CD_ESTOQUE" = e."CD_ESTOQUE"
        ORDER BY h."CD_PRODUTO"
),
treats
    AS (
        SELECT
            h."CD_SUPRIMENTO_KEY",
            h."CD_SOL_COM",
            h."CD_SETOR",
            h."CD_ESTOQUE",
            h."CD_MOT_PED",
            h."CD_MOT_CANCEL_SC",
            h."DT_SOL_COM",
            h."TP_SITUACAO_SC",
            h."SN_APROVADA",
            h."SN_URGENTE",
            h."SN_OPME",
            h."CD_ORD_COM",
            h."DT_ORD_COM",
            h."DT_PREV_ENTREGA",
            h."DT_AUTORIZACAO",
            h."CD_MOT_CANCEL_OC",
            h."TP_SITUACAO_OC",
            h."SN_AUTORIZADO_OC",
            h."CD_FORNECEDOR",
            h."NR_DOCUMENTO",
            h."DT_ENTRADA",
            h."CD_UNI_PRO",
            h."CD_PRODUTO",
            h."DT_CANCEL_SOL",
            h."QT_SOLIC_SOL",
            h."QT_COMPRADA_SOL",
            h."QT_ATENDIDA_SOL",
            h."DT_CANCEL_ORD",
            h."QT_COMPRADA_ORD",
            h."QT_ATENDIDA_ORD",
            h."QT_RECEBIDA_ORD",
            h."QT_CANCELADA_ORD",
            h."VL_UNITARIO_ORD",
            h."SALDO",
            h."QT_ENTRADA_ENT",
            h."QT_ATENDIDA_ENT",
            h."QT_UNITARIO_ENT",
            h."QT_ESTOQUE_ATUAL",
            h."QT_CONSUMO_ATUAL",
            h."DT_ULTIMA_MOVIMENTACAO",
            h."MATCHING",
            SUM(h."QT_MOVIMENTO") AS "QT_MOVIMENTO"
        FROM source_suprimentos h
        GROUP BY
            h."CD_SUPRIMENTO_KEY",
            h."CD_SOL_COM",
            h."CD_SETOR",
            h."CD_ESTOQUE",
            h."CD_MOT_PED",
            h."CD_MOT_CANCEL_SC",
            h."DT_SOL_COM",
            h."TP_SITUACAO_SC",
            h."SN_APROVADA",
            h."SN_URGENTE",
            h."SN_OPME",
            h."CD_ORD_COM",
            h."DT_ORD_COM",
            h."DT_PREV_ENTREGA",
            h."DT_AUTORIZACAO",
            h."CD_MOT_CANCEL_OC",
            h."TP_SITUACAO_OC",
            h."SN_AUTORIZADO_OC",
            h."CD_FORNECEDOR",
            h."NR_DOCUMENTO",
            h."DT_ENTRADA",
            h."CD_UNI_PRO",
            h."CD_PRODUTO",
            h."DT_CANCEL_SOL",
            h."QT_SOLIC_SOL",
            h."QT_COMPRADA_SOL",
            h."QT_ATENDIDA_SOL",
            h."DT_CANCEL_ORD",
            h."QT_COMPRADA_ORD",
            h."QT_ATENDIDA_ORD",
            h."QT_RECEBIDA_ORD",
            h."QT_CANCELADA_ORD",
            h."VL_UNITARIO_ORD",
            h."SALDO",
            h."QT_ENTRADA_ENT",
            h."QT_ATENDIDA_ENT",
            h."QT_UNITARIO_ENT",
            h."QT_ESTOQUE_ATUAL",
            h."QT_CONSUMO_ATUAL",
            h."DT_ULTIMA_MOVIMENTACAO",
            h."MATCHING"
)
SELECT
    *
FROM source_suprimentos
-- WHERE "MATCHING" = 2
WHERE "CD_SOL_COM" = 4176
-- WHERE O."CD_SOL_COM" = 4042
;



/*
  * Alterar Escopo Semantico p/ que Solicitacao tenha prioridade
  * Unir SC e OC c/ match entre 'CD_SOLICITACAO' e 'CD_PRODUTO'
  * Unir SC e OC c/ match entre 'CD_SOLICITACAO' e 'DS_PRODUTO'
  * Identificar OC c/ itens arbitrarios a SC
  * Identificar SC|OC s/ itens (SERVICOS)
*/



-- Versão itens da OC que nao compoe a SC orginal
WITH source_snp_sol_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            ic."CD_PRODUTO"
        FROM snapshots.snp_sol_com sc
        LEFT JOIN staging.stg_itsol_com ic ON sc."CD_SOL_COM" = ic."CD_SOL_COM"
        WHERE sc.dbt_valid_to IS NULL
),
source_snp_ord_com
    AS (
        SELECT
            oc."CD_ORD_COM",
            oc."CD_SOL_COM",
            oc."DT_ORD_COM",
            io."CD_PRODUTO"
        FROM snapshots.snp_ord_com oc
        LEFT JOIN staging.stg_itord_pro io ON oc."CD_ORD_COM" = io."CD_ORD_COM"
        WHERE oc.dbt_valid_to IS NULL
),
source_produto
    AS (
        SELECT
            "CD_PRODUTO"
            , "CD_ESPECIE"
            , "DS_PRODUTO"
            , "DS_PRODUTO_RESUMIDO"
            , "DT_CADASTRO"
        FROM staging.stg_produto
),
ordens_com_produtos_nao_solicitados
    AS (
        SELECT
            soc."CD_ORD_COM",
            soc."CD_SOL_COM",
            soc."CD_PRODUTO",
            soc."DT_ORD_COM"
        FROM source_snp_ord_com soc
        WHERE soc."CD_PRODUTO" IS NOT NULL -- Verificar produtos null's entre 'snp_ord_com' e 'stg_itord_pro'
        AND NOT EXISTS (                       -- RESULTADOO: SC/OC sem item - SERVICOS
            SELECT 1
            FROM source_snp_sol_com ssc
            WHERE ssc."CD_SOL_COM" = soc."CD_SOL_COM"
            AND ssc."CD_PRODUTO" = soc."CD_PRODUTO"
        )
)
SELECT -- DISTINCT
    o.*
FROM ordens_com_produtos_nao_solicitados o
-- WHERE O."CD_SOL_COM" = 4122
-- WHERE O."CD_SOL_COM" = 3029
WHERE o."CD_SOL_COM" = 4176
;




-- Query Tascom do Pianel CEOSgo SUPRIMENTOS
SELECT CD_ESPECIE,
       DS_ESPECIE,
       CD_PRODUTO,
       DS_PRODUTO,
       DS_UNIDADE,
       QT_ESTOQUE_ATUAL,
       QT_ORDEM_DE_COMPRA,
       QT_SOLICITACAO_COMPRA,
       QT_MVTO_90,
       QT_MENSAL,
       QT_DIARIO,
       QTD_DIAS_ESTOQUE

FROM (
        SELECT
            PRINCIPAL.CD_ESPECIE,
            PRINCIPAL.DS_ESPECIE,
            PRINCIPAL.CD_PRODUTO,
            PRINCIPAL.DS_PRODUTO,
            PRINCIPAL.DS_UNIDADE,
            NVL(PRINCIPAL.QT_ESTOQUE_ATUAL, 0) QT_ESTOQUE_ATUAL,

            (
                SELECT
                    Sum(
                        ( ( Nvl( itord_pro.qt_comprada, 0 ) - Nvl( itord_pro.qt_recebida, 0 ) ) * uni_pro.vl_fator ) /
                        verif_vl_fator_prod(principal.cd_produto, 'G')
                    ) qt_saldo_pendente
                FROM dbamv.ord_com,
                     dbamv.itord_pro,
                     dbamv.uni_pro
                WHERE ord_com.cd_ord_com = itord_pro.cd_ord_com
                      AND ord_com.tp_situacao IN ( 'A','L','S','U','P')
                      AND itord_pro.cd_mot_cancel is NULL
                      AND itord_pro.cd_produto = PRINCIPAL.cd_produto
                      AND itord_pro.cd_uni_pro = uni_pro.cd_uni_pro
                      AND ord_com.dt_ord_com >= SYSDATE - 360
            ) QT_ORDEM_DE_COMPRA,

            (
                SELECT Sum(
                           ( ( Nvl( itsol_com.qt_solic, 0 ) - Nvl( itsol_com.qt_atendida, 0 ) ) * uni_pro.vl_fator ) /
                           verif_vl_fator_prod(principal.cd_produto, 'G')
                        ) qt_saldo_pendsol
                FROM dbamv.sol_com,
                     dbamv.itsol_com,
                     dbamv.uni_pro
                WHERE sol_com.cd_sol_com = itsol_com.cd_sol_com
                      AND sol_com.tp_situacao IN ( 'A', 'L', 'S', 'U' )
                      AND itsol_com.cd_produto = PRINCIPAL.cd_produto
                      AND itsol_com.cd_uni_pro = uni_pro.cd_uni_pro
                      AND sol_com.dt_sol_com >= SYSDATE - 360
            ) QT_SOLICITACAO_COMPRA,

            TO_CHAR(ROUND(NVL(QT_MVTO,      0), 0), '999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''') AS QT_MVTO_90, -- Sem casas decimais
            TO_CHAR(ROUND(NVL(QT_MVTO /  3, 0), 0), '999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''') AS QT_MENSAL, -- Sem casas decimais
            TO_CHAR(ROUND(NVL(QT_MVTO / 90, 0), 0), '999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''') AS QT_DIARIO, -- Sem casas decimais

            CASE
                WHEN PRINCIPAL.QT_MVTO <= 0 THEN
                    99
                ELSE
                    ROUND(QT_ESTOQUE_ATUAL / (QT_MVTO / 90), 0)
            END AS QTD_DIAS_ESTOQUE

        FROM (
                SELECT
                    especie.cd_especie,
                    especie.ds_especie,
                    produto.cd_produto,
                    produto.ds_produto,
                    verif_vl_fator_prod(produto.cd_produto, 'G') fator,

                    verif_ds_unid_prod(produto.cd_produto, 'G') ds_unidade,

                    SUM(
                        est_pro.qt_ordem_de_compra /
                        verif_vl_fator_prod(produto.cd_produto, 'G')
                    ) AS qt_ordem_de_compra,

                    SUM(
                        est_pro.qt_solicitacao_de_compra /
                        verif_vl_fator_prod(produto.cd_produto, 'G')
                    ) AS qt_solicitacao_compra,

                    SUM(
                        est_pro.qt_estoque_atual /
                        verif_vl_fator_prod(produto.cd_produto, 'G')
                    ) AS qt_estoque_atual,

                    ((
                        SELECT
                            SUM(
                                itmvto_estoque.qt_movimentacao * uni_pro.vl_fator *
                                DECODE(mvto_estoque.tp_mvto_estoque, 'D', -1, 'C', -1, 1)
                            )
                        FROM dbamv.mvto_estoque,
                             dbamv.itmvto_estoque,
                             dbamv.uni_pro
                        WHERE mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
                              AND itmvto_estoque.cd_produto = produto.cd_produto
                              AND itmvto_estoque.cd_uni_pro = uni_pro.cd_uni_pro
                              AND mvto_estoque.tp_mvto_estoque IN ('S', 'P', 'D', 'C')
                            --   AND MVTO_ESTOQUE.DT_MVTO_ESTOQUE
                            --   BETWEEN TRUNC(TO_DATE($pgmvDataRange90$) - 90) AND TRUNC(TO_DATE($pgmvDataRange90$)) + 0.99999
                    ) /
                    verif_vl_fator_prod(produto.cd_produto, 'G')) QT_MVTO
                FROM dbamv.produto,
                     dbamv.est_pro,
                     dbamv.especie
                WHERE produto.cd_produto = est_pro.cd_produto
                      AND especie.cd_especie = produto.cd_especie AND produto.CD_PRODUTO = 14328
                    --   AND est_pro.cd_estoque = $hpcestoque$
                    --   AND especie.cd_especie = $hpcespecie$
                      AND produto.sn_movimentacao = 'S'
                GROUP BY especie.cd_especie,
                         especie.ds_especie,
                         produto.cd_produto,
                         produto.ds_produto,
                         verif_vl_fator_prod(produto.cd_produto, 'G')
            ) PRINCIPAL
            ORDER BY QTD_DIAS_ESTOQUE ASC
)
;





WITH dados_base
    AS (
        SELECT
            ep.CD_ESTOQUE,
            ep.CD_PRODUTO,
            ep.CD_LOCALIZACAO,
            ep.DT_ULTIMA_MOVIMENTACAO,
            ep.QT_ESTOQUE_ATUAL / verif_vl_fator_prod(ep.CD_PRODUTO, 'G') AS QT_ESTOQUE_ATUAL,
            ep.QT_CONSUMO_ATUAL / verif_vl_fator_prod(ep.CD_PRODUTO, 'G') AS QT_CONSUMO_ATUAL,
            ep.TP_CLASSIFICACAO_ABC,
            (
                SELECT
                    SUM(
                        itmvto_estoque.qt_movimentacao * uni_pro.vl_fator *
                        DECODE(mvto_estoque.tp_mvto_estoque, 'D', -1, 'C', -1, 1)
                    )
                FROM dbamv.mvto_estoque,
                    dbamv.itmvto_estoque,
                    dbamv.uni_pro
                WHERE mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
                    AND itmvto_estoque.cd_produto = ep.cd_produto
                    AND itmvto_estoque.cd_uni_pro = uni_pro.cd_uni_pro
                    AND mvto_estoque.tp_mvto_estoque IN ('S', 'P', 'D', 'C')
                    AND mvto_estoque.dt_mvto_estoque
                        BETWEEN TRUNC(SYSDATE) - 90 AND TRUNC(SYSDATE) + 0.99999
            ) / verif_vl_fator_prod(ep.CD_PRODUTO, 'G') AS QT_MVTO
        FROM DBAMV.EST_PRO ep
)
SELECT
    CD_ESTOQUE,
    CD_PRODUTO,
    CD_LOCALIZACAO,
    DT_ULTIMA_MOVIMENTACAO,
    QT_ESTOQUE_ATUAL,
    QT_CONSUMO_ATUAL,
    TP_CLASSIFICACAO_ABC,
    ROUND(NVL(QT_MVTO, 0), 0) AS QT_MVTO,
    ROUND(NVL(QT_MVTO / 3, 0), 0) AS QT_MENSAL,
    ROUND(NVL(QT_MVTO / 90, 0), 0) AS QT_DIARIO,
    CASE
        WHEN QT_MVTO <= 0 THEN 99
        ELSE ROUND(QT_ESTOQUE_ATUAL / (QT_MVTO / 90), 0)
    END AS QTD_DIAS_ESTOQUE
FROM dados_base
;





/*
    | Código | Significado Funcional             | Tipo de Movimento        | Observações                                                                   |
    | ------ | --------------------------------- | ------------------------ | ----------------------------------------------------------------------------- |
    | **D**  | **Devolução**                     | Saída negativa / Entrada | Retorno de materiais ao estoque, geralmente após devolução de setor/paciente. |
    | **C**  | **Devolução Paciente**            | Entrada                  | Retorno de itens dispensados ao paciente e não utilizados.                    |
    | **T**  | **Transferência**                 | Neutro                   | Transferência entre estoques físicos (ex: almoxarifado → farmácia).           |
    | **M**  | **Manipulação / Produção**        | Entrada                  | Entrada de produtos manipulados ou kits montados.                             |
    | **O**  | **Ordem de Serviço / Cirurgia**   | Saída                    | Movimento de saída por procedimentos cirúrgicos ou OS.                        |
    | **E**  | **Entrada**                       | Entrada                  | Entrada via compra, nota fiscal ou movimentação externa.                      |
    | **V**  | **Venda / Dispensação**           | Saída                    | Dispensação ou venda de materiais/medicamentos (ex: farmácia).                |
    | **X**  | **Baixa**                         | Saída                    | Baixa por consumo, perda, quebra ou ajuste.                                   |
    | **S**  | **Pedido Setor**                  | Saída                    | Solicitação feita por setores internos (enfermarias, UTI, etc.).              |
    | **P**  | **Pedido Paciente**               | Saída                    | Solicitação específica para atendimento de um paciente.                       |
    | **N**  | **Nota Fiscal**                   | Entrada                  | Registro de movimentações via nota fiscal, geralmente entrada de compras.     |
    | **R**  | **Requisição**                    | Saída                    | Pedido formal de materiais — pode gerar movimentação real ou reserva.         |
    | **B**  | **Baixa Técnica / Ajuste Manual** | Saída                    | Ajuste manual no estoque sem movimentação física visível.                     |
*/

-- MOVIMENTACAO, CONSUMO e CUSTO POR PERÍODO
WITH source_movimentacao
     AS (
        SELECT
            itmv.CD_PRODUTO,
            mvto.CD_ESTOQUE,
            p.CD_ESPECIE,
            -- TRUNC(mvto.DT_MVTO_ESTOQUE) AS MVTO_DIARIA,
            TO_NUMBER(TO_CHAR(LAST_DAY(mvto.DT_MVTO_ESTOQUE), 'DD')) AS DIAS_MES,
            EXTRACT(YEAR FROM mvto.DT_MVTO_ESTOQUE) AS ANO,
            TO_CHAR(mvto.DT_MVTO_ESTOQUE, 'MM/YYYY') AS MES_ANO,

            SUM(
                CASE
                    WHEN mvto.TP_MVTO_ESTOQUE IN ('D', 'C') THEN
                        (itmv.QT_MOVIMENTACAO * up.VL_FATOR) * -1
                    WHEN mvto.TP_MVTO_ESTOQUE IN ('S', 'P') THEN
                        (itmv.QT_MOVIMENTACAO * up.VL_FATOR)
                    ELSE 0
                END
            ) AS QT_MOVIMENTACAO

        FROM DBAMV.ITMVTO_ESTOQUE itmv
        JOIN DBAMV.MVTO_ESTOQUE mvto
            ON itmv.CD_MVTO_ESTOQUE = mvto.CD_MVTO_ESTOQUE
        JOIN DBAMV.UNI_PRO up
            ON itmv.CD_UNI_PRO = up.CD_UNI_PRO
        JOIN DBAMV.PRODUTO p
            ON itmv.CD_PRODUTO = p.CD_PRODUTO
        WHERE up.TP_RELATORIOS = 'G'
        AND    p.SN_MOVIMENTACAO = 'S'
        AND itmv.CD_PRODUTO IN(14328)
        GROUP BY
            itmv.CD_PRODUTO,
            mvto.CD_ESTOQUE,
            TO_NUMBER(TO_CHAR(LAST_DAY(mvto.DT_MVTO_ESTOQUE), 'DD')),
            p.CD_ESPECIE,
            -- TRUNC(mvto.DT_MVTO_ESTOQUE),
            EXTRACT(YEAR FROM mvto.DT_MVTO_ESTOQUE),
            TO_CHAR(mvto.DT_MVTO_ESTOQUE, 'MM/YYYY')
),
source_estoque_prod
    AS (
        SELECT * FROM DBAMV.EST_PRO WHERE CD_PRODUTO = 14328
),
source_custo_mensal
    AS (
        SELECT
            cmm.CD_PRODUTO,
            p.CD_ESPECIE,
            -- TRUNC(cmm.DH_CUSTO_MEDIO) AS MVTO_DIARIA,
            EXTRACT(YEAR FROM cmm.DH_CUSTO_MEDIO) AS ANO,
            TO_CHAR(cmm.DH_CUSTO_MEDIO, 'MM/YYYY') AS MES_ANO,
            SUM(cmm.VL_CUSTO_MEDIO) AS VL_CUSTO_MEDIO
        FROM DBAMV.CUSTO_MEDIO_MENSAL cmm
        JOIN DBAMV.PRODUTO p ON cmm.CD_PRODUTO = p.CD_PRODUTO
        WHERE cmm.CD_PRODUTO IN(14328)
        GROUP BY
            cmm.CD_PRODUTO,
            p.CD_ESPECIE,
            -- TRUNC(cmm.DH_CUSTO_MEDIO),
            EXTRACT(YEAR FROM cmm.DH_CUSTO_MEDIO),
            TO_CHAR(cmm.DH_CUSTO_MEDIO, 'MM/YYYY')
),
agg
    AS (
        SELECT
            m.CD_PRODUTO,
            m.CD_ESTOQUE,
            m.DIAS_MES,
            m.MES_ANO,
            m.ANO,

            SUM(m.QT_MOVIMENTACAO) AS QT_MOVIMENTACAO,
            SUM(cm.VL_CUSTO_MEDIO) AS VL_CUSTO_MEDIO,
            SUM(ep.QT_ESTOQUE_ATUAL) AS QT_ESTOQUE_ATUAL

        FROM source_movimentacao m
        LEFT JOIN source_custo_mensal cm
            ON m.CD_PRODUTO = cm.CD_PRODUTO AND m.MES_ANO = cm.MES_ANO
        LEFT JOIN source_estoque_prod ep
            ON m.CD_PRODUTO = ep.CD_PRODUTO AND m.CD_ESTOQUE = ep.CD_ESTOQUE
        GROUP BY
            m.CD_PRODUTO,
            m.CD_ESTOQUE,
            m.DIAS_MES,
            m.MES_ANO,
            m.ANO
)
SELECT
    CD_PRODUTO,
    CD_ESTOQUE,
    MES_ANO,
    --   DIAS_MES,
    --   ANO,
    -- FNC_MGCO_RETORNA_CONSUMO(CD_PRODUTO, MES_ANO, 1) AS QT_CONSUMO,
    QT_MOVIMENTACAO,
    VL_CUSTO_MEDIO,
    QT_ESTOQUE_ATUAL,
    -- ROUND(FNC_MGCO_RETORNA_CONSUMO(CD_PRODUTO, MES_ANO, 1) / DIAS_MES, 2) AS CONSUMO_MEDIO_DIARIO,
    ROUND( (QT_MOVIMENTACAO / DIAS_MES), 2) AS MOVIMENTO_MEDIO_DIARIO,
    -- ROUND(QT_ESTOQUE_ATUAL / (FNC_MGCO_RETORNA_CONSUMO(CD_PRODUTO, MES_ANO, 1) / DIAS_MES), 0) AS DIAS_RUPTURA
    ROUND(  QT_ESTOQUE_ATUAL / CASE WHEN (QT_MOVIMENTACAO / DIAS_MES ) = 0 THEN 1 ELSE (QT_MOVIMENTACAO / DIAS_MES ) END , 0 ) AS DIAS_RUPTURA
FROM agg
WHERE ANO IN(2024)
-- WHERE MES_ANO IN('01/2025', '02/2025', '03/2025', '04/2025')
-- WHERE MES_ANO IN('03/2025')
ORDER BY MES_ANO
;



SELECT
    CD_PRODUTO,
    CD_ESTOQUE,
    DT_ULTIMA_MOVIMENTACAO,
    QT_ESTOQUE_ATUAL,
    QT_CONSUMO_MES
FROM DBAMV.EST_PRO
WHERE CD_PRODUTO = 14328 --AND CD_ESTOQUE=2 --AND TO_CHAR(DT_ULTIMA_MOVIMENTACAO, 'MM/YYYY') = '06/2025'
ORDER BY DT_ULTIMA_MOVIMENTACAO DESC
;



SELECT DBAMV.FNC_MGCO_RETORNA_CONSUMO(14328, '03/2025', 1) AS CONSUMO_ FROM DUAL;
-- OU
SELECT
  ROUND(AVG(CONSUMO) / DBAMV.VERIF_VL_FATOR_PROD(MAX(CD_PRODUTO)), 2) AS CONSUMO_MEDIO
FROM (
    SELECT
        CD_PRODUTO,
        CD_MES,
        SUM(NVL(QT_SAIDA_PACIENTE,0)) + SUM(NVL(QT_SAIDA_SETOR,0)) -
        (SUM(NVL(QT_DEVOLUCAO_PACIENTE,0)) + SUM(NVL(QT_DEVOLUCAO_SETOR,0))) AS CONSUMO
    FROM DBAMV.C_CONEST
    WHERE CD_ANO || LPAD(CD_MES, 2, '0') BETWEEN '202503' AND '202503'
      AND CD_PRODUTO = 14328
    GROUP BY CD_PRODUTO, CD_MES
);






WITH paulo
    AS (
        SELECT
            'MVTO_ESTOQUE'          							  				 AS        Nm_Tabela
            ,Mvto_Estoque.Cd_Mvto_Estoque                                        AS        Cd_Movimentacao
            ,ItMvto_Estoque.Cd_Produto                                           AS        Cd_Produto_Mov
            ,Mvto_Estoque.Cd_Estoque                                             AS        Cd_Estoque_Mov
            ,Mvto_Estoque.Cd_Setor                                               AS        Cd_Setor
            ,To_Number(To_Char(Mvto_Estoque.Dt_Mvto_Estoque,'MM'))               AS        Cd_Mes
            ,To_Number(To_Char(Mvto_Estoque.Dt_Mvto_Estoque,'YYYY'))             AS        Cd_Ano
            ,ItMvto_Estoque.Qt_Movimentacao * Uni_Pro.Vl_Fator                   AS        Qt_Movimentacao

            ,dbamv.verif_vl_custo_medio(ItMvto_Estoque.Cd_Produto
                                        ,Mvto_Estoque.Dt_Mvto_Estoque
                                        ,'H'
                                        ,null
                                        ,Mvto_Estoque.Hr_Mvto_Estoque)

            * ItMvto_Estoque.Qt_Movimentacao * Uni_Pro.Vl_Fator                  AS        Vl_custo_Movimentacao
            , Estoque.Cd_Multi_Empresa
                    ,10000000000				 					     	                       Cd_Custo_Medio
                    ,Mvto_Estoque.Tp_Mvto_Estoque                                                Tp_Movimentacao
                    ,NVL(ItMvto_Estoque.Tp_Orcamento, 'O' )                                      Tp_Orcamento
                    ,Mvto_Estoque.Cd_Estoque_Destino                                             Cd_Estoque_Destino
                    ,trunc(Mvto_Estoque.Dt_Mvto_Estoque)								           Dt_Movimentacao
                    ,to_date(to_char(Mvto_Estoque.Hr_Mvto_Estoque, 'hh24:mi:ss'), 'hh24:mi:ss')  Hr_Movimentacao
                    ,ItMvto_Estoque.Cd_ItMvto_Estoque                                            Cd_Item
                    , mvto_estoque.cd_atendimento                                                cd_atendimento
                    , uni_pro.cd_uni_pro, uni_pro.cd_unidade, uni_pro.vl_fator, uni_pro.tp_relatorios
                FROM Dbamv.Mvto_Estoque
                    ,Dbamv.Uni_Pro
                    ,Dbamv.ItMvto_Estoque
                    ,Dbamv.Estoque
                    ,dbamv.produto
                -- WHERE Trunc(Mvto_Estoque.Dt_Mvto_Estoque)    BETWEEN To_Date('01/06/2024','dd/mm/yyyy') AND To_Date('30/06/2024' ,'dd/mm/yyyy')
                WHERE EXTRACT(YEAR FROM Mvto_Estoque.Dt_Mvto_Estoque) = 2024
                AND Mvto_Estoque.Cd_Estoque         = Estoque.Cd_Estoque
                AND ItMvto_Estoque.Cd_Mvto_Estoque  = Mvto_Estoque.Cd_Mvto_Estoque
                AND Uni_Pro.Cd_Uni_Pro(+)           = ItMvto_Estoque.Cd_Uni_Pro
                AND produto.cd_produto              = itmvto_estoque.cd_produto
                AND Estoque.Cd_Multi_Empresa        = 1
                AND produto.sn_consignado in ('N','R') --OR Dbamv.Pkg_Mges_Consignado.Fnc_Retorna_Tp_Processo(TO_DATE('01/06/2024','DD/MM/YYYY')) = 'F')
                AND mvto_estoque.tp_mvTO_ESTOQUE NOT IN ('T','E','R')
                AND produto.cd_produto =  14328

            ORDER BY Cd_Produto_Mov
                    ,Dt_Movimentacao
                    ,Hr_Movimentacao
                    ,Cd_Custo_Medio
                    ,Cd_Estoque_Mov
)
SELECT
    Cd_Produto_Mov,
    TRUNC(Dt_Movimentacao, 'MM') AS PERIODO,
    SUM(Qt_Movimentacao) AS Qt_Movimentacao,
    sum(Vl_custo_Movimentacao) AS Vl_custo_Movimentacao
FROM paulo
GROUP BY Cd_Produto_Mov, TRUNC(Dt_Movimentacao, 'MM')
ORDER BY Cd_Produto_Mov, TRUNC(Dt_Movimentacao, 'MM')
;

