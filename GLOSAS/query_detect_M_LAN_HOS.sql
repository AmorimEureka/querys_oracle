-- "Dados da Conta"
BEGIN Pkg_ffcv_M_LAN_HOS.P_I_WVI_C_CD_CONTA(:1 , :2 ); END;
---- Nova Linha ---- -- 15/05/2026 11:35:09

SELECT MM.CD_MOEDA
    FROM DBAMV.MOEDA_MULTI_EMPRESA MM, DBAMV.MOEDA M
        WHERE MM.CD_MOEDA = M.CD_MOEDA
            AND MM.CD_MULTI_EMPRESA = :1
            AND M.CD_MOEDA = :2
---- Nova Linha ---- -- 15/05/2026 11:35:50

-- "Serviços da Conta"
SELECT *
    FROM (SELECT ROWNUM
        AS RECNUM, f2n_table.*
        from (SELECT *
            FROM (SELECT CD_REG_FAT, CD_LANCAMENTO, CD_CONTA_PAI, CD_GRU_FAT, CD_PRO_FAT, CD_GUIA, DT_LANCAMENTO, HR_LANCAMENTO, SN_HORARIO_ESPECIAL, QT_LANCAMENTO, VL_PERCENTUAL_MULTIPLA, VL_PERCENTUAL_PACIENTE, CD_SETOR, CD_SETOR_PRODUZIU, CD_PRESTADOR, TP_PAGAMENTO, SN_PERTENCE_PACOTE, CD_PRES_CON, VL_UNITARIO, VL_TOTAL_CONTA, VL_OPERACIONAL_UNITARIO, VL_HONORARIO_UNITARIO, QT_CH_UNITARIO, VL_FILME_UNITARIO, VL_ACRESCIMO, VL_DESCONTO, CD_IMPORTA_REG_FAT, CD_ATI_MED, CD_FRANQUIA, CD_REG_FAT_PAI, CD_LANCAMENTO_PAI, CD_REGRA_ACOPLAMENTO, SN_PACIENTE_PAGA, CD_REG_FAT_REL, CD_LANCAMENTO_REL, CD_USUARIO, CD_MVTO, TP_MVTO, CD_PADRAO, CD_CONTA_KIT, CD_ITMVTO, CD_CONTA_PACOTE, NR_DIFEP, CD_REGRA_SUBSTITUICAO_PROCED, SN_PLANTAO_EMERG_PRESTADOR, CD_SUS, CD_MULTI_EMPRESA, ROWID
                AS F2N_ROWID
-- "Conta Selecionada na Grid 'Dados da Conta' "
                FROM DBAMV.ITREG_FAT
                    WHERE (cd_reg_fat = :"SYS_B_0") ORDER BY TO_DATE(TO_CHAR(DT_LANCAMENTO , :"SYS_B_1")||TO_CHAR(HR_LANCAMENTO,:"SYS_B_2"),:"SYS_B_3"), CD_SETOR) X ORDER BY SN_PERTENCE_PACOTE ASC) f2n_table
                        WHERE ROWNUM <= :1 )
                            WHERE RECNUM >= :2
---- Nova Linha ---- -- 15/05/2026 11:39:48

SELECT sum(nvl(itreg_amb.vl_total_conta, :"SYS_B_0"))
    FROM dbamv.itreg_amb
        WHERE itreg_amb.cd_atendimento = :1
            AND nvl(itreg_amb.tp_pagamento, :"SYS_B_1") <> :"SYS_B_2"
            AND nvl(itreg_amb.sn_pertence_pacote, :"SYS_B_3") = :"SYS_B_4"
            AND itreg_amb.cd_con_pla = :2
            AND itreg_amb.cd_convenio = :3
---- Nova Linha ---- -- 15/05/2026 11:39:48

SELECT SN_FECHADA
    FROM DBAMV.ITREG_AMB
        WHERE CD_ATENDIMENTO = :1
            AND CD_REG_AMB = :2 ORDER BY SN_FECHADA ASC
---- Nova Linha ---- -- 15/05/2026 11:40:56

SELECT *
    FROM (SELECT ROWNUM
        AS RECNUM, f2n_table.*
        from (SELECT CD_ATENDIMENTO, CD_PACIENTE, DT_ATENDIMENTO, HR_ATENDIMENTO, CD_PRESTADOR, SN_INFECCAO, SN_ACOMPANHANTE, CD_LEITO, CD_PROCEDIMENTO, CD_CID_OBITO, CD_TIP_ACOM, CD_CID, CD_ORI_ATE, CD_PRO_INT, CD_CONVENIO, CD_CON_PLA, TP_ATENDIMENTO, NM_USUARIO, DT_ALTA, CD_MOT_ALT, HR_ALTA, SN_OBITO, CD_MULTI_EMPRESA, NR_LAUDO, ROWID
            AS F2N_ROWID
            FROM DBAMV.ATENDIME
                WHERE CD_MULTI_EMPRESA = DBAMV.PKG_MV2000.LE_EMPRESA
                    AND (TP_ATENDIMENTO)
                    IN (:"SYS_B_0", :"SYS_B_1", :"SYS_B_2")
                    AND (CD_CONVENIO)
                    IN ((SELECT conf.cd_convenio
                    FROM dbamv.config_ffis conf
                        WHERE conf.CD_PARAMETRO = :"SYS_B_3" )) ORDER BY CD_ATENDIMENTO DESC) f2n_table)
                            WHERE RECNUM >= :1
                                AND RECNUM <= :2
---- Nova Linha ---- -- 15/05/2026 11:40:56

select count(*)
    as total_count
    from (SELECT :"SYS_B_0" X
        FROM DBAMV.ATENDIME
            WHERE CD_MULTI_EMPRESA = DBAMV.PKG_MV2000.LE_EMPRESA
                AND (TP_ATENDIMENTO)
                IN (:"SYS_B_1", :"SYS_B_2", :"SYS_B_3")
                AND (CD_CONVENIO)
                IN ((SELECT conf.cd_convenio
                FROM dbamv.config_ffis conf
                    WHERE conf.CD_PARAMETRO = :"SYS_B_4" )))
---- Nova Linha ---- -- 15/05/2026 11:42:33

SELECT :"SYS_B_0"
    FROM dbamv.reg_fat reg, dbamv.remessa_fatura remFat
        WHERE reg.cd_remessa = remFat.cd_remessa
            AND remFat.sn_suspensas = :"SYS_B_1"
            AND reg.cd_reg_fat = :1
            AND reg.cd_reg_fat_pai IS NOT NULL
---- Nova Linha ---- -- 15/05/2026 11:42:33

SELECT Cd_Prestador
    FROM ItReg_Fat
        WHERE Cd_Reg_Fat = :1
            AND Cd_Procedimento = :2
