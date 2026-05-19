-- DBAMV.ITPRE_MED definição

CREATE TABLE "DBAMV"."ITPRE_MED"
   (	"CD_ITPRE_MED" NUMBER(10,0) NOT NULL ENABLE,
	"CD_TIP_ESQ" VARCHAR2(3) NOT NULL ENABLE,
	"CD_TIP_PRESC" NUMBER(8,0) NOT NULL ENABLE,
	"CD_PRE_MED" NUMBER(8,0) NOT NULL ENABLE,
	"CD_SET_EXA" NUMBER,
	"CD_TIP_FRE" NUMBER(4,0),
	"CD_FOR_APL" VARCHAR2(4),
	"QT_ITPRE_MED" NUMBER(10,4),
	"DS_ITPRE_MED" VARCHAR2(2000),
	"TP_SITUACAO" VARCHAR2(1),
	"DH_INICIAL" DATE,
	"TP_LOCAL_EXAME" VARCHAR2(1),
	"SN_COPIA" VARCHAR2(1),
	"SN_CANCELADO" VARCHAR2(1) DEFAULT 'N',
	"CD_UNIDADE" VARCHAR2(8),
	"CD_PRODUTO" NUMBER,
	"CD_UNI_PRO" NUMBER(8,0),
	"CD_IMPORTA_REG_FAT" NUMBER(5,0),
	"CD_IMPORTA_REG_AMB" NUMBER(5,0),
	"CD_PRESTADOR" NUMBER(12,0),
	"DH_FINAL" DATE,
	"DH_CANCELADO" DATE,
	"CD_PREST_CANC" NUMBER(12,0),
	"CD_PRE_USO" NUMBER(10,0),
	"DS_NPADRONIZADO" VARCHAR2(60),
	"CD_NPADRONIZADO" NUMBER(8,0),
	"DS_JUSTIFICATIVA" VARCHAR2(2000),
	"CD_ITPRE_MED_CANC" NUMBER(10,0),
	"NR_AGRUPAMENTO" NUMBER(2,0),
	"QT_INFUSAO" NUMBER(10,4),
	"CD_UNI_PRO_INF" NUMBER(8,0),
	"TP_TEMPO" VARCHAR2(1),
	"QT_DIAS" NUMBER(3,0),
	"NR_DIA" NUMBER(10,0),
	"CD_ITPRE_PAD" NUMBER(10,0),
	"TP_JUSTIFICATIVA" VARCHAR2(3),
	"TP_DET_JUSTIFICATIVA" VARCHAR2(4),
	"SN_SOLICITA" VARCHAR2(1) DEFAULT 'S',
	"SN_URGENTE" VARCHAR2(1),
	"CD_TIP_FRE_DET" NUMBER(2,0),
	"CD_ITPRE_MED_COPIA" NUMBER(10,0),
	"QT_ITPRE_MED_CALCULADO" NUMBER(10,4),
	"SN_SOMENTE_HOJE" VARCHAR2(1) DEFAULT 'N',
	"CD_FORMULA" NUMBER(4,0),
	"CD_UNI_PRESC" NUMBER(8,0),
	"HR_DURACAO" DATE,
	"CD_UNI_PRESC_INF" NUMBER(8,0),
	"CD_ITPRE_MED_JUSTIFICATIVA" NUMBER(10,0),
	"SN_ATM_PRORROGACAO" VARCHAR2(1) DEFAULT 'N' NOT NULL ENABLE,
	"CD_ITPRE_MED_TRATMT" NUMBER(10,0),
	"CD_MATERIAL" NUMBER(4,0),
	"DH_REGISTRO" DATE DEFAULT sysdate,
	"CD_GRUPO_PRESCRICAO_ITPRE_MED" NUMBER(10,0),
	"QT_DOSE_PADRAO" NUMBER(14,4),
	"NR_ORDEM" NUMBER,
	"CD_ITPRE_MED_INTEGRA" VARCHAR2(50),
	"CD_SEQ_INTEGRA" NUMBER(20,0),
	"DT_INTEGRA" DATE,
	"SN_ALERTA_PERSISTIDO" VARCHAR2(1),
	"SN_COPIA_IDENTICA" VARCHAR2(1),
	"DS_OBSERVACAO_AUTOMATICA" VARCHAR2(4000),
	"DS_OBSERVACAO_APRAZAMENTO" VARCHAR2(4000),
	"CD_USUARIO_OBSERVACAO_APRAZA" VARCHAR2(30),
	"SN_KIT_PADRAO_ALTERADO" VARCHAR2(1) DEFAULT 'N',
	"CD_CONFIGURACAO_PADRAO_ITEM" NUMBER(13,0),
	"CD_LOCAL_ANATOMICO_COLETA" NUMBER,
	"CD_DISPOSITIVO" NUMBER,
	"SN_PREPARACAO" CHAR(1),
	"SN_HORARIO_GERADO" VARCHAR2(1),
	"SN_CONTINUO" VARCHAR2(1),
	"CD_TIP_FRE_APRAZAMENTO" NUMBER(4,0),
	"NM_EXIBICAO_OBSERVACAO_AUTOMAT" VARCHAR2(40),
	"NM_EXIBICAO_COMPONENTES" VARCHAR2(60),
	"DS_UNIDADE_FORMULA" VARCHAR2(30),
	"QTD_VOLUME_TOTAL" NUMBER(10,4),
	"CD_UNID_VOL_TOTAL" NUMBER(8,0),
	"CD_CID" VARCHAR2(6),
	"CD_CONFIGURACAO_CURVA" NUMBER,
	"SN_CURVA_PADRAO_AUTO" VARCHAR2(1),
	"DS_MATERIAL_COMPLEMENTAR" VARCHAR2(255),
	"NR_PERCENTUAL_REDUCAO_QUANTD" NUMBER(4,2),
	"SN_REDUZIR_QUANTIDADE" VARCHAR2(1),
	"SN_FINAL_CICLO_NOTIFICADO" VARCHAR2(1),
	"SN_CRONICO" VARCHAR2(1),
	"NR_DIAS" NUMBER,
	"NR_HORA" NUMBER,
	"NR_MINUTO" NUMBER,
	"CD_MULTI_EMPRESA" NUMBER(4,0),
	"TP_FASE_QT" VARCHAR2(3),
	"QTD_TOTAL_DISPENSAR" NUMBER(10,4),
	"SN_PESQUISA_CIENTIFICA" VARCHAR2(1),
	"SN_REAVALICAO_MEDICA" VARCHAR2(1),
	"CD_UNID_PRESC_VOL_TOTAL" NUMBER,
	 CONSTRAINT "CNT_ITPRE_MED_REAVAL_MED_CK" CHECK (

    SN_REAVALICAO_MEDICA IN ('S', 'N')

  ) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_HR_GERADO_CK" CHECK (SN_HORARIO_GERADO IN ('S','N')) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_CONTINUO_CK" CHECK (SN_CONTINUO IN ('S','N')) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_11_CK" CHECK (

    TP_SITUACAO IN ('N', 'S', 'A')

  ) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_26_CK" CHECK (TP_FASE_QT IN ('PRE','QT','POS')) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_9_CK" CHECK (

    sn_kit_padrao_alterado IN ('S', 'N')

  ) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_10_CK" CHECK (

    SN_PREPARACAO IN ('S','N')

  ) ENABLE,
	 CONSTRAINT "SYS_C00146569" CHECK ( tp_local_exame IN ( 'S' , 'L' )  ) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_PESQUISA_CK" CHECK (SN_PESQUISA_CIENTIFICA IN ('S','N')) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_5_CK" CHECK (SN_ATM_PRORROGACAO IN ('S','N')) ENABLE,
	 CONSTRAINT "AVCON_258539_TP_TE_000" CHECK (TP_TEMPO IN ('H', 'M')) ENABLE,
	 CONSTRAINT "ITPRE_MED_PK" PRIMARY KEY ("CD_ITPRE_MED")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I"  ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_2_CK" CHECK (
   Sn_Solicita Is Not Null
 ) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_3_CK" CHECK (
   Sn_Solicita In ('S', 'N' )
 ) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_4_CK" CHECK (SN_URGENTE IN ('N', 'S')) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_ALERTA_PERST_CK" CHECK (sn_alerta_persistido in ('S', 'N')) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_12_CK" CHECK (

    SN_CURVA_PADRAO_AUTO IN ('S', 'N')

  ) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_13_CK" CHECK (

    SN_FINAL_CICLO_NOTIFICADO IN ('S', 'N')

  ) ENABLE,
	 CONSTRAINT "ITPRE_MED_SN_CRONICO" CHECK (

    SN_CRONICO IN ('S', 'N')

  ) ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_UNI_PRESC_3_FK" FOREIGN KEY ("CD_UNID_PRESC_VOL_TOTAL")
	  REFERENCES "DBAMV"."UNI_PRESC" ("CD_UNI_PRESC") ENABLE,
	 CONSTRAINT "CNT_ITPREMED_TIPFRE_3_FK" FOREIGN KEY ("CD_TIP_FRE_APRAZAMENTO")
	  REFERENCES "DBAMV"."TIP_FRE" ("CD_TIP_FRE") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_MULTI_EMPRESA_FK" FOREIGN KEY ("CD_MULTI_EMPRESA")
	  REFERENCES "DBAMV"."MULTI_EMPRESAS" ("CD_MULTI_EMPRESA") ENABLE,
	 CONSTRAINT "ITPRE_MED_USUARIOS_FK" FOREIGN KEY ("CD_USUARIO_OBSERVACAO_APRAZA")
	  REFERENCES "DBASGU"."USUARIOS" ("CD_USUARIO") ENABLE,
	 CONSTRAINT "CNT_ITPRE_M_PW_GR_PRE_ITP_M_FK" FOREIGN KEY ("CD_GRUPO_PRESCRICAO_ITPRE_MED")
	  REFERENCES "DBAMV"."PW_GRUPO_PRESCRICAO_ITPRE_MED" ("CD_GRUPO_PRESCRICAO_ITPRE_MED") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_ITPRE_MED_FK" FOREIGN KEY ("CD_ITPRE_MED_TRATMT")
	  REFERENCES "DBAMV"."ITPRE_MED" ("CD_ITPRE_MED") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_MATERIAL_FK" FOREIGN KEY ("CD_MATERIAL")
	  REFERENCES "DBAMV"."MATERIAL" ("CD_MATERIAL") ENABLE,
	 CONSTRAINT "ITPRE_MED_FOR_APL_FK" FOREIGN KEY ("CD_FOR_APL")
	  REFERENCES "DBAMV"."FOR_APL" ("CD_FOR_APL") ENABLE,
	 CONSTRAINT "ITPRE_MED_UNIDADE_FK" FOREIGN KEY ("CD_UNIDADE")
	  REFERENCES "DBAMV"."UNIDADE" ("CD_UNIDADE") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_UNI_PRESC_1_FK" FOREIGN KEY ("CD_UNI_PRESC")
	  REFERENCES "DBAMV"."UNI_PRESC" ("CD_UNI_PRESC") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_UNI_PRESC_2_FK" FOREIGN KEY ("CD_UNI_PRESC_INF")
	  REFERENCES "DBAMV"."UNI_PRESC" ("CD_UNI_PRESC") ENABLE,
	 CONSTRAINT "ITPRE_MED_UNI_PRO_FK" FOREIGN KEY ("CD_UNI_PRO")
	  REFERENCES "DBAMV"."UNI_PRO" ("CD_UNI_PRO") ENABLE,
	 CONSTRAINT "TIP_ESQ_ITPRE_MED_FK" FOREIGN KEY ("CD_TIP_ESQ")
	  REFERENCES "DBAMV"."TIP_ESQ" ("CD_TIP_ESQ") ENABLE,
	 CONSTRAINT "CNT_ITPREMED_TIPFRE_2_FK" FOREIGN KEY ("CD_TIP_FRE_DET")
	  REFERENCES "DBAMV"."TIP_FRE" ("CD_TIP_FRE") ENABLE,
	 CONSTRAINT "ITPRE_MED_TIP_FRE_FK" FOREIGN KEY ("CD_TIP_FRE")
	  REFERENCES "DBAMV"."TIP_FRE" ("CD_TIP_FRE") ENABLE,
	 CONSTRAINT "ITPRE_MED_TIP_PRESC_FK" FOREIGN KEY ("CD_TIP_PRESC")
	  REFERENCES "DBAMV"."TIP_PRESC" ("CD_TIP_PRESC") ENABLE,
	 CONSTRAINT "ITPRE_MED_SET_EXA_FK" FOREIGN KEY ("CD_SET_EXA")
	  REFERENCES "DBAMV"."SET_EXA" ("CD_SET_EXA") ENABLE,
	 CONSTRAINT "ITPRE_MED_PRE_MED_FK" FOREIGN KEY ("CD_PRE_MED")
	  REFERENCES "DBAMV"."PRE_MED" ("CD_PRE_MED") ENABLE,
	 CONSTRAINT "ITPRE_MED_PRE_USO_FK" FOREIGN KEY ("CD_PRE_USO")
	  REFERENCES "DBAMV"."PRE_USO" ("CD_PRE_USO") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_PROC_DET_1_FK" FOREIGN KEY ("TP_JUSTIFICATIVA", "TP_DET_JUSTIFICATIVA")
	  REFERENCES "DBAMV"."PROCESSO_DETALHE_MV" ("CD_PROCESSO", "CD_DET_PROCESSO") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_PROC_MV_1_FK" FOREIGN KEY ("TP_JUSTIFICATIVA")
	  REFERENCES "DBAMV"."PROCESSO_MV" ("CD_PROCESSO") ENABLE,
	 CONSTRAINT "ITPRE_MED_PRODUTO_FK" FOREIGN KEY ("CD_PRODUTO")
	  REFERENCES "DBAMV"."PRODUTO" ("CD_PRODUTO") ENABLE,
	 CONSTRAINT "ITPRE_MED_NPADRONIZADO_FK" FOREIGN KEY ("CD_NPADRONIZADO")
	  REFERENCES "DBAMV"."PRODUTO" ("CD_PRODUTO") ENABLE,
	 CONSTRAINT "ITPRE_MED_PRESTADOR_FK" FOREIGN KEY ("CD_PRESTADOR")
	  REFERENCES "DBAMV"."PRESTADOR" ("CD_PRESTADOR") ENABLE,
	 CONSTRAINT "ITPRE_MED_PRESTADOR_FK2" FOREIGN KEY ("CD_PREST_CANC")
	  REFERENCES "DBAMV"."PRESTADOR" ("CD_PRESTADOR") ENABLE,
	 CONSTRAINT "CNT_ITPREMED_FORM_1_FK" FOREIGN KEY ("CD_FORMULA")
	  REFERENCES "DBAMV"."PAGU_FORMULA" ("CD_FORMULA") ENABLE,
	 CONSTRAINT "CNT_ITPREMED_JUSTIFIC_1_FK" FOREIGN KEY ("CD_ITPRE_MED_JUSTIFICATIVA")
	  REFERENCES "DBAMV"."ITPRE_MED_JUSTIFICATIVA" ("CD_ITPRE_MED_JUSTIFICATIVA") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_ITPRE_PAD_1_FK" FOREIGN KEY ("CD_ITPRE_PAD")
	  REFERENCES "DBAMV"."ITPRE_PAD" ("CD_ITPRE_PAD") ENABLE,
	 CONSTRAINT "ITPRE_MED_ITPRE_MED_CANC_FK" FOREIGN KEY ("CD_ITPRE_MED_CANC")
	  REFERENCES "DBAMV"."ITPRE_MED" ("CD_ITPRE_MED") ENABLE,
	 CONSTRAINT "ITPRE_MED_UNI_VOL_TOTAL_FK" FOREIGN KEY ("CD_UNID_VOL_TOTAL")
	  REFERENCES "DBAMV"."UNI_PRO" ("CD_UNI_PRO") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_CID_FK" FOREIGN KEY ("CD_CID")
	  REFERENCES "DBAMV"."CID" ("CD_CID") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_CONFIG_CURVA_FK" FOREIGN KEY ("CD_CONFIGURACAO_CURVA")
	  REFERENCES "DBAMV"."CONFIGURACAO_CURVA" ("CD_CONFIGURACAO_CURVA") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_LOC_ANAT_COL_FK" FOREIGN KEY ("CD_LOCAL_ANATOMICO_COLETA")
	  REFERENCES "DBAMV"."LOCAL_ANATOMICO_COLETA" ("CD_LOCAL_ANATOMICO_COLETA") ENABLE,
	 CONSTRAINT "CNT_ITPRE_MED_DISPOSITIVO_FK" FOREIGN KEY ("CD_DISPOSITIVO")
	  REFERENCES "DBAMV"."PW_DISPOSITIVO" ("CD_DISPOSITIVO") ENABLE
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_D" ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PAGU_VINCULA_GRUPO_PRESC"
BEFORE  INSERT ON dbamv.itpre_med
 REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
 CURSOR C_CdGruEsq (pcd_premed NUMBER, pcd_tip_presc VARCHAR2 ) IS
    SELECT pw_grupo_prescricao_itpre_med.cd_grupo_prescricao_itpre_med
    FROM dbamv.pw_grupo_prescricao_itpre_med,
         dbamv.pw_grupo_prescricao_tipo_esqm,
         dbamv.tip_presc
   WHERE tip_presc.cd_tip_esq = pw_grupo_prescricao_tipo_esqm.cd_tip_esq
     AND pw_grupo_prescricao_itpre_med.cd_grupo_prescricao = pw_grupo_prescricao_tipo_esqm.cd_grupo_prescricao
     AND pw_grupo_prescricao_itpre_med.cd_pre_med = pcd_premed
     AND tip_presc.cd_tip_presc = pcd_tip_presc;
 vCdGruEsq NUMBER;
BEGIN
  OPEN  C_CdGruEsq(:new.cd_pre_med,:new.cd_tip_presc);
  FETCH C_CdGruEsq INTO vCdGruEsq;
  CLOSE C_CdGruEsq;
  IF :new.cd_grupo_prescricao_itpre_med IS NULL THEN
    :new.cd_grupo_prescricao_itpre_med := vCdGruEsq;
  END IF;
END;




/
ALTER TRIGGER "DBAMV"."TRG_PAGU_VINCULA_GRUPO_PRESC" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_SUSPENDE_PRESC_FFCV"
BEFORE  UPDATE  ON DBAMV.ITPRE_MED
REFERENCING
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW
Declare
/****************************************************************************************************************
AUTOR..........: Alexandre Erik C. M. Costa
DATA ..........: 21/07/2004
FUNCIONALIDADE.: Trigger para realizar a exclusão dos itens da conta quando um item de prescrição for suspenso
*****************************************************************************************************************/
  Cursor c_pre_med Is
    Select Atendime.Tp_Atendimento
         , Atendime.cd_atendimento
         , pre_med.dt_pre_med
         , pre_med.hr_pre_med
         , pre_med.cd_unid_int
         , pre_med.cd_prestador
         , nvl(unid_int.cd_setor, pre_med.cd_setor) cd_setor
	    From Dbamv.Pre_Med, Dbamv.Atendime, dbamv.unid_int
	   Where Pre_Med.Cd_Atendimento = Atendime.Cd_Atendimento
	     and atendime.cd_multi_empresa = dbamv.Pkg_Mv2000.Le_Empresa
       And pre_med.cd_unid_int    = unid_int.cd_unid_int(+)
	     And Pre_Med.Cd_Pre_Med     = Nvl( :NEW.cd_pre_med, :OLD.cd_pre_med );
  --
  Cursor C_Cirurgiao is
     Select ati_med.cd_ati_med
     From   dbamv.ati_med
     where  ati_med.tp_funcao = 'C';
  --
  Cursor C_Tp_convenio is
    Select tp_convenio
    From dbamv.convenio   convenio,
         dbamv.atendime   atendime,
         dbamv.pre_med    pre_med,
	 dbamv.empresa_convenio
    Where atendime.cd_atendimento = Pre_med.cd_atendimento
    and atendime.cd_multi_empresa = dbamv.Pkg_Mv2000.Le_Empresa
    and convenio.cd_convenio = empresa_convenio.cd_convenio /* pda 118607/129023*/
    and empresa_convenio.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa /* pda 118607/129023*/
    and convenio.cd_convenio = atendime.cd_convenio
    And Pre_med.cd_pre_med = NVL(:NEW.cd_pre_med,:OLD.cd_pre_med) ;
  --
  Cursor C_Componentes is
    Select cd_itpre_med, cd_tip_presc, qt_componente, tp_componente, cd_unidade,
           cd_uni_pro, cd_produto, sn_fatura, ds_citpre_med, ds_npadronizado
      from dbamv.citpre_med
     where cd_itpre_med = :old.cd_itpre_med;
  --
  Cursor C_pitpre_med is
    Select cd_prestador, cd_ati_med
      from dbamv.pitpre_med
     where cd_itpre_med = :old.cd_itpre_med;
  --
    -- PDA 114439 (Início) - 27/01/2005 - Pollyane Kely Alves Nunes
  -- Retornando os horários para multiplicar pela quantidade lançada
  Cursor cHorario is
    select count(*) qt_horarios
      from dbamv.hritpre_med
     where hritpre_med.cd_itpre_med = NVL(:NEW.cd_itpre_med,:OLD.cd_itpre_med);
  -- PDA 114439 (Fim)
  vPre_Med   c_pre_med%rowtype;
  vTip_Conv  Dbamv.convenio.tp_convenio%type;
  cTp_Atendimento  Varchar2(1);
  vCdAtiMed        Varchar2(2);
  cTpAtend         Varchar2(1);
  -- PDA 114439 (Início) - 27/01/2005 - Pollyane Kely Alves Nunes
  -- Delaração da variável que irá quardar a quantidade
  nHorario        Number;
  -- PDA 114439 (Fim)
Begin
 If    nvl(:new.sn_cancelado, :old.sn_cancelado) = 'S'
   And nvl(:new.cd_itpre_med_canc, :old.cd_itpre_med_canc) is null
   And :new.Sn_solicita = 'S' Then--PDA 95239
   Open  c_pre_med;
   Fetch c_pre_med Into vPre_Med;
   Close c_pre_med;
   Open  C_Tp_convenio;
   Fetch C_Tp_convenio Into vTip_Conv;
   Close C_Tp_convenio;
   -- PDA 114439 (Início) - 27/01/2005 - Pollyane Kely Alves Nunes
   -- Retornando os horários para multiplicar pela quantidade lançada
    Open cHorario;
      Fetch cHorario into nHorario;
    Close cHorario;
    if nvl(nHorario,0) = 0 then
      nHorario := 1;
    end if;
   -- PDA 114439 (Fim)
   If  vTip_Conv  not in ('H', 'A') then   -- alteração feita  em 09/11/2002 PDA 61454
     If vPre_Med.Tp_Atendimento = 'I' Then
        For c_comp in C_Componentes Loop
            If c_comp.sn_fatura = 'S' then
               dbamv.pack_lanca_ffcv.Lanca_Componente_FFCV( Nvl( :OLD.cd_itpre_med, :NEW.cd_itpre_med ),
                                                            c_comp.cd_tip_presc,
                                                            null,
                                                            -- PDA 114439 (Início) - 27/01/2005 - Pollyane K. A. Nunes
                                                            -- Passando a quantidade do componente, multiplicado pelos horários
                                                            -- c_comp.qt_componente,
                                                            c_comp.qt_componente * nHorario,
                                                            -- PDA 114439 (Fim)
                                                            'D',
                                                            vPre_Med.cd_atendimento,
                                                            vPre_Med.dt_pre_med,
                                                            vPre_Med.hr_pre_med,
                                                            vPre_Med.cd_unid_int,
                                                            -- pda 104693 - 25/11/2004 - Amalia Araújo
                                                            -- Corrigindo erro de trigger mutante
                                                            -- vPre_Med.cd_prestador,
                                                            Nvl( :New.Cd_Prestador, vPre_Med.cd_prestador ),
                                                            -- pda 104693 - fim
                                                            vPre_Med.cd_setor);
            End If;
        End Loop;
        For p_it in C_pitpre_med Loop
            Dbamv.Lanca_Ffcv_Equipe_Pagu( Nvl( :OLD.cd_pre_med, :NEW.cd_pre_med ),
                                          Nvl( :OLD.cd_itpre_med, :NEW.cd_itpre_med ),
                                          Nvl( :OLD.cd_tip_presc, :NEW.cd_tip_presc ),
                                          p_it.cd_prestador,
                                          p_it.cd_ati_med,
                                          'D',
                                          vPre_Med.cd_atendimento,
                                          vPre_Med.dt_pre_med,
                                          vPre_Med.hr_pre_med,
                                          vPre_Med.cd_unid_int,
                                          vPre_Med.cd_prestador,
                                          vPre_Med.cd_setor);
        End Loop;
        Dbamv.Pack_Lanca_Ffcv.Lanca_Pagu_Ffcv( Nvl( :OLD.cd_pre_med, :NEW.cd_pre_med ),
                                               Null,  -->> Devolução de Prescrição
                                               Nvl( :OLD.cd_tip_presc, :NEW.cd_tip_presc ),
                                               Nvl( :OLD.cd_prestador, :NEW.cd_prestador ),
                                               Nvl( :OLD.cd_set_exa, :NEW.cd_set_exa ),
                                               null,
                                               -- PDA 114439 (Início) - 27/01/2005 - Pollyane K. A. Nunes
                                               -- Passando a quantidade lançada multiplicada pelo horário.
                                               --Nvl(:OLD.qt_itpre_med, :NEW.qt_itpre_med),
                                               Nvl(:OLD.qt_itpre_med, :NEW.qt_itpre_med) * nHorario,
                                               -- PDA 114439 (Fim)
                                               'D',
                                               Nvl( :OLD.cd_ItPre_med, :NEW.cd_ItPre_med ) ,
                                               null ,
                                               Nvl( :OLD.dh_cancelado, :NEW.dh_cancelado ) ,
                                               vPre_Med.cd_atendimento,
                                               vPre_Med.dt_pre_med,
                                               vPre_Med.hr_pre_med,
                                               vPre_Med.cd_unid_int,
                                               vPre_Med.cd_prestador) ;
     Else
       Open  C_Cirurgiao;
       Fetch C_Cirurgiao into vCdAtiMed;
       Close C_Cirurgiao;
       For c_comp in C_Componentes Loop
            If c_comp.sn_fatura = 'S' then
               cTpAtend := Dbamv.Lanca_Pagu_Amb_Ffc ( ncdproduto     => Null
                                                     ,ncddevpre      => Null
                                                     ,ncdtippresc    => c_comp.cd_tip_presc
                                                     ,nqtmovnew     => null
                                                     -- PDA 114439 (Início) - 27/01/2005 - Pollyane K. A. Nunes
                                                     -- Passando a quantidade lançada multiplicada pelo horário.
                                                     -- ,nqtmovold     => c_comp.qt_componente
                                                     ,nqtmovold     => c_comp.qt_componente * nHorario
                                                     -- PDA 114439 (Fim)
                                                     ,ncdpremed     => Nvl(:Old.cd_pre_med, :New.cd_pre_med )
                                                     ,caction      => 'D'
                                                     ,csnitempertencepacote => 'N'
                                                     ,ncditpre_med          => Nvl(:Old.cd_itpre_med, :New.cd_itpre_med )
                                                     ,ncdprestador          => Nvl(:Old.cd_prestador, :New.cd_prestador )
                                                     ,ncdatimed             => vCdAtiMed
                                                     ,pncdatendimento       => vPre_Med.cd_atendimento
                                                     ,pddtpremed         => vPre_Med.dt_pre_med
                                                     ,pdhrpremed         => vPre_Med.hr_pre_med
                                                     ,pncdunidint        => vPre_Med.cd_unid_int
                                                     ,pncdprestadorpresc => vPre_Med.cd_prestador
                                                     ,pncdsetor          => vPre_Med.cd_setor
                                                     ,pnSetorExa         => Nvl( :OLD.cd_set_exa, :NEW.cd_set_exa ) );
            End If;
       End Loop;
       For p_it in C_pitpre_med Loop
            Dbamv.Lanca_Ffcv_Equipe_Pagu( Nvl( :OLD.cd_pre_med, :NEW.cd_pre_med ),
                                          Nvl( :OLD.cd_itpre_med, :NEW.cd_itpre_med ),
                                          Nvl( :OLD.cd_tip_presc, :NEW.cd_tip_presc ),
                                          p_it.cd_prestador,
                                          p_it.cd_ati_med,
                                          'D',
                                          vPre_Med.cd_atendimento,
                                          vPre_Med.dt_pre_med,
                                          vPre_Med.hr_pre_med,
                                          vPre_Med.cd_unid_int,
                                          vPre_Med.cd_prestador,
                                          vPre_Med.cd_setor);
            cTpAtend := Dbamv.Lanca_Pagu_Amb_Ffc ( ncdproduto     => Null
                                                  ,ncddevpre      => Null
                                                  ,ncdtippresc    => Nvl( :OLD.cd_tip_presc, :NEW.cd_tip_presc )
                                                  ,nqtmovnew     => 0
                                                  ,nqtmovold     => 1
                                                  ,ncdpremed     => Nvl( :OLD.cd_pre_med, :NEW.cd_pre_med )
                                                  ,caction       => 'D'
                                                  ,csnitempertencepacote   => 'N'
                                                  ,ncditpre_med            => Nvl(:Old.cd_itpre_med, :New.cd_itpre_med )
                                                  ,ncdprestador            => p_it.cd_prestador
                                                  ,ncdatimed               => p_it.cd_ati_med
                                                  ,pncdatendimento         => vPre_Med.cd_atendimento
                                                  ,pddtpremed              => vPre_Med.dt_pre_med
                                                  ,pdhrpremed              => vPre_Med.hr_pre_med
                                                  ,pncdunidint             => vPre_Med.cd_unid_int
                                                  ,pncdprestadorpresc      => vPre_Med.cd_prestador
                                                  ,pncdsetor               => vPre_Med.cd_setor
                                                  ,pnSetorExa              => Nvl( :OLD.cd_set_exa, :NEW.cd_set_exa ));
        End Loop;
         cTpAtend := Dbamv.Lanca_Pagu_Amb_Ffc ( ncdproduto            => Null
                                             ,ncddevpre               => Null
                                             ,ncdtippresc             => Nvl( :Old.cd_tip_presc, :New.cd_tip_presc )
                                             ,nqtmovnew               => null
                                             -- PDA 114439 (Início) - 27/01/2005 - Pollyane K. A. Nunes
                                             -- Passando a quantidade lançada multiplicada pelo horário.
                                             --,nqtmovold               => Nvl(:Old.qt_itpre_med, :New.qt_itpre_med)
                                             ,nqtmovold               => Nvl(:Old.qt_itpre_med, :New.qt_itpre_med) * nHorario
                                             -- PDA 114439 (Fim)
                                             ,ncdpremed               => Nvl(:Old.cd_pre_med, :New.cd_pre_med )
                                             ,caction                 => 'D'
                                             ,csnitempertencepacote   => 'N'
                                             ,ncditpre_med            => Nvl(:Old.cd_itpre_med, :New.cd_itpre_med )
                                             ,ncdprestador            => Nvl(:Old.cd_prestador, :New.cd_prestador )
                                             ,ncdatimed               => vCdAtiMed
                                             ,pncdatendimento         => vPre_Med.cd_atendimento
                                             ,pddtpremed              => vPre_Med.dt_pre_med
                                             ,pdhrpremed              => vPre_Med.hr_pre_med
                                             ,pncdunidint             => vPre_Med.cd_unid_int
                                             ,pncdprestadorpresc      => vPre_Med.cd_prestador
                                             ,pncdsetor               => vPre_Med.cd_setor
                                             ,pnSetorExa              => Nvl( :OLD.cd_set_exa, :NEW.cd_set_exa )); -- pda 112225
     End If;
   End If;
 End If;
End ;






/
ALTER TRIGGER "DBAMV"."TRG_SUSPENDE_PRESC_FFCV" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_LOG_ITPRE_MED_TRATAMENTO"
 After Insert
    Or Update
    Or Delete
    On dbamv.itpre_med
 Referencing New as New
             Old as Old
 For Each Row
Declare
 Cursor cPreMed
       (pnCdPreMed Number)
     Is Select Pre_Med.Cd_Pre_Med_Tratmt
          From Dbamv.Pre_Med
         Where Pre_Med.Cd_Pre_Med = pnCdPreMed;
 nCdPrestador Dbamv.Prestador.Cd_Prestador%Type := Dbamv.Pkg_Pagu.Fn_Prestador().Cd_Prestador;
 rPreMed      cPreMed%RowType;
 vTpOperacao  Varchar2 (3);
Begin
     If Nvl(:New.Cd_ItPre_Med_Tratmt, :Old.Cd_ItPre_Med_Tratmt) Is Null Then -- Se o item não pertencer a algum tratamento, então não precisa realizar o log nessa trigger
        Return;
     End If;
     --
     Open  cPreMed (Nvl(:New.Cd_Pre_Med, :Old.Cd_Pre_Med));
     Fetch cPreMed Into rPreMed;
     Close cPreMed;
     --
     If     Inserting Then
            vTpOperacao := 'Inc';
     Elsif  Updating  Then
            vTpOperacao := 'Alt';
            If  Nvl(:Old.Sn_Cancelado,'N') = 'N' And Nvl(:New.Sn_Cancelado,'N') = 'S' Then
                vTpOperacao := 'Sus';
            End If;
     Else
            vTpOperacao := 'Exc';
     End If;
     --
     If  rPreMed.Cd_Pre_Med_Tratmt Is Not Null Then
         If  Inserting Then
             Insert into Dbamv.Log_Itpre_Med_Tratamento
               (Cd_Log_Itpre_Med_Tratamento
              , Cd_Pre_Med_Tratmt
              , Dh_Operacao
              , Tp_Operacao
              , Cd_Prestador_Operacao
              , Cd_Usuario
              , Cd_Itpre_Med
              , Cd_Tip_Esq
              , Cd_Tip_Presc
              , Cd_Pre_Med
              , Cd_Set_Exa
              , Cd_Tip_Fre
              , Cd_For_Apl
              , Qt_Itpre_Med
              , Ds_Itpre_Med
              , Tp_Situacao
              , Dh_Inicial
              , Tp_Local_Exame
              , Sn_Copia
              , Sn_Cancelado
              , Cd_Unidade
              , Cd_Produto
              , Cd_Uni_Pro
              , Cd_Importa_Reg_Fat
              , Cd_Importa_Reg_Amb
              , Cd_Prestador
              , Dh_Final
              , Dh_Cancelado
              , Cd_Prest_Canc
              , Cd_Pre_Uso
              , Ds_Npadronizado
              , Cd_Npadronizado
              , Ds_Justificativa
              , Cd_Itpre_Med_Canc
              , Nr_Agrupamento
              , Qt_Infusao
              , Cd_Uni_Pro_Inf
              , Tp_Tempo
              , Qt_Dias
              , Nr_Dia
              , Cd_Itpre_Pad
              , Tp_Justificativa
              , Tp_Det_Justificativa
              , Sn_Urgente
              , Cd_Tip_Fre_Det
              , Sn_Solicita
              , Cd_Itpre_Med_Copia
              , Qt_Itpre_Med_Calculado
              , Sn_Somente_Hoje
              , Cd_Formula
              , Cd_Uni_Presc
              , Hr_Duracao
              , Cd_Uni_Presc_Inf
              , Cd_Itpre_Med_Justificativa
              , Sn_Atm_Prorrogacao
              , Cd_Itpre_Med_Tratmt)
            Values (Dbamv.Seq_Log_Itpre_Med_Tratamento.NextVal
              , rPreMed.Cd_Pre_Med_Tratmt
              , Sysdate
              , vTpOperacao
              , nCdPrestador
              , Dbamv.Pkg_Mv_Variaveis.Fnc_Get_Usuario
              , :New.Cd_Itpre_Med
              , :New.Cd_Tip_Esq
              , :New.Cd_Tip_Presc
              , :New.Cd_Pre_Med
              , :New.Cd_Set_Exa
              , :New.Cd_Tip_Fre
              , :New.Cd_For_Apl
              , :New.Qt_Itpre_Med
              , :New.Ds_Itpre_Med
              , :New.Tp_Situacao
              , :New.Dh_Inicial
              , :New.Tp_Local_Exame
              , :New.Sn_Copia
              , :New.Sn_Cancelado
              , :New.Cd_Unidade
              , :New.Cd_Produto
              , :New.Cd_Uni_Pro
              , :New.Cd_Importa_Reg_Fat
              , :New.Cd_Importa_Reg_Amb
              , :New.Cd_Prestador
              , :New.Dh_Final
              , :New.Dh_Cancelado
              , :New.Cd_Prest_Canc
              , :New.Cd_Pre_Uso
              , :New.Ds_Npadronizado
              , :New.Cd_Npadronizado
              , :New.Ds_Justificativa
              , :New.Cd_Itpre_Med_Canc
              , :New.Nr_Agrupamento
              , :New.Qt_Infusao
              , :New.Cd_Uni_Pro_Inf
              , :New.Tp_Tempo
              , :New.Qt_Dias
              , :New.Nr_Dia
              , :New.Cd_Itpre_Pad
              , :New.Tp_Justificativa
              , :New.Tp_Det_Justificativa
              , :New.Sn_Urgente
              , :New.Cd_Tip_Fre_Det
              , :New.Sn_Solicita
              , :New.Cd_Itpre_Med_Copia
              , :New.Qt_Itpre_Med_Calculado
              , :New.Sn_Somente_Hoje
              , :New.Cd_Formula
              , :New.Cd_Uni_Presc
              , :New.Hr_Duracao
              , :New.Cd_Uni_Presc_Inf
              , :New.Cd_Itpre_Med_Justificativa
              , :New.Sn_Atm_Prorrogacao
              , :New.Cd_Itpre_Med_Tratmt);
         Elsif Updating Then
            --
            Insert into Dbamv.Log_Itpre_Med_Tratamento
               (Cd_Log_Itpre_Med_Tratamento
              , Cd_Pre_Med_Tratmt
              , Dh_Operacao
              , Tp_Operacao
              , Cd_Prestador_Operacao
              , Cd_Usuario
              , Cd_Itpre_Med
              , Cd_Tip_Esq
              , Cd_Tip_Presc
              , Cd_Pre_Med
              , Cd_Set_Exa
              , Cd_Tip_Fre
              , Cd_For_Apl
              , Qt_Itpre_Med
              , Ds_Itpre_Med
              , Tp_Situacao
              , Dh_Inicial
              , Tp_Local_Exame
              , Sn_Copia
              , Sn_Cancelado
              , Cd_Unidade
              , Cd_Produto
              , Cd_Uni_Pro
              , Cd_Importa_Reg_Fat
              , Cd_Importa_Reg_Amb
              , Cd_Prestador
              , Dh_Final
              , Dh_Cancelado
              , Cd_Prest_Canc
              , Cd_Pre_Uso
              , Ds_Npadronizado
              , Cd_Npadronizado
              , Ds_Justificativa
              , Cd_Itpre_Med_Canc
              , Nr_Agrupamento
              , Qt_Infusao
              , Cd_Uni_Pro_Inf
              , Tp_Tempo
              , Qt_Dias
              , Nr_Dia
              , Cd_Itpre_Pad
              , Tp_Justificativa
              , Tp_Det_Justificativa
              , Sn_Urgente
              , Cd_Tip_Fre_Det
              , Sn_Solicita
              , Cd_Itpre_Med_Copia
              , Qt_Itpre_Med_Calculado
              , Sn_Somente_Hoje
              , Cd_Formula
              , Cd_Uni_Presc
              , Hr_Duracao
              , Cd_Uni_Presc_Inf
              , Cd_Itpre_Med_Justificativa
              , Sn_Atm_Prorrogacao
              , Cd_Itpre_Med_Tratmt)
            Values (Dbamv.Seq_Log_Itpre_Med_Tratamento.NextVal
              , rPreMed.Cd_Pre_Med_Tratmt
              , Sysdate
              , vTpOperacao
              , nCdPrestador
              , Dbamv.Pkg_Mv_Variaveis.Fnc_Get_Usuario
              , :Old.Cd_Itpre_Med
              , :Old.Cd_Tip_Esq
              , :Old.Cd_Tip_Presc
              , :Old.Cd_Pre_Med
              , :Old.Cd_Set_Exa
              , :Old.Cd_Tip_Fre
              , :Old.Cd_For_Apl
              , :Old.Qt_Itpre_Med
              , :Old.Ds_Itpre_Med
              , :Old.Tp_Situacao
              , :Old.Dh_Inicial
              , :Old.Tp_Local_Exame
              , :Old.Sn_Copia
              , :Old.Sn_Cancelado
              , :Old.Cd_Unidade
              , :Old.Cd_Produto
              , :Old.Cd_Uni_Pro
              , :Old.Cd_Importa_Reg_Fat
              , :Old.Cd_Importa_Reg_Amb
              , :Old.Cd_Prestador
              , :Old.Dh_Final
              , :Old.Dh_Cancelado
              , :Old.Cd_Prest_Canc
              , :Old.Cd_Pre_Uso
              , :Old.Ds_Npadronizado
              , :Old.Cd_Npadronizado
              , :Old.Ds_Justificativa
              , :Old.Cd_Itpre_Med_Canc
              , :Old.Nr_Agrupamento
              , :Old.Qt_Infusao
              , :Old.Cd_Uni_Pro_Inf
              , :Old.Tp_Tempo
              , :Old.Qt_Dias
              , :Old.Nr_Dia
              , :Old.Cd_Itpre_Pad
              , :Old.Tp_Justificativa
              , :Old.Tp_Det_Justificativa
              , :Old.Sn_Urgente
              , :Old.Cd_Tip_Fre_Det
              , :Old.Sn_Solicita
              , :Old.Cd_Itpre_Med_Copia
              , :Old.Qt_Itpre_Med_Calculado
              , :Old.Sn_Somente_Hoje
              , :Old.Cd_Formula
              , :Old.Cd_Uni_Presc
              , :Old.Hr_Duracao
              , :Old.Cd_Uni_Presc_Inf
              , :Old.Cd_Itpre_Med_Justificativa
              , :Old.Sn_Atm_Prorrogacao
              , :Old.Cd_Itpre_Med_Tratmt);
            --
            Insert into Dbamv.Log_Itpre_Med_Tratamento
               (Cd_Log_Itpre_Med_Tratamento
              , Cd_Pre_Med_Tratmt
              , Dh_Operacao
              , Tp_Operacao
              , Cd_Prestador_Operacao
              , Cd_Usuario
              , Cd_Itpre_Med
              , Cd_Tip_Esq
              , Cd_Tip_Presc
              , Cd_Pre_Med
              , Cd_Set_Exa
              , Cd_Tip_Fre
              , Cd_For_Apl
              , Qt_Itpre_Med
              , Ds_Itpre_Med
              , Tp_Situacao
              , Dh_Inicial
              , Tp_Local_Exame
              , Sn_Copia
              , Sn_Cancelado
              , Cd_Unidade
              , Cd_Produto
              , Cd_Uni_Pro
              , Cd_Importa_Reg_Fat
              , Cd_Importa_Reg_Amb
              , Cd_Prestador
              , Dh_Final
              , Dh_Cancelado
              , Cd_Prest_Canc
              , Cd_Pre_Uso
              , Ds_Npadronizado
              , Cd_Npadronizado
              , Ds_Justificativa
              , Cd_Itpre_Med_Canc
              , Nr_Agrupamento
              , Qt_Infusao
              , Cd_Uni_Pro_Inf
              , Tp_Tempo
              , Qt_Dias
              , Nr_Dia
              , Cd_Itpre_Pad
              , Tp_Justificativa
              , Tp_Det_Justificativa
              , Sn_Urgente
              , Cd_Tip_Fre_Det
              , Sn_Solicita
              , Cd_Itpre_Med_Copia
              , Qt_Itpre_Med_Calculado
              , Sn_Somente_Hoje
              , Cd_Formula
              , Cd_Uni_Presc
              , Hr_Duracao
              , Cd_Uni_Presc_Inf
              , Cd_Itpre_Med_Justificativa
              , Sn_Atm_Prorrogacao
              , Cd_Itpre_Med_Tratmt)
            Values (Dbamv.Seq_Log_Itpre_Med_Tratamento.NextVal
              , rPreMed.Cd_Pre_Med_Tratmt
              , Sysdate
              , vTpOperacao
              , nCdPrestador
              , Dbamv.Pkg_Mv_Variaveis.Fnc_Get_Usuario
              , :New.Cd_Itpre_Med
              , :New.Cd_Tip_Esq
              , :New.Cd_Tip_Presc
              , :New.Cd_Pre_Med
              , :New.Cd_Set_Exa
              , :New.Cd_Tip_Fre
              , :New.Cd_For_Apl
              , :New.Qt_Itpre_Med
              , :New.Ds_Itpre_Med
              , :New.Tp_Situacao
              , :New.Dh_Inicial
              , :New.Tp_Local_Exame
              , :New.Sn_Copia
              , :New.Sn_Cancelado
              , :New.Cd_Unidade
              , :New.Cd_Produto
              , :New.Cd_Uni_Pro
              , :New.Cd_Importa_Reg_Fat
              , :New.Cd_Importa_Reg_Amb
              , :New.Cd_Prestador
              , :New.Dh_Final
              , :New.Dh_Cancelado
              , :New.Cd_Prest_Canc
              , :New.Cd_Pre_Uso
              , :New.Ds_Npadronizado
              , :New.Cd_Npadronizado
              , :New.Ds_Justificativa
              , :New.Cd_Itpre_Med_Canc
              , :New.Nr_Agrupamento
              , :New.Qt_Infusao
              , :New.Cd_Uni_Pro_Inf
              , :New.Tp_Tempo
              , :New.Qt_Dias
              , :New.Nr_Dia
              , :New.Cd_Itpre_Pad
              , :New.Tp_Justificativa
              , :New.Tp_Det_Justificativa
              , :New.Sn_Urgente
              , :New.Cd_Tip_Fre_Det
              , :New.Sn_Solicita
              , :New.Cd_Itpre_Med_Copia
              , :New.Qt_Itpre_Med_Calculado
              , :New.Sn_Somente_Hoje
              , :New.Cd_Formula
              , :New.Cd_Uni_Presc
              , :New.Hr_Duracao
              , :New.Cd_Uni_Presc_Inf
              , :New.Cd_Itpre_Med_Justificativa
              , :New.Sn_Atm_Prorrogacao
              , :New.Cd_Itpre_Med_Tratmt);
         --
         Elsif Deleting Then
            Insert into Dbamv.Log_Itpre_Med_Tratamento
               (Cd_Log_Itpre_Med_Tratamento
              , Cd_Pre_Med_Tratmt
              , Dh_Operacao
              , Tp_Operacao
              , Cd_Prestador_Operacao
              , Cd_Usuario
              , Cd_Itpre_Med
              , Cd_Tip_Esq
              , Cd_Tip_Presc
              , Cd_Pre_Med
              , Cd_Set_Exa
              , Cd_Tip_Fre
              , Cd_For_Apl
              , Qt_Itpre_Med
              , Ds_Itpre_Med
              , Tp_Situacao
              , Dh_Inicial
              , Tp_Local_Exame
              , Sn_Copia
              , Sn_Cancelado
              , Cd_Unidade
              , Cd_Produto
              , Cd_Uni_Pro
              , Cd_Importa_Reg_Fat
              , Cd_Importa_Reg_Amb
              , Cd_Prestador
              , Dh_Final
              , Dh_Cancelado
              , Cd_Prest_Canc
              , Cd_Pre_Uso
              , Ds_Npadronizado
              , Cd_Npadronizado
              , Ds_Justificativa
              , Cd_Itpre_Med_Canc
              , Nr_Agrupamento
              , Qt_Infusao
              , Cd_Uni_Pro_Inf
              , Tp_Tempo
              , Qt_Dias
              , Nr_Dia
              , Cd_Itpre_Pad
              , Tp_Justificativa
              , Tp_Det_Justificativa
              , Sn_Urgente
              , Cd_Tip_Fre_Det
              , Sn_Solicita
              , Cd_Itpre_Med_Copia
              , Qt_Itpre_Med_Calculado
              , Sn_Somente_Hoje
              , Cd_Formula
              , Cd_Uni_Presc
              , Hr_Duracao
              , Cd_Uni_Presc_Inf
              , Cd_Itpre_Med_Justificativa
              , Sn_Atm_Prorrogacao
              , Cd_Itpre_Med_Tratmt)
            Values (Dbamv.Seq_Log_Itpre_Med_Tratamento.NextVal
              , rPreMed.Cd_Pre_Med_Tratmt
              , Sysdate
              , vTpOperacao
              , nCdPrestador
              , Dbamv.Pkg_Mv_Variaveis.Fnc_Get_Usuario
              , :Old.Cd_Itpre_Med
              , :Old.Cd_Tip_Esq
              , :Old.Cd_Tip_Presc
              , :Old.Cd_Pre_Med
              , :Old.Cd_Set_Exa
              , :Old.Cd_Tip_Fre
              , :Old.Cd_For_Apl
              , :Old.Qt_Itpre_Med
              , :Old.Ds_Itpre_Med
              , :Old.Tp_Situacao
              , :Old.Dh_Inicial
              , :Old.Tp_Local_Exame
              , :Old.Sn_Copia
              , :Old.Sn_Cancelado
              , :Old.Cd_Unidade
              , :Old.Cd_Produto
              , :Old.Cd_Uni_Pro
              , :Old.Cd_Importa_Reg_Fat
              , :Old.Cd_Importa_Reg_Amb
              , :Old.Cd_Prestador
              , :Old.Dh_Final
              , :Old.Dh_Cancelado
              , :Old.Cd_Prest_Canc
              , :Old.Cd_Pre_Uso
              , :Old.Ds_Npadronizado
              , :Old.Cd_Npadronizado
              , :Old.Ds_Justificativa
              , :Old.Cd_Itpre_Med_Canc
              , :Old.Nr_Agrupamento
              , :Old.Qt_Infusao
              , :Old.Cd_Uni_Pro_Inf
              , :Old.Tp_Tempo
              , :Old.Qt_Dias
              , :Old.Nr_Dia
              , :Old.Cd_Itpre_Pad
              , :Old.Tp_Justificativa
              , :Old.Tp_Det_Justificativa
              , :Old.Sn_Urgente
              , :Old.Cd_Tip_Fre_Det
              , :Old.Sn_Solicita
              , :Old.Cd_Itpre_Med_Copia
              , :Old.Qt_Itpre_Med_Calculado
              , :Old.Sn_Somente_Hoje
              , :Old.Cd_Formula
              , :Old.Cd_Uni_Presc
              , :Old.Hr_Duracao
              , :Old.Cd_Uni_Presc_Inf
              , :Old.Cd_Itpre_Med_Justificativa
              , :Old.Sn_Atm_Prorrogacao
              , :Old.Cd_Itpre_Med_Tratmt);
         End If;
     End If;
End;





/
ALTER TRIGGER "DBAMV"."TRG_LOG_ITPRE_MED_TRATAMENTO" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_ITPRE_MED_ALTERA_VEL_INF"
AFTER  UPDATE  OF
   CD_UNI_PRESC_INF
  ,CD_UNI_PRO_INF
  ,HR_DURACAO
  ,QT_INFUSAO
  ,TP_TEMPO
 ON DBAMV.ITPRE_MED
REFERENCING
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW
DECLARE
   CURSOR C_PRE_MED( P_PRE_MED NUMBER ) IS
     SELECT NVL(PRE_MED.FL_IMPRESSO,'N') FL_IMPRESSO
       FROM DBAMV.PRE_MED
      WHERE PRE_MED.CD_PRE_MED = P_PRE_MED;
      VPRE_MED  C_PRE_MED%ROWTYPE;
BEGIN
  IF UPDATING THEN
    --
    OPEN C_PRE_MED( :NEW.CD_PRE_MED );
    --
    FETCH C_PRE_MED INTO VPRE_MED;
    CLOSE C_PRE_MED;
     --
     IF VPRE_MED.FL_IMPRESSO = 'S' THEN
      INSERT INTO DBAMV.ALTERACAO_ITPRE_MED
         (CD_ITPRE_MED
         ,DH_ALTERACAO
         ,NM_USUARIO_ALTERACAO
         ,QT_INFUSAO
         ,CD_UNI_PRO_INF
         ,CD_UNI_PRESC_INF
         ,HR_DURACAO
         ,TP_TEMPO )
      VALUES
         (:OLD.CD_ITPRE_MED
         ,SYSDATE
         ,USER
         ,:OLD.QT_INFUSAO
         ,:OLD.CD_UNI_PRO
         ,:OLD.CD_UNI_PRESC
         ,:OLD.HR_DURACAO
         ,:OLD.TP_TEMPO );
     --
     END IF;
  --
  END IF;
  --
  EXCEPTION
  WHEN OTHERS then
  raise_application_error(-20000,'Erro TRG_ITPRE_MED_ALTERA_VEL_INF');
  --
END TRG_ITPRE_MED_ALTERA_VEL_INF;






/
ALTER TRIGGER "DBAMV"."TRG_ITPRE_MED_ALTERA_VEL_INF" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_ITPRE_MED_SUSP_AVAL_STATUS"

Before Update Of sn_cancelado

On dbamv.itpre_med

For Each Row

Declare



  vStatus 				        Varchar2(15);



Begin



	-- Se o item de prescricao foi suspenso / cancelado

	If Nvl(:new.sn_cancelado,'*') <> Nvl(:old.sn_cancelado,'*') Then



		vStatus := dbamv.fnc_status_aval_pos_suspencao(:new.cd_pre_med, :new.cd_itpre_med);



	    Update dbamv.pw_pre_med_avaliacao_status

		   Set tp_status = vStatus

		 Where pw_pre_med_avaliacao_status.cd_pre_med = :new.cd_pre_med;



	End If;



End;

/
ALTER TRIGGER "DBAMV"."TRG_ITPRE_MED_SUSP_AVAL_STATUS" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_DELETE_MOV_INV"

BEFORE UPDATE OF SN_CANCELADO

ON DBAMV.ITPRE_MED

REFERENCING NEW AS NEW OLD AS OLD

FOR EACH ROW

DECLARE



BEGIN



  -- SE O ITEM DE PRESCRICAO FOI SUSPENSO

	IF  NVL(:NEW.SN_CANCELADO,'*') != NVL(:OLD.SN_CANCELADO,'*') AND

	    NVL(:NEW.SN_CANCELADO,'*') = 'S' THEN



    DELETE

      FROM DBAMV.COMPONENTE_NNISS

     WHERE CD_MOV_INV IN (SELECT CD_MOV_INV

                            FROM DBAMV.MOV_INV

                           WHERE CD_ITPRE_MED = :NEW.CD_ITPRE_MED

                             AND CD_USUARIO_APLICACAO IS NULL);



    DELETE

      FROM DBAMV.MOV_INV

     WHERE CD_ITPRE_MED = :NEW.CD_ITPRE_MED

       AND CD_USUARIO_APLICACAO IS NULL;



  END IF;



END;

/
ALTER TRIGGER "DBAMV"."TRG_DELETE_MOV_INV" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_ITPRE_MED_PRE_USO"
 BEFORE
  INSERT OR DELETE OR UPDATE
 ON dbamv.itpre_med
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
DECLARE
   CURSOR C_Pre_Med( P_Pre_Med NUMBER ) IS
     SELECT Pre_Med.Cd_Atendimento
           ,Pre_Med.Cd_Prestador
           ,Pre_Med.Fl_Principal
	     ,Pre_Med.Dt_Pre_Med
	     ,Pre_Med.Hr_Pre_Med
	     ,Pre_Med.Dt_Validade
	     ,Pre_Med.Fl_Impresso
         ,Pre_Med.Tp_Pre_Med
          , Nvl(Pagu_Objeto.Tp_Objeto,'@x@') Tp_Objeto -- Pda 449045
          , Pre_Med.Cd_Pre_Med_Tratmt -- Pda 449045
       FROM Dbamv.Pre_Med
          , Dbamv.Pagu_Objeto  -- Pda 449045
      WHERE Pre_Med.Cd_Pre_Med = P_Pre_Med
        And Pre_Med.Cd_Objeto  = Pagu_Objeto.Cd_Objeto (+); -- Pda 449045
    -- fac teste
   CURSOR C_TIP_FRE IS
     SELECT TP_CONTROLE
      FROM DBAMV.TIP_FRE
     WHERE CD_TIP_FRE = :NEW.CD_TIP_FRE;
    -- fac teste
   CURSOR C_TIP_ESQ IS
     SELECT SN_EXA_LAB
       FROM DBAMV.TIP_ESQ
      WHERE CD_TIP_ESQ = :NEW.CD_TIP_ESQ;
  vPre_Med  C_Pre_Med%RowType;
  vTP_CONTROLE Varchar2(6);
  vSn_Exa_Lab Varchar2(1);
  bCritica Boolean := True;
BEGIN
  IF Inserting OR Updating THEN
    -- fac teste inicio
     OPEN C_TIP_ESQ;
     FETCH C_TIP_ESQ INTO vSn_Exa_Lab;
     CLOSE C_TIP_ESQ;
     IF vSn_Exa_Lab = 'S' THEN
        IF :NEW.CD_TIP_FRE IS NOT NULL THEN
           OPEN C_TIP_FRE;
           FETCH C_TIP_FRE INTO vTP_CONTROLE;
           CLOSE C_TIP_FRE;
        END IF;
        --
        -- Retirado pois estava causando erro.
       /* IF vTP_CONTROLE = 'A' OR :NEW.SN_URGENTE = 'S' THEN
           :New.Dh_Inicial := Null;
        END IF;*/
    END IF;
        -- fac teste fim
    OPEN C_Pre_Med( :New.Cd_Pre_Med );
  ELSE
     OPEN C_Pre_Med( :Old.Cd_Pre_Med );
  END IF;
  FETCH C_Pre_Med INTO vPre_Med;
  CLOSE C_Pre_Med;
-- Pda 449045 Inicio
    If  Inserting Then
        If  vPre_Med.Tp_Objeto          = 'TRATMT'   And  -- Se prescri??o n?o ? de tratamento, continua a critica.
            vPre_Med.Cd_Pre_Med_Tratmt Is Null       And  -- Se n?o ? prescri??o pai, continua a critica.
            Pkg_Mv2000.Le_Formulario()             in ('M_PREMED', 'M_PREMED_ONCOLOGIA'
                                                      ,'M_RECEPCAO_AGENDA','M_RECEPCAO_MANUT_AGENDA') -- Pda 593826
           Then -- Se n?o vem das telas autorizadas, continua a critica. -- op 5349
            bCritica := False;
        End If;
    End If;
-- Pda 449045 Fim
  IF vPre_Med.Fl_Impresso = 'S'
    And bCritica -- Pda 449085
    and vPre_Med.Tp_Pre_Med not in ('F','A') and vPre_Med.Cd_Pre_Med_Tratmt is null    THEN  -->> PrescriÃ§Ã£o Futura
    If Not (Updating( 'Cd_nPadronizado' )
    Or Updating( 'Dh_Cancelado' )
    Or Updating( 'SN_ATM_PRORROGACAO' )
    Or Updating( 'CD_USUARIO_OBSERVACAO_APRAZA' )
    Or Updating( 'DS_OBSERVACAO_APRAZAMENTO' )
    Or Updating( 'SN_HORARIO_GERADO' )
    Or Updating( 'CD_TIP_FRE_APRAZAMENTO' )
    Or Updating( 'SN_PREPARACAO' )
  	Or Updating( 'SN_FINAL_CICLO_NOTIFICADO')
    OR Updating( 'SN_CRONICO')) Then
  	   Raise_Application_Error( -20001, pkg_rmi_traducao.extrair_proc_msg('MSG_2', 'TRG_ITPRE_MED_PRE_USO', 'Nao e permitido modificar(inserir,alterar,deletar) qualquer item da prescricao, apos ter sido impresso. Tela(%s)', arg_list(Pkg_Mv2000.Le_Formulario())) );
    end if;
  END IF;
END;
END TRG_ITPRE_MED_PRE_USO;
/
ALTER TRIGGER "DBAMV"."TRG_ITPRE_MED_PRE_USO" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_ITPRE_MED_SUSPENDE_PSND"
-- PDA 499651 (Inicio) - 18/05/2012 - TMS
before update  of sn_cancelado
on dbamv.itpre_med
for each row
declare
	Cursor cMovCardapio is
		select cd_mov_cardapio, dt_entrega, cd_usuario_entrega
		  from dbamv.mov_cardapio
		 where mov_cardapio.cd_itpre_med = :new.cd_itpre_med;
begin
	-- se o item de prescricao foi suspenso
	if  nvl(:new.sn_cancelado,'*') != nvl(:old.sn_cancelado,'*') and
	    nvl(:new.sn_cancelado,'*') = 'S' then
		-- varrre os movimentos de cardapio do mesmo.
		for rMov in cMovCardapio LOOP
      -- se a movimentação já foi confirmada não pode cancelar
	      if rMov.dt_entrega is not null and rMov.cd_usuario_entrega is not null then
	         update dbamv.mov_cardapio
		 	 		  set ds_observacao = ds_observacao || CHR(10) || 'Prescrição suspensa em: ' || sysdate || ' por ' || Nvl(dbamv.pkg_mv_variaveis.fnc_get_usuario, user)
				 	  where cd_mov_cardapio = rMov.cd_mov_cardapio;
	      else
			  -- e suspende os movimentos também

   			update dbamv.mov_cardapio

   	 	 		set sn_prescricao_suspensa = 'S'

			 		 ,cd_usuario_suspensao_presc = Nvl(dbamv.pkg_mv_variaveis.fnc_get_usuario, user)

   					 ,dt_suspensao_prescricao = sysdate

   			 where cd_mov_cardapio = rMov.cd_mov_cardapio;
		  end if;
   		end loop;
	end if;
	--OP6665 - INICIO - 18/04/2013 - CLHO
	if  nvl(:new.sn_cancelado,'*') = 'N' then
		for rMov in cMovCardapio Loop
	      -- se a movimentação já foi confirmada não pode cancelar
	      if rMov.dt_entrega is not null and rMov.cd_usuario_entrega is not null then
	         update dbamv.mov_cardapio
		 	 		  set ds_observacao = ds_observacao || CHR(10) || 'Prescrição suspensa em: ' || sysdate || ' por ' || Nvl(dbamv.pkg_mv_variaveis.fnc_get_usuario, user)
				 	  where cd_mov_cardapio = rMov.cd_mov_cardapio;
	      else
   		 	 update dbamv.mov_cardapio

   	 	 		set sn_prescricao_suspensa = 'N'

   			 		 ,cd_usuario_suspensao_presc = user

   					 ,dt_suspensao_prescricao = sysdate

   			 where cd_mov_cardapio = rMov.cd_mov_cardapio;
		  end if;
   		end loop;
	end if;
	--OP6665 - FIM - 18/04/2013 - CLHO
-- PDA 499651 (Fim)
end;

/
ALTER TRIGGER "DBAMV"."TRG_ITPRE_MED_SUSPENDE_PSND" ENABLE;

CREATE INDEX "DBAMV"."TIP_ESQ_ITPRE_MED_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_TIP_ESQ")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_ITPRE_MED_CANC_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_ITPRE_MED_CANC")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_CONFIG_CURVA_FK" ON "DBAMV"."ITPRE_MED" ("CD_CONFIGURACAO_CURVA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_PRE_USO_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_PRE_USO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_UNIDADE_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_UNIDADE")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPREMED_ITCOPIA_1_IX" ON "DBAMV"."ITPRE_MED" ("CD_ITPRE_MED_COPIA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_CID_FK" ON "DBAMV"."ITPRE_MED" ("CD_CID")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."CNT_ITPREMED_TIPFRE_2_IX" ON "DBAMV"."ITPRE_MED" ("CD_TIP_FRE_DET")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_UNI_PRO_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_UNI_PRO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_TIP_PRESC_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_TIP_PRESC")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_PROCE_DET_1_FK" ON "DBAMV"."ITPRE_MED" ("TP_JUSTIFICATIVA", "TP_DET_JUSTIFICATIVA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_UNI_PRESC_2_FK" ON "DBAMV"."ITPRE_MED" ("CD_UNI_PRESC_INF")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."CNT_ITPRE_MED_ITPRE_PAD_1_IX" ON "DBAMV"."ITPRE_MED" ("CD_ITPRE_PAD")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_FOR_APL_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_FOR_APL")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."CNT_ITPREMED_TIPFRE_3_IX" ON "DBAMV"."ITPRE_MED" ("CD_TIP_FRE_APRAZAMENTO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_SET_EXA_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_SET_EXA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_1_IX" ON "DBAMV"."ITPRE_MED" ("SN_URGENTE")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_2_IX" ON "DBAMV"."ITPRE_MED" ("CD_ITPRE_MED", "CD_TIP_PRESC", "CD_UNI_PRO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBATUALIZA"."IND_ITPRE_MED_MULTI_EMPRESA_FK" ON "DBAMV"."ITPRE_MED" ("CD_MULTI_EMPRESA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_M_PW_GR_PRE_ITP_M_FK" ON "DBAMV"."ITPRE_MED" ("CD_GRUPO_PRESCRICAO_ITPRE_MED")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPREMED_FORM_1_FK" ON "DBAMV"."ITPRE_MED" ("CD_FORMULA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_PRODUTO_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_PRODUTO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."CNT_ITPREMED_SN_CANCELADO_IX" ON "DBAMV"."ITPRE_MED" ("SN_CANCELADO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_NPADRONIZADO_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_NPADRONIZADO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_UNI_PRESC_3_FK" ON "DBAMV"."ITPRE_MED" ("CD_UNID_PRESC_VOL_TOTAL")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_PROC_MV_1_FK" ON "DBAMV"."ITPRE_MED" ("TP_JUSTIFICATIVA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_PRE_MED_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_PRE_MED")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_USUARIOS_IX" ON "DBAMV"."ITPRE_MED" ("CD_USUARIO_OBSERVACAO_APRAZA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_UNI_PRESC_1_FK" ON "DBAMV"."ITPRE_MED" ("CD_UNI_PRESC")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_PRESTADOR_FK2_I" ON "DBAMV"."ITPRE_MED" ("CD_PREST_CANC")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPREMED_JUSTIFIC_FK" ON "DBAMV"."ITPRE_MED" ("CD_ITPRE_MED_JUSTIFICATIVA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."CNT_ITPRE_MED_DISPOSITIVO_IX" ON "DBAMV"."ITPRE_MED" ("CD_DISPOSITIVO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_PRESTADOR_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_PRESTADOR")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."CNT_ITPRE_MED_LOC_ANAT_COL_IX" ON "DBAMV"."ITPRE_MED" ("CD_LOCAL_ANATOMICO_COLETA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_MATERIAL_FK" ON "DBAMV"."ITPRE_MED" ("CD_MATERIAL")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_VOL_TOTAL_IX" ON "DBAMV"."ITPRE_MED" ("CD_UNID_VOL_TOTAL")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."ITPRE_MED_TIP_FRE_FK_I" ON "DBAMV"."ITPRE_MED" ("CD_TIP_FRE")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_ITPRE_MED_ITPRE_MED_FK" ON "DBAMV"."ITPRE_MED" ("CD_ITPRE_MED_TRATMT")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "UPFLUX";
  GRANT UPDATE ON "DBAMV"."ITPRE_MED" TO "MEDWISE" WITH GRANT OPTION;
  GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "MEDWISE" WITH GRANT OPTION;
  GRANT INSERT ON "DBAMV"."ITPRE_MED" TO "MEDWISE" WITH GRANT OPTION;
  GRANT DELETE ON "DBAMV"."ITPRE_MED" TO "MEDWISE" WITH GRANT OPTION;
  GRANT UPDATE ON "DBAMV"."ITPRE_MED" TO "MVAPI";
  GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "MVAPI";
  GRANT INSERT ON "DBAMV"."ITPRE_MED" TO "MVAPI";
  GRANT DELETE ON "DBAMV"."ITPRE_MED" TO "MVAPI";
  GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "DBACP" WITH GRANT OPTION;
  GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "DBAPORTAL" WITH GRANT OPTION;
  GRANT UPDATE ON "DBAMV"."ITPRE_MED" TO "MVBIKE" WITH GRANT OPTION;
  GRANT INSERT ON "DBAMV"."ITPRE_MED" TO "MVBIKE" WITH GRANT OPTION;
  GRANT DELETE ON "DBAMV"."ITPRE_MED" TO "MVBIKE" WITH GRANT OPTION;
  GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "MVBIKE" WITH GRANT OPTION;
  GRANT REFERENCES ON "DBAMV"."ITPRE_MED" TO "MVINTEGRA";
  GRANT UPDATE ON "DBAMV"."ITPRE_MED" TO "MVINTEGRA";
  GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "MVINTEGRA" WITH GRANT OPTION;
  GRANT INSERT ON "DBAMV"."ITPRE_MED" TO "MVINTEGRA";
  GRANT DELETE ON "DBAMV"."ITPRE_MED" TO "MVINTEGRA";
  GRANT REFERENCES ON "DBAMV"."ITPRE_MED" TO "DBAPS";
  GRANT UPDATE ON "DBAMV"."ITPRE_MED" TO "DBAPS";
  GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "DBAPS";
  GRANT INSERT ON "DBAMV"."ITPRE_MED" TO "DBAPS";
  GRANT DELETE ON "DBAMV"."ITPRE_MED" TO "DBAPS";
  GRANT REFERENCES ON "DBAMV"."ITPRE_MED" TO "DBASGU";
  GRANT UPDATE ON "DBAMV"."ITPRE_MED" TO "DBASGU";
  GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "DBASGU";
  GRANT INSERT ON "DBAMV"."ITPRE_MED" TO "DBASGU";
  GRANT DELETE ON "DBAMV"."ITPRE_MED" TO "DBASGU";
  GRANT UPDATE ON "DBAMV"."ITPRE_MED" TO "MV2000";
  GRANT SELECT ON "DBAMV"."ITPRE_MED" TO "MV2000";
  GRANT INSERT ON "DBAMV"."ITPRE_MED" TO "MV2000";
  GRANT DELETE ON "DBAMV"."ITPRE_MED" TO "MV2000";

COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_SOLICITA IS 'Identifica se o item gera solicitação ao Estoque';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_URGENTE IS 'Indica a urgência na prescrição médica nos processos de integração';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_TIP_FRE_DET IS 'Detalhamento da frequência quando esta solicitar. Usado a princípio para as frequência S/N e ACM';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_ITPRE_MED_COPIA IS 'Codigo de origem do item da copia de prescrição';
COMMENT ON COLUMN DBAMV.ITPRE_MED.QT_ITPRE_MED_CALCULADO IS 'Quantidade do item cálculo através da fórmula de superfície corpórea.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_SOMENTE_HOJE IS 'Indica se o item poderá ser copiado em prescrições futuras';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_FORMULA IS 'Código da fórmula usada para calcular a quantidade do ítem';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_UNI_PRESC IS 'Código da unidade de medida';
COMMENT ON COLUMN DBAMV.ITPRE_MED.HR_DURACAO IS 'Duração da infusão';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_UNI_PRESC_INF IS 'Código da Unidade da Velocidade de Prescrição';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_ITPRE_MED_JUSTIFICATIVA IS 'Codigo da justificativa';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_ATM_PRORROGACAO IS 'Indica se o atm esta prorrogando um ciclo de tratamento na auditoria de prescrição.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_ITPRE_MED_TRATMT IS 'Primary key do item da prescrição pai de tratamento';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_MATERIAL IS 'Código do Material para o exame laboratorial';
COMMENT ON COLUMN DBAMV.ITPRE_MED.DH_REGISTRO IS 'Data de solicitação de exame ou realização de prescrição do item, preenchido automaticamente pelo sistema.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_GRUPO_PRESCRICAO_ITPRE_MED IS 'Código do grupo dos itens prescritos';
COMMENT ON COLUMN DBAMV.ITPRE_MED.QT_DOSE_PADRAO IS 'Apresenta a dose padrão da medicação, sendo esta informada pelo médico na prescrição';
COMMENT ON COLUMN DBAMV.ITPRE_MED.NR_ORDEM IS 'Indica qual será a ordem do item dentro da prescriçao medica';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_ITPRE_MED_INTEGRA IS 'Código de-para do item de prescrição medica';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_SEQ_INTEGRA IS 'Código identificador do registro de integração';
COMMENT ON COLUMN DBAMV.ITPRE_MED.DT_INTEGRA IS 'Data do registro da integração';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_ALERTA_PERSISTIDO IS 'Indica se os alertas do item foram persistidos na tabela pw_itpre_med_alerta ao fechar a prescrição';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_COPIA_IDENTICA IS 'Coluna que indica que o item é uma cópia identica ao item copiado de outra prescrição';
COMMENT ON COLUMN DBAMV.ITPRE_MED.DS_OBSERVACAO_AUTOMATICA IS 'Coluna que guarda as observações criadas automaticamente pelo sistema para o item de prescrição';
COMMENT ON COLUMN DBAMV.ITPRE_MED.DS_OBSERVACAO_APRAZAMENTO IS 'Coluna que guarda a observação do aprazamento para o item';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_USUARIO_OBSERVACAO_APRAZA IS 'Coluna que guarda o código do usuário que criou a observação do aprazamento para o item (FK)';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_KIT_PADRAO_ALTERADO IS 'Indica se o kit padrão do item foi alterado (inclusão, exclusão ou alteração dos componentes padrões)';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_CONFIGURACAO_PADRAO_ITEM IS 'Código da configuração padrão que originou o item';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_LOCAL_ANATOMICO_COLETA IS 'Campo para armazenar o código do local anatomico da coleta';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_DISPOSITIVO IS 'Código do dispositivo utilizado no item de prescrição.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_HORARIO_GERADO IS 'Indica se foi gerado horï¿½rio para o item.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_CONTINUO IS 'Indica se o item ï¿½ Continuo.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_TIP_FRE_APRAZAMENTO IS 'Cï¿½digo da frequï¿½ncia utilizada na hora de criaï¿½ï¿½o dos horï¿½rios.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.NM_EXIBICAO_OBSERVACAO_AUTOMAT IS 'Nome de exibição da observação predefinida';
COMMENT ON COLUMN DBAMV.ITPRE_MED.NM_EXIBICAO_COMPONENTES IS 'Nome de exibição dos componentes';
COMMENT ON COLUMN DBAMV.ITPRE_MED.DS_UNIDADE_FORMULA IS 'Descrição da unidade da fórmula';
COMMENT ON COLUMN DBAMV.ITPRE_MED.QTD_VOLUME_TOTAL IS 'Campo para informar o volume total da solução após a diluição.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_UNID_VOL_TOTAL IS 'Unidade de produto relacionada ao volume total da solução após a diluição.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_CID IS 'Campo para armazenar o código do CID, ao prescrever exames.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_CONFIGURACAO_CURVA IS 'Campo para armazenar o código da configuração da curva dinâmica, ao prescrever exames.';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_CURVA_PADRAO_AUTO IS 'Define se o item sofreu alteração manual da sua curva padrão setada automaticamente pelo sistema';
COMMENT ON COLUMN DBAMV.ITPRE_MED.DS_MATERIAL_COMPLEMENTAR IS 'Descrição do material complementar para o exame laboratorial';
COMMENT ON COLUMN DBAMV.ITPRE_MED.NR_PERCENTUAL_REDUCAO_QUANTD IS 'Indica o percentual usado para redução da quantidade do item';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_REDUZIR_QUANTIDADE IS 'Indica que a quantidade do item deve ser reduzida baseada no percentual informado na prescrição';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_FINAL_CICLO_NOTIFICADO IS 'FLAG INDICATIVA QUE O CICLO DE APLICAÇÃO FECHADO FOI NOTIFICADO';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_CRONICO IS 'A identificacao para medicacao cronica';
COMMENT ON COLUMN DBAMV.ITPRE_MED.NR_DIAS IS 'dias de duracao da medicacao';
COMMENT ON COLUMN DBAMV.ITPRE_MED.NR_HORA IS 'horas de duracao da medicacao';
COMMENT ON COLUMN DBAMV.ITPRE_MED.NR_MINUTO IS 'minutos de duracao da medicacao';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_MULTI_EMPRESA IS 'Código da empresa';
COMMENT ON COLUMN DBAMV.ITPRE_MED.TP_FASE_QT IS 'Tipo da fase da quimioterapia para o item, podendo ser antes da quimioterapia (PRE), quimioterápico(QT) ou após a quimioterapia (POS)';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_PESQUISA_CIENTIFICA IS 'Se o item foi incluído como item de pesquisa científica';
COMMENT ON COLUMN DBAMV.ITPRE_MED.SN_REAVALICAO_MEDICA IS 'Campo que informa se o item de prescrição sofreu uma reavaliação médica';
COMMENT ON COLUMN DBAMV.ITPRE_MED.CD_UNID_PRESC_VOL_TOTAL IS 'Unidade de prescrição relacionada ao volume total da solução após a diluição.';