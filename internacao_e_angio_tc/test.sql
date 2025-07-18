-- QTD 1.988
WITH EXAMEES
    AS (
        SELECT
            -- a.CD_ATENDIMENTO ,
            -- a.TP_ATENDIMENTO ,
            -- a.HR_ATENDIMENTO ,
            TO_CHAR(TRUNC(pr.HR_PEDIDO), 'MM/YYYY') AS MES_ANO,
            -- a.CD_ORI_ATE ,
            -- oa.DS_ORI_ATE ,
            -- c.NM_CONVENIO ,
            pm.CD_PRE_MED ,
            pm.DH_CRIACAO ,
            CAST('EXI' AS VARCHAR2(3)) AS CD_TIP_ESQ ,
            er.CD_EXA_RX,
            er.DS_EXA_RX EXAMES
        FROM  ITPED_RX ir
        LEFT JOIN PED_RX pr
            ON ir.cd_ped_rx = pr.cd_ped_rx
        LEFT JOIN EXA_RX er
            ON ir.cd_exa_rx = er.cd_exa_rx
        LEFT JOIN PRE_MED pm
            ON pr.CD_PRE_MED = pm.CD_PRE_MED
        -- LEFT JOIN ATENDIME a
        --     ON pr.cd_atendimento = a.cd_atendimento

)
SELECT COUNT(*) FROM EXAMEES WHERE MES_ANO IN('01/2025', '02/2025', '03/2025', '04/2025', '05/2025', '06/2025') AND CD_EXA_RX = 706
;


-- QTD 1.691
WITH EXA_REA
    AS (
        SELECT
            A.DT_ATENDIMENTO,
            PX.CD_PED_RX COD_PED,
            PX.CD_SETOR COD_SETOR,
            S.NM_SETOR NOME_SETOR,
            PX.CD_PRESTADOR COD_MEDICO_SOL,
            PR.NM_PRESTADOR NOME_MEDICO_SOL,
            TRUNC(PX.HR_PEDIDO) AS DATA_PEDIDO,
            IX.DT_REALIZADO,
            PX.CD_ATENDIMENTO COD_ATEND,
            A.CD_PACIENTE COD_PACIENTE,
            P.NM_PACIENTE NOME_PACIENTE,
            IX.CD_EXA_RX COD_EXAME,
            EX.DS_EXA_RX NOME_EXA,
            IB.CD_PRO_FAT PROCEDIMENTO,
            IB.VL_TOTAL_CONTA VL_TOTAL,
            PX.CD_CONVENIO COD_CONVENIO,
            C.NM_CONVENIO CONVENIO,
            IX.SN_REALIZADO,
            IX.CD_PRESTADOR COD_MED_LAU
        FROM
            EXA_RX EX,
            ITPED_RX IX,
            PED_RX PX,
            ATENDIME A,
            ITREG_AMB IB,
            --REG_FAT rf,
            --ITREG_FAT if,
            SETOR S,
            PRO_FAT pf,
            prestador pr,
            PACIENTE P,
            CONVENIO C
        WHERE
            A.CD_ATENDIMENTO = PX.CD_ATENDIMENTO
            AND PX.CD_PED_RX = IX.CD_PED_RX
            AND IX.CD_EXA_RX = EX.CD_EXA_RX
            AND C.CD_CONVENIO = IB.CD_CONVENIO
            AND IB.CD_ATENDIMENTO = A.CD_ATENDIMENTO
            AND P.CD_PACIENTE = A.CD_PACIENTE
            AND PR.CD_PRESTADOR = PX.CD_PRESTADOR
            --AND A.TP_ATENDIMENTO = 'E'
            AND IB.CD_PRO_FAT = PF.CD_PRO_FAT
            AND EX.EXA_RX_CD_PRO_FAT = IB.CD_PRO_FAT
            AND S.CD_SETOR = IB.CD_SETOR
            -- AND TRUNC(PX.HR_PEDIDO) BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-06-30', 'YYYY-MM-DD')
            -- AND TRUNC(IX.DT_REALIZADO) BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-06-30', 'YYYY-MM-DD')
            AND TRUNC(A.DT_ATENDIMENTO) BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-06-30', 'YYYY-MM-DD')
        UNION ALL
        SELECT
            A.DT_ATENDIMENTO,
            PX.CD_PED_RX COD_PED,
            PX.CD_SETOR COD_SETOR,
            S.NM_SETOR NOME_SETOR,
            PX.CD_PRESTADOR COD_MEDICO,
            PR.NM_PRESTADOR NOME_MEDICO,
            TRUNC(PX.HR_PEDIDO)  AS DATA_PEDIDO,
            IX.DT_REALIZADO,
            PX.CD_ATENDIMENTO COD_ATEND,
            A.CD_PACIENTE COD_PACIENTE,
            P.NM_PACIENTE NOME_PACIENTE,
            IX.CD_EXA_RX COD_EXAME,
            EX.DS_EXA_RX NOME_EXA,
            IF.CD_PRO_FAT PROCEDIMENTO,
            -- PF.DS_PRO_FAT NOME_EXAME,
            IF.VL_TOTAL_CONTA VL_TOTAL,
            PX.CD_CONVENIO COD_CONVENIO,
            C.NM_CONVENIO CONVENIO,
            IX.SN_REALIZADO,
            IX.CD_PRESTADOR COD_MED_LAU
        FROM
            EXA_RX EX,
            ITPED_RX IX,
            PED_RX PX,
            ATENDIME A,
            --ITREG_AMB IB,
            REG_FAT rf,
            ITREG_FAT if,
            SETOR S,
            PRO_FAT pf,
            prestador pr,
            PACIENTE P,
            CONVENIO C
        WHERE
            PX.CD_ATENDIMENTO = RF.CD_ATENDIMENTO
            AND PX.CD_PED_RX = IX.CD_PED_RX
            AND IX.CD_EXA_RX = EX.CD_EXA_RX
            AND C.CD_CONVENIO = rf.CD_CONVENIO
            AND RF.CD_ATENDIMENTO = A.CD_ATENDIMENTO
            AND IF.CD_REG_FAT = RF.CD_REG_FAT
            --AND IB.CD_ATENDIMENTO = A.CD_ATENDIMENTO
            AND P.CD_PACIENTE = A.CD_PACIENTE
            AND PR.CD_PRESTADOR = PX.CD_PRESTADOR
            --AND A.TP_ATENDIMENTO = 'E'
            AND IF.CD_PRO_FAT = PF.CD_PRO_FAT
            AND EX.EXA_RX_CD_PRO_FAT = IF.CD_PRO_FAT
            AND S.CD_SETOR = If.CD_SETOR
            -- AND TRUNC(PX.HR_PEDIDO) BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-06-30', 'YYYY-MM-DD')
            -- AND TRUNC(IX.DT_REALIZADO) BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-06-30', 'YYYY-MM-DD')
            AND TRUNC(A.DT_ATENDIMENTO) BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-06-30', 'YYYY-MM-DD')
)
SELECT
    COUNT(COD_PED)
FROM
    EXA_REA
-- WHERE SN_REALIZADO = 'S' AND COD_EXAME = 706   -- 1.650 / 1.648 / 1.650
WHERE COD_ATEND IS NOT NULL AND COD_EXAME = 706   -- 1.686 / 1.648 / 1.686
;


--- ###########################################################################################################################


/*
    QUERY PARA CONTABILIZAR O QUANTITATIVO DE EXAMES
        - VALIDADA COM O RELATÓRIO R_EXAME_PACIENTE
*/
WITH QUANTIDADE_EXAMES
    AS (
        SELECT
            er.CD_EXA_RX,
            er.DS_EXA_RX,
            rx.DT_PEDIDO AS DT_PEDIDO,
            TO_CHAR(rx.DT_PEDIDO, 'MMYYYY') AS MES_ANO,
            COUNT(DISTINCT rx.CD_ATENDIMENTO) AS QTD_ATENDIMENTO,
            COUNT(DISTINCT rx.CD_PED_RX)      AS QTD_EXAMES
        FROM DBAMV.PED_RX rx
        JOIN DBAMV.ITPED_RX irx ON irx.CD_PED_RX = rx.CD_PED_RX
        JOIN DBAMV.EXA_RX er ON irx.CD_EXA_RX = er.CD_EXA_RX
        WHERE TRUNC(rx.HR_PEDIDO) BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-06-30', 'YYYY-MM-DD')
            AND irx.CD_EXA_RX = 706
            AND irx.SN_REALIZADO = 'S'
        GROUP BY er.CD_EXA_RX, er.DS_EXA_RX, rx.DT_PEDIDO, TO_CHAR(rx.DT_PEDIDO, 'MMYYYY')
)
SELECT
    CD_EXA_RX, DS_EXA_RX, DT_PEDIDO, MES_ANO, DADO, QUANTITATIVO
FROM QUANTIDADE_EXAMES
UNPIVOT(
    QUANTITATIVO FOR DADO IN(QTD_ATENDIMENTO, QTD_EXAMES)
)
;


-- CONSULTA NO POWERQUERY
-- let
--     // Converte os parâmetros para texto no formato esperado pela query
--     RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
--     RangeEndText = Date.ToText(RangeEnd, "yyyy-MM-dd"),

--     //RangeStartText = "2025-05-01",
--     //RangeEndText = "2025-05-29",


--     // Sua query SQL com os parâmetros inseridos dinamicamente
--     Query =
--         "WITH QUANTIDADE_EXAMES
--             AS (
--                 SELECT
--                     er.CD_EXA_RX,
--                     er.DS_EXA_RX,
--                     rx.DT_PEDIDO AS DT_PEDIDO,
--                     TO_CHAR(rx.DT_PEDIDO, 'MMYYYY') AS MES_ANO,
--                     COUNT(DISTINCT rx.CD_ATENDIMENTO) AS QTD_ATENDIMENTO,
--                     COUNT(DISTINCT rx.CD_PED_RX)      AS QTD_EXAMES
--                 FROM DBAMV.PED_RX rx
--                 JOIN DBAMV.ITPED_RX irx ON irx.CD_PED_RX = rx.CD_PED_RX
--                 JOIN DBAMV.EXA_RX er ON irx.CD_EXA_RX = er.CD_EXA_RX
--                 WHERE TRUNC(rx.HR_PEDIDO) BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
--                     --AND irx.CD_EXA_RX = 706
--                     AND irx.SN_REALIZADO = 'S'
--                 GROUP BY er.CD_EXA_RX, er.DS_EXA_RX, rx.DT_PEDIDO, TO_CHAR(rx.DT_PEDIDO, 'MMYYYY')
--         )
--         SELECT
--             CD_EXA_RX, DS_EXA_RX, DT_PEDIDO, MES_ANO, QTD_ATENDIMENTO, QTD_EXAMES
--         FROM QUANTIDADE_EXAMES",

-- // Chamada Oracle com a query final montada
-- Fonte = Oracle.Database(
--     "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
--     [Query = Query]
-- )
-- in
--     Fonte


--- ###########################################################################################################################


-- QUANTIDADEDE PACIENTES INTERNADOS
--      - POR MES_ANO
--      - UNIDADE
--      - LEITO
WITH source_atendimento
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            a.DT_ATENDIMENTO,
            TO_CHAR(a.DT_ATENDIMENTO, 'MMYYYY') AS MES_ANO,
            a.HR_ATENDIMENTO,
            a.TP_ATENDIMENTO,
            a.CD_LEITO
        FROM DBAMV.ATENDIME a
        WHERE a.tp_atendimento = 'I'
),
source_leito
    AS (
        SELECT
            CD_LEITO,
            CD_UNID_INT,
            DS_LEITO
        FROM DBAMV.LEITO
),
source_unidade_intercao
    AS (
        SELECT
            CD_UNID_INT,
            DS_UNID_INT
        FROM DBAMV.UNID_INT
),
source_total_por_periodo
    AS (
        SELECT
            sa.MES_ANO,
            sui.CD_UNID_INT,
            sui.DS_UNID_INT,
            sl.CD_LEITO,
            sl.DS_LEITO,
            COUNT(*) AS QTD
        FROM source_atendimento sa
        INNER JOIN source_leito sl
            ON sa.CD_LEITO = sl.CD_LEITO
        LEFT JOIN source_unidade_intercao sui
            ON sl.CD_UNID_INT = sui.CD_UNID_INT
        WHERE
            MES_ANO IN( '012025', '022025', '032025', '042025', '052025')
        GROUP BY sa.MES_ANO, sui.CD_UNID_INT, sui.DS_UNID_INT, sl.CD_LEITO, sl.DS_LEITO
        ORDER BY sa.MES_ANO, sui.CD_UNID_INT, sl.CD_LEITO
),
source_subtotal
    AS (
        SELECT
            MES_ANO,
            CD_UNID_INT,
            DS_UNID_INT,
            CD_LEITO,
            DS_LEITO,
            QTD,
            0
        FROM source_total_por_periodo
        UNION ALL
        SELECT
            'TOTAL GERAL' AS MES_ANO,
            NULL AS CD_UNID_INT,
            NULL AS DS_UNID_INT,
            NULL AS CD_LEITO,
            NULL AS DS_LEITO,
            SUM(QTD),
            1 FROM source_total_por_periodo
)
SELECT
    MES_ANO,
    CD_UNID_INT,
    DS_UNID_INT,
    CD_LEITO,
    DS_LEITO,
    QTD
FROM source_subtotal
ORDER BY
    CASE WHEN MES_ANO = 'TOTAL GERAL' THEN 1 ELSE 0 END ASC
;



--- ###########################################################
--   PACIENTES INTERNADOS NOS ULTIMOS 6 MESES QUE REALIZARAM
--   EXAMES DE IMAGEM NOS ULTIMOS 6 MESES ANTES DA INTERNACAO

--- ###########################################################


WITH pacientes_internados
    AS (
        SELECT DISTINCT
            ai.CD_PACIENTE,
            ai.CD_ATENDIMENTO AS CD_ATENDIMENTO_INTERNACAO,
            ai.DT_ATENDIMENTO AS DT_ATENDIMENTO_INTERNACAO,
            TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') AS MES_ANO_INTERNACAO
        FROM DBAMV.ATENDIME ai
        WHERE ai.TP_ATENDIMENTO = 'I'
          AND ai.DT_ATENDIMENTO BETWEEN ADD_MONTHS(SYSDATE, -6) AND ai.DT_ATENDIMENTO
),
detalhes_consultas_e_exames
    AS (
        SELECT
            pi.CD_PACIENTE,
            aa.TP_ATENDIMENTO,
            pi.MES_ANO_INTERNACAO,
            COUNT(pi.CD_ATENDIMENTO_INTERNACAO) OVER(PARTITION BY pi.MES_ANO_INTERNACAO ) AS QTD_INTERNADOS,
            LAST_DAY(pi.DT_ATENDIMENTO_INTERNACAO) AS DT_COMPETENCIA,
            aa.CD_ATENDIMENTO AS CD_ATENDIMENTO_EXAME_ANTERIOR,
            aa.DT_ATENDIMENTO AS DT_EXAME_ANTERIORL,
            pi.CD_ATENDIMENTO_INTERNACAO,
            pi.DT_ATENDIMENTO_INTERNACAO,
            er.CD_EXA_RX,
            er.DS_EXA_RX,
            rx.CD_PED_RX,
            TRUNC(rx.HR_PEDIDO) AS DT_PEDIDO_EXAME,
            irx.SN_REALIZADO,
            irx.DT_REALIZADO
        FROM pacientes_internados pi
        INNER JOIN DBAMV.ATENDIME aa ON aa.CD_PACIENTE = pi.CD_PACIENTE
        INNER JOIN DBAMV.PED_RX rx ON rx.CD_ATENDIMENTO = aa.CD_ATENDIMENTO
        INNER JOIN DBAMV.ITPED_RX irx ON irx.CD_PED_RX = rx.CD_PED_RX
        INNER JOIN DBAMV.EXA_RX er ON irx.CD_EXA_RX = er.CD_EXA_RX
        WHERE aa.TP_ATENDIMENTO <> 'I'
          AND aa.DT_ATENDIMENTO BETWEEN ADD_MONTHS(pi.DT_ATENDIMENTO_INTERNACAO, -6) AND pi.DT_ATENDIMENTO_INTERNACAO
)
SELECT
    MES_ANO_INTERNACAO,
    DT_COMPETENCIA,
    CD_EXA_RX,
    DS_EXA_RX,
    TP_ATENDIMENTO,
    QTD_INTERNADOS,
    COUNT(DISTINCT CD_PACIENTE) AS QTD_PACIENTES,
    COUNT(DISTINCT CD_PED_RX) AS QTD_PEDIDOS_EXAME,
    COUNT(DISTINCT CASE WHEN SN_REALIZADO = 'S' THEN CD_PED_RX END) AS QTD_EXAMES_REALIZADOS
FROM detalhes_consultas_e_exames
GROUP BY MES_ANO_INTERNACAO, DT_COMPETENCIA, CD_EXA_RX, DS_EXA_RX, TP_ATENDIMENTO, QTD_INTERNADOS
ORDER BY MES_ANO_INTERNACAO, COUNT(DISTINCT CD_PED_RX) DESC , COUNT(DISTINCT CASE WHEN SN_REALIZADO = 'S' THEN CD_PED_RX END) DESC
;

-- let

--     Intervalo_Meses_dos_Internados = Text.From(Intervalo_Meses_dos_Internados),
--     Intervalor_Dias_a_Recuar = Text.From(Intervalor_Dias_a_Recuar),

--     Query =
--         "WITH pacientes_internados
--     AS (
--         SELECT DISTINCT
--             ai.CD_PACIENTE,
--             ai.CD_ATENDIMENTO AS CD_ATENDIMENTO_INTERNACAO,
--             ai.DT_ATENDIMENTO AS DT_ATENDIMENTO_INTERNACAO,
--             TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') AS MES_ANO_INTERNACAO
--         FROM DBAMV.ATENDIME ai
--         WHERE ai.TP_ATENDIMENTO = 'I'
--           AND ai.DT_ATENDIMENTO BETWEEN ADD_MONTHS(SYSDATE, -'" & Intervalo_Meses_dos_Internados & "') AND ai.DT_ATENDIMENTO
-- ),
-- detalhes_consultas_e_exames
--     AS (
--         SELECT
--             pi.CD_PACIENTE,
--             aa.TP_ATENDIMENTO,
--             pi.MES_ANO_INTERNACAO,
--             COUNT(pi.CD_ATENDIMENTO_INTERNACAO) OVER(PARTITION BY pi.MES_ANO_INTERNACAO ) AS QTD_INTERNADOS,
--             LAST_DAY(pi.DT_ATENDIMENTO_INTERNACAO) AS DT_COMPETENCIA,
--             aa.CD_ATENDIMENTO AS CD_ATENDIMENTO_EXAME_ANTERIOR,
--             aa.DT_ATENDIMENTO AS DT_EXAME_ANTERIORL,
--             pi.CD_ATENDIMENTO_INTERNACAO,
--             pi.DT_ATENDIMENTO_INTERNACAO,
--             er.CD_EXA_RX,
--             er.DS_EXA_RX,
--             rx.CD_PED_RX,
--             TRUNC(rx.HR_PEDIDO) AS DT_PEDIDO_EXAME,
--             irx.SN_REALIZADO,
--             irx.DT_REALIZADO
--         FROM pacientes_internados pi
--         INNER JOIN DBAMV.ATENDIME aa ON aa.CD_PACIENTE = pi.CD_PACIENTE
--         INNER JOIN DBAMV.PED_RX rx ON rx.CD_ATENDIMENTO = aa.CD_ATENDIMENTO
--         INNER JOIN DBAMV.ITPED_RX irx ON irx.CD_PED_RX = rx.CD_PED_RX
--         INNER JOIN DBAMV.EXA_RX er ON irx.CD_EXA_RX = er.CD_EXA_RX
--         WHERE aa.TP_ATENDIMENTO <> 'I'
--           AND aa.DT_ATENDIMENTO BETWEEN ADD_MONTHS(pi.DT_ATENDIMENTO_INTERNACAO, -'" & Intervalor_Dias_a_Recuar & "') AND pi.DT_ATENDIMENTO_INTERNACAO
-- )
-- SELECT
--     MES_ANO_INTERNACAO,
--     DT_COMPETENCIA,
--     CD_EXA_RX,
--     DS_EXA_RX,
--     TP_ATENDIMENTO,
--     QTD_INTERNADOS,
--     COUNT(DISTINCT CD_PACIENTE) AS QTD_PACIENTES,
--     COUNT(DISTINCT CD_PED_RX) AS QTD_PEDIDOS_EXAME,
--     COUNT(DISTINCT CASE WHEN SN_REALIZADO = 'S' THEN CD_PED_RX END) AS QTD_EXAMES_REALIZADOS
-- FROM detalhes_consultas_e_exames
-- GROUP BY MES_ANO_INTERNACAO, DT_COMPETENCIA, CD_EXA_RX, DS_EXA_RX, TP_ATENDIMENTO, QTD_INTERNADOS
-- ORDER BY MES_ANO_INTERNACAO, COUNT(DISTINCT CD_PED_RX) DESC , COUNT(DISTINCT CASE WHEN SN_REALIZADO = 'S' THEN CD_PED_RX END) DESC",

-- // Chamada Oracle com a query final montada
-- Fonte = Oracle.Database(
--     "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
--     [Query = Query]
-- )
-- in
--     Fonte
-- ;


--- ###########################################################################################################################



-- VALIDACAO ANGIO TC - OBTER PRESTADOR PARA MICKELY UPFLUX
-- CD_PRESTADOR = 356
SELECT
    CD_PRESTADOR
FROM DBAMV.ITPED_RX
WHERE CD_PED_RX = 310189
;

SELECT
    CD_PED_RX,
    CD_PRESTADOR,
    NM_PRESTADOR,
    NR_CRM_PRESTADOR
FROM DBAMV.PED_RX
WHERE CD_PED_RX = 310189
;

SELECT
    cd_laudo_integra,
    CD_PRESTADOR,
    CD_PRESTADOR2,
    CD_PRESTADOR_REALIZADO_POR_TEC
FROM DBAMV.LAUDO_RX
-- WHERE CD_PRESTADOR_REALIZADO_POR_TEC IS NOT NULL
WHERE CD_PED_RX = 310189
;

SELECT
    NM_PRESTADOR
FROM DBAMV.PRESTADOR
WHERE CD_PRESTADOR = 356
;


SELECT
    *
FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN
WHERE id_exame_pedido = 321211
;


--- ###########################################################################################################################




