

-- CONSUMO FINAL
WITH CONSUMO_FINAL_POR_MES
    AS (
        SELECT
            TO_CHAR(sp.DT_SOLSAI_PRO, 'YYYY-MM') AS MES_ANO,
            sp.CD_SETOR,
            st.NM_SETOR,

            pr.CD_PRODUTO,
            pr.DS_PRODUTO,

            sp.CD_ESTOQUE_SOLICITANTE,
            e1.DS_ESTOQUE AS ESTOQUE_SOLICITANTE,

            sp.CD_ESTOQUE,
            e.DS_ESTOQUE AS ESTOQUE,

            sp.CD_AVISO_CIRURGIA,
            -- c.DS_CIRURGIA,

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

            COALESCE(
                CASE
                    WHEN sp.TP_SOLSAI_PRO = 'C' THEN
                        ip.QT_ATENDIDA * COALESCE(DBAMV.fnc_mges_custo_medio_produto(pr.CD_PRODUTO, sp.HR_SOLSAI_PRO), 0)
                    WHEN sp.TP_SOLSAI_PRO = 'D' THEN
                        COALESCE(DBAMV.fnc_mges_custo_medio_produto(pr.CD_PRODUTO, sp.HR_SOLSAI_PRO), 0) * -1
                    ELSE COALESCE(DBAMV.fnc_mges_custo_medio_produto(pr.CD_PRODUTO, sp.HR_SOLSAI_PRO), 0)
                END,
                0
            ) AS VL_CUSTO_MEDIO

        FROM
            DBAMV.ITSOLSAI_PRO ip
        JOIN
            DBAMV.SOLSAI_PRO sp ON ip.CD_SOLSAI_PRO = sp.CD_SOLSAI_PRO
        JOIN
            DBAMV.ESTOQUE e ON sp.CD_ESTOQUE = e.CD_ESTOQUE
        JOIN
            DBAMV.ESTOQUE e1 ON sp.CD_ESTOQUE_SOLICITANTE = e1.CD_ESTOQUE
        -- LEFT JOIN
        --     DBAMV.AVISO_CIRURGIA ac ON sp.CD_AVISO_CIRURGIA = ac.CD_AVISO_CIRURGIA
        -- JOIN
        --     DBAMV.CIRURGIA_AVISO ca ON sp.CD_AVISO_CIRURGIA = ca.CD_AVISO_CIRURGIA
        -- JOIN
        --     DBAMV.CIRURGIA c ON ca.CD_CIRURGIA = c.CD_CIRURGIA
        LEFT JOIN
            DBAMV.PRODUTO pr ON ip.CD_PRODUTO = pr.CD_PRODUTO
        LEFT JOIN
            DBAMV.SETOR st ON sp.CD_SETOR = st.CD_SETOR
        WHERE
            sp.DT_SOLSAI_PRO IS NOT NULL AND
            sp.CD_ESTOQUE = 2 AND
            EXTRACT(YEAR FROM sp.DT_SOLSAI_PRO) = EXTRACT(YEAR FROM SYSDATE)

)
SELECT
    CD_SETOR,
    NM_SETOR,
    MES_ANO,
    CD_PRODUTO,
    DS_PRODUTO,


    CD_ESTOQUE,
    ESTOQUE,
    -- DS_CIRURGIA,

    CD_ESTOQUE_SOLICITANTE,
    ESTOQUE_SOLICITANTE,

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
WHERE MES_ANO = '2025-03'
GROUP BY
    CD_SETOR,
    NM_SETOR,
    MES_ANO,
    CD_PRODUTO,
    DS_PRODUTO,
    CD_ESTOQUE,
    ESTOQUE,
    -- DS_CIRURGIA,
    CD_ESTOQUE_SOLICITANTE,
    ESTOQUE_SOLICITANTE
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