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
source_match_cod_sol_ord_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            oc."CD_ORD_COM",
            oc."CD_PRODUTO",
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
        INNER JOIN source_snp_ord_com oc ON sc."CD_SOL_COM" = oc."CD_SOL_COM"
        AND sc."CD_PRODUTO" = oc."CD_PRODUTO"
),
source_match_desc_sol_ord_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            oc."CD_ORD_COM",
            oc."CD_PRODUTO",
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
            1 AS "MATCHING"
        FROM source_snp_sol_com sc
        INNER JOIN source_snp_ord_com oc ON sc."CD_SOL_COM" = oc."CD_SOL_COM"
        AND TRIM(UPPER(sc."DS_PRODUTO")) = TRIM(UPPER(oc."DS_PRODUTO"))
        WHERE
            NOT EXISTS(
                SELECT
                    1
                FROM source_snp_sol_com sc2
                INNER JOIN source_snp_ord_com oc2 ON sc2."CD_SOL_COM" = sc."CD_SOL_COM"
                AND sc2."CD_PRODUTO" = oc2."CD_PRODUTO"
                WHERE oc2."CD_PRODUTO" = oc."CD_PRODUTO"
            )
),
source_remov_match_cod_sol_ord_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            oc."CD_ORD_COM",
            oc."CD_PRODUTO",
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
            oc."TP_SITUACAO_OC"
        FROM source_snp_sol_com sc
        INNER JOIN source_snp_ord_com oc ON sc."CD_SOL_COM" = oc."CD_SOL_COM"
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM source_match_cod_sol_ord_com sm
                WHERE sm."CD_SOL_COM" = sc."CD_SOL_COM"
                AND sm."CD_PRODUTO" = sc."CD_PRODUTO"
            )
),
source_remov_match_desc_sol_ord_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            oc."CD_ORD_COM",
            oc."CD_PRODUTO",
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
            oc."TP_SITUACAO_OC"
        FROM source_remov_match_cod_sol_ord_com sc
        INNER JOIN source_snp_ord_com oc ON sc."CD_SOL_COM" = oc."CD_SOL_COM"
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM source_remov_match_cod_sol_ord_com sm_desc
                WHERE sm_desc."CD_SOL_COM" = sc."CD_SOL_COM"
                AND sm_desc."DS_PRODUTO" = sc."DS_PRODUTO"
            )
),
source_no_match_sol_ord_com
    AS (
        SELECT
            srm."CD_SOL_COM",
            srm."CD_ORD_COM",
            srm."CD_PRODUTO",
            srm."DS_PRODUTO",
            srm."CD_SETOR",
            srm."CD_ESTOQUE",
            srm."CD_MOT_PED",
            srm."CD_MOT_CANCEL_SC",
            srm."CD_MOT_CANCEL_OC",
            srm."DT_ORD_COM",
            srm."DT_SOL_COM",
            srm."DT_CANCELAMENTO",
            srm."DT_AUTORIZACAO",
            srm."SN_APROVADA",
            srm."SN_URGENTE",
            srm."SN_AUTORIZADO_OC",
            srm."SN_OPME",
            srm."TP_SITUACAO_SC",
            srm."TP_SITUACAO_OC",
            2 AS "MATCHING"
        FROM source_remov_match_desc_sol_ord_com srm
        WHERE NOT EXISTS (
            SELECT 1 FROM source_remov_match_cod_sol_ord_com cod
            WHERE cod."CD_SOL_COM" = srm."CD_SOL_COM"
            AND cod."CD_PRODUTO" = srm."CD_PRODUTO"
        )
        AND NOT EXISTS (
            SELECT 1 FROM source_remov_match_desc_sol_ord_com desc2
            WHERE desc2."CD_SOL_COM" = srm."CD_SOL_COM"
            AND desc2."DS_PRODUTO" = srm."DS_PRODUTO"
            -- AND desc2.ROWID <> srm.ROWID
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
        FROM source_match_cod_sol_ord_com a
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
        FROM source_match_desc_sol_ord_com b
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
        FROM source_no_match_sol_ord_com c
),
source_sol_ord_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            sc."CD_SETOR",
            sc."CD_ESTOQUE",
            sc."CD_MOT_PED",
            sc."CD_MOT_CANCEL_SC",
            sc."DT_SOL_COM",
            sc."DT_CANCELAMENTO",
            sc."TP_SITUACAO_SC",
            sc."SN_APROVADA",
            sc."SN_URGENTE",
            sc."SN_OPME",
            oc."CD_ORD_COM",
            oc."CD_PRODUTO",
            oc."CD_MOT_CANCEL_OC",
            oc."DT_ORD_COM",
            oc."DT_AUTORIZACAO",
            oc."TP_SITUACAO_OC",
            oc."SN_AUTORIZADO_OC"
        FROM source_snp_sol_com sc
        LEFT JOIN source_snp_ord_com oc ON sc."CD_SOL_COM" = oc."CD_SOL_COM"
),
source_itens_solicitacao
    AS (
        SELECT
            ic."CD_ITSOL_COM_KEY",
            ic."CD_SOL_COM",
            ic."CD_PRODUTO",
            ic."CD_UNI_PRO",
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
source_est_pro
    AS (
        SELECT
            ep."CD_ESTOQUE",
            ep."CD_PRODUTO",
            ep."DT_ULTIMA_MOVIMENTACAO",
            ep."QT_ESTOQUE_ATUAL",
            ep."QT_ESTOQUE_MAXIMO",
            ep."QT_ESTOQUE_MINIMO",
            ep."QT_ESTOQUE_VIRTUAL",
            ep."QT_PONTO_DE_PEDIDO",
            ep."QT_CONSUMO_MES",
            ep."QT_CONSUMO_ATUAL",
            ep."TP_CLASSIFICACAO_ABC"
        FROM staging.stg_est_pro ep
),
treats_qt_mov
    AS (
        SELECT
            itmve."CD_PRODUTO",
            up."VL_FATOR",
            up."TP_RELATORIOS",
            mve."TP_MVTO_ESTOQUE",
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
        WHERE up."TP_RELATORIOS" = 'G'
            AND mve."TP_MVTO_ESTOQUE" IN ('S', 'P', 'D', 'C')
        GROUP BY
            itmve."CD_PRODUTO",
            up."VL_FATOR",
            up."TP_RELATORIOS",
            mve."TP_MVTO_ESTOQUE"
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
            h."CD_MOT_CANCEL_SC",
            h."DT_SOL_COM",
            CASE
                WHEN (io."QT_COMPRADA" - io."QT_RECEBIDA") = 0 THEN 'Atendida'
                WHEN (io."QT_COMPRADA" - io."QT_RECEBIDA") = io."QT_CANCELADA" THEN 'Cancelada'
                ELSE h."TP_SITUACAO_SC"
            END AS "TP_SITUACAO_SC",
            h."SN_APROVADA",
            h."SN_URGENTE",
            h."SN_OPME",
            h."CD_ORD_COM",
            h."DT_ORD_COM",
            h."DT_AUTORIZACAO",
            h."CD_MOT_CANCEL_OC",
            CASE
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
            COALESCE(po."QT_ESTOQUE_ATUAL", 0) AS "QT_ESTOQUE_ATUAL",
            COALESCE(po."QT_CONSUMO_ATUAL", 0) AS "QT_CONSUMO_ATUAL",
            po."DT_ULTIMA_MOVIMENTACAO",
            COALESCE(tm."QT_MOVIMENTO", 0) AS "QT_MOVIMENTO",
            h."MATCHING"
        FROM treats_sol_ord_com h
        LEFT JOIN source_itens_solicitacao isol ON h."CD_SOL_COM" = isol."CD_SOL_COM" AND h."CD_PRODUTO" = isol."CD_PRODUTO"
        LEFT JOIN source_itens_pedidos io ON h."CD_ORD_COM" = io."CD_ORD_COM" AND h."CD_PRODUTO" = io."CD_PRODUTO"
        LEFT JOIN source_itens_entradas ie ON h."CD_ORD_COM" = ie."CD_ORD_COM" AND h."CD_PRODUTO" = ie."CD_PRODUTO"
        LEFT JOIN source_est_pro po ON h."CD_PRODUTO" = po."CD_PRODUTO" AND h."CD_ESTOQUE" = po."CD_ESTOQUE"
        LEFT JOIN treats_qt_mov tm ON h."CD_PRODUTO" = tm."CD_PRODUTO"
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
FROM treats
WHERE "MATCHING" = 2
--"CD_SOL_COM" = 3029
-- WHERE O."CD_SOL_COM" = 4042
;




/*
  * Alterar Escopo Semantico p/ que Solicitacao tenha prioridade
  * Unir SC e OC c/ match entre 'CD_SOLICITACAO' e 'CD_PRODUTO'
  * Unir SC e OC c/ match entre 'CD_SOLICITACAO' e 'DS_PRODUTO'
  * Identificar OC c/ itens arbitrarios a SC
  * Identificar SC|OC s/ itens (SERVICOS)
  *
  *
  *
  *
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
         NOT EXISTS (                      -- RESULTADOO: SC/OC sem item - SERVICOS
            SELECT 1
            FROM source_snp_sol_com ssc
            WHERE ssc."CD_SOL_COM" = soc."CD_SOL_COM"
            AND ssc."CD_PRODUTO" = soc."CD_PRODUTO"
        )
)
SELECT -- DISTINCT
    o.*
FROM ordens_com_produtos_nao_solicitados o
-- WHERE O."CD_SOL_COM" = 3029
-- WHERE O."CD_SOL_COM" = 4042
;



-- Versão que remove do resultado itens com descrição semelhante
-- entre SC e OC
-- Restando apenas:
--      - Itens de OC não pertencentes à SC original
--      - Itens de OC que não possui SC
WITH source_snp_sol_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            ic."CD_PRODUTO" AS "CD_PRODUTO_SC"
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
            io."CD_PRODUTO" AS "CD_PRODUTO_OC"
        FROM snapshots.snp_ord_com oc
        LEFT JOIN staging.stg_itord_pro io ON oc."CD_ORD_COM" = io."CD_ORD_COM"
        WHERE oc.dbt_valid_to IS NULL
),
source_produto
    AS (
        SELECT
            "CD_PRODUTO",
            TRIM(UPPER("DS_PRODUTO")) AS "DS_PRODUTO"
        FROM staging.stg_produto
),
ordens_com_produtos_nao_solicitados
    AS (
        SELECT
            soc."CD_ORD_COM",
            soc."CD_SOL_COM",
            soc."CD_PRODUTO_OC",
            soc."DT_ORD_COM",
            p_ord."DS_PRODUTO" AS "DS_PRODUTO_OC"
        FROM source_snp_ord_com soc
        LEFT JOIN source_produto p_ord ON soc."CD_PRODUTO_OC" = p_ord."CD_PRODUTO"
        WHERE soc."CD_PRODUTO_OC" IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM source_snp_sol_com ssc
            WHERE ssc."CD_SOL_COM" = soc."CD_SOL_COM"
            AND ssc."CD_PRODUTO_SC" = soc."CD_PRODUTO_OC"
        )
),
descricoes_solicitadas
    AS (
        SELECT
            ssc."CD_SOL_COM",
            TRIM(UPPER(p_sol."DS_PRODUTO")) AS "DS_PRODUTO_SC"
        FROM source_snp_sol_com ssc
        LEFT JOIN source_produto p_sol ON ssc."CD_PRODUTO_SC" = p_sol."CD_PRODUTO"
)
SELECT DISTINCT
    o."CD_ORD_COM",
    o."CD_SOL_COM",
    o."CD_PRODUTO_OC",
    o."DT_ORD_COM",
    o."DS_PRODUTO_OC"
FROM ordens_com_produtos_nao_solicitados o
LEFT JOIN descricoes_solicitadas ds ON ds."CD_SOL_COM" = o."CD_SOL_COM"
-- WHERE o."DS_PRODUTO_OC" IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM descricoes_solicitadas ds2
    WHERE ds2."CD_SOL_COM" = o."CD_SOL_COM"
    AND ds2."DS_PRODUTO_SC" = o."DS_PRODUTO_OC"
  )
;

-- Versão auditável evidenciando os itens com descrição semelhante
WITH source_snp_sol_com
    AS (
        SELECT
            sc."CD_SOL_COM",
            ic."CD_PRODUTO" AS "CD_PRODUTO_SC"
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
            io."CD_PRODUTO" AS "CD_PRODUTO_OC"
        FROM snapshots.snp_ord_com oc
        LEFT JOIN staging.stg_itord_pro io ON oc."CD_ORD_COM" = io."CD_ORD_COM"
        WHERE oc.dbt_valid_to IS NULL
),
source_produto
    AS (
        SELECT
            "CD_PRODUTO",
            TRIM(UPPER("DS_PRODUTO")) AS "DS_PRODUTO"
        FROM staging.stg_produto
),
ordens_com_produtos_nao_solicitados
    AS (
        SELECT
            soc."CD_ORD_COM",
            soc."CD_SOL_COM",
            soc."CD_PRODUTO_OC",
            soc."DT_ORD_COM",
            p_ord."DS_PRODUTO" AS "DS_PRODUTO_OC"
        FROM source_snp_ord_com soc
        LEFT JOIN source_produto p_ord ON soc."CD_PRODUTO_OC" = p_ord."CD_PRODUTO"
        WHERE soc."CD_PRODUTO_OC" IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM source_snp_sol_com ssc
            WHERE ssc."CD_SOL_COM" = soc."CD_SOL_COM"
                AND ssc."CD_PRODUTO_SC" = soc."CD_PRODUTO_OC"
        )
),
descricoes_solicitadas
    AS (
        SELECT DISTINCT
            ssc."CD_SOL_COM",
            TRIM(UPPER(p_sol."DS_PRODUTO")) AS "DS_PRODUTO_SC"
        FROM source_snp_sol_com ssc
        LEFT JOIN source_produto p_sol ON ssc."CD_PRODUTO_SC" = p_sol."CD_PRODUTO"
),
produtos_com_descricao_igual
    AS (
        SELECT DISTINCT
            o."CD_ORD_COM",
            o."CD_SOL_COM",
            o."CD_PRODUTO_OC",
            o."DT_ORD_COM",
            o."DS_PRODUTO_OC",
            ds."DS_PRODUTO_SC" AS "DS_PRODUTO_EQUIVALENTE_SC"
        FROM ordens_com_produtos_nao_solicitados o
        INNER JOIN descricoes_solicitadas ds ON o."CD_SOL_COM" = ds."CD_SOL_COM"
        AND o."DS_PRODUTO_OC" = ds."DS_PRODUTO_SC"
)
SELECT DISTINCT
    o."CD_ORD_COM",
    o."CD_SOL_COM",
    o."CD_PRODUTO_OC",
    o."DT_ORD_COM",
    o."DS_PRODUTO_OC",
    p."DS_PRODUTO_EQUIVALENTE_SC"
FROM ordens_com_produtos_nao_solicitados o
LEFT JOIN produtos_com_descricao_igual p ON o."CD_ORD_COM" = p."CD_ORD_COM"
AND o."CD_PRODUTO_OC" = p."CD_PRODUTO_OC"
WHERE p."DS_PRODUTO_EQUIVALENTE_SC" IS NULL
;