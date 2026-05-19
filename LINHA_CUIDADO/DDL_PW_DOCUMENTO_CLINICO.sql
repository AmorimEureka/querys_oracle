-- DBAMV.PW_DOCUMENTO_CLINICO definição

CREATE TABLE "DBAMV"."PW_DOCUMENTO_CLINICO" 
   (	"CD_DOCUMENTO_CLINICO" NUMBER(13,0) NOT NULL ENABLE, 
	"CD_TIPO_DOCUMENTO" NUMBER(13,0) NOT NULL ENABLE, 
	"CD_DOCUMENTO_DIGITAL" NUMBER(13,0), 
	"CD_PACIENTE" NUMBER(13,0), 
	"CD_ATENDIMENTO" NUMBER(13,0), 
	"CD_USUARIO" VARCHAR2(30), 
	"CD_PRESTADOR" NUMBER(13,0), 
	"TP_STATUS" VARCHAR2(9), 
	"DH_REFERENCIA" DATE, 
	"DH_CRIACAO" DATE, 
	"DH_FECHAMENTO" DATE, 
	"DH_IMPRESSO" DATE, 
	"TP_EXTENSAO" VARCHAR2(10), 
	"CD_SETOR" NUMBER(4,0), 
	"CD_OBJETO" NUMBER(10,0), 
	"CD_DOCUMENTO_CANCELADO" NUMBER(13,0), 
	"NM_DOCUMENTO" VARCHAR2(100), 
	"NM_VERSAO_DOCUMENTO" VARCHAR2(50), 
	"DH_DOCUMENTO" DATE, 
	"CD_DOCUMENTO_CLINICO_NOVO" NUMBER(13,0), 
	"CD_DOC_CLINICO_REFERENCIA" NUMBER(13,0), 
	"CD_USUARIO_AUTORIZADOR" VARCHAR2(30), 
	"SN_INTEGRA_GREEN" VARCHAR2(1), 
	"CD_MULTI_EMPRESA" NUMBER(4,0), 
	"SN_CONFIDENCIAL" VARCHAR2(1), 
	"QT_VIAS_IMPRESSAS" NUMBER(10,0), 
	"CD_DOCUMENTO_CLINICO_ANTERIOR" NUMBER(14,0), 
	"CD_ESPECIALIDADE_PRESTADOR" NUMBER, 
	 CONSTRAINT "CNT_SN_INTEGRA_GREEN_CK" CHECK (

    SN_INTEGRA_GREEN in ('S', 'N')

  ) ENABLE, 
	 CONSTRAINT "CNT_CONFIG_PAGU_44_CK" CHECK (

    SN_CONFIDENCIAL IN ('S','N')

  ) ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUMENTO_CLINICO_2_CK" CHECK (

    TP_EXTENSAO In ('IMAGEM','PDF','MVEDITOR','PDF_ANEXO')

  ) ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUMENTO_CLINICO_1_CK" CHECK (
    TP_STATUS in('IMPORTADO','ABERTO', 'FECHADO', 'ASSINADO', 'CANCELADO')
  ) ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUMENTO_CLINICO_PK" PRIMARY KEY ("CD_DOCUMENTO_CLINICO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I"  ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUMENTO_CLINICO_1_UK" UNIQUE ("CD_DOCUMENTO_DIGITAL")
  USING INDEX (CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINC_DOC_DIGI_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOCUMENTO_DIGITAL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" )  ENABLE, 
	 CONSTRAINT "CNT_DOC_CLI_ANTERIOR_FK" FOREIGN KEY ("CD_DOCUMENTO_CLINICO_ANTERIOR")
	  REFERENCES "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOCUMENTO_CLINICO") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUMENTO_CLINC_SET_FK" FOREIGN KEY ("CD_SETOR")
	  REFERENCES "DBAMV"."SETOR" ("CD_SETOR") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUM_CLIN_PW_TP_DOC_FK" FOREIGN KEY ("CD_TIPO_DOCUMENTO")
	  REFERENCES "DBAMV"."PW_TIPO_DOCUMENTO" ("CD_TIPO_DOCUMENTO") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUM_CLINC_ATENDIME_FK" FOREIGN KEY ("CD_ATENDIMENTO")
	  REFERENCES "DBAMV"."ATENDIME" ("CD_ATENDIMENTO") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUMENTO_CLINC_USU_FK" FOREIGN KEY ("CD_USUARIO")
	  REFERENCES "DBASGU"."USUARIOS" ("CD_USUARIO") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUMENTO_CLINC_PRES_FK" FOREIGN KEY ("CD_PRESTADOR")
	  REFERENCES "DBAMV"."PRESTADOR" ("CD_PRESTADOR") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUM_CLINC_DOC_DIGI_FK" FOREIGN KEY ("CD_DOCUMENTO_DIGITAL")
	  REFERENCES "DBAMV"."DOCUMENTO_DIGITAL" ("CD_DOCUMENTO_DIGITAL") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUM_CLI_PAGU_OBJ_FK" FOREIGN KEY ("CD_OBJETO")
	  REFERENCES "DBAMV"."PAGU_OBJETO" ("CD_OBJETO") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUM_CLIN_CANCEL_FK" FOREIGN KEY ("CD_DOCUMENTO_CANCELADO")
	  REFERENCES "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOCUMENTO_CLINICO") ENABLE, 
	 CONSTRAINT "PW_DOCUMENTO_CLINICO_ME_FK" FOREIGN KEY ("CD_MULTI_EMPRESA")
	  REFERENCES "DBAMV"."MULTI_EMPRESAS" ("CD_MULTI_EMPRESA") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUM_CLINC_PACIEN_FK" FOREIGN KEY ("CD_PACIENTE")
	  REFERENCES "DBAMV"."PACIENTE" ("CD_PACIENTE") ENABLE, 
	 CONSTRAINT "CNT_DOCUMENTO_CLIN_US_AUTZD_FK" FOREIGN KEY ("CD_USUARIO_AUTORIZADOR")
	  REFERENCES "DBASGU"."USUARIOS" ("CD_USUARIO") ENABLE, 
	 CONSTRAINT "CNT_PW_DOCUM_CLI_PW_DOC_CLI_FK" FOREIGN KEY ("CD_DOCUMENTO_CLINICO_NOVO")
	  REFERENCES "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOCUMENTO_CLINICO") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_D" ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_PW_DOCUMENTO_CLINICO_NTFC" 

	AFTER INSERT OR UPDATE OR DELETE ON DBAMV.PW_DOCUMENTO_CLINICO

	FOR EACH ROW



DECLARE



  cdNotificacao NUMBER;

  dsDetalhes VARCHAR(255);

  dsNotificacao VARCHAR(255);



  CURSOR descricaoNotificacao IS

    SELECT ds_tipo_documento || ' não assinado(a)'

    FROM pw_tipo_documento WHERE cd_tipo_documento = :NEW.cd_tipo_documento;



  CURSOR detalhesNotificacao IS

      SELECT

        (SELECT DBAMV.FNC_AS_NOME_PACIENTE(:NEW.CD_PACIENTE) FROM DUAL) ||

        (select ' - ' || setor.NM_SETOR FROM setor WHERE cd_setor = :NEW.CD_SETOR)

      FROM DUAL;



  CURSOR cCdNotificacaoAssinatura IS

    SELECT mvpep_notificacao.CD_NOTIFICACAO

    FROM dbamv.mvpep_notificacao, dbamv.notificacao

    WHERE

      notificacao.cd_notificacao = mvpep_notificacao.cd_notificacao AND

      notificacao.sn_resolvida = 'N' AND

      mvpep_notificacao.CD_DOCUMENTO_CLINICO = :NEW.CD_DOCUMENTO_CLINICO;



    PROCEDURE geraPendencia IS

    BEGIN



      OPEN descricaoNotificacao;

          FETCH descricaoNotificacao INTO dsNotificacao;

      CLOSE descricaoNotificacao;



      OPEN detalhesNotificacao;

        FETCH detalhesNotificacao INTO dsDetalhes;

      CLOSE detalhesNotificacao;



      -- Registra notificação

--      cdNotificacao := dbamv.FNC_REGISTRA_NOTIFICACAO('MVPEP_PENDENCIAS_ALERTAS', dsNotificacao, dsDetalhes);





	  return;



    END;



    PROCEDURE concluiPendencia IS

    BEGIN

      OPEN cCdNotificacaoAssinatura;

        FETCH cCdNotificacaoAssinatura INTO cdNotificacao;

      CLOSE cCdNotificacaoAssinatura;



        DBAMV.PRC_CONCLUI_NOTIFICACAO(cdNotificacao);

    END;



BEGIN



   -- Desabilitando a trigger até que a funcionalidade seja ajustada

   return;



  IF INSERTING THEN



    IF :NEW.TP_STATUS = 'FECHADO' THEN

      geraPendencia();

    END IF;



  ELSIF UPDATING THEN



    -- SE HOUVER ALTERAÇÃO DE STATUS

    IF :OLD.TP_STATUS <> :NEW.TP_STATUS THEN



      -- ESTÁ SENDO ABERTO ou CANCELADO ou ASSINADO

      IF :NEW.TP_STATUS = 'ABERTO' OR :NEW.TP_STATUS = 'CANCELADO' OR :NEW.TP_STATUS = 'ASSINADO' THEN

        concluiPendencia();

      END IF;



      -- ESTÁ SENDO FECHADO (gera pendência)

      IF :NEW.TP_STATUS = 'FECHADO' THEN

        geraPendencia();

      END IF;



    END IF;



  ELSIF DELETING THEN

    concluiPendencia();

  END IF;



  --Error

  EXCEPTION

    WHEN Others THEN

      null;



END;


/
ALTER TRIGGER "DBAMV"."TRG_PW_DOCUMENTO_CLINICO_NTFC" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_LOG_DOCUMENTO_CLINICO" 
AFTER UPDATE OR INSERT 
ON DBAMV.PW_DOCUMENTO_CLINICO
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE

	CURSOR cTpDocumentoPrescricao IS
		SELECT CD_TIPO_DOCUMENTO
		  FROM DBAMV.PW_TIPO_DOCUMENTO
		 WHERE TP_DOCUMENTO = 'PRESCR';
		 
	vCdTipoDocumento NUMBER := NULL;

BEGIN
	
	OPEN  cTpDocumentoPrescricao;
	FETCH cTpDocumentoPrescricao INTO vCdTipoDocumento;
	CLOSE cTpDocumentoPrescricao;

	IF (Inserting OR (Updating AND :OLD.TP_STATUS <> :NEW.TP_STATUS) ) AND :NEW.CD_TIPO_DOCUMENTO = vCdTipoDocumento  THEN
		
		DBAMV.PRC_REG_LOG_DOCUMENTO_CLINICO(:NEW.CD_DOCUMENTO_CLINICO,
		                                    :NEW.TP_STATUS,
                                            :NEW.CD_USUARIO);
		
		
	END IF;
	
END;

/
ALTER TRIGGER "DBAMV"."TRG_LOG_DOCUMENTO_CLINICO" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_U_DOC_CLINICO_AVAFAR" 
BEFORE UPDATE
ON Dbamv.Pw_Documento_Clinico
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
  --
  CURSOR C_Tipo_Documento IS
    SELECT Tp_Documento
      FROM Dbamv.Pw_Tipo_Documento
     WHERE Pw_Tipo_Documento.Cd_Tipo_Documento = :New.Cd_Tipo_Documento;
  --
  rTipoDocumento  C_Tipo_Documento%ROWTYPE;
  --
  cd_avaliacao_pre_med NUMBER;
  cd_unid_int NUMBER;
  cd_setor NUMBER;
  --
Begin
  --
  if :old.tp_status = 'ABERTO' and
     :new.tp_status IN ('FECHADO', 'ASSINADO') Then
    --
    -- *** A consulta do tipo de documento abaixo, precisa ficar separada do cursor de avaliacao para evitar trigger mutante, que ocorreu quando finalizava uma evolução ***
    OPEN  C_Tipo_Documento;
    FETCH C_Tipo_Documento INTO rTipoDocumento;
    CLOSE C_Tipo_Documento;
    --
    IF rTipoDocumento.Tp_Documento = 'AVAFAR' THEN
      --
      -- Carregando dados da pre_med a partir da procedure
      dbamv.prc_get_avafar_by_doc_cli( :new.cd_documento_clinico,
                                 cd_avaliacao_pre_med,
                                 cd_unid_int,
                                 cd_setor);
      --
      IF cd_avaliacao_pre_med IS NOT NULL THEN
        --
        Dbamv.Gera_Solicitacao( Null,
                                cd_avaliacao_pre_med,
                                :new.cd_atendimento,
                                cd_unid_int,
                                cd_setor );
        --
      END IF;
      --
    END IF;
    --
  End If;
  --
End;
/
ALTER TRIGGER "DBAMV"."TRG_U_DOC_CLINICO_AVAFAR" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_VALIDA_DATA_ALTA" 

BEFORE INSERT ON dbamv.pw_documento_clinico

FOR EACH ROW



DECLARE



 Cursor cValidaDocPosAlta Is

      SELECT Count(*)

        FROM dbamv.pagu_objeto_parametro,

             dbamv.pw_parametro_pagu_objeto,

             dbamv.pagu_objeto

       WHERE pagu_objeto_parametro.cd_parametro_pagu_objeto = pw_parametro_pagu_objeto.cd_parametro_pagu_objeto

         AND pagu_objeto.cd_tipo_documento = pw_parametro_pagu_objeto.cd_tipo_documento

         AND pagu_objeto.cd_objeto = :new.cd_objeto

         AND pagu_objeto_parametro.cd_objeto   = pagu_objeto.cd_objeto

         AND nm_parametro = 'SN_CRIAR_DOC_POS_ALTA'

         AND vl_parametro = 'N';

--

CURSOR cAlta IS

 SELECT dt_alta

   FROM dbamv.atendime

  WHERE cd_atendimento = :new.cd_atendimento;



vExisteConfig NUMBER;

vAlta cAlta%ROWTYPE;

--

BEGIN

--

  OPEN cAlta;

  FETCH cAlta INTO vAlta;

  CLOSE cAlta;

--

  OPEN cValidaDocPosAlta;

  FETCH cValidaDocPosAlta INTO vExisteConfig;

  CLOSE cValidaDocPosAlta;

--

  IF vAlta.dt_alta IS NOT NULL AND vExisteConfig > 0 THEN

	   raise_application_error (-20230,'Atenção: Documento não pode ser criado pois o paciente está de Alta.');

 END IF;

 --

END;

/
ALTER TRIGGER "DBAMV"."TRG_VALIDA_DATA_ALTA" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_MVPEP_DOC_CONSISTE_FECHADO" 

            AFTER UPDATE

               OF TP_STATUS

               ON DBAMV.PW_DOCUMENTO_CLINICO

         FOR EACH ROW

DECLARE



BEGIN

  --

  --1 Verificando se o status do Documento está sendo FECHADO ou ASSINADO

  IF (:OLD.TP_STATUS = 'ABERTO' AND

      :NEW.TP_STATUS IN ('FECHADO','ASSINADO')) THEN

    --

    --2 Verificando se o Objeto é Documento Eletrônico

    FOR x IN (SELECT 1

                FROM DBAMV.PAGU_OBJETO PO

               WHERE PO.TP_OBJETO IN ('GRUDOC','DOCELE')

                 AND PO.CD_OBJETO = :OLD.CD_OBJETO )

    LOOP

      --

      --3 Obtendo os Documentos do Editor para verificar se o mesmo foi fechado no Editor

      FOR rEditor IN (SELECT PEC.CD_EDITOR_REGISTRO

                        FROM DBAMV.PW_EDITOR_CLINICO PEC

                       WHERE PEC.CD_DOCUMENTO_CLINICO = :OLD.CD_DOCUMENTO_CLINICO)

      LOOP

        --4

        FOR y IN (SELECT COUNT(1) VAL

                      FROM DBAMV.EDITOR_REGISTRO

                     WHERE CD_REGISTRO = rEditor.CD_EDITOR_REGISTRO

                       AND NVL(SN_FECHADO,'N') = 'N')

        LOOP

          --

          IF (y.VAL > 0) THEN

             Raise_Application_Error(-20998,'Ocorreu um erro no Editor.  Alguns registros não foram fechados devidamente!');

          END IF;

          --

        END LOOP;

        --4

      END LOOP;

      --3

    END LOOP;

    --2

  END IF;

  --1

END;


/
ALTER TRIGGER "DBAMV"."TRG_MVPEP_DOC_CONSISTE_FECHADO" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_DOC_CLI_GERA_LOG_CONS_FIM" 

	AFTER INSERT ON dbamv.pw_documento_clinico

	REFERENCING NEW AS NEW OLD AS OLD

	FOR EACH ROW

DECLARE

	AUX_CD_TRIAGEM_ATENDIMENTO DBAMV.TRIAGEM_ATENDIMENTO.CD_TRIAGEM_ATENDIMENTO%TYPE := NULL;

	VINICIO                    DBAMV.SACR_TEMPO_PROCESSO.CD_TIPO_TEMPO_PROCESSO%TYPE := NULL;

    VFINAL                     DBAMV.SACR_TEMPO_PROCESSO.CD_TIPO_TEMPO_PROCESSO%TYPE := NULL;

    -- VERIFICA A EXISTÊNCIA DE REGISTROS REFERENTES AO INÍCIO DE UMA CONSULTA

CURSOR CINICIO IS

    SELECT CD_TIPO_TEMPO_PROCESSO

    FROM DBAMV.SACR_TEMPO_PROCESSO

    WHERE CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO

    AND CD_TIPO_TEMPO_PROCESSO = 31;

-- VERIFICA A EXISTÊNCIA DE REGISTROS REFERENTES AO FIM DE UMA CONSULTA

CURSOR CFINAL IS

    SELECT CD_TIPO_TEMPO_PROCESSO

    FROM DBAMV.SACR_TEMPO_PROCESSO

    WHERE CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO

    AND CD_TIPO_TEMPO_PROCESSO = 32;

-- RETORNA O TIPO DE ATENDIMENTO, O NOME DO USUÁRIO E O CÓDIGO DE MULTI EMPRESA

CURSOR cATENDIME IS

    SELECT TP_ATENDIMENTO, NM_USUARIO, CD_MULTI_EMPRESA, DT_ALTA, DT_ALTA_MEDICA

    FROM DBAMV.ATENDIME

 	WHERE CD_ATENDIMENTO IS NOT NULL

    AND CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO;

-- RETORNA O CÓDIGO DA TRIAGEM REFERENTE AO ATENDIMENTO

CURSOR cCOD_TRIAGEM IS

	SELECT CD_TRIAGEM_ATENDIMENTO

    FROM DBAMV.TRIAGEM_ATENDIMENTO

    WHERE DH_PRE_ATENDIMENTO IN (SELECT MAX(DH_PRE_ATENDIMENTO)

                                 FROM DBAMV.TRIAGEM_ATENDIMENTO

                                 WHERE CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO)

    AND CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO;



CURSOR cTipoDocumento( pCdTipoDocumento Number ) IS

	SELECT DBAMV.PW_TIPO_DOCUMENTO.TP_DOCUMENTO

    FROM DBAMV.PW_TIPO_DOCUMENTO

    WHERE DBAMV.PW_TIPO_DOCUMENTO.CD_TIPO_DOCUMENTO = pCdTipoDocumento;



CURSOR cPrestadorMedico( pCdPrestador Number ) IS

	SELECT DBAMV.PREMED_TIP_PRESTA.TP_FUNCAO

    FROM DBAMV.PRESTADOR

        ,DBAMV.PREMED_TIP_PRESTA

    WHERE DBAMV.PRESTADOR.CD_TIP_PRESTA = DBAMV.PREMED_TIP_PRESTA.CD_TIP_PRESTA

    AND DBAMV.PRESTADOR.CD_PRESTADOR = pCdPrestador;



vATENDIME                   cATENDIME%ROWTYPE;



vcTipoDocumento             cTipoDocumento%RowType;

vcPrestadorMedico           cPrestadorMedico%ROWTYPE;



BEGIN

-- Gravado o processo de finalização do atendimento apenas quando finalizar a prescrição

--

   Open cTipoDocumento(:NEW.cd_tipo_documento);

   Fetch cTipoDocumento Into vcTipoDocumento;

   Close cTipoDocumento;



   IF vcTipoDocumento.tp_documento In ('ARQPDF','DOCELE', 'ALTMED') THEN



      OPEN  cINICIO;

      FETCH cINICIO INTO VINICIO;

      CLOSE cINICIO;



      OPEN  CFINAL;

      FETCH CFINAL INTO VFINAL;

      CLOSE CFINAL;

   -- OS CURSORES DETERMINAM SE EXISTE INÍCIO OU FIM DE UMA CONSULTA.

      OPEN  cATENDIME;

      FETCH cATENDIME INTO vATENDIME;

      CLOSE cATENDIME;



   -- VERIFICA SE O ATENDIMENTO REALIZADO É URGÊNCIA, E NESTE CASO, ALIMENTA A VARIÁVEL QUE INDICA

   -- O CÓDIGO DA TRIAGEM.

   -- Raise_Application_Error(-20001,':old.fl_impresso ' ||:old.fl_impresso || ' :new.fl_impresso ' ||:new.fl_impresso || 'vATENDIME.TP_ATENDIMENTO ' || vATENDIME.TP_ATENDIMENTO);



	  IF(vATENDIME.TP_ATENDIMENTO  IN ('U','A')) THEN



		OPEN  cCOD_TRIAGEM;

		FETCH cCOD_TRIAGEM INTO AUX_CD_TRIAGEM_ATENDIMENTO;

		CLOSE cCOD_TRIAGEM;



		IF(vATENDIME.DT_ALTA_MEDICA IS NOT NULL AND vATENDIME.DT_ALTA IS NULL) THEN

			--Se a data de alta de alta hospitalar estiver null mas a data de alta médica não, então será será incluido o tipo 32 de código tempo

			PRC_SACR_CHAMADA_PAINEL_MV(:NEW.CD_ATENDIMENTO, AUX_CD_TRIAGEM_ATENDIMENTO, vATENDIME.CD_MULTI_EMPRESA, NULL, 32, vATENDIME.NM_USUARIO, sysdate, 'N');

		END IF;



		IF(vATENDIME.DT_ALTA IS NOT NULL) THEN

			--Se a data de alta de alta hospitalar não estiver null então será será incluido o tipo 90 de código tempo

			PRC_SACR_CHAMADA_PAINEL_MV(:NEW.CD_ATENDIMENTO, AUX_CD_TRIAGEM_ATENDIMENTO, vATENDIME.CD_MULTI_EMPRESA, NULL, 90, vATENDIME.NM_USUARIO, sysdate, 'N');

		END IF;



		--VERIFICA SE A CONSULTA JA FOI INICIADA,

		--E NESTE CASO, CHAMA A PROCEDURE QUE IRÁ GRAVAR OS DADOS RELATIVOS AO FIM DA CONSULTA.

		IF (VINICIO IS NOT NULL) THEN

          --Se o atendimento já estiver sido iniciado, será incluido o tipo 32

		  PRC_SACR_CHAMADA_PAINEL_MV(:NEW.CD_ATENDIMENTO, AUX_CD_TRIAGEM_ATENDIMENTO, vATENDIME.CD_MULTI_EMPRESA, NULL, 32, vATENDIME.NM_USUARIO, sysdate, 'N');

		ELSE



          OPEN cPrestadorMedico(:NEW.cd_prestador);

          FETCH cPrestadorMedico INTO vcPrestadorMedico;

          CLOSE cPrestadorMedico;



          IF NVL(vcPrestadorMedico.TP_FUNCAO,'*') = 'M'   THEN

             --Se o atendimento não estiver sido iniciado, esta prescrição iniciará o atendimento

             PRC_SACR_CHAMADA_PAINEL_MV(:NEW.CD_ATENDIMENTO, AUX_CD_TRIAGEM_ATENDIMENTO, vATENDIME.CD_MULTI_EMPRESA, NULL, 31, vATENDIME.NM_USUARIO, sysdate, 'N');

          END IF;

		END IF;

      END IF;

   END IF;



EXCEPTION

   WHEN OTHERS THEN

   	  --MULTI-IDIOMA: Utilização do pkg_rmi_traducao.extrair_msg para mensagens (MSG_1)

   	  RAISE_APPLICATION_ERROR(-20003,pkg_rmi_traducao.extrair_proc_msg('MSG_1', 'TRG_DOC_CLI_GERA_LOG_CONS_FIM', 'ERRO AO EXECUTAR A TRIGGER DBAMV.TRG_PRE_MED_GERA_LOG_CONS_FIM: %s - %s', arg_list(SQLCODE, SQLERRM)));

END;

/
ALTER TRIGGER "DBAMV"."TRG_DOC_CLI_GERA_LOG_CONS_FIM" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_VALIDA_DOCUMENTO_CLINICO" 

BEFORE INSERT ON dbamv.pw_documento_clinico
FOR EACH ROW
DECLARE
 Cursor cPrestadorAtendime Is
   Select u.Cd_Prestador
        , a.Cd_Paciente
     From Dbamv.Atendime a, dbamv.hist_subs_pac h, dbasgu.usuarios u
    Where a.Cd_Atendimento = :New.Cd_Atendimento
    AND h.cd_paciente = a.cd_paciente
    AND h.cd_usuario_criacao = u.cd_usuario
    AND ROWNUM <= 1
    ORDER BY 1 DESC
    ;

 Cursor cPrestadorUsuario Is
   Select u.Cd_Prestador
        , h.Cd_Paciente
    From dbamv.hist_subs_pac h, dbasgu.usuarios u
    Where h.cd_paciente = :new.cd_paciente
    AND h.cd_usuario_criacao = u.cd_usuario
    AND ROWNUM <= 1
    ORDER BY 1 DESC
    ;

 CURSOR cTipoDocumento Is

    select tp_documento
      from dbamv.pw_tipo_documento
     where tp_documento = 'ARQPDF'
       AND cd_tipo_documento = :new.cd_tipo_documento;

 rCdPrestadorAtendime cPrestadorAtendime%RowType;
 rPrestadorUsuario cPrestadorUsuario%RowType;
 vTpTipoDocumento VARCHAR2(15);

BEGIN

  Open cPrestadorAtendime;
     Fetch cPrestadorAtendime INTO rCdPrestadorAtendime;
  Close cPrestadorAtendime;

  Open cPrestadorUsuario;
    Fetch cPrestadorUsuario Into rPrestadorUsuario;
  Close cPrestadorUsuario;

  OPEN cTipoDocumento;
    FETCH cTipoDocumento INTO vTpTipoDocumento;
  CLOSE cTipoDocumento;

  IF :New.Cd_Prestador IS NULL AND vTpTipoDocumento IS NULL THEN
  :New.Cd_Prestador := Nvl(rPrestadorUsuario.Cd_Prestador,rCdPrestadorAtendime.Cd_Prestador);
  END IF;

  If :New.Cd_Paciente Is Null Then
  If rCdPrestadorAtendime.Cd_Paciente Is Not Null Then
     :New.Cd_Paciente := rCdPrestadorAtendime.Cd_Paciente;
  end if;
  End If;

  If :New.Cd_Usuario Is Null Then
     :New.Cd_Usuario := Nvl(Dbamv.Pkg_MV_Variaveis.Fnc_Get_Usuario(),User);
  End If;

  If :New.Dh_Criacao Is Null Then
     :new.Dh_Documento := SYSDATE;
  End If;

  If :New.Dh_Documento Is Null Then
     :New.Dh_Documento := Nvl(:New.Dh_Criacao,Sysdate);
  End If;

  If :New.Dh_Referencia Is Null Then
     :New.Dh_Referencia := Nvl(Trunc(:New.Dh_Criacao),Trunc(Sysdate));
  End If;

  If :New.Tp_Status Is Null Then
     :New.Tp_status := 'ABERTO';
  End If;

  exception when others then
     raise_application_error (-20230,'Problema ao atualizar documento clinico.');

END trg_valida_documento_clinico;
/
ALTER TRIGGER "DBAMV"."TRG_VALIDA_DOCUMENTO_CLINICO" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_SNOMEDCT_PACIENTE" 

BEFORE INSERT OR UPDATE OF tp_status

ON dbamv.pw_documento_clinico

FOR EACH ROW



DECLARE



  C_DIAGNOSTICO_MEDICO     CONSTANT VARCHAR2(200) := 'DIAEST' ;

  C_DIAGOSTICO_ENFERMAGEM  CONSTANT VARCHAR2(200) := 'DIAENF' ;

  C_INTERVENCAO_ENFERMAGEM CONSTANT VARCHAR2(200) := 'PREENF' ;

  C_RESULTADO_ENFERMAGEM   CONSTANT VARCHAR2(200) := 'RESENF' ;

  C_ALERGIA_SUBSTANCIA     CONSTANT VARCHAR2(200) := 'ALERGI';

  C_DOCUMENTO_ELETRONICO   CONSTANT VARCHAR2(200) := 'DOCELE' ;

  vTipoDocumento VARCHAR2(200);





  -- Função para verificar se está habilitado o uso do snomed-ct

  FUNCTION fnc_snomedct_ligado RETURN BOOLEAN IS



  BEGIN



     FOR i IN (SELECT 1 FROM dbamv.config_pagu WHERE sn_utiliza_snomedct ='S') LOOP



         RETURN TRUE;



     END LOOP;



     RETURN FALSE;



  END;



  -- Função para recuperar o tipo de documento que está sedo manipulado

  FUNCTION fnc_tipo_documento (p_cd_tipo_documento NUMBER) RETURN VARCHAR2 IS



  BEGIN



      FOR i IN (SELECT tp_documento

                  FROM dbamv.pw_tipo_documento

                 WHERE cd_tipo_documento = p_cd_tipo_documento

                ) LOOP

          RETURN i.tp_documento;



      END LOOP;



      RETURN NULL;

  END;





  -- Insere na tabela dbamv.snomedct_paciente

  procedure prc_insere_snomedct_paciente( p_cd_snomedct           number

                                         ,p_cd_paciente           number

                                         ,p_cd_documento_clinico  number

                                         ,p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                         ) IS

  BEGIN





     INSERT INTO dbamv.snomedct_paciente (cd_snomedct_paciente

                                         ,cd_snomedct

                                         ,cd_paciente

                                         ,cd_documento_clinico

                                         ,dh_registro

                                        )

                                 VALUES ( dbamv.seq_snomedct_paciente.nextval

                                         ,p_cd_snomedct

                                         ,p_cd_paciente

                                         ,p_cd_documento_clinico

                                         ,p_dh_registro

                                         );



  END;





BEGIN



   -- verifica se a configuração do snomed-ct está habilitada. Se não estiver, já aborta o processamento

   IF NOT fnc_snomedct_ligado THEN

      RETURN;

   END IF;



   -- Aborta caso documento não esteja sendo fechado.

   IF :new.tp_status NOT IN ('FECHADO') THEN

     RETURN;

   END IF;



   -- Recupera o tipo documento que está sendo manipulado

   vTipoDocumento := fnc_tipo_documento (:new.cd_tipo_documento);





   -- Verifica e o tipo de documento está na lista dos documentos que possuem mapeamento.

   -- Se não estiver, aborta o processamento.

   IF vTipoDocumento NOT IN (C_DIAGNOSTICO_MEDICO, C_DIAGOSTICO_ENFERMAGEM ,C_INTERVENCAO_ENFERMAGEM

                            ,C_RESULTADO_ENFERMAGEM,C_ALERGIA_SUBSTANCIA,C_DOCUMENTO_ELETRONICO

                            ) THEN

      RETURN;

   END IF;





   -- insere na tabela dbamv.snomedct_paciente



   -- Insere diagnósticos

   IF vTipoDocumento = C_DIAGNOSTICO_MEDICO THEN



      -- Insere o cid principal

      FOR i IN (SELECT cd_snomedct

                  FROM dbamv.snomedct_cid

                 WHERE cd_cid in (SELECT cd_cid

                                   FROM dbamv.diagnostico_atendime

                                 WHERE cd_documento_clinico = :NEW.cd_documento_clinico



                                 )

                  AND sn_principal = 'S'

                  AND sn_ativo = 'S'

                ) LOOP



          prc_insere_snomedct_paciente( i.cd_snomedct              --p_cd_snomedct           number

                                       ,:NEW.cd_paciente           --p_cd_paciente           number

                                       ,:NEW.cd_documento_clinico  --p_cd_documento_clinico  number

                                       ,systimestamp               --p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                       );



      END LOOP;

      -- Insere os cids secundários

      FOR i IN (SELECT cd_snomedct

            FROM dbamv.snomedct_cid

            WHERE cd_cid in (SELECT cd_cid

                              FROM dbamv.pw_diagnostico_atendime_cid

                            WHERE cd_diagnostico_atendime in (SELECT cd_diagnostico_atendime

                                                                FROM dbamv.diagnostico_atendime

                                                              WHERE cd_documento_clinico = :NEW.cd_documento_clinico

                                                            )

                              AND cd_cid IS NOT null

                            )

            AND sn_principal = 'S'

            AND sn_ativo = 'S'

          ) LOOP



            prc_insere_snomedct_paciente( i.cd_snomedct              --p_cd_snomedct           number

                                        ,:NEW.cd_paciente           --p_cd_paciente           number

                                        ,:NEW.cd_documento_clinico  --p_cd_documento_clinico  number

                                        ,systimestamp               --p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                        );

      END LOOP;



      -- Insere snomedct primario

      FOR i IN (SELECT cd_snomedct

                 FROM dbamv.diagnostico_atendime

                 WHERE cd_documento_clinico = :NEW.cd_documento_clinico

                AND cd_snomedct IS NOT null

               ) LOOP



            prc_insere_snomedct_paciente( i.cd_snomedct              --p_cd_snomedct           number

                                        ,:NEW.cd_paciente           --p_cd_paciente           number

                                        ,:NEW.cd_documento_clinico  --p_cd_documento_clinico  number

                                        ,systimestamp               --p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                        );

      END LOOP;



      -- Insere snomedct secundário

      FOR i IN (SELECT cd_snomedct

                FROM dbamv.pw_diagnostico_atendime_snomed

               WHERE cd_diagnostico_atendime in (SELECT cd_diagnostico_atendime

                                                  FROM dbamv.diagnostico_atendime

                                                WHERE cd_documento_clinico = :NEW.cd_documento_clinico

                                              )

                AND cd_snomedct IS NOT null

              ) LOOP



            prc_insere_snomedct_paciente( i.cd_snomedct              --p_cd_snomedct           number

                                        ,:NEW.cd_paciente           --p_cd_paciente           number

                                        ,:NEW.cd_documento_clinico  --p_cd_documento_clinico  number

                                        ,systimestamp               --p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                        );

      END LOOP;





   END IF;

   -- Fim Insere diagnósticos



   -- Insere diagnósticos de enfermagem

   IF vTipoDocumento = C_DIAGOSTICO_ENFERMAGEM THEN



      -- Insere o cid principal

      FOR i IN (SELECT cd_snomedct

                  FROM dbamv.snomedct_diagnostico

                 WHERE cd_diagnostico in (SELECT dp.cd_diagnostico

                                          FROM dbamv.SAE_DIAGNOSTICO_REALIZADO dr

                                              ,dbamv.sae_diagnostico_paciente dp

                                        WHERE dr.cd_diagnostico_realizado = dp.cd_diagnostico_realizado

                                          AND cd_documento_clinico = :NEW.cd_documento_clinico

                                        )

                  AND sn_principal = 'S'

                  AND sn_ativo = 'S'

                ) LOOP



          prc_insere_snomedct_paciente( i.cd_snomedct              --p_cd_snomedct           number

                                       ,:NEW.cd_paciente           --p_cd_paciente           number

                                       ,:NEW.cd_documento_clinico  --p_cd_documento_clinico  number

                                       ,systimestamp               --p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                       );



      END LOOP;



   END IF;



   -- Fim Insere diagnósticos  de enfermagem



   -- Inicio insere alergias  DBAMV.SNOMEDCT_SUBSTANCIA ,  C_ALERGIA_SUBSTANCIA

   IF vTipoDocumento = C_ALERGIA_SUBSTANCIA THEN



      FOR i IN (SELECT cd_snomedct

                  FROM dbamv.snomedct_substancia

                 WHERE cd_substancia in (SELECT cd_substancia

                                          FROM DBAMV.pw_alergia_paciente a

                                              ,dbamv.hist_subs_pac h

                                        WHERE a.cd_hist_subs_pac = h.cd_hist_subs_pac

                                          AND cd_documento_clinico = :NEW.cd_documento_clinico

                                          AND h.sn_ativo = 'S'

                                        )

                  AND sn_principal = 'S'

                  AND sn_ativo = 'S'

                ) LOOP



          prc_insere_snomedct_paciente( i.cd_snomedct              --p_cd_snomedct           number

                                       ,:NEW.cd_paciente           --p_cd_paciente           number

                                       ,:NEW.cd_documento_clinico  --p_cd_documento_clinico  number

                                       ,systimestamp               --p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                       );



      END LOOP;



   END IF;



   -- Fim insere alergias





   -- Inicio insere metadados DBAMV.SNOMEDCT_EDITOR_CAMPO , C_DOCUMENTO_ELETRONICO



   IF vTipoDocumento = C_DOCUMENTO_ELETRONICO THEN



      FOR i IN (SELECT cd_snomedct

                  FROM dbamv.snomedct_editor_campo

                 WHERE cd_campo in (SELECT cd_campo

                                    FROM dbamv.editor_registro_campo erc

                                        ,dbamv.pw_editor_clinico ec

                                    WHERE erc.cd_registro = ec.cd_editor_registro

                                      AND cd_documento_clinico = :NEW.cd_documento_clinico

                                        )

                  AND sn_principal = 'S'

                  AND sn_ativo = 'S'

                ) LOOP



          prc_insere_snomedct_paciente( i.cd_snomedct              --p_cd_snomedct           number

                                       ,:NEW.cd_paciente           --p_cd_paciente           number

                                       ,:NEW.cd_documento_clinico  --p_cd_documento_clinico  number

                                       ,systimestamp               --p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                       );



      END LOOP;



   END IF;





   -- Fim insere metadados





   -- Inicio insere intevenções de enfermagem     DBAMV.SNOMEDCT_CONFIG_SAE_INTERV_ENF  , C_INTERVENCAO_ENFERMAGEM

   IF vTipoDocumento = C_INTERVENCAO_ENFERMAGEM THEN



      FOR i IN (SELECT cd_snomedct

                  FROM dbamv.snomedct_config_sae_interv_enf

                 WHERE cd_config_sae_intervencao_enf in (SELECT csie.cd_config_sae_intervencao_enf

                                                          FROM dbamv.pw_config_sae_intervencao_enf csie

                                                              ,dbamv.itpre_med ip

                                                              ,dbamv.pre_med pm

                                                         WHERE  pm.cd_pre_med = ip.cd_pre_med

                                                           AND csie.cd_tip_presc = ip.cd_tip_presc

                                                           AND pm.cd_documento_clinico = :new.cd_documento_clinico

                                                        )

                  AND sn_principal = 'S'

                  AND sn_ativo = 'S'

                ) LOOP



          prc_insere_snomedct_paciente( i.cd_snomedct              --p_cd_snomedct           number

                                       ,:NEW.cd_paciente           --p_cd_paciente           number

                                       ,:NEW.cd_documento_clinico  --p_cd_documento_clinico  number

                                       ,systimestamp               --p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                       );



      END LOOP;



   END IF;



   -- Fim insere intevenções de enfermagem







   -- Inicio insere resultados de enfermagem          DBAMV.SNOMEDCT_CONFIG_SAE_RESULT_ENF , C_RESULTADO_ENFERMAGEM

   IF vTipoDocumento = C_RESULTADO_ENFERMAGEM THEN



      -- Insere o resultado

      FOR i IN (SELECT cd_snomedct

                  FROM dbamv.snomedct_config_sae_result_enf

                 WHERE cd_config_sae_resultado_enfer in (SELECT DISTINCT csdr.cd_config_sae_resultado_enfer

                                                          FROM dbamv.sae_diagnostico_realizado dr

                                                              ,dbamv.sae_diagnostico_paciente dp

                                                              ,dbamv.pw_config_sae_diagnostico_res  csdr

                                                              ,dbamv.pw_config_sae_resultado_enfer csre

                                                        WHERE dr.cd_diagnostico_realizado = dp.cd_diagnostico_realizado

                                                          AND csdr.cd_diagnostico = dp.cd_diagnostico

                                                          AND csdr.cd_config_sae_resultado_enfer = csre.cd_config_sae_resultado_enfer

                                                          AND dr.cd_documento_clinico = :new.cd_documento_clinico



                                        )

                  AND sn_principal = 'S'

                  AND sn_ativo = 'S'

                ) LOOP



          prc_insere_snomedct_paciente( i.cd_snomedct              --p_cd_snomedct           number

                                       ,:NEW.cd_paciente           --p_cd_paciente           number

                                       ,:NEW.cd_documento_clinico  --p_cd_documento_clinico  number

                                       ,systimestamp               --p_dh_registro           TIMESTAMP WITH LOCAL TIME ZONE

                                       );



      END LOOP;



   END IF;



   -- Fim   fim insere resultados de enfermagem



END;

/
ALTER TRIGGER "DBAMV"."TRG_SNOMEDCT_PACIENTE" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBAMV"."TRG_ATUALIZA_PREST_ATENDIME" 



   



    BEFORE INSERT OR UPDATE ON dbamv.pw_documento_clinico



   



   REFERENCING NEW AS NEW OLD AS OLD



   



    FOR EACH ROW



   



   DECLARE



   



   



   



      Cursor cAtendimento( pCdAtendimento Number ) Is



   



         Select atendime.cd_atendimento



   



              , atendime.tp_atendimento



   



              , atendime.cd_prestador



   



              , atendime.cd_especialid



   



              , atendime.cd_servico



   



              , atendime.cd_ser_dis



   



              , atendime.cd_convenio



   



              , atendime.cd_ori_ate



   



              , atendime.cd_multi_empresa



   



              , atendime.dt_atendimento



   



              , atendime.cd_procedimento



   



              , convenio.tp_convenio



   



           From dbamv.atendime



   



              , dbamv.convenio



   



          Where atendime.cd_convenio = convenio.cd_convenio(+)



   



            AND atendime.cd_atendimento = pCdAtendimento;



   



   



   



      Cursor cConfigPrestadorPlantao( pCdMultiEmpresa Number ) Is



   



         Select config_paeu.cd_prestador_geral



   



           From dbamv.config_paeu



   



          Where config_paeu.cd_multi_empresa = pCdMultiEmpresa;



   



   



   



      Cursor cPrestador( pCdPrestador Number ) Is



   



         Select premed_tip_presta.tp_funcao



   



           From dbamv.prestador



   



              , dbamv.premed_tip_presta



   



          Where prestador.cd_tip_presta = premed_tip_presta.cd_tip_presta



   



            And prestador.cd_prestador  = pCdPrestador;



   



   



   



      Cursor cItemRegAmbulatorio( pCdAtendimento Number, pCdPrestador Number) Is



   



         Select itreg_amb.*



   



           From dbamv.itreg_amb



   



          Where itreg_amb.cd_atendimento = pCdAtendimento



   



            And itreg_amb.cd_prestador   = pCdPrestador



   



            And itreg_amb.tp_mvto        = 'Atendimento'



   



            And sn_fechada               = 'N';



   



   



   



      Cursor cDataLancamentoRegAmb( pCdRegAmb Number) Is



   



         Select reg_amb.dt_lancamento



   



           From dbamv.reg_amb



   



          Where reg_amb.cd_reg_amb = pCdRegAmb;



   



      



   



      Cursor cUsuario( pCdUsuario Varchar2) Is



   



         Select usuarios.nm_usuario



   



           From dbasgu.usuarios



   



          Where usuarios.cd_usuario = pCdUsuario;



   



          



   



      Cursor cTipoDocumento( pCdTipoDocumento Varchar2) Is



   



         Select pw_tipo_documento.tp_documento



   



           From dbamv.pw_tipo_documento



   



          Where pw_tipo_documento.cd_tipo_documento = pCdTipoDocumento;



   



   



   



   	CURSOR cVerificaCBOPrestador( pCdPrestador    IN NUMBER



   



                                , pCdProcedimento IN VARCHAR2



   



                                , P_COMPETENCIA   IN DATE )IS



   



       SELECT pc.cd_cbo



   



         FROM dbamv.prestador_cbo pc



   



            , dbamv.procedimento_cbo_vigencia pv



   



        WHERE pc.cd_prestador             = pCdPrestador



   



          AND pv.cd_procedimento          = pCdProcedimento



   



          AND pv.cd_cbo                   = pc.cd_cbo



   



          AND pc.tp_cbo_padrao_importacao = 'P'



   



          and pc.sn_regra_vinculo         = 'N'



   



          AND P_COMPETENCIA BETWEEN pv.DT_VALIDADE_INICIAL AND nvl(pv.DT_VALIDADE_FINAL, P_COMPETENCIA)



   



          AND pc.cd_multi_empresa              = dbamv.pkg_mv2000.le_empresa



   



          AND rownum=1;



   



   



   



      CURSOR cCboProc(pCdProcedimento Varchar2, P_COMPETENCIA DATE ) IS



   



       SELECT procedimento_cbo_vigencia.cd_cbo



   



         FROM dbamv.multi_empresas_cbo



   



            , dbamv.procedimento_cbo_vigencia



   



        WHERE multi_empresas_cbo.cd_multi_empresa  = dbamv.pkg_mv2000.le_empresa



   



          AND multi_empresas_cbo.cd_cbo            = procedimento_cbo_vigencia.cd_cbo



   



          AND procedimento_cbo_vigencia.cd_procedimento = pCdProcedimento



   



          AND P_COMPETENCIA BETWEEN procedimento_cbo_vigencia.DT_VALIDADE_INICIAL AND nvl(procedimento_cbo_vigencia.DT_VALIDADE_FINAL, P_COMPETENCIA)



   



          AND multi_empresas_cbo.sn_ativo          = 'S'



   



          AND rownum=1;



   



   



   



       CURSOR cValidaRegraPrestador IS



   



       SELECT sn_valida_cbo_pagu



   



         FROM dbamv.config_ffas



   



        WHERE cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;



   



   	 



   



      vcAtendimento            cAtendimento%RowType;



   



      vcConfigPrestadorPlantao cConfigPrestadorPlantao%RowType;



   



      vcPrestadorNovo          cPrestador%RowType;



   



      vMovPrest                dbamv.mov_prestador%RowType;



   



      vcTipoDocumento          cTipoDocumento%RowType;



   



      vCdPrestadorAnterior     Number;



   



      vDtLancamentoRegAmb      Date;



   



      vcUsuario                cUsuario%RowType;



   



      vSnValidaCBOPrestador   Varchar2(1);



   



      vCdCBOProc              dbamv.prestador_cbo.cd_cbo%Type;



   



      bEXISTE                 BOOLEAN;



   



      vRetorno1               VARCHAR2(2000);



   



      



   



   BEGIN



   



   



   



      IF (:New.cd_tipo_documento <> :old.cd_tipo_documento)THEN



   



          RETURN;



   



      END IF;



   



   



   



      If Inserting THEN



   



   



   



         Open cTipoDocumento(:New.cd_tipo_documento);



   



         Fetch cTipoDocumento Into vcTipoDocumento;



   



         Close cTipoDocumento;



   



         



   



         If vcTipoDocumento.tp_documento Not In ('ENCAMI') Then



   



            Return;



   



         End If;



   



         



   



      End If;



   



   



   



      Open cAtendimento(:New.cd_atendimento);



   



      Fetch cAtendimento Into vcAtendimento;



   



   



   



    /* Caso alguma tela tente inserir o documento j? como assinado, eu n?o executo a trigger */



   



      If cAtendimento%Found



   



         And vcAtendimento.tp_atendimento = 'U'



   



         And :New.tp_status In ('FECHADO', 'ASSINADO') Then



   



         vCdPrestadorAnterior := vcAtendimento.cd_prestador;



   



   



   



         Open cPrestador(:New.cd_prestador);



   



         Fetch cPrestador Into vcPrestadorNovo;



   



         Close cPrestador;



   



   



   



         Open cConfigPrestadorPlantao(vcAtendimento.cd_multi_empresa);



   



         Fetch cConfigPrestadorPlantao Into vcConfigPrestadorPlantao;



   



   



   



         If cConfigPrestadorPlantao%Found



   



            And vcAtendimento.cd_prestador = vcConfigPrestadorPlantao.cd_prestador_geral -->Se o prestador do atendimento for igual ao prestador configurado como geral



   



            And vcPrestadorNovo.tp_funcao = 'M' Then  -->Se o prestador do documento clinico for do tipo M - Medico



   



   



   



            If vcConfigPrestadorPlantao.cd_prestador_geral <> :New.cd_prestador Then



   



   



   



               IF (vcAtendimento.tp_convenio = 'A') then



   



   



   



                 OPEN cValidaRegraPrestador;



   



                 FETCH cValidaRegraPrestador INTO vSnValidaCBOPrestador;



   



                 CLOSE cValidaRegraPrestador;



   



   



   



                 IF vSnValidaCBOPrestador = 'S' THEN



   



   



   



                     Open  cVerificaCBOPrestador( :New.cd_prestador, vcAtendimento.Cd_Procedimento, trunc(vcAtendimento.dt_atendimento) );



   



                     Fetch cVerificaCBOPrestador Into vCdCBOProc;



   



   		                bEXISTE:= cVerificaCBOPrestador%FOUND;



   



                     Close cVerificaCBOPrestador;



   



   



   



                     IF NOT bEXISTE THEN



   



                       vRetorno1:= 'Atenção: Procedimento '||vcAtendimento.Cd_Procedimento||' sem nenhum CBO cadastrado para o prestdor '||:New.cd_prestador||','||chr(10)||



   



                                   ' verificar em Faturamento > Faturamento Ambulatorial SUS (BPA e APAC) > Tabelas > Geral > Prestador SUS';



   



                       Raise_Application_Error(-20999,vRetorno1);



   



                     END IF;



   



   



   



                 ELSE



   



   



   



                     Open cCboProc(vcAtendimento.Cd_Procedimento, trunc(vcAtendimento.dt_atendimento));



   



                     Fetch cCboProc Into vCdCBOProc;



   



   		                bEXISTE:= cCboProc%FOUND;



   



                     Close cCboProc;



   



   



   



                     IF NOT bEXISTE THEN



   



                         vRetorno1:= 'Atenção: Procedimento '||vcAtendimento.Cd_Procedimento||' sem nenhum CBO ativo cadastrado para a empresa,'||chr(10)||



   



                                     ' verificar em Faturamento > Faturamento de Internação SUS (AIH) > Tabelas > Empresa';



   



                       Raise_Application_Error(-20999,vRetorno1);



   



                     END IF;



   



   



   



                 END IF;



   



   



   



               END IF;



   



   



   



               Update dbamv.atendime



   



                  Set atendime.cd_prestador     = :New.cd_prestador,



   



                      atendime.cd_cbo_prestador = vCdCBOProc



   



               Where atendime.cd_atendimento = vcAtendimento.cd_atendimento;



   



   



   



   			 



   



               Open cUsuario(:New.cd_usuario);



   



               Fetch cUsuario Into vcUsuario;



   



               Close cUsuario;



   



   



   



               vMovPrest.cd_atendimento := :New.cd_atendimento;



   



               vMovPrest.dt_ini_transf  := Sysdate;



   



               vMovPrest.dt_fim_transf  := Sysdate;



   



               vMovPrest.cd_prestador   := :New.cd_prestador;



   



               vMovPrest.ds_motivo      := '';



   



               vMovPrest.nm_usuario     := vcUsuario.nm_usuario;



   



               vMovPrest.cd_servico     := vcAtendimento.cd_servico;



   



               vMovPrest.cd_especialid  := vcAtendimento.cd_especialid;



   



   



   



               If vcAtendimento.tp_atendimento = 'U' Then



   



   



   



                  vMovPrest.cd_servico := vcAtendimento.cd_servico;



   



   



   



               ElsIf vcAtendimento.tp_atendimento = 'A' Then



   



   



   



                  vMovPrest.cd_ser_dis := vcAtendimento.cd_ser_dis;



   



   



   



               End If;



   



                --> Colocando o log de transferencia de prestador



   



               Insert Into dbamv.mov_prestador( cd_atendimento



   



                                              , dt_ini_transf



   



                                              , dt_fim_transf



   



                                              , cd_prestador



   



                                              , ds_motivo



   



                                              , nm_usuario



   



                                              , cd_servico



   



                                              , cd_especialid



   



                                              , cd_ser_dis)



   



                                        Values( vMovPrest.cd_atendimento



   



                                              , vMovPrest.dt_ini_transf



   



                                              , vMovPrest.dt_fim_transf



   



                                              , vMovPrest.cd_prestador



   



                                              , vMovPrest.ds_motivo



   



                                              , vMovPrest.nm_usuario



   



                                              , vMovPrest.cd_servico



   



                                              , vMovPrest.cd_especialid



   



                                              , vMovPrest.cd_ser_dis );



   



   



   



               /* Atualizando a ITREG_AMB */



   



               For vcItemRegAmbulatorio In cItemRegAmbulatorio( :New.cd_Atendimento, vCdPrestadorAnterior ) Loop



   



   



   



                  Open cDataLancamentoRegAmb(vcItemRegAmbulatorio.cd_reg_amb);



   



                  Fetch cDataLancamentoRegAmb Into vDtLancamentoRegAmb;



   



                  Close cDataLancamentoRegAmb;



   



   



   



                  vcItemRegAmbulatorio.tp_pagamento := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento( :New.cd_prestador



   



                                                                                                       , vcAtendimento.cd_convenio



   



                                                                                                       , vcAtendimento.tp_atendimento



   



                                                                                                       , vcItemRegAmbulatorio.cd_pro_fat



   



                                                                                                       , vcAtendimento.cd_ori_ate



   



                                                                                                       , vDtLancamentoRegAmb



   



                                                                                                       , vcItemRegAmbulatorio.hr_lancamento);



   



   



   



                  vcItemRegAmbulatorio.cd_prestador := :New.cd_prestador;



   



   



   



                  Update dbamv.itreg_amb



   



                     Set itreg_amb.tp_pagamento = vcItemRegAmbulatorio.tp_pagamento



   



                       , itreg_amb.cd_prestador = vcItemRegAmbulatorio.cd_prestador



   



                   Where itreg_amb.cd_reg_amb   = vcItemRegAmbulatorio.cd_reg_amb



   



                     And itreg_amb.cd_lancamento = vcItemRegAmbulatorio.cd_lancamento;



   



   



   



               End LOOP;



   



   



   



            End If;



   



   



   



         End If;



   



   



   



         Close cConfigPrestadorPlantao;



   



   



   



      End If;



   



   



   



      Close cAtendimento;



   



   



   



   END;

/
ALTER TRIGGER "DBAMV"."TRG_ATUALIZA_PREST_ATENDIME" ENABLE;

CREATE INDEX "DBAMV"."IND_PW_DOC_PER_IX" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_TIPO_DOCUMENTO", "CD_DOCUMENTO_CLINICO", "CD_MULTI_EMPRESA", "CD_ATENDIMENTO", "CD_PRESTADOR", "CD_USUARIO_AUTORIZADOR", "TP_STATUS", "CD_OBJETO", "CD_DOCUMENTO_DIGITAL", "DH_CRIACAO", "CD_PACIENTE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."WDS_IDX_TRUNC_PW_DOC_CLI_DH_CR" ON "DBAMV"."PW_DOCUMENTO_CLINICO" (TRUNC("DH_CRIACAO")) 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUMENTO_CLINC_SET_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_SETOR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUMENTO_CLINICO_2_IX" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_PRESTADOR", "TP_STATUS", "CD_DOCUMENTO_DIGITAL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUMENTO_CLINC_USU_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_USUARIO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINIC_LIST_13" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_PACIENTE", "CD_OBJETO", "CD_TIPO_DOCUMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINC_ATENDIME_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_ATENDIMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLI_PAGU_OBJ_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_OBJETO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINIC_LIST_3" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_ATENDIMENTO", "CD_TIPO_DOCUMENTO", "CD_PRESTADOR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUMENTO_CLINC_PRES_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_PRESTADOR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUMENTO_CLINC_3_IX" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("DH_REFERENCIA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUMENTO_CLINC_4_IX" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOC_CLINICO_REFERENCIA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINIC_LIST_2" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_ATENDIMENTO", "TP_STATUS", "DH_REFERENCIA", "CD_PRESTADOR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINIC_LIST_10" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("TP_STATUS", "DH_FECHAMENTO", "CD_ATENDIMENTO", "CD_DOCUMENTO_CLINICO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINIC_LIST_1" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_ATENDIMENTO", "TP_STATUS", "DH_REFERENCIA", "CD_PRESTADOR", "CD_TIPO_DOCUMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINIC_LIST_4" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_ATENDIMENTO", "CD_TIPO_DOCUMENTO", "TP_STATUS") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_DOC_CLI_ANTERIOR_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOCUMENTO_CLINICO_ANTERIOR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLIN_CANCEL_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOCUMENTO_CANCELADO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLI_PW_DOC_CLI_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOCUMENTO_CLINICO_NOVO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_DOCUMENTO_CLIN_US_AUTZD_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_USUARIO_AUTORIZADOR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUMENTO_CLINC_1_IX" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("DH_CRIACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLIN_PW_TP_DOC_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_TIPO_DOCUMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOC_CLIN_TP_STS_1_IX" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_DOCUMENTO_CLINICO", "TP_STATUS") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINIC_LIST_5" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("TP_STATUS", "CD_PACIENTE", "CD_ATENDIMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."IND_PW_DOCUM_CLINC_PACIEN_FK" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_PACIENTE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBAMV"."CNT_PW_DOCUM_CLINI_MUL_EMP_IX" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("CD_MULTI_EMPRESA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_I" ;

CREATE INDEX "DBATUALIZA"."IND_PW_DOCUM_CLIN_CONFI" ON "DBAMV"."PW_DOCUMENTO_CLINICO" ("SN_CONFIDENCIAL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MV2000_D" ;

GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "CARTORIO";
  GRANT UPDATE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MEDWISE" WITH GRANT OPTION;
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MEDWISE" WITH GRANT OPTION;
  GRANT INSERT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MEDWISE" WITH GRANT OPTION;
  GRANT DELETE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MEDWISE" WITH GRANT OPTION;
  GRANT UPDATE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVAPI";
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVAPI";
  GRANT INSERT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVAPI";
  GRANT DELETE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVAPI";
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "IDCE" WITH GRANT OPTION;
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBACP" WITH GRANT OPTION;
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBAPORTAL" WITH GRANT OPTION;
  GRANT UPDATE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVBIKE" WITH GRANT OPTION;
  GRANT INSERT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVBIKE" WITH GRANT OPTION;
  GRANT DELETE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVBIKE" WITH GRANT OPTION;
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVBIKE" WITH GRANT OPTION;
  GRANT REFERENCES ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVINTEGRA";
  GRANT UPDATE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVINTEGRA";
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVINTEGRA" WITH GRANT OPTION;
  GRANT INSERT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVINTEGRA";
  GRANT DELETE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MVINTEGRA";
  GRANT REFERENCES ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBAPS";
  GRANT UPDATE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBAPS";
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBAPS";
  GRANT INSERT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBAPS";
  GRANT DELETE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBAPS";
  GRANT REFERENCES ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBASGU";
  GRANT UPDATE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBASGU";
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBASGU";
  GRANT INSERT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBASGU";
  GRANT DELETE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "DBASGU";
  GRANT UPDATE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MV2000";
  GRANT SELECT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MV2000";
  GRANT INSERT ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MV2000";
  GRANT DELETE ON "DBAMV"."PW_DOCUMENTO_CLINICO" TO "MV2000";

COMMENT ON TABLE DBAMV.PW_DOCUMENTO_CLINICO IS 'Armazena dados bÃ¡sicos sobre todos os documentos gerados atravÃ©s do MVPEP ou de sistemas que geram os mesmos documentos do MVPEP, esta tabela Ã© populada e atualizada atravÃ©s de triggers nas tabelas que representam os documentos clÃ­nicos, ex.: PRE_MED, RECEITA, AFERICAO, etc.';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_DOCUMENTO_CLINICO IS 'O cÃ³digo do documento clÃ­nico (pk)';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_TIPO_DOCUMENTO IS 'O cÃ³digo do tipo de documento (fk)';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_DOCUMENTO_DIGITAL IS 'O cÃ³digo do documento assinado, caso o documento jÃ¡ tenha sido assinado digitalmente, nulo indica que o documento ainda nÃ£o foi assinado digitalmente (fk)';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_PACIENTE IS 'O cÃ³digo do paciente ao qual o documento se refere (fk)';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_ATENDIMENTO IS 'O cÃ³digo do atendimento ao qual o documento se refere (fk)';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_USUARIO IS 'O cÃ³digo do usuÃ¡rio, serÃ¡ sempre o mesmo que estÃ¡ na tabela original do documento (PRE_MED, PW_RECEITA, etc) (fk)';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_PRESTADOR IS 'O cÃ³digo do prestador, serÃ¡ sempre o mesmo que estÃ¡ na tabela original do documento (PRE_MED, PW_RECEITA, etc) (fk)';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.TP_STATUS IS 'O status do documento (ABERTO, FECHADO, ASSINADO=Assinado Digitalmente ou CANCELADO). Se for ASSINADO, deve haver cï¿½digo de documento assinado (CD_DOCUMENTO_DIGITAL)';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.DH_REFERENCIA IS 'A data de referÃªncia do documento, nem todos os documentos utilizam';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.DH_CRIACAO IS 'A data de criaÃ§Ã£o do documento';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.DH_FECHAMENTO IS 'A data de fechamento do documento';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.DH_IMPRESSO IS 'A data em que o documento foi impresso';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.TP_EXTENSAO IS 'Indica a extensão do documento clínico';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_SETOR IS 'Indica SETOR QUE o documento clinico foi criado.';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_OBJETO IS 'Código do tipo de pagu objeto';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_DOCUMENTO_CANCELADO IS 'O código do documento clínico cancelado. Quando o documento clínico é cancelado obrigatoriamente um novo é criado, e neste novo o código do cancelado é setado (nesta coluna). Poderãoocorrer vários cancelamentos, gerando uma lista encadeada.';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.NM_DOCUMENTO IS 'Versão do documento no momento que ele foi criado.';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.DH_DOCUMENTO IS 'A data do documento.';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_DOC_CLINICO_REFERENCIA IS 'Coluna que guarda o código do documento clínico a que o documento faz referência';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_USUARIO_AUTORIZADOR IS 'CÓDIGO DO USUÁRIO QUE AUTORIZOU O DOCUMENTO CLÍNICO.';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.SN_INTEGRA_GREEN IS 'Verifica se green ja importou o documento';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.SN_CONFIDENCIAL IS 'Indicará se o documento foi gravado como confidencial (OP42330).';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.QT_VIAS_IMPRESSAS IS 'Quantidade de vias impressas do documento';
COMMENT ON COLUMN DBAMV.PW_DOCUMENTO_CLINICO.CD_ESPECIALIDADE_PRESTADOR IS 'Código da especialidade do prestador no fechamento';