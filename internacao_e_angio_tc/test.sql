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

--- ###########################################################################################################################

--- ###########################################################
--   QUANTIDADE DE EXAMES DE IMAGEM DOS ULTIMOS 6 MESES DOS
--   DOS PACIENTES INTERNADOS QUE REALIZARAM EXAMES DE IMAGEM
--   NOS ULTIMOS 6 MESES
--- ###########################################################

WITH CONTEXTO
    AS (
        SELECT DISTINCT
            ai.CD_PACIENTE,
            ai.CD_CONVENIO,
            ai.CD_ATENDIMENTO AS CD_ATENDIMENTO_INTERNACAO,
            ai.DT_ATENDIMENTO AS DT_ATENDIMENTO_INTERNACAO,
            TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') AS MES_ANO_INTERNACAO,
            COUNT(ai.CD_ATENDIMENTO) OVER(PARTITION BY TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') ) AS QTD_INTERNADOS,
            COUNT(ai.CD_ATENDIMENTO) OVER(PARTITION BY TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY'), ai.CD_CONVENIO ) AS QTD_CONVENIO_INTERNADOS
        FROM DBAMV.ATENDIME ai
        WHERE ai.TP_ATENDIMENTO = 'I'
          AND ai.CD_CONVENIO NOT IN(1,2,3,56)
        --   AND ai.DT_ATENDIMENTO BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -6) AND TRUNC(SYSDATE)
)
SELECT * FROM CONTEXTO WHERE MES_ANO_INTERNACAO = '012025'
;




WITH pacientes_internados
    AS (
        SELECT DISTINCT
            ai.CD_PACIENTE,
            ai.CD_ATENDIMENTO AS CD_ATENDIMENTO_INTERNACAO,
            ai.DT_ATENDIMENTO AS DT_ATENDIMENTO_INTERNACAO,
            TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') AS MES_ANO_INTERNACAO,
            COUNT(ai.CD_ATENDIMENTO) OVER(PARTITION BY TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') ) AS QTD_INTERNADOS,
            COUNT(ai.CD_ATENDIMENTO) OVER(PARTITION BY TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY'), ai.CD_CONVENIO ) AS QTD_CONVENIO_INTERNADOS
        FROM DBAMV.ATENDIME ai
        WHERE ai.TP_ATENDIMENTO = 'I'
          AND ai.CD_CONVENIO NOT IN(1,2,3,56) -- REMOVE SUS, PARTICULAR e CORTESIAS
          AND ai.DT_ATENDIMENTO BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -6) AND TRUNC(SYSDATE)
),
detalhes_consultas_e_exames
    AS (
        SELECT
            pi.CD_PACIENTE,
            aa.TP_ATENDIMENTO,
            co.NM_CONVENIO,
            pi.MES_ANO_INTERNACAO,
            LAST_DAY(pi.DT_ATENDIMENTO_INTERNACAO) AS DT_COMPETENCIA,
            pi.QTD_INTERNADOS,
            pi.QTD_CONVENIO_INTERNADOS,
            COUNT(DISTINCT pi.CD_PACIENTE) OVER( PARTITION BY pi.MES_ANO_INTERNACAO ) AS QTD_PACIENTES,
            COUNT(DISTINCT pi.CD_PACIENTE) OVER( PARTITION BY pi.MES_ANO_INTERNACAO, co.NM_CONVENIO ) AS QTD_CONVENIO,
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
        INNER JOIN DBAMV.CONVENIO co ON aa.CD_CONVENIO = co.CD_CONVENIO
        INNER JOIN DBAMV.PED_RX rx ON rx.CD_ATENDIMENTO = aa.CD_ATENDIMENTO
        INNER JOIN DBAMV.ITPED_RX irx ON irx.CD_PED_RX = rx.CD_PED_RX
        INNER JOIN DBAMV.EXA_RX er ON irx.CD_EXA_RX = er.CD_EXA_RX
        WHERE aa.TP_ATENDIMENTO <> 'I'
          AND aa.CD_CONVENIO NOT IN(1,2,3,56)
          AND aa.DT_ATENDIMENTO BETWEEN ADD_MONTHS(pi.DT_ATENDIMENTO_INTERNACAO, -6) AND pi.DT_ATENDIMENTO_INTERNACAO
)
SELECT
    MES_ANO_INTERNACAO,
    DT_COMPETENCIA,
    CD_EXA_RX,
    DS_EXA_RX,
    NM_CONVENIO,
    TP_ATENDIMENTO,
    QTD_INTERNADOS,
    QTD_PACIENTES,
    QTD_CONVENIO_INTERNADOS,
    QTD_CONVENIO,
    COUNT(DISTINCT CD_PED_RX) AS QTD_PEDIDOS_EXAME,
    COUNT(DISTINCT CASE WHEN SN_REALIZADO = 'S' THEN CD_PED_RX END) AS QTD_EXAMES_REALIZADOS
FROM detalhes_consultas_e_exames
WHERE MES_ANO_INTERNACAO = '012025'
GROUP BY MES_ANO_INTERNACAO, DT_COMPETENCIA, CD_EXA_RX, DS_EXA_RX, TP_ATENDIMENTO, QTD_INTERNADOS, QTD_CONVENIO_INTERNADOS, QTD_PACIENTES, NM_CONVENIO, QTD_CONVENIO
ORDER BY MES_ANO_INTERNACAO, COUNT(DISTINCT CD_PED_RX) DESC , COUNT(DISTINCT CASE WHEN SN_REALIZADO = 'S' THEN CD_PED_RX END) DESC
;



let

    Intervalo_Meses_dos_Internados = Text.From(Intervalo_Meses_dos_Internados),
    Intervalor_Dias_a_Recuar = Text.From(Intervalor_Dias_a_Recuar),

    Query =
        "WITH pacientes_internados
    AS (
        SELECT DISTINCT
            ai.CD_PACIENTE,
            ai.CD_ATENDIMENTO AS CD_ATENDIMENTO_INTERNACAO,
            ai.DT_ATENDIMENTO AS DT_ATENDIMENTO_INTERNACAO,
            TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') AS MES_ANO_INTERNACAO,
            COUNT(ai.CD_ATENDIMENTO) OVER(PARTITION BY TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY') ) AS QTD_INTERNADOS,
            COUNT(ai.CD_ATENDIMENTO) OVER(PARTITION BY TO_CHAR(ai.DT_ATENDIMENTO, 'MMYYYY'), ai.CD_CONVENIO ) AS QTD_CONVENIO_INTERNADOS
        FROM DBAMV.ATENDIME ai
        WHERE ai.TP_ATENDIMENTO = 'I'
          AND ai.CD_CONVENIO NOT IN(1,2,3,56)
          AND ai.DT_ATENDIMENTO BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -'" & Intervalo_Meses_dos_Internados & "') AND TRUNC(SYSDATE)
),
detalhes_consultas_e_exames
    AS (
        SELECT
            pi.CD_PACIENTE,
            aa.TP_ATENDIMENTO,
            co.NM_CONVENIO,
            pi.MES_ANO_INTERNACAO,
            LAST_DAY(pi.DT_ATENDIMENTO_INTERNACAO) AS DT_COMPETENCIA,
            pi.QTD_INTERNADOS,
            pi.QTD_CONVENIO_INTERNADOS,
            COUNT(DISTINCT pi.CD_PACIENTE) OVER( PARTITION BY pi.MES_ANO_INTERNACAO ) AS QTD_PACIENTES,
            COUNT(DISTINCT pi.CD_PACIENTE) OVER( PARTITION BY pi.MES_ANO_INTERNACAO, co.NM_CONVENIO ) AS QTD_CONVENIO,
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
        INNER JOIN DBAMV.CONVENIO co ON aa.CD_CONVENIO = co.CD_CONVENIO
        INNER JOIN DBAMV.PED_RX rx ON rx.CD_ATENDIMENTO = aa.CD_ATENDIMENTO
        INNER JOIN DBAMV.ITPED_RX irx ON irx.CD_PED_RX = rx.CD_PED_RX
        INNER JOIN DBAMV.EXA_RX er ON irx.CD_EXA_RX = er.CD_EXA_RX
        WHERE aa.TP_ATENDIMENTO <> 'I'
          AND aa.CD_CONVENIO NOT IN(1,2,3,56)
          AND aa.DT_ATENDIMENTO BETWEEN ADD_MONTHS(pi.DT_ATENDIMENTO_INTERNACAO, -'" & Intervalor_Dias_a_Recuar & "') AND pi.DT_ATENDIMENTO_INTERNACAO
)
SELECT
    MES_ANO_INTERNACAO,
    DT_COMPETENCIA,
    CD_EXA_RX,
    DS_EXA_RX,
    NM_CONVENIO,
    TP_ATENDIMENTO,
    QTD_INTERNADOS,
    QTD_PACIENTES,
    QTD_CONVENIO_INTERNADOS,
    QTD_CONVENIO,
    COUNT(DISTINCT CD_PED_RX) AS QTD_PEDIDOS_EXAME,
    COUNT(DISTINCT CASE WHEN SN_REALIZADO = 'S' THEN CD_PED_RX END) AS QTD_EXAMES_REALIZADOS
FROM detalhes_consultas_e_exames
GROUP BY MES_ANO_INTERNACAO, DT_COMPETENCIA, CD_EXA_RX, DS_EXA_RX, TP_ATENDIMENTO, QTD_INTERNADOS, QTD_CONVENIO_INTERNADOS, QTD_PACIENTES, NM_CONVENIO, QTD_CONVENIO
ORDER BY MES_ANO_INTERNACAO, COUNT(DISTINCT CD_PED_RX) DESC , COUNT(DISTINCT CASE WHEN SN_REALIZADO = 'S' THEN CD_PED_RX END) DESC",

// Chamada Oracle com a query final montada
Fonte = Oracle.Database(
    "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
    [Query = Query]
)
in
    Fonte



--- ###########################################################################################################################



-- VALIDACAO ANGIO TC - OBTER PRESTADOR PARA MICKELY UPFLUX
-- CD_PRESTADOR = 356
SELECT
    CD_PED_RX,
    CD_PRESTADOR,
    NM_PRESTADOR,
    NR_CRM_PRESTADOR
FROM DBAMV.PED_RX
WHERE CD_PED_RX = 310189
;


SELECT
    CD_PRESTADOR
FROM DBAMV.ITPED_RX
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
    *
FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN
WHERE id_exame_pedido = 321211
;


SELECT
    NM_PRESTADOR
FROM DBAMV.PRESTADOR
WHERE CD_PRESTADOR = 356
;


--- ###########################################################################################################################
--- ###########################################################################################################################




SELECT
    CD_PED_RX,
    DT_PEDIDO,
    HR_PEDIDO,
    DT_SOLICITACAO,
    DT_AUTORIZACAO,
    DT_VALIDADE,
    DT_ENTREGA
FROM DBAMV.PED_RX
WHERE CD_PED_RX = 309337
;


SELECT
    CD_ITPED_RX,
    CD_PED_RX,
    CD_EXA_RX,
    CD_LAUDO,
    CD_ITPRE_MED,
    DT_REALIZADO, -- IGUAL A LAUDO_RX.DT_LAUDO
    DT_ENTREGA,
    SN_REALIZADO,
    SN_EXAME_LAUDADO
FROM DBAMV.ITPED_RX
WHERE CD_PED_RX = 309337  -- RESULTADO 320350 E 320351
;


SELECT
    CD_LAUDO,
    CD_LAUDO_INTEGRA,
    CD_PED_RX,
    DT_LAUDO,
    HR_LAUDO,
    DT_INTEGRA
FROM DBAMV.LAUDO_RX
-- WHERE CD_LAUDO IN( 320350, 320351)         --SEM RESULTADO
-- WHERE CD_LAUDO_INTEGRA IN( 320350, 320351) --RETORNA APENAS 320350
-- WHERE CD_PED_RX = 309337                   --RETORNA APENAS 320350
;

-- AQUI
SELECT
    idc.CD_PEDIDO_HIS,
    idc.CD_ATENDIMENTO_HIS,
    idc.CD_EXAME_HIS,
    idc.ID_EXAME_PEDIDO, -- CD_LAUDO
    idc.ID_PEDIDO_EXAME, -- CD_LAUDO
    idc.ID_EXAME,
    idc.NM_EXAME,
    idc.DT_PEDIDO,
    idc.DT_CADASTRO,     -- IGUAL DT_PEDIDO
    idc.DT_STUDY,        -- INTEGRACAO MV/VIVACE


    -- CADASTRO MANUAL NA MÁQUINA FORA DO WORKLIST (CADASTRO DO PACIENTE A PARTIR DA SOLICITACAO)
    -- NAO FAZER O EXAME NO MESMO LOCAL ONDE A MAQUINA ESTÁ
    -- EXCLUSAO DA IMAGEM POR ERROR (YAGO OU PEDRO)

    FIRST_VALUE( idc.DT_STUDY ) OVER( PARTITION BY idc.CD_ATENDIMENTO_HIS, TRUNC(idc.DT_PEDIDO), idc.ID_MEDICO ORDER BY idc.DT_PEDIDO ) AS NEW_DT_STUDY, -- RESOLVE DT_STUDY "NULL"
    idc.DT_LAUDADO,
    idc.DT_ALTERACAO,

    idc.SN_ATRASADO,

    idc.CD_STATUS,

    idc.ID_MEDICO,
    idc.NM_MEDICO_SOLICITANTE,

    idc.CD_HIS_EXECUTANTE,
    idc.NM_MEDICO_EXECUTANTE,

    idc.ID_MEDICO_REVISOR,
    idc.NM_MEDICO_REVISOR,

    idc.ID_MEDICO_REVISOR_FINAL,
    idc.NM_MEDICO_REVISOR_FINAL,

    idc.ID_MEDICO_DITADO,
    idc.ID_MEDICO_DITADO,

    idc.SN_EXECUTANTE_REVISOR,
    idc.DS_LAUDO_TXT
FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN idc
WHERE
    idc.DT_PEDIDO BETWEEN ADD_MONTHS(TRUNC(SYSDATE), -1) AND TRUNC(SYSDATE)
    AND idc.CD_STATUS IN('I', 'U')
    -- AND idc.ID_CONVENIO NOT IN(1,2,3,56)
    -- AND ( idc.DT_STUDY IS NULL AND idc.DT_LAUDADO IS NULL AND idc.ID_MEDICO_REVISOR_FINAL IS NULL AND idc.ID_MEDICO_REVISOR IS NULL )
    -- AND idc.CD_PEDIDO_HIS = 311804
    AND idc.DT_LAUDADO < idc.DT_STUDY
    -- AND idc.DS_LAUDO_TXT IS NOT NULL
    -- AND DT_LAUDADO IS NULL
    -- AND idc.DT_STUDY IS NULL
    -- AND idc.CD_STUDY_UID IS NULL
    -- AND idc.CD_ATENDIMENTO_HIS = 226696
    AND idc.CD_HIS_EXECUTANTE = 277
ORDER BY CD_ATENDIMENTO_HIS DESC
;



-- DT_LAUDADO < DT_STUDY
SELECT
    *
FROM IDCE.RS_LAU_EXAME_PEDIDO
WHERE DT_LAUDADO < DT_STUDY
;



WITH main
    AS (
        SELECT
            idc.CD_PEDIDO_HIS,
            idc.CD_ATENDIMENTO_HIS,
            idc.CD_HIS_EXECUTANTE,
            idc.NM_MEDICO_EXECUTANTE,
            idc.ID_EXAME,
            idc.ID_EXAME_PEDIDO, -- CD_LAUDO
            idc.ID_PEDIDO_EXAME, -- CD_LAUDO
            idc.NM_PACIENTE,
            idc.NM_EXAME,
            idc.DT_PEDIDO,
            idc.DT_STUDY,
            idc.CD_STATUS,
            COALESCE(idc.DT_LAUDADO, lr.DT_LAUDO) AS DT_LAUDADO,
            idc.DT_ENTREGA
        FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN idc
        INNER JOIN DBAMV.PED_RX pr
            ON idc.CD_PEDIDO_HIS = pr.CD_PED_RX
        INNER JOIN DBAMV.LAUDO_RX lr
            ON idc.ID_EXAME_PEDIDO = lr.CD_LAUDO_INTEGRA
        WHERE idc.DT_PEDIDO BETWEEN ADD_MONTHS(TRUNC(SYSDATE), -1) AND TRUNC(SYSDATE)
          AND idc.CD_STATUS <> 'I'
          AND idc.DS_LAUDO_TXT IS NOT NULL
        ORDER BY idc.CD_ATENDIMENTO_HIS
),
source_duplicados_dt_study
    AS (
        SELECT
            idc.CD_PEDIDO_HIS,
            idc.ID_EXAME,
            idc.DT_STUDY,
            ROW_NUMBER() OVER (
                PARTITION BY idc.CD_PEDIDO_HIS, idc.ID_EXAME
                ORDER BY
                    CASE WHEN idc.DT_STUDY IS NOT NULL THEN 0 ELSE 1 END,
                    idc.DT_STUDY DESC
            ) AS rn
        FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN idc
        WHERE idc.DT_PEDIDO BETWEEN ADD_MONTHS(TRUNC(SYSDATE), -1) AND TRUNC(SYSDATE)
          AND idc.CD_STATUS <> 'I'
),
source_filtro
    AS (
        SELECT
            CD_PEDIDO_HIS,
            ID_EXAME,
            DT_STUDY
        FROM source_duplicados_dt_study
        WHERE rn = 1
),
treats
    AS (
        SELECT
            m.CD_PEDIDO_HIS,
            m.CD_ATENDIMENTO_HIS,
            m.ID_EXAME_PEDIDO, -- CD_LAUDO
            m.ID_PEDIDO_EXAME, -- CD_LAUDO
            m.CD_HIS_EXECUTANTE,
            m.NM_MEDICO_EXECUTANTE,
            m.CD_STATUS,
            m.NM_PACIENTE,
            m.NM_EXAME,
            m.DT_PEDIDO,
            sf.DT_STUDY,
            m.DT_LAUDADO,
            m.DT_ENTREGA,
        -- TEMPO - SOLICITACAO ATE REALIZACAO
        -- CONSIDERAR HR_PRE_MED - DT_PEDIDO
        --    - TP_ATENDIMENTO = 'U' -> PEDIDO É GERADO AUTOMATICAMENTE
        --        - VE A TP_ATENDIMENTO = 'A' NAS ÚLTIMAS 48H
        --    - TP_ATENDIMENTO = 'E' -> PEDIDO É GERADO AUTOMATICAMENTE
        --        - VE A TP_ATENDIMENTO = 'A' NOS ÚLTIMAS 30DIAS ANTERIORES AO AGENDAMENTO
          TO_CHAR(NUMTODSINTERVAL(sf.DT_STUDY - m.DT_PEDIDO, 'DAY'), 'HH24:MI:SS') AS INTERVALO,
          TRUNC(sf.DT_STUDY - m.DT_PEDIDO) || ' dias ' || TO_CHAR(NUMTODSINTERVAL(sf.DT_STUDY - m.DT_PEDIDO, 'DAY'), 'HH24:MI:SS') AS INTERVALO_LEGIVEL,
          (sf.DT_STUDY - m.DT_PEDIDO) * 24 AS HORAS_PEDIDO_REALIZACAO,

        -- TEMPO - REALIZACAO ATE LAUDO
          (m.DT_LAUDADO - sf.DT_STUDY) * 24 AS HORAS_REALIZACAO_LAUDO,

        -- TEMPO - LAUDO ATE CONDUTA (ENTREGA)
          (m.DT_ENTREGA - m.DT_LAUDADO) * 24 AS HORAS_LAUDO_CONDUTA,

        -- TEMPO TOTAL - PEDIDO ATE ENTREGA
          (COALESCE(m.DT_ENTREGA, m.DT_LAUDADO) - m.DT_PEDIDO) * 24 AS HORAS_TOTAL_FLUXO
        FROM main m
        INNER JOIN source_filtro sf
            ON m.CD_PEDIDO_HIS = sf.CD_PEDIDO_HIS AND m.ID_EXAME = sf.ID_EXAME
)
SELECT * FROM treats --WHERE CD_PEDIDO_HIS = 309337
;


-- let

--     Intervalo_Meses_dos_Internados = Text.From(Intervalo_Meses_dos_Internados),
--     Intervalor_Dias_a_Recuar = Text.From(Intervalor_Dias_a_Recuar),

--     Query =
--         "WITH main
--     AS (
--         SELECT
--             idc.CD_PEDIDO_HIS,
--             idc.CD_ATENDIMENTO_HIS,
--             idc.CD_HIS_EXECUTANTE,
--             idc.NM_MEDICO_EXECUTANTE,
--             idc.ID_EXAME,
--             idc.ID_EXAME_PEDIDO, -- CD_LAUDO
--             idc.ID_PEDIDO_EXAME, -- CD_LAUDO
--             idc.NM_PACIENTE,
--             idc.NM_EXAME,
--             idc.DT_PEDIDO,
--             idc.DT_STUDY,
--             idc.CD_STATUS,
--             COALESCE(idc.DT_LAUDADO, lr.DT_LAUDO) AS DT_LAUDADO,
--             idc.DT_ENTREGA
--         FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN idc
--         INNER JOIN DBAMV.PED_RX pr
--             ON idc.CD_PEDIDO_HIS = pr.CD_PED_RX
--         INNER JOIN DBAMV.LAUDO_RX lr
--             ON idc.ID_EXAME_PEDIDO = lr.CD_LAUDO_INTEGRA
--         WHERE idc.DT_PEDIDO BETWEEN ADD_MONTHS(TRUNC(SYSDATE), -1) AND TRUNC(SYSDATE)
--           AND idc.CD_STATUS <> 'I'
--           AND idc.DS_LAUDO_TXT IS NOT NULL
--         ORDER BY idc.CD_ATENDIMENTO_HIS
-- ),
-- source_duplicados_dt_study
--     AS (
--         SELECT
--             idc.CD_PEDIDO_HIS,
--             idc.ID_EXAME,
--             idc.DT_STUDY,
--             ROW_NUMBER() OVER (
--                 PARTITION BY idc.CD_PEDIDO_HIS, idc.ID_EXAME
--                 ORDER BY
--                     CASE WHEN idc.DT_STUDY IS NOT NULL THEN 0 ELSE 1 END,
--                     idc.DT_STUDY DESC
--             ) AS rn
--         FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN idc
--         WHERE idc.DT_PEDIDO BETWEEN ADD_MONTHS(TRUNC(SYSDATE), -1) AND TRUNC(SYSDATE)
--           AND idc.CD_STATUS <> 'I'
-- ),
-- source_filtro
--     AS (
--         SELECT
--             CD_PEDIDO_HIS,
--             ID_EXAME,
--             DT_STUDY
--         FROM source_duplicados_dt_study
--         WHERE rn = 1
-- ),
-- treats
--     AS (
--         SELECT
--             m.CD_PEDIDO_HIS,
--             m.CD_ATENDIMENTO_HIS,
--             m.ID_EXAME_PEDIDO, -- CD_LAUDO
--             m.ID_PEDIDO_EXAME, -- CD_LAUDO
--             m.CD_HIS_EXECUTANTE,
--             m.NM_MEDICO_EXECUTANTE,
--             m.CD_STATUS,
--             m.NM_PACIENTE,
--             m.NM_EXAME,
--             m.DT_PEDIDO,
--             sf.DT_STUDY,
--             m.DT_LAUDADO,
--             m.DT_ENTREGA,
--         -- TEMPO - SOLICITACAO ATE REALIZACAO
--         -- CONSIDERAR HR_PRE_MED - DT_PEDIDO
--         --    - TP_ATENDIMENTO = 'U' -> PEDIDO É GERADO AUTOMATICAMENTE
--         --        - VE A TP_ATENDIMENTO = 'A' NAS ÚLTIMAS 48H
--         --    - TP_ATENDIMENTO = 'E' -> PEDIDO É GERADO AUTOMATICAMENTE
--         --        - VE A TP_ATENDIMENTO = 'A' NOS ÚLTIMAS 30DIAS ANTERIORES AO AGENDAMENTO
--           (sf.DT_STUDY - m.DT_PEDIDO) * 24 AS HORAS_PEDIDO_REALIZACAO,

--         -- TEMPO - REALIZACAO ATE LAUDO
--           (m.DT_LAUDADO - sf.DT_STUDY) * 24 AS HORAS_REALIZACAO_LAUDO,

--         -- TEMPO - LAUDO ATE CONDUTA (ENTREGA)
--           (m.DT_ENTREGA - m.DT_LAUDADO) * 24 AS HORAS_LAUDO_CONDUTA,

--         -- TEMPO TOTAL - PEDIDO ATE ENTREGA
--           (COALESCE(m.DT_ENTREGA, m.DT_LAUDADO) - m.DT_PEDIDO) * 24 AS HORAS_TOTAL_FLUXO
--         FROM main m
--         INNER JOIN source_filtro sf
--             ON m.CD_PEDIDO_HIS = sf.CD_PEDIDO_HIS AND m.ID_EXAME = sf.ID_EXAME
-- )
-- SELECT * FROM treats",

-- // Chamada Oracle com a query final montada
-- Fonte = Oracle.Database(
--     "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
--     [Query = Query]
-- )
-- in
--     Fonte



/*
  * ****************************** RESULTADO UNPIVOT ******************************
*/
WITH main
    AS (
        SELECT
            idc.CD_PEDIDO_HIS,
            idc.CD_ATENDIMENTO_HIS,
            idc.CD_HIS_EXECUTANTE,
            idc.NM_MEDICO_EXECUTANTE,
            idc.ID_EXAME,
            idc.ID_EXAME_PEDIDO,
            idc.ID_PEDIDO_EXAME,
            idc.NM_PACIENTE,
            idc.NM_EXAME,
            idc.DT_PEDIDO,
            idc.DT_STUDY,
            idc.CD_STATUS,
            COALESCE(idc.DT_LAUDADO, lr.DT_LAUDO) AS DT_LAUDADO,
            idc.DT_ENTREGA
        FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN idc
        INNER JOIN DBAMV.PED_RX pr
            ON idc.CD_PEDIDO_HIS = pr.CD_PED_RX
        INNER JOIN DBAMV.LAUDO_RX lr
            ON idc.ID_EXAME_PEDIDO = lr.CD_LAUDO_INTEGRA
        WHERE idc.DT_PEDIDO BETWEEN ADD_MONTHS(TRUNC(SYSDATE), -1) AND TRUNC(SYSDATE)
          AND idc.CD_STATUS IN('I', 'U')
          AND idc.DS_LAUDO_TXT IS NOT NULL
        ORDER BY idc.CD_ATENDIMENTO_HIS
),
source_duplicados_dt_study
    AS (
        SELECT
            idc.CD_PEDIDO_HIS,
            idc.ID_EXAME,
            idc.DT_STUDY,
            ROW_NUMBER() OVER (
                PARTITION BY idc.CD_PEDIDO_HIS, idc.ID_EXAME
                ORDER BY
                    CASE WHEN idc.DT_STUDY IS NOT NULL THEN 0 ELSE 1 END,
                    idc.DT_STUDY DESC
            ) AS rn
        FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN idc
        WHERE idc.DT_PEDIDO BETWEEN ADD_MONTHS(TRUNC(SYSDATE), -1) AND TRUNC(SYSDATE)
          AND idc.CD_STATUS IN('I', 'U')
),
source_filtro
    AS (
        SELECT
            CD_PEDIDO_HIS,
            ID_EXAME,
            DT_STUDY
        FROM source_duplicados_dt_study
        WHERE rn = 1
),
treats
    AS (
        SELECT
            m.CD_PEDIDO_HIS,
            m.CD_ATENDIMENTO_HIS,
            m.ID_EXAME_PEDIDO,
            m.ID_PEDIDO_EXAME,
            m.CD_HIS_EXECUTANTE,
            m.NM_MEDICO_EXECUTANTE,
            m.CD_STATUS,
            m.NM_PACIENTE,
            m.NM_EXAME,
            m.DT_PEDIDO,
            TO_CHAR(m.DT_PEDIDO, 'MMYYYY') AS MES_ANO,
            sf.DT_STUDY,
            m.DT_LAUDADO,
            m.DT_ENTREGA,
        -- TEMPO - PEDIDO ATE REALIZACAO
          (sf.DT_STUDY - m.DT_PEDIDO) * 24 AS HORAS_PEDIDO_REALIZACAO,

        -- TEMPO - REALIZACAO ATE LAUDO
          (m.DT_LAUDADO - sf.DT_STUDY) * 24 AS HORAS_REALIZACAO_LAUDO,

        -- TEMPO - LAUDO ATE CONDUTA (ENTREGA)
          (m.DT_ENTREGA - m.DT_LAUDADO) * 24 AS HORAS_LAUDO_CONDUTA,

        -- TEMPO TOTAL - PEDIDO ATE ENTREGA
          (COALESCE(m.DT_ENTREGA, m.DT_LAUDADO) - m.DT_PEDIDO) * 24 AS HORAS_TOTAL_FLUXO
        FROM main m
        INNER JOIN source_filtro sf
            ON m.CD_PEDIDO_HIS = sf.CD_PEDIDO_HIS AND m.ID_EXAME = sf.ID_EXAME
),
agg_por_tempo_medico_exame
    AS (
        SELECT
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,


            CASE
                WHEN HORAS_PEDIDO_REALIZACAO < 1 THEN '< 1 hora'
                WHEN HORAS_PEDIDO_REALIZACAO < 2 THEN '1-2 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 4 THEN '2-4 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 8 THEN '4-8 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 12 THEN '8-12 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 24 THEN '12-24 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 48 THEN '1-2 dias'
                WHEN HORAS_PEDIDO_REALIZACAO < 72 THEN '2-3 dias'
                WHEN HORAS_PEDIDO_REALIZACAO < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END AS FAIXA_TEMPO_PEDIDO_REALIZACAO,

            CASE
                WHEN HORAS_REALIZACAO_LAUDO < 1 THEN '< 1 hora'
                WHEN HORAS_REALIZACAO_LAUDO < 2 THEN '1-2 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 4 THEN '2-4 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 8 THEN '4-8 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 12 THEN '8-12 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 24 THEN '12-24 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 48 THEN '1-2 dias'
                WHEN HORAS_REALIZACAO_LAUDO < 72 THEN '2-3 dias'
                WHEN HORAS_REALIZACAO_LAUDO < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END AS FAIXA_TEMPO_REALIZACAO_LAUDO,

            CASE
                WHEN HORAS_LAUDO_CONDUTA < 1 THEN '< 1 hora'
                WHEN HORAS_LAUDO_CONDUTA < 2 THEN '1-2 horas'
                WHEN HORAS_LAUDO_CONDUTA < 4 THEN '2-4 horas'
                WHEN HORAS_LAUDO_CONDUTA < 8 THEN '4-8 horas'
                WHEN HORAS_LAUDO_CONDUTA < 12 THEN '8-12 horas'
                WHEN HORAS_LAUDO_CONDUTA < 24 THEN '12-24 horas'
                WHEN HORAS_LAUDO_CONDUTA < 48 THEN '1-2 dias'
                WHEN HORAS_LAUDO_CONDUTA < 72 THEN '2-3 dias'
                WHEN HORAS_LAUDO_CONDUTA < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END AS FAIXA_TEMPO_LAUDO_CONDUTA,

            COUNT(*) AS QTD_EXAMES
            -- ROUND(AVG(HORAS_PEDIDO_REALIZACAO), 2) AS MEDIA_HORAS_PEDIDO_REALIZACAO,
            -- ROUND(MIN(HORAS_PEDIDO_REALIZACAO), 2) AS MIN_HORAS_PEDIDO_REALIZACAO,
            -- ROUND(MAX(HORAS_PEDIDO_REALIZACAO), 2) AS MAX_HORAS_PEDIDO_REALIZACAO
        FROM treats
        WHERE HORAS_PEDIDO_REALIZACAO IS NOT NULL
        GROUP BY
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,

            CASE
                WHEN HORAS_PEDIDO_REALIZACAO < 1 THEN '< 1 hora'
                WHEN HORAS_PEDIDO_REALIZACAO < 2 THEN '1-2 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 4 THEN '2-4 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 8 THEN '4-8 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 12 THEN '8-12 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 24 THEN '12-24 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 48 THEN '1-2 dias'
                WHEN HORAS_PEDIDO_REALIZACAO < 72 THEN '2-3 dias'
                WHEN HORAS_PEDIDO_REALIZACAO < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END,

            CASE
                WHEN HORAS_REALIZACAO_LAUDO < 1 THEN '< 1 hora'
                WHEN HORAS_REALIZACAO_LAUDO < 2 THEN '1-2 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 4 THEN '2-4 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 8 THEN '4-8 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 12 THEN '8-12 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 24 THEN '12-24 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 48 THEN '1-2 dias'
                WHEN HORAS_REALIZACAO_LAUDO < 72 THEN '2-3 dias'
                WHEN HORAS_REALIZACAO_LAUDO < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END,

            CASE
                WHEN HORAS_LAUDO_CONDUTA < 1 THEN '< 1 hora'
                WHEN HORAS_LAUDO_CONDUTA < 2 THEN '1-2 horas'
                WHEN HORAS_LAUDO_CONDUTA < 4 THEN '2-4 horas'
                WHEN HORAS_LAUDO_CONDUTA < 8 THEN '4-8 horas'
                WHEN HORAS_LAUDO_CONDUTA < 12 THEN '8-12 horas'
                WHEN HORAS_LAUDO_CONDUTA < 24 THEN '12-24 horas'
                WHEN HORAS_LAUDO_CONDUTA < 48 THEN '1-2 dias'
                WHEN HORAS_LAUDO_CONDUTA < 72 THEN '2-3 dias'
                WHEN HORAS_LAUDO_CONDUTA < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END
),
resultado_unpivot
    AS (
        SELECT
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,
            'PEDIDO_REALIZACAO' AS FAIXA,
            1 AS ORDEM_FAIXA,
            FAIXA_TEMPO_PEDIDO_REALIZACAO AS FAIXA_TEMPO,
            QTD_EXAMES
        FROM agg_por_tempo_medico_exame
        WHERE FAIXA_TEMPO_PEDIDO_REALIZACAO IS NOT NULL

        UNION ALL

        SELECT
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,
            'REALIZACAO_LAUDO' AS FAIXA,
            2 AS ORDEM_FAIXA,
            FAIXA_TEMPO_REALIZACAO_LAUDO AS FAIXA_TEMPO,
            QTD_EXAMES
        FROM agg_por_tempo_medico_exame
        WHERE FAIXA_TEMPO_REALIZACAO_LAUDO IS NOT NULL

        UNION ALL

        SELECT
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,
            'LAUDO_CONDUTA' AS FAIXA,
            3 AS ORDEM_FAIXA,
            FAIXA_TEMPO_LAUDO_CONDUTA AS FAIXA_TEMPO,
            QTD_EXAMES
        FROM agg_por_tempo_medico_exame
        WHERE FAIXA_TEMPO_LAUDO_CONDUTA IS NOT NULL
)
SELECT
    *
FROM (
        SELECT
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,
            FAIXA,
            ORDEM_FAIXA,
            FAIXA_TEMPO,
            QTD_EXAMES
        FROM resultado_unpivot
)
PIVOT (
    SUM(QTD_EXAMES)
    FOR FAIXA_TEMPO IN (
        '< 1 hora' AS ATE_1H,
        '1-2 horas' AS ENTRE_1_2H,
        '2-4 horas' AS ENTRE_2_4H,
        '4-8 horas' AS ENTRE_4_8H,
        '8-12 horas' AS ENTRE_8_12H,
        '12-24 horas' AS ENTRE_12_24H,
        '1-2 dias' AS ENTRE_1_2D,
        '2-3 dias' AS ENTRE_2_3D,
        '3-7 dias' AS ENTRE_3_7D,
        '> 7 dias' AS MAIS_7D
    )
)
ORDER BY
    MES_ANO,
    CD_HIS_EXECUTANTE,
    NM_MEDICO_EXECUTANTE,
    NM_EXAME,
    CD_STATUS,
    ORDEM_FAIXA
;






-- QUERY FINAL P/ PAINEL
-- TEMPOS PEDIDOS - REALIZACAO - LAUDO - CONDUTA
WITH main
    AS (
        SELECT
            idc.CD_PEDIDO_HIS,
            idc.CD_ATENDIMENTO_HIS,
            idc.CD_HIS_EXECUTANTE,
            idc.NM_MEDICO_EXECUTANTE,
            idc.ID_EXAME,
            idc.ID_EXAME_PEDIDO,
            idc.ID_PEDIDO_EXAME,
            idc.NM_PACIENTE,
            idc.NM_EXAME,
            idc.DT_PEDIDO,
            FIRST_VALUE( idc.DT_STUDY ) OVER( PARTITION BY idc.CD_ATENDIMENTO_HIS, TRUNC(idc.DT_PEDIDO), idc.ID_MEDICO ORDER BY idc.DT_PEDIDO ) AS DT_STUDY,
            -- idc.DT_STUDY,
            idc.CD_STATUS,
            idc.DT_LAUDADO,
            -- COALESCE(idc.DT_LAUDADO, lr.DT_LAUDO) AS DT_LAUDADO,
            idc.DT_ENTREGA
        FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN idc
        -- INNER JOIN DBAMV.PED_RX pr
        --     ON idc.CD_PEDIDO_HIS = pr.CD_PED_RX
        -- INNER JOIN DBAMV.LAUDO_RX lr
        --     ON idc.ID_EXAME_PEDIDO = lr.CD_LAUDO_INTEGRA
        WHERE idc.DT_PEDIDO BETWEEN ADD_MONTHS(TRUNC(SYSDATE), -2) AND TRUNC(SYSDATE)
          AND idc.CD_STATUS IN('I', 'U', 'E')
          AND idc.DS_LAUDO_TXT IS NOT NULL
          AND idc.CD_HIS_EXECUTANTE IS NOT NULL
        --   AND idc.CD_ATENDIMENTO_HIS = 229694
        ORDER BY idc.CD_ATENDIMENTO_HIS
),
source_duplicados_dt_study
    AS (
        SELECT
            idc.CD_PEDIDO_HIS,
            idc.ID_EXAME,
            idc.DT_STUDY,
            ROW_NUMBER() OVER (
                PARTITION BY idc.CD_PEDIDO_HIS, idc.ID_EXAME
                ORDER BY
                    CASE WHEN idc.DT_STUDY IS NOT NULL THEN 0 ELSE 1 END,
                    idc.DT_STUDY DESC
            ) AS rn
        FROM IDCE.EXAME_PEDIDO_MULTI_LOGIN idc
        WHERE idc.DT_PEDIDO BETWEEN ADD_MONTHS(TRUNC(SYSDATE), -2) AND TRUNC(SYSDATE)
          AND idc.CD_STATUS IN('I', 'U', 'E')
        --   AND idc.CD_ATENDIMENTO_HIS = 229694
),
source_filtro
    AS (
        SELECT
            CD_PEDIDO_HIS,
            ID_EXAME,
            DT_STUDY
        FROM source_duplicados_dt_study
        WHERE rn = 1
),
treats
    AS (
        SELECT
            m.CD_PEDIDO_HIS,
            m.CD_ATENDIMENTO_HIS,
            m.ID_EXAME_PEDIDO,
            m.ID_PEDIDO_EXAME,
            m.CD_HIS_EXECUTANTE,
            m.NM_MEDICO_EXECUTANTE,
            m.CD_STATUS,
            m.NM_PACIENTE,
            m.NM_EXAME,
            m.DT_PEDIDO,
            TO_CHAR(m.DT_PEDIDO, 'MMYYYY') AS MES_ANO,
            m.DT_STUDY,
            m.DT_LAUDADO,
            m.DT_ENTREGA,
        -- TEMPO - PEDIDO ATE REALIZACAO
          (m.DT_STUDY - m.DT_PEDIDO) * 24 AS HORAS_PEDIDO_REALIZACAO,

        -- TEMPO - REALIZACAO ATE LAUDO
          (m.DT_LAUDADO - m.DT_STUDY) * 24 AS HORAS_REALIZACAO_LAUDO,

        -- TEMPO - LAUDO ATE CONDUTA (ENTREGA)
          (m.DT_ENTREGA - m.DT_LAUDADO) * 24 AS HORAS_LAUDO_CONDUTA,

        -- TEMPO TOTAL - PEDIDO ATE ENTREGA
          (COALESCE(m.DT_ENTREGA, m.DT_LAUDADO) - m.DT_PEDIDO) * 24 AS HORAS_TOTAL_FLUXO
        FROM main m
        INNER JOIN source_filtro sf
            ON m.CD_PEDIDO_HIS = sf.CD_PEDIDO_HIS AND m.ID_EXAME = sf.ID_EXAME
),
agg_por_tempo_medico_exame
    AS (
        SELECT
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,

            CASE
                WHEN HORAS_PEDIDO_REALIZACAO < 1 THEN '< 1 hora'
                WHEN HORAS_PEDIDO_REALIZACAO < 2 THEN '1-2 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 4 THEN '2-4 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 8 THEN '4-8 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 12 THEN '8-12 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 24 THEN '12-24 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 48 THEN '1-2 dias'
                WHEN HORAS_PEDIDO_REALIZACAO < 72 THEN '2-3 dias'
                WHEN HORAS_PEDIDO_REALIZACAO < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END AS FAIXA_TEMPO_PEDIDO_REALIZACAO,

            CASE
                WHEN HORAS_REALIZACAO_LAUDO < 1 THEN '< 1 hora'
                WHEN HORAS_REALIZACAO_LAUDO < 2 THEN '1-2 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 4 THEN '2-4 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 8 THEN '4-8 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 12 THEN '8-12 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 24 THEN '12-24 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 48 THEN '1-2 dias'
                WHEN HORAS_REALIZACAO_LAUDO < 72 THEN '2-3 dias'
                WHEN HORAS_REALIZACAO_LAUDO < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END AS FAIXA_TEMPO_REALIZACAO_LAUDO,

            CASE
                WHEN HORAS_LAUDO_CONDUTA < 1 THEN '< 1 hora'
                WHEN HORAS_LAUDO_CONDUTA < 2 THEN '1-2 horas'
                WHEN HORAS_LAUDO_CONDUTA < 4 THEN '2-4 horas'
                WHEN HORAS_LAUDO_CONDUTA < 8 THEN '4-8 horas'
                WHEN HORAS_LAUDO_CONDUTA < 12 THEN '8-12 horas'
                WHEN HORAS_LAUDO_CONDUTA < 24 THEN '12-24 horas'
                WHEN HORAS_LAUDO_CONDUTA < 48 THEN '1-2 dias'
                WHEN HORAS_LAUDO_CONDUTA < 72 THEN '2-3 dias'
                WHEN HORAS_LAUDO_CONDUTA < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END AS FAIXA_TEMPO_LAUDO_CONDUTA,

            COUNT(*) AS QTD_EXAMES
        FROM treats
        WHERE HORAS_PEDIDO_REALIZACAO IS NOT NULL
        GROUP BY
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,

            CASE
                WHEN HORAS_PEDIDO_REALIZACAO < 1 THEN '< 1 hora'
                WHEN HORAS_PEDIDO_REALIZACAO < 2 THEN '1-2 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 4 THEN '2-4 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 8 THEN '4-8 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 12 THEN '8-12 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 24 THEN '12-24 horas'
                WHEN HORAS_PEDIDO_REALIZACAO < 48 THEN '1-2 dias'
                WHEN HORAS_PEDIDO_REALIZACAO < 72 THEN '2-3 dias'
                WHEN HORAS_PEDIDO_REALIZACAO < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END,

            CASE
                WHEN HORAS_REALIZACAO_LAUDO < 1 THEN '< 1 hora'
                WHEN HORAS_REALIZACAO_LAUDO < 2 THEN '1-2 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 4 THEN '2-4 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 8 THEN '4-8 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 12 THEN '8-12 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 24 THEN '12-24 horas'
                WHEN HORAS_REALIZACAO_LAUDO < 48 THEN '1-2 dias'
                WHEN HORAS_REALIZACAO_LAUDO < 72 THEN '2-3 dias'
                WHEN HORAS_REALIZACAO_LAUDO < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END,

            CASE
                WHEN HORAS_LAUDO_CONDUTA < 1 THEN '< 1 hora'
                WHEN HORAS_LAUDO_CONDUTA < 2 THEN '1-2 horas'
                WHEN HORAS_LAUDO_CONDUTA < 4 THEN '2-4 horas'
                WHEN HORAS_LAUDO_CONDUTA < 8 THEN '4-8 horas'
                WHEN HORAS_LAUDO_CONDUTA < 12 THEN '8-12 horas'
                WHEN HORAS_LAUDO_CONDUTA < 24 THEN '12-24 horas'
                WHEN HORAS_LAUDO_CONDUTA < 48 THEN '1-2 dias'
                WHEN HORAS_LAUDO_CONDUTA < 72 THEN '2-3 dias'
                WHEN HORAS_LAUDO_CONDUTA < 168 THEN '3-7 dias'
                ELSE '> 7 dias'
            END
),
resultado_unpivot
    AS (
        SELECT
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,
            'PEDIDO_REALIZACAO' AS FAIXA,
            FAIXA_TEMPO_PEDIDO_REALIZACAO AS TEMPO,
            1 AS ORDEM_FAIXA,
            FAIXA_TEMPO_PEDIDO_REALIZACAO AS FAIXA_TEMPO,
            QTD_EXAMES
        FROM agg_por_tempo_medico_exame
        WHERE FAIXA_TEMPO_PEDIDO_REALIZACAO IS NOT NULL

        UNION ALL

        SELECT
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,
            'REALIZACAO_LAUDO' AS FAIXA,
            FAIXA_TEMPO_REALIZACAO_LAUDO AS TEMPO,
            2 AS ORDEM_FAIXA,
            FAIXA_TEMPO_REALIZACAO_LAUDO AS FAIXA_TEMPO,
            QTD_EXAMES
        FROM agg_por_tempo_medico_exame
        WHERE FAIXA_TEMPO_REALIZACAO_LAUDO IS NOT NULL

        UNION ALL

        SELECT
            CD_HIS_EXECUTANTE,
            NM_MEDICO_EXECUTANTE,
            NM_EXAME,
            CD_STATUS,
            MES_ANO,
            'LAUDO_CONDUTA' AS FAIXA,
            FAIXA_TEMPO_LAUDO_CONDUTA AS TEMPO,
            3 AS ORDEM_FAIXA,
            FAIXA_TEMPO_LAUDO_CONDUTA AS FAIXA_TEMPO,
            QTD_EXAMES
        FROM agg_por_tempo_medico_exame
        WHERE FAIXA_TEMPO_LAUDO_CONDUTA IS NOT NULL
)
SELECT
    MES_ANO,
    CD_HIS_EXECUTANTE,
    NM_MEDICO_EXECUTANTE,
    NM_EXAME,
    CD_STATUS,
    ORDEM_FAIXA,
    FAIXA,
    TEMPO,
    FAIXA_TEMPO,
    QTD_EXAMES
FROM resultado_unpivot
ORDER BY MES_ANO, CD_HIS_EXECUTANTE, NM_EXAME, ORDEM_FAIXA
;