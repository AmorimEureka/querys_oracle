-- DBAMV.PRE_MED definição

CREATE TABLE "DBAMV"."PRE_MED"
   (	"CD_PRE_MED" NUMBER(8,0) NOT NULL ENABLE,
	"CD_ATENDIMENTO" NUMBER(10,0) NOT NULL ENABLE,
	"CD_PRESTADOR" NUMBER(12,0) NOT NULL ENABLE,
	"CD_UNID_INT" NUMBER(6,0),
	"DT_PRE_MED" DATE NOT NULL ENABLE,
	"HR_PRE_MED" DATE NOT NULL ENABLE,
	"DS_EVOLUCAO" LONG,
	"CD_ID_USUARIO" NUMBER(10,0) NOT NULL ENABLE,
	"CD_SOLSAI_PRO" NUMBER,
	"SN_FECHADO" VARCHAR2(1),
	"SN_RN" VARCHAR2(1) NOT NULL ENABLE,
	"DT_VALIDADE" DATE NOT NULL ENABLE,
	"FL_PRINCIPAL" VARCHAR2(1) DEFAULT 'S' NOT NULL ENABLE,
	"FL_IMPRESSO" VARCHAR2(1) DEFAULT 'N' NOT NULL ENABLE,
	"TP_PRE_MED" VARCHAR2(1) DEFAULT 'M' NOT NULL ENABLE,
	"NM_USUARIO" VARCHAR2(30),
	"CD_SETOR" NUMBER(4,0),
	"DT_REFERENCIA" DATE NOT NULL ENABLE,
	"SN_TRANSCRICAO" VARCHAR2(1) DEFAULT 'N' NOT NULL ENABLE,
	"DH_CRIACAO" DATE,
	"DH_IMPRESSAO" DATE,
	"CD_IMPORTA_REG_FAT" NUMBER(1,0),
	"CD_IMPORTA_REG_AMB" NUMBER(1,0),
	"CD_PRE_PAD" NUMBER,
	"CD_OBJETO" NUMBER(10,0),
	"NM_USUARIO_AUTORIZADOR" VARCHAR2(30),
	"CD_REGISTRO_CLINICO" NUMBER(13,0),
	"CD_PRE_MED_TRATMT" NUMBER(8,0),
	"SN_ALTERA_PROTOCOLO_TRATAMENTO" VARCHAR2(1) DEFAULT 'N',
	"SN_PRESCRICAO_DIA_SEGUINTE" VARCHAR2(1) DEFAULT 'N' NOT NULL ENABLE,
	"CD_USUARIO_CONVERSAO_PRESCRIC" VARCHAR2(30),
	"DH_CONVERSAO_PRESCRICAO" DATE,
	"NM_PRESCRICAO" VARCHAR2(70),
	"CD_DOCUMENTO_CLINICO" NUMBER(13,0),
	"CD_TRATAMENTO" NUMBER(8,0),
	"NR_CICLO" NUMBER(2,0),
	"NR_SESSAO" NUMBER(2,0),
	"CD_PRE_MED_INTEGRA" VARCHAR2(50),
	"CD_TP_SOLICITACAO" NUMBER(2,0),
	"SN_COPIADA" VARCHAR2(1) DEFAULT 'N',
	"NR_PERCENTUAL_REDUCAO_QUANTD" NUMBER(4,2),
	"DS_JUSTIFICATIVA_REDUCAO_QTD" VARCHAR2(120),
	"SN_CONCO_RADIOTERAPIA" VARCHAR2(1) DEFAULT 'N',
	"TP_AGENDAMENTO" VARCHAR2(3),
	"SN_INTERROMPER_SESSAO" VARCHAR2(1),
	"DS_JUSTIFICATIVA_INTERROMPER" VARCHAR2(200),
	"SN_INTERCORRENCIA" VARCHAR2(1),
	"DS_JUSTIFICATIVA_SESSAO" VARCHAR2(600),
	"SN_MEDICAMENTO_ADMINISTRADO" VARCHAR2(1),
	"DS_TOKEN_EXAMES_ONLINE" VARCHAR2(200),
	 CONSTRAINT "CNT_PRE_MED_SN_INTER_CK" CHECK (

    SN_INTERCORRENCIA IN ('S', 'N')

  ) ENABLE,
	 CONSTRAINT "CNT_PRE_MED_SN_INTER_SESSAO_CK" CHECK (

    sn_interromper_sessao IN ('S', 'N')

  ) ENABLE,
	 CONSTRAINT "CNT_PRE_MED_1_UK" UNIQUE ("CD_DOCUMENTO_CLINICO")
  USING INDEX (CREATE INDEX "DBAMV"."IND_PRE_MED_PW_DOCUM_CLIN_FK" ON "DBAMV"."PRE_MED" ("CD_DOCUMENTO_CLINICO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" )  ENABLE,
	 CONSTRAINT "CNT_PRE_MED_2_CK" CHECK (sn_prescricao_dia_seguinte in ('S', 'N')) ENABLE,
	 CONSTRAINT "PRE_MED_PK" PRIMARY KEY ("CD_PRE_MED")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I"  ENABLE,
	 CONSTRAINT "AVCON_258542_FL_PR_000" CHECK (FL_PRINCIPAL IN ('S', 'N')) ENABLE,
	 CONSTRAINT "CNT_PRE_MED_3_CK" CHECK (

    sn_copiada IN ('S', 'N')

  ) ENABLE,
	 CONSTRAINT "CNT_PRE_MED_TP_AGENDAMENTO_CK" CHECK (

    TP_AGENDAMENTO IN ('QUI', 'RAD', 'FAR')

  ) ENABLE,
	 CONSTRAINT "PRE_MED_SETOR_FK" FOREIGN KEY ("CD_SETOR")
	  REFERENCES "DBAMV"."SETOR" ("CD_SETOR") ENABLE,
	 CONSTRAINT "CNT_PRE_MED_REGISTRO_CLINC_FK" FOREIGN KEY ("CD_REGISTRO_CLINICO")
	  REFERENCES "DBAMV"."REGISTRO_CLINICO" ("CD_REGISTRO_CLINICO") ENABLE,
	 CONSTRAINT "CNT_PRE_MED_PRE_PAD_1_FK" FOREIGN KEY ("CD_PRE_PAD")
	  REFERENCES "DBAMV"."PRE_PAD" ("CD_PRE_PAD") ENABLE,
	 CONSTRAINT "PRE_MED_PRESTADOR_FK" FOREIGN KEY ("CD_PRESTADOR")
	  REFERENCES "DBAMV"."PRESTADOR" ("CD_PRESTADOR") ENABLE,
	 CONSTRAINT "CNT_PRE_MED_PAGU_OBJ_2_FK" FOREIGN KEY ("CD_OBJETO")
	  REFERENCES "DBAMV"."PAGU_OBJETO" ("CD_OBJETO") ENABLE,
	 CONSTRAINT "CNT_PRE_MED_PRE_MED_FK" FOREIGN KEY ("CD_PRE_MED_TRATMT")
	  REFERENCES "DBAMV"."PRE_MED" ("CD_PRE_MED") ENABLE,
	 CONSTRAINT "CNT_PRE_MED_PW_DOCUM_CLIN_FK" FOREIGN KEY ("CD_DOCUMENTO_CLINICO")
	  REFERENCES "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOCUMENTO_CLINICO") ENABLE,
	 CONSTRAINT "CNT_PRE_MED_SESSAO_TRTM_FK" FOREIGN KEY ("CD_TRATAMENTO", "NR_CICLO", "NR_SESSAO")
	  REFERENCES "DBAMV"."SESSAO_TRATAMENTO" ("CD_TRATAMENTO", "NR_CICLO", "NR_SESSAO") ENABLE,
	 CONSTRAINT "PRE_MED_ATENDIME_FK" FOREIGN KEY ("CD_ATENDIMENTO")
	  REFERENCES "DBAMV"."ATENDIME" ("CD_ATENDIMENTO") ENABLE,
	 CONSTRAINT "PRE_MED_UNID_INT_FK" FOREIGN KEY ("CD_UNID_INT")
	  REFERENCES "DBAMV"."UNID_INT" ("CD_UNID_INT") ENABLE,
	 CONSTRAINT "CNT_PRE_MED_TP_SOLICITACAO_FK" FOREIGN KEY ("CD_TP_SOLICITACAO")
	  REFERENCES "DBAMV"."TIPO_SOLICITACAO" ("CD_TP_SOLICITACAO") ENABLE
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_D" ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PROD_NPADRONIZADO"
BEFORE UPDATE
ON dbamv.pre_med
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
 Cursor C_ItPreMed( nCdPreMed In number) is
   Select cd_itpre_med, ds_npadronizado,
          cd_npadronizado
   from   dbamv.itpre_med
   where  cd_pre_med = nCdPreMed
   And    ItPre_Med.Sn_Solicita  = 'S' --PDA 95239
   and    ds_npadronizado is not null;
 Cursor C_Prod_nPadronizado( nCdItPreMed In number) is
   Select flag_lib_futuro
   from   dbamv.lib_prod_npadronizado
   where  cd_itpre_med = nCdItPreMed;
   Cursor C_Seq IS
     Select Dbamv.SEQ_LIB_PROD_NPADRONIZADO.NextVal
       From Dual;
  cSnLibFuturo VarChar2(1);
  nCdProdNPadronizado Number;
begin
 if :old.fl_impresso = 'N' and :new.fl_impresso = 'S' Then
   For C_item In C_ItPreMed(:Old.cd_pre_med) Loop
       cSnLibFuturo := null;
       Open  C_Prod_nPadronizado(C_Item.cd_itpre_med);
       Fetch C_Prod_nPadronizado Into cSnLibFuturo;
       Close C_Prod_nPadronizado;
       if NVL(cSnLibFuturo, 'N') = 'N' Then -- Verifica se é necessario liberar novamente.
          Open  C_Seq;
          Fetch C_Seq Into nCdProdNPadronizado;
          Close C_Seq;
             INSERT INTO dbamv.lib_prod_npadronizado (cd_prod_npadronizado,
                         ds_prod_npadronizado, cd_itpre_med, cd_produto,
                         dt_liberacao, cd_id_usuario, tp_acao,
                         ds_justificativa, flag_lib_futuro )
             VALUES(nCdProdNPadronizado,C_ITEM.ds_npadronizado,
                    C_ITEM.cd_itpre_med, C_ITEM.cd_npadronizado, null,
                    null, 'I', null, 'N');
       end if; -- Liberacao Futuro
   End Loop; -- Loop
 end if; -- Impresso
end;




/
ALTER TRIGGER "DBAMV"."TRG_PROD_NPADRONIZADO" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PRE_MED_REG_DOCUM_CLINC"

BEFORE INSERT OR UPDATE OR DELETE ON dbamv.pre_med

FOR EACH ROW

DECLARE

  v_cd_documento_clinico  NUMBER;

  v_cd_tipo_documento NUMBER;



  Cursor cDocClinico(pCdDocumentoClinico Number) IS

    Select Tp_Status

      From Dbamv.Pw_Documento_Clinico

     Where Cd_Documento_Clinico = pCdDocumentoClinico;

  vTpStatus VARCHAR2(20);



BEGIN

  IF INSERTING THEN

    IF :NEW.tp_pre_med = 'I' THEN

      select dbamv.seq_pw_documento_clinico.nextval

        into v_cd_documento_clinico

        from dual;

		  insert into dbamv.pw_documento_clinico ( cd_documento_clinico

                                                 , cd_tipo_documento

                                                 , tp_status

                                                 , dh_referencia

                                                 , dh_criacao

                                                 , dh_fechamento

                                                 , dh_impresso

											     , dh_documento

                                                 , cd_paciente

                                                 , cd_prestador

                                                 , cd_atendimento

                                                 , cd_usuario

											     , cd_objeto)

		                                  values ( v_cd_documento_clinico

                                                 , dbamv.FNC_PEP_BUSCA_CODIGO_TIP_DOCUM('ADMISS')

                                                 , 'ABERTO'  -->> tp_status

                                                 , :new.dt_referencia

                                                 , SYSDATE

                                                 , NULL

                                                 , NULL

											     , sysdate

                                                 , dbamv.FNC_PEP_BUSCA_CODIGO_PACIENTE(:new.cd_atendimento)

                                                 , :new.cd_prestador

                                                 , :new.cd_atendimento

                                                 , :new.nm_usuario

											     , :new.cd_objeto);

      -- Seta na pre_med o cd_documento_clinico associado

      :new.cd_documento_clinico := v_cd_documento_clinico;

    END IF;

  ELSIF UPDATING THEN

    IF :NEW.fl_impresso = 'S' OR :new.tp_pre_med = 'I' AND :NEW.fl_impresso = 'N' AND :new.sn_fechado = 'S' THEN

      UPDATE Dbamv.Pw_Documento_clinico SET tp_status = 'FECHADO', dh_fechamento = nvl(dh_fechamento,SYSDATE)

      WHERE cd_documento_Clinico = :Old.Cd_Documento_Clinico and tp_status <> 'ASSINADO';

    END IF;

    --verifica se o registro foi reaberto e se não é prescrição tratamento filha

    IF ((:OLD.FL_IMPRESSO = 'S') AND (:NEW.FL_IMPRESSO = 'N'))

      AND ((:new.tp_pre_med <> 'F' AND dbamv.fnc_pep_busca_tipo_objeto(:new.cd_objeto) = 'TRATMT')

            OR dbamv.fnc_pep_busca_tipo_objeto(:new.cd_objeto) <> 'TRATMT') THEN

      --Recupera cd_tipo_documento do documento clínico que foi cancelado

        v_cd_tipo_documento := dbamv.fnc_pep_busca_cod_tip_doc_clin(:Old.Cd_Documento_Clinico);



		--Recupera o status do documento clínico para ver se deve ou não realizar o cancelamento do mesmo e a criação de um novo

		Open cDocClinico(:Old.Cd_Documento_Clinico);

		Fetch cDocClinico Into vTpStatus;

		Close cDocClinico;



      --Deve realizar o cancelamento e criação de um novo documento clínico somente se o atual estiver ASSINADO (alinhado com Gyzelle e Camacho)

      IF (vTpStatus IS NOT NULL AND vTpStatus = 'ASSINADO') THEN

            -- Cancela documento clínico pois a prescrição foi reaberta.

      		UPDATE Dbamv.Pw_Documento_clinico SET tp_status = 'CANCELADO'

      		WHERE cd_documento_Clinico = :Old.Cd_Documento_Clinico;

      		-- Inserir novo documento clínico após o documento que estava associado à prescrição cancelada ter sido cancelado também.

      		select dbamv.seq_pw_documento_clinico.nextval

        		into v_cd_documento_clinico

        	from dual;

		  	insert into dbamv.pw_documento_clinico ( cd_documento_clinico

                                                 	, cd_tipo_documento

                                                 	, tp_status

                                                 	, dh_referencia

                                                 	, dh_criacao

                                                 	, dh_fechamento

                                                 	, dh_impresso

											     	, dh_documento

                                                 	, cd_paciente

                                                 	, cd_prestador

                                                 	, cd_atendimento

                                                 	, cd_usuario

                                                 	, cd_objeto

                                                 	, cd_documento_cancelado)

		                                  	values ( v_cd_documento_clinico

                                                 	, v_cd_tipo_documento

                                                 	, 'ABERTO'  -->> tp_status

                                                 	, :new.dt_referencia

                                                 	, SYSDATE

                                                 	, NULL

                                                 	, NULL

											     	, sysdate

                                                 	, dbamv.FNC_PEP_BUSCA_CODIGO_PACIENTE(:new.cd_atendimento)

                                                 	, :new.cd_prestador

                                                 	, :new.cd_atendimento

                                                 	, :new.Nm_Usuario

                                                 	, :new.cd_objeto

                                                 	, :old.cd_documento_clinico);

      		-- Seta na pre_med o novo cd_documento_clinico associado

      		:new.cd_documento_clinico := v_cd_documento_clinico;

      END IF;



    END IF;

    --Para casos de conversão de prescrição de atendimento de urgência para internação, precisa atualizar o atendimento do documento clínico

    IF :old.cd_atendimento <> :new.cd_atendimento THEN

        UPDATE Dbamv.Pw_Documento_clinico

           SET cd_atendimento = :new.cd_atendimento

         WHERE cd_documento_Clinico = :Old.Cd_Documento_Clinico;

    END IF;

  ELSIF DELETING THEN

     DELETE FROM dbamv.pw_documento_clinico

      WHERE cd_documento_clinico =  :Old.Cd_documento_Clinico;

  END IF;

END;

/
ALTER TRIGGER "DBAMV"."TRG_PRE_MED_REG_DOCUM_CLINC" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PRE_MED_GERA_LOG_CONS_FIM"
AFTER UPDATE OF fl_impresso ON dbamv.pre_med
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
	AUX_CD_TRIAGEM_ATENDIMENTO     DBAMV.TRIAGEM_ATENDIMENTO.CD_TRIAGEM_ATENDIMENTO%TYPE := NULL;
	VINICIO DBAMV.SACR_TEMPO_PROCESSO.CD_TIPO_TEMPO_PROCESSO%TYPE := NULL;
    VFINAL  DBAMV.SACR_TEMPO_PROCESSO.CD_TIPO_TEMPO_PROCESSO%TYPE := NULL;
-- VERIFICA A EXISTÊNCIA DE REGISTROS REFERENTES AO INÍCIO DE UMA CONSULTA
	CURSOR CINICIO IS
	SELECT CD_TIPO_TEMPO_PROCESSO
	FROM SACR_TEMPO_PROCESSO
	WHERE CD_ATENDIMENTO     = :NEW.CD_ATENDIMENTO
	AND CD_TIPO_TEMPO_PROCESSO = 31;
-- VERIFICA A EXISTÊNCIA DE REGISTROS REFERENTES AO FIM DE UMA CONSULTA
	CURSOR CFINAL IS
	SELECT CD_TIPO_TEMPO_PROCESSO
	FROM SACR_TEMPO_PROCESSO
	WHERE CD_ATENDIMENTO     = :NEW.CD_ATENDIMENTO
	AND CD_TIPO_TEMPO_PROCESSO = 32;
-- RETORNA O TIPO DE ATENDIMENTO, O NOME DO USUÁRIO E O CÓDIGO DE MULTI EMPRESA
	CURSOR cATENDIME IS
	SELECT TP_ATENDIMENTO, NM_USUARIO, CD_MULTI_EMPRESA
	FROM DBAMV.ATENDIME
	WHERE CD_ATENDIMENTO IS NOT NULL
	AND CD_ATENDIMENTO      = :NEW.CD_ATENDIMENTO;
--            RETORNA O CÓDIGO DA TRIAGEM REFERENTE AO ATENDIMENTO
	CURSOR cCOD_TRIAGEM IS
	SELECT CD_TRIAGEM_ATENDIMENTO
	FROM DBAMV.TRIAGEM_ATENDIMENTO
	WHERE DH_PRE_ATENDIMENTO IN (SELECT MAX(DH_PRE_ATENDIMENTO)
	FROM DBAMV.TRIAGEM_ATENDIMENTO
	WHERE CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO)
	AND CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO;
	vATENDIME cATENDIME%ROWTYPE;
	AUX_TP_ATENDIMENTO          vATENDIME.TP_ATENDIMENTO%TYPE;
	AUX_NM_USUARIO              vATENDIME.NM_USUARIO%TYPE;
	AUX_CD_MULTI_EMPRESA        vATENDIME.CD_MULTI_EMPRESA%TYPE;
BEGIN
-- Gravado o processo de finalização do atendimento apenas quando finalizar a prescrição
IF :old.fl_impresso = 'N' and :new.fl_impresso = 'S' THEN
	OPEN  cINICIO;
    FETCH cINICIO INTO VINICIO;
    CLOSE cINICIO;
    OPEN  CFINAL;
    FETCH CFINAL INTO VFINAL;
    CLOSE CFINAL;
--            OS CURSORES DETERMINAM SE EXISTE INÍCIO OU FIM DE UMA CONSULTA.
    OPEN  cATENDIME;
    FETCH cATENDIME INTO vATENDIME;
    CLOSE cATENDIME;
	AUX_TP_ATENDIMENTO         := vATENDIME.TP_ATENDIMENTO;
	AUX_NM_USUARIO             := vATENDIME.NM_USUARIO;
	AUX_CD_MULTI_EMPRESA       := vATENDIME.CD_MULTI_EMPRESA;
--            VERIFICA SE O ATENDIMENTO REALIZADO É URGÊNCIA, E NESTE CASO, ALIMENTA A VARIÁVEL QUE INDICA
--            O CÓDIGO DA TRIAGEM.
	IF(AUX_TP_ATENDIMENTO  IN ('U','A')) THEN

		OPEN  cCOD_TRIAGEM;
		FETCH cCOD_TRIAGEM INTO AUX_CD_TRIAGEM_ATENDIMENTO;
		CLOSE cCOD_TRIAGEM;

--      VERIFICA SE A CONSULTA JA FOI INICIADA,
--      E NESTE CASO, CHAMA A PROCEDURE QUE IRÁ GRAVAR OS DADOS RELATIVOS AO FIM DA CONSULTA.

		IF (VINICIO IS NOT NULL) THEN
         --Se o atendimento já estiver sido iniciado, será incluido o tipo 32
			PRC_SACR_CHAMADA_PAINEL_MV(:NEW.CD_ATENDIMENTO, AUX_CD_TRIAGEM_ATENDIMENTO, AUX_CD_MULTI_EMPRESA, NULL, 32, AUX_NM_USUARIO, sysdate, 'N');
		ELSE
         --Se o atendimento não estiver sido iniciado, esta prescrição iniciará o atendimento
			PRC_SACR_CHAMADA_PAINEL_MV(:NEW.CD_ATENDIMENTO, AUX_CD_TRIAGEM_ATENDIMENTO, AUX_CD_MULTI_EMPRESA, NULL, 31, AUX_NM_USUARIO, sysdate, 'N');
		END IF;

    END IF;
END IF;
	EXCEPTION
		WHEN OTHERS THEN
			--MULTI-IDIOMA: Utilização do pkg_rmi_traducao.extrair_msg para mensagens (MSG_1)
			RAISE_APPLICATION_ERROR(-20003,pkg_rmi_traducao.extrair_proc_msg('MSG_1', 'TRG_PRE_MED_GERA_LOG_CONS_FIM', 'ERRO AO EXECUTAR A TRIGGER DBAMV.TRG_PRE_MED_GERA_LOG_CONS_FIM: %s - %s', arg_list(SQLCODE, SQLERRM)));
END;





/
ALTER TRIGGER "DBAMV"."TRG_PRE_MED_GERA_LOG_CONS_FIM" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PRE_MED_CHECA_ALTER_PREST"
BEFORE UPDATE
 OF CD_PRESTADOR
 ON DBAMV.PRE_MED
REFERENCING
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW

DECLARE

	Cursor cursorCodigoSequencial is SELECT Dbamv.SEQ_PW_LOG_PRE_MED.NextVal FROM dual;
	codigoSequencial  number;

BEGIN

     open  cursorCodigoSequencial;
     fetch cursorCodigoSequencial into codigoSequencial;
     close cursorCodigoSequencial;

    IF :OLD.CD_PRESTADOR != :NEW.CD_PRESTADOR THEN

		 INSERT INTO DBAMV.PW_LOG_PRE_MED(

			CD_PW_LOG_PRE_MED,
			CD_PRE_MED,
			CD_PRESTADOR_ANTERIOR,
			CD_USUARIO_ANTERIOR,
			DH_CRIACAO_ANTERIOR,
			CD_PRESTADOR,
			CD_USUARIO,
			DH_CRIACAO
	  )
		VALUES (
			codigoSequencial,
			:OLD.CD_PRE_MED,
			:OLD.CD_PRESTADOR,
			:OLD.NM_USUARIO,
			:OLD.DH_CRIACAO,
			:NEW.CD_PRESTADOR,
			:NEW.NM_USUARIO,
			:NEW.DH_CRIACAO
			);
    END IF;

END;






/
ALTER TRIGGER "DBAMV"."TRG_PRE_MED_CHECA_ALTER_PREST" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PRE_MED_ALTERA_PROT_TRATMT"
   Before Update Of fl_impresso On dbamv.pre_med
     For each Row
Declare
   Cursor cObjeto Is
      Select Tp_Objeto
        From Dbamv.Pagu_Objeto
       Where Cd_Objeto = :New.Cd_Objeto;
   vTp_Objeto  Dbamv.Pagu_Objeto.Tp_Objeto%Type;
   --
   Cursor cPadrao Is
     Select 1
       From (select nvl(cd_itpre_pad,0) cd_itpre_pad
               from dbamv.itpre_med
              where cd_pre_med = :new.cd_pre_med
             minus
             select cd_itpre_pad
               from dbamv.itpre_pad
              where cd_pre_pad = :new.cd_pre_pad
                and sn_ativo   = 'S'
             union all
             select cd_itpre_pad
               from dbamv.itpre_pad
              where cd_pre_pad  = :new.cd_pre_pad
                and sn_ativo    = 'S'
             minus
             select cd_itpre_pad cd_itpre_pad
               from dbamv.itpre_med
              where cd_pre_med = :new.cd_pre_med
                and cd_itpre_pad is not null);
   vExiste    Number(1);
   vformula   Number; -- PDA 517136
   --
   Cursor cQuant Is
      select it.cd_itpre_pad,
             it.qt_itpre_med,
             it.qt_infusao,
             it.cd_uni_pro_inf
        from dbamv.itpre_med it,
             dbamv.tip_presc tip,
             dbamv.tip_esq   esq
       where it.cd_tip_presc = tip.cd_tip_presc
         and tip.cd_tip_esq  = esq.cd_tip_esq
         and it.cd_pre_med   = :new.cd_pre_med
         and it.cd_itpre_pad is not null
      minus
      select it.cd_itpre_pad,
             qt_itpre_pad,
             it.qt_infusao,
             it.cd_uni_pro_inf
        from dbamv.itpre_pad it,
             dbamv.tip_presc tip,
             dbamv.tip_esq   esq
       where it.cd_tip_presc = tip.cd_tip_presc
         and tip.cd_tip_esq  = esq.cd_tip_esq
         and it.sn_ativo     = 'S'
         and it.cd_pre_pad   = :new.cd_pre_pad;
   --
   rQuant    cQuant%RowTYpe;
   --
   Cursor cPre_Pad (pCd_ItPre_Pad In Number) Is
      Select qt_itpre_pad,
             it.qt_infusao,
             it.cd_uni_pro_inf
        From dbamv.itpre_pad it,
             dbamv.tip_presc tip,
             dbamv.tip_esq   esq
       Where it.cd_tip_presc = tip.cd_tip_presc
         And tip.cd_tip_esq  = esq.cd_tip_esq
         And it.cd_itpre_pad = pCd_ItPre_Pad;
   --
   vPre_Pad   cPre_Pad%RowType;
 Begin
     If :Old.Fl_Impresso = 'N' And :New.Fl_Impresso = 'S' And :New.Cd_Pre_Med_Tratmt Is Null Then
        Open  cObjeto;
        Fetch cObjeto Into vTp_Objeto;
        Close cObjeto;
        --
        If vTp_Objeto = 'TRATMT' Then
           Open  cPadrao;
           Fetch cPadrao into vExiste;
              If ( cPadrao%Found ) Then
                 :New.Sn_Altera_Protocolo_Tratamento := 'S';
              End If;
           Close cPadrao;
           --
           If Nvl(vExiste,0) != 1 Then
              For c in cQuant
              Loop
                  Open  cPre_Pad(c.cd_itpre_pad);
                  Fetch cPre_Pad Into vPre_Pad;
                  Close cPre_Pad;
                  --
                  If Nvl(c.qt_infusao,0)       != Nvl(vPre_Pad.qt_infusao,0) Or
                     Nvl(c.cd_uni_pro_inf,0) != Nvl(vPre_Pad.cd_uni_pro_inf,0) Then
                     :New.Sn_Altera_Protocolo_Tratamento := 'S';
                  Else
                     If c.qt_itpre_med != Nvl(Dbamv.Pkg_Avaliacao.Fnc_Formula_ItPre_Pad(c.cd_itpre_pad, :New.Cd_Atendimento, vformula ), vPre_Pad.Qt_ItPre_Pad) Then -- PDA 517136
                        :New.Sn_Altera_Protocolo_Tratamento := 'S';
                     End If;
                  End If;
              End Loop;
           End If;
        End If;
     End If;
End;




/
ALTER TRIGGER "DBAMV"."TRG_PRE_MED_ALTERA_PROT_TRATMT" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_U_PRE_MED"
 AFTER
 UPDATE OF TP_PRE_MED, FL_IMPRESSO, DT_REFERENCIA
 ON dbamv.pre_med
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN
/****************************************************************************************************************
AUTOR..........: Desconhecido                                        Autor da definiÃ§Ã£o: Keilla
DATA ..........: 02/03/2004
FUNCIONALIDADE.: Dispara qdo Ã© atualizada a flag de impressÃ£o da prescriÃ§Ã£o. Ao alterar de 'N' p/ 'S'
                 (imprimir a prescriÃ§Ã£o),Ã© criada a equipe mÃ©dica na conta do paciente p/ os procedimentos da
                 referida prescriÃ§Ã£o que exigem equipe.Qdo altera de 'S' p/ 'N' Ã© excluÃ­do os itens de itped_lab
*****************************************************************************************************************/
DECLARE
   CURSOR C_PED_LAB IS
      SELECT cd_ped_lab
      FROM   dbamv.ped_lab
      WHERE  cd_pre_med = :new.cd_pre_med;
   vCd_Mov_Cardapio NUMBER;
   vTp_Mov          CHAR;
   -- pda 87035 inicio( Verifica o tipo de conv~enio do atendimento)
   Cursor cTipoConv is
     Select conv.tp_convenio
       From dbamv.convenio conv,
            dbamv.atendime atend
        Where atend.cd_convenio = conv.cd_convenio
          and atend.cd_multi_empresa = dbamv.Pkg_Mv2000.Le_Empresa
          and atend.cd_atendimento = :new.cd_atendimento;  -->> NÃ£o Ã© preciso de condiÃ§Ã£o de multi-empresa, pois a restriÃ§Ã£o deve ser feita  em tela
   --PDA 256464
   Cursor cCdPaciente (pCd_Paciente Number)Is
     Select Cd_Res_Lei, Cd_Pre_Med
       From Dbamv.Res_Lei
      Where Cd_Paciente = pCd_Paciente
        And Trunc(Dt_Reserva) Between Trunc(Sysdate) - 1
                                  And Trunc(Sysdate + 12/24); -- PDA 542100
   vTpConvenio             varchar2(1):=null;
   vCd_Res_Lei             Number;
   vCd_Pre_Med_Res_Lei     Number; -- PDA 542100
   -- pda 87035 fim
  -- PDA 155599 (Inicio) - Henrique Antunes - 14/12/2006
  Cursor C_ConfigPresc is
  select sn_prescricao_automatica
  from   dbamv.config_ffcv
  where  cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;
  cSnPreMed varchar2(1);
  -- PDA 155599 (Fim)
  --
  -- Cursor para obter o tipo de objeto da prescriÃ§Ã£o
  CURSOR c_tp_objeto IS
    SELECT tp_objeto
      FROM dbamv.pagu_objeto
     WHERE cd_objeto = :new.cd_objeto;
  -- Cursor para obter o valor do parametro da chave
  --
  CURSOR c_vl_parametro IS
    SELECT pr.VL_PARAMETRO
      FROM dbamv.pagu_objeto_parametro pr,
           dbamv.Pw_Parametro_Pagu_Objeto ppo
     WHERE
       ppo.CD_PARAMETRO_PAGU_OBJETO = pr.CD_PARAMETRO_PAGU_OBJETO
       AND ppo.NM_PARAMETRO = 'SN_CRIAR_NOVA_RESERVA_LEITO'
       AND pr.cd_objeto = :new.cd_objeto;
  --
  -- Armazena o tipo de objeto da prescriÃ§Ã£o
  v_tp_objeto dbamv.pagu_objeto.tp_objeto%type;
  -- Armazena o valor do parametro do objeto INTERN
  v_vl_parametro dbamv.pagu_objeto_parametro.vl_parametro%type;
  -- Indica se a prescriÃ§Ã£o deve gerar solicitaÃ§Ãµes:
  v_sn_gerar_solicitacoes VARCHAR2(1);
BEGIN
  OPEN c_tp_objeto;
  FETCH c_tp_objeto INTO v_tp_objeto;
  CLOSE c_tp_objeto;
  -- As prescriÃ§Ãµes que possuem tipo de objeto RECEIT nÃ£o devem gerar solicitaÃ§Ãµes
  IF v_tp_objeto IS NOT NULL AND v_tp_objeto = 'RECEIT' THEN
    v_sn_gerar_solicitacoes := 'N';
  ELSE
    v_sn_gerar_solicitacoes := 'S';
  END IF;
  IF v_tp_objeto IS NOT NULL AND v_tp_objeto = 'INTERN' THEN

    OPEN  c_vl_parametro;
    FETCH c_vl_parametro INTO v_vl_parametro;
    CLOSE c_vl_parametro;
  END IF;
  -- PDA 154303(Inicio)
  -- Geracao automatica da pre-internacao, apenas para prescricao de internado
  if (:old.fl_impresso = 'N' and :new.fl_impresso = 'S' and :new.tp_pre_med = 'A') then
    for x in (select pac.cd_paciente        ,pac.cd_cidade                                                ,pac.nm_paciente
                    ,Decode(pac.tp_sexo,'I','A',pac.tp_sexo) tp_sexo  ,pac.tp_estado_civil                ,pac.ds_endereco
                    ,pac.cd_profissao       ,pac.nr_cep                                                   ,pac.nr_documento
                    ,pac.nr_fone            ,pac.nm_usuario                                               ,pac.nr_cpf
                    ,pac.ds_complemento     ,pac.nr_endereco                                              ,pac.ds_observacao
/* PDA 499386 AROS */,ate.cd_multi_empresa   ,pac.nm_bairro                                                ,ate.cd_atendimento
                    ,ate.cd_ori_ate         ,ate.cd_convenio                                              ,ate.cd_pro_int
                    ,ate.cd_prestador       ,ate.cd_leito                                                 ,ate.cd_cid
                    ,ate.cd_servico   ,nvl(ate.dt_prevista_alta, add_months(sysdate,1)) dt_prevista_alta  ,ate.cd_tip_acom
                    ,ate.dt_val_guia        ,ate.nr_guia                                                  ,ate.cd_con_pla
                    ,ate.cd_tipo_internacao ,ate.sn_acompanhante                                          ,ate.cd_especialid
                    ,ate.cd_sub_plano       ,ate.nr_carteira                                              ,ate.dt_validade
                    ,ate.nm_empresa
                from dbamv.atendime  ate
                    ,dbamv.paciente  pac
               where ate.cd_atendimento = :new.cd_atendimento
                 and ate.cd_multi_empresa = dbamv.Pkg_Mv2000.Le_Empresa
                 and ate.cd_paciente    = pac.cd_paciente)loop
      --PDA 256464
      Open  cCdPaciente(x.cd_paciente);
      Fetch cCdPaciente Into vCd_Res_Lei, vCd_Pre_Med_Res_Lei; -- PDA 542100
      If vCd_Res_Lei is null OR (vCd_Res_Lei IS NOT NULL AND Nvl(v_vl_parametro,'N') = 'S') then
          insert into dbamv.res_lei
                (cd_res_lei                ,nm_paciente       ,ds_tratamento
                ,dt_reserva                ,dt_prev_alta      ,tp_sexo
                ,dt_prev_internacao        ,nr_fone           ,cd_cidade
                ,cd_convenio               ,cd_servico        ,cd_tip_acom
                ,cd_prestador              ,dt_chamado        ,hr_chamado
                ,cd_atendimento            ,cd_paciente       ,cd_leito
                ,sn_ativo                  ,cd_ori_ate        ,cd_con_pla
                ,sn_acompanhante           ,cd_cid            ,cd_pro_int
                ,cd_tipo_internacao        ,nr_guia           ,dt_val_guia
                ,nm_usuario                ,cd_senha          ,sn_checa_leito
                ,cd_tip_paren              ,nm_responsavel    ,tp_estado_civil
                ,cd_profissao              ,ds_nacionalidade  ,nr_fone_res
                ,ds_contato_familia        ,ds_endereco_res   ,nr_endereco_res
                ,ds_complemento_res        ,nm_bairro_res     ,cd_cidade_res
                ,ds_documento              ,nr_cpf            ,nr_carteira
                ,dt_validade               ,dt_ult_pgto       ,cd_empresa_carteira
                ,nm_empresa                ,nm_titular        ,nr_dias_autorizados
                ,ds_observacao             ,cd_multi_empresa  ,cd_aviso_cirurgia
                ,nm_usuario_desativa       ,nr_cep_res        ,nr_horas_autorizadas
                ,cd_especialid             ,cd_sub_plano      ,cd_unid_int
                ,cd_pre_med)
          values
                (dbamv.seq_res_lei.nextval   ,x.nm_paciente       ,null
                ,sysdate                     ,x.dt_prevista_alta  ,x.tp_sexo
                ,sysdate                     ,x.nr_fone           ,x.cd_cidade
                ,x.cd_convenio               ,x.cd_servico        ,null
                ,x.cd_prestador              ,null                ,null
                ,null                        ,x.cd_paciente       ,null
                ,'S'                         ,x.cd_ori_ate        ,x.cd_con_pla
                ,x.sn_acompanhante           ,x.cd_cid            ,x.cd_pro_int
                ,x.cd_tipo_internacao        ,x.nr_guia           ,x.dt_val_guia
                ,x.nm_usuario                ,null                ,null
                ,null                        ,null                ,x.tp_estado_civil
                ,x.cd_profissao              ,null                ,x.nr_fone
                ,null                        ,x.ds_endereco       ,x.nr_endereco
                ,x.ds_complemento            ,x.nm_bairro         ,x.cd_cidade
                ,x.nr_documento              ,x.nr_cpf            ,x.nr_carteira
                ,x.dt_validade               ,null                ,null
                ,x.nm_empresa                ,null                ,null
                ,x.ds_observacao             ,x.cd_multi_empresa  ,null
                ,null                        ,x.nr_cep            ,null
                ,x.cd_especialid             ,x.cd_sub_plano      ,:new.cd_unid_int
                ,:new.cd_pre_med);
      Else -- PDA 542100 (inicio)
		Update Dbamv.Res_Lei
		   Set Cd_Pre_Med = :New.Cd_Pre_Med, Dt_Prev_Internacao = sysdate
		 Where Cd_Res_Lei = vCd_Res_Lei;
      End If; -- PDA 542100 (fim)
      Close cCdPaciente;
    end loop;
    -- PDA 154303(Fim)
  end if;
  If ((:old.fl_impresso = 'N' and :new.fl_impresso = 'S' and :new.tp_pre_med Not In ( 'A', 'F' ) )
   or (:old.tp_pre_med In ( 'A', 'F' ) and :new.tp_pre_med = 'M')) then
    --
    Open C_ConfigPresc ;
    Fetch C_ConfigPresc into cSnPreMed ;
    Close C_ConfigPresc ;
    if nvl(cSnPreMed,'N') <> 'C' and v_sn_gerar_solicitacoes = 'S' then
       dbamv.prc_lanca_presc_ffcv (:new.cd_pre_med
                               ,:old.cd_pre_med
                               ,:new.cd_atendimento
                               ,:old.cd_atendimento
                               ,:new.hr_pre_med
                               ,:old.hr_pre_med
                               ,:new.cd_unid_int
                               ,:old.cd_unid_int
                               ,:new.cd_prestador
                               ,:old.cd_prestador
                               ,:new.cd_setor
                               ,:old.cd_setor
                               ,:new.dt_pre_med
                               ,:old.dt_pre_med
                               ,:new.fl_impresso
                               --,:old.fl_impresso -- 320791 Comentado
                               ,'N'                -- 320791
                               ,null
                               ,null);
    End If;
    --
      IF v_sn_gerar_solicitacoes = 'S' THEN
        DBAMV.GERA_PED_EXA_LAB(:NEW.CD_PRE_MED, :NEW.CD_ATENDIMENTO, :NEW.DT_PRE_MED, :NEW.HR_PRE_MED, :NEW.CD_PRESTADOR
        -- PDA 204742 Inicio
                           , :NEW.CD_SETOR);
        -- PDA 204742 Fim
        DBAMV.GERA_PSND(:NEW.CD_PRE_MED
                     ,:NEW.CD_ATENDIMENTO
                     ,pkg_pagu_itpremed.fnc_retorna_primeira_dieta
                     ,vCd_Mov_Cardapio
                     ,vTp_Mov
                     ,Dbamv.Fnc_Mv_Recupera_Data_Hora(:New.Dt_Pre_Med, :New.Hr_Pre_Med)); -- PDA 549206
        -->> Trata o retorno da Gera_Psnd para impressao DO Aviso
        If vCd_Mov_Cardapio is not null Then -- (Tï¿½rcio Arruda)
            Dbamv.Imprime_Aviso_Psnd(:NEW.Cd_Atendimento, vCd_Mov_Cardapio, vTp_Mov);
        End If;
        --
        DBAMV.GERA_PSDI(:NEW.CD_PRE_MED, :NEW.CD_ATENDIMENTO, :NEW.DT_PRE_MED, :NEW.HR_PRE_MED, :NEW.CD_PRESTADOR, :NEW.CD_UNID_INT,  :NEW.CD_SETOR);
      end if;
      DBAMV.ENVIA_MSG_ITENS_PRESC( :Old.Cd_Setor, :Old.Cd_Atendimento, :Old.Cd_Pre_Med, Trunc( :Old.Dt_Pre_Med ) + ( :Old.Hr_Pre_Med -  Trunc( :Old.Hr_Pre_Med ) ) );
      ----Integracao com SIH_SUS ----------------------------------------------
      dbamv.pack_lanca_ffis.Lanca_PAGU_FFIS ( :NEW.CD_ATENDIMENTO
                                            , :NEW.CD_PRE_MED
                                            , :NEW.CD_SETOR
                                            , :NEW.DT_PRE_MED
                                            , :NEW.HR_PRE_MED
                                            , :NEW.CD_PRESTADOR);
      --------------------------------------------------------------------------
      ---- Integracao com SIH_SUS ----------------------------------------------
      -- Pda 395953 inicio
      /*dbamv.pack_lanca_ffas.Lanca_PAGU_FFAS( :NEW.CD_ATENDIMENTO
                                           , :NEW.CD_PRE_MED
                                           , :NEW.CD_SETOR
                                           , :NEW.CD_PRESTADOR );*/


	    IF not (v_tp_objeto = 'TRATMT' and :NEW.CD_PRE_MED_TRATMT IS NULL) THEN

          dbamv.prc_ffas_lanca_pagu( :NEW.CD_ATENDIMENTO
                                   , :NEW.CD_PRE_MED
                                   , :NEW.CD_SETOR
                                   , :NEW.CD_PRESTADOR);

		  end if;
      -- Pda 395953 fim
      --------------------------------------------------------------------------
      --------------------------------------------------------------------------
      ---- Inclue ocorrencia de Antimicrobiano em DBAMV.HIST_AUDIT_PSIH --------
      dbamv.prc_lanca_hist_audit_psih ( :NEW.CD_ATENDIMENTO, :NEW.CD_PRE_MED, :NEW.DT_PRE_MED, :NEW.HR_PRE_MED );
      --------------------------------------------------------------------------
      --------------------------------------------------------------------------
      -- PDA 270868 (Inï¿½cio) - Ins
      --inserir registro de infecï¿½ï¿½o automaticamente
      ---- Insere registro de infecï¿½ï¿½o em DBAMV.Prc_Psih_Insere_Registro_Infec -
      If :OLD.FL_IMPRESSO = 'N' and :NEW.FL_IMPRESSO = 'S' Then
        --PDA 423873 - processo de prorrogaï¿½ï¿½o atm -- PDA 538560 (inicio)
     /*
      * GGMS - OP 30505 - Retirado trecho abaixo e incluido na procedure prc_pagu_fechar_prescricao para corrigir DEADLOCK na prescriï¿½ï¿½o medica.*
      For x In cDadosProrrogacao LOOP
          DBAMV.PRC_PSIH_AUDITA_PRORROGACAO( :new.cd_atendimento,
                                              x.cd_Produto,
                                             :new.dt_pre_med,
                                              x.nr_dia,
                                              x.cd_itpre_med,
                                             'T',
                                              vMensagem,
                                              vAcaoProrrogacao
                                           );
        END LOOP;

        --PDA 423873 - (Fim) -- PDA 538560 (fim)
         */
        --
        Dbamv.Prc_Psih_Insere_Registro_Infec ( :NEW.CD_PRE_MED, :NEW.DT_PRE_MED, :NEW.CD_ATENDIMENTO, :new.cd_prestador );
      End If;
      -- PDA 270868 (Fim)
      --------------------------------------------------------------------------
      ---- Inclue ocorrencia de Procedimento Invasivo em DBAMV.MOV_INV----------
      DBAMV.PRC_PSIH_ATUALIZA_MOV_INV ( :NEW.CD_PRE_MED, :NEW.CD_ATENDIMENTO, :NEW.DT_PRE_MED, :NEW.HR_PRE_MED,
                                        Null, Null);
      if v_sn_gerar_solicitacoes = 'S' then
        -- PDA 320228 (Inicio)
        dbamv.prc_pbsa_gera_solicitacao(  :new.cd_pre_med
                                        , :new.cd_atendimento
                                        , :new.dt_pre_med
                                        , :new.hr_pre_med
                                        , :new.cd_setor
                                        , :new.Fl_Impresso
                                        , :old.Fl_Impresso);
        -- PDA 320228 (Fim)
      end if;
      --------------------------------------------------------------------------
      /*  PDA 103913
          Procedimento que exclui os pedidos de exames Laboratoriais e de imagem caso existam itens associados sendo            suspensos*/
         Dbamv.PRC_PAGU_EXCLUI_PED_EXA (:new.Cd_Pre_Med ,:new.Cd_Atendimento);
         --Adicionado o parametro tp_pre_med - ggms
         -- Passando o novo parametro pkg_pagu_itpremed.fnc_retorna_primeira_dieta na prc_pagu_exclui_dieta
         dbamv.prc_pagu_exclui_dieta(:New.cd_pre_med
                                    ,:New.cd_atendimento
                                    ,pkg_pagu_itpremed.fnc_retorna_primeira_dieta
                                    ,:New.tp_pre_med
                                    ); -->> PDA 133574
      --- pda 170539 (Inicio) chama procedure que insere registros na apac pendente
      dbamv.prc_insere_apac_pendente(:new.cd_atendimento
                                ,:new.cd_prestador
                                ,:new.cd_pre_med
                                ,:new.dt_pre_med);
      --- pda 170539 (fim) ---
      /**********************************************************************************************************
        PDA: 87035 - 02/03/04 - Keilla Costa
        DESCRIï¿½ï¿½O: Esta trigger foi alterada , unindo ï¿½ funcionalidade jï¿½ existente o que a trigger da pitpre_med fazia.
                A de lï¿½ foi excluï¿½da . Qdo a Prescriï¿½ï¿½o for impressa, serï¿½ criada equipe mï¿½dica p/ o procedimento
      *********************************************************************************************************/
      Open  cTipoConv;
      Fetch cTipoConv into vTpConvenio;
      Close cTipoConv;
      if vTpConvenio in ('C','P') and v_sn_gerar_solicitacoes = 'S' then
      -- Gera equipe mï¿½dica na  itlan_med e na pitpre_med
       DBAMV.GERA_EQUIPE_MEDICA (:new.cd_pre_med,
                                 :new.cd_atendimento,
                                 :new.dt_pre_med,
                                 :new.hr_pre_med,
                                 :new.cd_unid_int,
                                 :new.cd_prestador,
                                 :new.cd_setor ) ;
      end if;
      --- pda 87035 fim ---
    if v_sn_gerar_solicitacoes = 'S' or v_tp_objeto = 'RECEIT' then
      --  PDA 478851 Inicio
      /**********************************************************************************************************
          PDA:478851 - 13/01/12 - Roberta Valï¿½ria
          DESCRIï¿½ï¿½O: Incluï¿½da a geraï¿½ï¿½o da solicitaï¿½ï¿½o da Guia Tis SPSADT.Esta geraï¿½ï¿½o vai ser feita atravï¿½s da chamada do objeto
          FNC_MVPEP_GERA_SOLICITACAO criado pela equipe de faturamento.
        ************************************************************************************************************/
        Declare
        Cursor CconvenioTiss is
        select count(*)
          from dbamv.convenio
               ,dbamv.atendime
               ,dbamv.convenio_conf_tiss conf_tiss
         where convenio.cd_convenio     = atendime.cd_convenio
           and conf_tiss.cd_convenio    = convenio.cd_convenio
           and convenio.tp_convenio     = 'C'
           and atendime.cd_atendimento  = :new.cd_atendimento;
        ---
        Cursor Cobjeto is
        Select tp_objeto
          From dbamv.pagu_objeto
         Where cd_objeto  = :new.cd_objeto;
         Cursor CconfigImpressaoTiss is
         Select count(*)
           From dbamv.config_pagu_impressao
          Where (tp_imprime_presc_med in ('A','S') and tp_relatorio = 'T')
                 OR (tp_imprime_exa_lab in ('A','S')  and tp_relatorio = 'T')
                   OR (tp_imprime_exa_ima in ('A','S')  and tp_relatorio = 'T');
       vRetFunc varchar2(2000);
       vConvenioTiss number(2);
       vpvMsg  varchar2(2000);
       vTpObjeto varchar2(6);
       --
        Begin
            Open  CconvenioTiss;
            Fetch CconvenioTiss into vConvenioTiss;
            Close CconvenioTiss;
            Open  Cobjeto;
            Fetch Cobjeto into vTpObjeto;
            Close Cobjeto;
            If nvl(vConvenioTiss,0) > 0  then
               vRetFunc := DBAMV.FNC_MVPEP_GERA_SOLICITACAO(:New.Cd_Pre_Med,null,:New.Cd_Atendimento,:New.Cd_Prestador,vTpObjeto,vpvMsg,null);
            End if;
         End;
        --  PDA 478851 Fim
      END IF;
   --
   -- inicio PDA: 566462 - 16/01/2013
   -- *** Gera as pendï¿½ncias na lista do Painel, para  a soluï¿½ï¿½o de atendimentos de urgï¿½ncia, a principio usado pela UPA ***
      if v_sn_gerar_solicitacoes = 'S' then
        Dbamv.Prc_MVPainel_Registra_Penden( :New.Cd_Pre_Med, :New.Cd_Atendimento, :New.Cd_Setor ); -- Pda 552196
      end if;
   --  Dbamv.Prc_MVPainel_Registra_Penden( :New.Cd_Pre_Med, :New.Cd_Atendimento, :New.Cd_Setor ); -- Inibido pelo Pda 552196
                  --
  ELSIF ((:OLD.FL_IMPRESSO = 'S') AND (:NEW.FL_IMPRESSO = 'N')) THEN
--      if v_sn_gerar_solicitacoes = 'S' then
--        Dbamv.Prc_MVPainel_Registra_Penden( :New.Cd_Pre_Med, :New.Cd_Atendimento, :New.Cd_Setor ); -- Pda 552196
--      end if;
      FOR C_record IN C_ped_lab LOOP
         DELETE DBAMV.ITPED_LAB
         WHERE  CD_PED_LAB = C_RECORD.CD_PED_LAB;
         DELETE DBAMV.PED_LAB
         WHERE  CD_PED_LAB = C_RECORD.CD_PED_LAB;
      END LOOP;
      --
   END IF;
   --
   -- tï¿½rmino PDA: 566462 - 16/01/2013
   --
   -- *** Aqui deve ficar todas as rotinas que devem ser disparadas a partir do momento que a prescriï¿½ï¿½o seja fechada,
   --   independente se ela jï¿½ vai estar vï¿½lida ou nï¿½o de acordo com os tipos de prescriï¿½ï¿½o:
   --        "(A) => Presc. de Internado" e "(F) => Presc. Futura"  ***
  -- *** Se a data de referï¿½ncia de uma prescriï¿½ï¿½o for alterada enquanto ela estiver fechada, uma nova solicitaï¿½ï¿½o
  --     de agendamento deve ser solicitada (Prescriï¿½ï¿½es futuras).
  IF :New.FL_IMPRESSO = 'S' AND (:Old.FL_IMPRESSO = 'N'
                                 OR :New.dt_referencia <> :Old.dt_referencia) THEN
     --
      Declare
        Cursor C_Item_Agendamento Is
          Select Tip_Presc.Cd_Item_Agendamento
                ,ItPre_Med.Cd_Itpre_Med
                ,ItPre_Med.ds_itpre_med
                ,To_Number(NULL) Cd_Tip_Presc
                ,Tip_Presc.cd_exa_lab
                ,Tip_Presc.cd_exa_rx
            From Dbamv.ItPre_Med
                , Dbamv.Tip_Presc
            Where ItPre_Med.Cd_Pre_Med = :New.Cd_Pre_Med
              And ItPre_Med.Cd_Tip_Presc = Tip_Presc.Cd_Tip_Presc
              And Tip_Presc.Cd_Item_Agendamento Is Not NULL
              AND  nvl( itpre_med.sn_cancelado , 'N') = 'N'
          Union All -- PDA 503589 (inicio)
          Select Tip_Presc.Cd_Item_Agendamento
                ,ItPre_Med.Cd_Itpre_Med
                ,ItPre_Med.ds_itpre_med
                ,CItpre_Med.Cd_Tip_Presc
                ,Tip_Presc.cd_exa_lab
                ,Tip_Presc.cd_exa_rx
            From Dbamv.CItPre_Med
                , Dbamv.ItPre_Med
                , Dbamv.Tip_Presc
            Where ItPre_Med.Cd_Pre_Med    = :New.Cd_Pre_Med
              And ItPre_Med.Cd_ItPre_Med  = CItPre_Med.Cd_ItPre_Med
              And CItPre_Med.Cd_Tip_Presc = Tip_Presc.Cd_Tip_Presc
              AND  nvl( itpre_med.sn_cancelado , 'N') = 'N'
              And Tip_Presc.Cd_Item_Agendamento Is Not Null; -- PDA 503589 (fim)
        --
        rItem_Agendamento C_Item_Agendamento%RowType;
        --
        Cursor cObjeto Is
            Select Tp_Objeto
              From Dbamv.Pagu_Objeto
            Where Cd_Objeto = :New.Cd_Objeto;
        vTp_Objeto Varchar2(30);
        --
        CURSOR cSessao IS
        SELECT Nr_Dia
          FROM Dbamv.Sessao_Tratamento
          WHERE Cd_Tratamento = :New.Cd_Tratamento
            AND Nr_Ciclo      = :New.Nr_Ciclo
            AND Nr_Sessao     = :New.Nr_Sessao;
        --
        nNrDia NUMBER;
        --
      Begin
        --
        FOR C1 IN  C_Item_Agendamento LOOP
            --
            Open  cObjeto;
            Fetch cObjeto Into vTp_Objeto;
            Close cObjeto;
            --
            -- *************************** --
            -- *** Rotina do MVPEP 2.0 *** --
            -- *************************** --
            IF    :New.Cd_Tratamento IS NOT NULL
              AND :New.Cd_Pre_Med_Tratmt Is not NULL
              AND :New.tp_pre_med = 'F'
              AND :New.fl_impresso = 'S' AND (:Old.fl_impresso = 'N'
                                              OR :New.dt_referencia <> :Old.dt_referencia) THEN
              --
                  --
                  OPEN  cSessao;
                  FETCH cSessao INTO nNrDia;
                  CLOSE cSessao;
                 --
                    Dbamv.Pkg_Pagu_Agendamento.Prc_Insere_Solic_Agendamento( C1.Cd_Item_Agendamento
                                                                , :New.Dt_Referencia
                                                                , :New.Cd_Atendimento
                                                                , C1.Cd_ItPre_Med
                                                                , :New.Cd_Tratamento
                                                                , :New.Nr_Ciclo
                                                                , nNrDia
                                                                , :New.Nr_Sessao
                                                                , 'N' -->> O faturamento sï¿½ funciona atualmente por sessï¿½o
                                                                , C1.Cd_Tip_Presc -- PDA 503589
                                                                , C1.ds_itpre_med
                                                                , Nvl(:New.Tp_Agendamento, 'QUI'));
              --
            ELSE
              --
              -- ***************************************************** --
              -- *** Rotina do PAGU, para prescricao de tratamento *** --
              -- ***************************************************** --
              If ( (vTp_Objeto = 'TRATMT' And :New.Cd_Pre_Med_Tratmt Is Null )
                  OR
                   (vTp_Objeto = 'MEDICA'
                     AND C1.CD_EXA_LAB IS NULL
                     AND C1.CD_EXA_RX IS NULL
                     And :New.Tp_Pre_Med In ('M', 'F') ) --SÃ£o rafael devido ao pagu tela de checagem nÃ£o interpretar o tipo TRATMT colocamos essa condiÃ§Ã£o para o objeto MEDICA
                   ) Then -- PDA 518186 -- PDA 503589
                --
                Dbamv.Pkg_Pagu_Tratamento.Prc_Valida_Dias_Prescricao(:New.Cd_Pre_Med);
                Dbamv.pkg_pagu_tratamento.acumula_variaveis(:new.cd_atendimento, :new.cd_prestador, :new.cd_setor);
                Dbamv.pkg_pagu_tratamento.cria_tratamento(:new.cd_pre_med,:new.cd_atendimento); --PDA 202158
                --
              -- ***************************************************** --
              -- *** Para prescriï¿½ï¿½o que nï¿½o seja de tratamento    *** --
              -- ***************************************************** --
              Elsif vTp_Objeto = 'RECEIT' or :new.tp_pre_med = 'F' Then
                --
                  Dbamv.Pkg_Pagu_Agendamento.Prc_Insere_Solic_Agendamento( C1.Cd_Item_Agendamento
                                                                , :New.Dt_Referencia
                                                                , :New.Cd_Atendimento
                                                                , C1.Cd_ItPre_Med
                                                                , NULL  --Cd_Tratamento
                                                                , NULL  --Nr_Ciclo
                                                                , 1     --NrDia
                                                                , NULL  --Nr_Sessao
                                                                , 'N' -->> O faturamento sÃ³ funciona atualmente por sessÃ£o
                                                                , C1.Cd_Tip_Presc -- PDA 503589
                                                                , C1.ds_itpre_med
                                                                , NULL);
                  --
                --
              End If;
           END IF;
        END LOOP;
      End;
      --
      -- Pda 518073 Inicio
      Dbamv.Pkg_Pagu_Tratamento.Prc_Popula_Dia_Tratamento (:New.Cd_Pre_Med);
      -- Pda 518073 Fim
  END IF;
END;
END TRG_U_PRE_MED;
/
ALTER TRIGGER "DBAMV"."TRG_U_PRE_MED" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_U_PRE_MED_SN_PREPARACAO"

 BEFORE UPDATE OF FL_IMPRESSO

 ON dbamv.pre_med

 REFERENCING OLD AS OLD NEW AS NEW

 FOR EACH ROW

DECLARE

   --PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN

   IF :NEW.FL_IMPRESSO = 'S' THEN



      --dbamv.PRC_GRAVA_LOG_ERRO('AGG', 'TRG_U_PRE_MED_SN_PREPARACAO', 'PREPARA_MED_1', 'PRE_MED: '||:new.cd_pre_med, 99991);



      UPDATE dbamv.Itpre_Med itpreMed

        SET itpreMed.sn_Preparacao = 'S'

      WHERE itpreMed.cd_pre_Med = :New.Cd_Pre_Med

        AND dbamv.fnc_mvpep_item_preparacao (itpreMed.cd_itPre_Med ) = 'S';



      --dbamv.PRC_GRAVA_LOG_ERRO('AGG', 'TRG_U_PRE_MED_SN_PREPARACAO', 'PREPARA_MED_2', 'PRE_MED: '||:new.cd_pre_med, 99992);



      dbamv.prc_pagu_gerar_etiqu_preparo ( :New.Cd_Pre_Med );



      --dbamv.PRC_GRAVA_LOG_ERRO('AGG', 'TRG_U_PRE_MED_SN_PREPARACAO', 'PREPARA_MED_3', 'PRE_MED: '||:new.cd_pre_med, 99993);

    END IF;



EXCEPTION WHEN OTHERS THEN

    dbamv.PRC_GRAVA_LOG_ERRO('AGG', 'TRG_U_PRE_MED_SN_PREPARACAO', 'PREPARA_MED_ERRO', 'PRE_MED: '||:new.cd_pre_med||' - '||sqlerrm, 99994);

    NULL;

END;

/
ALTER TRIGGER "DBAMV"."TRG_U_PRE_MED_SN_PREPARACAO" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_LANCA_PRESC_FFCV"
BEFORE UPDATE OF fl_impresso ON dbamv.PRE_MED
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare
  -- PDA 86938 -  Campos "cd_importa_reg_fat" e "cd_importa_reg_amb" - com base nesse dois campos sera verificado
  -- se a trigger realmente foi executada
BEGIN
  /* PDA 281046 (Início) - 06/04/2009 - Diego Costa - Melhoria de performance */
  /*
  for x in (select ate.tp_atendimento
        from dbamv.atendime ate
            ,dbamv.convenio con
            ,dbamv.empresa_convenio
       where ate.cd_atendimento = :new.cd_atendimento
         and ate.cd_multi_empresa = dbamv.Pkg_Mv2000.Le_Empresa
         and con.cd_convenio = empresa_convenio.cd_convenio                    */                                                                    /* pda 118607/129023*/
  /*       and empresa_convenio.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa */                                                                    /* pda 118607/129023*/
  /*       and con.cd_convenio = ate.cd_convenio) loop */
    --
  for x in (select ate.tp_atendimento
              from dbamv.atendime ate
             where ate.cd_atendimento = :new.cd_atendimento
               and ate.cd_multi_empresa = dbamv.Pkg_Mv2000.Le_Empresa) LOOP
  /* PDA 281046 (Fim) */
    if x.Tp_Atendimento = 'I' then
      :new.cd_importa_reg_fat := 0;
    else
      :new.cd_importa_reg_amb := 0;
    end if;
  end loop;
end;




/
ALTER TRIGGER "DBAMV"."TRG_LANCA_PRESC_FFCV" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_LOG_PRE_MED_TRATAMENTO"

 After Delete Or Update Of Tp_Pre_Med   -- OP 26413

    On dbamv.pre_med

 Referencing New as New

             Old as Old

 For Each Row

Declare

 Cursor cObjeto

     Is Select Pagu_Objeto.Tp_Objeto

          From Dbamv.Pagu_Objeto

         Where Pagu_Objeto.Cd_Objeto = :Old.Cd_Objeto;

 Cursor cPrestador(cdUsuario In Varchar2) Is

    Select Cd_Prestador

    From Dbasgu.Usuarios

    Where cd_Usuario = cdUsuario;

 nCdUsuario Varchar2(30) := Dbamv.Pkg_Mv_Variaveis.Fnc_Get_Usuario();

 nCdPrestador Dbamv.Prestador.Cd_Prestador%Type;

 rObjeto      cObjeto%RowType;

 vTp_Operacao  Varchar2(3); -- OP 26413

Begin

     Open  cObjeto;

     Fetch cObjeto Into rObjeto;

     Close cObjeto;

     --

     If Deleting Then -- OP 26413 (inicio)

        vTp_Operacao := 'Exc';

     Elsif Updating Then

        vTp_Operacao := 'Alt';

     End If; -- OP 26413 (fim)

     --

     If  rObjeto.Tp_Objeto = 'TRATMT' Then



		 Open  cPrestador(nCdUsuario);

		 Fetch cPrestador Into nCdPrestador;

		 Close cPrestador;



		 Insert into Dbamv.Log_Pre_Med_Tratamento

			   (Cd_Log_Pre_Med_Tratamento

			  , Cd_Pre_Med_Tratmt

			  , Dh_Operacao

			  , Tp_Operacao

			  , Cd_Prestador_Operacao

			  , Cd_Usuario

			  , Cd_Pre_Med

			  , Cd_Atendimento

			  , Cd_Prestador

			  , Cd_Unid_Int

			  , Dt_Pre_Med

			  , Hr_Pre_Med

			  , Cd_Id_Usuario

			  , Cd_Solsai_Pro

			  , Sn_Fechado

			  , Sn_Rn

			  , Dt_Validade

			  , Fl_Principal

			  , Fl_Impresso

			  , Cd_Setor

			  , Tp_Pre_Med

			  , Nm_Usuario

			  , Dt_Referencia

			  , Sn_Transcricao

			  , Dh_Criacao

			  , Dh_Impressao

			  , Cd_Importa_Reg_Fat

			  , Cd_Importa_Reg_Amb

			  , Cd_Pre_Pad

			  , Cd_Objeto

			  , Nm_Usuario_Autorizador

			  , Cd_Registro_Clinico)

		Values (Dbamv.Seq_Log_Pre_Med_Tratamento.NextVal

			  , Nvl(:New.Cd_Pre_Med_Tratmt, :Old.Cd_Pre_Med_Tratmt)

			  , Sysdate

			  , vTp_Operacao -- OP 26413

			  , nCdPrestador

			  , Dbamv.Pkg_Mv_Variaveis.Fnc_Get_Usuario

			  , Nvl(:New.Cd_Pre_Med, :Old.Cd_Pre_Med)

			  , Nvl(:New.Cd_Atendimento, :Old.Cd_Atendimento)

			  , Nvl(:New.Cd_Prestador, :Old.Cd_Prestador)

			  , Nvl(:New.Cd_Unid_Int, :Old.Cd_Unid_Int)

			  , Nvl(:New.Dt_Pre_Med, :Old.Dt_Pre_Med)

			  , Nvl(:New.Hr_Pre_Med, :Old.Hr_Pre_Med)

			  , Nvl(:New.Cd_Id_Usuario, :Old.Cd_Id_Usuario)

			  , Nvl(:New.Cd_Solsai_Pro, :Old.Cd_Solsai_Pro)

			  , Nvl(:New.Sn_Fechado, :Old.Sn_Fechado)

			  , Nvl(:New.Sn_Rn, :Old.Sn_Rn)

			  , Nvl(:New.Dt_Validade, :Old.Dt_Validade)

			  , Nvl(:New.Fl_Principal, :Old.Fl_Principal)

			  , Nvl(:New.Fl_Impresso, :Old.Fl_Impresso)

			  , Nvl(:New.Cd_Setor, :Old.Cd_Setor)

			  , Nvl(:New.Tp_Pre_Med, :Old.Tp_Pre_Med)

			  , Nvl(:New.Nm_Usuario, :Old.Nm_Usuario)

			  , Nvl(:New.Dt_Referencia, :Old.Dt_Referencia)

			  , Nvl(:New.Sn_Transcricao, :Old.Sn_Transcricao)

			  , Nvl(:New.Dh_Criacao, :Old.Dh_Criacao)

			  , Nvl(:New.Dh_Impressao, :Old.Dh_Impressao)

			  , Nvl(:New.Cd_Importa_Reg_Fat, :Old.Cd_Importa_Reg_Fat)

			  , Nvl(:New.Cd_Importa_Reg_Amb, :Old.Cd_Importa_Reg_Amb)

			  , Nvl(:New.Cd_Pre_Pad, :Old.Cd_Pre_Pad)

			  , Nvl(:New.Cd_Objeto, :Old.Cd_Objeto)

			  , Nvl(:New.Nm_Usuario_Autorizador, :Old.Nm_Usuario_Autorizador)

			  , Nvl(:New.Cd_Registro_Clinico, :Old.Cd_Registro_Clinico));

	 End If;

Exception

 When Others Then

      Null;

End;

/
ALTER TRIGGER "DBAMV"."TRG_LOG_PRE_MED_TRATAMENTO" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PREMED_LANCA_FFAS"

 AFTER

 UPDATE OF TP_PRE_MED, FL_IMPRESSO

 ON dbamv.pre_med

 REFERENCING OLD AS OLD NEW AS NEW

 FOR EACH ROW



DECLARE

  CURSOR c_tp_objeto IS

    SELECT tp_objeto

      FROM dbamv.pagu_objeto

     WHERE cd_objeto = :new.cd_objeto;



  v_tp_objeto dbamv.pagu_objeto.tp_objeto%type;



BEGIN

  OPEN c_tp_objeto;

  FETCH c_tp_objeto INTO v_tp_objeto;

  CLOSE c_tp_objeto;

  IF ((:old.fl_impresso = 'N' and :new.fl_impresso = 'S' and :new.tp_pre_med Not In ( 'A', 'F' ) )

   OR (:old.tp_pre_med In ( 'A', 'F' ) and :new.tp_pre_med = 'M')) then

    --

	IF NOT (v_tp_objeto = 'TRATMT' and :NEW.CD_PRE_MED_TRATMT IS NULL) THEN

          dbamv.PRC_FFAS_LANCA_PREMED_APAC_LAU( :NEW.CD_ATENDIMENTO

                                   , :NEW.CD_PRE_MED

								   , :NEW.CD_PRE_MED_TRATMT

                                   , :NEW.DT_PRE_MED

								   , :NEW.CD_SETOR

                                   , :NEW.CD_PRESTADOR

								   , :NEW.NM_USUARIO

								   , NULL);



          dbamv.PRC_FFAS_LANCA_PREMED_APAC_CON( :NEW.CD_ATENDIMENTO

                                   , :NEW.CD_PRE_MED

								   , :NEW.CD_PRE_MED_TRATMT

                                   , :NEW.DT_PRE_MED

								   , :NEW.CD_SETOR

                                   , :NEW.CD_PRESTADOR

								   , :NEW.NM_USUARIO

								   , NULL);

     END IF;

  END IF;

END TRG_PREMED_LANCA_FFAS;

/
ALTER TRIGGER "DBAMV"."TRG_PREMED_LANCA_FFAS" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_CONSOLIDAR_FECHAM_PRE_MED"

  AFTER UPDATE OF tp_pre_med, fl_impresso ON dbamv.pre_med

  REFERENCING OLD AS OLD NEW AS NEW

  FOR EACH ROW

BEGIN

    /****************************************************************************************************************

    AUTOR..........: Aureo Bezerra Modolo

    DATA ..........: 03/10/2017

    FUNCIONALIDADE.: Dispara qdo atualizada a flag de impressao da prescricao. Objetiva consolidar os horarios

                     apos o fechamento da prescricao.

    *****************************************************************************************************************/

    DECLARE

        CURSOR c_hrit_pre_med IS

          SELECT HR.*

          FROM   dbamv.hritpre_med HR

                 join dbamv.itpre_med IT

                   ON HR.cd_itpre_med = IT.cd_itpre_med

          WHERE  IT.cd_pre_med = :NEW.cd_pre_med;

    BEGIN

        -- Reabertura

        IF (  :old.fl_impresso = 'S'

             AND :new.fl_impresso = 'N' ) THEN



          DELETE dbamv.pw_hritpre_med_prescricao hr

          WHERE EXISTS (

            SELECT 1

              FROM dbamv.itpre_med it

             WHERE hr.cd_itpre_med =  it.cd_itpre_med

               AND it.cd_pre_med = :NEW.cd_pre_med

          );



        -- Abertura

        ELSIF ( :old.fl_impresso = 'N'

             AND :new.fl_impresso = 'S' ) THEN

          FOR horario IN c_hrit_pre_med LOOP

              INSERT INTO dbamv.pw_hritpre_med_prescricao

                          (cd_hritpre_med_prescricao,

                           cd_itpre_med,

                           dh_medicacao,

                           cd_atendimento,

                           dh_cancelado,

                           cd_prest_canc,

                           cd_fechamento,

                           ds_horario,

                           dh_limite,

                           nr_dia,

                           sn_alterado_prestador,

                           nm_usuario,

                           dh_criacao,

                           nm_formulario,

                           nr_dia_tratamento,

                           cd_pre_med_sessao,

                           ds_observacao_aprazamento,

                           cd_usuario_aprazamento,

                           dh_conferencia,

                           cd_usuario_conferencia,

                           ds_codigo_barras_horario,

                           cd_justificativa_mobile,

                           tp_geracao,

                           qt_administrada,

                           cd_identificador)

              VALUES     ( dbamv.seq_pw_hritpre_med_prescricao.NEXTVAL,

                          horario.cd_itpre_med,

                          horario.dh_medicacao,

                          horario.cd_atendimento,

                          horario.dh_cancelado,

                          horario.cd_prest_canc,

                          horario.cd_fechamento,

                          horario.ds_horario,

                          horario.dh_limite,

                          horario.nr_dia,

                          horario.sn_alterado_prestador,

                          horario.nm_usuario,

                          horario.dh_criacao,

                          horario.nm_formulario,

                          horario.nr_dia_tratamento,

                          horario.cd_pre_med_sessao,

                          horario.ds_observacao_aprazamento,

                          horario.cd_usuario_aprazamento,

                          horario.dh_conferencia,

                          horario.cd_usuario_conferencia,

                          horario.ds_codigo_barras_horario,

                          horario.cd_justificativa_mobile,

                          horario.tp_geracao,

                          horario.qt_administrada,

                          horario.cd_identificador );

          END LOOP;

        END IF;

    END;

END trg_consolidar_fecham_pre_med;

/
ALTER TRIGGER "DBAMV"."TRG_CONSOLIDAR_FECHAM_PRE_MED" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PRE_MED_DATA_VALIDADE"
BEFORE INSERT OR UPDATE ON DBAMV.PRE_MED
FOR EACH ROW
DECLARE

  CURSOR C_CONFIG_SETOR IS
    SELECT QT_DIAS_PRESC_MED
      FROM DBAMV.CONFIG_PAGU_SETOR C
     WHERE C.CD_SETOR = :NEW.CD_SETOR;

  nQtDiasPresc NUMBER;
  dDataValidade DATE;
BEGIN

  OPEN C_CONFIG_SETOR;
   FETCH C_CONFIG_SETOR INTO nQtDiasPresc;
  CLOSE C_CONFIG_SETOR;

  IF Nvl(nQtDiasPresc,2) = 2 AND (Trunc(:NEW.DT_VALIDADE) - Trunc(:NEW.HR_PRE_MED)) > 1 THEN
      dDataValidade := :NEW.DT_VALIDADE ;
      :NEW.DT_VALIDADE := (dDataValidade - 1);
  END IF;

END;

/
ALTER TRIGGER "DBAMV"."TRG_PRE_MED_DATA_VALIDADE" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PRE_MED_TP_TRATMT"



BEFORE INSERT OR UPDATE OR DELETE ON dbamv.pre_med



FOR EACH ROW



BEGIN



	IF :new.cd_pre_med_tratmt IS NOT NULL AND :New.Tp_Agendamento IS NULL THEN

	--

	 :New.Tp_Agendamento := 'QUI';

	--

	END IF;



END;

/
ALTER TRIGGER "DBAMV"."TRG_PRE_MED_TP_TRATMT" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PRE_MED_SUSP_SOL"
   after update of fl_impresso on dbamv.pre_med
      referencing new as new old as old
      for each row
DECLARE

    deadlock_detected   EXCEPTION ;
    PRAGMA EXCEPTION_INIT(deadlock_detected, -60);
cursor citsolsaipro is
	select itsolsai_pro.cd_itsolsai_pro
	      ,solsai_pro.cd_solsai_pro
	      ,solsai_pro.tp_situacao
-- Pda 321635 Inicio
        ,nvl(itsolsai_pro.qt_atendida,0) qt_atendida
-- Pda 321635 Fim
      from dbamv.itsolsai_pro
          ,dbamv.itpre_med
          ,dbamv.solsai_pro
     where solsai_pro.cd_solsai_pro  = itsolsai_pro.cd_solsai_pro
       and itsolsai_pro.cd_itpre_med = itpre_med.cd_itpre_med_canc
       and itpre_med.cd_pre_med      = :new.cd_pre_med
       and itpre_med.sn_cancelado    = 'S'
       and itpre_med.sn_solicita     = 'S';

Cursor cExisteFracionamento(pcd_itsolsai_pro Number) Is
    Select Count(*) qtd
      From dbamv.fracionamento
     Where cd_itsolsai_pro = pcd_itsolsai_pro;

Cursor cExisteItemNaoCancelado(pcd_solsai_pro Number) Is
-- Pda 321635 Inicio
   Select Max(todos)      todos
         ,Max(atendidos)  atendidos
         ,Max(cancelados) cancelados
         ,Max(abertos)    abertos
   From (Select Count(*)  todos
               ,0         atendidos
               ,0         cancelados
               ,0         abertos
           From dbamv.itsolsai_pro
               ,dbamv.solsai_pro
          Where solsai_pro.cd_solsai_pro = pcd_solsai_pro
            And solsai_pro.cd_solsai_pro = itsolsai_pro.cd_solsai_pro
         Union
         Select 0         todos
               ,Count(*)  atendidos
               ,0         cancelados
               ,0         abertos
           From dbamv.itsolsai_pro
               ,dbamv.solsai_pro
          Where solsai_pro.cd_solsai_pro         = pcd_solsai_pro
            And solsai_pro.cd_solsai_pro         = itsolsai_pro.cd_solsai_pro
            and nvl(itsolsai_pro.qt_atendida,0) <> 0
            And (upper(nvl(ds_alerta_automatico,'xyz')) Like '%ITEM%N%ATENDIDO%CANCELADO%' OR upper(nvl(ds_alerta_automatico,'xyz')) Like '%TEM%N%ATENDIDO%CANCELADO%' OR upper(nvl(ds_alerta_automatico,'xyz')) Like '%TEM%N%ATENDIDO%ANULADO%')
         Union
         Select 0         todos
               ,0         atendidos
               ,Count(*)  cancelados
               ,0         abertos
           From dbamv.itsolsai_pro
               ,dbamv.solsai_pro
          Where solsai_pro.cd_solsai_pro        = pcd_solsai_pro
            And solsai_pro.cd_solsai_pro        = itsolsai_pro.cd_solsai_pro
            And (upper(nvl(ds_alerta_automatico,'xyz')) Like '%ITEM%N%ATENDIDO%CANCELADO%' OR upper(nvl(ds_alerta_automatico,'xyz')) Like '%TEM%N%ATENDIDO%CANCELADO%' OR upper(nvl(ds_alerta_automatico,'xyz')) Like '%TEM%N%ATENDIDO%ANULADO%')
         Union
         Select 0         todos
               ,0         atendidos
               ,0         cancelados
               ,Count(*)  abertos
           From dbamv.itsolsai_pro
               ,dbamv.solsai_pro
          Where solsai_pro.cd_solsai_pro         = pcd_solsai_pro
            And solsai_pro.cd_solsai_pro         = itsolsai_pro.cd_solsai_pro
            and nvl(itsolsai_pro.qt_atendida,0)  = 0
            And (upper(nvl(ds_alerta_automatico,'xyz')) Like '%ITEM%N%ATENDIDO%CANCELADO%' OR upper(nvl(ds_alerta_automatico,'xyz')) Like '%TEM%N%ATENDIDO%CANCELADO%' OR upper(nvl(ds_alerta_automatico,'xyz')) Like '%TEM%N%ATENDIDO%ANULADO%'));
-- Pda 321635 Fim
CURSOR cMsgTraduzidaItemCancelado IS
    SELECT DS_MENSAGEM
    FROM DBAMV.RMI_MENSAGEM
    WHERE CD_MODULO = 'TRG_PRE_MED_SUSP_SOL'
    AND NM_CONSTANTE_MENSAGEM = 'MSG_1'
    AND TP_MODULO = 'K'
    AND cd_idioma = (SELECT CD_IDIOMA FROM DBASGU.USUARIOS WHERE CD_USUARIO = pkg_mv_variaveis.fnc_get_usuario);

-- Pda 321635 Inicio
 vExisteItemNaoCancelado cExisteItemNaoCancelado%rowtype;
 vExisteFracionamento cExisteFracionamento%rowtype;
  vMsgTraduzida VARCHAR2(400);
-- Pda 321635 Fim

begin

	if nvl(:old.fl_impresso,'N') = 'N' and :new.fl_impresso = 'S' then

     for ritsolsaipro in citsolsaipro
     loop
         -- Pda 321635 Inicio
         If ((ritsolsaipro.tp_situacao = 'P') or (ritsolsaipro.tp_situacao = 'C' and ritsolsaipro.qt_atendida = 0)) Then -- Pda 321635 Fim
            OPEN cMsgTraduzidaItemCancelado;
			FETCH cMsgTraduzidaItemCancelado INTO vMsgTraduzida;
			CLOSE cMsgTraduzidaItemCancelado;

			Update dbamv.itsolsai_pro
               Set sn_conf_determ_usu   = 'S'
				  ,ds_alerta_automatico = nvl(vMsgTraduzida,'Atencao: O Item nao sera atendido, pois foi cancelado na prescricao.')
             Where cd_itsolsai_pro      = ritsolsaipro.cd_itsolsai_pro;
            --
            Open  cExisteFracionamento(ritsolsaipro.cd_itsolsai_pro);
            Fetch cExisteFracionamento Into vExisteFracionamento;
               if vExisteFracionamento.qtd > 0 Then
		            Update dbamv.fracionamento
			   	         Set qt_sobra        = 0
			       	   Where cd_itsolsai_pro = ritsolsaipro.cd_itsolsai_pro;
	       	   End if;
	       	Close cExisteFracionamento;
            --
            Open  cExisteItemNaoCancelado(ritsolsaipro.cd_solsai_pro);
            Fetch cExisteItemNaoCancelado Into vExisteItemNaoCancelado;
               if vExisteItemNaoCancelado.todos = vExisteItemNaoCancelado.atendidos then
                  Update dbamv.solsai_pro
                     Set tp_situacao   = 'S'
                   Where cd_solsai_pro = ritsolsaipro.cd_solsai_pro;
               elsif vExisteItemNaoCancelado.todos = vExisteItemNaoCancelado.cancelados then
                  Update dbamv.solsai_pro
                     Set tp_situacao   = 'A'
                   Where cd_solsai_pro = ritsolsaipro.cd_solsai_pro;
               elsif  vExisteItemNaoCancelado.todos = (vExisteItemNaoCancelado.atendidos + vExisteItemNaoCancelado.cancelados) then
                  Update dbamv.solsai_pro
                     Set tp_situacao   = 'S'
                   Where cd_solsai_pro = ritsolsaipro.cd_solsai_pro;
               elsif vExisteItemNaoCancelado.atendidos > 0 then
                  Update dbamv.solsai_pro
                     Set tp_situacao   = 'C'
                   Where cd_solsai_pro = ritsolsaipro.cd_solsai_pro;
               End If; -- Pda 321635 Fim
				    Close cExisteItemNaoCancelado;
            --
         End If;
     end loop;
	end if;

  Exception
  When deadlock_detected Then
      raise_application_error (-20001,'A prescricao esta em atendimento.');



end;

/
ALTER TRIGGER "DBAMV"."TRG_PRE_MED_SUSP_SOL" ENABLE;

CREATE INDEX "DBAMV"."PRE_MED_SETOR_FK_I" ON "DBAMV"."PRE_MED" ("CD_SETOR")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_01_IX" ON "DBAMV"."PRE_MED" ("CD_ATENDIMENTO", "DT_REFERENCIA", "TP_PRE_MED", "FL_IMPRESSO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_3_IX" ON "DBAMV"."PRE_MED" ("DT_PRE_MED")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_PRE_MED_FK" ON "DBAMV"."PRE_MED" ("CD_PRE_MED_TRATMT")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_DOC_ATD_OBJ" ON "DBAMV"."PRE_MED" ("CD_OBJETO", "CD_DOCUMENTO_CLINICO", "CD_ATENDIMENTO", "DT_REFERENCIA", "TP_PRE_MED")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_SESSAO_TRTM_FK" ON "DBAMV"."PRE_MED" ("CD_TRATAMENTO", "NR_CICLO", "NR_SESSAO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_5_IX" ON "DBAMV"."PRE_MED" ("CD_SOLSAI_PRO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_TP_SOLICITACAO_FK" ON "DBAMV"."PRE_MED" ("CD_TP_SOLICITACAO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_ATD_TP" ON "DBAMV"."PRE_MED" ("FL_IMPRESSO", "CD_ATENDIMENTO", "TP_PRE_MED", "SN_TRANSCRICAO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_6_IX" ON "DBAMV"."PRE_MED" ("DT_VALIDADE")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_D" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_7_IX" ON "DBAMV"."PRE_MED" ("CD_PRE_MED", "CD_ATENDIMENTO", "CD_PRESTADOR")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_REGISTRO_CLINC_FK" ON "DBAMV"."PRE_MED" ("CD_REGISTRO_CLINICO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_8_IX" ON "DBAMV"."PRE_MED" ("CD_PRE_MED", "CD_ATENDIMENTO", "CD_PRESTADOR", "CD_SETOR")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_4_IX" ON "DBAMV"."PRE_MED" ("FL_IMPRESSO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_1_IX" ON "DBAMV"."PRE_MED" ("DT_REFERENCIA")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."PRE_MED_ATENDIME_FK_I" ON "DBAMV"."PRE_MED" ("CD_ATENDIMENTO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_10_IX" ON "DBAMV"."PRE_MED" ("HR_PRE_MED")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."PRE_MED_UNID_INT_FK_I" ON "DBAMV"."PRE_MED" ("CD_UNID_INT")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."PRE_MED_PRE_PAD_FK_I" ON "DBAMV"."PRE_MED" ("CD_PRE_PAD")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PRE_MED_PAGU_OBJ_2_FK" ON "DBAMV"."PRE_MED" ("CD_OBJETO")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."PRE_MED_PRESTADOR_FK_I" ON "DBAMV"."PRE_MED" ("CD_PRESTADOR")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

GRANT SELECT ON "DBAMV"."PRE_MED" TO "UPFLUX";
  GRANT UPDATE ON "DBAMV"."PRE_MED" TO "MEDWISE" WITH GRANT OPTION;
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "MEDWISE" WITH GRANT OPTION;
  GRANT INSERT ON "DBAMV"."PRE_MED" TO "MEDWISE" WITH GRANT OPTION;
  GRANT DELETE ON "DBAMV"."PRE_MED" TO "MEDWISE" WITH GRANT OPTION;
  GRANT UPDATE ON "DBAMV"."PRE_MED" TO "MVAPI";
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "MVAPI";
  GRANT INSERT ON "DBAMV"."PRE_MED" TO "MVAPI";
  GRANT DELETE ON "DBAMV"."PRE_MED" TO "MVAPI";
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "IDCE";
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "DBACP" WITH GRANT OPTION;
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "DBAPORTAL" WITH GRANT OPTION;
  GRANT DELETE ON "DBAMV"."PRE_MED" TO "MV2000";
  GRANT INSERT ON "DBAMV"."PRE_MED" TO "MV2000";
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "MV2000";
  GRANT UPDATE ON "DBAMV"."PRE_MED" TO "MV2000";
  GRANT DELETE ON "DBAMV"."PRE_MED" TO "DBASGU";
  GRANT INSERT ON "DBAMV"."PRE_MED" TO "DBASGU";
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "DBASGU";
  GRANT UPDATE ON "DBAMV"."PRE_MED" TO "DBASGU";
  GRANT REFERENCES ON "DBAMV"."PRE_MED" TO "DBASGU";
  GRANT DELETE ON "DBAMV"."PRE_MED" TO "DBAPS";
  GRANT INSERT ON "DBAMV"."PRE_MED" TO "DBAPS";
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "DBAPS";
  GRANT UPDATE ON "DBAMV"."PRE_MED" TO "DBAPS";
  GRANT REFERENCES ON "DBAMV"."PRE_MED" TO "DBAPS";
  GRANT DELETE ON "DBAMV"."PRE_MED" TO "MVINTEGRA";
  GRANT INSERT ON "DBAMV"."PRE_MED" TO "MVINTEGRA";
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "MVINTEGRA" WITH GRANT OPTION;
  GRANT UPDATE ON "DBAMV"."PRE_MED" TO "MVINTEGRA";
  GRANT REFERENCES ON "DBAMV"."PRE_MED" TO "MVINTEGRA";
  GRANT SELECT ON "DBAMV"."PRE_MED" TO "MVBIKE" WITH GRANT OPTION;
  GRANT DELETE ON "DBAMV"."PRE_MED" TO "MVBIKE" WITH GRANT OPTION;
  GRANT INSERT ON "DBAMV"."PRE_MED" TO "MVBIKE" WITH GRANT OPTION;
  GRANT UPDATE ON "DBAMV"."PRE_MED" TO "MVBIKE" WITH GRANT OPTION;

COMMENT ON COLUMN DBAMV.PRE_MED.CD_OBJETO IS 'Codigo do Objeto - FK de PAGU_OBJETO';
COMMENT ON COLUMN DBAMV.PRE_MED.NM_USUARIO_AUTORIZADOR IS 'Usuario responsavel para autorização da prescrição.';
COMMENT ON COLUMN DBAMV.PRE_MED.CD_REGISTRO_CLINICO IS 'Especifica o RegistroClinico que foi realizado no atendimento';
COMMENT ON COLUMN DBAMV.PRE_MED.CD_PRE_MED_TRATMT IS 'Primary key da prescrição pai de tratamento';
COMMENT ON COLUMN DBAMV.PRE_MED.SN_ALTERA_PROTOCOLO_TRATAMENTO IS 'Se o protocolo da prescrição de tratamento foi alterado durante a prescrição';
COMMENT ON COLUMN DBAMV.PRE_MED.SN_PRESCRICAO_DIA_SEGUINTE IS 'Se a prescrição é uma prescrição criada para o dia seguinte';
COMMENT ON COLUMN DBAMV.PRE_MED.CD_USUARIO_CONVERSAO_PRESCRIC IS 'Usuário que fez a conversão da prescrição do dia seguinte para uma prescrição médica';
COMMENT ON COLUMN DBAMV.PRE_MED.DH_CONVERSAO_PRESCRICAO IS 'Data da conversão da prescrição futura para prescrição médica';
COMMENT ON COLUMN DBAMV.PRE_MED.NM_PRESCRICAO IS 'Nome da Prescrição para facil identificação no histórico';
COMMENT ON COLUMN DBAMV.PRE_MED.CD_DOCUMENTO_CLINICO IS 'O cÃ³digo do documento clÃ­nico, setado via trigger (fk)';
COMMENT ON COLUMN DBAMV.PRE_MED.CD_TRATAMENTO IS 'O cÃ³digo da sessÃ£o do tratamento';
COMMENT ON COLUMN DBAMV.PRE_MED.NR_CICLO IS 'Numero do ciclo de tratamento';
COMMENT ON COLUMN DBAMV.PRE_MED.NR_SESSAO IS 'Numero da sessÃ£o do tratamento';
COMMENT ON COLUMN DBAMV.PRE_MED.CD_PRE_MED_INTEGRA IS 'Código de-para da prescrição médica';
COMMENT ON COLUMN DBAMV.PRE_MED.CD_TP_SOLICITACAO IS 'Coluna que informa qual o tipo de solicitação foi selecionado no momento da criação da prescrição (FK)';
COMMENT ON COLUMN DBAMV.PRE_MED.SN_COPIADA IS 'Indica se a prescrição foi copiada';
COMMENT ON COLUMN DBAMV.PRE_MED.NR_PERCENTUAL_REDUCAO_QUANTD IS 'Indica o percentual a ser usado na redução da quantidade dos itens';
COMMENT ON COLUMN DBAMV.PRE_MED.DS_JUSTIFICATIVA_REDUCAO_QTD IS 'Justificativa para quando for marcado a redução da quantidade na tela de prescrição de tratamento';
COMMENT ON COLUMN DBAMV.PRE_MED.SN_CONCO_RADIOTERAPIA IS 'Se a PRE_MED é concomitante (realizado ao mesmo tempo) com a radioterapia ou não';
COMMENT ON COLUMN DBAMV.PRE_MED.TP_AGENDAMENTO IS 'TIPO DA SOLICITAÇÃO DE AGENDAMENTO. PODE SER QUI = QUIMIOTERAPIA, RAD = RADIOTERAPIA, FAR = FARMÁCIA.';
COMMENT ON COLUMN DBAMV.PRE_MED.SN_INTERROMPER_SESSAO IS 'Informa se a sessÃ£o de tratamento foi interrompida.';
COMMENT ON COLUMN DBAMV.PRE_MED.DS_JUSTIFICATIVA_INTERROMPER IS 'Justificativa informada ao interromper uma sessÃ£o de tratamento via tela de checagem.';
COMMENT ON COLUMN DBAMV.PRE_MED.DS_TOKEN_EXAMES_ONLINE IS 'Armazenamento do token ou URL para redirecionamento para o sistema de exames online da Unimed POA';