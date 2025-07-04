


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
GROUP BY STATUS_ATENDIMENTO;
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

    let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangEnd, "yyyy-MM-dd"),

    //RangeStartText = "2025-05-01",
    //RangeEndText = "2025-05-29",


    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query =
"WITH EXAMES
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
            AND TRUNC(PX.HR_PEDIDO) BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD')",
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
    let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStar, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangEnd, "yyyy-MM-dd"),

    //RangeStartText = "2025-05-01",
    //RangeEndText = "2025-05-29",


    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query = "
        SELECT
            ITCONTAGEM.CD_PRODUTO                          AS                             CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)                    AS                             DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                          AS                           VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)                    AS                             DS_UNIDADE,
            sum( NVL(ITCONTAGEM.QT_ESTOQUE,0) + NVL( ITCONTAGEM.QT_ESTOQUE_DOADO,0)) AS   QUANTIDADE,
            TRUNC(CONTAGEM.DT_GERACAO)                                               AS   DT_GERACAO,
            to_char(CONTAGEM.HR_GERACAO,'hh24:mi:ss')                                AS   HORA,
            CONTAGEM.CD_CONTAGEM                                                     AS   DOCUMENTO,
            'Contagem - ' || INITCAP(ESTOQUE.DS_ESTOQUE)                             AS   DS_DESTINO,
            'Contagem'                                                               AS   OPERACAO,
            0                                                                        AS   VALOR,
            ESTOQUE.CD_ESTOQUE                                                       AS   CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)                                              AS   DS_ESTOQUE,
            UNI_PRO.VL_FATOR                                                         AS   VL_FATOR,
            '1'                                                                      AS   TP_ORDEM,
            'N'                                                                      AS   SN_CONSIGNADO,
            0                                                                        AS   cd_itmvto_estoque
        FROM
            dbamv.ITCONTAGEM            ITCONTAGEM,
            dbamv.CONTAGEM              CONTAGEM,
            dbamv.PRODUTO               PRODUTO,
            dbamv.UNI_PRO               UNI_PRO,
            dbamv.ESTOQUE               ESTOQUE,
            dbamv.ITENT_PRO             ITENT_PRO,
            dbamv.VALOR_INICIAL_PRODUTO VALOR_INICIAL_PRODUTO
        WHERE
            ITCONTAGEM.CD_PRODUTO       = PRODUTO.CD_PRODUTO
            AND PRODUTO.CD_PRODUTO       = ITENT_PRO.CD_PRODUTO
            AND PRODUTO.CD_PRODUTO       = valor_inicial_produto.CD_PRODUTO
            AND  ITCONTAGEM.CD_CONTAGEM = CONTAGEM.CD_CONTAGEM
            AND  ITCONTAGEM.CD_UNI_PRO  = UNI_PRO.CD_UNI_PRO
            AND CONTAGEM.CD_ESTOQUE     = ESTOQUE.CD_ESTOQUE
            AND TRUNC(CONTAGEM.DT_GERACAO) BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
        GROUP BY
            ITCONTAGEM.CD_PRODUTO,
            PRODUTO.DS_PRODUTO,
            PRODUTO.VL_CUSTO_MEDIO,
            ITENT_PRO.VL_UNITARIO,
            VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
            UNI_PRO.DS_UNIDADE,
            CONTAGEM.DT_GERACAO,
            CONTAGEM.HR_GERACAO,
            CONTAGEM.CD_CONTAGEM,
            ESTOQUE.CD_ESTOQUE,
            ESTOQUE.DS_ESTOQUE,
            UNI_PRO.VL_FATOR" ,

    // Chamada Oracle com a query final montada
    Fonte = Oracle.Database(
        "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
        [Query = Query]
    )
in
    Fonte


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
    Fonte,

     -- AND a.cd_recurso_central   = $aPgRecursoCentral
     --  AND i.hr_agenda            BETWEEN $aPgDataInicialProntocardio$ AND $aPgDataFinalProntocardio$
     --  AND a.cd_prestador         = $aPglistaprestadores
     --  AND  a.cd_setor            = $AlistaSetor