

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

            sp.TP_SOLSAI_PRO,
            CASE sp.TP_SOLSAI_PRO
                WHEN 'C' THEN 'DEVOLUCAO PACIENTE'
                WHEN 'D' THEN 'DEVOLUCAO SETOR'
                WHEN 'E' THEN 'PEDIDO ESTOQUE'
                WHEN 'P' THEN 'PEDIDO PACIENTE'
                WHEN 'S' THEN 'PEDIDO SETOR'
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
        LEFT JOIN
            DBAMV.PRODUTO pr ON ip.CD_PRODUTO = pr.CD_PRODUTO
        LEFT JOIN
            DBAMV.SETOR st ON sp.CD_SETOR = st.CD_SETOR
        WHERE
            sp.DT_SOLSAI_PRO IS NOT NULL AND
            sp.CD_ESTOQUE = 1 AND
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

    CD_AVISO_CIRURGIA,
    -- DS_CIRURGIA,

    CD_ESTOQUE_SOLICITANTE,
    ESTOQUE_SOLICITANTE,

    DS_TP_SOLSAI_PRO,

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
    CD_AVISO_CIRURGIA,
    -- DS_CIRURGIA,
    DS_TP_SOLSAI_PRO,
    CD_ESTOQUE_SOLICITANTE,
    ESTOQUE_SOLICITANTE
ORDER BY CD_SETOR, MES_ANO, CD_PRODUTO
;





-- QUERY LUCAS
WITH MOV_EST
    AS (
        SELECT
            me.CD_MVTO_ESTOQUE,
            me.CD_AVISO_CIRURGIA,
            me.CD_ATENDIMENTO,
            me.CD_SOLSAI_PRO,
            me.CD_PRE_MED,
            me.CD_ESTOQUE,
            e.DS_ESTOQUE,
            me.CD_UNID_INT,
            me.CD_SETOR,
            me.DT_MVTO_ESTOQUE,
            me.HR_MVTO_ESTOQUE,
            me.DT_VALIDADE,
            me.TP_MVTO_ESTOQUE,
            me.VL_TOTAL
        FROM DBAMV.MVTO_ESTOQUE me
        JOIN DBAMV.ESTOQUE e        ON me.CD_ESTOQUE = e.CD_ESTOQUE
        WHERE
            me.CD_AVISO_CIRURGIA IS NOT NULL AND
            EXTRACT(YEAR FROM me.HR_MVTO_ESTOQUE) = EXTRACT(YEAR FROM SYSDATE)
),
ITEM_MOV_EST
    AS (
        SELECT
            ie.CD_MVTO_ESTOQUE,
            ie.CD_PRODUTO,
            p.DS_PRODUTO,
            ie.CD_UNI_PRO,
            ie.CD_LOTE,
            ie.DT_VALIDADE
        FROM DBAMV.ITMVTO_ESTOQUE ie
        JOIN DBAMV.PRODUTO p ON ie.CD_PRODUTO = p.CD_PRODUTO
)
SELECT * FROM
MOV_EST me
JOIN ITEM_MOV_EST ime  ON me.CD_MVTO_ESTOQUE   = ime.CD_MVTO_ESTOQUE
;













--
WITH MOV_EST
    AS (
        SELECT
            me.CD_MVTO_ESTOQUE,
            me.CD_AVISO_CIRURGIA,
            me.CD_ATENDIMENTO,
            me.CD_SOLSAI_PRO,
            me.CD_PRE_MED,
            me.CD_ESTOQUE,
            e.DS_ESTOQUE,
            me.CD_UNID_INT,
            me.CD_SETOR,
            me.DT_MVTO_ESTOQUE,
            me.HR_MVTO_ESTOQUE,
            me.DT_VALIDADE,
            me.TP_MVTO_ESTOQUE,
            me.VL_TOTAL
        FROM DBAMV.MVTO_ESTOQUE me
        JOIN DBAMV.ESTOQUE e        ON me.CD_ESTOQUE = e.CD_ESTOQUE
        WHERE
            me.CD_AVISO_CIRURGIA IS NOT NULL AND
            EXTRACT(YEAR FROM me.HR_MVTO_ESTOQUE) = EXTRACT(YEAR FROM SYSDATE)
),
ITEM_MOV_EST
    AS (
        SELECT
            ie.CD_MVTO_ESTOQUE,
            ie.CD_PRODUTO,
            p.DS_PRODUTO,
            ie.CD_UNI_PRO,
            ie.CD_LOTE,
            ie.DT_VALIDADE
        FROM DBAMV.ITMVTO_ESTOQUE ie
        JOIN DBAMV.PRODUTO p ON ie.CD_PRODUTO = p.CD_PRODUTO
),
AV_CIRURGIAS
    AS (
        SELECT
            ac.CD_AVISO_CIRURGIA,
            ac.CD_ATENDIMENTO,
            ac.CD_PACIENTE,
            ac.CD_SAL_CIR,
            ac.CD_CEN_CIR,
            ac.DT_AVISO_CIRURGIA,
            ac.DT_REALIZACAO,
            ac.TP_SITUACAO,
            ac.CD_MOT_CANC
        FROM DBAMV.AVISO_CIRURGIA ac
        WHERE
            ac.CD_MOT_CANC IS NULL AND
            EXTRACT(YEAR FROM DT_AVISO_CIRURGIA) = EXTRACT(YEAR FROM SYSDATE)
),
CIRURGIA_AV
    AS (
        SELECT
            ca.CD_CIRURGIA_AVISO,
            ca.CD_AVISO_CIRURGIA,
            ca.CD_CIRURGIA,
            ca.CD_CONVENIO,
            c.NM_CONVENIO,
            ca.CD_PORTE_CIRURGIA,
            ca.SN_PRINCIPAL,
            ca.TP_CIRURGIA
        FROM DBAMV.CIRURGIA_AVISO ca
        JOIN DBAMV.CONVENIO c           ON  ca.CD_CONVENIO = c.CD_CONVENIO AND ca.SN_PRINCIPAL = 'S'
),
CIRURGIAS
    AS (
        SELECT
            c.CD_CIRURGIA,
            c.DS_CIRURGIA,
            c.TP_CIRURGIA,
            c.CD_PRO_FAT
        FROM DBAMV.CIRURGIA c
),
TREATS
    AS (
        SELECT
            c.CD_CIRURGIA,
            -- me.CD_CIRURGIA,

            c.DS_CIRURGIA AS DS_CIRURGIA_C,
            ime.CD_PRODUTO,
            ime.DS_PRODUTO,
            me.CD_ESTOQUE,
            me.DS_ESTOQUE,

            ac.CD_MOT_CANC,

            ca.CD_AVISO_CIRURGIA,
            -- me.CD_AVISO_CIRURGIA,

            ca.CD_CONVENIO,
            ca.NM_CONVENIO,
            -- me.CD_CONVENIO,

            ca.SN_PRINCIPAL,
            -- me.SN_PRINCIPAL,

            ac.CD_ATENDIMENTO,
            ac.CD_PACIENTE,
            ac.CD_SAL_CIR,
            ac.CD_CEN_CIR,
            ac.DT_AVISO_CIRURGIA,
            ac.DT_REALIZACAO,
            EXTRACT(MONTH FROM ac.DT_REALIZACAO) AS MES,
            EXTRACT(YEAR FROM ac.DT_REALIZACAO) AS ANO,
            ac.TP_SITUACAO,

            ca.CD_CIRURGIA_AVISO,
            ca.CD_PORTE_CIRURGIA,
            ca.TP_CIRURGIA

        FROM CIRURGIA_AV ca
        JOIN CIRURGIAS c       ON ca.CD_CIRURGIA       = c.CD_CIRURGIA
        JOIN AV_CIRURGIAS ac   ON ca.CD_AVISO_CIRURGIA = ac.CD_AVISO_CIRURGIA
        JOIN MOV_EST me        ON ac.CD_AVISO_CIRURGIA = me.CD_AVISO_CIRURGIA
        JOIN ITEM_MOV_EST ime  ON me.CD_MVTO_ESTOQUE   = ime.CD_MVTO_ESTOQUE
),
AGRUPAMENTO AS (
    SELECT
        MES,
        ANO,
        DS_CIRURGIA_C,
        DS_PRODUTO,
        COUNT(*) AS FREQUENCIA
    FROM TREATS
    GROUP BY
        MES,
        ANO,
        DS_CIRURGIA_C,
        DS_PRODUTO
),
PIVO AS (
    SELECT * FROM AGRUPAMENTO
    PIVOT (
        SUM(FREQUENCIA)
        FOR MES IN (
            1 AS JAN,
            2 AS FEV,
            3 AS MAR,
            4 AS ABR,
            5 AS MAI,
            6 AS JUN,
            7 AS JUL,
            8 AS AGO,
            9 AS SET_,
            10 AS OUT_,
            11 AS NOV,
            12 AS DEZ
        )
    )
    ORDER BY
        ANO,
        DS_CIRURGIA_C,
        DS_PRODUTO
)
SELECT
    ANO,
    DS_CIRURGIA_C,
    DS_PRODUTO,
    JAN, FEV, MAR, ABR, MAI, JUN, JUL, AGO, SET_, OUT_, NOV, DEZ
FROM PIVO;





-- SELECT
--     CD_CIRURGIA,
--     DS_CIRURGIA_C,
--     CD_PRODUTO,
--     DS_PRODUTO,
--     CD_ESTOQUE,
--     DS_ESTOQUE,
--     CD_MOT_CANC,
--     CD_AVISO_CIRURGIA,
--     CD_CONVENIO,
--     NM_CONVENIO,
--     SN_PRINCIPAL,
--     CD_ATENDIMENTO,
--     CD_PACIENTE,
--     CD_SAL_CIR,
--     CD_CEN_CIR,
--     DT_AVISO_CIRURGIA,
--     DT_REALIZACAO,
--     TP_SITUACAO,
--     CD_CIRURGIA_AVISO,
--     CD_PORTE_CIRURGIA,
--     TP_CIRURGIA
-- FROM TREATS
-- WHERE CD_ATENDIMENTO = 238671
-- ORDER BY CD_ATENDIMENTO, CD_CIRURGIA




SELECT
    *
FROM DBAMV.AVISO_CIRURGIA
WHERE CD_ATENDIMENTO = 238671
;


SELECT
    *
FROM DBAMV.CIRURGIA_AVISO
WHERE CD_AVISO_CIRURGIA IN(17343, 17372, 17375)
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