

/* ###################### RELATORIO DE GUIAS FUSMA ####################### */

-- M_REMESSA_FFCV
-- M_LAN_AMB_PARTICULAR
-- M_TUSS_FFCV



/* ############################# OCORRENCIAS #############################
 *
 * - CD_ATENDIMENTO: 238738
 *      - 2 CD_REMESSAS:
 *          - 14375 - 41001230  TC - ANGIOTOMOGRAFIA CORONARIANA [EXAME]
 *          - 13657 - 10805048  PS - ESPECIALIDADE CARDIOLOGIA   [CONSULTA]
 *      - ATENDIMENTO C/ CONSULTAS e EXAMES NA MESMA COMPETENCIA:
 *          - AGRUPA O VL_TOTAL_CONTA PELO PROCEDIMENTO DA CONSULTA
 *              - CODIGO PROCEDIMENTO DA CONSULTA
 *              - DESCRICAO CONSULTA
 *              - GUIA DA CONSULTA
 *              - CARTEIRA DA CONSULTA
 *      - ATENDIMENTO C/ CONSULTAS e EXAMES EM COMPETENCIAS DIFERENTES:
 *              - CODIGO PROCEDIMENTO DA CONSULTA ou EXAME
 *              - DESCRICAO CONSULTA ou EXAME
 *              - GUIA DA CONSULTA ou EXAME
 *              - CARTEIRA DA CONSULTA ou EXAME
 *
 * ########################################################################
 *
 *      - 2 PROCEDIMENTOS DE EXAMES NA SEGUNDA REMESSA:
 *              - RETORNA OS 2 PROCEDIMENTOS COM MESMA GUIA DE AUTORIZACAO ?
 *              - OU AGRUPA E RETORNA SÓ UM ? RETORNA OS DOIS CASOS
 *
 * ########################################################################
 *
 *  - CD_PRO_FAT:
 *      - CD_REMESSA: 14764 -> CONSULTAS
 *          - 00040105 | 00040108 | 00040109
 *
 *      - CD_REMESSA: 14050 -> EXAMES
 *          - 40901361
 *
 * ########################################################################
 *
 *  - CASOS COM N_GAU | NM_PACIENTE | NIP = NULL
 *      - PROCEDIMENTOS SEM GUIA EM ITREG_AMB/ITREG_FAT
 *      - POR NAO TER  CD_GUIA O JOIN NAO RECUPERA OS DADOS DE ATENDIME
 *        NA QUERY FINAL
 *
*/

WITH FILTRO AS (
    SELECT
        -- {V_CODIGO_DA_REMESSA} AS CD_REMESSA
        :param AS CD_REMESSA
    FROM DUAL
),
JN_ATENDIMENTO
    AS(
        SELECT
            a.CD_ATENDIMENTO,
            a.DT_ATENDIMENTO,
            EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES,
            EXTRACT(YEAR FROM  a.DT_ATENDIMENTO) AS ANO,
            a.CD_PACIENTE,
            p.NM_PACIENTE,
            a.TP_ATENDIMENTO,
            c.NM_CONVENIO,
            a.SN_OBITO,
            g.CD_GUIA,
            g.NR_GUIA,
            g.TP_GUIA,
            g.DT_AUTORIZACAO,
            a.NR_CARTEIRA
        FROM DBAMV.ATENDIME a
        JOIN DBAMV.PACIENTE p ON a.CD_PACIENTE = p.CD_PACIENTE
        JOIN DBAMV.CONVENIO c ON a.CD_CONVENIO = c.CD_CONVENIO
        JOIN DBAMV.GUIA     g ON a.CD_ATENDIMENTO = g.CD_ATENDIMENTO AND a.CD_CONVENIO = g.CD_CONVENIO
        WHERE
            g.NR_GUIA IS NOT NULL
),
JN_REGRA_AMBULATORIO
    AS (
        SELECT
            ia.CD_ATENDIMENTO,
            CASE
                WHEN ia.CD_GRU_FAT = 8 THEN
                    COALESCE(FIRST_VALUE(CASE WHEN pf.CD_GRU_PRO = 0 THEN ia.CD_GUIA END) OVER (
                        PARTITION BY ia.CD_ATENDIMENTO
                        ORDER BY CASE WHEN pf.CD_GRU_PRO = 0 THEN 1 ELSE 2 END
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                    ), ia.CD_GUIA)
                WHEN ia.SN_PERTENCE_PACOTE = 'N' THEN
                    COALESCE(FIRST_VALUE(CASE WHEN ia.CD_GRU_FAT = 8 THEN ia.CD_GUIA END) OVER (
                        PARTITION BY ia.CD_ATENDIMENTO
                        ORDER BY CASE WHEN ia.CD_GRU_FAT = 8 THEN 1 ELSE 2 END
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                    ), ia.CD_GUIA)

                ELSE ia.CD_GUIA
            END AS CD_GUIA,
            ia.CD_REG_AMB,
            ra.CD_REMESSA,
            pf.CD_GRU_PRO,
            ia.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            ia.CD_CONVENIO,
            ia.SN_PERTENCE_PACOTE,
            ia.VL_TOTAL_CONTA,
            ia.TP_PAGAMENTO,
            'AMBULATORIO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_AMB ia
        LEFT JOIN DBAMV.PRO_FAT pf     ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_AMB ra     ON ia.CD_REG_AMB = ra.CD_REG_AMB
        LEFT JOIN DBAMV.PRESTADOR p    ON ia.CD_PRESTADOR = p.CD_PRESTADOR
        CROSS JOIN FILTRO
        WHERE
            ra.CD_REMESSA = FILTRO.CD_REMESSA
),
JN_REGRA_HOSPITALAR
    AS (
        SELECT
            rf.CD_ATENDIMENTO,
                CASE
                    WHEN ift.CD_GRU_FAT = 8 THEN
                        COALESCE(FIRST_VALUE(CASE WHEN pf.CD_GRU_PRO = 0 THEN ift.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN pf.CD_GRU_PRO = 0 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), ift.CD_GUIA)
                    WHEN ift.SN_PERTENCE_PACOTE = 'N' THEN
                        COALESCE(FIRST_VALUE(CASE WHEN ift.CD_GRU_FAT = 8 THEN ift.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN ift.CD_GRU_FAT = 8 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), ift.CD_GUIA)

                    ELSE ift.CD_GUIA
                END AS CD_GUIA,
            ift.CD_REG_FAT,
            rf.CD_REMESSA,
            pf.CD_GRU_PRO,
            ift.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            rf.CD_CONVENIO,
            ift.SN_PERTENCE_PACOTE,
            ift.VL_TOTAL_CONTA,
            ift.TP_PAGAMENTO,
            'FATURAMENTO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_FAT ift
        LEFT JOIN DBAMV.PRO_FAT pf 	   ON ift.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_FAT rf 	   ON ift.CD_REG_FAT = rf.CD_REG_FAT
        LEFT JOIN DBAMV.PRESTADOR p    ON ift.CD_PRESTADOR = p.CD_PRESTADOR
        CROSS JOIN FILTRO
        WHERE
            rf.CD_REMESSA = FILTRO.CD_REMESSA
),
JN_UNION_REGRAS
    AS (
        SELECT
            ra.CD_ATENDIMENTO,
            ra.CD_GUIA,

            ra.SN_PERTENCE_PACOTE,

            ra.DS_PRO_FAT AS PROCEDIMENTO,
            ra.CD_PRO_FAT AS CODIGO,

            ra.CD_CONVENIO,

            ra.RG_FATURAMENTO AS RG_FATURAMENTO,
            ra.VL_TOTAL_CONTA  AS VL_TOTAL_CONTA,

            CASE WHEN ra.CD_PRO_FAT = '10805048' THEN 1 END UNI,

            ROW_NUMBER() OVER ( PARTITION BY
                    ra.CD_ATENDIMENTO
                ORDER BY ra.CD_GUIA
            ) AS RW

        FROM JN_REGRA_AMBULATORIO ra
        WHERE ra.SN_PERTENCE_PACOTE = 'N'

        UNION ALL

        SELECT
            rh.CD_ATENDIMENTO,
            rh.CD_GUIA,

            rh.SN_PERTENCE_PACOTE,

            rh.DS_PRO_FAT AS PROCEDIMENTO,
            rh.CD_PRO_FAT AS CODIGO,

            rh.CD_CONVENIO,

            rh.RG_FATURAMENTO AS RG_FATURAMENTO,
            rh.VL_TOTAL_CONTA  AS VL_TOTAL_CONTA,

            CASE WHEN rh.CD_PRO_FAT = '10805048' THEN 1 END UNI,

            ROW_NUMBER() OVER ( PARTITION BY
                    rh.CD_ATENDIMENTO
                ORDER BY rh.CD_GUIA
            ) AS RW

        FROM JN_REGRA_HOSPITALAR rh
        WHERE rh.SN_PERTENCE_PACOTE = 'N'
),
JN_TUSS
    AS (
        SELECT
            CD_PRO_FAT,
            CD_TUSS,
            CD_CONVENIO
        FROM DBAMV.TUSS
),
TREATS
    AS (
        SELECT
            a.NR_GUIA AS N_GAU,
            a.NM_PACIENTE,

            a.NR_CARTEIRA  AS NIP,

            ur.PROCEDIMENTO,

            COALESCE(t.CD_TUSS, ur.CODIGO) AS CODIGO,

            ur.UNI,
            ur.RW,

            CASE WHEN ur.SN_PERTENCE_PACOTE = 'N' THEN
                SUM(ur.VL_TOTAL_CONTA) OVER ( PARTITION BY ur.CD_ATENDIMENTO )
            ELSE
                SUM(ur.VL_TOTAL_CONTA) OVER ( PARTITION BY ur.CD_ATENDIMENTO, a.NR_GUIA )
            END AS VL_TOTAL_CONTA

        FROM JN_UNION_REGRAS ur
        LEFT JOIN JN_ATENDIMENTO a  ON a.CD_ATENDIMENTO = ur.CD_ATENDIMENTO AND a.CD_GUIA = ur.CD_GUIA
        LEFT JOIN JN_TUSS t ON ur.CODIGO = t.CD_PRO_FAT AND ur.CD_CONVENIO = t.CD_CONVENIO
)
SELECT
    *
FROM TREATS
WHERE RW = 1

;




SELECT
    PROCEDIMENTO,
    COUNT(1) QTD_PROCEDIMENTOS,
    VL_TOTAL_CONTA,
    VL_TOTAL_CONTA * COUNT(1) AS TOTAL

 FROM (
        WITH FILTRO AS (
            SELECT
                :param AS CD_REMESSA
            FROM DUAL
    ),
JN_ATENDIMENTO
    AS(
        SELECT
            a.CD_ATENDIMENTO,
            a.DT_ATENDIMENTO,
            EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES,
            EXTRACT(YEAR FROM  a.DT_ATENDIMENTO) AS ANO,
            a.CD_PACIENTE,
            p.NM_PACIENTE,
            a.TP_ATENDIMENTO,
            c.NM_CONVENIO,
            a.SN_OBITO,
            g.CD_GUIA,
            g.NR_GUIA,
            g.TP_GUIA,
            g.DT_AUTORIZACAO,
            a.NR_CARTEIRA
        FROM DBAMV.ATENDIME a
        JOIN DBAMV.PACIENTE p ON a.CD_PACIENTE = p.CD_PACIENTE
        JOIN DBAMV.CONVENIO c ON a.CD_CONVENIO = c.CD_CONVENIO
        JOIN DBAMV.GUIA     g ON a.CD_ATENDIMENTO = g.CD_ATENDIMENTO AND a.CD_CONVENIO = g.CD_CONVENIO
        WHERE
            g.NR_GUIA IS NOT NULL
),
JN_REGRA_AMBULATORIO
    AS (
        SELECT
            ia.CD_ATENDIMENTO,
            CASE
                WHEN ia.CD_GRU_FAT = 8 THEN
                    COALESCE(FIRST_VALUE(CASE WHEN pf.CD_GRU_PRO = 0 THEN ia.CD_GUIA END) OVER (
                        PARTITION BY ia.CD_ATENDIMENTO
                        ORDER BY CASE WHEN pf.CD_GRU_PRO = 0 THEN 1 ELSE 2 END
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                    ), ia.CD_GUIA)
                WHEN ia.SN_PERTENCE_PACOTE = 'N' THEN
                    COALESCE(FIRST_VALUE(CASE WHEN ia.CD_GRU_FAT = 8 THEN ia.CD_GUIA END) OVER (
                        PARTITION BY ia.CD_ATENDIMENTO
                        ORDER BY CASE WHEN ia.CD_GRU_FAT = 8 THEN 1 ELSE 2 END
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                    ), ia.CD_GUIA)

                ELSE ia.CD_GUIA
            END AS CD_GUIA,
            ia.CD_REG_AMB,
            ra.CD_REMESSA,
            pf.CD_GRU_PRO,
            ia.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            ia.CD_CONVENIO,
            ia.SN_PERTENCE_PACOTE,
            ia.VL_TOTAL_CONTA,
            ia.TP_PAGAMENTO,
            'AMBULATORIO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_AMB ia
        LEFT JOIN DBAMV.PRO_FAT pf     ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_AMB ra     ON ia.CD_REG_AMB = ra.CD_REG_AMB
        LEFT JOIN DBAMV.PRESTADOR p    ON ia.CD_PRESTADOR = p.CD_PRESTADOR
        CROSS JOIN FILTRO
        WHERE
            ra.CD_REMESSA = FILTRO.CD_REMESSA
),
JN_REGRA_HOSPITALAR
    AS (
        SELECT
            rf.CD_ATENDIMENTO,
                CASE
                    WHEN ift.CD_GRU_FAT = 8 THEN
                        COALESCE(FIRST_VALUE(CASE WHEN pf.CD_GRU_PRO = 0 THEN ift.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN pf.CD_GRU_PRO = 0 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), ift.CD_GUIA)
                    WHEN ift.SN_PERTENCE_PACOTE = 'N' THEN
                        COALESCE(FIRST_VALUE(CASE WHEN ift.CD_GRU_FAT = 8 THEN ift.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN ift.CD_GRU_FAT = 8 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), ift.CD_GUIA)

                    ELSE ift.CD_GUIA
                END AS CD_GUIA,
            ift.CD_REG_FAT,
            rf.CD_REMESSA,
            pf.CD_GRU_PRO,
            ift.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            rf.CD_CONVENIO,
            ift.SN_PERTENCE_PACOTE,
            ift.VL_TOTAL_CONTA,
            ift.TP_PAGAMENTO,
            'FATURAMENTO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_FAT ift
        LEFT JOIN DBAMV.PRO_FAT pf 	   ON ift.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_FAT rf 	   ON ift.CD_REG_FAT = rf.CD_REG_FAT
        LEFT JOIN DBAMV.PRESTADOR p    ON ift.CD_PRESTADOR = p.CD_PRESTADOR
        CROSS JOIN FILTRO
        WHERE
            rf.CD_REMESSA = FILTRO.CD_REMESSA
),
JN_UNION_REGRAS
    AS (
        SELECT
            ra.CD_ATENDIMENTO,
            ra.CD_GUIA,

            ra.SN_PERTENCE_PACOTE,

            ra.DS_PRO_FAT AS PROCEDIMENTO,
            ra.CD_PRO_FAT AS CODIGO,

            ra.CD_CONVENIO,

            ra.RG_FATURAMENTO AS RG_FATURAMENTO,
            ra.VL_TOTAL_CONTA  AS VL_TOTAL_CONTA,

            CASE WHEN ra.CD_PRO_FAT = '10805048' THEN 1 END UNI,

            ROW_NUMBER() OVER ( PARTITION BY
                    ra.CD_ATENDIMENTO
                ORDER BY ra.CD_GUIA
            ) AS RW

        FROM JN_REGRA_AMBULATORIO ra
        WHERE ra.SN_PERTENCE_PACOTE = 'N'

        UNION ALL

        SELECT
            rh.CD_ATENDIMENTO,
            rh.CD_GUIA,

            rh.SN_PERTENCE_PACOTE,

            rh.DS_PRO_FAT AS PROCEDIMENTO,
            rh.CD_PRO_FAT AS CODIGO,

            rh.CD_CONVENIO,

            rh.RG_FATURAMENTO AS RG_FATURAMENTO,
            rh.VL_TOTAL_CONTA  AS VL_TOTAL_CONTA,

            CASE WHEN rh.CD_PRO_FAT = '10805048' THEN 1 END UNI,

            ROW_NUMBER() OVER ( PARTITION BY
                    rh.CD_ATENDIMENTO
                ORDER BY rh.CD_GUIA
            ) AS RW

        FROM JN_REGRA_HOSPITALAR rh
        WHERE rh.SN_PERTENCE_PACOTE = 'N'
),
JN_TUSS
    AS (
        SELECT
            CD_PRO_FAT,
            CD_TUSS,
            CD_CONVENIO
        FROM DBAMV.TUSS
),
TREATS
    AS (
        SELECT
            ur.CD_ATENDIMENTO,
            a.NR_GUIA AS N_GAU,
            a.NM_PACIENTE,

            a.NR_CARTEIRA  AS NIP,

            ur.PROCEDIMENTO,

            COALESCE(t.CD_TUSS, ur.CODIGO) AS CODIGO,

            ur.UNI,
            ur.RW,

            CASE WHEN ur.SN_PERTENCE_PACOTE = 'N' THEN
                SUM(ur.VL_TOTAL_CONTA) OVER ( PARTITION BY ur.CD_ATENDIMENTO )
            ELSE
                SUM(ur.VL_TOTAL_CONTA) OVER ( PARTITION BY ur.CD_ATENDIMENTO, a.NR_GUIA )
            END AS VL_TOTAL_CONTA

        FROM JN_UNION_REGRAS ur
        LEFT JOIN JN_ATENDIMENTO a  ON a.CD_ATENDIMENTO = ur.CD_ATENDIMENTO AND a.CD_GUIA = ur.CD_GUIA
        LEFT JOIN JN_TUSS t ON ur.CODIGO = t.CD_PRO_FAT AND ur.CD_CONVENIO = t.CD_CONVENIO
)
SELECT
    *
FROM TREATS
WHERE RW = 1
)
GROUP BY
    PROCEDIMENTO,
    VL_TOTAL_CONTA
;