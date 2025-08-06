

-- CONSUMO FINAL
WITH CONSUMO_FINAL_POR_MES
    AS (
        SELECT
            TO_CHAR(sp.DT_SOLSAI_PRO, 'YYYY-MM') AS MES_ANO,
            sp.CD_SETOR,
            st.NM_SETOR,

            pr.CD_PRODUTO,
            pr.DS_PRODUTO,

            CASE sp.TP_SITUACAO
                WHEN 'P' THEN 'PEDIDO'
                WHEN 'C' THEN 'CONFIRMADO PARCIALMENTE'
                WHEN 'S' THEN 'CONFIRMADO'
                WHEN 'A' THEN 'CANCELADA'
                ELSE 'DESCONHECIDO'
            END AS TP_SITUACAO,

            CASE sp.TP_SOLSAI_PRO
                WHEN 'C' THEN 'DEVOLUCAO PACIENTE'
                WHEN 'D' THEN 'DEVOLUCAO SETOR'
                WHEN 'E' THEN 'PEDIDO ESTOQUE'
                WHEN 'P' THEN 'PEDIDO PACIENTE'
                WHEN 'T' THEN 'TRANSFERENCIA ENTRE EMPRESAS'
                ELSE 'DESCONHECIDO'
            END AS DS_TP_SOLSAI_PRO,

            ip.QT_ATENDIDA,

            DBAMV.VERIF_VL_FATOR_PROD(pr.CD_PRODUTO, 'G') AS FATOR_CONVERSAO,

            CASE
                WHEN sp.TP_SOLSAI_PRO = 'C' THEN
                    ip.QT_ATENDIDA * DBAMV.fnc_mges_custo_medio_produto(pr.CD_PRODUTO, sp.HR_SOLSAI_PRO)
                WHEN sp.TP_SOLSAI_PRO = 'D' THEN
                    DBAMV.fnc_mges_custo_medio_produto(pr.CD_PRODUTO, sp.HR_SOLSAI_PRO) * -1
                ELSE 0
            END AS VL_CUSTO_MEDIO

        FROM
            DBAMV.ITSOLSAI_PRO ip
        JOIN
            DBAMV.SOLSAI_PRO sp ON ip.CD_SOLSAI_PRO = sp.CD_SOLSAI_PRO
        LEFT JOIN
            DBAMV.PRODUTO pr ON ip.CD_PRODUTO = pr.CD_PRODUTO
        LEFT JOIN
            DBAMV.SETOR st ON sp.CD_SETOR = st.CD_SETOR
        WHERE
            sp.DT_SOLSAI_PRO IS NOT NULL
            -- AND sp.TP_SOLSAI_PRO IN ( 'C', 'D')
)
SELECT
    CD_SETOR,
    NM_SETOR,
    MES_ANO,
    CD_PRODUTO,
    DS_PRODUTO,

    SUM(QT_ATENDIDA * FATOR_CONVERSAO) AS QT_QUANTIDADE,

    ROUND(
        SUM((QT_ATENDIDA * FATOR_CONVERSAO) * VL_CUSTO_MEDIO) /
        NULLIF(SUM(QT_ATENDIDA * FATOR_CONVERSAO), 0),
        3
    ) AS VL_CUSTO_MEDIO,

    ROUND(
        ROUND(SUM(QT_ATENDIDA * FATOR_CONVERSAO), 3) *
        ROUND(
            SUM((QT_ATENDIDA * FATOR_CONVERSAO) * VL_CUSTO_MEDIO)
            / NULLIF(SUM(QT_ATENDIDA * FATOR_CONVERSAO), 0),
            3
        ),
        3
    ) AS VL_TOTAL_CONSUMIDO

FROM CONSUMO_FINAL_POR_MES
WHERE MES_ANO = '2025-07'
GROUP BY
    CD_SETOR,
    NM_SETOR,
    MES_ANO,
    CD_PRODUTO,
    DS_PRODUTO
ORDER BY CD_SETOR, MES_ANO, CD_PRODUTO
;



SELECT
    sp.*
FROM DBAMV.SOLSAI_PRO sp
WHERE sp.CD_SOLSAI_PRO = 469744
;


SELECT
    sp.TP_SOLSAI_PRO,
    count(*) AS FREQUENCIA
FROM DBAMV.SOLSAI_PRO sp
WHERE TO_CHAR(sp.DT_SOLSAI_PRO, 'MMYYYY') IN('012025', '022025', '032025', '042025', '052025', '062025', '072025')
GROUP BY sp.TP_SOLSAI_PRO
ORDER BY count(*) DESC
;