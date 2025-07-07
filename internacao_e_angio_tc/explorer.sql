


WITH ATENDIMENTO_N_AGENDADOS
    AS (
        SELECT
        CAST('0' AS NUMBER(8,0)) AS cd_agenda_central,
        CAST('SEM' AS VARCHAR2(3)) AS TIPO_AGENDA,
        a.dt_atendimento AS hr_agenda,
        a.cd_atendimento,
        a.cd_paciente,
        pa.nm_paciente,
        pa.dt_nascimento,
        c.cd_convenio,
        c.nm_convenio,
        CAST('0' AS NUMBER(9,0)) AS cd_item_agendamento,
        ia.ds_especialid AS ds_item_agendamento,
        'ATENDIDO NAO AGENDADO' AS STATUS_ATENDIMENTO,
        a.hr_atendimento AS dt_gravacao,
        CAST('SEM' AS VARCHAR2(600)) AS ds_observacao_geral,
        CAST('' AS DATE) AS dh_presenca_falta,
        CAST('0' AS NUMBER(6,0)) AS cd_recurso_central,
        CAST('SEM' AS VARCHAR2(30)) AS ds_recurso_central,
        a.cd_prestador,
        p.nm_prestador,
        S.cd_ori_ate cd_setor,
        s.ds_ori_ate nm_setor,
        CAST('0' AS NUMBER(3,0)) AS qt_atendimento,
        CAST('0' AS NUMBER(3,0)) AS qt_marcados,
        CAST('SEM' AS VARCHAR2(30)) AS cd_usuario,
        CAST('SEM' AS VARCHAR2(30)) AS nm_usuario,
        CAST('0' AS NUMBER(4,0)) AS cd_tip_mar,
        t.ds_tip_mar,
        CASE a.tp_atendimento
                WHEN 'A' THEN 'Consulta'
                WHEN 'E' THEN 'Exame'
                WHEN 'U' THEN 'Urgência/Emergência'
                WHEN 'I' THEN 'Internação'
                ELSE 'Sem Correspondência'
        END AS tp_atendimento
        FROM DBAMV.ATENDIME a
        LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
        LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR
        LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
        LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
        LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
        LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
        WHERE
            NOT EXISTS (
                        SELECT 1 FROM IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento
                            )
)
SELECT
    *
	-- COUNT(*) AS QTD
FROM
	ATENDIMENTO_N_AGENDADOS
WHERE
TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024' AND tp_atendimento = 'Exame';
GROUP BY STATUS_ATENDIMENTO
;
--hr_agenda BETWEEN  TO_DATE('2024-06-01', 'YYYY-MM-DD') AND TO_DATE('2024-06-30', 'YYYY-MM-DD');



-- ############################################################################################################


WITH EXAMES
    AS (
        SELECT
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
            AND TRUNC(PX.HR_PEDIDO) BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD')

        UNION ALL

        SELECT
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
        WHERE PX.CD_ATENDIMENTO = RF.CD_ATENDIMENTO
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
            AND TRUNC(PX.HR_PEDIDO) BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD')
)
SELECT
    COUNT(*)
FROM EXAMES
WHERE
    DATA_PEDIDO BETWEEN  TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-06-30', 'YYYY-MM-DD')
    -- AND NOME_EXA LIKE '%ANGIOTOMOGRAFIA CORONARIANA COM CONTRASTE%'
    AND COD_EXAME = 706
;

---################################################################################################################


-- CONSULTA AGENDAMENTO - PAINEL HPC-CLINICA-Agendamentos
let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangEnd, "yyyy-MM-dd"),

    //RangeStartText = "2025-05-01",
    //RangeEndText = "2025-05-29",


    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query = "
SELECT i.cd_agenda_central,
       DECODE(a.TP_AGENDA,
              'L','LABORATORIO',
              'I', 'IMAGEM',
              'A', 'AMBULATORIO' ) AS TIPO_AGENDA,
       i.hr_agenda,
       i.cd_atendimento,
       i.cd_paciente,
       i.nm_paciente,
       i.dt_nascimento,
       i.cd_convenio,
       c.nm_convenio,
       i.cd_item_agendamento,
       ia.ds_item_agendamento,
       DECODE (i.sn_atendido, 'S', 'ATENDIDO', 'N', 'NAO ATENDIDO') AS STATUS_ATENDIMENTO,
       i.dt_gravacao,
       i.ds_observacao_geral,
       i.dh_presenca_falta,
       a.cd_recurso_central,
       r.ds_recurso_central,
       a.cd_prestador,
       pr.nm_prestador,
       a.cd_setor,
       s.nm_setor,
       a.qt_atendimento,
       a.qt_marcados,
       i.cd_usuario,
       u.nm_usuario,
       i.cd_tip_mar,
       tr.ds_tip_mar
FROM DBAMV.IT_AGENDA_CENTRAL i
left JOIN DBAMV.AGENDA_CENTRAL a ON i.cd_agenda_central = a.cd_agenda_central
left JOIN DBAMV.ITEM_AGENDAMENTO ia ON i.cd_item_agendamento = ia.cd_item_agendamento
left JOIN DBAMV.SETOR s ON s.cd_setor = a.cd_setor
left JOIN DBAMV.PRESTADOR pr ON pr.cd_prestador = a.cd_prestador
left JOIN DBAMV.convenio c ON c.cd_convenio = i.cd_convenio
left JOIN DBASGU.USUARIOS u ON u.cd_usuario = a.cd_usuario
left JOIN DBAMV.RECURSO_CENTRAL r ON r.cd_recurso_central = a.cd_recurso_central
left JOIN DBAMV.TIP_MAR tr ON tr.cd_tip_mar = i.cd_tip_mar
WHERE i.hr_agenda BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD') " ,

    // Chamada Oracle com a query final montada
    Fonte = Oracle.Database(
        "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
        [Query = Query]
    )
in
    Fonte

-- RangeStar
#date(2025, 5, 28) meta [IsParameterQuery=true, Type="Date", IsParameterQueryRequired=true]

-- RangEnd
#date(2025, 5, 29) meta [IsParameterQuery=true, Type="Date", IsParameterQueryRequired=true]


---################################################################################################################


-- CONSULTA AGEN_EXAM - PAINEL HPC-CLINICA-Agendamentos
let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangEnd, "yyyy-MM-dd"),

    //RangeStartText = "2025-05-01",
    //RangeEndText = "2025-05-29",


    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query = "
SELECT
    i.cd_agenda_central,
       DECODE(a.TP_AGENDA,
       'L','LABORATORIO',
       'I', 'IMAGEM',
       'A', 'AMBULATORIO' ) TIPO_AGENDA,
        i.HR_AGENDA,
        i.cd_atendimento,
        i.cd_paciente,
        i.nm_paciente,
        I.DT_NASCIMENTO,
        I.CD_CONVENIO,
        C.NM_CONVENIO,
        i.cd_item_agendamento,
        ia.ds_item_agendamento,
        Decode (i.sn_atendido, 'S', 'ATENDIDO', 'N', 'NAO ATENDIDO'),
        i.dt_gravacao,
        i.ds_observacao_geral,
        i.dh_presenca_falta,
        a.cd_recurso_central,
        R.DS_RECURSO_CENTRAL,
        a.cd_prestador,
        --PR.NM_PRESTADOR,
        a.cd_setor,
        s.nm_setor,
        a.qt_atendimento,
        a.qt_marcados,
        i.cd_usuario,
        U.NM_USUARIO
    FROM DBAMV.IT_AGENDA_CENTRAL i,
         DBAMV.AGENDA_CENTRAL a,
         DBAMV.ITEM_AGENDAMENTO ia,
         DBAMV.SETOR s,
         --DBAMV.PRESTADOR pr,
         DBAMV.convenio c,
         DBASGU.USUARIOS u,
         DBAMV.RECURSO_CENTRAL r
      WHERE i.cd_agenda_central   = a.cd_agenda_central
       AND i.cd_item_agendamento  = ia.cd_item_agendamento
       AND a.cd_recurso_central   = r.cd_recurso_central
       --AND A.CD_PRESTADOR is null
       AND S.CD_SETOR = A.CD_SETOR
       AND U.CD_USUARIO = A.CD_USUARIO
       AND C.CD_CONVENIO = I.CD_CONVENIO
       AND A.TP_AGENDA = 'I'
       AND i.HR_AGENDA BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD') " ,

    // Chamada Oracle com a query final montada
    Fonte = Oracle.Database(
        "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
        [Query = Query]
    )
in
    Fonte

---################################################################################################################


-- CONSULTA EXA_REA - PAINEL HPC-CLINICA-Agendamentos

let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangEnd, "yyyy-MM-dd"),

    //RangeStartText = "2025-05-01",
    //RangeEndText = "2025-05-29",


    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query =
"SELECT
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
            AND TRUNC(PX.HR_PEDIDO) BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')

        UNION ALL

        SELECT
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
        WHERE PX.CD_ATENDIMENTO = RF.CD_ATENDIMENTO
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
            AND TRUNC(PX.HR_PEDIDO) BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')",
    // Chamada Oracle com a query final montada
    Fonte = Oracle.Database(
        "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
        [Query = Query]
    )
in
    Fonte

---################################################################################################################
---################################################################################################################

-- CONSULTA FATURAMENTO - PAINEL HPC-FATURAMENTO-Emergência e Produção MV

let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangeEnd, "yyyy-MM-dd"),

    //RangeStartText = "2025-05-01",
    //RangeEndText = "2025-05-29",


    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query =
"WITH FATURAMENTO
    AS (
SELECT
    a.cd_atendimento as COD_ATEND,
    RF.CD_REG_FAT as CONTA,
    a.cd_paciente as COD_PACIENTE,
    p.nm_paciente as NOME_PACIENTE,
    a.cd_convenio as COD_CONVENIO,
    c.nm_convenio as NOME_CONVENIO,
    if.cd_pro_fat as COD_PROCEDIMENTO,
    p.cd_produto  AS PRODUTO,
    pf.ds_pro_fat as NOME_PROCEDIMENTO,
    IF.CD_SETOR as SETOR,
    S.NM_SETOR as NOME_SETOR,
    a.dt_atendimento as DATA_ATENDIMENTO,
    a.hr_alta as DATA_ALTA,
    rf.dt_fechamento as DATA_FECHAMENTO,
    rf.sn_fechada,
    rf.sn_fatura_impressa,
    if.qt_lancamento as QNT,
    if.vl_unitario as VL_UNIT,
    round(cmm.vl_custo_medio,3) AS CUSTO_MEDIO,
    if.vl_total_conta as VL_TOTAL,
    CASE
        WHEN A.TP_ATENDIMENTO = 'A' THEN 'AMBULATORIO'
        WHEN A.TP_ATENDIMENTO = 'E' THEN 'EXAMES'
        WHEN A.TP_ATENDIMENTO = 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN A.TP_ATENDIMENTO = 'I' THEN 'INTERNACAO'
    END AS TIPO
FROM
    atendime a,
    paciente p,
    convenio c,
    itreg_fat if,
    pro_fat pf,
    reg_fat rf,
    produto p,
    setor s,
    valor_inicial_produto cmm
WHERE P.CD_PACIENTE = A.CD_PACIENTE
AND PF.CD_PRO_FAT = IF.CD_PRO_FAT
AND RF.CD_ATENDIMENTO = A.CD_ATENDIMENTO
AND RF.CD_CONVENIO = C.CD_CONVENIO
AND RF.CD_REG_FAT = IF.CD_REG_FAT
AND S.CD_SETOR = IF.CD_SETOR
AND IF.CD_PRO_FAT = P.CD_PRO_FAT (+)
AND P.CD_PRODUTO = CMM.CD_PRODUTO (+)
UNION ALL
SELECT
    a.cd_atendimento as COD_ATEND,
    RB.CD_REG_AMB as CONTA,
    a.cd_paciente as COD_PACIENTE,
    p.nm_paciente as NOME_PACIENTE,
    a.cd_convenio as COD_CONVENIO,
    c.nm_convenio as NOME_CONVENIO,
    ib.cd_pro_fat as COD_PROCEDIMENTO,
    p.cd_produto  AS PRODUTO,
    pf.ds_pro_fat as NOME_PROCEDIMENTO,
    IB.CD_SETOR as SETOR,
    S.NM_SETOR as NOME_SETOR,
    a.dt_atendimento as DATA_ATENDIMENTO,
    A.HR_ALTA as DATA_ALTA,
    ib.dt_fechamento as DATA_FECHAMENTO,
    ib.sn_fechada,
    ib.sn_fatura_impressa,
    ib.qt_lancamento as QNT,
    ib.vl_unitario VL_UNIT,
    round(cmm.vl_custo_medio,3) AS CUSTO_MEDIO,
    ib.vl_total_conta VL_TOTAL,
    CASE
        WHEN A.TP_ATENDIMENTO = 'A' THEN 'AMBULATORIO'
        WHEN A.TP_ATENDIMENTO = 'E' THEN 'EXAMES'
        WHEN A.TP_ATENDIMENTO = 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN A.TP_ATENDIMENTO = 'I' THEN 'INTERNACAO'
    END AS TIPO
FROM
    atendime a,
    paciente p,
    convenio c,
    itreg_amb ib,
        pro_fat pf,
    reg_amb rb,
    produto p,
    setor s,
    valor_inicial_produto cmm
WHERE P.CD_PACIENTE = A.CD_PACIENTE
AND PF.CD_PRO_FAT = IB.CD_PRO_FAT
AND IB.CD_ATENDIMENTO = A.CD_ATENDIMENTO
AND RB.CD_CONVENIO = C.CD_CONVENIO
AND RB.CD_REG_AMB = IB.CD_REG_AMB
AND S.CD_SETOR = IB.CD_SETOR
AND IB.CD_PRO_FAT = P.CD_PRO_FAT (+)
AND P.CD_PRODUTO = CMM.CD_PRODUTO (+)
)
SELECT * FROM FATURAMENTO WHERE DATA_ATENDIMENTO BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')",

// Chamada Oracle com a query final montada
Fonte = Oracle.Database(
    "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
    [Query = Query]
)

---################################################################################################################

-- CONSULTA MOVIMENTAÇÃO - PAINEL HPC-FATURAMENTO-Emergência e Produção MV

let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangeEnd, "yyyy-MM-dd"),

    //RangeStartText = "2025-05-01",
    //RangeEndText = "2025-05-29",


    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query =
"SELECT
    PD.CD_PROTOCOLO_DOC,
    IPD.CD_ATENDIMENTO,
    P.NM_PACIENTE,
    A.CD_CONVENIO,
    C.NM_CONVENIO,
    IPD.CD_REG_AMB,
    IPD.CD_REG_FAT,
    IPD.DT_DEVOLUCAO,
    IPD.NM_USUARIO_DEVOLUCAO,
    IPD.DT_REALIZACAO,
    IPD.HR_REALIZACAO,
    IPD.DT_RECEBIMENTO,
    IPD.NM_USUARIO_RECEBIMENTO,
    PD.DT_ENVIO,
    PD.NM_USUARIO_ENVIO,
    PD.CD_SETOR,
    S.NM_SETOR,
    PD.CD_SETOR_DESTINO,
    CASE
        WHEN PD.CD_SETOR_DESTINO = '1' THEN 'DIRECAO ADMINISTRATIVA'
        WHEN PD.CD_SETOR_DESTINO = '2' THEN 'ADMINISTRACAO'
        WHEN PD.CD_SETOR_DESTINO = '3' THEN 'AUTORIZACAO'
        WHEN PD.CD_SETOR_DESTINO = '4' THEN 'AUDITORIA'
        WHEN PD.CD_SETOR_DESTINO = '5' THEN 'COMERCIAL'
        WHEN PD.CD_SETOR_DESTINO = '6' THEN 'COMPRAS'
        WHEN PD.CD_SETOR_DESTINO = '7' THEN 'CONTABILIDADE'
        WHEN PD.CD_SETOR_DESTINO = '8' THEN 'DIRETORIA'
        WHEN PD.CD_SETOR_DESTINO = '9' THEN 'FATURAMENTO'
        WHEN PD.CD_SETOR_DESTINO = '10' THEN 'FINANCEIRO'
        WHEN PD.CD_SETOR_DESTINO = '11' THEN 'MARKETING'
        WHEN PD.CD_SETOR_DESTINO = '12' THEN 'TI'
        WHEN PD.CD_SETOR_DESTINO = '13' THEN 'PATRIMONIO'
        WHEN PD.CD_SETOR_DESTINO = '14' THEN 'DH/JURIDICO'
        WHEN PD.CD_SETOR_DESTINO = '15' THEN 'DP'
        WHEN PD.CD_SETOR_DESTINO = '16' THEN 'JURIDICO'
        WHEN PD.CD_SETOR_DESTINO = '17' THEN 'RH'
        WHEN PD.CD_SETOR_DESTINO = '18' THEN 'SESMT'
        WHEN PD.CD_SETOR_DESTINO = '19' THEN 'ASSISTENCIAL'
        WHEN PD.CD_SETOR_DESTINO = '20' THEN 'CCIH'
        WHEN PD.CD_SETOR_DESTINO = '21' THEN 'CME'
        WHEN PD.CD_SETOR_DESTINO = '22' THEN 'CENTRO CIRURGICO'
        WHEN PD.CD_SETOR_DESTINO = '23' THEN 'COORDENACAO ASSISTENCIAL'
        WHEN PD.CD_SETOR_DESTINO = '24' THEN 'FARMACIA'
        WHEN PD.CD_SETOR_DESTINO = '25' THEN 'FISIOTERAPIA'
        WHEN PD.CD_SETOR_DESTINO = '26' THEN 'HEMODINAMICA'
        WHEN PD.CD_SETOR_DESTINO = '27' THEN 'LABORATORIO'
        WHEN PD.CD_SETOR_DESTINO = '28' THEN 'NUTRICAO'
        WHEN PD.CD_SETOR_DESTINO = '29' THEN 'POSTO 1'
        WHEN PD.CD_SETOR_DESTINO = '30' THEN 'POSTO 2'
        WHEN PD.CD_SETOR_DESTINO = '31' THEN 'POSTO 3'
        WHEN PD.CD_SETOR_DESTINO = '32' THEN 'EMERGENCIA'
        WHEN PD.CD_SETOR_DESTINO = '33' THEN 'UTI 1'
        WHEN PD.CD_SETOR_DESTINO = '34' THEN 'UTI 2'
        WHEN PD.CD_SETOR_DESTINO = '35' THEN 'UTI 3'
        WHEN PD.CD_SETOR_DESTINO = '36' THEN 'UTI 4'
        WHEN PD.CD_SETOR_DESTINO = '37' THEN 'APOIO'
        WHEN PD.CD_SETOR_DESTINO = '38' THEN 'ALMOXARIFADO'
        WHEN PD.CD_SETOR_DESTINO = '39' THEN 'CALL CENTER'
        WHEN PD.CD_SETOR_DESTINO = '40' THEN 'HIGIENE E LIMPEZA'
        WHEN PD.CD_SETOR_DESTINO = '41' THEN 'HOTELARIA'
        WHEN PD.CD_SETOR_DESTINO = '42' THEN 'MANUTENCAO CLINICA'
        WHEN PD.CD_SETOR_DESTINO = '43' THEN 'MANUTENCAO PREDIAL'
        WHEN PD.CD_SETOR_DESTINO = '44' THEN 'OBRAS E REFORMAS'
        WHEN PD.CD_SETOR_DESTINO = '45' THEN 'RECEPCAO EMERGENCIA'
        WHEN PD.CD_SETOR_DESTINO = '46' THEN 'SAME'
        WHEN PD.CD_SETOR_DESTINO = '47' THEN 'SERVICO DE TRANSPORTE'
        WHEN PD.CD_SETOR_DESTINO = '48' THEN 'QUALIDADE'
        WHEN PD.CD_SETOR_DESTINO = '49' THEN 'CLINICA'
        WHEN PD.CD_SETOR_DESTINO = '50' THEN 'ECOCARDIOGRAMA'
        WHEN PD.CD_SETOR_DESTINO = '51' THEN 'ELETROCARDIOGRAMA'
        WHEN PD.CD_SETOR_DESTINO = '52' THEN 'ERGOMETRIA'
        WHEN PD.CD_SETOR_DESTINO = '53' THEN 'HOLTER'
        WHEN PD.CD_SETOR_DESTINO = '54' THEN 'MAPA'
        WHEN PD.CD_SETOR_DESTINO = '55' THEN 'RAIO X'
        WHEN PD.CD_SETOR_DESTINO = '56' THEN 'RECEPCAO CLINICA'
        WHEN PD.CD_SETOR_DESTINO = '57' THEN 'TOMOGRAFIA'
        WHEN PD.CD_SETOR_DESTINO = '58' THEN 'ULTRASSONOGRAFIA'
        WHEN PD.CD_SETOR_DESTINO = '59' THEN 'ECG'
        WHEN PD.CD_SETOR_DESTINO = '60' THEN 'NIR (NUCLEO DE INTERNACAO E REGULACAO)'
    END AS NM_SETOR_DESTINO
FROM
    DBAMV.IT_PROTOCOLO_DOC ipd,
    DBAMV.SETOR s,
    DBAMV.PROTOCOLO_DOC pd,
    DBAMV.ATENDIME a,
    DBAMV.PACIENTE p,
    DBAMV.CONVENIO c
WHERE
    IPD.CD_ATENDIMENTO = A.CD_ATENDIMENTO
    AND PD.CD_PROTOCOLO_DOC = IPD.CD_PROTOCOLO_DOC
    AND PD.CD_SETOR = S.CD_SETOR
    AND P.CD_PACIENTE = A.CD_PACIENTE
    AND C.CD_CONVENIO = A.CD_CONVENIO
    AND PD.DT_ENVIO BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')",

// Chamada Oracle com a query final montada
Fonte = Oracle.Database(
    "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
    [Query = Query]
)


---################################################################################################################


-- CONSULTA BASEDATA - PAINEL HPC-FATURAMENTO-Emergência e Produção MV

let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangeEnd, "yyyy-MM-dd"),

    //RangeStartText = "2025-05-01",
    //RangeEndText = "2025-05-29",


    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query =
"
WITH BASEDATA
    AS (
SELECT
    a.cd_atendimento as COD_ATEND,
    RF.CD_REG_FAT as CONTA,
    a.cd_paciente as COD_PACIENTE,
    p.nm_paciente as NOME_PACIENTE,
    a.cd_convenio as COD_CONVENIO,
    c.nm_convenio as NOME_CONVENIO,
    if.cd_pro_fat as COD_PROCEDIMENTO,
    p.cd_produto  AS PRODUTO,
    pf.ds_pro_fat as NOME_PROCEDIMENTO,
    IF.CD_SETOR as SETOR,
    S.NM_SETOR as NOME_SETOR,
    a.dt_atendimento as DATA_ATENDIMENTO,
    a.hr_alta as DATA_ALTA,
    rf.dt_fechamento as DATA_FECHAMENTO,
    rf.sn_fechada,
    rf.sn_fatura_impressa,
    if.qt_lancamento as QNT,
    if.vl_unitario as VL_UNIT,
    round(cmm.vl_custo_medio,3) AS CUSTO_MEDIO,
    if.vl_total_conta as VL_TOTAL,
    CASE
        WHEN A.TP_ATENDIMENTO = 'A' THEN 'AMBULATORIO'
        WHEN A.TP_ATENDIMENTO = 'E' THEN 'EXAMES'
        WHEN A.TP_ATENDIMENTO = 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN A.TP_ATENDIMENTO = 'I' THEN 'INTERNACAO'
    END AS TIPO
FROM
    atendime a,
    paciente p,
    convenio c,
    itreg_fat if,
        pro_fat pf,
    reg_fat rf,
    produto p,
    setor s,
    valor_inicial_produto cmm
WHERE
    P.CD_PACIENTE = A.CD_PACIENTE
    AND PF.CD_PRO_FAT = IF.CD_PRO_FAT
    AND RF.CD_ATENDIMENTO = A.CD_ATENDIMENTO
    AND RF.CD_CONVENIO = C.CD_CONVENIO
    AND RF.CD_REG_FAT = IF.CD_REG_FAT
    AND S.CD_SETOR = IF.CD_SETOR
    AND IF.CD_PRO_FAT = P.CD_PRO_FAT (+)
    AND P.CD_PRODUTO = CMM.CD_PRODUTO (+)
UNION ALL
SELECT
    a.cd_atendimento as COD_ATEND,
    RB.CD_REG_AMB as CONTA,
    a.cd_paciente as COD_PACIENTE,
    p.nm_paciente as NOME_PACIENTE,
    a.cd_convenio as COD_CONVENIO,
    c.nm_convenio as NOME_CONVENIO,
    ib.cd_pro_fat as COD_PROCEDIMENTO,
    p.cd_produto  AS PRODUTO,
    pf.ds_pro_fat as NOME_PROCEDIMENTO,
    IB.CD_SETOR as SETOR,
    S.NM_SETOR as NOME_SETOR,
    a.dt_atendimento as DATA_ATENDIMENTO,
    A.HR_ALTA as DATA_ALTA,
    ib.dt_fechamento as DATA_FECHAMENTO,
    ib.sn_fechada,
    ib.sn_fatura_impressa,
    ib.qt_lancamento as QNT,
    ib.vl_unitario VL_UNIT,
    round(cmm.vl_custo_medio,3) AS CUSTO_MEDIO,
    ib.vl_total_conta VL_TOTAL,
    CASE
        WHEN A.TP_ATENDIMENTO = 'A' THEN 'AMBULATORIO'
        WHEN A.TP_ATENDIMENTO = 'E' THEN 'EXAMES'
        WHEN A.TP_ATENDIMENTO = 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN A.TP_ATENDIMENTO = 'I' THEN 'INTERNACAO'
    END AS TIPO
FROM
    atendime a,
    paciente p,
    convenio c,
    itreg_amb ib,
    pro_fat pf,
    reg_amb rb,
    produto p,
    setor s,
    valor_inicial_produto cmm
WHERE
    P.CD_PACIENTE = A.CD_PACIENTE
    AND PF.CD_PRO_FAT = IB.CD_PRO_FAT
    AND IB.CD_ATENDIMENTO = A.CD_ATENDIMENTO
    AND RB.CD_CONVENIO = C.CD_CONVENIO
    AND RB.CD_REG_AMB = IB.CD_REG_AMB
    AND S.CD_SETOR = IB.CD_SETOR
    AND IB.CD_PRO_FAT = P.CD_PRO_FAT (+)
    AND P.CD_PRODUTO = CMM.CD_PRODUTO (+)
)
SELECT * FROM BASEDATA WHERE DATA_ATENDIMENTO BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')",

// Chamada Oracle com a query final montada
Fonte = Oracle.Database(
    "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
    [Query = Query]
)


--- **************************************************************************************************************************

-- CONSULTA BASEDATA - PAINEL HPC-FATURAMENTO-Emergência e Produção MV

let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangeEnd, "yyyy-MM-dd"),

    //RangeStartText = "2025-05-01",
    //RangeEndText = "2025-05-29",


    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query =
"
WITH BASEDATA
    AS (
SELECT
    a.cd_atendimento as COD_ATEND,
    RF.CD_REG_FAT as CONTA,
    a.cd_paciente as COD_PACIENTE,
    p.nm_paciente as NOME_PACIENTE,
    a.cd_convenio as COD_CONVENIO,
    c.nm_convenio as NOME_CONVENIO,
    if.cd_pro_fat as COD_PROCEDIMENTO,
    p.cd_produto  AS PRODUTO,
    pf.ds_pro_fat as NOME_PROCEDIMENTO,
    IF.CD_SETOR as SETOR,
    S.NM_SETOR as NOME_SETOR,
    a.dt_atendimento as DATA_ATENDIMENTO,
    a.hr_alta as DATA_ALTA,
    rf.dt_fechamento as DATA_FECHAMENTO,
    rf.sn_fechada,
    rf.sn_fatura_impressa,
    if.qt_lancamento as QNT,
    if.vl_unitario as VL_UNIT,
    round(cmm.vl_custo_medio,3) AS CUSTO_MEDIO,
    if.vl_total_conta as VL_TOTAL,
    CASE
        WHEN A.TP_ATENDIMENTO = 'A' THEN 'AMBULATORIO'
        WHEN A.TP_ATENDIMENTO = 'E' THEN 'EXAMES'
        WHEN A.TP_ATENDIMENTO = 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN A.TP_ATENDIMENTO = 'I' THEN 'INTERNACAO'
    END AS TIPO
FROM
    atendime a,
    paciente p,
    convenio c,
    itreg_fat if,
        pro_fat pf,
    reg_fat rf,
    produto p,
    setor s,
    valor_inicial_produto cmm
WHERE
    P.CD_PACIENTE = A.CD_PACIENTE
    AND PF.CD_PRO_FAT = IF.CD_PRO_FAT
    AND RF.CD_ATENDIMENTO = A.CD_ATENDIMENTO
    AND RF.CD_CONVENIO = C.CD_CONVENIO
    AND RF.CD_REG_FAT = IF.CD_REG_FAT
    AND S.CD_SETOR = IF.CD_SETOR
    AND IF.CD_PRO_FAT = P.CD_PRO_FAT (+)
    AND P.CD_PRODUTO = CMM.CD_PRODUTO (+)
UNION ALL
SELECT
    a.cd_atendimento as COD_ATEND,
    RB.CD_REG_AMB as CONTA,
    a.cd_paciente as COD_PACIENTE,
    p.nm_paciente as NOME_PACIENTE,
    a.cd_convenio as COD_CONVENIO,
    c.nm_convenio as NOME_CONVENIO,
    ib.cd_pro_fat as COD_PROCEDIMENTO,
    p.cd_produto  AS PRODUTO,
    pf.ds_pro_fat as NOME_PROCEDIMENTO,
    IB.CD_SETOR as SETOR,
    S.NM_SETOR as NOME_SETOR,
    a.dt_atendimento as DATA_ATENDIMENTO,
    A.HR_ALTA as DATA_ALTA,
    ib.dt_fechamento as DATA_FECHAMENTO,
    ib.sn_fechada,
    ib.sn_fatura_impressa,
    ib.qt_lancamento as QNT,
    ib.vl_unitario VL_UNIT,
    round(cmm.vl_custo_medio,3) AS CUSTO_MEDIO,
    ib.vl_total_conta VL_TOTAL,
    CASE
        WHEN A.TP_ATENDIMENTO = 'A' THEN 'AMBULATORIO'
        WHEN A.TP_ATENDIMENTO = 'E' THEN 'EXAMES'
        WHEN A.TP_ATENDIMENTO = 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN A.TP_ATENDIMENTO = 'I' THEN 'INTERNACAO'
    END AS TIPO
FROM
    atendime a,
    paciente p,
    convenio c,
    itreg_amb ib,
    pro_fat pf,
    reg_amb rb,
    produto p,
    setor s,
    valor_inicial_produto cmm
WHERE
    P.CD_PACIENTE = A.CD_PACIENTE
    AND PF.CD_PRO_FAT = IB.CD_PRO_FAT
    AND IB.CD_ATENDIMENTO = A.CD_ATENDIMENTO
    AND RB.CD_CONVENIO = C.CD_CONVENIO
    AND RB.CD_REG_AMB = IB.CD_REG_AMB
    AND S.CD_SETOR = IB.CD_SETOR
    AND IB.CD_PRO_FAT = P.CD_PRO_FAT (+)
    AND P.CD_PRODUTO = CMM.CD_PRODUTO (+)
)
SELECT * FROM BASEDATA WHERE DATA_ATENDIMENTO BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')",

// Chamada Oracle com a query final montada
Fonte = Oracle.Database(
    "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
    [Query = Query]
),
    #"Data Inserida" = Table.AddColumn(Fonte, "DATA", each Date.From([DATA_ATENDIMENTO]), type date),
    #"Coluna Condicional Adicionada" = Table.AddColumn(#"Data Inserida", "AMB/INT", each if [TIPO] = "AMBULATORIO" then "AMBULATORIO" else if [TIPO] = "EXAMES" then "AMBULATORIO" else if [TIPO] = "URGENCIA/EMERGENCIA" then "AMBULATORIO" else "INTERNACAO"),
    #"Coluna Condicional Adicionada1" = Table.AddColumn(#"Coluna Condicional Adicionada", "CATEGORIA_CONVENIOS", each if [NOME_SETOR] = "PARTICULAR" then "PARTICULAR" else if [NOME_SETOR] = "SUS - INTERNACAO" then "SUS" else "CONVENIO"),
    #"Coluna Condicional Adicionada2" = Table.AddColumn(#"Coluna Condicional Adicionada1", "NOVA", each if [NOME_CONVENIO] = "PARTICULAR" then "PARTICULAR" else if [NOME_CONVENIO] = "SUS - INTERNACAO" then "SUS" else "CONVENIO"),
    #"Colunas Removidas" = Table.RemoveColumns(#"Coluna Condicional Adicionada2",{"CATEGORIA_CONVENIOS"}),
    #"Colunas Renomeadas" = Table.RenameColumns(#"Colunas Removidas",{{"NOVA", "CATEGORIA_CONVENIO"}}),
    #"Coluna Condicional Adicionada3" = Table.AddColumn(#"Colunas Renomeadas", "COM OU SEM ALTA", each if [DATA_ALTA] = null then "SEM ALTA" else "COM ALTA"),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Coluna Condicional Adicionada3",{{"PRODUTO", type text}}),
    #"Linhas Filtradas" = Table.SelectRows(#"Tipo Alterado", each true),
    #"Colunas Renomeadas1" = Table.RenameColumns(#"Linhas Filtradas",{{"NOME_CONVENIO", "CONVENIO"}}),
    #"Tipo Alterado1" = Table.TransformColumnTypes(#"Colunas Renomeadas1",{{"CONTA", type text}}),
    #"Dia Inserido" = Table.AddColumn(#"Tipo Alterado1", "Dia", each Date.Day([DATA_ATENDIMENTO]), Int64.Type),
    #"Linhas Filtradas1" = Table.SelectRows(#"Dia Inserido", each true),
    #"Colunas Removidas1" = Table.RemoveColumns(#"Linhas Filtradas1",{"COD_ATEND", "CONTA", "COD_PACIENTE", "NOME_PACIENTE", "COD_CONVENIO", "CONVENIO", "COD_PROCEDIMENTO", "PRODUTO", "NOME_PROCEDIMENTO", "SETOR", "NOME_SETOR", "DATA_ALTA", "DATA_FECHAMENTO", "SN_FECHADA", "SN_FATURA_IMPRESSA", "QNT", "VL_UNIT", "CUSTO_MEDIO", "VL_TOTAL", "TIPO", "DATA", "AMB/INT", "CATEGORIA_CONVENIO", "COM OU SEM ALTA", "Dia"}),
    #"Duplicatas Removidas" = Table.Distinct(#"Colunas Removidas1"),
    #"Linhas Classificadas" = Table.Sort(#"Duplicatas Removidas",{{"DATA_ATENDIMENTO", Order.Ascending}})
in
    #"Linhas Classificadas"

--- **************************************************************************************************************************


---################################################################################################################


