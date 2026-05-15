CREATE OR REPLACE PACKAGE BODY DBAMV.PKG_FFCV_M_LAN_HOS AS

-- Struct definitions for passing state from appliction level to the code units
-- defined in this package

	-- Record to be used as parameter of procedures and functions that access application block FRANQUIA_REG_FAT's items
	TYPE FRANQUIA_REG_FATRec IS RECORD (
		CD_REG_FAT	VARCHAR2(2000),
		VL_DESCONTO_CONTA	NUMBER,
		CD_CONVENIO_ACP	NUMBER,
		DSP_CONVENIO_ACP	VARCHAR2(2000),
		CD_PLANO_ACP	NUMBER,
		DSP_PLANO_ACP	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block AUDITORIA_CONTA's items
	TYPE AUDITORIA_CONTARec IS RECORD (
		CD_MOTIVO_AUDITORIA	NUMBER,
		DSP_DS_MOTIVO_AUDITORIA	VARCHAR2(2000),
		DSP_TP_MOTIVO_AUDITORIA	VARCHAR2(2000),
		CD_AUDITORIA_CONTA	NUMBER,
		DT_AUDITORIA	Date,
		CD_MVTO	NUMBER,
		CD_USUARIO_SOL	VARCHAR2(2000),
		CD_USUARIO_REL	VARCHAR2(2000),
		CD_USUARIO_AUD	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block DESC_GERAL's items
	TYPE DESC_GERALRec IS RECORD (
		CD_REG_FAT	VARCHAR2(2000),
		DSP_EMPRESA	VARCHAR2(2000),
		VL_DESCONTO_CONTA	NUMBER,
		DS_OBSERVACAO_FRANQUIA	VARCHAR2(2000),
		CD_MULTI_EMPRESA	NUMBER
	);

	-- Record to be used as parameter of procedures and functions that access application block LOG_FALHA_IMPORTACAO's items
	TYPE LOG_FALHA_IMPORTACAORec IS RECORD (
		CD_PRO_FAT	VARCHAR2(2000),
		TP_ERRO	VARCHAR2(2000),
		DSP_DS_PRO_FAT	VARCHAR2(2000),
		DSP_SN_OK	VARCHAR2(2000),
		NM_USUARIO_BAIXOU	VARCHAR2(2000),
		NM_USUARIO_EXCLUIU	VARCHAR2(2000),
		TP_IMPORTACAO	VARCHAR2(2000),
		CD_MVTO_FALHA	NUMBER,
		CD_ITEM_FALHA	NUMBER,
		CD_PRODUTO	NUMBER,
		DSP_DS_ITEM_FALHA	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block ITREG_FAT_REL's items
	TYPE ITREG_FAT_RELRec IS RECORD (
		CD_LANCAMENTO	NUMBER,
		CD_GRU_FAT	NUMBER,
		DSP_DS_GRU_FAT	VARCHAR2(2000),
		DSP_TP_GRU_FAT	VARCHAR2(2000),
		CD_PRO_FAT	VARCHAR2(2000),
		DSP_DS_UNIDADE	VARCHAR2(2000),
		DSP_DS_PRO_FAT	VARCHAR2(2000),
		DSP_TP_SEXO	VARCHAR2(2000),
		DSP_CD_GRU_PRO	NUMBER,
		DSP_NR_AUXILIAR	NUMBER,
		DSP_CD_POR_ANE	NUMBER,
		DSP_TP_GRU_PRO	VARCHAR2(2000),
		DSP_SN_CADASTRA_QTD	VARCHAR2(2000),
		DSP_SN_CADASTRA_DATA	VARCHAR2(2000),
		DSP_SN_CADASTRA_CRM	VARCHAR2(2000),
		DSP_SN_CADASTRA_VALOR	VARCHAR2(2000),
		DSP_SN_CADASTRA_PERC_PACIENTE	VARCHAR2(2000),
		DSP_TP_DT_REFERENCIA_LANCAMENT	VARCHAR2(2000),
		DSP_QTD_MAXIMA	NUMBER,
		DT_LANCAMENTO	DATE,
		HR_LANCAMENTO	Date,
		SN_HORARIO_ESPECIAL	VARCHAR2(2000),
		QT_LANCAMENTO	NUMBER,
		VL_PERCENTUAL_MULTIPLA	NUMBER,
		VL_PERCENTUAL_PACIENTE	NUMBER,
		CD_SETOR	NUMBER,
		CD_PRESTADOR	NUMBER,
		TP_PAGAMENTO	VARCHAR2(2000),
		DSP_NM_PRESTADOR	VARCHAR2(2000),
		VL_UNITARIO	NUMBER,
		VL_TOTAL_CONTA	NUMBER,
		VL_OPERACIONAL_UNITARIO	NUMBER,
		VL_HONORARIO_UNITARIO	NUMBER,
		QT_CH_UNITARIO	NUMBER,
		VL_FILME_UNITARIO	NUMBER,
		VL_ACRESCIMO	NUMBER,
		VL_DESCONTO	NUMBER,
		CD_REG_FAT	NUMBER,
		DSP_NM_SETOR	VARCHAR2(2000),
		DSP_PRO_FAT_SN_ATIVO	VARCHAR2(2000),
		CD_ATI_MED	VARCHAR2(2000),
		CD_FRANQUIA	NUMBER,
		CD_REGRA_ACOPLAMENTO	VARCHAR2(2000),
		SN_PACIENTE_PAGA	VARCHAR2(2000),
		DSP_VL_INICIAL	NUMBER,
		CD_REG_FAT_REL	NUMBER,
		CD_LANCAMENTO_REL	NUMBER,
		CD_USUARIO	VARCHAR2(2000),
		TP_MVTO	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block ITREG_FAT_ORIGINAL's items
	TYPE ITREG_FAT_ORIGINALRec IS RECORD (
		CD_LANCAMENTO	NUMBER,
		CD_GRU_FAT	NUMBER,
		DSP_DS_GRU_FAT	VARCHAR2(2000),
		DSP_TP_GRU_FAT	VARCHAR2(2000),
		CD_PRO_FAT	VARCHAR2(2000),
		DSP_DS_UNIDADE	VARCHAR2(2000),
		DSP_DS_PRO_FAT	VARCHAR2(2000),
		DSP_TP_SEXO	VARCHAR2(2000),
		DSP_CD_GRU_PRO	NUMBER,
		DSP_NR_AUXILIAR	NUMBER,
		DSP_CD_POR_ANE	NUMBER,
		DSP_TP_GRU_PRO	VARCHAR2(2000),
		DSP_SN_CADASTRA_QTD	VARCHAR2(2000),
		DSP_SN_CADASTRA_DATA	VARCHAR2(2000),
		DSP_SN_CADASTRA_CRM	VARCHAR2(2000),
		DSP_SN_CADASTRA_VALOR	VARCHAR2(2000),
		DSP_SN_CADASTRA_PERC_PACIENTE	VARCHAR2(2000),
		DSP_TP_DT_REFERENCIA_LANCAMENT	VARCHAR2(2000),
		DSP_QTD_MAXIMA	NUMBER,
		CD_SETOR	NUMBER,
		CD_PRESTADOR	NUMBER,
		TP_PAGAMENTO	VARCHAR2(2000),
		DSP_NM_PRESTADOR	VARCHAR2(2000),
		CD_REG_FAT	NUMBER,
		DSP_NM_SETOR	VARCHAR2(2000),
		DSP_PRO_FAT_SN_ATIVO	VARCHAR2(2000),
		SN_PACIENTE_PAGA	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block ITREG_FAT_LANC_PACOTE's items
	TYPE ITREG_FAT_LANC_PACOTERec IS RECORD (
		CD_GRU_FAT	NUMBER,
		CD_PRO_FAT	VARCHAR2(2000),
		CD_SETOR	NUMBER,
		SN_PERTENCE_PACOTE	VARCHAR2(2000),
		CD_CONTA_PACOTE	NUMBER,
		DSP_DS_GRU_FAT	VARCHAR2(2000),
		DSP_DS_PRO_PCT	VARCHAR2(2000),
		DSP_NM_SETOR_PRO_PCT	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block ITLAN_MED2's items
	TYPE ITLAN_MED2Rec IS RECORD (
		DSP_TP_FUNCAO	VARCHAR2(2000),
		DSP_VL_PERCENTUAL_PAGO	NUMBER,
		CD_PRESTADOR	NUMBER,
		DSP_NM_PRESTADOR	VARCHAR2(2000),
		DSP_SN_ANESTESISTA	VARCHAR2(2000),
		DSP_SN_AUXILIAR	VARCHAR2(2000),
		DSP_SN_CIRURGIAO	VARCHAR2(2000),
		DSP_SN_OUTROS	VARCHAR2(2000),
		TP_PAGAMENTO	VARCHAR2(2000),
		SN_PACIENTE_PAGA	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block ITREG_FAT_RELACIONADO's items
	TYPE ITREG_FAT_RELACIONADORec IS RECORD (
		CD_GRU_FAT	NUMBER,
		CD_PRO_FAT	VARCHAR2(2000),
		DT_LANCAMENTO	DATE,
		DSP_DS_GRU_FAT	VARCHAR2(2000),
		DSP_DS_UNIDADE	VARCHAR2(2000),
		DSP_DS_PRO_FAT	VARCHAR2(2000),
		DSP_CD_GRU_PRO	NUMBER,
		DSP_TP_GRU_PRO	VARCHAR2(2000),
		DSP_TP_GRU_FAT	VARCHAR2(2000),
		DSP_TP_SEXO	VARCHAR2(2000),
		DSP_NR_AUXILIAR	NUMBER,
		DSP_CD_POR_ANE	NUMBER,
		DSP_QTD_MAXIMA	NUMBER,
		DSP_PRO_FAT_SN_ATIVO	VARCHAR2(2000),
		DSP_SN_CADASTRA_QTD	VARCHAR2(2000),
		DSP_SN_CADASTRA_DATA	VARCHAR2(2000),
		DSP_SN_CADASTRA_CRM	VARCHAR2(2000),
		DSP_SN_CADASTRA_VALOR	VARCHAR2(2000),
		DSP_SN_CADASTRA_PERC_PACIENTE	VARCHAR2(2000),
		DSP_TP_DT_REFERENCIA_LANCAMENT	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block TRANSF_CONTAS's items
	TYPE TRANSF_CONTASRec IS RECORD (
		CD_REG_FAT	NUMBER,
		CD_CONVENIO	NUMBER,
		CD_REG_FAT_DEST	NUMBER,
		DT_INICIO_DEST	DATE,
		DT_FINAL_DEST	DATE,
		CD_CONVENIO_DEST	NUMBER,
		DSP_NM_CONVENIO_DEST	VARCHAR2(2000),
		DSP_CD_POR_ANE	VARCHAR2(2000),
		DSP_NR_AUXILIAR	VARCHAR2(2000),
		DSP_CD_CATEGORIA	VARCHAR2(2000),
		DSP_SN_TITULAR	VARCHAR2(2000),
		DSP_SN_PENSIONISTA	VARCHAR2(2000),
		DSP_CD_PRO_FAT	VARCHAR2(2000),
		DSP_CD_GRU_FAT	VARCHAR2(2000),
		DSP_CD_GRU_PRO	VARCHAR2(2000),
		DSP_DT_LANCAMENTO	Date
	);

	-- Record to be used as parameter of procedures and functions that access application block ITCOB_PRE's items
	TYPE ITCOB_PRERec IS RECORD (
		SN_CONSIG_PERCENT	VARCHAR2(2000),
		VL_PRECO_UNITARIO	NUMBER,
		VL_PRECO_TOTAL	NUMBER
	);

	-- Record to be used as parameter of procedures and functions that access application block ITREG_FAT_SINTETICO's items
	TYPE ITREG_FAT_SINTETICORec IS RECORD (
		CD_GRU_FAT	NUMBER,
		CD_PRO_FAT	VARCHAR2(2000),
		DT_LANCAMENTO	DATE,
		CD_SETOR	NUMBER,
		CD_PRESTADOR	NUMBER,
		TP_PAGAMENTO	VARCHAR2(2000),
		DSP_DS_GRU_FAT	VARCHAR2(2000),
		DSP_DS_UNIDADE	VARCHAR2(2000),
		DSP_DS_PRO_FAT	VARCHAR2(2000),
		DSP_NM_PRESTADOR	VARCHAR2(2000),
		DSP_NM_SETOR	VARCHAR2(2000),
		DSP_TP_GRU_FAT	VARCHAR2(2000),
		DSP_SN_CADASTRA_QTD	VARCHAR2(2000),
		DSP_SN_CADASTRA_DATA	VARCHAR2(2000),
		DSP_SN_CADASTRA_CRM	VARCHAR2(2000),
		DSP_SN_CADASTRA_VALOR	VARCHAR2(2000),
		DSP_SN_CADASTRA_PERC_PACIENTE	VARCHAR2(2000),
		DSP_TP_DT_REFERENCIA_LANCAMENT	VARCHAR2(2000),
		DSP_TP_SEXO	VARCHAR2(2000),
		DSP_CD_GRU_PRO	NUMBER,
		DSP_NR_AUXILIAR	NUMBER,
		DSP_CD_POR_ANE	NUMBER,
		DSP_TP_GRU_PRO	VARCHAR2(2000),
		DSP_QTD_MAXIMA	NUMBER,
		DSP_PRO_FAT_SN_ATIVO	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block REG_FAT's items
	TYPE REG_FATRec IS RECORD (
		CD_ATENDIMENTO	NUMBER,
		DSP_CD_CID	VARCHAR2(2000),
		DSP_CD_GUIA_ATEND	NUMBER,
		CD_REG_FAT	NUMBER,
		CD_REG_FAT_PAI	NUMBER,
		CD_CONTA_PAI	NUMBER,
		TP_MVTO	VARCHAR2(2000),
		DT_INICIO	Date,
		DT_FINAL	Date,
		CD_TIP_ACOM	NUMBER,
		CD_CONVENIO	NUMBER,
		CD_CON_PLA	NUMBER,
		CD_REGRA	NUMBER,
		CD_REMESSA	NUMBER,
		CD_PRO_FAT_SOLICITADO	VARCHAR2(2000),
		SN_FECHADA	VARCHAR2(2000),
		DSP_IMPRESSA	VARCHAR2(2000),
		DSP_NR_CARTEIRA	VARCHAR2(2000),
		DSP_DT_VALIDADE	DATE,
		DSP_NM_TITULAR	VARCHAR2(2000),
		DSP_NM_EMPRESA	VARCHAR2(2000),
		DSP_DS_CATEGORIA	VARCHAR2(2000),
		DSP_CD_CATEGORIA	NUMBER,
		DSP_SN_TITULAR	VARCHAR2(2000),
		DSP_SN_PENSIONISTA	VARCHAR2(2000),
		CD_MULTI_EMPRESA	NUMBER,
		DSP_EMPRESA_ATENDIME	NUMBER,
		DSP_DT_ATENDIMENTO	DATE,
		DSP_HR_ATENDIMENTO	Date,
		DSP_CD_TIP_ACOM	NUMBER,
		DSP_DS_TIP_ACOM2	VARCHAR2(2000),
		DSP_DT_VAL_GUIA	DATE,
		DSP_TP_ATENDIMENTO	VARCHAR2(2000),
		DSP_DT_ALTA	DATE,
		DSP_HR_ALTA	Date,
		DSP_CD_CONVENIO	NUMBER,
		DSP_NM_CONVENIO_ATENDIMENTO	VARCHAR2(2000),
		DSP_TP_CONVENIO_ATENDIMENTO	VARCHAR2(2000),
		DSP_TP_FORMA_AGRUPAMENTO	VARCHAR2(2000),
		DSP_TP_IMPORTAR_MATMED	VARCHAR2(2000),
		DSP_NR_GUIA_ATEND	VARCHAR2(2000),
		DSP_CD_ORI_ATE	NUMBER,
		DSP_DS_ORI_ATE	VARCHAR2(2000),
		DSP_CD_PACIENTE	NUMBER,
		DSP_NM_PACIENTE	VARCHAR2(2000),
		DSP_TP_SEXO	VARCHAR2(2000),
		DSP_CD_PRESTADOR	NUMBER,
		DSP_NM_PRESTADOR	VARCHAR2(2000),
		DSP_DS_PROC_INTERN	VARCHAR2(2000),
		DSP_DS_CID	VARCHAR2(2000),
		DSP_DT_ABERTURA	DATE,
		DSP_DT_FECHAMENTO	DATE,
		DSP_SN_FECHADA_REMESSA	VARCHAR2(2000),
		DSP_CD_AGRUPAMENTO	NUMBER,
		DT_GUIA	DATE,
		DSP_DS_TIP_ACOM	VARCHAR2(2000),
		DSP_DS_REGRA	VARCHAR2(2000),
		DSP_DS_CON_PLA	VARCHAR2(2000),
		DSP_CD_FOR_APRE	NUMBER,
		DSP_CD_REGRA	NUMBER,
		VL_ORIGINAL	NUMBER,
		SN_FATURA_IMPRESSA	VARCHAR2(2000),
		SN_CONTA_CALCULADA	VARCHAR2(2000),
		DSP_FECHADA	VARCHAR2(2000),
		DSP_SN_CONTA_CALCULADA	VARCHAR2(2000),
		CD_CON_PLA_OLD	NUMBER,
		CD_CONVENIO_OLD	NUMBER,
		DSP_NM_CONVENIO	VARCHAR2(2000),
		DSP_TP_CONVENIO	VARCHAR2(2000),
		DSP_NR_GUIA_CONTA	VARCHAR2(2000),
		CD_PRO_FAT_REALIZADO	VARCHAR2(2000),
		DSP_SN_PERTENCE_PACOTE	VARCHAR2(2000),
		DSP_CD_EMPRESA_CARTEIRA	NUMBER,
		DSP_SN_ACOMOD_CONTA	VARCHAR2(2000),
		DSP_SN_GUIA	VARCHAR2(2000),
		DSP_CD_CONVENIO_SECUNDARIO	NUMBER,
		DSP_CD_CON_PLA_SECUNDARIO	NUMBER,
		DSP_CD_ESPECIALID	NUMBER,
		DSP_VL_TOTAL_CONTA	NUMBER,
		DSP_CT_DIARIA_PERM	NUMBER,
		DSP_CT_DIARIA_PAC	NUMBER,
		DSP_CT_DIARIA_UTI	NUMBER,
		DSP_CT_DIARIA_ACOMP	NUMBER,
		TP_DESCONTO	VARCHAR2(2000),
		DS_OBSERVACAO_FRANQUIA	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block ITLAN_MED_ORIGINAL's items
	TYPE ITLAN_MED_ORIGINALRec IS RECORD (
		CD_ATI_MED	VARCHAR2(2000),
		DSP_DS_ATI_MED	VARCHAR2(2000),
		DSP_TP_FUNCAO	VARCHAR2(2000),
		DSP_VL_PERCENTUAL_PAGO	NUMBER,
		CD_PRESTADOR	NUMBER,
		DSP_NM_PRESTADOR	VARCHAR2(2000),
		DSP_SN_ANESTESISTA	VARCHAR2(2000),
		DSP_SN_AUXILIAR	VARCHAR2(2000),
		DSP_SN_CIRURGIAO	VARCHAR2(2000),
		DSP_SN_OUTROS	VARCHAR2(2000),
		TP_PAGAMENTO	VARCHAR2(2000),
		SN_PACIENTE_PAGA	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block DESC_GRU_PRO's items
	TYPE DESC_GRU_PRORec IS RECORD (
		CD_CONTA_DESC_DET	NUMBER,
		CD_REG_FAT	VARCHAR2(2000),
		DSP_EMPRESA	VARCHAR2(2000),
		DS_OBSERVACAO_FRANQUIA	VARCHAR2(2000),
		CD_GRU_PRO	NUMBER,
		NM_PROCED_GRU	VARCHAR2(2000),
		VL_PERC_DESCONTO	NUMBER,
		VL_DESCONTO	NUMBER,
		CD_REG_AMB	VARCHAR2(2000),
		CD_ATENDIMENTO	VARCHAR2(2000),
		CD_PRO_FAT	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block ITREG_FAT's items
	TYPE ITREG_FATRec IS RECORD (
		CD_REG_FAT	NUMBER,
		CD_LANCAMENTO	NUMBER,
		CD_GRU_FAT	NUMBER,
		DSP_DS_GRU_FAT	VARCHAR2(2000),
		DSP_TP_GRU_FAT	VARCHAR2(2000),
		CD_PRO_FAT	VARCHAR2(2000),
		DSP_DS_UNIDADE	VARCHAR2(2000),
		DSP_DS_PRO_FAT	VARCHAR2(2000),
		DSP_TP_SEXO	VARCHAR2(2000),
		DSP_CD_GRU_PRO	NUMBER,
		DSP_NR_AUXILIAR	NUMBER,
		DSP_CD_POR_ANE	NUMBER,
		DSP_TP_GRU_PRO	VARCHAR2(2000),
		DSP_SN_CADASTRA_QTD	VARCHAR2(2000),
		DSP_SN_CADASTRA_DATA	VARCHAR2(2000),
		DSP_SN_CADASTRA_CRM	VARCHAR2(2000),
		DSP_SN_CADASTRA_VALOR	VARCHAR2(2000),
		DSP_SN_CADASTRA_PERC_PACIENTE	VARCHAR2(2000),
		DSP_TP_DT_REFERENCIA_LANCAMENT	VARCHAR2(2000),
		DSP_QTD_MAXIMA	NUMBER,
		DT_LANCAMENTO	DATE,
		HR_LANCAMENTO	Date,
		SN_HORARIO_ESPECIAL	VARCHAR2(2000),
		QT_LANCAMENTO	NUMBER,
		VL_PERCENTUAL_MULTIPLA	NUMBER,
		VL_PERCENTUAL_PACIENTE	NUMBER,
		CD_SETOR	NUMBER,
		CD_SETOR_PRODUZIU	NUMBER,
		CD_PRESTADOR	NUMBER,
		TP_PAGAMENTO	VARCHAR2(2000),
		DSP_NM_PRESTADOR	VARCHAR2(2000),
		VL_UNITARIO	NUMBER,
		VL_TOTAL_CONTA	NUMBER,
		VL_OPERACIONAL_UNITARIO	NUMBER,
		VL_HONORARIO_UNITARIO	NUMBER,
		QT_CH_UNITARIO	NUMBER,
		VL_FILME_UNITARIO	NUMBER,
		VL_ACRESCIMO	NUMBER,
		VL_DESCONTO	NUMBER,
		DSP_NM_SETOR	VARCHAR2(2000),
		DSP_QT_RATEIO	NUMBER,
		DSP_PRO_FAT_SN_ATIVO	VARCHAR2(2000),
		CD_ATI_MED	VARCHAR2(2000),
		CD_FRANQUIA	NUMBER,
		CD_REGRA_ACOPLAMENTO	VARCHAR2(2000),
		SN_PACIENTE_PAGA	VARCHAR2(2000),
		DSP_VL_INICIAL	NUMBER,
		CD_LANCAMENTO_REL	NUMBER,
		CD_USUARIO	VARCHAR2(2000),
		CD_MVTO	NUMBER,
		TP_MVTO	VARCHAR2(2000),
		DSP_NM_SETOR_EXEC	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block ITLAN_MED_REL's items
	TYPE ITLAN_MED_RELRec IS RECORD (
		DSP_TP_FUNCAO	VARCHAR2(2000),
		DSP_VL_PERCENTUAL_PAGO	NUMBER,
		CD_PRESTADOR	NUMBER,
		DSP_NM_PRESTADOR	VARCHAR2(2000),
		DSP_SN_ANESTESISTA	VARCHAR2(2000),
		DSP_SN_AUXILIAR	VARCHAR2(2000),
		DSP_SN_CIRURGIAO	VARCHAR2(2000),
		DSP_SN_OUTROS	VARCHAR2(2000),
		TP_PAGAMENTO	VARCHAR2(2000),
		SN_PACIENTE_PAGA	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block CONTA_KIT's items
	TYPE CONTA_KITRec IS RECORD (
		CD_PRESTADOR	NUMBER,
		DSP_NM_PRESTADOR	VARCHAR2(2000),
		CD_CONTA_KIT	VARCHAR2(2000),
		CD_PADRAO	NUMBER,
		DS_PADRAO	VARCHAR2(2000),
		DT_LANCAMENTO	Date,
		HR_LANCAMENTO	Date,
		QT_PADRAO	NUMBER,
		CD_SETOR	NUMBER,
		DSP_NM_SETOR	VARCHAR2(2000),
		DSP_DT_SESSAO	DATE,
		TP_PAGAMENTO	VARCHAR2(2000),
		CD_REG_FAT	VARCHAR2(2000),
		CD_ATENDIMENTO	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block CG$CTRL's items
	TYPE CG$CTRLRec IS RECORD (
		CD_REMESSA_ANT	NUMBER,
		SN_CHK_EQUIPE	VARCHAR2(2000),
		DSP_NR_AUX_DIGITADO	NUMBER,
		DSP_NR_AUX_DIGITADO_REL	NUMBER,
		DSP_PREST_DIGITADO	VARCHAR2(2000),
		DSP_PREST_DIGITADO_REL	VARCHAR2(2000),
		SN_IMPRIME	VARCHAR2(2000),
		SN_NOVA_CONTA	VARCHAR2(2000),
		DSP_ERRO_VALOR	VARCHAR2(2000),
		CD_PRO_FAT_SOLICITADO	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block AUDITORIA_DATA's items
	TYPE AUDITORIA_DATARec IS RECORD (
		QT_LANCAMENTO	NUMBER,
		CD_MOTIVO_AUDITORIA	NUMBER,
		DSP_DS_PRO_FAT	VARCHAR2(2000),
		DT_LANCAMENTO	DATE,
		DSP_DS_MOTIVO_AUDITORIA	VARCHAR2(2000),
		QT_AUXILIAR	NUMBER,
		CD_PRO_FAT	VARCHAR2(2000),
		CD_MVTO	NUMBER,
		DSP_TP_MOTIVO_AUDITORIA	VARCHAR2(2000),
		CD_USUARIO_SOL	VARCHAR2(2000),
		CD_USUARIO_REL	VARCHAR2(2000),
		CD_SETOR	NUMBER,
		CD_SETOR_PRODUZIU	NUMBER,
		VL_TOTAL	NUMBER
	);

	-- Record to be used as parameter of procedures and functions that access application block CG$CTRL_2's items
	TYPE CG$CTRL_2Rec IS RECORD (
		DSP_AT_DIARIA_PERM	NUMBER,
		DSP_AT_DIARIA_PAC	NUMBER,
		DSP_AT_DIARIA_UTI	NUMBER,
		DSP_AT_DIARIA_ACOMP	NUMBER
	);

	-- Record to be used as parameter of procedures and functions that access application block DESC_PRO_FAT's items
	TYPE DESC_PRO_FATRec IS RECORD (
		CD_CONTA_DESC_DET	NUMBER,
		CD_REG_FAT	VARCHAR2(2000),
		DSP_EMPRESA	VARCHAR2(2000),
		DS_OBSERVACAO_FRANQUIA	VARCHAR2(2000),
		CD_PRO_FAT	VARCHAR2(2000),
		NM_PROCED	VARCHAR2(2000),
		VL_PERC_DESCONTO	NUMBER,
		VL_DESCONTO	NUMBER,
    DSP_CD_LANCAMENTO	NUMBER,
		CD_REG_AMB	VARCHAR2(2000),
		CD_ATENDIMENTO	VARCHAR2(2000)
	);

	-- Record to be used as parameter of procedures and functions that access application block COMUM's items
	TYPE COMUMRec IS RECORD (
		CD_CONTA	VARCHAR2(2000),
		DS_EMPRESA	VARCHAR2(2000)
	);


	-- Record to be used as parameter of procedures and functions that access application level global variables
	TYPE GlobalsRec IS RECORD (
		CD_PRO_INT	VARCHAR2(256),
		OLD_VL_FRANQUIA	VARCHAR2(256),
		CANCELANDO	VARCHAR2(256),
		SN_FILL_REVISAO	VARCHAR2(256),
		CONTA_DEST	VARCHAR2(256)
	);


	-- Record to be used as parameter of procedures and functions that access application level Form parameters
	TYPE FormParamsRec IS RECORD (
		P_MIG_CD_MULTI_EMPRESA    NUMBER,
		P_MIG_CD_USUARIO    VARCHAR2(4000),
		P_MIG_SN_REMESSA_AUTOMATICA    VARCHAR2(4000),
		P_MIG_SN_PSDI_PEDIDO    VARCHAR2(4000),
		P_MIG_SN_PSSD_PEDIDO    VARCHAR2(4000),
		P_MIG_SN_ESTORNO_SOLIC_DEVOL    VARCHAR2(4000),
		P_NR_CARTEIRA    VARCHAR2(4000),
		P_MIG_SN_RELACIONADA    VARCHAR2(4000),
		P_MIG_SN_ABRE_FECHA_CONTA    VARCHAR2(4000),
		P_MIG_SN_MOSTRA_VL_ORIG    VARCHAR2(4000),
		P_MIG_CD_HOSPITAL    NUMBER,
		P_MIG_SN_AUDITORIA_CONTA    VARCHAR2(4000),
		P_MIG_SN_VALIDA_VALOR_OPME_FAT    VARCHAR2(4000),
		P_MIG_LCTO_SETOR_NAO_PRODUTIVO    VARCHAR2(4000),
		P_MIG_SN_FILTRA_PROC_PRECO    VARCHAR2(4000),
		P_MIG_SN_CREDENCIADO_CENTAVOS    VARCHAR2(4000),
		P_MIG_CD_USUARIO_AUDIT_IN_LOCO    VARCHAR2(4000),
		P_MIG_TP_IMPRESSAO_FATURA    VARCHAR2(4000),
		P_MIG_CD_CONVENIO_FAT_EXTRA    NUMBER,
		P_MIG_CD_CON_PLA_FAT_EXTRA    NUMBER,
		P_MIG_SN_CONTRL_PROC_PRINC_FAT    VARCHAR2(4000),
		P_MIG_SN_AUDITA_APOS_IMPRESSAO    VARCHAR2(4000),
		P_MIG_CD_ATI_MED_CLINICO    VARCHAR2(4000),
		P_MIG_SN_PRESTADOR_DUPLICADO    VARCHAR2(4000),
		P_MIG_SN_CHECAGEM_AVI_CIR    VARCHAR2(4000),
		P_MIG_SN_CREDENCIADO_AUTO    VARCHAR2(4000),
		P_MIG_SN_PERMITE_AUDITAR_MAIOR    VARCHAR2(4000),
		P_MIG_SN_DEVOLUCAO_FAT_SOLIC    VARCHAR2(4000),
		P_MIG_SN_MULTIPLAS_REGRAS_PACO    VARCHAR2(4000),
		P_MIG_SN_CRIA_NF_AO_FECHAR_CT    VARCHAR2(4000),
		P_MIG_SN_DIFEP_OBRIGATORIO    VARCHAR2(4000),
		P_MIG_SN_HAB_DADOS_NOTA_LANC    VARCHAR2(4000),
		P_MIG_SN_PERMITE_KIT_PARCIAL    VARCHAR2(4000),
		P_MIG_SN_PROIBE_LANC_FC    VARCHAR2(4000),
		P_MIG_SN_PROIBE_LANC_NA    VARCHAR2(4000),
		P_MIG_SN_CONFIRMA_CONSUMO_AVIS    VARCHAR2(4000),
		P_MIG_NM_USUARIO    VARCHAR2(4000),
		P_MIG_DS_MULTI_EMPRESA    VARCHAR2(4000),
		P_MIG_SN_USUARIO_SETOR    VARCHAR2(4000)
               ,P_TEMP_CD_PRO_FAT         VARCHAR2(4000)       -- pda RE 376214
	);

	type reg_rec is record ( erro varchar2(2000));

	type tTable is table of reg_rec
	  index by binary_integer;

	type rAtividadeMedica is record (CD_ATI_MED dbamv.ati_med.cd_ati_med%type);

	type tAtividadeMedica is table of rAtividadeMedica
	  index by binary_integer;

	tAtiMed   			 tAtividadeMedica;
	nIndexAtiMed		 Number;

	tTabela   			        tTable;

    -- Record to be used as parameter of procedures and functions that access package VAR's vars
    TYPE varRec IS RECORD (
        tTabela tTable,
        nIndex Number,
        del varchar2(1),
        vSnValidarGruFat Varchar2(1),
        vTpAlteracaoKit varchar2(1),
        vAgrupamento varchar2(2),
        vSnImportacao varchar2(1) := 'N',
        nCdRegLanc number
    );

	function Getreg_rec(reader PKG_XML.XmlReader) return reg_rec is
	  rec reg_rec;
  begin
	  rec.erro := PKG_XML.GetVarchar2(reader ,'erro');

    return rec;
  end Getreg_rec;

  /*  saves a record to xml */
  procedure Setreg_rec(recRow in out NOCOPY PKG_XML.XmlRow, rec reg_rec)  is
  begin
    PKG_XML.SetVarChar2(recRow,'erro', rec.ERRO);
  end;

  function ConvertTTableToOraTable(param CLOB) return tTable is
     oraTable tTable;
     reader PKG_XML.XmlReader;
     key_row INTEGER;
     recReader PKG_XML.XmlReader;
   begin
     reader :=PKG_XML.InitTable(param);
     FOR index_row IN 1..PKG_XML.CountRows(reader) LOOP
       key_row := PKG_XML.GetRowKey(reader, index_row);
       recReader := PKG_XML.GetRow(reader, key_row);
       oraTable(key_row) := Getreg_rec(recReader);
     END LOOP;
     return oraTable;
   end;

   function ConvertTTableToXml(rec TTable) return clob is
     key_row INTEGER;
     recRow PKG_XML.XmlRow;
     xml PKG_XML.XmlTable;
   begin
     xml := PKG_XML.CreateTable();
     key_row := rec.FIRST;
     WHILE key_row IS NOT NULL
     LOOP
       recRow := PKG_XML.CreateRow;
       Setreg_rec(recRow, rec(key_row));
       PKG_XML.SetRow(xml,recRow, key_row);
       key_row := rec.NEXT(key_row);
     END LOOP;
     return PKG_XML.GetTableParam(xml,'ora_table');
   end;


-- Extracted code units
    FUNCTION F_CHK_EQMEDICA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, var IN OUT NOCOPY VARRec, formParams IN OUT NOCOPY FormParamsRec) RETURN Boolean;
    FUNCTION F_GET_REMESSA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,nConv in Number,
                      nOrigem in Number,
                      dDataAtend in Date) RETURN Number;
    FUNCTION F_TEM_ACOPLAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,cProFat in VarChar2, nGruPro in Number) RETURN Boolean;
    FUNCTION F_POPULA_NM_SETOR (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdSetor in number, pMostraMensagem in boolean default false, pRaise in boolean default false) RETURN varchar2;
    FUNCTION F_CHK_VALORES (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) RETURN Boolean;
    FUNCTION F_ESTA_ACOPLADO (xml IN OUT NOCOPY PKG_XML.XmlContext,pConta in itreg_fat.cd_reg_fat%type , pPro_Fat in varchar2, pLanc in itreg_fat.cd_lancamento_pai%type) RETURN varchar2;
    FUNCTION F_VERIF_GUIAS_ATEND_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) RETURN varchar2;
    FUNCTION F_CHK_FRANQUIA_DESCONTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, var IN OUT NOCOPY VARRec,bExclusao in boolean) RETURN varchar;
    FUNCTION F_SN_VERIFICA_PRECO_REL (xml IN OUT NOCOPY PKG_XML.XmlContext,pnCdProFat IN val_pro_relacionado.cd_pro_fat%type, pnCdProFatPai IN val_pro_relacionado.cd_pro_fat_pai%type,
	                                  pnCdRegra IN val_pro_relacionado.cd_regra%type, pdDtReferencia IN val_pro_relacionado.dt_vigencia%type) RETURN BOOLEAN;
    FUNCTION F_DESCRICAO_EMPRESA (xml IN OUT NOCOPY PKG_XML.XmlContext,pnCdRegFat in number, pnCdMultiEmpresa out number) RETURN varchar2;
    FUNCTION F_RETORNA_SEQUENCIA_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext) RETURN reg_fat.cd_reg_fat%type;
    FUNCTION F_VL_ITENS (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdRegFat in number, pnCdMultiEmpresa in number) RETURN number;
    FUNCTION F_RETORNA_SEQUENCIA_AUD_CONT (xml IN OUT NOCOPY PKG_XML.XmlContext) RETURN auditoria_conta.cd_auditoria_conta%type;
    FUNCTION F_CHECA_FORNECEDOR (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdForncedor in number, pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) RETURN varchar2;
    FUNCTION F_CHECA_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec,pnCdPrestador in number,
	                            pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean, pvOrigem in varchar2) RETURN varchar2;
    FUNCTION F_CHECA_ATI_MED (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec,pnCdAtiMed in varchar2,
	                          pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean, pvOrigem in varchar2) RETURN varchar2;
    FUNCTION F_QTD_AUDITORIA (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pCD_REG_FAT          in number,
                             pTp_Motivo_Auditoria in varchar2 default null) RETURN number;
    FUNCTION F_VL_ITENS_POR_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdRegFat in number, pvCdProFat in VARCHAR2, pvCdLancamento IN NUMBER) RETURN number;
    FUNCTION F_VL_ITENS_POR_GRU_PRO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdRegFat in number, pnCdGruPro in number) RETURN number;
    FUNCTION F_VL_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdRegFat in number, pnCdMultiEmpresa in number) RETURN number;
    FUNCTION F_TP_ATENDIMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,nCdAtendimento in number) RETURN varchar2;
    FUNCTION F_VALIDAR_REGISTRO (xml IN OUT NOCOPY PKG_XML.XmlContext,FSV_RECORD_STATUS IN OUT NOCOPY varchar2) RETURN boolean;
    FUNCTION F_LANCA_MVTO_ESTOQUE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
	RETURN varchar2;
    FUNCTION F_LANCA_PRESCRICAO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
	RETURN varchar2;
    FUNCTION F_LANCA_COMPONENTE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
	RETURN varchar2;
    FUNCTION F_LANCA_IMAGEM (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec,nCdMVtoFalha in number,
                          	 nCdItemFalha in number) RETURN varchar2;
    FUNCTION F_LANCA_SADT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec,nCdMVtoFalha in number,
	                       nCdItemFalha in number) RETURN varchar2;
    FUNCTION F_LANCA_NUTRICAO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number) RETURN varchar2;
    FUNCTION F_LANCA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number) RETURN varchar2;
    FUNCTION F_LANCA_EQUIPE_IMAGEM (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
	RETURN varchar2;
    FUNCTION F_LANCA_PRODUTO_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
	RETURN varchar2;
    FUNCTION F_LANCA_KIT_EXAME (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec,
	                            nCdMVtoFalha in number, nCdItemFalha in number) RETURN varchar2;
    FUNCTION F_SN_PERTENCE_PACOTE (xml IN OUT NOCOPY PKG_XML.XmlContext,nCdRegFat in number, nCdLancamento in number, vSnPertencePacote in varchar2 default 'S') RETURN VARCHAR2;
    FUNCTION F_TP_FATURA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,nCdConvenio in number) RETURN varchar2;
    FUNCTION F_PROCESSA_PROIBICAO_PRODUTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec)
	RETURN number;
    FUNCTION F_VALIDA_CONVEIO_E_REMESSA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,nCdRemessa in Number, cDs_Convenio out varchar2) RETURN number;
    FUNCTION F_QTD_FATURAS_JUNTAS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec,pConta in number) RETURN number;
    FUNCTION F_QTD_FATURAS_JUNTAS_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec,pConta in number) RETURN number;
    FUNCTION F_QTD_STOP_LOSS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) RETURN number;
    FUNCTION F_QTD_DOCUMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,nConta in number) RETURN number;
    PROCEDURE P_CHK_REG_FAT_REG_FAT_TIP_A (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean);
    PROCEDURE P_CHK_REG_FAT_REG_FAT_ATEND (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, global IN OUT NOCOPY GlobalsRec, formParams IN OUT NOCOPY FormParamsRec,
	                                       FSV_RECORD_STATUS IN OUT NOCOPY varchar2,pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean);
    PROCEDURE P_CHK_ITREG_FAT_ITREG_FAT_G (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_relacionado IN OUT NOCOPY ITREG_FAT_RELACIONADORec,
	                                       pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec, preg_fat IN OUT NOCOPY REG_FATRec, var IN OUT NOCOPY VARRec,
						                  formParams IN OUT NOCOPY FormParamsRec,cSintetico in VarChar2 Default 'F', pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean);
    PROCEDURE P_CHK_ITREG_FAT_ITREG_FAT_P (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat_relacionado IN OUT NOCOPY ITREG_FAT_RELACIONADORec,
	                                       pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2,
										   P_FIELD_LEVEL IN BOOLEAN, cSintetico in VarChar2 Default 'F');
    PROCEDURE P_CHK_ITREG_FAT_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec,
	                                     pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec,cSintetico in VarChar2 Default 'F',
										 pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean);
    PROCEDURE P_CHK_VALORES_PROCEDIMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,p_cd_pro_fat in VARCHAR2,
                                                                        p_tp_gru_fat in VARCHAR2,
                                                                        p_dt_lancamento in date,
                                                                        p_hr_lancamento in date,
                                                                        p_erro_retorno out VARCHAR2);
    PROCEDURE P_ATUALIZA_SN_FATURA_IMPRESS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2,
	                                        FSV_RECORD_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_ATUALIZA_STATUS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_EXCLUI_LOGS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec);
    PROCEDURE P_CHK_CONVENIO_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean);
    PROCEDURE P_TRANSFERE_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,nConta in reg_fat.cd_reg_fat%type);
    PROCEDURE P_CHK_PRO_INT (xml IN OUT NOCOPY PKG_XML.XmlContext,pcg$ctrl IN OUT NOCOPY CG$CTRLRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean,
                       pbSnMostraMensagem in boolean);
    PROCEDURE P_CHK_CID (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean);
    PROCEDURE P_GRAVA_ATENDIME (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_GRAVA_CARTEIRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_CHK_REGRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean ,pbSnMostraMensagem in boolean);
    PROCEDURE P_CTRL_REG_FAT_BLOCK (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_CHK_CAT_PLANO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_CHK_ITREG_FAT_ITREG_FAT_A (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
	                                       pitreg_fat_relacionado IN OUT NOCOPY ITREG_FAT_RELACIONADORec, pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec,P_FIELD_LEVEL IN BOOLEAN, cSintetico in VarChar2 Default 'F');
    PROCEDURE P_CHK_TRANSF_CONTAS_FAT_A (xml IN OUT NOCOPY PKG_XML.XmlContext,ptransf_contas IN OUT NOCOPY TRANSF_CONTASRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_CHK_TRANSF_CONTAS_FAT_G (xml IN OUT NOCOPY PKG_XML.XmlContext,ptransf_contas IN OUT NOCOPY TRANSF_CONTASRec, formParams IN OUT NOCOPY FormParamsRec,cSintetico in VarChar2 Default 'F',
	                                     pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean);
    PROCEDURE P_CHK_VALORES_PROCEDIMENTO_R (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
	                                        formParams IN OUT NOCOPY FormParamsRec,p_cd_pro_fat in VARCHAR2,
                                                                                p_tp_gru_fat in VARCHAR2,
                                                                                p_dt_lancamento in date,
                                                                                p_hr_lancamento in date,
                                                                                p_erro_retorno out VARCHAR2);
    PROCEDURE P_CHK_MOTIVO_AUD_MOT_AUD (xml IN OUT NOCOPY PKG_XML.XmlContext,pauditoria_conta IN OUT NOCOPY AUDITORIA_CONTARec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, formParams IN OUT NOCOPY FormParamsRec,
	                                    nCdMotivoAuditoria in number, vTpAuditoria in varchar2, pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean);
    PROCEDURE P_VALIDA_PROIBICAO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_VALIDA_PROIBICAO_CARTEIRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_CHK_AUDITORIA_IN_LOCO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pdDt_referencia IN DATE
       ,pdhR_referencia IN DATE);
    PROCEDURE P_ATUALIZA_DIARIAS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl_2 IN OUT NOCOPY CG$CTRL_2Rec);
    PROCEDURE P_APAGA_CONTA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_GERA_NF_QDO_FECHA_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_VALIDA_PERIODO_LANCTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_RECORD_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_LE_CONFIGURACAO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_VERIFICA_PROIBICAO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdConPla       in number
                               , pnCdConvenio     in number
                               , pvCdProFat       in varchar2
                               , pvTpAtendimento  in varchar2
                               , pdDtReferencia   in date
                               , pnCdSetor        in number default null
                               , pnCdMultiEmpresa in number default null
                               , pnCdAtendimento  in number default null
                               , pnQtdlanc        in number default null);
    PROCEDURE P_CHECA_REPASSE_ITEM (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec,nCdRegFat in number, nCdLancamento in number);
    PROCEDURE P_CHECA_PROCEDIMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,
	                                FSV_RECORD_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_INCREMENTA_AUDITORIA_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,pauditoria_conta IN OUT NOCOPY AUDITORIA_CONTARec);
    PROCEDURE P_ALTERA_NR_AUXILIAR_DIGITAD (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec);
    PROCEDURE P_CONVENIO_DADOS (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pCd_Convenio          in number                                                    -- Passagem da Chave
                             , pCd_Multi_Empresa     in number    Default dbamv.pkg_mv2000.le_empresa       -- Codigo da MultiEmpresa Logada
                             , pCd_Usuario           in varchar2  Default user                                    -- Nome Do Usuario Logado
                             , pRaise                in boolean   Default True                                    -- Ser ou não levantada a exceção - "Parar"
                             , pMostraMensagem       in boolean   Default True                                    -- Mostra ou não a Mensagem
                             , pNmConvenio           out varchar2
                             , pTpConvenio           out varchar2
                             , pSnFilantropia        out varchar2
                             , pTpFormaGerarConRec   out varchar2
                             , pTpFormaAgrupamento   out varchar2
                             , pTpImportarMatMed     out varchar2
                             , nCdForApre            out number
                             , pSnValidadeCarteira   out varchar2
                             , pSnGuia               out varchar2
                             , pSnCarteriaParticular out varchar2);
    PROCEDURE P_ABRE_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,pnCdRegFat in number);
    PROCEDURE P_FECHA_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,pnCdRegFat in number);
    PROCEDURE P_ATUALIZA_CONTA_PAI (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,nCdConta in number, vNmBloco in varchar2 default 'ITREG_FAT');
    PROCEDURE P_VALIDA_PREENCHIMENTO_PROC (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, FSV_MODE IN OUT NOCOPY varchar2);
    PROCEDURE P_CHK_ITEM_GERADO_POR_PACOTE (xml IN OUT NOCOPY PKG_XML.XmlContext,nCdRegFat in number, nCdLancamento in number);
    PROCEDURE P_CHK_COMPARTILHAMENTO_FRANQ (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec);
    PROCEDURE P_CHK_DATA_ATENDIMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,vNmBloco in varchar2);
    PROCEDURE P_LANCA_SANGUE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number);
    PROCEDURE P_LANCA_EQUIPAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number);
    PROCEDURE P_LANCA_LIGACAO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMvtoFalha in number);
    PROCEDURE P_LANCA_SANGUE_PBSA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMvtoFalha in number, nCdItemFalha in number);
    PROCEDURE P_LANCA_SANGUE_COMPONEN_PBSA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMvtoFalha in number, nCdItemFalha in number);
    PROCEDURE P_PROCESSA_PROIBICAO_AG (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,
	                                   pitreg_fat IN OUT NOCOPY ITREG_FATRec,bEfetuaBaixaConsumo in boolean);
    PROCEDURE P_CARREGA_DADOS_IT_GUIA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_EXECUCAO_VALIDA_QT_LANC (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitcob_pre IN OUT NOCOPY ITCOB_PRERec,
	                                     formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_C2_DSP_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2);
    PROCEDURE P_I_WVI_RF_CD_TIP_ACOM (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_RECORD_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_I_WVI_RF_CD_REGRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_RECORD_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_I_WVI_RF_DSP_NR_CARTEIRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_RF_DSP_DT_VALIDADE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PD_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_OCDM_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_B_PU_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec);
    PROCEDURE P_I_WVI_IF_SN_HORARIO_ESPECI (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec);
    PROCEDURE P_I_WVI_IF_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, preg_fat IN OUT NOCOPY REG_FATRec,
	                                   pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec, pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec,
									   pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_IF_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2);
    PROCEDURE P_B_PI_ITREG_FAT_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, formParams IN OUT NOCOPY FormParamsRec,
	                                FSV_RECORD_STATUS IN OUT NOCOPY varchar2, FSV_MODE IN OUT NOCOPY varchar2, FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_B_PD_ITREG_FAT_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
	                                FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2, FSV_RECORD_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_B_PI_ITREG_FAT_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_B_PU_ITREG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec);
    PROCEDURE P_B_PD_ITREG_FAT_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_I_WVI_FRF_CD_PLANO_ACP (xml IN OUT NOCOPY PKG_XML.XmlContext,pfranquia_reg_fat IN OUT NOCOPY FRANQUIA_REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PQ_ITREG_FAT_ORIGINAL (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_original IN OUT NOCOPY ITREG_FAT_ORIGINALRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PD_ITREG_FAT_ORIGINAL (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_original IN OUT NOCOPY ITREG_FAT_ORIGINALRec);
    PROCEDURE P_I_WVI_DG_CD_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_geral IN OUT NOCOPY DESC_GERALRec, pfranquia_reg_fat IN OUT NOCOPY FRANQUIA_REG_FATRec, global IN OUT NOCOPY GlobalsRec);
    PROCEDURE P_I_WVI_DGP_CD_GRU_PRO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pdesc_gru_pro IN OUT NOCOPY DESC_GRU_PRORec);
    PROCEDURE P_B_PI_DESC_GRU_PRO_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_gru_pro IN OUT NOCOPY DESC_GRU_PRORec, preg_fat IN OUT NOCOPY REG_FATRec, pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec,
	                                    formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PQ_DESC_GRU_PRO (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_gru_pro IN OUT NOCOPY DESC_GRU_PRORec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec,
	                               formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PD_DESC_GRU_PRO (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, pdesc_gru_pro IN OUT NOCOPY DESC_GRU_PRORec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_DPF_CD_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PI_DESC_PRO_FAT_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_B_PI_DESC_PRO_FAT_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PQ_DESC_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec,
	                               formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PD_DESC_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_IM_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec,
	                                   pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_IM_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
	                                   formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2);
    PROCEDURE P_B_PB_ITLAN_MED2 (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec);
    PROCEDURE P_B_PQ_ITLAN_MED_ORIGINAL (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_original IN OUT NOCOPY ITLAN_MED_ORIGINALRec, FSV_RECORD_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_I_WVI_CK_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_CK_CD_PADRAO (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_CK_CD_SETOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_CK_DSP_DT_SESSAO (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_CK_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
	                                   formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2);
    PROCEDURE P_B_PI_CONTA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, preg_fat IN OUT NOCOPY REG_FATRec, var IN OUT NOCOPY VARRec);
    PROCEDURE P_B_PU_CONTA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec);
    PROCEDURE P_B_PQ_CONTA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PQ_LOG_FALHA_IMPORTACAO (xml IN OUT NOCOPY PKG_XML.XmlContext,plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_AD_QT_LANCAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_AD_DT_LANCAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, var IN OUT NOCOPY VARRec, global IN OUT NOCOPY GlobalsRec);
    PROCEDURE P_I_WVI_AD_CD_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, var IN OUT NOCOPY VARRec,
	                                 global IN OUT NOCOPY GlobalsRec);
    PROCEDURE P_B_PB_AUDITORIA_DATA (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, pauditoria_conta IN OUT NOCOPY AUDITORIA_CONTARec,
	                                 formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_B_PB_AUDITORIA_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pauditoria_conta IN OUT NOCOPY AUDITORIA_CONTARec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_C_CD_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcomum IN OUT NOCOPY COMUMRec);
    PROCEDURE P_I_WVI_IFR_DT_LANCAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
	                                     pitreg_fat_relacionado IN OUT NOCOPY ITREG_FAT_RELACIONADORec, pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec);
    PROCEDURE P_I_WVI_IFR_SN_HORARIO_ESPEC (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec);
    PROCEDURE P_I_WVI_IFR_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
	                                    pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec, pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_IFR_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,
	                                    FSV_MODE IN OUT NOCOPY varchar2);
    PROCEDURE P_B_PI_ITREG_FAT_REL_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
	                                    formParams IN OUT NOCOPY FormParamsRec, FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2, FSV_RECORD_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_B_PD_ITREG_FAT_REL_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
	                                    FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2, FSV_RECORD_STATUS IN OUT NOCOPY varchar2);
    PROCEDURE P_B_PI_ITREG_FAT_REL_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_B_PU_ITREG_FAT_REL (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec);
    PROCEDURE P_B_PD_ITREG_FAT_REL_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_I_WVI_IMR_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
	                                    pcg$ctrl IN OUT NOCOPY CG$CTRLRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_IMR_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
	                                    formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2);
    PROCEDURE P_I_WVI_TC_CD_REG_FAT_DEST (xml IN OUT NOCOPY PKG_XML.XmlContext,ptransf_contas IN OUT NOCOPY TRANSF_CONTASRec, preg_fat IN OUT NOCOPY REG_FATRec, global IN OUT NOCOPY GlobalsRec,
	                                       formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_IFLP_CD_GRU_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_IFLP_CD_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WVI_IFLP_CD_SETOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec, formParams IN OUT NOCOPY FormParamsRec);
    PROCEDURE P_I_WCC_IFLP_SN_PERTENCE_PAC (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec);
    PROCEDURE P_I_WVI_IFLP_CD_CONTA_PACOTE (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec, preg_fat IN OUT NOCOPY REG_FATRec);
    PROCEDURE P_B_WVR_ITREG_FAT_LANC_PACOT (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec);





    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>P_FACHADA</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
PROCEDURE P_FACHADA(in_params in Clob, out_params out Clob) IS
BEGIN

    null;

END P_FACHADA;

    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CHK_EQMEDICA</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_CHK_EQMEDICA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, var IN OUT NOCOPY VARRec, formParams IN OUT NOCOPY FormParamsRec) RETURN Boolean IS
Cursor C_Lctos is
         Select itreg_fat.cd_lancamento,
                itreg_fat.cd_pro_fat,
                itreg_fat.dt_lancamento
           From DBAMV.itreg_fat,
                pro_fat
          Where itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat
            and itreg_fat.cd_reg_fat = pREG_FAT.CD_REG_FAT
            and ( Nvl( pro_fat.nr_auxiliar, 0 ) > 0 or
                  pro_fat.cd_por_ane is not null ) ;

  Cursor C_Excecao(ncd_pro_fat pro_fat.cd_pro_fat%type,
                   ndt_lancamento date) is
        Select por_ane_tab.cd_por_ane,por_ane_tab.nr_auxiliares
          From DBAMV.por_ane_tab,
               DBAMV.itregra,
               DBAMV.pro_fat,
               DBAMV.con_pla,
               DBAMV.empresa_con_pla
         where empresa_con_pla.cd_convenio = con_pla.cd_convenio
           and empresa_con_pla.cd_con_pla = con_pla.cd_con_pla
            and Empresa_Con_Pla.Cd_Multi_Empresa = formParams.P_MIG_CD_MULTI_EMPRESA
            and con_pla.cd_con_pla = pREG_FAT.CD_CON_PLA
              and con_pla.cd_convenio = pREG_FAT.CD_CONVENIO
              and itregra.cd_regra = empresa_con_pla.cd_regra
              and itregra.cd_gru_pro = pro_fat.cd_gru_pro
              and por_ane_tab.cd_pro_fat = pro_fat.cd_pro_fat
             and por_ane_tab.cd_tab_fat  = itregra.cd_tab_fat
             and por_ane_tab.cd_pro_fat  = ncd_pro_fat
             and por_ane_tab.dt_vigencia = ( SELECT MAX( por_ane_tab.dt_vigencia )
                                               FROM DBAMV.por_ane_tab,
                                                    DBAMV.itregra,
                                                    DBAMV.pro_fat,
                                                    DBAMV.con_pla,
                                                    DBAMV.empresa_con_pla
                                                                               where empresa_con_pla.cd_convenio = con_pla.cd_convenio
                                                                                    and empresa_con_pla.cd_con_pla = con_pla.cd_con_pla
                                                                                  and Empresa_Con_Pla.Cd_Multi_Empresa = formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                  and con_pla.cd_con_pla = pREG_FAT.CD_CON_PLA
                                                and con_pla.cd_convenio = pREG_FAT.CD_CONVENIO
                                                and itregra.cd_regra = empresa_con_pla.cd_regra
                                                and itregra.cd_gru_pro = pro_fat.cd_gru_pro
                                                and por_ane_tab.cd_pro_fat = pro_fat.cd_pro_fat
                                                and por_ane_tab.cd_tab_fat  = itregra.cd_tab_fat
                                                and por_ane_tab.cd_pro_fat  = ncd_pro_fat
                                                and por_ane_tab.dt_vigencia <= ndt_lancamento);

  Cursor C_EqMed( nLcto in itlan_med.cd_lancamento%type  ) is
         Select Count(1) qt_lctos
           From DBAMV.itlan_med
          Where itlan_med.cd_reg_fat = pREG_FAT.CD_REG_FAT
            and itlan_med.cd_lancamento = nLcto ;

  cursor cConsumoNaoLancado is
      select 'x'
      From DBAMV.log_falha_importacao lfi
     Where lfi.cd_atendimento = pREG_FAT.CD_ATENDIMENTO
       and lfi.nm_usuario_baixou is null
       and trunc(lfi.dt_importacao) between preg_fat.dt_inicio and nvl(preg_fat.dt_final,trunc(sysdate));

  vConsumoNaoLancado varchar2(1);
  V_Lctos    C_Lctos%RowType ;
  V_Excecao  C_Excecao%RowType ;
  nQtLctos Number ;
  bLocalizouRegistro boolean;
BEGIN

  open  cConsumoNaoLancado;
  fetch cConsumoNaoLancado into vConsumoNaoLancado;
  bLocalizouRegistro := cConsumoNaoLancado%found;
  close cConsumoNaoLancado;

  if var.vSnImportacao <> 'S' AND not bLocalizouRegistro and  pCG$CTRL.SN_CHK_EQUIPE = 'S' then
    For V_Lctos in C_Lctos loop
      Open  C_Excecao( V_Lctos.cd_pro_fat,V_Lctos.dt_lancamento ) ;
      Fetch C_Excecao into V_Excecao;
      bLocalizouRegistro := C_Excecao%found;
      Close C_Excecao;

      if    (bLocalizouRegistro  and
              (V_Excecao.cd_por_ane is not null or nvl(V_Excecao.nr_auxiliares,0) > 0)) or
              (not bLocalizouRegistro) then

          Open C_EqMed( V_Lctos.cd_lancamento ) ;
          Fetch C_EqMed into nQtLctos ;
          Close C_EqMed ;

          if Nvl( nQtLctos, 0 ) = 0 then
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_1)
            PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_1', 'PKG_FFCV_M_LAN_HOS',
						  'Atenção: Falta informar equipe médica do procedimento %s com data de lançamento %s!', arg_list(V_Lctos.cd_pro_fat, V_Lctos.dt_lancamento)), 'W', False) ;
            Return False ;
          end if ;

      end if;
    end loop ;
  end if ;

  Return True ;
END;

FUNCTION F_CHK_EQMEDICA (in_params in Clob, out_params out Clob) RETURN Boolean IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pcg$ctrl CG$CTRLRec;
    var VARRec;
    formParams FormParamsRec;
    result Boolean;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DT_INICIO:= PKG_XML.GetDate(xml, 'REG_FAT.DT_INICIO');
        pREG_FAT.DT_FINAL:= PKG_XML.GetDate(xml, 'REG_FAT.DT_FINAL');
        pCG$CTRL.SN_CHK_EQUIPE:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.SN_CHK_EQUIPE');
        var.vSnImportacao:= PKG_XML.Getvarchar2(xml, 'VAR.VSNIMPORTACAO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_CHK_EQMEDICA_E(xml) THEN
                result:= F_CHK_EQMEDICA(xml, pREG_FAT, pCG$CTRL, VAR, formParams);
                Pkg_ffcv_M_LAN_HOS_C.F_CHK_EQMEDICA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_INICIO', pREG_FAT.DT_INICIO);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_FINAL', pREG_FAT.DT_FINAL);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.SN_CHK_EQUIPE', pCG$CTRL.SN_CHK_EQUIPE);
        PKG_XML.Setvarchar2(xml, 'VAR.VSNIMPORTACAO', var.vSnImportacao);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>Get_Remessa</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_GET_REMESSA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,nConv in Number,
                      nOrigem in Number,
                      dDataAtend in Date) RETURN Number IS
vTpAtend       varchar2(1);
  nCdRemessa     Number ;
BEGIN

  if  formParams.P_MIG_SN_REMESSA_AUTOMATICA = 'N' then
    Return Null ;
  end if ;

  -- Consulta o tipo de atendimento
  vTpAtend := Pkg_ffcv_M_LAN_HOS.F_TP_ATENDIMENTO(xml, formParams, preg_fat.CD_ATENDIMENTO);

  nCdRemessa := PKG_FFCV_REMESSA_FATURA.FNC_OBTEM_REMESSA (  pnCdMultiEmpresa  => formParams.P_MIG_CD_MULTI_EMPRESA,
                                                                   pnCdConvenio      => nConv,
                                                                   pnCdAtendimento   => preg_fat.CD_ATENDIMENTO,
                                                                   pvTpAtendimento   => vTpAtend,
                                                                   pnCdOriAte        => nOrigem,
                                                                   pnCdConta         => preg_fat.cd_reg_fat);



  Return nCdRemessa ;
END;

FUNCTION F_GET_REMESSA (in_params in Clob, out_params out Clob) RETURN Number IS
    xml PKG_XML.XmlContext;
    nConv Number;
    nOrigem Number;
    dDataAtend Date;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    result Number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        formParams.P_MIG_SN_REMESSA_AUTOMATICA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_REMESSA_AUTOMATICA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        nConv:= PKG_XML.GetNumber(xml, 'nConv');
        nOrigem:= PKG_XML.GetNumber(xml, 'nOrigem');
        dDataAtend:= PKG_XML.GetDate(xml, 'dDataAtend');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_GET_REMESSA_E(xml) THEN
                result:= F_GET_REMESSA(xml, pREG_FAT, formParams, nConv, nOrigem, dDataAtend);
                Pkg_ffcv_M_LAN_HOS_C.F_GET_REMESSA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_REMESSA_AUTOMATICA', formParams.P_MIG_SN_REMESSA_AUTOMATICA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>tem_acoplamento</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_TEM_ACOPLAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,cProFat in VarChar2, nGruPro in Number) RETURN Boolean IS
vAtendimeNrCarteira           atendime.nr_carteira%type;
  vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
begin
  M_PKG_PAEU_ATENDIME.P_RETORNA_DADOS(xml, preg_fat.cd_atendimento
                                     ,formParams.P_MIG_CD_MULTI_EMPRESA
                                     ,formParams.P_MIG_CD_USUARIO
                                     ,false
                                     ,false
                                     ,vLst_Retorno);
  --
  vLst_Local := pkg_parametro.fn_recupera_lista_parametros(vLst_Retorno);
  --
  -- Recuperao dos parametros retornados pela Procedure
  pkg_parametro.pr_recupera_parametro(vLst_Local,'NR_CARTEIRA', vAtendimeNrCarteira, false);

  -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
  pkg_parametro.pr_limpar_lista_parametros(vLst_Local);

  RETURN M_PKG_FFCV_ACOPLAMENTO.F_TEM_ACOPLAMENTO(xml, pREG_FAT.DSP_CD_PACIENTE
                                                                                                    ,pREG_FAT.DSP_TP_ATENDIMENTO
                                                                                                    ,vAtendimeNrCarteira
                                                                                                    ,pREG_FAT.CD_CONVENIO
                                                                                                    ,pREG_FAT.CD_CON_PLA
                                                                                                    ,pREG_FAT.DSP_CD_CONVENIO_SECUNDARIO
                                                                                                    ,pREG_FAT.DSP_CD_CON_PLA_SECUNDARIO
                                                                                                    ,cProFat
                                                                                                    ,nGruPro
                                                                                                    ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                                    ,formParams.P_MIG_CD_USUARIO
                                                                                                    ,false
                                                                                                    ,false);
END;

FUNCTION F_TEM_ACOPLAMENTO (in_params in Clob, out_params out Clob) RETURN Boolean IS
    xml PKG_XML.XmlContext;
    cProFat VarChar2(4000);
    nGruPro Number;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    result Boolean;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_CD_PACIENTE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_CD_CONVENIO_SECUNDARIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO_SECUNDARIO');
        pREG_FAT.DSP_CD_CON_PLA_SECUNDARIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CON_PLA_SECUNDARIO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        cProFat:= PKG_XML.GetVarChar2(xml, 'cProFat');
        nGruPro:= PKG_XML.GetNumber(xml, 'nGruPro');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_TEM_ACOPLAMENTO_E(xml) THEN
                result:= F_TEM_ACOPLAMENTO(xml, pREG_FAT, formParams, cProFat, nGruPro);
                Pkg_ffcv_M_LAN_HOS_C.F_TEM_ACOPLAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE', pREG_FAT.DSP_CD_PACIENTE);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO_SECUNDARIO', pREG_FAT.DSP_CD_CONVENIO_SECUNDARIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CON_PLA_SECUNDARIO', pREG_FAT.DSP_CD_CON_PLA_SECUNDARIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_popula_nm_setor</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_POPULA_NM_SETOR (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdSetor in number, pMostraMensagem in boolean default false, pRaise in boolean default false) RETURN varchar2 IS
Begin
    return M_PKG_GLOBAL_SETOR.F_RETORNA_DESCRICAO(xml, pnCdSetor
                                                                                          , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                            , formParams.P_MIG_CD_USUARIO
                                                                                            , pMostraMensagem
                                                                                            , pRaise);
END;

FUNCTION F_POPULA_NM_SETOR (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    pnCdSetor number;
    pMostraMensagem boolean;
    pRaise boolean;
    formParams FormParamsRec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pnCdSetor:= PKG_XML.Getnumber(xml, 'pnCdSetor');
        pMostraMensagem:= PKG_XML.Getboolean(xml, 'pMostraMensagem');
        pRaise:= PKG_XML.Getboolean(xml, 'pRaise');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_POPULA_NM_SETOR_E(xml) THEN
                result:= F_POPULA_NM_SETOR(xml, formParams, pnCdSetor, pMostraMensagem, pRaise);
                Pkg_ffcv_M_LAN_HOS_C.F_POPULA_NM_SETOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>Chk_Valores</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_CHK_VALORES (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) RETURN Boolean IS
nValorConta Number ;
  nValorItens Number ;
  bRetVal     Boolean := True ;
BEGIN
  nValorConta := Pkg_ffcv_M_LAN_HOS.F_VL_CONTA(xml, formParams, preg_fat.cd_reg_fat, formParams.P_MIG_CD_MULTI_EMPRESA);

  nValorItens := Pkg_ffcv_M_LAN_HOS.F_VL_ITENS(xml, formParams, preg_fat.cd_reg_fat, formParams.P_MIG_CD_MULTI_EMPRESA);

  if Nvl( nValorConta, 0 ) <> Nvl( nValorItens, 0 ) then
    bRetVal := False ;
  end if ;

  Return bRetVal ;

END;

FUNCTION F_CHK_VALORES (in_params in Clob, out_params out Clob) RETURN Boolean IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    result Boolean;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_CHK_VALORES_E(xml) THEN
                result:= F_CHK_VALORES(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.F_CHK_VALORES_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>Esta_acoplado</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_ESTA_ACOPLADO (xml IN OUT NOCOPY PKG_XML.XmlContext,pConta in itreg_fat.cd_reg_fat%type , pPro_Fat in varchar2, pLanc in itreg_fat.cd_lancamento_pai%type) RETURN varchar2 IS
Cursor C_Acopla is
    Select cd_reg_fat, cd_lancamento
      From DBAMV.itreg_fat
     Where cd_reg_fat_pai = pConta
       and cd_lancamento_pai = pLanc
       and cd_pro_fat = pPro_Fat ;

   Vconta itreg_fat.cd_reg_fat_pai%type :=null;
   Vlanc itreg_fat.cd_lancamento_pai%type :=null;

BEGIN
  open c_acopla;
  fetch c_acopla into Vconta, Vlanc;
  close c_acopla;

  if Vconta is null then
      return '0';
  else
      return Vconta||'&'||Vlanc;
  end if;
END;

FUNCTION F_ESTA_ACOPLADO (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    pConta NUMBER;
    pPro_Fat varchar2(4000);
    pLanc NUMBER;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pConta:= PKG_XML.GetNUMBER(xml, 'pConta');
        pPro_Fat:= PKG_XML.Getvarchar2(xml, 'pPro_Fat');
        pLanc:= PKG_XML.GetNUMBER(xml, 'pLanc');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_ESTA_ACOPLADO_E(xml) THEN
                result:= F_ESTA_ACOPLADO(xml, pConta, pPro_Fat, pLanc);
                Pkg_ffcv_M_LAN_HOS_C.F_ESTA_ACOPLADO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>verif_guias_atend_conta</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_VERIF_GUIAS_ATEND_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) RETURN varchar2 IS
vSnGuia      convenio.sn_guia%type;
  nCdGuiaRet   guia.cd_guia%type;
  bDuplicidade boolean := false;
  vMsg         varchar2(2000) := null;
  --
BEGIN
  M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, pREG_FAT.DSP_CD_CONVENIO
                                     ,formParams.P_MIG_CD_MULTI_EMPRESA
                                     ,formParams.P_MIG_CD_USUARIO
                                     ,true
                                     ,true
                                     ,'SN_GUIA'
                                     ,vSnGuia);

  if  preg_fat.dsp_cd_guia_atend is null and  pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO = 'C' and vSnGuia = 'S' then
    -- identificando a guia digitada
    nCdGuiaRet := pkg_ffcv_guia.fnc_retorna_guia( preg_fat.cd_atendimento, preg_fat.cd_convenio,
                                                        preg_fat.dsp_nr_guia_atend, bDuplicidade );
    if nCdGuiaRet is null then
     vMsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_161', 'PKG_FFCV_M_LAN_HOS', 'Guia do atendimento não identificada! Use a Janela de Pesquisa para selecionar Guia disponível.');
    end if;
    --
    preg_fat.dsp_cd_guia_atend := nCdGuiaRet;
    --
  end if;
  --
  return vMsg;
  --
END;

FUNCTION F_VERIF_GUIAS_ATEND_CONTA (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    result varchar2(2000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO');
        pREG_FAT.DSP_CD_GUIA_ATEND:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_GUIA_ATEND');
        pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO_ATENDIMENTO');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.DSP_NR_GUIA_ATEND:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NR_GUIA_ATEND');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_VERIF_GUIAS_ATEND_CONTA_E(xml) THEN
                result:= F_VERIF_GUIAS_ATEND_CONTA(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.F_VERIF_GUIAS_ATEND_CONTA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO', pREG_FAT.DSP_CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_GUIA_ATEND', pREG_FAT.DSP_CD_GUIA_ATEND);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO_ATENDIMENTO', pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NR_GUIA_ATEND', pREG_FAT.DSP_NR_GUIA_ATEND);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>chk_franquia_desconto</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_CHK_FRANQUIA_DESCONTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, var IN OUT NOCOPY VARRec,bExclusao in boolean) RETURN varchar IS
    cursor cFranquiasDesc is
        select	cd_reg_fat,
				tp_desconto,
				vl_desconto_conta
        from 	DBAMV.reg_fat
        where 	cd_reg_fat = preg_Fat.cd_reg_fat
			and cd_reg_fat = Nvl(cd_conta_pai, cd_reg_fat)
			and tp_desconto <> 'L'
		union all
   		select	cd_reg_fat,
				tp_desconto,
				vl_desconto_conta
		from  	dbamv.reg_fat
		where 	cd_conta_pai = preg_Fat.cd_reg_fat
			and cd_reg_fat <> cd_conta_pai
			and tp_desconto <> 'L';

    vFranquiasDesc cFranquiasDesc%rowtype;
    vRetorno              varchar2(500);
    bHeader                 boolean:= false;
BEGIN
    if bExclusao then
            for vFranquiasDesc in cFranquiasDesc  loop
                if vFranquiasDesc.vl_desconto_conta > 0 then
                    if not bHeader then
                        vRetorno :=  pkg_rmi_traducao.extrair_pkg_msg('MSG_162', 'PKG_FFCV_M_LAN_HOS', 'Atenção:  Antes de excluir esta conta é necessário excluir os dados referentes');
                        bHeader := true;
                    end if;

                    if vFranquiasDesc.tp_desconto = 'P' then -->> Franquia Paciente
                        vRetorno :=  vRetorno ||' a Franquia do Paciente';
                    Elsif  pReg_Fat.Tp_Desconto = 'C'  then -->> Franquia Convênio
                  vRetorno :=  vRetorno ||' a Franquia de Convênio';
                    Elsif  pReg_Fat.Tp_Desconto = 'D'  then -->> Desconto
                        vRetorno :=  vRetorno ||' ao Desconto';
                    end if;
                    --
                    if vFranquiasDesc.cd_reg_fat <>  pReg_Fat.cd_reg_Fat then
                  vRetorno := vRetorno || ' da conta '|| vFranquiasDesc.cd_reg_fat ||'.';
              else
                  vRetorno := vRetorno || '.';
              end if;

                end if;
            end loop;
    else
            for vFranquiasDesc in cFranquiasDesc  loop
                if vFranquiasDesc.vl_desconto_conta > 0 then

                    if vFranquiasDesc.tp_desconto = 'P' then -->> Franquia Paciente
                     vretorno := 'existe';
                  var.nIndex := var.nIndex + 1;

                  if vFranquiasDesc.cd_reg_fat <>  pReg_Fat.cd_reg_Fat then
                      var.tTabela(var.nIndex).erro :=pkg_rmi_traducao.extrair_pkg_msg('MSG_155', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Para abrir a conta é necessário excluir a franquia paciente da conta: %s', arg_list(vFranquiasDesc.cd_reg_fat));
                  else
                      var.tTabela(var.nIndex).erro := pkg_rmi_traducao.extrair_pkg_msg('MSG_156', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Para abrir a conta é necessário excluir a franquia paciente');
                  end if;

                    Elsif  pReg_Fat.Tp_Desconto = 'C'  then -->> Franquia Convênio
                     vretorno := 'existe';
                  var.nIndex := var.nIndex + 1;

                  if vFranquiasDesc.cd_reg_fat <>  pReg_Fat.cd_reg_Fat then
                      var.tTabela(var.nIndex).erro := pkg_rmi_traducao.extrair_pkg_msg('MSG_157', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Para abrir a conta é necessário excluir a franquia Convênio da conta : %s', arg_list(vFranquiasDesc.cd_reg_fat));
                  else
                      var.tTabela(var.nIndex).erro := pkg_rmi_traducao.extrair_pkg_msg('MSG_158', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Para abrir a conta é necessário excluir a franquia Convênio');
                  end if;

                    Elsif  pReg_Fat.Tp_Desconto = 'D'  then -->> Desconto
                     vretorno := 'existe';
                  var.nIndex := var.nIndex + 1;

                  if vFranquiasDesc.cd_reg_fat <>  pReg_Fat.cd_reg_Fat then
                      var.tTabela(var.nIndex).erro := pkg_rmi_traducao.extrair_pkg_msg('MSG_159', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Para abrir a conta é necessário excluir o Desconto da conta: %s',arg_list(vFranquiasDesc.cd_reg_fat));
                  else
                      var.tTabela(var.nIndex).erro := pkg_rmi_traducao.extrair_pkg_msg('MSG_160', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Para abrir a conta é necessário excluir o Desconto');
                  end if;
                    end if;
                end if;
            end loop;

    end if;
    return vRetorno;
END;

FUNCTION F_CHK_FRANQUIA_DESCONTO (in_params in Clob, out_params out Clob) RETURN varchar IS
    xml PKG_XML.XmlContext;
    bExclusao boolean;
    preg_fat REG_FATRec;
    var VARRec;
    result varchar(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.TP_DESCONTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.TP_DESCONTO');
        var.nIndex := PKG_XML.GetNumber(xml, 'VAR.NINDEX');
        var.tTabela := ConvertTTableToOraTable(PKG_XML.GetObject(xml, 'VAR.TTABELA'));
        bExclusao:= PKG_XML.Getboolean(xml, 'bExclusao');

        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_CHK_FRANQUIA_DESCONTO_E(xml) THEN
                result:= F_CHK_FRANQUIA_DESCONTO(xml, pREG_FAT, VAR, bExclusao);
                Pkg_ffcv_M_LAN_HOS_C.F_CHK_FRANQUIA_DESCONTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML

        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.TP_DESCONTO', pREG_FAT.TP_DESCONTO);
        PKG_XML.SetNumber(xml, 'VAR.NINDEX', var.nIndex);
        PKG_XML.SetObject(xml, 'VAR.TTABELA', ConvertTTableToXml(var.tTabela));

        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_sn_verifica_preco_rel</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	FUNCTION F_SN_VERIFICA_PRECO_REL (xml IN OUT NOCOPY PKG_XML.XmlContext,pnCdProFat IN val_pro_relacionado.cd_pro_fat%type, pnCdProFatPai IN val_pro_relacionado.cd_pro_fat_pai%type,
	                                  pnCdRegra IN val_pro_relacionado.cd_regra%type, pdDtReferencia IN val_pro_relacionado.dt_vigencia%type) RETURN BOOLEAN IS
CURSOR cSnExisteProcRelTpValor (nCdProFat IN val_pro_relacionado.cd_pro_fat%type, nCdProFatPai IN val_pro_relacionado.cd_pro_fat_pai%type, nCdRegra IN val_pro_relacionado.cd_regra%type,
                                dDtReferencia IN val_pro_relacionado.dt_vigencia%type) IS
    SELECT 'S' Existe
      FROM DBAMV.val_pro_relacionado rela
     WHERE rela.cd_pro_fat_pai = nCdProFatPai
       AND rela.cd_pro_fat = nCdProFat
       AND Nvl(rela.tp_valor, 'X') <> 'P'
       AND rela.tp_lancamento <> 'A'
       AND ( rela.tp_atend_externo = 'S' OR rela.tp_atend_internacao = 'S')
       AND rela.cd_regra = nCdRegra
       AND rela.dt_vigencia IN (SELECT Max (vpr.dt_vigencia)
                                  FROM DBAMV.val_pro_relacionado vpr
                                 WHERE vpr.dt_vigencia <= dDtReferencia
                                   AND vpr.cd_regra = rela.cd_regra
                                   AND vpr.cd_pro_fat_pai = rela.cd_pro_fat_pai
                                   AND vpr.cd_pro_fat = rela.cd_pro_fat);
  vSnExiste VARCHAR2(1) := 'N';
  bRetorno  BOOLEAN := FALSE;
BEGIN
    OPEN  cSnExisteProcRelTpValor (pnCdProFat, pnCdProFatPai, pnCdRegra, pdDtReferencia);
    FETCH cSnExisteProcRelTpValor INTO vSnExiste;
    CLOSE cSnExisteProcRelTpValor;

    IF Nvl(vSnExiste, 'N') = 'S' THEN
        bRetorno := TRUE;
    ELSE
        bRetorno := FALSE;
    END IF;

    RETURN bRetorno;
END;

FUNCTION F_SN_VERIFICA_PRECO_REL (in_params in Clob, out_params out Clob) RETURN BOOLEAN IS
    xml PKG_XML.XmlContext;
    pnCdProFat VARCHAR2(4000);
    pnCdProFatPai VARCHAR2(4000);
    pnCdRegra NUMBER;
    pdDtReferencia DATE;
    result BOOLEAN;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pnCdProFat:= PKG_XML.GetVARCHAR2(xml, 'pnCdProFat');
        pnCdProFatPai:= PKG_XML.GetVARCHAR2(xml, 'pnCdProFatPai');
        pnCdRegra:= PKG_XML.GetNUMBER(xml, 'pnCdRegra');
        pdDtReferencia:= PKG_XML.GetDATE(xml, 'pdDtReferencia');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_SN_VERIFICA_PRECO_REL_E(xml) THEN
                result:= F_SN_VERIFICA_PRECO_REL(xml, pnCdProFat, pnCdProFatPai, pnCdRegra, pdDtReferencia);
                Pkg_ffcv_M_LAN_HOS_C.F_SN_VERIFICA_PRECO_REL_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_descricao_empresa</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_DESCRICAO_EMPRESA (xml IN OUT NOCOPY PKG_XML.XmlContext,pnCdRegFat in number, pnCdMultiEmpresa out number) RETURN varchar2 IS
cursor cEmpresa(pCdRegFat in number) is
        select multi_empresas.ds_multi_empresa,
           multi_empresas.cd_multi_empresa
        from DBAMV.reg_fat
           , DBAMV.multi_empresas
       where reg_fat.cd_multi_empresa = multi_empresas.cd_multi_empresa
          and reg_fat.cd_reg_fat = pCdRegFat;

  rEmpresa        cEmpresa%rowtype;
  vRetorno        varchar(2000);
  nCdMultiEmpresa number;
BEGIN
    vRetorno        := null;
    nCdMultiEmpresa := to_number(null);

  open  cEmpresa(pnCdRegFat);
  fetch cEmpresa into rEmpresa;
  close cEmpresa;

  vRetorno        := rEmpresa.ds_multi_empresa;
  nCdMultiEmpresa := rEmpresa.cd_multi_empresa;

  return vRetorno;
END;

FUNCTION F_DESCRICAO_EMPRESA (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    pnCdRegFat number;
    pnCdMultiEmpresa number;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pnCdRegFat:= PKG_XML.Getnumber(xml, 'pnCdRegFat');
        pnCdMultiEmpresa:= PKG_XML.Getnumber(xml, 'pnCdMultiEmpresa');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_DESCRICAO_EMPRESA_E(xml) THEN
                result:= F_DESCRICAO_EMPRESA(xml, pnCdRegFat, pnCdMultiEmpresa);
                Pkg_ffcv_M_LAN_HOS_C.F_DESCRICAO_EMPRESA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.Setnumber(xml, 'pnCdMultiEmpresa', pnCdMultiEmpresa);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_retorna_sequencia_reg_fat</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_RETORNA_SEQUENCIA_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext) RETURN reg_fat.cd_reg_fat%type IS
cursor c is
    select seq_reg_fat.nextval
      from sys.dual;
  bLocalizouRegistro boolean;
  vRetorno reg_fat.cd_reg_fat%type;
begin
    --
  vRetorno := NULL;

  open c;
  fetch c into vRetorno;
  bLocalizouRegistro := c%found;
  close c;

  if not bLocalizouRegistro then
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_58)
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_59)
    PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_58', 'PKG_FFCV_M_LAN_HOS', 'Erro'),
		  pkg_rmi_traducao.extrair_pkg_msg('MSG_59', 'PKG_FFCV_M_LAN_HOS',
			  'Erro..: não foi possível obter a préxima numeração de conta da sequência de controle.: Entrar em contato com o setor de informática do hospital para que a sequência seja verificada.', arg_list(chr(10))), true);
  end if;

  return vRetorno;

exception
  when others then
    RAISE;
end;

FUNCTION F_RETORNA_SEQUENCIA_REG_FAT (in_params in Clob, out_params out Clob) RETURN reg_fat.cd_reg_fat%type IS
    xml PKG_XML.XmlContext;
    result reg_fat.cd_reg_fat%type;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_RETORNA_SEQUENCIA_REG_FAT_E(xml) THEN
                result:= F_RETORNA_SEQUENCIA_REG_FAT(xml);
                Pkg_ffcv_M_LAN_HOS_C.F_RETORNA_SEQUENCIA_REG_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_vl_itens</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_VL_ITENS (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdRegFat in number, pnCdMultiEmpresa in number) RETURN number IS
BEGIN
  return nvl(M_PKG_FFCV_ITEM_CONTA.F_RETORNA_VL_ITENS(xml, pnCdRegFat
                                                    , null
                                                    , 'H'
                                                    , pnCdMultiEmpresa
                                                    , formParams.P_MIG_CD_USUARIO
                                                    , false
                                                    , false), 0);
END;

FUNCTION F_VL_ITENS (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    pnCdRegFat number;
    pnCdMultiEmpresa number;
    formParams FormParamsRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pnCdRegFat:= PKG_XML.Getnumber(xml, 'pnCdRegFat');
        pnCdMultiEmpresa:= PKG_XML.Getnumber(xml, 'pnCdMultiEmpresa');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_VL_ITENS_E(xml) THEN
                result:= F_VL_ITENS(xml, formParams, pnCdRegFat, pnCdMultiEmpresa);
                Pkg_ffcv_M_LAN_HOS_C.F_VL_ITENS_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_retorna_sequencia_aud_cont</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_RETORNA_SEQUENCIA_AUD_CONT (xml IN OUT NOCOPY PKG_XML.XmlContext) RETURN auditoria_conta.cd_auditoria_conta%type IS
CURSOR C IS
    SELECT SEQ_AUDITORIA_CONTA.NEXTVAL
      FROM SYS.DUAL;
  nRetorno auditoria_conta.cd_auditoria_conta%type;
BEGIN
  OPEN C;
  FETCH C INTO nRetorno;
  IF C%NOTFOUND THEN
       CLOSE C;
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_60)
    PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
		  pkg_rmi_traducao.extrair_pkg_msg('MSG_60', 'PKG_FFCV_M_LAN_HOS',
			  'Atenção..: não foi possível obter a préxima sequência de auditoria conta.: Entar em contato com o setor de informática do hospital para que a sequência seja corrigida.', arg_list(chr(10))), true);
  END IF;
  CLOSE C;

  return nRetorno;
END;

FUNCTION F_RETORNA_SEQUENCIA_AUD_CONT (in_params in Clob, out_params out Clob) RETURN auditoria_conta.cd_auditoria_conta%type IS
    xml PKG_XML.XmlContext;
    result auditoria_conta.cd_auditoria_conta%type;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_RETORNA_SEQUENCIA_AUD_CONT_E(xml) THEN
                result:= F_RETORNA_SEQUENCIA_AUD_CONT(xml);
                Pkg_ffcv_M_LAN_HOS_C.F_RETORNA_SEQUENCIA_AUD_CONT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_checa_fornecedor</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_CHECA_FORNECEDOR (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdForncedor in number, pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) RETURN varchar2 IS
vRetorno varchar2(2000);
BEGIN
  vRetorno := null;
  vRetorno := M_PKG_FNFI_FORNECEDOR.F_RETORNA_DESCRICAO(xml, pnCdForncedor
                                                       ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                       ,formParams.P_MIG_CD_USUARIO
                                                       ,pbSnLevantaExecessao
                                                       ,pbSnMostraMensagem);

  return vRetorno;
END;

FUNCTION F_CHECA_FORNECEDOR (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    pnCdForncedor number;
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    formParams FormParamsRec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pnCdForncedor:= PKG_XML.Getnumber(xml, 'pnCdForncedor');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_CHECA_FORNECEDOR_E(xml) THEN
                result:= F_CHECA_FORNECEDOR(xml, formParams, pnCdForncedor, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.F_CHECA_FORNECEDOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_checa_prestador</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	FUNCTION F_CHECA_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec,pnCdPrestador in number,
	                            pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean, pvOrigem in varchar2) RETURN varchar2 IS
vNmPrestador   varchar2(2000);
  vSnCirurgiao   varchar2(2000);
  vSnAuxiliar    varchar2(2000);
  vSnAnestesista varchar2(2000);
  vSmOutros      varchar2(2000);
  vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
BEGIN
    vNmPrestador := null;
  --
  -- Chamada da Procedure
  M_PKG_AMDC_PRESTADOR.P_RETORNA_DADOS(xml, pnCdPrestador
                                                             ,null
                                                               ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                               ,formParams.P_MIG_CD_USUARIO
                                                               ,pbSnLevantaExecessao
                                                               ,pbSnMostraMensagem
                                                               ,vLst_Retorno);
  --
  vLst_Local := pkg_parametro.fn_recupera_lista_parametros(vLst_Retorno);
  --
  -- Recuperao dos parametros retornados pela Procedure
  pkg_parametro.pr_recupera_parametro(vLst_Local,'NM_PRESTADOR'   , vNmPrestador  , false);
  pkg_parametro.pr_recupera_parametro(vLst_Local,'SN_CIRURGIAO'   , vSnCirurgiao  , false);
  pkg_parametro.pr_recupera_parametro(vLst_Local,'SN_AUXILIAR'    , vSnAuxiliar   , false);
  pkg_parametro.pr_recupera_parametro(vLst_Local,'SN_ANESTESISTA' , vSnAnestesista, false);
  pkg_parametro.pr_recupera_parametro(vLst_Local,'SN_OUTROS'      , vSmOutros     , false);
  --
  -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
  pkg_parametro.pr_limpar_lista_parametros(vLst_Local);
  --
  if pvOrigem = 'ITLAN_MED_REL' then
        pITLAN_MED_REL.DSP_SN_CIRURGIAO   := vSnCirurgiao;
        pITLAN_MED_REL.DSP_SN_AUXILIAR    := vSnAuxiliar;
        pITLAN_MED_REL.DSP_SN_ANESTESISTA := vSnAnestesista;
        pITLAN_MED_REL.DSP_SN_OUTROS      := vSmOutros;
  elsif pvOrigem = 'ITLAN_MED2' then
    pITLAN_MED2.DSP_SN_CIRURGIAO   := vSnCirurgiao;
    pITLAN_MED2.DSP_SN_AUXILIAR    := vSnAuxiliar;
    pITLAN_MED2.DSP_SN_ANESTESISTA := vSnAnestesista;
    pITLAN_MED2.DSP_SN_OUTROS      := vSmOutros;
  end if;
  --
  Return vNmPrestador;
  --
END;

FUNCTION F_CHECA_PRESTADOR (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    pnCdPrestador number;
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    pvOrigem varchar2(4000);
    pitlan_med_rel ITLAN_MED_RELRec;
    pitlan_med2 ITLAN_MED2Rec;
    formParams FormParamsRec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITLAN_MED_REL.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO');
        pITLAN_MED_REL.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR');
        pITLAN_MED_REL.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA');
        pITLAN_MED_REL.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS');
        pITLAN_MED2.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO');
        pITLAN_MED2.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR');
        pITLAN_MED2.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA');
        pITLAN_MED2.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pnCdPrestador:= PKG_XML.Getnumber(xml, 'pnCdPrestador');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        pvOrigem:= PKG_XML.Getvarchar2(xml, 'pvOrigem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_CHECA_PRESTADOR_E(xml) THEN
                result:= F_CHECA_PRESTADOR(xml, pITLAN_MED_REL, pITLAN_MED2, formParams, pnCdPrestador, pbSnLevantaExecessao, pbSnMostraMensagem, pvOrigem);
                Pkg_ffcv_M_LAN_HOS_C.F_CHECA_PRESTADOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO', pITLAN_MED_REL.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR', pITLAN_MED_REL.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA', pITLAN_MED_REL.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS', pITLAN_MED_REL.DSP_SN_OUTROS);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO', pITLAN_MED2.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR', pITLAN_MED2.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA', pITLAN_MED2.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS', pITLAN_MED2.DSP_SN_OUTROS);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_checa_ati_med</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_CHECA_ATI_MED (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec,pnCdAtiMed in varchar2,
	                          pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean, pvOrigem in varchar2) RETURN varchar2 IS
vDsAtiMed         varchar2(2000);
  nVlParcentualPago number;
  vTpFuncao         varchar2(2000);
  vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
BEGIN
    vDsAtiMed := null;
  --
  -- Chamada da Procedure
  M_PKG_AMDC_ATI_MED.P_RETORNA_DADOS(xml, pnCdAtiMed
                                                          ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                            ,formParams.P_MIG_CD_USUARIO
                                                            ,pbSnLevantaExecessao
                                                            ,pbSnMostraMensagem
                                                            ,vLst_Retorno);
  --
  vLst_Local := pkg_parametro.fn_recupera_lista_parametros(vLst_Retorno);
  --
  -- Recuperao dos parametros retornados pela Procedure
  pkg_parametro.pr_recupera_parametro(vLst_Local,'DS_ATI_MED'        , vDsAtiMed        , false);
  pkg_parametro.pr_recupera_parametro(vLst_Local,'VL_PERCENTUAL_PAGO', nVlParcentualPago, false);
  pkg_parametro.pr_recupera_parametro(vLst_Local,'TP_FUNCAO'         , vTpFuncao        , false);
  --
  -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
  pkg_parametro.pr_limpar_lista_parametros(vLst_Local);
  --
  if pvOrigem = 'ITLAN_MED_REL' then
    pITLAN_MED_REL.DSP_VL_PERCENTUAL_PAGO := nVlParcentualPago;
    pITLAN_MED_REL.DSP_TP_FUNCAO          := vTpFuncao;
  elsif pvOrigem = 'ITLAN_MED2' then
    pITLAN_MED2.DSP_VL_PERCENTUAL_PAGO    := nVlParcentualPago;
    pITLAN_MED2.DSP_TP_FUNCAO                := vTpFuncao;
  end if;
  --
  Return vDsAtiMed;
  --
END;

FUNCTION F_CHECA_ATI_MED (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    pnCdAtiMed varchar2(4000);
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    pvOrigem varchar2(4000);
    pitlan_med_rel ITLAN_MED_RELRec;
    pitlan_med2 ITLAN_MED2Rec;
    formParams FormParamsRec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITLAN_MED_REL.DSP_VL_PERCENTUAL_PAGO:= PKG_XML.GetNUMBER(xml, 'ITLAN_MED_REL.DSP_VL_PERCENTUAL_PAGO');
        pITLAN_MED_REL.DSP_TP_FUNCAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_TP_FUNCAO');
        pITLAN_MED2.DSP_VL_PERCENTUAL_PAGO:= PKG_XML.GetNUMBER(xml, 'ITLAN_MED2.DSP_VL_PERCENTUAL_PAGO');
        pITLAN_MED2.DSP_TP_FUNCAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_TP_FUNCAO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pnCdAtiMed:= PKG_XML.Getvarchar2(xml, 'pnCdAtiMed');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        pvOrigem:= PKG_XML.Getvarchar2(xml, 'pvOrigem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_CHECA_ATI_MED_E(xml) THEN
                result:= F_CHECA_ATI_MED(xml, pITLAN_MED_REL, pITLAN_MED2, formParams, pnCdAtiMed, pbSnLevantaExecessao, pbSnMostraMensagem, pvOrigem);
                Pkg_ffcv_M_LAN_HOS_C.F_CHECA_ATI_MED_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITLAN_MED_REL.DSP_VL_PERCENTUAL_PAGO', pITLAN_MED_REL.DSP_VL_PERCENTUAL_PAGO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_TP_FUNCAO', pITLAN_MED_REL.DSP_TP_FUNCAO);
        PKG_XML.SetNUMBER(xml, 'ITLAN_MED2.DSP_VL_PERCENTUAL_PAGO', pITLAN_MED2.DSP_VL_PERCENTUAL_PAGO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_TP_FUNCAO', pITLAN_MED2.DSP_TP_FUNCAO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_qtd_auditoria</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_QTD_AUDITORIA (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pCD_REG_FAT          in number,
                             pTp_Motivo_Auditoria in varchar2 default null) RETURN number IS
BEGIN
  return M_PKG_FFCV_AUDITORIA_CONTA.F_QTD_AUDITORIA_POR_REG_F(xml, pCD_REG_FAT
                                                            , pTp_Motivo_Auditoria
                                                                                          , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                          , formParams.P_MIG_CD_USUARIO
                                                                                          , FALSE
                                                                                          , FALSE);
END;

FUNCTION F_QTD_AUDITORIA (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    pCD_REG_FAT number;
    pTp_Motivo_Auditoria varchar2(4000);
    formParams FormParamsRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pCD_REG_FAT:= PKG_XML.Getnumber(xml, 'pCD_REG_FAT');
        pTp_Motivo_Auditoria:= PKG_XML.Getvarchar2(xml, 'pTp_Motivo_Auditoria');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_QTD_AUDITORIA_E(xml) THEN
                result:= F_QTD_AUDITORIA(xml, formParams, pCD_REG_FAT, pTp_Motivo_Auditoria);
                Pkg_ffcv_M_LAN_HOS_C.F_QTD_AUDITORIA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_vl_itens_por_pro_fat</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_VL_ITENS_POR_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdRegFat in number, pvCdProFat in VARCHAR2, pvCdLancamento IN number) RETURN number IS

    cursor cValorItensHospLanc is
      select sum(nvl(nvl(itlan_med.vl_liquido, itreg_fat.vl_total_conta), 0))
        from dbamv.itreg_fat
           , dbamv.itlan_med
       where itreg_fat.cd_pro_fat = pvCdProFat
         and itreg_fat.cd_reg_fat = pnCdRegFat
         and itreg_fat.cd_lancamento = pvCdLancamento
         and itreg_fat.cd_reg_fat = itlan_med.cd_reg_fat(+)
         and itreg_fat.cd_lancamento = itlan_med.cd_lancamento(+)
         and nvl(itreg_fat.sn_pertence_pacote, 'N') = 'N'
         and nvl(itreg_fat.sn_paciente_paga,'N') = 'N'
         and nvl(nvl(itlan_med.tp_pagamento, itreg_fat.tp_pagamento), 'P') <> 'C';

    cursor cValorItensHosp is
      select sum(nvl(nvl(itlan_med.vl_liquido, itreg_fat.vl_total_conta), 0))
        from dbamv.itreg_fat
           , dbamv.itlan_med
       where itreg_fat.cd_pro_fat = pvCdProFat
         and itreg_fat.cd_reg_fat = pnCdRegFat
       --  and itreg_fat.cd_lancamento = pvCdLancamento
         and itreg_fat.cd_reg_fat = itlan_med.cd_reg_fat(+)
         and itreg_fat.cd_lancamento = itlan_med.cd_lancamento(+)
         and nvl(itreg_fat.sn_pertence_pacote, 'N') = 'N'
         and nvl(itreg_fat.sn_paciente_paga,'N') = 'N'
         and nvl(nvl(itlan_med.tp_pagamento, itreg_fat.tp_pagamento), 'P') <> 'C';

    CURSOR verificaDesconto IS
      SELECT nvl(sn_desconto_por_lancamento, 'N')
        FROM dbamv.config_ffcv
       WHERE cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;

    variavel VARCHAR2(1);
    nRetorno NUMBER := 0;
BEGIN
  variavel   := NULL;
   OPEN verificaDesconto;
   FETCH verificaDesconto INTO variavel;
   CLOSE verificaDesconto;


  nRetorno:= 0;
   IF Nvl(variavel, 'N') = 'S' then
    open  cValorItensHospLanc;
    fetch cValorItensHospLanc into nRetorno;
    close cValorItensHospLanc;
   ELSE
    open  cValorItensHosp;
    fetch cValorItensHosp into nRetorno;
    close cValorItensHosp;
   END IF;


  return nRetorno;
END;

FUNCTION F_VL_ITENS_POR_PRO_FAT (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    pnCdRegFat number;
    pvCdProFat varchar2(4000);
    pvCdLancamento NUMBER;
    formParams FormParamsRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pnCdRegFat:= PKG_XML.Getnumber(xml, 'pnCdRegFat');
        pvCdProFat:= PKG_XML.Getvarchar2(xml, 'pvCdProFat');
        pvCdLancamento:= PKG_XML.Getvarchar2(xml, 'pvCdLancamento');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_VL_ITENS_POR_PRO_FAT_E(xml) THEN
                result:= F_VL_ITENS_POR_PRO_FAT(xml, formParams, pnCdRegFat, pvCdProFat, pvCdLancamento);
                Pkg_ffcv_M_LAN_HOS_C.F_VL_ITENS_POR_PRO_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_vl_itens_por_gru_pro</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_VL_ITENS_POR_GRU_PRO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdRegFat in number, pnCdGruPro in number) RETURN number IS
BEGIN
  return M_PKG_FFCV_ITEM_CONTA.F_VL_LANCAMENTO_POR_GRUPO(xml, pnCdRegFat
                                                            ,NULL
                                                            ,'H'
                                                            ,pnCdGruPro
                                                            ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                            ,formParams.P_MIG_CD_USUARIO
                                                            ,false
                                                            ,false);
END;

FUNCTION F_VL_ITENS_POR_GRU_PRO (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    pnCdRegFat number;
    pnCdGruPro number;
    formParams FormParamsRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pnCdRegFat:= PKG_XML.Getnumber(xml, 'pnCdRegFat');
        pnCdGruPro:= PKG_XML.Getnumber(xml, 'pnCdGruPro');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_VL_ITENS_POR_GRU_PRO_E(xml) THEN
                result:= F_VL_ITENS_POR_GRU_PRO(xml, formParams, pnCdRegFat, pnCdGruPro);
                Pkg_ffcv_M_LAN_HOS_C.F_VL_ITENS_POR_GRU_PRO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_vl_conta</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_VL_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdRegFat in number, pnCdMultiEmpresa in number) RETURN number IS
BEGIN
  return nvl( M_PKG_FFCV_CONTA.F_RETORNA_VL_CONTA(xml, pnCdRegFat                    -- Cd_conta
                                                 , null                         -- Cd_atendimento
                                                 , 'H'                          -- TP_conta
                                                 , pnCdMultiEmpresa             -- Empresa
                                                 , formParams.P_MIG_CD_USUARIO  -- Usuario
                                                 , false                        -- Levanta exceção
                                                 , false), 0);                  -- Mostra mensagem
END;

FUNCTION F_VL_CONTA (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    pnCdRegFat number;
    pnCdMultiEmpresa number;
    formParams FormParamsRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pnCdRegFat:= PKG_XML.Getnumber(xml, 'pnCdRegFat');
        pnCdMultiEmpresa:= PKG_XML.Getnumber(xml, 'pnCdMultiEmpresa');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_VL_CONTA_E(xml) THEN
                result:= F_VL_CONTA(xml, formParams, pnCdRegFat, pnCdMultiEmpresa);
                Pkg_ffcv_M_LAN_HOS_C.F_VL_CONTA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_tp_atendimento</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_TP_ATENDIMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,nCdAtendimento in number) RETURN varchar2 IS
BEGIN
  return M_PKG_PAEU_ATENDIME.F_RETORNA_DESCRICAO(xml, nCdAtendimento
                                                       , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                         , formParams.P_MIG_CD_USUARIO
                                                                                         , TRUE
                                                                                         , TRUE);
END;

FUNCTION F_TP_ATENDIMENTO (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdAtendimento number;
    formParams FormParamsRec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        nCdAtendimento:= PKG_XML.Getnumber(xml, 'nCdAtendimento');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_TP_ATENDIMENTO_E(xml) THEN
                result:= F_TP_ATENDIMENTO(xml, formParams, nCdAtendimento);
                Pkg_ffcv_M_LAN_HOS_C.F_TP_ATENDIMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_validar_registro</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_VALIDAR_REGISTRO (xml IN OUT NOCOPY PKG_XML.XmlContext,FSV_RECORD_STATUS IN OUT NOCOPY varchar2) RETURN boolean IS
BEGIN
  If nvl( FSV_RECORD_STATUS, 'X') <> 'QUERY' THEN
      return true;
  else
      return false;
  end if;
END;

FUNCTION F_VALIDAR_REGISTRO (in_params in Clob, out_params out Clob) RETURN boolean IS
    xml PKG_XML.XmlContext;
    FSV_RECORD_STATUS VARCHAR2(4000);
    result boolean;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_VALIDAR_REGISTRO_E(xml) THEN
                result:= F_VALIDAR_REGISTRO(xml, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.F_VALIDAR_REGISTRO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_mvto_estoque</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_MVTO_ESTOQUE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
           	RETURN varchar2 IS
Cursor C_MvtoEstoque is
    Select itconsumo_paciente.cd_uni_pro,
          itconsumo_paciente.qt_consumo,
          itconsumo_paciente.cd_produto
      From DBAMV.itconsumo_paciente
    Where itconsumo_paciente.cd_consumo_paciente = nCdMvtoFalha
      and itconsumo_paciente.cd_itconsumo_paciente = nCdItemFalha ;

  cDummy VarChar2( 1 ) ;
  vqtde         varchar2(1) := null;
Begin
  vqtde := null;

  For V_Mvto in C_MvtoEstoque loop
    vqtde := '1';
    cDummy := pack_lanca_ffcv.Lanca_MGES_Consumo_FFCV( V_Mvto.cd_produto,
                                                            nCdMvtoFalha,
                                                            V_Mvto.cd_uni_pro,
                                                            V_Mvto.qt_consumo,
                                                            Null,
                                                            'I',
                                                            nCdItemFalha ) ;
  end loop ;

  if vqtde is null then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  end if;

  return vqtde;
end ;

FUNCTION F_LANCA_MVTO_ESTOQUE (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_MVTO_ESTOQUE_E(xml) THEN
                result:= F_LANCA_MVTO_ESTOQUE(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_MVTO_ESTOQUE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_prescricao</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_PRESCRICAO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
	                RETURN varchar2 IS
Cursor C_MvtoPresc is
    Select itpre_med.cd_prestador,
           itpre_med.cd_set_exa,
           itpre_med.qt_itpre_med,
           itpre_med.cd_tip_presc,
           pre_med.cd_atendimento,
           pre_med.dt_pre_med,
           pre_med.hr_pre_med,
           pre_med.cd_unid_int,
           pre_med.cd_prestador prest_med
      From DBAMV.itpre_med,
           DBAMV.pre_med
     Where itpre_med.cd_pre_med   = nCdMvtoFalha
       and itpre_med.cd_itpre_med = nCdItemFalha
       and itpre_med.cd_pre_med   = pre_med.cd_pre_med ;

  vqtde varchar2(1) := null;
Begin

  vqtde := null;
  For V_Mvto in C_MvtoPresc loop

    vqtde := '1';
    pack_lanca_ffcv.Lanca_PAGU_FFCV( ncdpremed            => nCdMvtoFalha,
                                           ncddevpre            => null,
                                           ncdtippresc        => V_Mvto.cd_tip_presc,
                                           ncdprestador   => V_Mvto.cd_prestador,
                                           ncdsetexa      => V_Mvto.cd_set_exa,
                                           nqtnew         => V_Mvto.qt_itpre_med,
                                           nqtold         => Null,
                                           caction        => 'I',
                                           ncditemmvto    => nCdItemFalha,
                                           ncd_setor      => null,
                                           vdh_cancelado  => SYSDATE,
                                           pncdatendimento => V_Mvto.cd_atendimento,
                                           pddtpremed      => V_Mvto.dt_pre_med,
                                           pdhrpremed      => V_Mvto.hr_pre_med,
                                           pncdunidint     => V_Mvto.cd_unid_int,
                                           pncdprestadorpresc => V_Mvto.prest_med ) ;

  end loop ;

  if vqtde is null then
      Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  end if;

  return vqtde;
end;

FUNCTION F_LANCA_PRESCRICAO (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_PRESCRICAO_E(xml) THEN
                result:= F_LANCA_PRESCRICAO(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_PRESCRICAO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_componente</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_COMPONENTE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
	           RETURN varchar2 IS
Cursor C_MvtoComp is
    Select citpre_med.cd_itpre_med,
            citpre_med.cd_tip_presc,
            citpre_med.qt_componente,
            pre_med.cd_atendimento,
            pre_med.dt_pre_med,
            pre_med.hr_pre_med,
            pre_med.cd_unid_int,
            pre_med.cd_prestador prest_med,
            pre_med.cd_setor
      From DBAMV.citpre_med, DBAMV.pre_med, DBAMV.itpre_med
      Where citpre_med.cd_itpre_med = itpre_med.cd_itpre_med
        and itpre_med.cd_pre_med    = pre_med.cd_pre_med
        and citpre_med.cd_itpre_med = nCdMvtoFalha
        and citpre_med.cd_tip_presc = nCdItemFalha ;

  vqtde varchar2(1) := null;
Begin

  vqtde := null;
  For V_Mvto in C_MvtoComp loop

    vqtde := '1';
    pack_lanca_ffcv.Lanca_Componente_FFCV( ncditpremed            => nCdMvtoFalha,
                                                ncdtippresc     => nCdItemFalha,
                                                nqtnew                    => V_Mvto.qt_componente,
                                                nqtold          => Null,
                                                caction                    => 'I',
                                                pncdatendimento    => V_Mvto.cd_atendimento,
                                                pddtpremed      => V_Mvto.dt_pre_med,
                                                pdhrpremed      => V_Mvto.hr_pre_med,
                                                pncdunidint     => V_Mvto.cd_unid_int,
                                                pncdprestadorpresc => V_Mvto.prest_med,
                                                pncdsetor       => V_Mvto.cd_setor ) ;
  end loop ;

  if vqtde is null then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  end if;

  return vqtde;
end ;

FUNCTION F_LANCA_COMPONENTE (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_COMPONENTE_E(xml) THEN
                result:= F_LANCA_COMPONENTE(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_COMPONENTE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_imagem</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_IMAGEM (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec,nCdMVtoFalha in number,
	                         nCdItemFalha in number) RETURN varchar2 IS
Cursor C_MvtoImagem is
    Select itped_rx.dt_realizado,
            itped_Rx.nr_faturado,
            itped_Rx.Cd_Prestador,
            itped_rx.cd_exa_rx,
            itped_rx.VL_PERC_FATUR_EXA
      From DBAMV.itped_rx
      Where itped_rx.cd_ped_rx = nCdMvtoFalha
        and itped_rx.cd_itped_rx = nCdItemFalha ;

    Cursor C_Ped is
    Select to_date(to_char(ped_rx.dt_pedido,'DD/MM/YYYY')||' '||to_char(ped_rx.hr_pedido,'HH24:MI'),'DD/MM/YYYY HH24:MI') dt_pedido
      From DBAMV.ped_rx
      Where ped_rx.cd_ped_rx = nCdMvtoFalha;

  dDtPed  Date ;
  vqtde   varchar2(1) := null;
Begin

  if   formParams.P_MIG_SN_PSDI_PEDIDO = 'S' then
      Open C_Ped ;
      Fetch C_Ped into dDtPed ;
      Close C_Ped ;
  else
      dDtPed := null;
  end if;

  vqtde := null;
  For V_Mvto in C_MvtoImagem loop
    vqtde := '1';
    pack_lanca_ffcv.Lanca_PSDI_FFCV( ncdpedrx      => nCdMvtoFalha,
                                            ncditpedrx    => nCdItemFalha,
                                            ncdexarx      => V_mvto.cd_exa_rx,
                                            ddtrealiznew  => nvl(dDtPed,V_Mvto.dt_realizado),
                                            ddtrealizold  => Null,
                                            nrfaturado    => nvl(V_Mvto.nr_faturado,1),
                                            nrcdprestador => V_Mvto.Cd_Prestador,
                                            pcfaturado    => V_Mvto.VL_PERC_FATUR_EXA ) ;
  end loop ;

  if vqtde is null then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  end if;

  return vqtde;
end ;

FUNCTION F_LANCA_IMAGEM (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    formParams FormParamsRec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        formParams.P_MIG_SN_PSDI_PEDIDO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSDI_PEDIDO');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_IMAGEM_E(xml) THEN
                result:= F_LANCA_IMAGEM(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, formParams, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_IMAGEM_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSDI_PEDIDO', formParams.P_MIG_SN_PSDI_PEDIDO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_sadt</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_SADT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec,nCdMVtoFalha in number,
	                       nCdItemFalha in number) RETURN varchar2 IS
Cursor C_MvtoSADT is
    Select decode(itped_lab.dt_laudo,null,null,to_date(to_char(itped_lab.dt_laudo,'DD/MM/YYYY')||' '||to_char(itped_lab.hr_laudo,'HH24:MI'),'DD/MM/YYYY HH24:MI')) dt_laudo,
            itped_lab.cd_exa_lab,
            itped_lab.cd_itped_lab,
            itped_lab.cd_set_exa,
            itped_lab.cd_medico_exec
      From DBAMV.itped_lab
      Where itped_lab.cd_ped_lab = nCdMvtoFalha
        and itped_lab.cd_itped_lab = nCdItemFalha ;

  Cursor C_Ped is
    Select to_date(to_char(ped_lab.dt_pedido,'DD/MM/YYYY')||' '||to_char(ped_lab.hr_ped_lab,'HH24:MI'),'DD/MM/YYYY HH24:MI') dt_pedido
      From DBAMV.ped_lab
      Where ped_lab.cd_ped_lab = nCdMvtoFalha;

  dDtPed       Date;
  vqtde        varchar2(1) := null;
Begin

  if  formParams.P_MIG_SN_PSSD_PEDIDO = 'S' then
      Open C_Ped ;
      Fetch C_Ped into dDtPed ;
      Close C_Ped ;
  else
      dDtPed := null;
  end if;

  vqtde := null;
  For V_Mvto in C_MvtoSADT loop

    vqtde := '1';

    pack_lanca_ffcv.Lanca_PSSD_FFCV( ncdpedlab     => nCdMvtoFalha,
                                           ncdexalab     => V_Mvto.cd_exa_lab,
                                           ddtrealiznew  => nvl(dDtPed,V_Mvto.dt_laudo),
                                           ddtrealizold  => Null,
                                           ncditemmvto   => nCdItemFalha,
                                           nitsetexa     => V_mvto.cd_set_exa,
                                           nitmedexe     => v_mvto.cd_medico_exec) ;
  end loop ;

  if vqtde is null then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  end if;

  return vqtde;
end ;

FUNCTION F_LANCA_SADT (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    formParams FormParamsRec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        formParams.P_MIG_SN_PSSD_PEDIDO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSSD_PEDIDO');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_SADT_E(xml) THEN
                result:= F_LANCA_SADT(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, formParams, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_SADT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSSD_PEDIDO', formParams.P_MIG_SN_PSSD_PEDIDO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_nutricao</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_NUTRICAO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number) RETURN varchar2 IS
Cursor C_MvtoPSND is
    Select itmov_cardapio.qt_cardapio,
          itmov_cardapio.sn_consumo_extra,
          itmov_cardapio.cd_opcao
      From DBAMV.itmov_cardapio
    Where itmov_cardapio.cd_mov_cardapio = nCdMvtoFalha
      and itmov_cardapio.cd_itmov_cardapio = nCdItemFalha ;
  vqtde varchar2(1) := null;
Begin

  vqtde := null;
  For V_PSND in C_MvtoPSND loop

    vqtde := '1';
    pack_lanca_ffcv.Lanca_PSND_FFCV( ncdopcao        => V_PSND.cd_opcao,
                                          ncdmovcardapio  => nCdMvtoFalha,
                                          nqtmovnew       => V_PSND.qt_cardapio,
                                          nqtmovold       => Null,
                                          caction                    => 'I',
                                          ccobranca       => nvl(V_PSND.sn_consumo_extra,'S'),
                                          ncditemmvto     => nCdItemFalha ) ;
  end loop ;

  if vqtde is null then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  end if;

  return vqtde;
end ;

FUNCTION F_LANCA_NUTRICAO (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_NUTRICAO_E(xml) THEN
                result:= F_LANCA_NUTRICAO(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_NUTRICAO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_kit</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number) RETURN varchar2 IS
Cursor c_kit is
      select qt_kit
        from DBAMV.itmvto_kits
       where cd_mvto_estoque = nCdMvtoFalha
         and cd_formula = nCdItemFalha;

  Cursor c_KitProFat is
    Select cd_pro_fat,qt_padrao
      from DBAMV.kit_pro_fat
     Where cd_formula = nCdItemFalha;

  cTpAtend Varchar2(1);
  vqtde    varchar2(1) := null;
begin
    vqtde := null;

    for ck in c_kit loop
        for v_KitProFat in c_KitProFat loop
            vqtde := '1';
            cTpAtend := LANCA_FFCV_KIT_PRO_FAT( v_KitProFat.CD_PRO_FAT,
                                                     null,
                                                     nCdMvtoFalha,
                                                     ck.qt_kit * v_KitProFat.qt_padrao,
                                                     ck.qt_kit * v_KitProFat.qt_padrao,
                                                     'I',
                                                     nCdItemFalha );
        end loop;
    end loop;

    if vqtde is null then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
    end if;

    return vqtde;
end;

FUNCTION F_LANCA_KIT (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_KIT_E(xml) THEN
                result:= F_LANCA_KIT(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_KIT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_equipe_imagem</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_EQUIPE_IMAGEM (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
	                 RETURN varchar2 IS
cursor c_produtoKit is
      select cd_ati_med, tp_pagamento
        from DBAMV.itped_rx_equipe
       where cd_itped_rx = nCdMvtoFalha
         and cd_prestador = nCdItemFalha;
  vqtde varchar2(1) := null;
begin
  vqtde := null;

    for cprod in c_produtoKit loop
    vqtde := '1';
    lanca_ffcv_psdi_equipe( nCdMvtoFalha
                                 ,nCdItemFalha
                                 ,cprod.cd_ati_med
                                 ,cprod.tp_pagamento
                                 ,'I' );
  end loop;

  if vqtde is null then
      Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  end if;

  return vqtde;
end;

FUNCTION F_LANCA_EQUIPE_IMAGEM (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_EQUIPE_IMAGEM_E(xml) THEN
                result:= F_LANCA_EQUIPE_IMAGEM(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_EQUIPE_IMAGEM_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_produto_kit</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_PRODUTO_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number)
	               RETURN varchar2 IS
Cursor c_kit is
       select qt_kit
         from DBAMV.itmvto_kits
        where cd_mvto_estoque = nCdMvtoFalha
          and cd_formula = nCdItemFalha;

  Cursor c_produto is
    Select cd_produto, verif_cd_unid_Prod( cd_produto,  'R' ) cd_uni_pro
      From DBAMV.Formula
     Where cd_formula = nCdItemFalha;

  iCdProduto  Number;
  iCdUnidProd Number;
  cTpAtend    Varchar2(1);
  vqtde       varchar2(1) := null;
begin
  Open c_produto ;
  Fetch c_produto into iCdProduto, iCdUnidProd;
  Close c_produto ;

  vqtde := null;

  for ck in c_kit loop
    vqtde := '1';
    cTpAtend := pack_lanca_ffcv.Lanca_MGES_FFCV( ncdproduto     => iCdProduto,
                                                       ncdmvtoestoque => nCdMvtoFalha,
                                                       ncdunipro      => iCdUnidProd,
                                                       nqtmovnew      => ck.QT_KIT,
                                                       nqtmovold      => ck.QT_KIT,
                                                       caction        => 'I',
                                                       csnitempertencepacote  => 'N',
                                                       ncditemmvto    => nCdItemFalha) ;
  end loop;

  if vqtde is null then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  end if;

  return vqtde;
end;

FUNCTION F_LANCA_PRODUTO_KIT (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_PRODUTO_KIT_E(xml) THEN
                result:= F_LANCA_PRODUTO_KIT(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_PRODUTO_KIT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_lanca_kit_exame</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_LANCA_KIT_EXAME (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec,nCdMVtoFalha in number,
                            	nCdItemFalha in number) RETURN varchar2 IS
cursor C_MvtoImagem( nCdMvtoFalha in number
                       , nCdItemFalha in number ) is Select it.dt_realizado
                                                          , it.nr_faturado
                                                          , it.Cd_Prestador
                                                          , it.cd_exa_rx
                                                          , it.VL_PERC_FATUR_EXA
                                                          , ped.cd_ped_rx
                                                       From DBAMV.itped_rx it
                                                          , DBAMV.itped_rx_produto itp
                                                          , DBAMV.ped_rx ped
                                                      Where it.cd_itped_rx          = nCdMvtoFalha
                                                        and it.cd_itped_rx          = itp.cd_itped_rx
                                                        and itp.cd_itped_rx_produto = nCdItemFalha
                                                        and ped.cd_ped_rx           = it.cd_ped_rx;


    cursor C_Ped( nCdMvtoFalha in number ) is
      Select to_date(to_char(ped_rx.dt_pedido,'DD/MM/YYYY')||' '||to_char(ped_rx.hr_pedido,'HH24:MI'),'DD/MM/YYYY HH24:MI') dt_pedido
        From DBAMV.ped_rx
           , DBAMV.itped_rx
       Where ped_rx.cd_ped_rx     = itped_rx.cd_ped_rx
         and itped_rx.cd_itped_rx = nCdMvtoFalha ;

    dDtPed Date;
  vqtde varchar2(1) := null;
Begin

  if  formParams.P_MIG_SN_PSDI_PEDIDO = 'S' then
     open  C_Ped(nCdMvtoFalha) ;
     fetch C_Ped into dDtPed ;
     close C_Ped ;
  end if;

  vqtde := null;

  For V_Mvto in C_MvtoImagem(nCdMvtoFalha, nCdItemFalha) loop
    vqtde := '1';
    pack_lanca_ffcv.Lanca_PSDI_FFCV( ncdpedrx       => V_mvto.cd_ped_rx
                                         , ncditpedrx     => nCdMvtoFalha
                                         , ncdexarx       => V_mvto.cd_exa_rx
                                         , ddtrealiznew   => nvl(dDtPed,V_Mvto.dt_realizado)
                                         , ddtrealizold   => Null
                                         , nrfaturado     => nvl(V_Mvto.nr_faturado,1)
                                         , nrcdprestador  => V_Mvto.Cd_Prestador
                                         , pcfaturado     => V_Mvto.VL_PERC_FATUR_EXA
                                         , ncdItemformula => nCdItemFalha ) ;
  end loop V_Mvto;

  if vqtde is null then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  end if;

  return vqtde;
end;

FUNCTION F_LANCA_KIT_EXAME (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    formParams FormParamsRec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        formParams.P_MIG_SN_PSDI_PEDIDO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSDI_PEDIDO');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_LANCA_KIT_EXAME_E(xml) THEN
                result:= F_LANCA_KIT_EXAME(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, formParams, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.F_LANCA_KIT_EXAME_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSDI_PEDIDO', formParams.P_MIG_SN_PSDI_PEDIDO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_sn_pertence_pacote</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_SN_PERTENCE_PACOTE (xml IN OUT NOCOPY PKG_XML.XmlContext,nCdRegFat in number, nCdLancamento in number, vSnPertencePacote in varchar2 default 'S') RETURN VARCHAR2 IS
cursor c_ItemPacote is
    select 'S'
      from DBAMV.conta_pacote
     where cd_reg_fat = nCdRegFat
       and cd_lancamento_fat = nCdLancamento;

  cSnItemPacote varchar2(1);
BEGIN
  open  c_ItemPacote;
  fetch c_ItemPacote into cSnItemPacote;

  if c_ItemPacote%found and vSnPertencePacote = 'S' then
      cSnItemPacote := 'S';
  else
      cSnItemPacote := 'N';
  end if;

  close c_ItemPacote;

  return cSnItemPacote;
END;

FUNCTION F_SN_PERTENCE_PACOTE (in_params in Clob, out_params out Clob) RETURN VARCHAR2 IS
    xml PKG_XML.XmlContext;
    nCdRegFat number;
    nCdLancamento number;
    vSnPertencePacote varchar2(4000);
    result VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        nCdRegFat:= PKG_XML.Getnumber(xml, 'nCdRegFat');
        nCdLancamento:= PKG_XML.Getnumber(xml, 'nCdLancamento');
        vSnPertencePacote:= PKG_XML.Getvarchar2(xml, 'vSnPertencePacote');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_SN_PERTENCE_PACOTE_E(xml) THEN
                result:= F_SN_PERTENCE_PACOTE(xml, nCdRegFat, nCdLancamento, vSnPertencePacote);
                Pkg_ffcv_M_LAN_HOS_C.F_SN_PERTENCE_PACOTE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_tp_fatura</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_TP_FATURA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,nCdConvenio in number) RETURN varchar2 IS
vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_ParamRet PKG_PARAMETRO.ID_LISTA_PARAM;
  vTpFatura      for_apre.tp_fatura%type;
begin
    vTpFatura := null;

  M_PKG_FFCV_FOR_APRE.P_RETORNA_DADOS_CONV(xml, nCdConvenio
                                          ,formParams.P_MIG_CD_MULTI_EMPRESA
                                          ,formParams.P_MIG_CD_USUARIO
                                          ,true
                                          ,true
                                          ,vLst_ParamRet);

    -- Recuperao da lista de parmetro retornada pela Procedure
    vLst_Local := pkg_parametro.fn_recupera_lista_parametros(vLst_ParamRet);
    --
    -- Recuperao dos parametros
    pkg_parametro.pr_recupera_parametro(vLst_Local, 'TP_FATURA', vTpFatura, false);
    --
    -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
    pkg_parametro.pr_limpar_lista_parametros(vLst_Local);

    if vTpFatura is null then
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_61)
        PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
				  pkg_rmi_traducao.extrair_pkg_msg('MSG_61', 'PKG_FFCV_M_LAN_HOS',
					  'Atenção: Forma de Apresentação não cadastrada para o Convênio %s.: Definir uma forma de Apresentação para o Convênio.', arg_list(preg_fat.cd_convenio, chr(10))), true);
    end if;

  return vTpFatura;
end;

FUNCTION F_TP_FATURA (in_params in Clob, out_params out Clob) RETURN varchar2 IS
    xml PKG_XML.XmlContext;
    nCdConvenio number;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    result varchar2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        nCdConvenio:= PKG_XML.Getnumber(xml, 'nCdConvenio');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_TP_FATURA_E(xml) THEN
                result:= F_TP_FATURA(xml, pREG_FAT, formParams, nCdConvenio);
                Pkg_ffcv_M_LAN_HOS_C.F_TP_FATURA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_processa_proibicao_produto</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_PROCESSA_PROIBICAO_PRODUTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec)
	                RETURN number IS
    Cursor C_MvtoEstoque is
       Select itmvto_estoque.cd_produto,
              itmvto_estoque.cd_uni_pro,
              itmvto_estoque.qt_movimentacao,
              itmvto_estoque.cd_fornecedor,
              mvto_estoque.tp_mvto_estoque
         From DBAMV.itmvto_estoque, DBAMV.mvto_estoque
        Where mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
          and (mvto_estoque.cd_atendimento = preg_fat.cd_atendimento
                   or mvto_estoque.cd_atendimento IN (SELECT cd_atendimento
                                                    FROM dbamv.atendime
                                                   WHERE cd_atendimento_pai = preg_fat.cd_atendimento))
          and itmvto_estoque.cd_mvto_estoque = pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA
          and itmvto_estoque.cd_itmvto_estoque = pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA ;

     Cursor C_Solsaipro is
       Select itsolsai_pro.cd_produto,
              itsolsai_pro.cd_uni_pro,
              itsolsai_pro.qt_solicitado,
              null,
              'C'
         From DBAMV.itsolsai_pro, DBAMV.solsai_pro
        Where solsai_pro.cd_solsai_pro = itsolsai_pro.cd_solsai_pro
          and (solsai_pro.cd_atendimento = preg_fat.cd_atendimento
                   or solsai_pro.cd_atendimento IN (SELECT cd_atendimento
                                                  FROM DBAMV.atendime
                                                 WHERE cd_atendimento_pai = preg_fat.cd_atendimento))
          and itsolsai_pro.cd_solsai_pro = pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA
          and itsolsai_pro.cd_itsolsai_pro = pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA ;


     cDummy VarChar2( 1 ) ;
     V_Mvto C_MvtoEstoque%rowtype;
     vSnMvto varchar2(1);
     vqtde number;

  Begin
    vqtde := to_number(null);
    open C_MvtoEstoque;
    fetch C_MvtoEstoque into  V_Mvto;
    close C_MvtoEstoque;

    if nvl(v_mvto.tp_mvto_estoque, 'X') = 'P' then
          vSnMvto := 'S';
    else
      if  formParams.P_MIG_SN_ESTORNO_SOLIC_DEVOL = 'S' then
        vSnMvto := 'N';
      else
        vSnMvto := 'S';
      end if;
    end if;

    if vSnMvto = 'S' then
      For V_Mvto in C_MvtoEstoque loop
          vqtde := '1';
          cDummy := pack_lanca_ffcv.Lanca_MGES_FFCV( ncdproduto      => V_Mvto.cd_produto,
                                                        ncdmvtoestoque  => pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA,
                                                        ncdunipro                => V_Mvto.cd_uni_pro,
                                                        nqtmovnew       => V_Mvto.qt_movimentacao,
                                                        nqtmovold       => Null,
                                                        caction                    => 'I',
                                                        csnitempertencepacote => 'X',
                                                        ncditemmvto     => pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA,
                                                        ncdfornec       => V_Mvto.cd_fornecedor) ;
      end loop ;
    else
      For V_Mvto in C_Solsaipro loop
        vqtde := '1';
        cDummy := pack_lanca_ffcv.Lanca_MGES_FFCV( ncdproduto      => V_Mvto.cd_produto,
                                                        ncdmvtoestoque  => pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA,
                                                        ncdunipro                => V_Mvto.cd_uni_pro,
                                                        nqtmovnew       => V_Mvto.qt_solicitado,
                                                        nqtmovold       => Null,
                                                        caction                    => 'I',
                                                        csnitempertencepacote => 'X',
                                                        ncditemmvto     => pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA,
                                                        ncdfornec       => null /*V_Mvto.cd_fornecedor*/) ;
      end loop ;
    end if;

    if vqtde is null then
        Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
    end if;

    return vqtde;
end ;

FUNCTION F_PROCESSA_PROIBICAO_PRODUTO (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    formParams FormParamsRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        formParams.P_MIG_SN_ESTORNO_SOLIC_DEVOL:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ESTORNO_SOLIC_DEVOL');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_PROCESSA_PROIBICAO_PRODUTO_E(xml) THEN
                result:= F_PROCESSA_PROIBICAO_PRODUTO(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, formParams);
                Pkg_ffcv_M_LAN_HOS_C.F_PROCESSA_PROIBICAO_PRODUTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ESTORNO_SOLIC_DEVOL', formParams.P_MIG_SN_ESTORNO_SOLIC_DEVOL);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_valida_conveio_e_remessa</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_VALIDA_CONVEIO_E_REMESSA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,nCdRemessa in Number, cDs_Convenio out varchar2) RETURN number IS
CURSOR C IS
    SELECT REM_FAT.DT_ABERTURA
          ,REM_FAT.DT_FECHAMENTO
          ,FATURA.CD_CONVENIO
          ,CONVENIO.NM_CONVENIO
          ,REM_FAT.CD_AGRUPAMENTO
          ,REM_FAT.SN_FECHADA
          ,fatura.dt_competencia
    FROM   DBAMV.REMESSA_FATURA REM_FAT
          ,DBAMV.FATURA FATURA
          ,DBAMV.CONVENIO CONVENIO
    WHERE  REM_FAT.CD_REMESSA = nCdRemessa
    AND    FATURA.CD_FATURA = REM_FAT.CD_FATURA
    AND    FATURA.CD_CONVENIO = CONVENIO.CD_CONVENIO
    AND    FATURA.CD_MULTI_EMPRESA = formParams.P_MIG_CD_MULTI_EMPRESA;
    nCd_Convenio NUMBER;
    dCompetencia date ;
BEGIN
  OPEN C;
  FETCH C
  INTO    pREG_FAT.DSP_DT_ABERTURA
        , pREG_FAT.DSP_DT_FECHAMENTO
        ,nCd_Convenio
        ,cDs_Convenio
        , pREG_FAT.DSP_CD_AGRUPAMENTO
        , pREG_FAT.DSP_SN_FECHADA_REMESSA
        ,dCompetencia;
  close c;

  return nCd_Convenio;
end;

FUNCTION F_VALIDA_CONVEIO_E_REMESSA (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    nCdRemessa Number;
    cDs_Convenio varchar2(4000);
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_DT_ABERTURA:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ABERTURA');
        pREG_FAT.DSP_DT_FECHAMENTO:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_FECHAMENTO');
        pREG_FAT.DSP_CD_AGRUPAMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_AGRUPAMENTO');
        pREG_FAT.DSP_SN_FECHADA_REMESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_FECHADA_REMESSA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        nCdRemessa:= PKG_XML.GetNumber(xml, 'nCdRemessa');
        cDs_Convenio:= PKG_XML.Getvarchar2(xml, 'cDs_Convenio');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_VALIDA_CONVEIO_E_REMESSA_E(xml) THEN
                result:= F_VALIDA_CONVEIO_E_REMESSA(xml, pREG_FAT, formParams, nCdRemessa, cDs_Convenio);
                Pkg_ffcv_M_LAN_HOS_C.F_VALIDA_CONVEIO_E_REMESSA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ABERTURA', pREG_FAT.DSP_DT_ABERTURA);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_FECHAMENTO', pREG_FAT.DSP_DT_FECHAMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_AGRUPAMENTO', pREG_FAT.DSP_CD_AGRUPAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_FECHADA_REMESSA', pREG_FAT.DSP_SN_FECHADA_REMESSA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.Setvarchar2(xml, 'cDs_Convenio', cDs_Convenio);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_qtd_faturas_juntas</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_QTD_FATURAS_JUNTAS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec,pConta in number) RETURN number IS
cursor c_imp_junta is
      select Count(1)
      from   DBAMV.reg_fat
            ,DBAMV.itreg_fat
            ,DBAMV.convenio
            ,DBAMV.for_apre
            ,DBAMV.itfor_apre_gru_pro
            ,DBAMV.pro_fat
            ,dbamv.empresa_convenio
      where  reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
      AND    empresa_convenio.cd_convenio = Convenio.Cd_Convenio
      AND    empresa_Convenio.Cd_Multi_Empresa = dbamv.pkg_mv2000.le_empresa
      and    reg_fat.cd_convenio = convenio.cd_convenio
      and    for_apre.cd_for_apre = nvl(empresa_convenio.cd_for_apre,convenio.cd_for_apre)
      And    for_apre.cd_for_apre = itfor_apre_gru_pro.cd_for_apre
      and    pro_fat.cd_pro_fat =  itreg_fat.cd_pro_fat
      and    pro_fat.cd_gru_pro =  itfor_apre_gru_pro.cd_gru_pro
      and    itfor_apre_gru_pro.sn_separada = 'N'
      and    itreg_fat.sn_pertence_pacote = 'N'
      and    reg_fat.cd_atendimento = preg_fat.cd_atendimento
      and    reg_fat.cd_reg_fat = nvl(pConta,preg_fat.cd_reg_fat);
  nvl_cont_junta number;
begin
    open  c_imp_junta;
    fetch c_imp_junta into nvl_cont_junta;
    close c_imp_junta;

    return nvl_cont_junta;
END;

FUNCTION F_QTD_FATURAS_JUNTAS (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    pConta number;
    preg_fat REG_FATRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pConta:= PKG_XML.Getnumber(xml, 'pConta');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_QTD_FATURAS_JUNTAS_E(xml) THEN
                result:= F_QTD_FATURAS_JUNTAS(xml, pREG_FAT, pConta);
                Pkg_ffcv_M_LAN_HOS_C.F_QTD_FATURAS_JUNTAS_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_qtd_faturas_juntas_fat</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_QTD_FATURAS_JUNTAS_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec,pConta in number) RETURN number IS
cursor c_imp_junta_fat is
      select Count(1)
      from   DBAMV.reg_fat
            ,DBAMV.itreg_fat
            ,DBAMV.convenio
            ,DBAMV.for_apre
            ,DBAMV.itfor_apre_gru_fat
            ,DBAMV.pro_fat
            ,dbamv.empresa_convenio
      where  reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
      and    reg_fat.cd_convenio = convenio.cd_convenio
      AND    empresa_convenio.cd_convenio = Convenio.Cd_Convenio
      AND    empresa_Convenio.Cd_Multi_Empresa = dbamv.pkg_mv2000.le_empresa
      and    for_apre.cd_for_apre = nvl(empresa_convenio.cd_for_apre,convenio.cd_for_apre)
      And    for_apre.cd_for_apre = itfor_apre_gru_fat.cd_for_apre
      and    pro_fat.cd_pro_fat =  itreg_fat.cd_pro_fat
      and    itreg_fat.cd_gru_fat =  itfor_apre_gru_fat.cd_gru_fat
      and    itfor_apre_gru_fat.sn_separada = 'N'
      and    itreg_fat.sn_pertence_pacote = 'N'
      and    reg_fat.cd_atendimento = preg_fat.cd_atendimento
      and    reg_fat.cd_reg_fat = nvl(pConta,preg_fat.cd_reg_fat) ;

  nvl_cont_junta number;
begin
    open  c_imp_junta_fat;
    fetch c_imp_junta_fat into nvl_cont_junta;
    close c_imp_junta_fat;

    return nvl_cont_junta;
end;

FUNCTION F_QTD_FATURAS_JUNTAS_FAT (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    pConta number;
    preg_fat REG_FATRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pConta:= PKG_XML.Getnumber(xml, 'pConta');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_QTD_FATURAS_JUNTAS_FAT_E(xml) THEN
                result:= F_QTD_FATURAS_JUNTAS_FAT(xml, pREG_FAT, pConta);
                Pkg_ffcv_M_LAN_HOS_C.F_QTD_FATURAS_JUNTAS_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_qtd_stop_loss</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_QTD_STOP_LOSS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) RETURN number IS
Cursor C_Stop_Loss IS
        Select count(1)
          From DBAMV.regra_sl, DBAMV.empresa_convenio
         Where regra_sl.cd_convenio = preg_fat.cd_convenio
           and regra_sl.cd_convenio = empresa_convenio.cd_convenio
           and empresa_convenio.cd_multi_empresa = formParams.P_MIG_CD_MULTI_EMPRESA
         and regra_sl.cd_con_pla  = preg_fat.cd_con_pla;
  Total number;
BEGIN
  Open  C_Stop_Loss;
  Fetch C_Stop_Loss Into Total;
  CLose C_Stop_Loss;

  return Total;
END;

FUNCTION F_QTD_STOP_LOSS (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_QTD_STOP_LOSS_E(xml) THEN
                result:= F_QTD_STOP_LOSS(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.F_QTD_STOP_LOSS_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>fnc_qtd_documento</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	FUNCTION F_QTD_DOCUMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,nConta in number) RETURN number IS
cursor cQtdDoc is
   select count(1)
     from DBAMV.documento_req  doc_req,
          DBAMV.itreg_fat  itreg_fat,
          DBAMV.reg_fat  reg_fat
    where itreg_fat.cd_pro_fat  =  doc_req.cd_pro_fat
      AND REG_FAT.CD_MULTI_EMPRESA = formParams.P_MIG_CD_MULTI_EMPRESA
      and (reg_fat.cd_convenio  =  doc_req.cd_convenio  or
             doc_req.cd_convenio  is  null)
      and (reg_fat.cd_con_pla  =  doc_req.cd_con_pla  or
          doc_req.cd_con_pla  is  null)
        and reg_fat.cd_reg_fat  =  nConta
        and reg_fat.cd_reg_fat  =  itreg_fat.cd_reg_fat
        and doc_req.sn_fatura  =  'S';
  nreg number;
begin
    -- Implementao da impresso do relatrio de documento requisitados
  open  cQtdDoc;
  fetch cQtdDoc into nreg;
  close cQtdDoc;

  return nreg;
end;

FUNCTION F_QTD_DOCUMENTO (in_params in Clob, out_params out Clob) RETURN number IS
    xml PKG_XML.XmlContext;
    nConta number;
    formParams FormParamsRec;
    result number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        nConta:= PKG_XML.Getnumber(xml, 'nConta');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.F_QTD_DOCUMENTO_E(xml) THEN
                result:= F_QTD_DOCUMENTO(xml, formParams, nConta);
                Pkg_ffcv_M_LAN_HOS_C.F_QTD_DOCUMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        out_params := PKG_XML.GetOutputClob(xml);
     return result;

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CGFK$CHK_REG_FAT_REG_FAT_TIP_A</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_REG_FAT_REG_FAT_TIP_A (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) IS
vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
  --
Begin
  --
  -- Chamada da Procedure
  M_PKG_PARI_TIP_ACOM.P_RETORNA_DADOS(xml, pREG_FAT.CD_TIP_ACOM
                                     ,formParams.P_MIG_CD_MULTI_EMPRESA
                                     ,formParams.P_MIG_CD_USUARIO
                                     ,pbSnLevantaExecessao
                                     ,pbSnMostraMensagem
                                     ,vLst_Retorno);
  --
  vLst_Local := pkg_parametro.fn_recupera_lista_parametros(vLst_Retorno);
  --
  -- Recuperao dos parametros retornados pela Procedure
  pkg_parametro.pr_recupera_parametro(vLst_Local,'DS_TIP_ACOM'    , pREG_FAT.DSP_DS_TIP_ACOM     , false);
  pkg_parametro.pr_recupera_parametro(vLst_Local,'SN_ACOMOD_CONTA', pREG_FAT.DSP_SN_ACOMOD_CONTA , false);
  --
  -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
  pkg_parametro.pr_limpar_lista_parametros(vLst_Local);
  --
end;

PROCEDURE P_CHK_REG_FAT_REG_FAT_TIP_A (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_TIP_ACOM');
        pREG_FAT.DSP_DS_TIP_ACOM:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_TIP_ACOM');
        pREG_FAT.DSP_SN_ACOMOD_CONTA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_ACOMOD_CONTA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_REG_FAT_REG_FAT_TIP_A_E(xml) THEN
                P_CHK_REG_FAT_REG_FAT_TIP_A(xml, pREG_FAT, formParams, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_REG_FAT_REG_FAT_TIP_A_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_TIP_ACOM', pREG_FAT.CD_TIP_ACOM);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_TIP_ACOM', pREG_FAT.DSP_DS_TIP_ACOM);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_ACOMOD_CONTA', pREG_FAT.DSP_SN_ACOMOD_CONTA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



  /*
  <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
  <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
  <OBJETIVO>CGFK$CHK_REG_FAT_REG_FAT_ATEND</OBJETIVO>
  <ALTERACOES></ALTERACOES>
  */
PROCEDURE P_CHK_REG_FAT_REG_FAT_ATEND (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, global IN OUT NOCOPY GlobalsRec, formParams IN OUT NOCOPY FormParamsRec,
	                                      FSV_RECORD_STATUS IN OUT NOCOPY varchar2,pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) IS
  Cursor C1 Is
    select nr_carteira,
           dt_validade,
           nm_titular,
           cd_con_pla,
           ds_con_pla,
           nm_empresa,
           cd_empresa_carteira,
           cd_regra,
           cd_categoria_plano,
           ds_categoria_plano,
           sn_titular,
           sn_pensionista
    from (select carteira.nr_carteira,
                  carteira.dt_validade,
                  carteira.nm_titular,
                  carteira.cd_con_pla,
                  con_pla.ds_con_pla,
                  carteira.nm_empresa,
                  carteira.cd_empresa_carteira,
                  empresa_con_pla.cd_regra,
                  carteira.cd_categoria_plano,
                  categoria_plano.ds_categoria_plano,
                  carteira.sn_titular,
                  carteira.sn_pensionista,
                         2 ordem
                from DBAMV.carteira carteira
               ,DBAMV.con_pla con_pla
               ,DBAMV.categoria_plano
                   ,DBAMV.empresa_con_pla
                where carteira.cd_paciente = pREG_FAT.DSP_CD_PACIENTE
                  and carteira.cd_convenio = pREG_FAT.CD_CONVENIO
                  and carteira.cd_con_pla  = pREG_FAT.CD_CON_PLA
                  and empresa_con_pla.cd_convenio = con_pla.cd_convenio
                      and empresa_con_pla.cd_con_pla = con_pla.cd_con_pla
                      and Empresa_Con_Pla.Cd_Multi_Empresa = formParams.P_MIG_CD_MULTI_EMPRESA
                      and carteira.cd_con_pla = con_pla.cd_con_pla
            and carteira.cd_convenio = con_pla.cd_convenio
            and carteira.cd_categoria_plano = categoria_plano.cd_categoria_plano (+)

                union all

                select carteira.nr_carteira,
                  carteira.dt_validade,
                  carteira.nm_titular,
                  carteira.cd_con_pla,
                  con_pla.ds_con_pla,
                  carteira.nm_empresa,
                  carteira.cd_empresa_carteira,
                  empresa_con_pla.cd_regra,
                  carteira.cd_categoria_plano,
                  categoria_plano.ds_categoria_plano,
                  carteira.sn_titular,
                  carteira.sn_pensionista,
                           1 ordem
                from DBAMV.carteira carteira
               ,DBAMV.con_pla con_pla
               ,DBAMV.categoria_plano
                   ,DBAMV.empresa_con_pla
                   ,DBAMV.atendime
                where carteira.cd_paciente = pREG_FAT.DSP_CD_PACIENTE
                  and carteira.cd_convenio = pREG_FAT.CD_CONVENIO
                  and carteira.cd_con_pla  = pREG_FAT.CD_CON_PLA
                  and atendime.cd_atendimento  = pREG_FAT.CD_ATENDIMENTO
                  and atendime.nr_carteira  = carteira.nr_carteira
                  and empresa_con_pla.cd_convenio = con_pla.cd_convenio
                      and empresa_con_pla.cd_con_pla = con_pla.cd_con_pla
                      and Empresa_Con_Pla.Cd_Multi_Empresa = formParams.P_MIG_CD_MULTI_EMPRESA
                      and carteira.cd_con_pla = con_pla.cd_con_pla
            and carteira.cd_convenio = con_pla.cd_convenio
            and carteira.cd_categoria_plano = categoria_plano.cd_categoria_plano (+)
        )
        order by ordem;

    CURSOR cRegAcop(pnConvSec IN NUMBER, pnPlanSec IN regra_acoplamento.cd_con_pla%type ) IS
        SELECT reg_acop.cd_regra_acoplamento
          FROM DBAMV.regra_acoplamento reg_acop,
               DBAMV.atendime atendime
              ,DBAMV.empresa_convenio
         where reg_acop.cd_convenio = empresa_convenio.cd_convenio
           and empresa_convenio.cd_multi_empresa = formParams.P_MIG_CD_MULTI_EMPRESA
           and reg_acop.cd_convenio_conta = atendime.cd_convenio
           AND reg_acop.cd_convenio = pnConvSec
           AND reg_acop.cd_con_pla_conta = atendime.cd_con_pla
           AND reg_acop.cd_con_pla = pnPlanSec
           AND reg_acop.tp_atendimento IN ('T','I')
           AND reg_acop.sn_titular = 'T'
           AND reg_acop.sn_pensionista = 'T'
           AND atendime.cd_atendimento = preg_fat.cd_atendimento;

  cursor cMaxRegFat is
    select max(cd_reg_fat)conta
      from DBAMV.reg_fat
     where reg_fat.cd_atendimento = preg_fat.CD_ATENDIMENTO;

  cursor cDtConta(pConta in reg_fat.cd_reg_fat%type ) is
    select dt_inicio, dt_final
      from DBAMV.reg_fat
    where cd_reg_fat = pConta;

  vTpConvSec       VARCHAR2(1):= NULL;
  vTpConvenioConta VARCHAR2(1):= NULL;
  nCdAcoplamento   regra_acoplamento.cd_regra_acoplamento%TYPE;
  vMaxConta        cMaxRegFat%rowtype;
  vData            cDtConta%rowtype;
  nCd_Con_Pla      con_pla.cd_con_pla%type ;
  cDsp_Ds_Con_Pla  VARCHAR2(30);
  nCdRegra         Number;
  vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;

  vAtendimeDtAtendimento        atendime.dt_atendimento%type;
  vAtendimeHrAtendimento        atendime.hr_atendimento%type;
  vAtendimeCdTipAcom            atendime.cd_tip_acom%type;
  vAtendimeTpAtendimento        atendime.tp_atendimento%type;
  vAtendimeDtAlta               atendime.dt_alta%type;
  vAtendimeHrAlta               atendime.hr_alta%type;
  vAtendimeCdConvenio           atendime.cd_convenio%type;
  vAtendimeCdPaciente           atendime.cd_paciente%type;
  vAtendimeCdPrestador          atendime.cd_prestador%type;
  vAtendimeCdCid                atendime.cd_cid%type;
  vAtendimeCdConPla             atendime.cd_con_pla%type;
  vAtendimeCdConvenioSecundario atendime.cd_convenio_secundario%type;
  vAtendimeCdConPlaSecundario   atendime.cd_con_pla_secundario%type;
  vAtendimeCdEspecialid         atendime.cd_especialid%type;
  vAtendimeCdMultiEmpresa       atendime.cd_multi_empresa%type;
  vAtendimeCdOriAte             atendime.cd_ori_ate%type;
  vAtendimeCdProInt             atendime.cd_pro_int%type;
  vConvenioSnValidadeCarteira   convenio.sn_validade_carteira%type;
  vTemp                         varchar2(2000);
  --
  -- OP 19191 - 06/05/2014 - melhoria de performance
  CURSOR cAtendimeLista( pAtendime IN NUMBER ) IS
    SELECT dt_atendimento, hr_atendimento, cd_tip_acom, tp_atendimento, dt_alta, hr_alta, cd_convenio, cd_paciente,
           cd_prestador, cd_cid, cd_con_pla, cd_convenio_secundario, cd_con_pla_secundario, cd_especialid, cd_multi_empresa,
           cd_ori_ate, cd_pro_int
      FROM dbamv.atendime
     WHERE cd_atendimento = pAtendime;
  --
  CURSOR cConvenioLista1( pConvenio IN NUMBER ) IS
    SELECT c.tp_convenio
      FROM dbamv.convenio c
     WHERE c.cd_convenio = pConvenio;
  --
 CURSOR cConvenioLista2( pConvenio IN NUMBER ) IS
    SELECT c.tp_convenio, c.nm_convenio, c.sn_filantropia, e.tp_forma_gerar_con_rec,
           c.tp_forma_agrupamento, c.tp_importar_matmed, Nvl(e.cd_for_apre,c.cd_for_apre), c.sn_validade_carteira, c.sn_guia
      FROM dbamv.convenio c, dbamv.empresa_convenio e
     WHERE c.cd_convenio = pConvenio
       AND c.cd_convenio = e.cd_convenio
       AND e.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;
  --
  CURSOR cTipAcomLista( pAcom IN NUMBER ) IS
    SELECT ds_tip_acom FROM dbamv.tip_acom
     WHERE cd_tip_acom = pAcom;
  --
  CURSOR cPrestadorLista( pPrest IN NUMBER ) IS
    SELECT nm_prestador FROM dbamv.prestador
     WHERE cd_prestador = pPrest;
  --
  CURSOR cOrigemLista( pOrigem IN NUMBER ) IS
    SELECT ds_ori_ate FROM dbamv.ori_ate
     WHERE cd_ori_ate = pOrigem;
  --
  CURSOR cPacienteLista( pPaciente IN NUMBER ) IS
    SELECT nm_paciente, tp_sexo FROM dbamv.paciente
     WHERE cd_paciente = pPaciente;
  --
  CURSOR cProfat( pProfat IN VARCHAR2 ) IS
    SELECT sn_pacote FROM dbamv.pro_fat
     WHERE cd_pro_fat = pProfat;
  --
  CURSOR cContaLista( pConta IN NUMBER ) IS
    SELECT cd_convenio FROM dbamv.reg_fat
     WHERE cd_reg_fat = pConta;
  --
  CURSOR cPlanoLista( pcd_con_pla IN NUMBER, pcd_convenio IN NUMBER, pEmpresa IN NUMBER ) IS
    SELECT c.ds_con_pla, e.cd_regra
      FROM dbamv.con_pla c, dbamv.empresa_con_pla e
     WHERE c.cd_con_pla       = pcd_con_pla
       AND c.cd_convenio      = pcd_convenio
       AND e.cd_con_pla       = c.cd_con_pla
       AND e.cd_convenio      = c.cd_convenio
       AND e.cd_multi_empresa = pEmpresa;

  -- OP 19191 - fim
  --
BEGIN

  vAtendimeDtAtendimento        := null;
  vAtendimeHrAtendimento        := null;
  vAtendimeCdTipAcom            := null;
  vAtendimeTpAtendimento        := null;
  vAtendimeDtAlta               := null;
  vAtendimeHrAlta               := null;
  vAtendimeCdConvenio           := null;
  vAtendimeCdPaciente           := null;
  vAtendimeCdPrestador          := null;
  vAtendimeCdCid                := null;
  vAtendimeCdConPla             := null;
  vAtendimeCdConvenioSecundario := null;
  vAtendimeCdConPlaSecundario   := null;
  vAtendimeCdEspecialid         := null;
  vAtendimeCdMultiEmpresa       := null;
  vAtendimeCdOriAte             := null;
  vAtendimeCdProInt             := null;
  vConvenioSnValidadeCarteira   := null;

  -- OP 19191 - 06/05/2014 - melhoria de performance
  OPEN  cAtendimeLista( preg_fat.cd_atendimento );
  FETCH cAtendimeLista INTO vAtendimeDtAtendimento, vAtendimeHrAtendimento, vAtendimeCdTipAcom, vAtendimeTpAtendimento, vAtendimeDtAlta,
                            vAtendimeHrAlta, vAtendimeCdConvenio, vAtendimeCdPaciente, vAtendimeCdPrestador, vAtendimeCdCid, vAtendimeCdConPla,
                            vAtendimeCdConvenioSecundario, vAtendimeCdConPlaSecundario, vAtendimeCdEspecialid, vAtendimeCdMultiEmpresa,
                            vAtendimeCdOriAte, vAtendimeCdProInt;
  CLOSE cAtendimeLista;

  IF vAtendimeCdConvenioSecundario IS NOT NULL THEN

    -- OP 19191 - 06/05/2014 - melhoria de performance
    -- Consulta o tipo de Convênio do plano secundrio
    OPEN  cConvenioLista1( vAtendimeCdConvenioSecundario );
    FETCH cConvenioLista1 INTO vTpConvSec;
    CLOSE cConvenioLista1;

    -- Consulta a regra de acoplamento, caso exista Convênio secundrio
    OPEN  cRegAcop(vAtendimeCdConvenioSecundario ,vAtendimeCdConPlaSecundario) ;
    FETCH cRegAcop into nCdAcoplamento;
    CLOSE cRegAcop;

  END IF;

  -- Atribui informaes do atendimento ao bloco da conta
  pREG_FAT.DSP_DT_ATENDIMENTO         := vAtendimeDtAtendimento;
  pREG_FAT.DSP_HR_ATENDIMENTO         := vAtendimeHrAtendimento;
  pREG_FAT.DSP_CD_TIP_ACOM            := vAtendimeCdTipAcom;
  pREG_FAT.DSP_TP_ATENDIMENTO         := vAtendimeTpAtendimento;
  pREG_FAT.DSP_DT_ALTA                := vAtendimeDtAlta;
  pREG_FAT.DSP_HR_ALTA                := vAtendimeHrAlta;
  pREG_FAT.DSP_CD_PACIENTE            := vAtendimeCdPaciente;
  pREG_FAT.DSP_CD_PRESTADOR           := vAtendimeCdPrestador;
  pREG_FAT.DSP_CD_CID                 := vAtendimeCdCid;
  pREG_FAT.DSP_CD_CONVENIO_SECUNDARIO := vAtendimeCdConvenioSecundario;
  pREG_FAT.DSP_CD_CON_PLA_SECUNDARIO  := vAtendimeCdConPlaSecundario;
  pREG_FAT.DSP_CD_ESPECIALID          := vAtendimeCdEspecialid;
  pREG_FAT.DSP_EMPRESA_ATENDIME       := vAtendimeCdMultiEmpresa;
  pREG_FAT.DSP_CD_ORI_ATE             := vAtendimeCdOriAte;

  pREG_FAT.DSP_NM_PACIENTE := null;
  pREG_FAT.DSP_TP_SEXO     := null;

  -- OP 19191 - 06/05/2014 - melhoria de performance
  OPEN  cTipAcomLista( vAtendimeCdTipAcom );
  FETCH cTipAcomLista INTO pREG_FAT.DSP_DS_TIP_ACOM2;
  CLOSE cTipAcomLista;
  --
  OPEN  cPrestadorLista( vAtendimeCdPrestador );
  FETCH cPrestadorLista INTO pREG_FAT.DSP_NM_PRESTADOR;
  CLOSE cPrestadorLista;
  --
  OPEN  cOrigemLista( vAtendimeCdOriAte );
  FETCH cOrigemLista INTO pREG_FAT.DSP_DS_ORI_ATE;
  CLOSE cOrigemLista;
  --
  OPEN  cPacienteLista( vAtendimeCdPaciente );
  FETCH cPacienteLista INTO pREG_FAT.DSP_NM_PACIENTE, pREG_FAT.DSP_TP_SEXO;
  CLOSE cPacienteLista;
  -- OP 19191 - fim

  -- Verifica se deve utilizar o Convênio da conta ou do atendimento.
  pREG_FAT.DSP_TP_FORMA_AGRUPAMENTO    := null;
  pREG_FAT.DSP_TP_IMPORTAR_MATMED      := null;
  pREG_FAT.DSP_NM_CONVENIO_ATENDIMENTO := null;
  pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO := null;
  pREG_FAT.DSP_CD_FOR_APRE             := null;
  pREG_FAT.DSP_SN_PERTENCE_PACOTE      := null;

  if  preg_fat.cd_reg_fat is null then
    -- OP 19191 - 06/05/2014 - melhoria de performance
    -- Consulta informas do Convênio do atendimento
    OPEN  cConvenioLista2( vAtendimeCdConvenio );
    FETCH cConvenioLista2 INTO pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO, pREG_FAT.DSP_NM_CONVENIO_ATENDIMENTO, vTemp, vTemp,
                               pREG_FAT.DSP_TP_FORMA_AGRUPAMENTO, pREG_FAT.DSP_TP_IMPORTAR_MATMED, pREG_FAT.DSP_CD_FOR_APRE,
                               vConvenioSnValidadeCarteira, vTemp;
    CLOSE cConvenioLista2;

    pREG_FAT.DSP_CD_CONVENIO := vAtendimeCdConvenio;
    vTpConvenioConta         := pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO;

    if  pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO in ('C', 'P') then
      -- OP 19191 - 06/05/2014 - melhoria de performance
      -- Consulta se o procedimento principal do atendimento permite pacote
      OPEN  cProfat( vAtendimeCdProInt );
      FETCH cProfat INTO pREG_FAT.DSP_SN_PERTENCE_PACOTE;
      CLOSE cProfat;
    end if;

  else

    if  pREG_FAT.DSP_CD_CONVENIO is null THEN
      -- OP 19191 - 06/05/2014 - melhoria de performance
      OPEN  cContaLista( preg_fat.cd_reg_fat );
      FETCH cContaLista INTO pREG_FAT.DSP_CD_CONVENIO;
      CLOSE cContaLista;
    end if;

    if  pREG_FAT.DSP_CD_CONVENIO is null then
        PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_58', 'PKG_FFCV_M_LAN_HOS', 'Erro'),
				  pkg_rmi_traducao.extrair_pkg_msg('MSG_62', 'PKG_FFCV_M_LAN_HOS',
					  'Erro: não foi possível localizar o Convênio da conta %s.: entrar em contato com o setor de informática do hospital.', arg_list(preg_fat.cd_reg_fat, chr(10))), true);
    end if;

    -- OP 19191 - 06/05/2014 - melhoria de performance
    -- Consulta informaes do Convênio da conta
    OPEN  cConvenioLista2( pREG_FAT.DSP_CD_CONVENIO );
    FETCH cConvenioLista2 INTO pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO, pREG_FAT.DSP_NM_CONVENIO_ATENDIMENTO, vTemp, vTemp,
                               pREG_FAT.DSP_TP_FORMA_AGRUPAMENTO, pREG_FAT.DSP_TP_IMPORTAR_MATMED, pREG_FAT.DSP_CD_FOR_APRE,
                               vConvenioSnValidadeCarteira, vTemp;
    CLOSE cConvenioLista2;

    vTpConvenioConta := pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO;

    if  pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO in ('C', 'P') then
      -- OP 19191 - 06/05/2014 - melhoria de performance
      -- Consulta se o procedimento principal da conta permite pacote
      OPEN  cProfat( pREG_FAT.CD_PRO_FAT_SOLICITADO );
      FETCH cProfat INTO pREG_FAT.DSP_SN_PERTENCE_PACOTE;
      CLOSE cProfat;
    end if;
  end if;

  global.cd_pro_int := pREG_FAT.CD_PRO_FAT_SOLICITADO ;

  If  FSV_RECORD_STATUS = 'INSERT' THEN
    open cMaxRegFat;
    fetch cMaxRegFat into vMaxConta;
    if cMaxRegFat%found then
      open cDtConta(vMaxConta.conta);
      fetch cDtConta into vData;
      close cDtConta;
    end if;
    close  cMaxRegFat;

    pReg_Fat.Dt_Guia         := pReg_Fat.Dsp_Dt_Val_Guia;
    pReg_Fat.Cd_Tip_Acom     := pReg_Fat.Dsp_Cd_Tip_Acom;
    pReg_Fat.Dsp_Ds_Tip_Acom := pReg_Fat.Dsp_Ds_Tip_Acom2;

    if vData.dt_inicio is not null then
      if vData.dt_final is not null then
           pReg_Fat.Dt_Inicio := to_date(to_char(trunc(vData.dt_final),'dd/mm/yyyy')||to_char(vData.dt_final + 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');
      else
        pReg_Fat.Dt_Inicio := to_date(to_char(trunc(vData.dt_inicio),'dd/mm/yyyy')||to_char(vData.dt_inicio + 1/1440,'hh24:mi'),'dd/mm/yyyy hh24:mi');
      end if;
    else
      pReg_Fat.Dt_Inicio   := to_date(to_char(nvl(pREG_FAT.DSP_DT_ATENDIMENTO, sysdate),'DD/MM/YYYY')||' '||to_char(nvl(pREG_FAT.DSP_HR_ATENDIMENTO, sysdate),'HH24:MI'),'DD/MM/YYYY HH24:MI');
    end if;

    pReg_Fat.Dt_Final        := to_date(to_char(pREG_FAT.DSP_DT_ATENDIMENTO,'DD/MM/YYYY')||' '||NVL(to_char(pREG_FAT.DSP_HR_ALTA,'HH24:MI'),'DD/MM/YYYY HH24:MI'), TO_CHAR(NULL));
    pReg_Fat.Cd_Convenio     := pReg_Fat.Dsp_Cd_Convenio;
    pReg_Fat.Cd_Con_pla      := vAtendimeCdConPla;
    pCG$CTRL.SN_NOVA_CONTA   := 'S';
  End If;

  Pkg_ffcv_M_LAN_HOS.P_CHK_CID(xml, pREG_FAT, formParams, pbSnLevantaExecessao,pbSnMostraMensagem);

  IF  pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO = 'P'
    AND (vAtendimeCdConvenioSecundario IS NULL OR  (vAtendimeCdConvenioSecundario IS NOT NULL AND (nCdAcoplamento IS NOT NULL OR (nCdAcoplamento IS NULL AND vTpConvSec = 'P'))))
    and nvl(vConvenioSnValidadeCarteira, 'N') = 'N' THEN

    -- Consulta dados do plano (Incio)
    -- OP 19191 - 06/05/2014 - melhoria de performance
    OPEN  cPlanoLista( vAtendimeCdConPla, pREG_FAT.CD_CONVENIO, formParams.P_MIG_CD_MULTI_EMPRESA );
    FETCH cPlanoLista INTO cDsp_Ds_Con_Pla, nCdRegra;
    CLOSE cPlanoLista;

    -- Consulta dados do plano (Fim)
    nCd_Con_Pla                      := vAtendimeCdConPla ;
    pREG_FAT.DSP_NR_CARTEIRA         := null ;
    pREG_FAT.DSP_DT_VALIDADE         := null ;
    pREG_FAT.DSP_NM_TITULAR          := null ;
    pREG_FAT.DSP_NM_EMPRESA          := null ;
    pREG_FAT.DSP_CD_EMPRESA_CARTEIRA := Null ;
    pREG_FAT.DSP_CD_REGRA            := nCdRegra ;
    pREG_FAT.DSP_CD_CATEGORIA        := Null ;
    pREG_FAT.DSP_DS_CATEGORIA        := Null ;
    pREG_FAT.DSP_SN_TITULAR          := 'S' ;
    pREG_FAT.DSP_SN_PENSIONISTA      := 'S' ;

  ELSE

    Open C1;
    Fetch C1 Into
            pREG_FAT.DSP_NR_CARTEIRA
          , pREG_FAT.DSP_DT_VALIDADE
          , pREG_FAT.DSP_NM_TITULAR
          ,nCd_Con_Pla
          ,cDsp_Ds_Con_Pla
          , pREG_FAT.DSP_NM_EMPRESA
          , pREG_FAT.DSP_CD_EMPRESA_CARTEIRA
          , pREG_FAT.DSP_CD_REGRA
          , pREG_FAT.DSP_CD_CATEGORIA
          , pREG_FAT.DSP_DS_CATEGORIA
          , pREG_FAT.DSP_SN_TITULAR
          , pREG_FAT.DSP_SN_PENSIONISTA ;
     Close C1;

     formParams.p_nr_carteira := preg_fat.dsp_nr_carteira;
  END IF;

  If  FSV_RECORD_STATUS = 'INSERT' Then
    pREG_FAT.CD_CON_PLA       := nCd_Con_Pla;
    pREG_FAT.DSP_DS_CON_PLA   := cDsp_Ds_Con_Pla;
    pREG_FAT.CD_REGRA         := pREG_FAT.DSP_CD_REGRA ;
    pREG_FAT.CD_MULTI_EMPRESA := formParams.P_MIG_CD_MULTI_EMPRESA;
    Pkg_ffcv_M_LAN_HOS.P_CTRL_REG_FAT_BLOCK(xml, pREG_FAT, pCG$CTRL, formParams) ;
    PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CONVENIO','ITEM_IS_VALID',true) ;
    PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CON_PLA','ITEM_IS_VALID',true) ;
    PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REGRA','ITEM_IS_VALID',true) ;
    PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REMESSA','ITEM_IS_VALID',true) ;

    if  pREG_FAT.DSP_TP_CONVENIO <> 'P' then
      if nvl(vTpConvenioConta,'P') <> 'P' then
         pREG_FAT.CD_REMESSA := Pkg_ffcv_M_LAN_HOS.F_GET_REMESSA(xml, pREG_FAT, formParams, pREG_FAT.CD_CONVENIO,
                                              pREG_FAT.DSP_CD_ORI_ATE,
                                              TRUNC(pREG_FAT.DT_INICIO))  ;
        end if;
    end if ;
  end if ;

  if  pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO = 'H' and  FSV_Record_Status not in ( 'INSERT', 'NEW' )THEN
    Raise Form_Trigger_Failure ;
  end if ;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END;

PROCEDURE P_CHK_REG_FAT_REG_FAT_ATEND (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    preg_fat REG_FATRec;
    pcg$ctrl CG$CTRLRec;
    global GlobalsRec;
    formParams FormParamsRec;
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_CD_PACIENTE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_DT_ATENDIMENTO:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO');
        pREG_FAT.DSP_HR_ATENDIMENTO:= PKG_XML.GetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO');
        pREG_FAT.DSP_CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_DT_ALTA:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ALTA');
        pREG_FAT.DSP_HR_ALTA:= PKG_XML.GetDate(xml, 'REG_FAT.DSP_HR_ALTA');
        pREG_FAT.DSP_CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_PRESTADOR');
        pREG_FAT.DSP_CD_CID:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_CD_CID');
        pREG_FAT.DSP_CD_CONVENIO_SECUNDARIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO_SECUNDARIO');
        pREG_FAT.DSP_CD_CON_PLA_SECUNDARIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CON_PLA_SECUNDARIO');
        pREG_FAT.DSP_CD_ESPECIALID:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ESPECIALID');
        pREG_FAT.DSP_EMPRESA_ATENDIME:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_EMPRESA_ATENDIME');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
        pREG_FAT.DSP_DS_TIP_ACOM2:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_TIP_ACOM2');
        pREG_FAT.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NM_PRESTADOR');
        pREG_FAT.DSP_DS_ORI_ATE:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_ORI_ATE');
        pREG_FAT.DSP_NM_PACIENTE:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NM_PACIENTE');
        pREG_FAT.DSP_TP_SEXO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_SEXO');
        pREG_FAT.DSP_TP_FORMA_AGRUPAMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_FORMA_AGRUPAMENTO');
        pREG_FAT.DSP_TP_IMPORTAR_MATMED:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_IMPORTAR_MATMED');
        pREG_FAT.DSP_NM_CONVENIO_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NM_CONVENIO_ATENDIMENTO');
        pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO_ATENDIMENTO');
        pREG_FAT.DSP_CD_FOR_APRE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_FOR_APRE');
        pREG_FAT.DSP_SN_PERTENCE_PACOTE:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_PERTENCE_PACOTE');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.DSP_CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO');
        pREG_FAT.CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_MULTI_EMPRESA');
        pREG_FAT.CD_PRO_FAT_SOLICITADO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.CD_PRO_FAT_SOLICITADO');
        pREG_FAT.DT_GUIA:= PKG_XML.GetDATE(xml, 'REG_FAT.DT_GUIA');
        pREG_FAT.DSP_DT_VAL_GUIA:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_VAL_GUIA');
        pREG_FAT.CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_TIP_ACOM');
        pREG_FAT.DSP_DS_TIP_ACOM:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_TIP_ACOM');
        pREG_FAT.DT_INICIO:= PKG_XML.GetDate(xml, 'REG_FAT.DT_INICIO');
        pREG_FAT.DT_FINAL:= PKG_XML.GetDate(xml, 'REG_FAT.DT_FINAL');
        pREG_FAT.DSP_NR_CARTEIRA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NR_CARTEIRA');
        pREG_FAT.DSP_DT_VALIDADE:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_VALIDADE');
        pREG_FAT.DSP_NM_TITULAR:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NM_TITULAR');
        pREG_FAT.DSP_NM_EMPRESA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NM_EMPRESA');
        pREG_FAT.DSP_CD_EMPRESA_CARTEIRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_EMPRESA_CARTEIRA');
        pREG_FAT.DSP_CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_REGRA');
        pREG_FAT.DSP_CD_CATEGORIA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA');
        pREG_FAT.DSP_DS_CATEGORIA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_CATEGORIA');
        pREG_FAT.DSP_SN_TITULAR:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_TITULAR');
        pREG_FAT.DSP_SN_PENSIONISTA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_PENSIONISTA');
        pREG_FAT.DSP_DS_CON_PLA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_CON_PLA');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        pREG_FAT.CD_REMESSA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REMESSA');
        pREG_FAT.CD_REG_FAT_PAI:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT_PAI');
        pREG_FAT.SN_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FECHADA');
        pREG_FAT.SN_FATURA_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA');
        pREG_FAT.TP_MVTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.TP_MVTO');
        pREG_FAT.DSP_SN_FECHADA_REMESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_FECHADA_REMESSA');
        pREG_FAT.DSP_DS_CID:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_CID');
        pREG_FAT.DSP_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA');
        pREG_FAT.DSP_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA');
        pREG_FAT.SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA');
        pREG_FAT.DSP_SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA');
        pCG$CTRL.SN_NOVA_CONTA:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.SN_NOVA_CONTA');
        pCG$CTRL.SN_IMPRIME:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.SN_IMPRIME');
        global.CD_PRO_INT:= PKG_XML.GetVARCHAR2(xml, 'GLOBAL.CD_PRO_INT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_NR_CARTEIRA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_NR_CARTEIRA');
        formParams.P_MIG_SN_RELACIONADA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_RELACIONADA');
        formParams.P_MIG_SN_ABRE_FECHA_CONTA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ABRE_FECHA_CONTA');
        formParams.P_MIG_SN_REMESSA_AUTOMATICA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_REMESSA_AUTOMATICA');
        formParams.P_MIG_SN_MOSTRA_VL_ORIG:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MOSTRA_VL_ORIG');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        formParams.P_MIG_SN_AUDITORIA_CONTA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_AUDITORIA_CONTA');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_REG_FAT_REG_FAT_ATEND_E(xml) THEN
                P_CHK_REG_FAT_REG_FAT_ATEND(xml, pREG_FAT, pCG$CTRL, global, formParams, FSV_RECORD_STATUS, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_REG_FAT_REG_FAT_ATEND_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE', pREG_FAT.DSP_CD_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO', pREG_FAT.DSP_DT_ATENDIMENTO);
        PKG_XML.SetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO', pREG_FAT.DSP_HR_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM', pREG_FAT.DSP_CD_TIP_ACOM);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ALTA', pREG_FAT.DSP_DT_ALTA);
        PKG_XML.SetDate(xml, 'REG_FAT.DSP_HR_ALTA', pREG_FAT.DSP_HR_ALTA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_PRESTADOR', pREG_FAT.DSP_CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_CD_CID', pREG_FAT.DSP_CD_CID);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO_SECUNDARIO', pREG_FAT.DSP_CD_CONVENIO_SECUNDARIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CON_PLA_SECUNDARIO', pREG_FAT.DSP_CD_CON_PLA_SECUNDARIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ESPECIALID', pREG_FAT.DSP_CD_ESPECIALID);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_EMPRESA_ATENDIME', pREG_FAT.DSP_EMPRESA_ATENDIME);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_TIP_ACOM2', pREG_FAT.DSP_DS_TIP_ACOM2);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NM_PRESTADOR', pREG_FAT.DSP_NM_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_ORI_ATE', pREG_FAT.DSP_DS_ORI_ATE);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NM_PACIENTE', pREG_FAT.DSP_NM_PACIENTE);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_SEXO', pREG_FAT.DSP_TP_SEXO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_FORMA_AGRUPAMENTO', pREG_FAT.DSP_TP_FORMA_AGRUPAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_IMPORTAR_MATMED', pREG_FAT.DSP_TP_IMPORTAR_MATMED);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NM_CONVENIO_ATENDIMENTO', pREG_FAT.DSP_NM_CONVENIO_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO_ATENDIMENTO', pREG_FAT.DSP_TP_CONVENIO_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_FOR_APRE', pREG_FAT.DSP_CD_FOR_APRE);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_PERTENCE_PACOTE', pREG_FAT.DSP_SN_PERTENCE_PACOTE);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO', pREG_FAT.DSP_CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_MULTI_EMPRESA', pREG_FAT.CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.CD_PRO_FAT_SOLICITADO', pREG_FAT.CD_PRO_FAT_SOLICITADO);
        PKG_XML.SetDATE(xml, 'REG_FAT.DT_GUIA', pREG_FAT.DT_GUIA);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_VAL_GUIA', pREG_FAT.DSP_DT_VAL_GUIA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_TIP_ACOM', pREG_FAT.CD_TIP_ACOM);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_TIP_ACOM', pREG_FAT.DSP_DS_TIP_ACOM);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_INICIO', pREG_FAT.DT_INICIO);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_FINAL', pREG_FAT.DT_FINAL);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NR_CARTEIRA', pREG_FAT.DSP_NR_CARTEIRA);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_VALIDADE', pREG_FAT.DSP_DT_VALIDADE);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NM_TITULAR', pREG_FAT.DSP_NM_TITULAR);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NM_EMPRESA', pREG_FAT.DSP_NM_EMPRESA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_EMPRESA_CARTEIRA', pREG_FAT.DSP_CD_EMPRESA_CARTEIRA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_REGRA', pREG_FAT.DSP_CD_REGRA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA', pREG_FAT.DSP_CD_CATEGORIA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_CATEGORIA', pREG_FAT.DSP_DS_CATEGORIA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_TITULAR', pREG_FAT.DSP_SN_TITULAR);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_PENSIONISTA', pREG_FAT.DSP_SN_PENSIONISTA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_CON_PLA', pREG_FAT.DSP_DS_CON_PLA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REMESSA', pREG_FAT.CD_REMESSA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT_PAI', pREG_FAT.CD_REG_FAT_PAI);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FECHADA', pREG_FAT.SN_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA', pREG_FAT.SN_FATURA_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.TP_MVTO', pREG_FAT.TP_MVTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_FECHADA_REMESSA', pREG_FAT.DSP_SN_FECHADA_REMESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_CID', pREG_FAT.DSP_DS_CID);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA', pREG_FAT.DSP_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA', pREG_FAT.DSP_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA', pREG_FAT.SN_CONTA_CALCULADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA', pREG_FAT.DSP_SN_CONTA_CALCULADA);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.SN_NOVA_CONTA', pCG$CTRL.SN_NOVA_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.SN_IMPRIME', pCG$CTRL.SN_IMPRIME);
        PKG_XML.SetVARCHAR2(xml, 'GLOBAL.CD_PRO_INT', global.CD_PRO_INT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_NR_CARTEIRA', formParams.P_NR_CARTEIRA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_RELACIONADA', formParams.P_MIG_SN_RELACIONADA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ABRE_FECHA_CONTA', formParams.P_MIG_SN_ABRE_FECHA_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_REMESSA_AUTOMATICA', formParams.P_MIG_SN_REMESSA_AUTOMATICA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MOSTRA_VL_ORIG', formParams.P_MIG_SN_MOSTRA_VL_ORIG);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_AUDITORIA_CONTA', formParams.P_MIG_SN_AUDITORIA_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CGFK$CHK_ITREG_FAT_ITREG_FAT_G</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_ITREG_FAT_ITREG_FAT_G (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_relacionado IN OUT NOCOPY ITREG_FAT_RELACIONADORec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
                                           pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec, preg_fat IN OUT NOCOPY REG_FATRec, var IN OUT NOCOPY VARRec, formParams IN OUT NOCOPY FormParamsRec,
										   cSintetico in VarChar2 Default 'F', pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) IS
     CURSOR cExisteConfiguracao(nCdGruFat in number, nCdForApre in number) IS
       SELECT 'x'
         FROM dbamv.gru_fat gru_fat
            , dbamv.itfor_apre itfor_apre
        WHERE gru_fat.cd_gru_fat = nCdGruFat
          AND itfor_apre.cd_for_apre = nCdForApre
          AND itfor_apre.cd_gru_fat = gru_fat.cd_gru_fat
          AND Nvl(sn_ativo,'N') = 'S';

    nCdGruFat        number;
    vDsGruFat        varchar2(2000);
    vTpGruFat        varchar2(2000);
    vSnValidarGruFat varchar2(2000);
    vSnCadastraQtd   varchar2(2000);
    vSnCadastraData  varchar2(2000);
    vSnCadastraCrm   varchar2(2000);
    vSnCadastraValor varchar2(2000);
    vTpDtReferenciaLancamento varchar2(2000);
    vSnCadastraPercPaciente   varchar2(2000);
    vRetorno                  varchar2(1);
    bExiste                   boolean := false;

    vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
    vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  BEGIN
    if cSintetico = 'F' then
        nCdGruFat := pITREG_FAT.CD_GRU_FAT;
    elsif cSintetico = 'R' then
        nCdGruFat := pITREG_FAT_RELACIONADO.CD_GRU_FAT;
    elsif cSintetico = 'E' then
        nCdGruFat := pITREG_FAT_REL.CD_GRU_FAT;
    else
        nCdGruFat := pITREG_FAT_SINTETICO.CD_GRU_FAT;
    end if ;

    M_PKG_FFCV_GRU_FAT.P_RETORNA_DADOS(xml, nCdGruFat
                                          , formParams.P_MIG_CD_MULTI_EMPRESA
                                          , formParams.P_MIG_CD_USUARIO
                                          , pbSnLevantaExecessao
                                          , pbSnMostraMensagem
                                          , vLst_Retorno);
    --
    vLst_Local  := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_Retorno);
    --
    -- Recuperao dos parametros retornados pela Procedure
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'DS_GRU_FAT'        , vDsGruFat, false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'TP_GRU_FAT'        , vTpGruFat, false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'SN_VALIDAR_GRU_FAT', vSnValidarGruFat, false);
    --
    -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
    PKG_PARAMETRO.pr_limpar_lista_parametros(vLst_Retorno);
    --
    M_PKG_FFCV_ITFOR_APRE.P_RETORNA_DADOS(xml, pREG_FAT.DSP_CD_FOR_APRE
                                            , nCdGruFat
                                            , formParams.P_MIG_CD_MULTI_EMPRESA
                                            , formParams.P_MIG_CD_USUARIO
                                            , pbSnLevantaExecessao
                                            , pbSnMostraMensagem
                                            , vLst_Retorno);
    --
    vLst_Local  := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_Retorno);
    --
    -- Recuperao dos parametros retornados pela Procedure
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'SN_CADASTRA_QTD' , vSnCadastraQtd, false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'SN_CADASTRA_DATA', vSnCadastraData, false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'SN_CADASTRA_CRM' , vSnCadastraCrm, false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'SN_CADASTRA_VALOR' , vSnCadastraValor, false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'TP_DT_REFERENCIA_LANCAMENTO', vTpDtReferenciaLancamento, false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'SN_CADASTRA_PERC_PACIENTE', vSnCadastraPercPaciente, false);
    --
    -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
    PKG_PARAMETRO.pr_limpar_lista_parametros(vLst_Retorno);

    open  cExisteConfiguracao(nCdGruFat, pREG_FAT.DSP_CD_FOR_APRE);
    fetch cExisteConfiguracao into vRetorno;
    bExiste := cExisteConfiguracao%found;
    close cExisteConfiguracao;

    if not bExiste and pbSnMostraMensagem then
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_2)
      PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_2', 'PKG_FFCV_M_LAN_HOS',
			  'Atenção: O grupo de faturamento %s-%s não esta configurado para a forma de Apresentação %s!', arg_list(nCdGruFat, vDsGruFat, pREG_FAT.DSP_CD_FOR_APRE)), 'W', pbSnLevantaExecessao);
    end if;

    if cSintetico = 'F' then
      pITREG_FAT.DSP_DS_GRU_FAT                 := vDsGruFat;
      pITREG_FAT.DSP_TP_GRU_FAT                 := vTpGruFat;
      pITREG_FAT.DSP_SN_CADASTRA_QTD            := vSnCadastraQtd;
      pITREG_FAT.DSP_SN_CADASTRA_DATA           := vSnCadastraData;
      pITREG_FAT.DSP_SN_CADASTRA_CRM            := vSnCadastraCrm;
      pITREG_FAT.DSP_SN_CADASTRA_VALOR          := vSnCadastraValor;
      pITREG_FAT.DSP_TP_DT_REFERENCIA_LANCAMENT := vTpDtReferenciaLancamento;
      pITREG_FAT.DSP_SN_CADASTRA_PERC_PACIENTE  := vSnCadastraPercPaciente;
      VAR.VsnValidarGruFat                      := vSnValidarGruFat;

      If  pITREG_FAT.DSP_TP_GRU_FAT = 'MM' Then
        pITREG_FAT.DSP_TP_GRU_FAT := 'M%';
      End If;
    elsif cSintetico = 'R' then
      pITREG_FAT_RELACIONADO.DSP_DS_GRU_FAT                 := vDsGruFat;
      pITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT                 := vTpGruFat;
      pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_QTD            := vSnCadastraQtd;
      pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_DATA           := vSnCadastraData;
      pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_CRM            := vSnCadastraCrm;
      pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_VALOR          := vSnCadastraValor;
      pITREG_FAT_RELACIONADO.DSP_TP_DT_REFERENCIA_LANCAMENT := vTpDtReferenciaLancamento;
      pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_PERC_PACIENTE  := vSnCadastraPercPaciente;
      VAR.VsnValidarGruFat                                  := vSnValidarGruFat;

      If  pITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT = 'MM' Then
        pITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT := 'M%';
      End If;
    elsif cSintetico = 'E' then
      pITREG_FAT_REL.DSP_DS_GRU_FAT                 := vDsGruFat;
      pITREG_FAT_REL.DSP_TP_GRU_FAT                 := vTpGruFat;
      pITREG_FAT_REL.DSP_SN_CADASTRA_QTD            := vSnCadastraQtd;
      pITREG_FAT_REL.DSP_SN_CADASTRA_DATA           := vSnCadastraData;
      pITREG_FAT_REL.DSP_SN_CADASTRA_CRM            := vSnCadastraCrm;
      pITREG_FAT_REL.DSP_SN_CADASTRA_VALOR          := vSnCadastraValor;
      pITREG_FAT_REL.DSP_TP_DT_REFERENCIA_LANCAMENT := vTpDtReferenciaLancamento;
      pITREG_FAT_REL.DSP_SN_CADASTRA_PERC_PACIENTE  := vSnCadastraPercPaciente;
      VAR.VsnValidarGruFat                      := vSnValidarGruFat;

      If  pITREG_FAT_REL.DSP_TP_GRU_FAT = 'MM' Then
        pITREG_FAT_REL.DSP_TP_GRU_FAT := 'M%';
      End If;
    else
      pITREG_FAT_SINTETICO.DSP_DS_GRU_FAT                 := vDsGruFat;
      pITREG_FAT_SINTETICO.DSP_TP_GRU_FAT                 := vTpGruFat;
      pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_QTD            := vSnCadastraQtd;
      pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_DATA           := vSnCadastraData;
      pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_CRM            := vSnCadastraCrm;
      pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_VALOR          := vSnCadastraValor;
      pITREG_FAT_SINTETICO.DSP_TP_DT_REFERENCIA_LANCAMENT := vTpDtReferenciaLancamento;
      pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_PERC_PACIENTE  := vSnCadastraPercPaciente;
      VAR.VsnValidarGruFat                      := vSnValidarGruFat;

      If  pITREG_FAT_SINTETICO.DSP_TP_GRU_FAT = 'MM' Then
        pITREG_FAT_SINTETICO.DSP_TP_GRU_FAT := 'M%';
      End If;
    end if;
  END;

PROCEDURE P_CHK_ITREG_FAT_ITREG_FAT_G (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    cSintetico VarChar2(4000);
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    pitreg_fat ITREG_FATRec;
    pitreg_fat_relacionado ITREG_FAT_RELACIONADORec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    pitreg_fat_sintetico ITREG_FAT_SINTETICORec;
    preg_fat REG_FATRec;
    var VARRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_GRU_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_GRU_FAT');
        pITREG_FAT_REL.DSP_DS_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_DS_GRU_FAT');
        pITREG_FAT_REL.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_GRU_FAT');
        pITREG_FAT_REL.DSP_SN_CADASTRA_QTD:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_QTD');
        pITREG_FAT_REL.DSP_SN_CADASTRA_DATA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_DATA');
        pITREG_FAT_REL.DSP_SN_CADASTRA_CRM:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_CRM');
        pITREG_FAT_REL.DSP_SN_CADASTRA_VALOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_VALOR');
        pITREG_FAT_REL.DSP_TP_DT_REFERENCIA_LANCAMENT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_DT_REFERENCIA_LANCAMENT');
        pITREG_FAT_REL.DSP_SN_CADASTRA_PERC_PACIENTE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_PERC_PACIENTE');
        pREG_FAT.DSP_CD_FOR_APRE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_FOR_APRE');
        pITREG_FAT_SINTETICO.CD_GRU_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.CD_GRU_FAT');
        pITREG_FAT_SINTETICO.DSP_DS_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_DS_GRU_FAT');
        pITREG_FAT_SINTETICO.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_GRU_FAT');
        pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_QTD:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_QTD');
        pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_DATA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_DATA');
        pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_CRM:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_CRM');
        pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_VALOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_VALOR');
        pITREG_FAT_SINTETICO.DSP_TP_DT_REFERENCIA_LANCAMENT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_DT_REFERENCIA_LANCAMENT');
        pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_PERC_PACIENTE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_PERC_PACIENTE');
        pITREG_FAT_RELACIONADO.CD_GRU_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_RELACIONADO.CD_GRU_FAT');
        pITREG_FAT_RELACIONADO.DSP_DS_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_DS_GRU_FAT');
        pITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT');
        pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_QTD:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_QTD');
        pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_DATA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_DATA');
        pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_CRM:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_CRM');
        pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_VALOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_VALOR');
        pITREG_FAT_RELACIONADO.DSP_TP_DT_REFERENCIA_LANCAMENT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_DT_REFERENCIA_LANCAMENT');
        pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_PERC_PACIENTE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_PERC_PACIENTE');
        pITREG_FAT.CD_GRU_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_GRU_FAT');
        pITREG_FAT.DSP_DS_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_DS_GRU_FAT');
        pITREG_FAT.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT');
        pITREG_FAT.DSP_SN_CADASTRA_QTD:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_QTD');
        pITREG_FAT.DSP_SN_CADASTRA_DATA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_DATA');
        pITREG_FAT.DSP_SN_CADASTRA_CRM:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_CRM');
        pITREG_FAT.DSP_SN_CADASTRA_VALOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_VALOR');
        pITREG_FAT.DSP_TP_DT_REFERENCIA_LANCAMENT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_DT_REFERENCIA_LANCAMENT');
        pITREG_FAT.DSP_SN_CADASTRA_PERC_PACIENTE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_PERC_PACIENTE');
        var.vSnValidarGruFat:= PKG_XML.GetVarchar2(xml, 'VAR.VSNVALIDARGRUFAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        cSintetico:= PKG_XML.GetVarChar2(xml, 'cSintetico');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITREG_FAT_ITREG_FAT_G_E(xml) THEN
                P_CHK_ITREG_FAT_ITREG_FAT_G(xml, pITREG_FAT, pITREG_FAT_RELACIONADO, pITREG_FAT_REL, pITREG_FAT_SINTETICO, pREG_FAT, VAR, formParams, cSintetico, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITREG_FAT_ITREG_FAT_G_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_GRU_FAT', pITREG_FAT_REL.CD_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_DS_GRU_FAT', pITREG_FAT_REL.DSP_DS_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_GRU_FAT', pITREG_FAT_REL.DSP_TP_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_QTD', pITREG_FAT_REL.DSP_SN_CADASTRA_QTD);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_DATA', pITREG_FAT_REL.DSP_SN_CADASTRA_DATA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_CRM', pITREG_FAT_REL.DSP_SN_CADASTRA_CRM);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_VALOR', pITREG_FAT_REL.DSP_SN_CADASTRA_VALOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_DT_REFERENCIA_LANCAMENT', pITREG_FAT_REL.DSP_TP_DT_REFERENCIA_LANCAMENT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_SN_CADASTRA_PERC_PACIENTE', pITREG_FAT_REL.DSP_SN_CADASTRA_PERC_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_FOR_APRE', pREG_FAT.DSP_CD_FOR_APRE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.CD_GRU_FAT', pITREG_FAT_SINTETICO.CD_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_DS_GRU_FAT', pITREG_FAT_SINTETICO.DSP_DS_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_GRU_FAT', pITREG_FAT_SINTETICO.DSP_TP_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_QTD', pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_QTD);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_DATA', pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_DATA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_CRM', pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_CRM);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_VALOR', pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_VALOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_DT_REFERENCIA_LANCAMENT', pITREG_FAT_SINTETICO.DSP_TP_DT_REFERENCIA_LANCAMENT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_SN_CADASTRA_PERC_PACIENTE', pITREG_FAT_SINTETICO.DSP_SN_CADASTRA_PERC_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_RELACIONADO.CD_GRU_FAT', pITREG_FAT_RELACIONADO.CD_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_DS_GRU_FAT', pITREG_FAT_RELACIONADO.DSP_DS_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT', pITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_QTD', pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_QTD);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_DATA', pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_DATA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_CRM', pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_CRM);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_VALOR', pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_VALOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_DT_REFERENCIA_LANCAMENT', pITREG_FAT_RELACIONADO.DSP_TP_DT_REFERENCIA_LANCAMENT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_PERC_PACIENTE', pITREG_FAT_RELACIONADO.DSP_SN_CADASTRA_PERC_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_GRU_FAT', pITREG_FAT.CD_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_DS_GRU_FAT', pITREG_FAT.DSP_DS_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT', pITREG_FAT.DSP_TP_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_QTD', pITREG_FAT.DSP_SN_CADASTRA_QTD);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_DATA', pITREG_FAT.DSP_SN_CADASTRA_DATA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_CRM', pITREG_FAT.DSP_SN_CADASTRA_CRM);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_VALOR', pITREG_FAT.DSP_SN_CADASTRA_VALOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_DT_REFERENCIA_LANCAMENT', pITREG_FAT.DSP_TP_DT_REFERENCIA_LANCAMENT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_PERC_PACIENTE', pITREG_FAT.DSP_SN_CADASTRA_PERC_PACIENTE);
        PKG_XML.SetVarchar2(xml, 'VAR.VSNVALIDARGRUFAT', var.vSnValidarGruFat);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CGFK$CHK_ITREG_FAT_ITREG_FAT_P</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_ITREG_FAT_ITREG_FAT_P (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat_relacionado IN OUT NOCOPY ITREG_FAT_RELACIONADORec,
	                                       pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2,
										   P_FIELD_LEVEL IN BOOLEAN, cSintetico in VarChar2 Default 'F') IS
    CURSOR C IS
      SELECT PRO_FAT1.DS_PRO_FAT
           , PRO_FAT1.NR_AUXILIAR
           , PRO_FAT1.CD_POR_ANE
           , PRO_FAT1.TP_SEXO
           , PRO_FAT1.CD_GRU_PRO
           , PRO_FAT1.QTD_MAXIMA
           , PRO_FAT1.DS_UNIDADE
           , Nvl(PRO_FAT1.SN_ATIVO, 'S' ) SN_ATIVO
           , PRO_FAT1.CD_GRU_PRO
        FROM DBAMV.PRO_FAT PRO_FAT1
       WHERE PRO_FAT1.CD_PRO_FAT = Decode( cSintetico, 'F', pITREG_FAT.CD_PRO_FAT, 'E', pITREG_FAT_REL.CD_PRO_FAT, 'R', pITREG_FAT_RELACIONADO.CD_PRO_FAT, pITREG_FAT_SINTETICO.CD_PRO_FAT);

    cursor cTpGruPro (pnCdGruPro in number) is
      select GRU_PRO.TP_GRU_PRO
        from DBAMV.GRU_PRO GRU_PRO
       WHERE gru_pro.cd_gru_pro = pnCdGruPro;

  /*
      SELECT PRO_FAT1.DS_PRO_FAT
            ,PRO_FAT1.NR_AUXILIAR
            ,PRO_FAT1.CD_POR_ANE
            ,PRO_FAT1.TP_SEXO
            ,PRO_FAT1.CD_GRU_PRO
            ,PRO_FAT1.QTD_MAXIMA
            ,PRO_FAT1.DS_UNIDADE
            ,GRU_PRO.TP_GRU_PRO
            ,Nvl( PRO_FAT1.SN_ATIVO, 'S' ) SN_ATIVO
      FROM   PRO_FAT PRO_FAT1
            ,GRU_PRO GRU_PRO
      WHERE  gru_pro.cd_gru_pro  = pro_fat1.cd_gru_pro
        and  PRO_FAT1.CD_PRO_FAT = Decode( cSintetico, 'F', pITREG_FAT.CD_PRO_FAT, 'E', pITREG_FAT_REL.CD_PRO_FAT, 'R', pITREG_FAT_RELACIONADO.CD_PRO_FAT, pITREG_FAT_SINTETICO.CD_PRO_FAT )
        and  gru_pro.tp_gru_pro  like
             decode( FSV_mode, 'NORMAL', Decode( cSintetico, 'F', pitreg_fat.dsp_tp_gru_fat,  'E', pitreg_fat_REL.dsp_tp_gru_fat, 'R', pITREG_FAT_RELACIONADO.dsp_tp_gru_fat, pitreg_fat_sintetico.dsp_tp_gru_fat ), 'QUERY', '%' );

    cursor cTpGruPro (pnCdGruPro in number) is
      select GRU_PRO.TP_GRU_PRO
        from GRU_PRO GRU_PRO
       WHERE gru_pro.cd_gru_pro = pnCdGruPro
         and gru_pro.tp_gru_pro  like
             decode( FSV_mode, 'NORMAL', Decode( cSintetico, 'F', pitreg_fat.dsp_tp_gru_fat,  'E', pitreg_fat_REL.dsp_tp_gru_fat, 'R', pITREG_FAT_RELACIONADO.dsp_tp_gru_fat, pitreg_fat_sintetico.dsp_tp_gru_fat ), 'QUERY', '%' );

    */

    bLocalizouProcedimento boolean := false;
    bLocalizouTpGruPro     boolean := false;
    vCdProFat              varchar2(100);
    vTpGruFat              varchar2(100);
    vTpGruPro              varchar2(100);
    vSnAtivo               varchar2(1);
    nCdGruPro              number;
    nCdGruFat              number;
BEGIN
    OPEN C;
    if cSintetico = 'F' then
      FETCH C
      INTO    pITREG_FAT.DSP_DS_PRO_FAT
            , pITREG_FAT.DSP_NR_AUXILIAR
            , pITREG_FAT.DSP_CD_POR_ANE
            , pITREG_FAT.DSP_TP_SEXO
            , pITREG_FAT.DSP_CD_GRU_PRO
            , pITREG_FAT.DSP_QTD_MAXIMA
            , pITREG_FAT.DSP_DS_UNIDADE
            , pITREG_FAT.DSP_PRO_FAT_SN_ATIVO
            , nCdGruPro;
      bLocalizouProcedimento := C%found;

      -- Pesquisa informaes do grupo de procedimento
      open  cTpGruPro(nCdGruPro);
      fetch cTpGruPro into pITREG_FAT.DSP_TP_GRU_PRO;
      bLocalizouTpGruPro := cTpGruPro%found;
      close cTpGruPro;

      -- Carrega variveis locais para validaes
      vCdProFat := pITREG_FAT.CD_PRO_FAT;
      vTpGruFat := pITREG_FAT.DSP_TP_GRU_FAT;
      vTpGruPro := pITREG_FAT.DSP_TP_GRU_PRO;
      vSnAtivo  := pITREG_FAT.DSP_PRO_FAT_SN_ATIVO;
      nCdGruFat := pITREG_FAT.CD_GRU_FAT;

    elsif cSintetico = 'R' then
      FETCH C
      INTO    pITREG_FAT_RELACIONADO.DSP_DS_PRO_FAT
            , pITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR
            , pITREG_FAT_RELACIONADO.DSP_CD_POR_ANE
            , pITREG_FAT_RELACIONADO.DSP_TP_SEXO
            , pITREG_FAT_RELACIONADO.DSP_CD_GRU_PRO
            , pITREG_FAT_RELACIONADO.DSP_QTD_MAXIMA
            , pITREG_FAT_RELACIONADO.DSP_DS_UNIDADE
            , pITREG_FAT_RELACIONADO.DSP_PRO_FAT_SN_ATIVO
            , nCdGruPro;
      bLocalizouProcedimento := C%found;

      -- Pesquisa informaes do grupo de procedimento
      open  cTpGruPro(nCdGruPro);
      fetch cTpGruPro into pITREG_FAT_RELACIONADO.DSP_TP_GRU_PRO;
      bLocalizouTpGruPro := cTpGruPro%found;
      close cTpGruPro;

      -- Carrega variveis locais para validaes
      vCdProFat := pITREG_FAT_RELACIONADO.CD_PRO_FAT;
      vTpGruFat := pITREG_FAT_RELACIONADO.dsp_tp_gru_fat;
      vTpGruPro := pITREG_FAT_RELACIONADO.DSP_TP_GRU_PRO;
      vSnAtivo  := pITREG_FAT_RELACIONADO.DSP_PRO_FAT_SN_ATIVO;
      nCdGruFat := pITREG_FAT_RELACIONADO.CD_GRU_FAT;

    elsif cSintetico = 'E' then
      FETCH C
      INTO    pITREG_FAT_REL.DSP_DS_PRO_FAT
            , pITREG_FAT_REL.DSP_NR_AUXILIAR
            , pITREG_FAT_REL.DSP_CD_POR_ANE
            , pITREG_FAT_REL.DSP_TP_SEXO
            , pITREG_FAT_REL.DSP_CD_GRU_PRO
            , pITREG_FAT_REL.DSP_QTD_MAXIMA
            , pITREG_FAT_REL.DSP_DS_UNIDADE
            , pITREG_FAT_REL.DSP_PRO_FAT_SN_ATIVO
            , nCdGruPro;
      bLocalizouProcedimento := C%found;

      -- Pesquisa informaes do grupo de procedimento
      open  cTpGruPro(nCdGruPro);
      fetch cTpGruPro into pITREG_FAT_REL.DSP_TP_GRU_PRO;
      bLocalizouTpGruPro := cTpGruPro%found;
      close cTpGruPro;

      -- Carrega variveis locais para validaes
      vCdProFat := pitreg_fat_REL.CD_PRO_FAT;
      vTpGruFat := pitreg_fat_REL.dsp_tp_gru_fat;
      vTpGruPro := pitreg_fat_REL.DSP_TP_GRU_PRO;
      vSnAtivo  := pitreg_fat_REL.DSP_PRO_FAT_SN_ATIVO;
      nCdGruFat := pitreg_fat_REL.CD_GRU_FAT;
    else
      FETCH C
      INTO    pITREG_FAT_SINTETICO.DSP_DS_PRO_FAT
            , pITREG_FAT_SINTETICO.DSP_NR_AUXILIAR
            , pITREG_FAT_SINTETICO.DSP_CD_POR_ANE
            , pITREG_FAT_SINTETICO.DSP_TP_SEXO
            , pITREG_FAT_SINTETICO.DSP_CD_GRU_PRO
            , pITREG_FAT_SINTETICO.DSP_QTD_MAXIMA
            , pITREG_FAT_SINTETICO.DSP_DS_UNIDADE
            , pITREG_FAT_SINTETICO.DSP_PRO_FAT_SN_ATIVO
            , nCdGruPro;
      bLocalizouProcedimento := C%found;

      -- Pesquisa informaes do grupo de procedimento
      open  cTpGruPro(nCdGruPro);
      fetch cTpGruPro into pITREG_FAT_SINTETICO.DSP_TP_GRU_PRO;
      bLocalizouTpGruPro := cTpGruPro%found;
      close cTpGruPro;

      -- Carrega variveis locais para validaes
      vCdProFat := pitreg_fat_sintetico.CD_PRO_FAT;
      vTpGruFat := pitreg_fat_sintetico.dsp_tp_gru_fat;
      vTpGruPro := pitreg_fat_sintetico.DSP_TP_GRU_PRO;
      vSnAtivo  := pitreg_fat_sintetico.DSP_PRO_FAT_SN_ATIVO;
      nCdGruFat := pitreg_fat_sintetico.CD_GRU_FAT;
   end if ;
   CLOSE C;

   -- Realiza validaes se o procedimento estiver ativo
   if FSV_mode <> 'QUERY' then
      if not bLocalizouProcedimento then
        -- Procedimento não existe
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_3)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_3', 'PKG_FFCV_M_LAN_HOS', 'Atenção: O procedimento (%s) não cadastrado!', arg_list(vCdProFat)), 'W', True) ;
      else
        if nvl(vSnAtivo, 'S') = 'N' then
          -- Procedimento esta inativo
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_4)
          PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_4', 'PKG_FFCV_M_LAN_HOS', 'Atenção: O procedimento (%s) não esta ativo!', arg_list(vCdProFat)), 'W', True) ;
        end if;
      end if;

      if not bLocalizouTpGruPro then
        -- Grupo de procedimento não localizado
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_5)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_5', 'PKG_FFCV_M_LAN_HOS', 'Atenção: não foi possível localizar o grupo de procedimento (%s) do procedimento %s.', arg_list(nCdGruPro, vCdProFat)), 'W', True) ;
      else
        -- Verifica tipo de grupo de procedimento x tipo de grupo de faturamento
        /*PDA 443431 (inicio)- Jansen Gallindo - correo abaixo para levar em considerA??o vTpGruPro = MM com vTpGruFat = M%*/
        --if nvl(vTpGruPro, 'X') <> nvl(vTpGruFat, 'X') then
        if not(nvl(vTpGruPro, 'X') like nvl(vTpGruFat, 'X')) then
        /*PDA 443431 (fim)- Jansen Gallindo*/

          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_6)
          PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_6', 'PKG_FFCV_M_LAN_HOS',
					  'Atenção: Foi identificado um erro de configuração! %sO grupo de procedimento %s esta definido com o tipo %s, enquanto o grupo de faturamento %s esta definido com o tipo %s.:
						Para lançar o procedimento %s é necessário que os grupos sejam do mesmo tipo.', arg_list(chr(13), nCdGruPro, vTpGruPro, nCdGruFat, vTpGruFat, chr(13), vCdProFat)), 'W', True) ;
        end if;
      end if;
   end if;

  if cSintetico = 'F' then
      if not Pkg_ffcv_M_LAN_HOS.F_TEM_ACOPLAMENTO(xml, pREG_FAT, formParams,  pITREG_FAT.CD_PRO_FAT,  pITREG_FAT.DSP_CD_GRU_PRO) and  pITREG_FAT.CD_REGRA_ACOPLAMENTO is null then

          Declare

            nVlrPercParticip Number ;
            nVlrParticip     Number ;
            nQtPontos        Number ;
            nCdFranquia      Number ;

          Begin

              nCdFranquia := Franquia_FFCV( pREG_FAT.CD_CONVENIO,
                                                  pREG_FAT.CD_CON_PLA,
                                                  pITREG_FAT.CD_PRO_FAT,
                                                  pREG_FAT.DSP_TP_ATENDIMENTO,
                                                  pREG_FAT.DSP_CD_ESPECIALID,
                                                  pREG_FAT.DSP_CD_CATEGORIA,
                                                  pREG_FAT.DSP_SN_TITULAR,
                                                  pREG_FAT.DSP_SN_PENSIONISTA,
                                                  nVlrPercParticip,
                                                  nVlrParticip,
                                                  nQtPontos ) ;

            if  pITREG_FAT.VL_PERCENTUAL_PACIENTE is null and nVlrPercParticip is not null then
              pITREG_FAT.VL_PERCENTUAL_PACIENTE := ( 100 - nVlrPercParticip ) ;
            end if ;

            if  pITREG_FAT.CD_FRANQUIA is null and nCdFranquia is not null then
              pITREG_FAT.CD_FRANQUIA := nCdFranquia ;
            end if ;

          end ;
      END IF;
  elsif cSintetico = 'E' then
        if not Pkg_ffcv_M_LAN_HOS.F_TEM_ACOPLAMENTO(xml, pREG_FAT, formParams,  pITREG_FAT_REL.CD_PRO_FAT,  pITREG_FAT_REL.DSP_CD_GRU_PRO) and  pITREG_FAT_REL.CD_REGRA_ACOPLAMENTO is null then

          Declare

            nVlrPercParticip Number ;
            nVlrParticip     Number ;
            nQtPontos        Number ;
            nCdFranquia      Number ;

          Begin

              nCdFranquia := Franquia_FFCV( pREG_FAT.CD_CONVENIO,
                                                  pREG_FAT.CD_CON_PLA,
                                                  pITREG_FAT_REL.CD_PRO_FAT,
                                                  pREG_FAT.DSP_TP_ATENDIMENTO,
                                                  pREG_FAT.DSP_CD_ESPECIALID,
                                                  pREG_FAT.DSP_CD_CATEGORIA,
                                                  pREG_FAT.DSP_SN_TITULAR,
                                                  pREG_FAT.DSP_SN_PENSIONISTA,
                                                  nVlrPercParticip,
                                                  nVlrParticip,
                                                  nQtPontos ) ;

            if  pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE is null and nVlrPercParticip is not null then
              pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE := ( 100 - nVlrPercParticip ) ;
            end if ;

            if  pITREG_FAT_REL.CD_FRANQUIA is null and nCdFranquia is not null then
              pITREG_FAT_REL.CD_FRANQUIA := nCdFranquia ;
            end if ;

          end ;
        END IF;
  end if ;
END;

PROCEDURE P_CHK_ITREG_FAT_ITREG_FAT_P (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    P_FIELD_LEVEL BOOLEAN;
    cSintetico VarChar2(4000);
    pitreg_fat ITREG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    pitreg_fat_relacionado ITREG_FAT_RELACIONADORec;
    pitreg_fat_sintetico ITREG_FAT_SINTETICORec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    FSV_MODE VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);

        -- extract input parameters from the XML
        -- Bloco ITREG_FAT
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.CD_GRU_FAT := PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_GRU_FAT');
        pITREG_FAT.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT');
        pITREG_FAT.DSP_DS_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_DS_PRO_FAT');
        pITREG_FAT.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_NR_AUXILIAR');
        pITREG_FAT.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_CD_POR_ANE');
        pITREG_FAT.DSP_TP_SEXO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_SEXO');
        pITREG_FAT.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO');
        pITREG_FAT.DSP_QTD_MAXIMA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_QTD_MAXIMA');
        pITREG_FAT.DSP_DS_UNIDADE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_DS_UNIDADE');
        pITREG_FAT.DSP_TP_GRU_PRO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_PRO');
        pITREG_FAT.DSP_PRO_FAT_SN_ATIVO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_PRO_FAT_SN_ATIVO');
        pITREG_FAT.CD_REGRA_ACOPLAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO');
        pITREG_FAT.VL_PERCENTUAL_PACIENTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE');
        pITREG_FAT.CD_FRANQUIA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA');

        -- Bloco ITREG_FAT_REL
        pITREG_FAT_REL.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT');
        pITREG_FAT_REL.CD_GRU_FAT := PKG_XML.GetNUMBER(xml, 'pITREG_FAT_REL.CD_GRU_FAT');
        pITREG_FAT_REL.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_GRU_FAT');
        pITREG_FAT_REL.DSP_DS_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_DS_PRO_FAT');
        pITREG_FAT_REL.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_NR_AUXILIAR');
        pITREG_FAT_REL.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_POR_ANE');
        pITREG_FAT_REL.DSP_TP_SEXO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_SEXO');
        pITREG_FAT_REL.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_GRU_PRO');
        pITREG_FAT_REL.DSP_QTD_MAXIMA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_QTD_MAXIMA');
        pITREG_FAT_REL.DSP_DS_UNIDADE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_DS_UNIDADE');
        pITREG_FAT_REL.DSP_TP_GRU_PRO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_GRU_PRO');
        pITREG_FAT_REL.DSP_PRO_FAT_SN_ATIVO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_PRO_FAT_SN_ATIVO');
        pITREG_FAT_REL.CD_REGRA_ACOPLAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_REGRA_ACOPLAMENTO');
        pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_PERCENTUAL_PACIENTE');
        pITREG_FAT_REL.CD_FRANQUIA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_FRANQUIA');

        -- Bloco ITREG_FAT_RELACIONADO
        pITREG_FAT_RELACIONADO.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.CD_PRO_FAT');
        pITREG_FAT_RELACIONADO.CD_GRU_FAT := PKG_XML.GetNUMBER(xml, 'pITREG_FAT_RELACIONADO.CD_GRU_FAT');
        pITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT');
        pITREG_FAT_RELACIONADO.DSP_DS_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_DS_PRO_FAT');
        pITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR');
        pITREG_FAT_RELACIONADO.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_CD_POR_ANE');
        pITREG_FAT_RELACIONADO.DSP_TP_SEXO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_SEXO');
        pITREG_FAT_RELACIONADO.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_CD_GRU_PRO');
        pITREG_FAT_RELACIONADO.DSP_QTD_MAXIMA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_QTD_MAXIMA');
        pITREG_FAT_RELACIONADO.DSP_DS_UNIDADE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_DS_UNIDADE');
        pITREG_FAT_RELACIONADO.DSP_TP_GRU_PRO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_GRU_PRO');
        pITREG_FAT_RELACIONADO.DSP_PRO_FAT_SN_ATIVO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_PRO_FAT_SN_ATIVO');

        -- Bloco ITREG_FAT_SINTETICO
        pITREG_FAT_SINTETICO.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.CD_PRO_FAT');
        pITREG_FAT_SINTETICO.CD_GRU_FAT := PKG_XML.GetNUMBER(xml, 'pITREG_FAT_SINTETICO.CD_GRU_FAT');
        pITREG_FAT_SINTETICO.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_GRU_FAT');
        pITREG_FAT_SINTETICO.DSP_DS_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_DS_PRO_FAT');
        pITREG_FAT_SINTETICO.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_NR_AUXILIAR');
        pITREG_FAT_SINTETICO.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_CD_POR_ANE');
        pITREG_FAT_SINTETICO.DSP_TP_SEXO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_SEXO');
        pITREG_FAT_SINTETICO.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_CD_GRU_PRO');
        pITREG_FAT_SINTETICO.DSP_QTD_MAXIMA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_QTD_MAXIMA');
        pITREG_FAT_SINTETICO.DSP_DS_UNIDADE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_DS_UNIDADE');
        pITREG_FAT_SINTETICO.DSP_TP_GRU_PRO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_GRU_PRO');
        pITREG_FAT_SINTETICO.DSP_PRO_FAT_SN_ATIVO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_PRO_FAT_SN_ATIVO');

        -- Bloco REG_FAT
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ESPECIALID:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ESPECIALID');
        pREG_FAT.DSP_CD_CATEGORIA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA');
        pREG_FAT.DSP_SN_TITULAR:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_TITULAR');
        pREG_FAT.DSP_SN_PENSIONISTA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_PENSIONISTA');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_CD_PACIENTE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE');
        pREG_FAT.DSP_CD_CONVENIO_SECUNDARIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO_SECUNDARIO');
        pREG_FAT.DSP_CD_CON_PLA_SECUNDARIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CON_PLA_SECUNDARIO');

        -- Parmetros gerais
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        FSV_MODE:= PKG_XML.GetVARCHAR2(xml, 'FSV_MODE');
        P_FIELD_LEVEL:= PKG_XML.GetBOOLEAN(xml, 'P_FIELD_LEVEL');
        cSintetico:= PKG_XML.GetVarChar2(xml, 'cSintetico');

        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITREG_FAT_ITREG_FAT_P_E(xml) THEN
                P_CHK_ITREG_FAT_ITREG_FAT_P(xml, pITREG_FAT, pITREG_FAT_REL, pITREG_FAT_RELACIONADO, pITREG_FAT_SINTETICO, pREG_FAT, formParams, FSV_MODE, P_FIELD_LEVEL, cSintetico);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITREG_FAT_ITREG_FAT_P_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT', pITREG_FAT_REL.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_GRU_FAT', pITREG_FAT_REL.DSP_TP_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_DS_PRO_FAT', pITREG_FAT_REL.DSP_DS_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_NR_AUXILIAR', pITREG_FAT_REL.DSP_NR_AUXILIAR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_POR_ANE', pITREG_FAT_REL.DSP_CD_POR_ANE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_SEXO', pITREG_FAT_REL.DSP_TP_SEXO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_GRU_PRO', pITREG_FAT_REL.DSP_CD_GRU_PRO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_QTD_MAXIMA', pITREG_FAT_REL.DSP_QTD_MAXIMA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_DS_UNIDADE', pITREG_FAT_REL.DSP_DS_UNIDADE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_TP_GRU_PRO', pITREG_FAT_REL.DSP_TP_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_PRO_FAT_SN_ATIVO', pITREG_FAT_REL.DSP_PRO_FAT_SN_ATIVO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_REGRA_ACOPLAMENTO', pITREG_FAT_REL.CD_REGRA_ACOPLAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_PERCENTUAL_PACIENTE', pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_FRANQUIA', pITREG_FAT_REL.CD_FRANQUIA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ESPECIALID', pREG_FAT.DSP_CD_ESPECIALID);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA', pREG_FAT.DSP_CD_CATEGORIA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_TITULAR', pREG_FAT.DSP_SN_TITULAR);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_PENSIONISTA', pREG_FAT.DSP_SN_PENSIONISTA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE', pREG_FAT.DSP_CD_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CONVENIO_SECUNDARIO', pREG_FAT.DSP_CD_CONVENIO_SECUNDARIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CON_PLA_SECUNDARIO', pREG_FAT.DSP_CD_CON_PLA_SECUNDARIO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.CD_PRO_FAT', pITREG_FAT_SINTETICO.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_GRU_FAT', pITREG_FAT_SINTETICO.DSP_TP_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_DS_PRO_FAT', pITREG_FAT_SINTETICO.DSP_DS_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_NR_AUXILIAR', pITREG_FAT_SINTETICO.DSP_NR_AUXILIAR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_CD_POR_ANE', pITREG_FAT_SINTETICO.DSP_CD_POR_ANE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_SEXO', pITREG_FAT_SINTETICO.DSP_TP_SEXO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_CD_GRU_PRO', pITREG_FAT_SINTETICO.DSP_CD_GRU_PRO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_QTD_MAXIMA', pITREG_FAT_SINTETICO.DSP_QTD_MAXIMA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_DS_UNIDADE', pITREG_FAT_SINTETICO.DSP_DS_UNIDADE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_TP_GRU_PRO', pITREG_FAT_SINTETICO.DSP_TP_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_PRO_FAT_SN_ATIVO', pITREG_FAT_SINTETICO.DSP_PRO_FAT_SN_ATIVO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.CD_PRO_FAT', pITREG_FAT_RELACIONADO.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT', pITREG_FAT_RELACIONADO.DSP_TP_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_DS_PRO_FAT', pITREG_FAT_RELACIONADO.DSP_DS_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR', pITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_CD_POR_ANE', pITREG_FAT_RELACIONADO.DSP_CD_POR_ANE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_SEXO', pITREG_FAT_RELACIONADO.DSP_TP_SEXO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_CD_GRU_PRO', pITREG_FAT_RELACIONADO.DSP_CD_GRU_PRO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_QTD_MAXIMA', pITREG_FAT_RELACIONADO.DSP_QTD_MAXIMA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_DS_UNIDADE', pITREG_FAT_RELACIONADO.DSP_DS_UNIDADE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_TP_GRU_PRO', pITREG_FAT_RELACIONADO.DSP_TP_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.DSP_PRO_FAT_SN_ATIVO', pITREG_FAT_RELACIONADO.DSP_PRO_FAT_SN_ATIVO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT', pITREG_FAT.DSP_TP_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_DS_PRO_FAT', pITREG_FAT.DSP_DS_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_NR_AUXILIAR', pITREG_FAT.DSP_NR_AUXILIAR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_CD_POR_ANE', pITREG_FAT.DSP_CD_POR_ANE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_SEXO', pITREG_FAT.DSP_TP_SEXO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO', pITREG_FAT.DSP_CD_GRU_PRO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_QTD_MAXIMA', pITREG_FAT.DSP_QTD_MAXIMA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_DS_UNIDADE', pITREG_FAT.DSP_DS_UNIDADE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_PRO', pITREG_FAT.DSP_TP_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_PRO_FAT_SN_ATIVO', pITREG_FAT.DSP_PRO_FAT_SN_ATIVO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO', pITREG_FAT.CD_REGRA_ACOPLAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE', pITREG_FAT.VL_PERCENTUAL_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA', pITREG_FAT.CD_FRANQUIA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'FSV_MODE', FSV_MODE);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CGFK$CHK_ITREG_FAT_PRESTADOR</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_ITREG_FAT_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec,
	                                     pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec,cSintetico in VarChar2 Default 'F',
										 pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) IS
nCdPrestador   number;
  vNmPrestador   varchar2(2000);
BEGIN
    nCdPrestador := to_number(null);
    vNmPrestador := null;

  if cSintetico = 'F' then
      nCdPrestador := pITREG_FAT.CD_PRESTADOR;
  elsif cSintetico = 'E' then
    nCdPrestador := pITREG_FAT_REL.CD_PRESTADOR;
  else
    nCdPrestador := pITREG_FAT_SINTETICO.CD_PRESTADOR;
  end if ;

  if nCdPrestador is null then
      return;
  end if;

  vNmPrestador := Pkg_ffcv_M_LAN_HOS.F_CHECA_PRESTADOR(xml, pITLAN_MED_REL, pITLAN_MED2, formParams, nCdPrestador
                                     ,pbSnLevantaExecessao
                                     ,pbSnMostraMensagem
                                     ,'ITREG_FAT');

  if cSintetico = 'F' then
    pITREG_FAT.DSP_NM_PRESTADOR := vNmPrestador;
  elsif cSintetico = 'E' then
    pITREG_FAT_REL.DSP_NM_PRESTADOR := vNmPrestador;
  else
    pITREG_FAT_SINTETICO.DSP_NM_PRESTADOR := vNmPrestador;
  end if;
END;

PROCEDURE P_CHK_ITREG_FAT_PRESTADOR (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    cSintetico VarChar2(4000);
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    pitreg_fat ITREG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    pitreg_fat_sintetico ITREG_FAT_SINTETICORec;
    pitlan_med_rel ITLAN_MED_RELRec;
    pitlan_med2 ITLAN_MED2Rec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR');
        pITREG_FAT_REL.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_NM_PRESTADOR');
        pITLAN_MED_REL.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO');
        pITLAN_MED_REL.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR');
        pITLAN_MED_REL.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA');
        pITLAN_MED_REL.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS');
        pITREG_FAT_SINTETICO.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.CD_PRESTADOR');
        pITREG_FAT_SINTETICO.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_NM_PRESTADOR');
        pITLAN_MED2.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO');
        pITLAN_MED2.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR');
        pITLAN_MED2.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA');
        pITLAN_MED2.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_NM_PRESTADOR');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        cSintetico:= PKG_XML.GetVarChar2(xml, 'cSintetico');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITREG_FAT_PRESTADOR_E(xml) THEN
                P_CHK_ITREG_FAT_PRESTADOR(xml, pITREG_FAT, pITREG_FAT_REL, pITREG_FAT_SINTETICO, pITLAN_MED_REL, pITLAN_MED2, formParams, cSintetico, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITREG_FAT_PRESTADOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR', pITREG_FAT_REL.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_NM_PRESTADOR', pITREG_FAT_REL.DSP_NM_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO', pITLAN_MED_REL.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR', pITLAN_MED_REL.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA', pITLAN_MED_REL.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS', pITLAN_MED_REL.DSP_SN_OUTROS);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.CD_PRESTADOR', pITREG_FAT_SINTETICO.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_NM_PRESTADOR', pITREG_FAT_SINTETICO.DSP_NM_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO', pITLAN_MED2.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR', pITLAN_MED2.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA', pITLAN_MED2.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS', pITLAN_MED2.DSP_SN_OUTROS);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_NM_PRESTADOR', pITREG_FAT.DSP_NM_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



/*
<DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
<CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
<OBJETIVO>chk_valores_procedimento</OBJETIVO>
<ALTERACOES></ALTERACOES>
*/
PROCEDURE P_CHK_VALORES_PROCEDIMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec,
                                        formParams IN OUT NOCOPY FormParamsRec,p_cd_pro_fat in VARCHAR2,
										p_tp_gru_fat in VARCHAR2,
										p_dt_lancamento in date,
										p_hr_lancamento in date,
										p_erro_retorno out VARCHAR2) IS
  cSnCancula VarChar2( 1 );
  nValor     Number ;
  nDummy     Number ;
  nValStart  Number ;
  nValTotal  Number ;
  vErroRetorno  varchar2(2000);   -- OP 6109 - segmentação
  nVlOper       number;           -- OP 6109 - segmentação
  nVlHonor      number;           -- OP 6109 - segmentação
  nVlFilme      number;           -- OP 6109 - segmentação
  nQtCh         number;           -- OP 6109 - segmentação
  nVlAcres      number;           -- OP 6109 - segmentação
  nVlDesc       number;           -- OP 6109 - segmentação

Begin

  IF  formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT = 'N' AND
      ( p_tp_gru_fat = 'OP' or FNC_FFCV_SN_OPME( pITREG_FAT.CD_PRO_FAT) = 'S' ) THEN
    RETURN;
  END IF;

  -- Verifica se o procedimento pode ser recalculado
  M_PKG_FFCV_PRO_FAT.P_RETORNA_CAMPO(xml, p_cd_pro_fat
                                    ,formParams.P_MIG_CD_MULTI_EMPRESA
                                    ,formParams.P_MIG_CD_USUARIO
                                    ,true
                                    ,true
                                    ,'SN_CALCULA_VALOR'
                                    ,cSnCancula);

  if nvl(cSnCancula,'S') = 'S' then

      -- Valor simblico para ortese e protese, OP não necessita valor em tabela.
      -- se estiver marcado como SN_OPME não necessita de valor em tabela
      if p_tp_gru_fat = 'OP' or fnc_ffcv_sn_opme(p_cd_pro_fat) = 'S' then
        pITREG_FAT.DSP_VL_INICIAL := 1 ;
      end if ;

	-- OP 6109 - 22/04/2013 - segmentação - substituindo parmetros por variveis nos campos IN OUT
	vErroRetorno := p_erro_retorno;
	nVlOper := pITREG_FAT.VL_OPERACIONAL_UNITARIO;
	nVlHonor := pITREG_FAT.VL_HONORARIO_UNITARIO;
	nVlFilme := pITREG_FAT.VL_FILME_UNITARIO;
	nQtCh := pITREG_FAT.QT_CH_UNITARIO;
	nVlAcres := pITREG_FAT.VL_ACRESCIMO;
	nVlDesc := pITREG_FAT.VL_DESCONTO;
	-- OP 6109 - fim

      nValor := val_proc_ffcv( p_cd_pro_fat,
                                     p_dt_lancamento,
                                     p_hr_lancamento,
                                    pREG_FAT.CD_CONVENIO,
                                    pREG_FAT.CD_CON_PLA,
                                    pREG_FAT.DSP_TP_ATENDIMENTO,
                                    pREG_FAT.DSP_CD_TIP_ACOM,
                                    pITREG_FAT.CD_ATI_MED,
                                    pITREG_FAT.VL_PERCENTUAL_MULTIPLA,
                                    vErroRetorno,  -- p_erro_retorno,  -- OP 6109 - segmentação
                                    nVlOper,       -- pITREG_FAT.VL_OPERACIONAL_UNITARIO,  -- OP 6109 - segmentação
                                    nVlHonor,      -- pITREG_FAT.VL_HONORARIO_UNITARIO,  -- OP 6109 - segmentação
                                    nVlFilme,      -- pITREG_FAT.VL_FILME_UNITARIO,  -- OP 6109 - segmentação
                                    nDummy,
                                    nDummy,
                                    nQtCh,         -- pITREG_FAT.QT_CH_UNITARIO,  -- OP 6109 - segmentação
                                    nVlAcres,      -- pITREG_FAT.VL_ACRESCIMO,  -- OP 6109 - segmentação
                                    nVlDesc,       -- pITREG_FAT.VL_DESCONTO,  -- OP 6109 - segmentação
                                    pITREG_FAT.DSP_VL_INICIAL,
                                    pITREG_FAT.QT_LANCAMENTO,
                                    nValTotal,
                                    pREG_FAT.CD_REGRA,
                                    pITREG_FAT.VL_PERCENTUAL_PACIENTE,
                                    pITREG_FAT.CD_FRANQUIA,
                                    Null,
                                    pITREG_FAT.CD_REGRA_ACOPLAMENTO,
                                    Null,
                                    pREG_FAT.DSP_TP_CONVENIO,
                                    pREG_FAT.CD_CONVENIO,
                                    pREG_FAT.CD_CON_PLA,
                                    null,
                                    pitreg_fat.cd_prestador,
                                    pitreg_fat.cd_setor
                                    ,null
                                    ,null
                                    ) ;

		-- OP 6109 - 22/04/2013 - segmentação - substituindo parmetros por variveis nos campos IN OUT
		p_erro_retorno := vErroRetorno;
		pITREG_FAT.VL_OPERACIONAL_UNITARIO := nVlOper;
		pITREG_FAT.VL_HONORARIO_UNITARIO := nVlHonor;
		pITREG_FAT.VL_FILME_UNITARIO := nVlFilme;
		pITREG_FAT.QT_CH_UNITARIO := nQtCh;
		pITREG_FAT.VL_ACRESCIMO := nVlAcres;
		pITREG_FAT.VL_DESCONTO := nVlDesc;
        -- OP 6109 - fim

  	  pITREG_FAT.VL_UNITARIO := nValor ;

      pITREG_FAT.VL_TOTAL_CONTA := ROUND( nValTotal + NVL( pITREG_FAT.VL_ACRESCIMO, 0 ) - NVL( pITREG_FAT.VL_DESCONTO, 0 ) +
                                        ( Nvl(pITREG_FAT.VL_FILME_UNITARIO * pITREG_FAT.QT_LANCAMENTO, 0) ), 2 ) ;

  end if;
End;

PROCEDURE P_CHK_VALORES_PROCEDIMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    p_cd_pro_fat VARCHAR2(4000);
    p_tp_gru_fat VARCHAR2(4000);
    p_dt_lancamento date;
    p_hr_lancamento date;
    p_erro_retorno VARCHAR2(4000);
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.DSP_VL_INICIAL:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_VL_INICIAL');
        pITREG_FAT.CD_ATI_MED:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_ATI_MED');
        pITREG_FAT.VL_PERCENTUAL_MULTIPLA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_MULTIPLA');
        pITREG_FAT.VL_OPERACIONAL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_OPERACIONAL_UNITARIO');
        pITREG_FAT.VL_HONORARIO_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_HONORARIO_UNITARIO');
        pITREG_FAT.VL_FILME_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_FILME_UNITARIO');
        pITREG_FAT.QT_CH_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_CH_UNITARIO');
        pITREG_FAT.VL_ACRESCIMO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_ACRESCIMO');
        pITREG_FAT.VL_DESCONTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_DESCONTO');
        pITREG_FAT.QT_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO');
        pITREG_FAT.VL_PERCENTUAL_PACIENTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE');
        pITREG_FAT.CD_FRANQUIA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA');
        pITREG_FAT.CD_REGRA_ACOPLAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_SETOR');
        pITREG_FAT.VL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_UNITARIO');
        pITREG_FAT.VL_TOTAL_CONTA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_TOTAL_CONTA');
        formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        p_cd_pro_fat:= PKG_XML.GetVARCHAR2(xml, 'p_cd_pro_fat');
        p_tp_gru_fat:= PKG_XML.GetVARCHAR2(xml, 'p_tp_gru_fat');
        p_dt_lancamento:= PKG_XML.Getdate(xml, 'p_dt_lancamento');
        p_hr_lancamento:= PKG_XML.Getdate(xml, 'p_hr_lancamento');
        p_erro_retorno:= PKG_XML.GetVARCHAR2(xml, 'p_erro_retorno');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_VALORES_PROCEDIMENTO_E(xml) THEN
                P_CHK_VALORES_PROCEDIMENTO(xml, pITREG_FAT, pREG_FAT, formParams, p_cd_pro_fat, p_tp_gru_fat, p_dt_lancamento, p_hr_lancamento, p_erro_retorno);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_VALORES_PROCEDIMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM', pREG_FAT.DSP_CD_TIP_ACOM);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_VL_INICIAL', pITREG_FAT.DSP_VL_INICIAL);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_ATI_MED', pITREG_FAT.CD_ATI_MED);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_MULTIPLA', pITREG_FAT.VL_PERCENTUAL_MULTIPLA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_OPERACIONAL_UNITARIO', pITREG_FAT.VL_OPERACIONAL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_HONORARIO_UNITARIO', pITREG_FAT.VL_HONORARIO_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_FILME_UNITARIO', pITREG_FAT.VL_FILME_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_CH_UNITARIO', pITREG_FAT.QT_CH_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_ACRESCIMO', pITREG_FAT.VL_ACRESCIMO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_DESCONTO', pITREG_FAT.VL_DESCONTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO', pITREG_FAT.QT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE', pITREG_FAT.VL_PERCENTUAL_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA', pITREG_FAT.CD_FRANQUIA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO', pITREG_FAT.CD_REGRA_ACOPLAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_SETOR', pITREG_FAT.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_UNITARIO', pITREG_FAT.VL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_TOTAL_CONTA', pITREG_FAT.VL_TOTAL_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT', formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'p_erro_retorno', p_erro_retorno);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ATUALIZA_SN_FATURA_IMPRESSA</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_ATUALIZA_SN_FATURA_IMPRESS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2,
	                                        FSV_RECORD_STATUS IN OUT NOCOPY varchar2) IS
BEGIN
    --
    IF  FSV_CURRENT_FIELD IS NULL THEN
       RETURN;
    END IF;
    --
    IF  FSV_FORM_STATUS = 'CHANGED' THEN
       --
       IF  pREG_FAT.SN_FECHADA <> 'S' THEN
         IF not ( (  FSV_CURRENT_FIELD = 'SN_FATURA_IMPRESSA' or  FSV_CURRENT_FIELD = 'SN_FECHADA' or  FSV_CURRENT_FIELD = 'SN_IMPORTA_AUTO' ) AND  FSV_RECORD_STATUS <> 'INSERT' ) THEN
           IF  FSV_CURRENT_FIELD = 'CD_REMESSA' AND  FSV_RECORD_STATUS <> 'INSERT' THEN
              --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_7)
              PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_7', 'PKG_FFCV_M_LAN_HOS', 'Aviso: A remessa desta conta foi alterada, portanto verifique se há faturas impressas.'), 'I', FALSE);
           ELSE
            pREG_FAT.SN_FATURA_IMPRESSA := 'N';
            pREG_FAT.SN_CONTA_CALCULADA := 'N';

            update DBAMV.reg_fat
               set sn_fatura_impressa = 'N'
                  ,sn_conta_calculada = 'N'
             where cd_conta_pai = preg_fat.cd_reg_fat;

           END IF;
         end if ;
       END IF;
       Pkg_ffcv_M_LAN_HOS.P_ATUALIZA_STATUS(xml, pREG_FAT);
   END IF;
END;

PROCEDURE P_ATUALIZA_SN_FATURA_IMPRESS (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    FSV_CURRENT_FIELD VARCHAR2(4000);
    FSV_FORM_STATUS VARCHAR2(4000);
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.SN_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FECHADA');
        pREG_FAT.SN_FATURA_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA');
        pREG_FAT.SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA');
        pREG_FAT.DSP_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA');
        pREG_FAT.DSP_SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA');
        FSV_CURRENT_FIELD:= PKG_XML.GetVARCHAR2(xml, 'FSV_CURRENT_FIELD');
        FSV_FORM_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_FORM_STATUS');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_ATUALIZA_SN_FATURA_IMPRESS_E(xml) THEN
                P_ATUALIZA_SN_FATURA_IMPRESS(xml, pREG_FAT, FSV_CURRENT_FIELD, FSV_FORM_STATUS, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_ATUALIZA_SN_FATURA_IMPRESS_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FECHADA', pREG_FAT.SN_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA', pREG_FAT.SN_FATURA_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA', pREG_FAT.SN_CONTA_CALCULADA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA', pREG_FAT.DSP_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA', pREG_FAT.DSP_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA', pREG_FAT.DSP_SN_CONTA_CALCULADA);
        PKG_XML.SetVARCHAR2(xml, 'FSV_CURRENT_FIELD', FSV_CURRENT_FIELD);
        PKG_XML.SetVARCHAR2(xml, 'FSV_FORM_STATUS', FSV_FORM_STATUS);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ATUALIZA_STATUS</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_ATUALIZA_STATUS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec) IS
v_sn_fatura_impressa varchar2(1);
BEGIN
  IF  pREG_FAT.CD_ATENDIMENTO IS NULL THEN
     RETURN;
  END IF;

  IF  pREG_FAT.SN_FECHADA = 'S' THEN
     pREG_FAT.DSP_FECHADA  := 'X';
  ELSE
     pREG_FAT.DSP_FECHADA  := NULL;
  END IF;

  IF  pREG_FAT.SN_FATURA_IMPRESSA = 'S' THEN
     pREG_FAT.DSP_IMPRESSA := 'X';
  ELSE
     pREG_FAT.DSP_IMPRESSA := NULL;
  END IF;

  IF  pREG_FAT.SN_CONTA_CALCULADA = 'S' THEN
     pREG_FAT.DSP_SN_CONTA_CALCULADA := 'X';
  ELSE
     pREG_FAT.DSP_SN_CONTA_CALCULADA := NULL;
  END IF;

END;

PROCEDURE P_ATUALIZA_STATUS (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.SN_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FECHADA');
        pREG_FAT.DSP_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA');
        pREG_FAT.SN_FATURA_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA');
        pREG_FAT.DSP_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA');
        pREG_FAT.SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA');
        pREG_FAT.DSP_SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_ATUALIZA_STATUS_E(xml) THEN
                P_ATUALIZA_STATUS(xml, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_ATUALIZA_STATUS_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FECHADA', pREG_FAT.SN_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA', pREG_FAT.DSP_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA', pREG_FAT.SN_FATURA_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA', pREG_FAT.DSP_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA', pREG_FAT.SN_CONTA_CALCULADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA', pREG_FAT.DSP_SN_CONTA_CALCULADA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>Exclui_Logs</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_EXCLUI_LOGS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec) IS
BEGIN
  Delete log_falha_importacao
  where  cd_atendimento = preg_fat.cd_atendimento
  and    cd_mvto_falha  = plog_falha_importacao.cd_mvto_falha
  and    cd_item_falha  = plog_falha_importacao.cd_item_falha;
END;

PROCEDURE P_EXCLUI_LOGS (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_EXCLUI_LOGS_E(xml) THEN
                P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
                Pkg_ffcv_M_LAN_HOS_C.P_EXCLUI_LOGS_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CHK_CONVENIO_REG_FAT</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_CONVENIO_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) IS
vTemp varchar2(2000);
  nTemp number;
Begin
      -- Consulta dados do Convênio
    Pkg_ffcv_M_LAN_HOS.P_CONVENIO_DADOS(xml, formParams, preg_fat.cd_convenio
                        , formParams.P_MIG_CD_MULTI_EMPRESA
                        , formParams.P_MIG_CD_USUARIO
                        , pbSnLevantaExecessao
                        , pbSnMostraMensagem
                          , pREG_FAT.DSP_NM_CONVENIO -- NM_CONVENIO
                          , pREG_FAT.DSP_TP_CONVENIO -- TP_CONVENIO
                          , vTemp                    -- SN_FILANTROPIA
                          , vTemp                    -- TP_FORMA_GERAR_CON_REC
                          , vTemp                    -- TP_FORMA_AGRUPAMENTO
                          , vTemp                    -- TP_IMPORTAR_MATMED
                          , nTemp                    -- CD_FOR_APRE
                          , vTemp                    -- SN_VALIDADE_CARTEIRA
                          , pREG_FAT.DSP_SN_GUIA     -- SN_GUIA
                          , vTemp);
end;

PROCEDURE P_CHK_CONVENIO_REG_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.DSP_NM_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NM_CONVENIO');
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        pREG_FAT.DSP_SN_GUIA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_GUIA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_CONVENIO_REG_FAT_E(xml) THEN
                P_CHK_CONVENIO_REG_FAT(xml, pREG_FAT, formParams, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_CONVENIO_REG_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NM_CONVENIO', pREG_FAT.DSP_NM_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_GUIA', pREG_FAT.DSP_SN_GUIA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>transfere_conta</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_TRANSFERE_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,nConta in reg_fat.cd_reg_fat%type) IS
cursor c_Lanc is
    select cd_reg_fat,
           cd_lancamento,
           dt_lancamento,
           hr_lancamento,
           qt_lancamento,
           vl_percentual_multipla,
           vl_unitario,
           vl_filme_unitario,
           vl_acrescimo,
           vl_desconto,
           cd_gru_fat,
           cd_pro_fat,
           cd_prestador,
           vl_honorario_unitario,
           vl_operacional_unitario,
           cd_pres_con,
           vl_percentual_paciente,
           vl_total_conta,
           cd_importa_reg_fat,
           cd_guia,
           sn_pertence_pacote,
           vl_base_repassado,
           qt_ch_unitario,
           tp_pagamento,
           cd_setor,
           cd_setor_produziu,
           cd_ati_med,
           sn_horario_especial,
           cd_padrao,
           cd_reg_fat_rel,
           cd_lancamento_rel,
           cd_usuario,
           cd_mvto,
           tp_mvto,
                     cd_itmvto,
                     nr_difep
      from DBAMV.itreg_fat it
     where cd_reg_fat = preg_fat.cd_reg_fat
       and   tp_mvto <> 'Gases'                /* pda RE 374416 */
       AND EXISTS(SELECT 'X'
                                  FROM DBAMV.itreg_fat it2
                                WHERE it2.cd_reg_fat_rel = it.cd_reg_fat
                                     AND it2.cd_lancamento_rel = it.cd_lancamento)
     order by cd_lancamento_rel;

  -- Cursor para verificar se o registro possui algum filho (procedimentos relacionados a ele)
  cursor C_Relacionamento(nConta itreg_fat.cd_reg_fat_rel%type , nLancamento itreg_fat.cd_lancamento_rel%type ) is
    Select count(1)
      from DBAMV.itreg_fat
     where itreg_fat.cd_reg_fat_rel = nConta
       and cd_lancamento_rel = nlancamento;

  Cursor C_LancRest_Rel IS
    Select it.cd_reg_fat,
           it.cd_lancamento,
           it.dt_lancamento,
           it.hr_lancamento,
           it.qt_lancamento,
           it.vl_percentual_multipla,
           it.vl_unitario,
           it.vl_filme_unitario,
           it.vl_acrescimo,
           it.vl_desconto,
           it.cd_gru_fat,
           it.cd_pro_fat,
           it.cd_prestador,
           it.vl_honorario_unitario,
           it.vl_operacional_unitario,
           it.cd_pres_con,
           it.vl_percentual_paciente,
           it.vl_total_conta,
           it.cd_importa_reg_fat,
           it.cd_guia,
           it.sn_pertence_pacote,
           it.vl_base_repassado,
           it.qt_ch_unitario,
           it.tp_pagamento,
           it.cd_setor,
           it.cd_setor_produziu,
           it.cd_ati_med,
           it.sn_horario_especial,
           it.cd_padrao,
           it.cd_reg_fat_rel,
           it.cd_lancamento_rel,
           it.cd_usuario,
           it.cd_mvto,
           it.tp_mvto,
                     cd_itmvto,
                     nr_difep
      from DBAMV.itreg_fat it
     where it.cd_reg_fat    = preg_fat.cd_reg_fat
       and   tp_mvto <> 'Gases'                /* pda RE 374416 */
       AND not EXISTS(SELECT 'X'
                                   FROM DBAMV.itreg_fat it2
                                  WHERE it2.cd_reg_fat_rel = it.cd_reg_fat
                                     AND it2.cd_lancamento_rel = it.cd_lancamento)
     order by it.cd_lancamento_rel;

  cursor c_Itlan_med (v_cd_reg_fat itlan_med.cd_reg_fat%type , v_cd_lancamento itlan_med.cd_lancamento%type ) is
    select cd_reg_fat,
           cd_lancamento,
           cd_ati_med,
           cd_prestador,
           vl_ato,
           cd_pres_con,
           tp_pagamento,
           vl_base_repassado
    from   DBAMV.itlan_med
    where  cd_reg_fat    =  v_cd_reg_fat
      and  cd_lancamento =  v_cd_lancamento;

  cursor c_nota (v_cd_reg_fat itcob_pre.cd_reg_fat%type , v_cd_lancamento itcob_pre.cd_lancamento%type ) is
    select cd_reg_fat,
           cd_lancamento,
           nr_documento,
           vl_preco_unitario,
           vl_preco_total,
           ds_observacao,
           cd_fornecedor
    from   DBAMV.itcob_pre
    where  cd_reg_fat = v_cd_reg_fat
     and   cd_lancamento = v_cd_lancamento;

     TYPE rLanc IS RECORD (nCdLancNew itreg_fat.cd_lancamento%type,
                                                 nCdLancOld itreg_fat.cd_lancamento%type);

     TYPE tLanc IS TABLE OF rLanc INDEX BY BINARY_INTEGER;

  nCdRegFat         itreg_fat.cd_reg_fat%type ;
  nCdLancamento     itreg_fat.cd_lancamento%type ;
  nCont                            number;
  nLancamento                itreg_fat.cd_lancamento%type  := 1;
     V_Lanc                tLanc;
     nIndex                   NUMBER := 0;
    nCdLancRel          itreg_fat.cd_lancamento%type ;
BEGIN

  nCdRegFat     := null;
  nCdLancamento := null;
  nCdRegFat     := nConta;

  If nCdRegFat is null then
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_8)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_8', 'PKG_FFCV_M_LAN_HOS', 'Atenção: não existe conta disponível para transferência dos lançamentos!'),'I',true);
  end if;

  nCdLancamento := PKG_FFCV_IT_CONTA.FNC_OBTEM_SEQUENCIA(nCdRegFat,'H') - 1;

  FOR r_lanc in C_Lanc LOOP

      nCdLancamento := nvl(nCdLancamento,0) + 1;
            nLancamento := nLancamento + 1;
      BEGIN
        INSERT INTO DBAMV.itreg_fat (cd_reg_fat,
                                     cd_lancamento,
                                     dt_lancamento,
                                     hr_lancamento,
                                     qt_lancamento,
                                     vl_percentual_multipla,
                                     vl_unitario,
                                     vl_filme_unitario,
                                     vl_acrescimo,
                                     vl_desconto,
                                     cd_gru_fat,
                                     cd_pro_fat,
                                     cd_prestador,
                                     vl_honorario_unitario,
                                     vl_operacional_unitario,
                                     cd_pres_con,
                                     vl_percentual_paciente,
                                     vl_total_conta,
                                     cd_importa_reg_fat,
                                     cd_guia,
                                     sn_pertence_pacote,
                                     vl_base_repassado,
                                     qt_ch_unitario,
                                     tp_pagamento,
                                     cd_setor,
                                     cd_setor_produziu,
                                              cd_ati_med,
                                             sn_horario_especial,
                                               cd_padrao,
                                       cd_reg_fat_rel,
                                       cd_lancamento_rel,
                                               cd_usuario,
                                               cd_mvto,
                                               tp_mvto,
                                                       cd_itmvto,
                                                       nr_difep
                                                       )
                       values        (
                                     nCdRegFat,
                                     nCdLancamento,
                                     r_lanc.dt_lancamento,
                                     r_lanc.hr_lancamento,
                                     r_lanc.qt_lancamento,
                                     r_lanc.vl_percentual_multipla,
                                     r_lanc.vl_unitario,
                                     r_lanc.vl_filme_unitario,
                                     r_lanc.vl_acrescimo,
                                     r_lanc.vl_desconto,
                                     r_lanc.cd_gru_fat,
                                     r_lanc.cd_pro_fat,
                                     r_lanc.cd_prestador,
                                     r_lanc.vl_honorario_unitario,
                                     r_lanc.vl_operacional_unitario,
                                     r_lanc.cd_pres_con,
                                     r_lanc.vl_percentual_paciente,
                                     r_lanc.vl_total_conta,
                                     r_lanc.cd_importa_reg_fat,
                                     r_lanc.cd_guia,
                                     r_lanc.sn_pertence_pacote,
                                     r_lanc.vl_base_repassado,
                                     r_lanc.qt_ch_unitario,
                                     decode(r_lanc.tp_pagamento, 'X', 'C', r_lanc.tp_pagamento),
                                     r_lanc.cd_setor,
                                     r_lanc.cd_setor_produziu,
                                              r_lanc.cd_ati_med,
                                             r_lanc.sn_horario_especial,
                                               r_lanc.cd_padrao,
                                     r_lanc.cd_reg_fat_rel,
                                     r_lanc.cd_lancamento_rel,
                                               r_lanc.cd_usuario,
                                               r_lanc.cd_mvto,
                                               r_lanc.tp_mvto,
                                                       r_lanc.cd_itmvto,
                                                       r_lanc.nr_difep
                                                       );

        FOR r_It in c_Itlan_Med(r_Lanc.cd_reg_fat, r_Lanc.cd_lancamento) LOOP

          IF r_It.cd_reg_fat is not null and r_It.cd_lancamento is not null THEN

            BEGIN
              Insert into DBAMV.itlan_med (cd_reg_fat,
                                           cd_lancamento,
                                           cd_ati_med,
                                           cd_prestador,
                                           vl_ato,
                                           cd_pres_con,
                                           tp_pagamento,
                                           vl_base_repassado)
                                  values  (nCdRegFat,
                                           nCdLancamento,
                                           r_it.cd_ati_med,
                                           r_it.cd_prestador,
                                           r_it.vl_ato,
                                           r_it.cd_pres_con,
                                           decode(r_it.tp_pagamento, 'X', 'C', r_it.tp_pagamento),
                                           r_it.vl_base_repassado);
            EXCEPTION
              --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_9)
              WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_9', 'PKG_FFCV_M_LAN_HOS', 'Erro insert itlan_med %s', arg_list(sqlerrm)), 'W', true);
            END;

            BEGIN
              DELETE itlan_med
              where  cd_reg_fat     = r_it.cd_reg_fat
                and  cd_lancamento  = r_it.cd_lancamento
                and  cd_ati_med     = r_it.cd_ati_med
                and  cd_prestador   = r_it.cd_prestador;

            EXCEPTION
              --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_10)
              WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_10', 'PKG_FFCV_M_LAN_HOS', 'Erro delete itlan_med %s', arg_list(sqlerrm)), 'W', true);
            END;

          END IF;

        END LOOP;

        -- > Se tiver dados da nota, transferi-los para outra conta
        FOR rNota in c_nota(r_Lanc.cd_reg_fat, r_Lanc.cd_lancamento) LOOP

          BEGIN
            INSERT INTO DBAMV.itcob_pre (cd_reg_fat,
                                         cd_lancamento,
                                         nr_documento,
                                         vl_preco_unitario,
                                         vl_preco_total,
                                         ds_observacao,
                                         cd_fornecedor)
                              values    (nCdRegFat,
                                         nCdLancamento,
                                      rNota.nr_documento,
                                         rNota.vl_preco_unitario,
                                         rNota.vl_preco_total,
                                         rNota.ds_observacao,
                                         rNota.cd_fornecedor);
         EXCEPTION
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_11)
            WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_11', 'PKG_FFCV_M_LAN_HOS', 'Erro insert itcob_pre - transferência %s', arg_list(sqlerrm)), 'W', true);
          END;
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

           -- Deletar dados da conta atual
          BEGIN
            DELETE itcob_pre
            where  cd_reg_fat     = rNota.cd_reg_fat
              and  cd_lancamento  = rNota.cd_lancamento;

          EXCEPTION
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_12)
            WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_12', 'PKG_FFCV_M_LAN_HOS', 'Erro delete itcob_pre %s', arg_list(sqlerrm)), 'W', true);
          END;

        END LOOP;

      EXCEPTION
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_13)
        WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_13', 'PKG_FFCV_M_LAN_HOS', 'Erro insert itreg_fat %s', arg_list(sqlerrm)), 'W', true);
      END;

     nIndex := nIndex + 1;
     V_Lanc(nIndex).nCdLancOld := r_Lanc.cd_lancamento;
     V_Lanc(nIndex).nCdLancNew := nCdlancamento;

    END LOOP;


    FOR r_LancRel in C_LancRest_Rel LOOP

          --Insero dos itens que não possuem filhos.
      nCdlancamento := nCdlancamento + 1;
      nCdLancRel := null;

      IF r_LancRel.cd_lancamento_rel IS NOT NULL THEN
          nIndex := 0;
          LOOP
              nIndex := nIndex + 1;
              IF r_LancRel.cd_lancamento_rel = V_Lanc(nIndex).nCdLancOld THEN
                  nCdLancRel := V_Lanc(nIndex).nCdLancNew;
                  EXIT;
              END IF;
          END LOOP;
      END IF;


      BEGIN
        INSERT INTO DBAMV.itreg_fat (cd_reg_fat,
                                     cd_lancamento,
                                     dt_lancamento,
                                     hr_lancamento,
                                     qt_lancamento,
                                     vl_percentual_multipla,
                                     vl_unitario,
                                     vl_filme_unitario,
                                     vl_acrescimo,
                                     vl_desconto,
                                     cd_gru_fat,
                                     cd_pro_fat,
                                     cd_prestador,
                                     vl_honorario_unitario,
                                     vl_operacional_unitario,
                                     cd_pres_con,
                                     vl_percentual_paciente,
                                     vl_total_conta,
                                     cd_importa_reg_fat,
                                     cd_guia,
                                     sn_pertence_pacote,
                                     vl_base_repassado,
                                     qt_ch_unitario,
                                     tp_pagamento,
                                     cd_setor,
                                     cd_setor_produziu,
                                              cd_ati_med,
                                             sn_horario_especial,
                                               cd_padrao,
                                       cd_reg_fat_rel,
                                        cd_lancamento_rel,
                                               cd_usuario,
                                               cd_mvto,
                                               tp_mvto,
                                                       cd_itmvto,
                                                       nr_difep
                                                       )
                       values        (
                                     nCdRegFat,
                                     nCdlancamento,
                                     r_LancRel.dt_lancamento,
                                     r_LancRel.hr_lancamento,
                                     r_LancRel.qt_lancamento,
                                     r_LancRel.vl_percentual_multipla,
                                     r_LancRel.vl_unitario,
                                     r_LancRel.vl_filme_unitario,
                                     r_LancRel.vl_acrescimo,
                                     r_LancRel.vl_desconto,
                                     r_LancRel.cd_gru_fat,
                                     r_LancRel.cd_pro_fat,
                                     r_LancRel.cd_prestador,
                                     r_LancRel.vl_honorario_unitario,
                                     r_LancRel.vl_operacional_unitario,
                                     r_LancRel.cd_pres_con,
                                     r_LancRel.vl_percentual_paciente,
                                     r_LancRel.vl_total_conta,
                                     r_LancRel.cd_importa_reg_fat,
                                     r_LancRel.cd_guia,
                                     r_LancRel.sn_pertence_pacote,
                                     r_LancRel.vl_base_repassado,
                                     r_LancRel.qt_ch_unitario,
                                     decode(r_LancRel.tp_pagamento, 'X', 'C', r_LancRel.tp_pagamento),
                                     r_LancRel.cd_setor,
                                     r_LancRel.cd_setor_produziu,
                                     r_LancRel.cd_ati_med,
                                     r_LancRel.sn_horario_especial,
                                     r_LancRel.cd_padrao,
                                     nCdRegFat,   -- r_LancRel.cd_reg_fat_rel,  -- OP 18259 - conta correta
                                     nCdLancRel,
                                     r_LancRel.cd_usuario,
                                     r_LancRel.cd_mvto,
                                     r_LancRel.tp_mvto,
                                     r_LancRel.cd_itmvto,
                                     r_LancRel.nr_difep
                                                       );
        FOR r_It in c_Itlan_Med(r_LancRel.cd_reg_fat, r_LancRel.cd_lancamento) LOOP

          IF r_It.cd_reg_fat is not null and r_It.cd_lancamento is not null THEN

            BEGIN
              Insert into DBAMV.itlan_med (cd_reg_fat,
                                           cd_lancamento,
                                           cd_ati_med,
                                           cd_prestador,
                                           vl_ato,
                                           cd_pres_con,
                                           tp_pagamento,
                                           vl_base_repassado)
                                  values  (nCdRegFat,
                                           nCdLancamento,
                                           r_it.cd_ati_med,
                                           r_it.cd_prestador,
                                           r_it.vl_ato,
                                           r_it.cd_pres_con,
                                           decode(r_it.tp_pagamento, 'X', 'C', r_it.tp_pagamento),
                                           r_it.vl_base_repassado);
            EXCEPTION
              --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_9)
              WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_9', 'PKG_FFCV_M_LAN_HOS', 'Erro insert itlan_med %s', arg_list(sqlerrm)), 'W', true);
            END;

            BEGIN
              DELETE itlan_med
              where  cd_reg_fat     = r_it.cd_reg_fat
                and  cd_lancamento  = r_it.cd_lancamento
                and  cd_ati_med     = r_it.cd_ati_med
                and  cd_prestador   = r_it.cd_prestador;

            EXCEPTION
              --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_10)
              WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_10', 'PKG_FFCV_M_LAN_HOS', 'Erro delete itlan_med %s', arg_list(sqlerrm)), 'W', true);
            END;

          END IF;

        END LOOP;

        -- > Se tiver dados da nota, transferi-los para outra conta
        FOR rNota in c_nota(r_LancRel.cd_reg_fat, r_LancRel.cd_lancamento) LOOP

          BEGIN
            INSERT INTO DBAMV.itcob_pre (cd_reg_fat,
                                         cd_lancamento,
                                         nr_documento,
                                         vl_preco_unitario,
                                         vl_preco_total,
                                         ds_observacao,
                                         cd_fornecedor)
                              values    (nCdRegFat,
                                         nCdLancamento,
                                      rNota.nr_documento,
                                         rNota.vl_preco_unitario,
                                         rNota.vl_preco_total,
                                         rNota.ds_observacao,
                                         rNota.cd_fornecedor);
         EXCEPTION
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_11)
            WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_11', 'PKG_FFCV_M_LAN_HOS', 'Erro insert itcob_pre - transferência %s', arg_list(sqlerrm)), 'W', true);
          END;

          -- Deletar dados da conta atual
          BEGIN
            DELETE DBAMV.itcob_pre
            where  cd_reg_fat     = rNota.cd_reg_fat
              and  cd_lancamento  = rNota.cd_lancamento;

          EXCEPTION
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_12)
            WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_12', 'PKG_FFCV_M_LAN_HOS', 'Erro delete itcob_pre %s', arg_list(sqlerrm)), 'W', true);
          END;

        END LOOP;

      EXCEPTION
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_13)
        WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_13', 'PKG_FFCV_M_LAN_HOS', 'Erro insert itreg_fat %s', arg_list(sqlerrm)), 'W', true);
      END;

    END LOOP;

     begin
        Update DBAMV.conta_kit set cd_reg_fat = nCdRegFat where cd_reg_fat = preg_fat.cd_reg_fat;
    Exception
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_14)
        When Others Then PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_14', 'PKG_FFCV_M_LAN_HOS', 'Ocorreu um erro na transferência dos kits para a nova conta. %s', arg_list(sqlerrm)), 'W', true);
    end;

    BEGIN
      DELETE itreg_fat
      where  cd_reg_fat    = preg_fat.cd_reg_fat;
        EXCEPTION
      WHEN others THEN
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_15)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_15', 'PKG_FFCV_M_LAN_HOS', 'Erro ao tentar apagar os itens da conta anterior. %s', arg_list(sqlerrm)), 'E', true);
    END;

    BEGIN
      UPDATE DBAMV.reg_fat
      set    sn_fatura_impressa = 'N'
      where  cd_reg_fat = nCdRegFat
       and   cd_multi_empresa = formParams.P_MIG_CD_MULTI_EMPRESA;
    EXCEPTION
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_16)
      WHEN others THEN PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_16', 'PKG_FFCV_M_LAN_HOS', 'Erro atualização conta como não impressa %s', arg_list(sqlerrm)), 'W', true);
    END;

    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_17)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_17', 'PKG_FFCV_M_LAN_HOS', 'Itens transferidos para conta: %s com sucesso.', arg_list(nCdRegFat))   , 'W', false);
END;

PROCEDURE P_TRANSFERE_CONTA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nConta NUMBER;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        nConta:= PKG_XML.GetNUMBER(xml, 'nConta');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_TRANSFERE_CONTA_E(xml) THEN
                P_TRANSFERE_CONTA(xml, pREG_FAT, formParams, nConta);
                Pkg_ffcv_M_LAN_HOS_C.P_TRANSFERE_CONTA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>chk_pro_int</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_PRO_INT (xml IN OUT NOCOPY PKG_XML.XmlContext,pcg$ctrl IN OUT NOCOPY CG$CTRLRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean,
                       pbSnMostraMensagem in boolean) IS
vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
  vCdProfat      pro_fat.cd_pro_fat%type;
  vDsProfat      pro_fat.ds_pro_fat%type;
  vSnPacote      pro_fat.sn_pacote%type;
Begin
    if  formParams.P_MIG_SN_MOSTRA_VL_ORIG = 'S' then
         vCdProfat := pCG$CTRL.CD_PRO_FAT_SOLICITADO;
  else
     vCdProfat := pREG_FAT.CD_PRO_FAT_SOLICITADO;
  end if;
  --
  M_PKG_FFCV_PRO_FAT.P_RETORNA_DADOS(xml, vCdProfat
                                    ,formParams.P_MIG_CD_MULTI_EMPRESA
                                    ,formParams.P_MIG_CD_USUARIO
                                    ,pbSnLevantaExecessao
                                    ,pbSnMostraMensagem
                                    ,vLst_Retorno);


  vLst_Local  := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_Retorno);
  --
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'DS_PRO_FAT', vDsProfat, false);
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'SN_PACOTE' , vSnPacote, false);
  --
  pkg_parametro.pr_limpar_lista_parametros(vLst_Local);
  --
  pREG_FAT.DSP_DS_PROC_INTERN     := vDsProfat;
  pREG_FAT.DSP_SN_PERTENCE_PACOTE := vSnPacote;
END;

PROCEDURE P_CHK_PRO_INT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    pcg$ctrl CG$CTRLRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_PRO_FAT_SOLICITADO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.CD_PRO_FAT_SOLICITADO');
        pREG_FAT.DSP_DS_PROC_INTERN:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_PROC_INTERN');
        pREG_FAT.DSP_SN_PERTENCE_PACOTE:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_PERTENCE_PACOTE');
        pCG$CTRL.CD_PRO_FAT_SOLICITADO:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.CD_PRO_FAT_SOLICITADO');
        formParams.P_MIG_SN_MOSTRA_VL_ORIG:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MOSTRA_VL_ORIG');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_PRO_INT_E(xml) THEN
                P_CHK_PRO_INT(xml, pCG$CTRL, pREG_FAT, formParams, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_PRO_INT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.CD_PRO_FAT_SOLICITADO', pREG_FAT.CD_PRO_FAT_SOLICITADO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_PROC_INTERN', pREG_FAT.DSP_DS_PROC_INTERN);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_PERTENCE_PACOTE', pREG_FAT.DSP_SN_PERTENCE_PACOTE);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.CD_PRO_FAT_SOLICITADO', pCG$CTRL.CD_PRO_FAT_SOLICITADO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MOSTRA_VL_ORIG', formParams.P_MIG_SN_MOSTRA_VL_ORIG);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CHK_CID</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_CID (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) IS
begin
  pREG_FAT.DSP_DS_CID := M_PKG_GLOBAL_CID.F_RETORNA_DESCRICAO(xml, pREG_FAT.DSP_CD_CID
                                                             ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                             ,formParams.P_MIG_CD_USUARIO
                                                             ,pbSnLevantaExecessao
                                                             ,pbSnMostraMensagem);
end;

PROCEDURE P_CHK_CID (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_DS_CID:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_CID');
        pREG_FAT.DSP_CD_CID:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_CD_CID');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_CID_E(xml) THEN
                P_CHK_CID(xml, pREG_FAT, formParams, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_CID_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_CID', pREG_FAT.DSP_DS_CID);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_CD_CID', pREG_FAT.DSP_CD_CID);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>GRAVA_ATENDIME</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_GRAVA_ATENDIME (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
vCdCid         atendime.cd_cid%Type;
  vCdProFat      atendime.cd_pro_int%Type;
    vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
    vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;

     -- PDA 34964 CARLY CHRISTIAN
     alt_proc_atendi VARCHAR2(1);
     Cursor AltProcDoAtendimentoSN(cd_empresa config_ffcv.CD_MULTI_EMPRESA%type) is
      Select SN_ALT_PROC_ATENDI
        from DBAMV.CONFIG_FFCV
       where CD_MULTI_EMPRESA = cd_empresa;


Begin
  --
    -- Chamada da Procedure
    M_PKG_PAEU_ATENDIME.P_RETORNA_DADOS(xml, pREG_FAT.CD_ATENDIMENTO
                                    , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                      , formParams.P_MIG_CD_USUARIO
                                                                      , TRUE
                                                                      , TRUE
                                                                      , vLst_Retorno);
    --
    vLst_Local := pkg_parametro.fn_recupera_lista_parametros(vLst_Retorno);
    --
    -- Recuperao dos parametros retornados pela Procedure
    pkg_parametro.pr_recupera_parametro(vLst_Local,'CD_CID'    , vCdCid   , false);
    pkg_parametro.pr_recupera_parametro(vLst_Local,'CD_PRO_INT', vCdProFat, false);
    --
    -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
    pkg_parametro.pr_limpar_lista_parametros(vLst_Local);

  --

     -- PDA 34964 CARLY CHRISTIAN
  Open AltProcDoAtendimentoSN(formParams.P_MIG_CD_MULTI_EMPRESA);
  Fetch AltProcDoAtendimentoSN into alt_proc_atendi ;
  Close AltProcDoAtendimentoSN;


  if Nvl(  pREG_FAT.DSP_CD_CID, '0' ) <> Nvl( vCdCid, '0' ) then
    Update DBAMV.atendime
       Set cd_cid = pREG_FAT.DSP_CD_CID
     Where atendime.cd_atendimento = pREG_FAT.CD_ATENDIMENTO ;
  end if ;
  --
   -- OP 34964 CARLY CHRISTIAN - inserida condição que permite alterar o cd do procedimento apenas para quando o paramentro esta 'S'
  if (Nvl(  pREG_FAT.CD_PRO_FAT_SOLICITADO, '0' ) <> Nvl( vCdProFat, '0' ) or
     (  pREG_FAT.CD_PRO_FAT_SOLICITADO is not null and vCdProFat is null )) and  NVL(alt_proc_atendi,'S') = 'S'  then
    Update DBAMV.atendime
       Set cd_pro_int = pREG_FAT.CD_PRO_FAT_SOLICITADO
     Where atendime.cd_atendimento = pREG_FAT.CD_ATENDIMENTO ;
  end if ;
  --
  -- Grava dados da guia do atendimento
  if  preg_fat.dsp_cd_guia_atend is not null then
      update DBAMV.atendime
         set cd_guia = preg_fat.dsp_cd_guia_atend
       where cd_atendimento = preg_fat.cd_atendimento;
  end if;
  --
end;

PROCEDURE P_GRAVA_ATENDIME (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_CD_CID:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_CD_CID');
        pREG_FAT.CD_PRO_FAT_SOLICITADO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.CD_PRO_FAT_SOLICITADO');
        pREG_FAT.DSP_CD_GUIA_ATEND:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_GUIA_ATEND');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_GRAVA_ATENDIME_E(xml) THEN
                P_GRAVA_ATENDIME(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_GRAVA_ATENDIME_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_CD_CID', pREG_FAT.DSP_CD_CID);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.CD_PRO_FAT_SOLICITADO', pREG_FAT.CD_PRO_FAT_SOLICITADO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_GUIA_ATEND', pREG_FAT.DSP_CD_GUIA_ATEND);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>Grava_Carteira</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_GRAVA_CARTEIRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS

  CURSOR cCarteira IS
       SELECT SN_VALIDADE_CARTEIRA, SN_CARTEIRA_PARTICULAR
         FROM dbamv.convenio
        WHERE cd_convenio = pREG_FAT.CD_CONVENIO;

     CURSOR cValidade IS
       SELECT SN_VALIDADE_INDETERMINADA
         FROM dbamv.con_pla
        WHERE cd_convenio = pREG_FAT.CD_CONVENIO
          AND cd_con_pla  = pREG_FAT.CD_CON_PLA;

     CURSOR cExisteCarteira IS
       SELECT 'X' Dummy
         FROM DBAMV.carteira
        WHERE carteira.cd_paciente = pREG_FAT.DSP_CD_PACIENTE
          AND carteira.cd_convenio = pREG_FAT.CD_CONVENIO
          AND carteira.cd_con_pla  = pREG_FAT.CD_CON_PLA
          AND carteira.nr_carteira = pREG_FAT.DSP_NR_CARTEIRA;

   bInsert          Boolean := False ;
   cSnValidade      VarChar2( 1 ) ;
   cSnValidadeIndeterminada varchar2(1);
   cSnCarteira      varchar2(1);
    vTemp            varchar2(2000);
    nTemp            number;
    vCCarteira               cCarteira%ROWTYPE;
     vCValidade               cValidade%ROWTYPE;
     vCExisteCarteira         VarChar2(1);

BEGIN
  if  pREG_FAT.DSP_TP_CONVENIO = 'C' or
   ( pREG_FAT.dsp_tp_convenio = 'P' and
     pREG_FAT.cd_convenio not in (3, 42, 8, 138)and
     formParams.P_MIG_CD_HOSPITAL in (444, 445, 446, 448, 449)) then
    null;
  else
    Return ;
  end if ;

     OPEN cCarteira;
     FETCH cCarteira INTO vCCarteira;
     CLOSE cCarteira;
/*-- Consulta informaes sobre o Convênio
  Pkg_ffcv_M_LAN_HOS.P_CONVENIO_DADOS(xml, formParams, preg_fat.cd_convenio
                      , formParams.P_MIG_CD_MULTI_EMPRESA
                      , formParams.P_MIG_CD_USUARIO
                      , false
                      , false
                      , vTemp          -- NM_CONVENIO
                      , vTemp          -- TP_CONVENIO
                      , vTemp          -- SN_FILANTROPIA
                      , vTemp          -- TP_FORMA_GERAR_CON_REC
                        , vTemp          -- TP_FORMA_AGRUPAMENTO
                        , vTemp          -- TP_IMPORTAR_MATMED
                        , nTemp          -- CD_FOR_APRE
                        , cSnValidade    -- SN_VALIDADE_CARTEIRA
                        , vTemp          -- SN_GUIA
                      , cSnCarteira);   */

  if  pREG_FAT.DSP_NR_CARTEIRA is null  then
      IF  pREG_FAT.dsp_tp_convenio = 'C' THEN
          if nvl(vCCarteira.SN_CARTEIRA_PARTICULAR,'S') = 'S' then
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_18)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_18', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Número da Carteira deve ser preenchido !'), 'W', True) ;
      end if;
    END IF;
    Return ;
  end if ;

  if Nvl( vCCarteira.SN_VALIDADE_CARTEIRA, 'N' ) = 'S' and  pREG_FAT.DSP_DT_VALIDADE is null then
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_19)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_19', 'PKG_FFCV_M_LAN_HOS', 'Atenção: A data de validade da Carteira é obrigatória para o Convênio da conta !'), 'W', True) ;
    Return ;
  end if ;

  OPEN cValidade;
      FETCH cValidade INTO vCValidade;
      CLOSE cValidade;

/*-- Consulta se a validade da carteiraindeterminada
  M_PKG_FFCV_CON_PLA.P_RETORNA_CAMPO(xml, preg_fat.cd_con_pla
                                    ,preg_fat.cd_convenio
                                                      ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                      ,formParams.P_MIG_CD_USUARIO
                                                      ,false
                                                      ,false
                                    ,'SN_VALIDADE_INDETERMINADA'
                                    ,cSnValidadeIndeterminada); */

  if nvl(cSnValidade, 'N') = 'S' then
      if Nvl( vCValidade.SN_VALIDADE_INDETERMINADA, 'S' ) = 'N' and  pREG_FAT.DSP_DT_VALIDADE is null then
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_20)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_20', 'PKG_FFCV_M_LAN_HOS', 'Atenção: A data de validade da Carteira é obrigatória. O Convênio não trabalha com validade indeterminada !'), 'W', True) ;
        Return ;
      end if ;
  end if ;

  OPEN cExisteCarteira;
     FETCH cExisteCarteira INTO vCExisteCarteira;
     CLOSE cExisteCarteira;

     IF vCExisteCarteira IS NOT NULL THEN

      bInsert := FALSE;

  /*bInsert := not M_PKG_FFCV_CARTEIRA.F_EXISTE_CARTEIRA(xml, pREG_FAT.CD_CONVENIO
                                                                      ,pREG_FAT.DSP_CD_PACIENTE
                                                                      ,pREG_FAT.CD_CON_PLA
                                                                      ,preg_fat.dsp_nr_carteira
                                                                                        ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                        ,formParams.P_MIG_CD_USUARIO
                                                                                        ,false
                                                                                        ,false);  */

      ELSE

      bInsert := TRUE;

     END IF;

  -- Se não existir a carteira insere na tabela.
  if bInsert then
    Insert into dbamv.carteira ( cd_convenio,
                                 cd_paciente,
                                 dt_validade,
                                 nm_titular,
                                 nr_carteira,
                                 nm_empresa,
                                 cd_con_pla,
                                 cd_empresa_carteira,
                                 cd_categoria_plano,
                                 sn_titular,
                                 sn_pensionista )
                        Values ( pREG_FAT.CD_CONVENIO,
                                 pREG_FAT.DSP_CD_PACIENTE,
                                 pREG_FAT.DSP_DT_VALIDADE,
                                 pREG_FAT.DSP_NM_TITULAR,
                                 pREG_FAT.DSP_NR_CARTEIRA,
                                 pREG_FAT.DSP_NM_EMPRESA,
                                 pREG_FAT.CD_CON_PLA,
                                 pREG_FAT.DSP_CD_EMPRESA_CARTEIRA,
                                 pREG_FAT.DSP_CD_CATEGORIA,
                                 pREG_FAT.DSP_SN_TITULAR,
                                 NVL(pREG_FAT.DSP_SN_PENSIONISTA,'N')) ;
  else
    Update DBAMV.carteira
       Set dt_validade         = pREG_FAT.DSP_DT_VALIDADE,
           nm_titular          = pREG_FAT.DSP_NM_TITULAR,
           cd_empresa_carteira = pREG_FAT.DSP_CD_EMPRESA_CARTEIRA,
           cd_categoria_plano  = pREG_FAT.DSP_CD_CATEGORIA,
           sn_titular          = pREG_FAT.DSP_SN_TITULAR,
           sn_pensionista      = NVL(pREG_FAT.DSP_SN_PENSIONISTA,'N')
     Where cd_convenio = pREG_FAT.CD_CONVENIO
       and cd_paciente = pREG_FAT.DSP_CD_PACIENTE
       and cd_con_pla  = pREG_FAT.CD_CON_PLA
       and nr_carteira = preg_fat.dsp_nr_carteira;
  end if ;

    update DBAMV.atendime
     set nr_carteira = pREG_FAT.DSP_NR_CARTEIRA,
             dt_validade = pREG_FAT.DSP_DT_VALIDADE,
               nm_empresa  =    pREG_FAT.DSP_NM_EMPRESA
     where cd_atendimento = pREG_FAT.CD_ATENDIMENTO;
END;

PROCEDURE P_GRAVA_CARTEIRA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.DSP_NR_CARTEIRA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NR_CARTEIRA');
        pREG_FAT.DSP_DT_VALIDADE:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_VALIDADE');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_CD_PACIENTE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE');
        pREG_FAT.DSP_NM_TITULAR:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NM_TITULAR');
        pREG_FAT.DSP_NM_EMPRESA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NM_EMPRESA');
        pREG_FAT.DSP_CD_EMPRESA_CARTEIRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_EMPRESA_CARTEIRA');
        pREG_FAT.DSP_CD_CATEGORIA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA');
        pREG_FAT.DSP_SN_TITULAR:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_TITULAR');
        pREG_FAT.DSP_SN_PENSIONISTA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_PENSIONISTA');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_GRAVA_CARTEIRA_E(xml) THEN
                P_GRAVA_CARTEIRA(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_GRAVA_CARTEIRA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NR_CARTEIRA', pREG_FAT.DSP_NR_CARTEIRA);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_VALIDADE', pREG_FAT.DSP_DT_VALIDADE);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE', pREG_FAT.DSP_CD_PACIENTE);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NM_TITULAR', pREG_FAT.DSP_NM_TITULAR);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NM_EMPRESA', pREG_FAT.DSP_NM_EMPRESA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_EMPRESA_CARTEIRA', pREG_FAT.DSP_CD_EMPRESA_CARTEIRA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA', pREG_FAT.DSP_CD_CATEGORIA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_TITULAR', pREG_FAT.DSP_SN_TITULAR);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_PENSIONISTA', pREG_FAT.DSP_SN_PENSIONISTA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>Chk_Regra</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_REGRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pbSnLevantaExecessao in boolean ,pbSnMostraMensagem in boolean) IS
BEGIN
  pREG_FAT.DSP_DS_REGRA := M_PKG_FFCV_REGRA.F_RETORNA_DESCRICAO(xml, pREG_FAT.CD_REGRA
                                                                              ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                              ,formParams.P_MIG_CD_USUARIO
                                                                              ,pbSnLevantaExecessao
                                                                              ,pbSnMostraMensagem);
END;

PROCEDURE P_CHK_REGRA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_DS_REGRA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_REGRA');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_REGRA_E(xml) THEN
                P_CHK_REGRA(xml, pREG_FAT, formParams, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_REGRA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_REGRA', pREG_FAT.DSP_DS_REGRA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>Ctrl_reg_fat_block</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CTRL_REG_FAT_BLOCK (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, formParams IN OUT NOCOPY FormParamsRec) IS
cursor cRemessaFechada is
    select cd_remessa
      from DBAMV.remessa_fatura
     where cd_remessa = preg_fat.cd_remessa
       and (dt_entrega_da_fatura is not null or sn_fechada = 'S');

  nCdRemessa       remessa_fatura.cd_remessa%type;
    nAuditoria       number;
    impAud             varchar2(1);
    nCdNotaFiscal    number;
    bExisteNfEmitida boolean;
begin
    Pkg_ffcv_M_LAN_HOS.P_ATUALIZA_STATUS(xml, pREG_FAT);

  -- *** Se a conta tiver sido gerada baseada em outra conta pelo processo de franquia,
  --  o sistema s permite as alteraes a partir da conta de origem mudando os valores
  --  informado para a franquia ***
  If  pReg_Fat.Cd_Reg_Fat_Pai Is Not Null
      or ( formParams.P_MIG_SN_RELACIONADA = 'S' and
           preg_fat.dsp_empresa_atendime <>  formParams.P_MIG_CD_MULTI_EMPRESA)
      Then
    PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','ENABLED',false);
    PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','UPDATEABLE',false);
    PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','INSERT_ALLOWED',false);
  Else

        if   formParams.P_MIG_SN_ABRE_FECHA_CONTA = 'S' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','ENABLED',true);
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','UPDATEABLE',true);
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','INSERT_ALLOWED',true);
        else

            PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','ENABLED',false);
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','UPDATEABLE',false);
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','INSERT_ALLOWED',false);
    end if;
    End If;

    if  formParams.P_MIG_SN_REMESSA_AUTOMATICA = 'S' then

    if  pREG_FAT.SN_Fechada = 'N' and  pREG_FAT.CD_REMESSA is null and  pREG_FAT.DSP_TP_CONVENIO <> 'P' AND  formParams.P_MIG_SN_ABRE_FECHA_CONTA = 'S' Then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','ENABLED',false) ;
      End If;

    end if;

    -- Se a fatura estiver impressa o boto fechar a conta fica  habilitado )
    if  pREG_FAT.DSP_TP_CONVENIO = 'P' then
      If  pREG_FAT.SN_FATURA_IMPRESSA = 'S' then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','ENABLED',true) ;
      else
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','ENABLED',false) ;
      end if;
    end if;

    If  preg_fat.sn_fechada = 'S' And  pReg_Fat.Tp_Mvto Is Null Then
        -- Includo o para checar se a contade Convênio e se a remessa já está entregue,
      -- em caso afirmativo, desabilita o boto de franquia.
      open cRemessaFechada;
      fetch cRemessaFechada into nCdRemessa;
      close cRemessaFechada;
        if  preg_fat.dsp_tp_convenio = 'C' and nCdRemessa is not null then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_FRANQUIA','ENABLED',false);
        else
      nAuditoria := Pkg_ffcv_M_LAN_HOS.F_QTD_AUDITORIA(xml, formParams, preg_fat.cd_reg_fat, 'A');

        if nAuditoria > 0 then
          PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_FRANQUIA','ENABLED',false);
        else
          PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_FRANQUIA','ENABLED',true);
        end if;
    end if;
    Else
    PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_FRANQUIA','ENABLED',false);
    End If;
  --
    if  pREG_FAT.SN_Fechada = 'N' and (  pREG_FAT.DT_INICIO is null or  pREG_FAT.DT_FINAL is null )
         and  pREG_FAT.DSP_TP_CONVENIO <> 'P' then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','ENABLED',false) ;
    end if ;

    if  pREG_FAT.SN_Fechada = 'S' and  pREG_FAT.DSP_SN_FECHADA_REMESSA = 'S' and  pREG_FAT.DSP_TP_CONVENIO <> 'P' then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','ENABLED',false) ;
    end if ;

    if  pREG_FAT.SN_FATURA_IMPRESSA = 'N' and nvl( pcg$ctrl.sn_imprime,'N') = 'N' then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.SN_FECHADA','ENABLED',false) ;
    end if ;

    If  pREG_FAT.SN_Fechada  = 'N' then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REMESSA','UPDATEABLE',true) ;
    Elsif  pREG_FAT.dsp_tp_convenio = 'P' then -- está fechada mas particular
      -- Consulta se existe nota fiscal emitida ou gravada para a conta
      bExisteNfEmitida := M_PKG_FFCV_NOTA_FISCAL.F_EXISTE_NOTA_VALIDA(xml, preg_fat.cd_reg_fat
                                                                                                , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                                , formParams.P_MIG_CD_USUARIO
                                                                                                , false
                                                                                                , false
                                                                                                , nCdNotaFiscal);

        if bExisteNfEmitida then
          PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REMESSA','UPDATEABLE',false);
      Else
          PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REMESSA','UPDATEABLE',true);
      End If;
    Else
           PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REMESSA','UPDATEABLE',false);
    End If;

    --verifica se conta fechada
    if  pREG_FAT.SN_Fechada = 'S' then
      if  formParams.P_MIG_SN_MOSTRA_VL_ORIG = 'S' then
      if    PKG_XML.GetPropVarChar2(xml, 'ITEM','CG$CTRL.CD_PRO_FAT_SOLICITADO','UPDATEABLE') = 'TRUE' then
          PKG_XML.SetPropBoolean(xml, 'ITEM','CG$CTRL.CD_PRO_FAT_SOLICITADO','UPDATEABLE',false) ;
        end if;
      else
      if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_PRO_FAT_SOLICITADO','UPDATEABLE') = 'TRUE' then
          PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_PRO_FAT_SOLICITADO','UPDATEABLE',false) ;
        end if;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DT_INICIO','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DT_INICIO','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DT_FINAL','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DT_FINAL','UPDATEABLE',false) ;
      end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_TIP_ACOM','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_TIP_ACOM','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_NR_CARTEIRA','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NR_CARTEIRA','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_DT_VALIDADE','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_DT_VALIDADE','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_NM_TITULAR','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_TITULAR','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_NM_EMPRESA','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_EMPRESA','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_CD_CATEGORIA','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_CD_CATEGORIA','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_SN_TITULAR','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_TITULAR','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_SN_PENSIONISTA','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_PENSIONISTA','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_CONVENIO','UPDATEABLE') = 'TRUE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CONVENIO','NAVIGABLE',false) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CONVENIO','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_CON_PLA','UPDATEABLE') = 'TRUE' then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CON_PLA','NAVIGABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CON_PLA','UPDATEABLE',false) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_REGRA','UPDATEABLE') = 'TRUE' then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REGRA','NAVIGABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REGRA','UPDATEABLE',false) ;
    end if;

    else
        if  formParams.P_MIG_SN_MOSTRA_VL_ORIG = 'S' then
          if    PKG_XML.GetPropVarChar2(xml, 'ITEM','CG$CTRL.CD_PRO_FAT_SOLICITADO','UPDATEABLE') = 'FALSE' then
              PKG_XML.SetPropBoolean(xml, 'ITEM','CG$CTRL.CD_PRO_FAT_SOLICITADO','ENABLED',true) ;
              PKG_XML.SetPropBoolean(xml, 'ITEM','CG$CTRL.CD_PRO_FAT_SOLICITADO','UPDATEABLE',true) ;
          end if;
      else
          if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_PRO_FAT_SOLICITADO','UPDATEABLE') = 'FALSE' then
          PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_PRO_FAT_SOLICITADO','ENABLED',true) ;
          PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_PRO_FAT_SOLICITADO','UPDATEABLE',true) ;
        end if;
      end if;
    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_CD_CID','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_CD_CID','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_CD_CID','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_REMESSA','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REMESSA','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REMESSA','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DT_INICIO','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DT_INICIO','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DT_INICIO','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DT_FINAL','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DT_FINAL','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DT_FINAL','UPDATEABLE',true) ;
      end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_TIP_ACOM','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_TIP_ACOM','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_TIP_ACOM','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_NR_CARTEIRA','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NR_CARTEIRA','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NR_CARTEIRA','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_DT_VALIDADE','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_DT_VALIDADE','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_DT_VALIDADE','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_NM_TITULAR','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_TITULAR','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_TITULAR','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_NM_EMPRESA','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_EMPRESA','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_EMPRESA','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_CD_CATEGORIA','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_CD_CATEGORIA','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_CD_CATEGORIA','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_SN_TITULAR','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_TITULAR','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_TITULAR','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.DSP_SN_PENSIONISTA','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_PENSIONISTA','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_PENSIONISTA','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_CONVENIO','UPDATEABLE') = 'FALSE' then
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CONVENIO','ENABLED',true) ;
        PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CONVENIO','UPDATEABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_CON_PLA','UPDATEABLE') = 'FALSE' then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CON_PLA','ENABLED',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_CON_PLA','NAVIGABLE',true) ;
    end if;

    if    PKG_XML.GetPropVarChar2(xml, 'ITEM','REG_FAT.CD_REGRA','UPDATEABLE') = 'FALSE' then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REGRA','ENABLED',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.CD_REGRA','UPDATEABLE',true) ;
    end if;
    end if ;

    if  pREG_FAT.DSP_TP_CONVENIO = 'C' or
       ( pREG_FAT.dsp_tp_convenio = 'P' and
         pREG_FAT.cd_convenio not in (3, 42, 8, 138)and
         formParams.P_MIG_CD_HOSPITAL in (444, 445, 446, 448, 449)) then
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NR_CARTEIRA','UPDATEABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_DT_VALIDADE','UPDATEABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_TITULAR','UPDATEABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_EMPRESA','UPDATEABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_CD_CATEGORIA','UPDATEABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_TITULAR','UPDATEABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_PENSIONISTA','UPDATEABLE',true) ;

      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NR_CARTEIRA','NAVIGABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_DT_VALIDADE','NAVIGABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_TITULAR','NAVIGABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_EMPRESA','NAVIGABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_CD_CATEGORIA','NAVIGABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_TITULAR','NAVIGABLE',true) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_PENSIONISTA','NAVIGABLE',true) ;
    else
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NR_CARTEIRA','UPDATEABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_DT_VALIDADE','UPDATEABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_TITULAR','UPDATEABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_EMPRESA','UPDATEABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_CD_CATEGORIA','UPDATEABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_TITULAR','UPDATEABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_PENSIONISTA','UPDATEABLE',false) ;

      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NR_CARTEIRA','NAVIGABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_DT_VALIDADE','NAVIGABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_TITULAR','NAVIGABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_NM_EMPRESA','NAVIGABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_CD_CATEGORIA','NAVIGABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_TITULAR','NAVIGABLE',false) ;
      PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_PENSIONISTA','NAVIGABLE',false) ;
    end if ;

    if  pREG_FAT.SN_Fechada = 'S' AND  pREG_FAT.DSP_TP_CONVENIO = 'P' THEN
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_FECHA_CONTA','ENABLED',true);
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_FECHA_CONTA','NAVIGABLE',true);
    else
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_FECHA_CONTA','ENABLED',false);
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_FECHA_CONTA','NAVIGABLE',false);
    end if;

    if  pREG_FAT.SN_Fechada = 'N' THEN
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_SIMULACAO','ENABLED',true);
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_SIMULACAO','NAVIGABLE',true);
    else
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_SIMULACAO','ENABLED',false);
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_SIMULACAO','NAVIGABLE',false);
    end if;

    if  pREG_FAT.DSP_TP_CONVENIO = 'C' THEN
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_GUIA_TISS','ENABLED',true);
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_GUIA_TISS','NAVIGABLE',true);

	    /*OP 23160*/
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_IMPRIME_GUIA_TISS','ENABLED',true);
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_IMPRIME_GUIA_TISS','NAVIGABLE',true);

    else
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_GUIA_TISS','ENABLED',false);
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_GUIA_TISS','NAVIGABLE',false);

	   /*OP 23160*/
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_IMPRIME_GUIA_TISS','ENABLED',false);
       PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.DSP_SN_IMPRIME_GUIA_TISS','NAVIGABLE',false);
    end if;

    if  preg_fat.cd_reg_fat is not null then

    nAuditoria := Pkg_ffcv_M_LAN_HOS.F_QTD_AUDITORIA(xml, formParams, preg_fat.cd_reg_fat);

    if to_number( formParams.P_MIG_CD_HOSPITAL) = 297 then
          impAud := 'S';
        else
      impAud := formParams.P_MIG_SN_AUDITORIA_CONTA;
      end if;

        if nvl(impAud,'N') = 'S' and nvl(nAuditoria,0) > 0  and  pREG_FAT.DSP_TP_CONVENIO <> 'P' then
          PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_IMPR_AUDITORIA','ENABLED',true);
          PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_CONTA_AUDITADA','ENABLED',true);
        else
            PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_IMPR_AUDITORIA','ENABLED',false);
            PKG_XML.SetPropBoolean(xml, 'ITEM','REG_FAT.BTN_CONTA_AUDITADA','ENABLED',false);
        end if;

    end if;

end ;

PROCEDURE P_CTRL_REG_FAT_BLOCK (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pcg$ctrl CG$CTRLRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REMESSA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REMESSA');
        pREG_FAT.CD_REG_FAT_PAI:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT_PAI');
        pREG_FAT.DSP_EMPRESA_ATENDIME:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_EMPRESA_ATENDIME');
        pREG_FAT.SN_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FECHADA');
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        pREG_FAT.SN_FATURA_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA');
        pREG_FAT.TP_MVTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.TP_MVTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.DT_INICIO:= PKG_XML.GetDate(xml, 'REG_FAT.DT_INICIO');
        pREG_FAT.DT_FINAL:= PKG_XML.GetDate(xml, 'REG_FAT.DT_FINAL');
        pREG_FAT.DSP_SN_FECHADA_REMESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_FECHADA_REMESSA');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA');
        pREG_FAT.DSP_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA');
        pREG_FAT.SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA');
        pREG_FAT.DSP_SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA');
        pCG$CTRL.SN_IMPRIME:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.SN_IMPRIME');
        formParams.P_MIG_SN_RELACIONADA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_RELACIONADA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_SN_ABRE_FECHA_CONTA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ABRE_FECHA_CONTA');
        formParams.P_MIG_SN_REMESSA_AUTOMATICA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_REMESSA_AUTOMATICA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_MIG_SN_MOSTRA_VL_ORIG:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MOSTRA_VL_ORIG');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        formParams.P_MIG_SN_AUDITORIA_CONTA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_AUDITORIA_CONTA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CTRL_REG_FAT_BLOCK_E(xml) THEN
                P_CTRL_REG_FAT_BLOCK(xml, pREG_FAT, pCG$CTRL, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_CTRL_REG_FAT_BLOCK_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REMESSA', pREG_FAT.CD_REMESSA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT_PAI', pREG_FAT.CD_REG_FAT_PAI);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_EMPRESA_ATENDIME', pREG_FAT.DSP_EMPRESA_ATENDIME);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FECHADA', pREG_FAT.SN_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA', pREG_FAT.SN_FATURA_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.TP_MVTO', pREG_FAT.TP_MVTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_INICIO', pREG_FAT.DT_INICIO);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_FINAL', pREG_FAT.DT_FINAL);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_FECHADA_REMESSA', pREG_FAT.DSP_SN_FECHADA_REMESSA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA', pREG_FAT.DSP_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA', pREG_FAT.DSP_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA', pREG_FAT.SN_CONTA_CALCULADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA', pREG_FAT.DSP_SN_CONTA_CALCULADA);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.SN_IMPRIME', pCG$CTRL.SN_IMPRIME);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_RELACIONADA', formParams.P_MIG_SN_RELACIONADA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ABRE_FECHA_CONTA', formParams.P_MIG_SN_ABRE_FECHA_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_REMESSA_AUTOMATICA', formParams.P_MIG_SN_REMESSA_AUTOMATICA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MOSTRA_VL_ORIG', formParams.P_MIG_SN_MOSTRA_VL_ORIG);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_AUDITORIA_CONTA', formParams.P_MIG_SN_AUDITORIA_CONTA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>Chk_Cat_Plano</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_CAT_PLANO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN
  pREG_FAT.DSP_DS_CATEGORIA := M_PKG_FFCV_CATEGORIA_PLANO.F_RETORNA_DESCRICAO(xml, pREG_FAT.DSP_CD_CATEGORIA
                                                                             ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                             ,formParams.P_MIG_CD_USUARIO
                                                                             ,true
                                                                             ,true);
END;

PROCEDURE P_CHK_CAT_PLANO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_DS_CATEGORIA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_CATEGORIA');
        pREG_FAT.DSP_CD_CATEGORIA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_CAT_PLANO_E(xml) THEN
                P_CHK_CAT_PLANO(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_CAT_PLANO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_CATEGORIA', pREG_FAT.DSP_DS_CATEGORIA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA', pREG_FAT.DSP_CD_CATEGORIA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CGFK$CHK_ITREG_FAT_ITREG_FAT_A</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_ITREG_FAT_ITREG_FAT_A (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
	                                       pitreg_fat_relacionado IN OUT NOCOPY ITREG_FAT_RELACIONADORec, pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec,P_FIELD_LEVEL IN BOOLEAN, cSintetico in VarChar2 Default 'F') IS
BEGIN
  DECLARE
      -- Verifica se existe exceção para Porte e Nr.Auxiliares
      Cursor C is
           Select por_ane_tab.cd_por_ane,
                  por_ane_tab.nr_auxiliares
             From DBAMV.por_ane_tab,
                  DBAMV.itregra
            Where itregra.cd_regra = pREG_FAT.CD_REGRA
              and itregra.cd_gru_pro = pITREG_FAT.DSP_CD_GRU_PRO
              and por_ane_tab.cd_tab_fat  = itregra.cd_tab_fat
              and por_ane_tab.cd_pro_fat  = Decode( cSintetico, 'F', pITREG_FAT.CD_PRO_FAT, 'E', pITREG_FAT_REL.CD_PRO_FAT, 'R', pITREG_FAT_RELACIONADO.CD_PRO_FAT, pITREG_FAT_SINTETICO.CD_PRO_FAT )
              and por_ane_tab.dt_vigencia = ( SELECT MAX( porte.dt_vigencia )
                                              FROM DBAMV.por_ane_tab porte,
                                                   DBAMV.itregra itregra
                                             WHERE itregra.cd_regra = pREG_FAT.CD_REGRA
                                                                                  and itregra.cd_gru_pro = pITREG_FAT.DSP_CD_GRU_PRO
                                                                                  and porte.cd_tab_fat  = itregra.cd_tab_fat
                                                                                 and porte.cd_pro_fat  =
                                                   Decode( cSintetico, 'F', pITREG_FAT.CD_PRO_FAT, 'E', pITREG_FAT_REL.CD_PRO_FAT,
                                                          'R', pITREG_FAT_RELACIONADO.CD_PRO_FAT,
                                                               pITREG_FAT_SINTETICO.CD_PRO_FAT )
                                               AND porte.dt_vigencia <=
                                                   Decode( cSintetico, 'F', pITREG_FAT.DT_LANCAMENTO, 'E', pITREG_FAT_REL.DT_LANCAMENTO,
                                                          'R', pITREG_FAT_RELACIONADO.DT_LANCAMENTO,
                                                               pITREG_FAT_SINTETICO.DT_LANCAMENTO ));
  --
  AUX_CD_POR_ANE  PRO_FAT.CD_POR_ANE%TYPE;
  AUX_NR_AUXILIAR PRO_FAT.NR_AUXILIAR%TYPE;
  --
  BEGIN
    OPEN C;
    if cSintetico = 'F' then
      FETCH C INTO AUX_CD_POR_ANE, AUX_NR_AUXILIAR;
      IF C%FOUND THEN
          pITREG_FAT.DSP_CD_POR_ANE  := AUX_CD_POR_ANE;
          pITREG_FAT.DSP_NR_AUXILIAR := AUX_NR_AUXILIAR;
      END IF;
    elsif cSintetico = 'R' then
      FETCH C INTO  AUX_CD_POR_ANE, AUX_NR_AUXILIAR;
      IF C%FOUND THEN
          pITREG_FAT_RELACIONADO.DSP_CD_POR_ANE  := AUX_CD_POR_ANE;
          pITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR := AUX_NR_AUXILIAR;
      END IF;
    elsif cSintetico = 'E' then
      FETCH C INTO  AUX_CD_POR_ANE, AUX_NR_AUXILIAR;
      IF C%FOUND THEN
          pITREG_FAT_REL.DSP_CD_POR_ANE  := AUX_CD_POR_ANE;
          pITREG_FAT_REL.DSP_NR_AUXILIAR := AUX_NR_AUXILIAR;
      END IF;
    else
      FETCH C INTO  AUX_CD_POR_ANE, AUX_NR_AUXILIAR;
      IF C%FOUND THEN
          pITREG_FAT_SINTETICO.DSP_CD_POR_ANE  := AUX_CD_POR_ANE;
          pITREG_FAT_SINTETICO.DSP_NR_AUXILIAR := AUX_NR_AUXILIAR;
      END IF;
    end if ;
    CLOSE C;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END;
END;

PROCEDURE P_CHK_ITREG_FAT_ITREG_FAT_A (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    P_FIELD_LEVEL BOOLEAN;
    cSintetico VarChar2(4000);
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    pitreg_fat_relacionado ITREG_FAT_RELACIONADORec;
    pitreg_fat_sintetico ITREG_FAT_SINTETICORec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT');
        pITREG_FAT_REL.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO');
        pITREG_FAT_REL.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_POR_ANE');
        pITREG_FAT_REL.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_NR_AUXILIAR');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pITREG_FAT_SINTETICO.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.CD_PRO_FAT');
        pITREG_FAT_SINTETICO.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_SINTETICO.DT_LANCAMENTO');
        pITREG_FAT_SINTETICO.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_CD_POR_ANE');
        pITREG_FAT_SINTETICO.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_NR_AUXILIAR');
        pITREG_FAT_RELACIONADO.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.CD_PRO_FAT');
        pITREG_FAT_RELACIONADO.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_RELACIONADO.DT_LANCAMENTO');
        pITREG_FAT_RELACIONADO.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_CD_POR_ANE');
        pITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR');
        pITREG_FAT.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_CD_POR_ANE');
        pITREG_FAT.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_NR_AUXILIAR');
        P_FIELD_LEVEL:= PKG_XML.GetBOOLEAN(xml, 'P_FIELD_LEVEL');
        cSintetico:= PKG_XML.GetVarChar2(xml, 'cSintetico');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITREG_FAT_ITREG_FAT_A_E(xml) THEN
                P_CHK_ITREG_FAT_ITREG_FAT_A(xml, pREG_FAT, pITREG_FAT, pITREG_FAT_REL, pITREG_FAT_RELACIONADO, pITREG_FAT_SINTETICO, P_FIELD_LEVEL, cSintetico);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITREG_FAT_ITREG_FAT_A_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT', pITREG_FAT_REL.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO', pITREG_FAT_REL.DT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_POR_ANE', pITREG_FAT_REL.DSP_CD_POR_ANE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_NR_AUXILIAR', pITREG_FAT_REL.DSP_NR_AUXILIAR);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.CD_PRO_FAT', pITREG_FAT_SINTETICO.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT_SINTETICO.DT_LANCAMENTO', pITREG_FAT_SINTETICO.DT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_CD_POR_ANE', pITREG_FAT_SINTETICO.DSP_CD_POR_ANE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_NR_AUXILIAR', pITREG_FAT_SINTETICO.DSP_NR_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.CD_PRO_FAT', pITREG_FAT_RELACIONADO.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT_RELACIONADO.DT_LANCAMENTO', pITREG_FAT_RELACIONADO.DT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_CD_POR_ANE', pITREG_FAT_RELACIONADO.DSP_CD_POR_ANE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR', pITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO', pITREG_FAT.DSP_CD_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_CD_POR_ANE', pITREG_FAT.DSP_CD_POR_ANE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_NR_AUXILIAR', pITREG_FAT.DSP_NR_AUXILIAR);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CGFK$CHK_TRANSF_CONTAS_FAT_A</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_TRANSF_CONTAS_FAT_A (xml IN OUT NOCOPY PKG_XML.XmlContext,ptransf_contas IN OUT NOCOPY TRANSF_CONTASRec, formParams IN OUT NOCOPY FormParamsRec) IS
vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
  nCdRegra       number;
begin
    --
    M_PKG_FFCV_CONTA.P_RETORNA_CAMPO(xml, pTRANSF_CONTAS.CD_REG_FAT_DEST    -- pCd_Conta
                                    ,'H'                               -- pTp_Conta
                                  ,formParams.P_MIG_CD_MULTI_EMPRESA -- pCd_Multi_Empresa
                                  ,formParams.P_MIG_CD_USUARIO       -- pCd_Usuario
                                  ,true                              -- pRaise
                                  ,true                              -- pMostraMensagem
                                  ,'CD_REGRA'                        -- pNmCampo
                                  ,nCdRegra);                        -- pRetorno

  M_PKG_FFCV_PRO_FAT.P_RETORNA_PORTE_E_AUXILIA(xml, nCdRegra                          -- pCd_Regra
                                                  ,pTRANSF_CONTAS.DSP_CD_GRU_PRO     -- pCd_Gru_Pro
                                                  ,pTRANSF_CONTAS.DSP_CD_PRO_FAT     -- pCd_Pro_fat
                                                  ,pTRANSF_CONTAS.DSP_DT_LANCAMENTO  -- pDt_Lancamento
                                                                ,formParams.P_MIG_CD_MULTI_EMPRESA -- pCd_Multi_Empresa
                                                                ,formParams.P_MIG_CD_USUARIO       -- pCd_Usuario
                                                                ,true                              -- pRaise
                                                                ,true                              -- pMostraMensagem
                                                                ,vLst_Retorno);

    vLst_Local  := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_Retorno);
    --
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'NR_AUXILIARES', pTRANSF_CONTAS.DSP_NR_AUXILIAR, false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'CD_POR_ANE'   , pTRANSF_CONTAS.DSP_CD_POR_ANE , false);
    --
    pkg_parametro.pr_limpar_lista_parametros(vLst_Local);
end;

PROCEDURE P_CHK_TRANSF_CONTAS_FAT_A (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    ptransf_contas TRANSF_CONTASRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pTRANSF_CONTAS.CD_REG_FAT_DEST:= PKG_XML.GetNUMBER(xml, 'TRANSF_CONTAS.CD_REG_FAT_DEST');
        pTRANSF_CONTAS.DSP_CD_GRU_PRO:= PKG_XML.GetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_GRU_PRO');
        pTRANSF_CONTAS.DSP_CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_PRO_FAT');
        pTRANSF_CONTAS.DSP_DT_LANCAMENTO:= PKG_XML.GetDate(xml, 'TRANSF_CONTAS.DSP_DT_LANCAMENTO');
        pTRANSF_CONTAS.DSP_NR_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_NR_AUXILIAR');
        pTRANSF_CONTAS.DSP_CD_POR_ANE:= PKG_XML.GetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_POR_ANE');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_TRANSF_CONTAS_FAT_A_E(xml) THEN
                P_CHK_TRANSF_CONTAS_FAT_A(xml, pTRANSF_CONTAS, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_TRANSF_CONTAS_FAT_A_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'TRANSF_CONTAS.CD_REG_FAT_DEST', pTRANSF_CONTAS.CD_REG_FAT_DEST);
        PKG_XML.SetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_GRU_PRO', pTRANSF_CONTAS.DSP_CD_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_PRO_FAT', pTRANSF_CONTAS.DSP_CD_PRO_FAT);
        PKG_XML.SetDate(xml, 'TRANSF_CONTAS.DSP_DT_LANCAMENTO', pTRANSF_CONTAS.DSP_DT_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_NR_AUXILIAR', pTRANSF_CONTAS.DSP_NR_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_POR_ANE', pTRANSF_CONTAS.DSP_CD_POR_ANE);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CGFK$CHK_TRANSF_CONTAS_FAT_G</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_TRANSF_CONTAS_FAT_G (xml IN OUT NOCOPY PKG_XML.XmlContext,ptransf_contas IN OUT NOCOPY TRANSF_CONTASRec, formParams IN OUT NOCOPY FormParamsRec,cSintetico in VarChar2 Default 'F',
	                                     pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) IS
v_DSP_CD_FOR_APRE  NUMBER;
  bExiste            boolean;
BEGIN
    M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, pTRANSF_CONTAS.CD_CONVENIO_DEST
                                                                         ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                         ,formParams.P_MIG_CD_USUARIO
                                                                         ,pbSnLevantaExecessao
                                                                         ,pbSnLevantaExecessao
                                                                         ,'CD_FOR_APRE'
                                                                         ,v_DSP_CD_FOR_APRE);

    bExiste := M_PKG_FFCV_ITFOR_APRE.F_SN_GRU_FAT_CADASTRADO(xml, v_DSP_CD_FOR_APRE
                                                            ,pTRANSF_CONTAS.DSP_CD_GRU_FAT
                                                            ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                            ,formParams.P_MIG_CD_USUARIO
                                                            ,pbSnLevantaExecessao
                                                            ,pbSnLevantaExecessao);
END;

PROCEDURE P_CHK_TRANSF_CONTAS_FAT_G (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    cSintetico VarChar2(4000);
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    ptransf_contas TRANSF_CONTASRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pTRANSF_CONTAS.CD_CONVENIO_DEST:= PKG_XML.GetNUMBER(xml, 'TRANSF_CONTAS.CD_CONVENIO_DEST');
        pTRANSF_CONTAS.DSP_CD_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_GRU_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        cSintetico:= PKG_XML.GetVarChar2(xml, 'cSintetico');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_TRANSF_CONTAS_FAT_G_E(xml) THEN
                P_CHK_TRANSF_CONTAS_FAT_G(xml, pTRANSF_CONTAS, formParams, cSintetico, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_TRANSF_CONTAS_FAT_G_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'TRANSF_CONTAS.CD_CONVENIO_DEST', pTRANSF_CONTAS.CD_CONVENIO_DEST);
        PKG_XML.SetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_GRU_FAT', pTRANSF_CONTAS.DSP_CD_GRU_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



/*
<DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
<CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
<OBJETIVO>chk_valores_procedimento_rel</OBJETIVO>
<ALTERACOES></ALTERACOES>
*/
PROCEDURE P_CHK_VALORES_PROCEDIMENTO_R (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec,
                                        pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
										formParams IN OUT NOCOPY FormParamsRec,p_cd_pro_fat in VARCHAR2,
										p_tp_gru_fat in VARCHAR2,
										p_dt_lancamento in date,
										p_hr_lancamento in date,
										p_erro_retorno out VARCHAR2) IS
  cSnCancula   VarChar2( 1 ) ;
  nValor    Number ;
  nDummy    Number ;
  nValStart Number ;
  nValTotal Number ;
  vErroRetorno  varchar2(2000);   -- OP 6109 - segmentação
  nVlOper       number;           -- OP 6109 - segmentação
  nVlHonor      number;           -- OP 6109 - segmentação
  nVlFilme      number;           -- OP 6109 - segmentação
  nQtCh         number;           -- OP 6109 - segmentação
  nVlAcres      number;           -- OP 6109 - segmentação
  nVlDesc       number;           -- OP 6109 - segmentação

  Begin
  IF  formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT = 'N' AND
       ( p_tp_gru_fat = 'OP' or FNC_FFCV_SN_OPME( pITREG_FAT.CD_PRO_FAT) = 'S' )THEN
    RETURN;
  END IF;

    -- S valoriza o procedimento relacionado se o tipo de valor for real, caso contrrio a valorizA??o do
    -- procedimento s ocorrer atravs do boto de reclculo da conta
  if Pkg_ffcv_M_LAN_HOS.F_SN_VERIFICA_PRECO_REL(xml, p_cd_pro_fat,  pITREG_FAT.cd_pro_fat,  pREG_FAT.CD_REGRA, p_dt_lancamento) THEN

      -- Valor simblico para ortese e protese, OP não necessita valor em tabela.
      -- se estiver marcado como SN_OPME não necessita de valor em tabela
    if p_tp_gru_fat = 'OP' or fnc_ffcv_sn_opme(p_cd_pro_fat) = 'S' then
        pITREG_FAT_REL.DSP_VL_INICIAL := 1 ;
      end if ;

      -- Verifica se o procedimento pode ser recalculado
      M_PKG_FFCV_PRO_FAT.P_RETORNA_CAMPO(xml, p_cd_pro_fat
                                        ,formParams.P_MIG_CD_MULTI_EMPRESA
                                        ,formParams.P_MIG_CD_USUARIO
                                        ,false
                                        ,false
                                        ,'SN_CALCULA_VALOR'
                                        ,cSnCancula);


      if nvl(cSnCancula,'S') = 'S' then
		-- OP 6109 - 22/04/2013 - segmentação - substituindo parmetros por variveis nos campos IN OUT
		vErroRetorno := p_erro_retorno;
		nVlOper := pITREG_FAT_REL.VL_OPERACIONAL_UNITARIO;
		nVlHonor := pITREG_FAT_REL.VL_HONORARIO_UNITARIO;
		nVlFilme := pITREG_FAT_REL.VL_FILME_UNITARIO;
		nQtCh := pITREG_FAT_REL.QT_CH_UNITARIO;
		nVlAcres := pITREG_FAT_REL.VL_ACRESCIMO;
		nVlDesc := pITREG_FAT_REL.VL_DESCONTO;
		-- OP 6109 - fim

          nValor := val_proc_ffcv( p_cd_pro_fat,
                                         p_dt_lancamento,
                                         p_hr_lancamento,
                                        pREG_FAT.CD_CONVENIO,
                                        pREG_FAT.CD_CON_PLA,
                                        pREG_FAT.DSP_TP_ATENDIMENTO,
                                        pREG_FAT.DSP_CD_TIP_ACOM,
                                        pITREG_FAT_REL.CD_ATI_MED,
                                        pITREG_FAT_REL.VL_PERCENTUAL_MULTIPLA,
                                        vErroRetorno,  --p_erro_retorno,  -- OP 6109 - segmentação
                                        nVlOper,       --pITREG_FAT_REL.VL_OPERACIONAL_UNITARIO,  -- OP 6109 - segmentação
                                        nVlHonor,      --pITREG_FAT_REL.VL_HONORARIO_UNITARIO,  -- OP 6109 - segmentação
                                        nVlFilme,      --pITREG_FAT_REL.VL_FILME_UNITARIO,  -- OP 6109 - segmentação
                                        nDummy,
                                        nDummy,
                                        nQtCh,         --pITREG_FAT_REL.QT_CH_UNITARIO,  -- OP 6109 - segmentação
                                        nVlAcres,      --pITREG_FAT_REL.VL_ACRESCIMO,  -- OP 6109 - segmentação
                                        nVlDesc,       --pITREG_FAT_REL.VL_DESCONTO,  -- OP 6109 - segmentação
                                        pITREG_FAT_REL.DSP_VL_INICIAL,
                                        pITREG_FAT_REL.QT_LANCAMENTO,
                                        nValTotal,
                                        pREG_FAT.CD_REGRA,
                                        pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE,
                                        pITREG_FAT_REL.CD_FRANQUIA,
                                        Null,
                                        pITREG_FAT_REL.CD_REGRA_ACOPLAMENTO,
                                        Null,
                                        pREG_FAT.DSP_TP_CONVENIO,
                                        pREG_FAT.CD_CONVENIO,
                                        pREG_FAT.CD_CON_PLA,
                                        null,
                                        null,
                                        null
                                        ,null
                                        ,null
                                        ) ;

		-- OP 6109 - 22/04/2013 - segmentação - substituindo parmetros por variveis nos campos IN OUT
		p_erro_retorno := vErroRetorno;
		pITREG_FAT_REL.VL_OPERACIONAL_UNITARIO := nVlOper;
		pITREG_FAT_REL.VL_HONORARIO_UNITARIO := nVlHonor;
		pITREG_FAT_REL.VL_FILME_UNITARIO := nVlFilme;
		pITREG_FAT_REL.QT_CH_UNITARIO := nQtCh;
		pITREG_FAT_REL.VL_ACRESCIMO := nVlAcres;
		pITREG_FAT_REL.VL_DESCONTO := nVlDesc;
        -- OP 6109 - fim

          pITREG_FAT_REL.VL_UNITARIO := nValor ;

          pITREG_FAT_REL.VL_TOTAL_CONTA := ROUND( nValTotal + NVL( pITREG_FAT_REL.VL_ACRESCIMO, 0 ) - NVL( pITREG_FAT_REL.VL_DESCONTO, 0 ) +
                                            ( pITREG_FAT_REL.VL_FILME_UNITARIO * pITREG_FAT_REL.QT_LANCAMENTO ), 2 ) ;

      end if;
  end if;
End;

PROCEDURE P_CHK_VALORES_PROCEDIMENTO_R (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    p_cd_pro_fat VARCHAR2(4000);
    p_tp_gru_fat VARCHAR2(4000);
    p_dt_lancamento date;
    p_hr_lancamento date;
    p_erro_retorno VARCHAR2(4000);
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.DSP_VL_INICIAL:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_VL_INICIAL');
        pITREG_FAT_REL.CD_ATI_MED:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_ATI_MED');
        pITREG_FAT_REL.VL_PERCENTUAL_MULTIPLA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_PERCENTUAL_MULTIPLA');
        pITREG_FAT_REL.VL_OPERACIONAL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_OPERACIONAL_UNITARIO');
        pITREG_FAT_REL.VL_HONORARIO_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_HONORARIO_UNITARIO');
        pITREG_FAT_REL.VL_FILME_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_FILME_UNITARIO');
        pITREG_FAT_REL.QT_CH_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.QT_CH_UNITARIO');
        pITREG_FAT_REL.VL_ACRESCIMO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_ACRESCIMO');
        pITREG_FAT_REL.VL_DESCONTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_DESCONTO');
        pITREG_FAT_REL.QT_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.QT_LANCAMENTO');
        pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_PERCENTUAL_PACIENTE');
        pITREG_FAT_REL.CD_FRANQUIA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_FRANQUIA');
        pITREG_FAT_REL.CD_REGRA_ACOPLAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_REGRA_ACOPLAMENTO');
        pITREG_FAT_REL.VL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_UNITARIO');
        pITREG_FAT_REL.VL_TOTAL_CONTA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_TOTAL_CONTA');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM');
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        p_cd_pro_fat:= PKG_XML.GetVARCHAR2(xml, 'p_cd_pro_fat');
        p_tp_gru_fat:= PKG_XML.GetVARCHAR2(xml, 'p_tp_gru_fat');
        p_dt_lancamento:= PKG_XML.Getdate(xml, 'p_dt_lancamento');
        p_hr_lancamento:= PKG_XML.Getdate(xml, 'p_hr_lancamento');
        p_erro_retorno:= PKG_XML.GetVARCHAR2(xml, 'p_erro_retorno');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_VALORES_PROCEDIMENTO_R_E(xml) THEN
                P_CHK_VALORES_PROCEDIMENTO_R(xml, pITREG_FAT, pREG_FAT, pITREG_FAT_REL, formParams, p_cd_pro_fat, p_tp_gru_fat, p_dt_lancamento, p_hr_lancamento, p_erro_retorno);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_VALORES_PROCEDIMENTO_R_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_VL_INICIAL', pITREG_FAT_REL.DSP_VL_INICIAL);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_ATI_MED', pITREG_FAT_REL.CD_ATI_MED);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_PERCENTUAL_MULTIPLA', pITREG_FAT_REL.VL_PERCENTUAL_MULTIPLA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_OPERACIONAL_UNITARIO', pITREG_FAT_REL.VL_OPERACIONAL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_HONORARIO_UNITARIO', pITREG_FAT_REL.VL_HONORARIO_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_FILME_UNITARIO', pITREG_FAT_REL.VL_FILME_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.QT_CH_UNITARIO', pITREG_FAT_REL.QT_CH_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_ACRESCIMO', pITREG_FAT_REL.VL_ACRESCIMO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_DESCONTO', pITREG_FAT_REL.VL_DESCONTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.QT_LANCAMENTO', pITREG_FAT_REL.QT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_PERCENTUAL_PACIENTE', pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_FRANQUIA', pITREG_FAT_REL.CD_FRANQUIA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_REGRA_ACOPLAMENTO', pITREG_FAT_REL.CD_REGRA_ACOPLAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_UNITARIO', pITREG_FAT_REL.VL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_TOTAL_CONTA', pITREG_FAT_REL.VL_TOTAL_CONTA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM', pREG_FAT.DSP_CD_TIP_ACOM);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT', formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'p_erro_retorno', p_erro_retorno);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CGFK$CHK_MOTIVO_AUD_MOT_AUD</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_MOTIVO_AUD_MOT_AUD (xml IN OUT NOCOPY PKG_XML.XmlContext,pauditoria_conta IN OUT NOCOPY AUDITORIA_CONTARec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, formParams IN OUT NOCOPY FormParamsRec,
	                                    nCdMotivoAuditoria in number, vTpAuditoria in varchar2, pbSnLevantaExecessao in boolean, pbSnMostraMensagem in boolean) IS
vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
    vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
  vDsMotivoAuditoria motivo_auditoria.ds_motivo_auditoria%type;
  vTpMotivoAuditoria motivo_auditoria.tp_motivo_auditoria%type;
BEGIN
    M_PKG_FFCV_MOTIVO_AUDITORIA.P_RETORNA_DADOS(xml, nCdMotivoAuditoria
                                               ,formParams.P_MIG_CD_MULTI_EMPRESA
                                               ,formParams.P_MIG_CD_USUARIO
                                             ,pbSnLevantaExecessao
                                             ,pbSnMostraMensagem
                                             ,vLst_Retorno);


  vLst_Local := pkg_parametro.fn_recupera_lista_parametros(vLst_Retorno);
  --
  -- Recuperao dos parametros
  pkg_parametro.pr_recupera_parametro(vLst_Local, 'DS_MOTIVO_AUDITORIA', vDsMotivoAuditoria, false);
  pkg_parametro.pr_recupera_parametro(vLst_Local, 'TP_MOTIVO_AUDITORIA', vTpMotivoAuditoria, false);
  --
  -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
  pkg_parametro.pr_limpar_lista_parametros(vLst_Retorno);

  if vTpMotivoAuditoria = 'A' then
      vDsMotivoAuditoria := null;
      vTpMotivoAuditoria := null;
      if pbSnMostraMensagem then
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
          -- OP 10011 - Incio - trocado msg_alert para chama_mensagem , pois não exibia a mensagem na tela e estava travando o sistema .
          -- PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Ateno'), 'Ateno..: S permitido informar motivo de auditoria operacional.' || chr(10) ||
          --                      'A??o..: Entre em contato com o setor responsvel ou modificque o motivo da auditoria.',pbSnLevantaExecessao);
          --MULTI-IDIOMA: Utiliza do pkg_rmi_traducao.extrair_msg para mensagens (MSG_154)
          PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg(
'MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'), pkg_rmi_traducao.extrair_pkg_msg(
'MSG_154', 'PKG_FFCV_M_LAN_HOS', 'Atenção..: não é permitido informar motivo de auditoria operacional.%s..: Entre em contato com o setor responsável ou modifique o motivo da auditoria.', arg_list(chr(10))), pbSnLevantaExecessao);
          -- OP 10011 - Fim
      end if;
  end if;

  if vTpAuditoria = 'AUDITORIA_CONTA' then
    pAUDITORIA_CONTA.DSP_DS_MOTIVO_AUDITORIA := vDsMotivoAuditoria;
    pAUDITORIA_CONTA.DSP_TP_MOTIVO_AUDITORIA := vTpMotivoAuditoria;
  elsif vTpAuditoria = 'AUDITORIA_DATA' then
    pAUDITORIA_DATA.DSP_DS_MOTIVO_AUDITORIA  := vDsMotivoAuditoria;
    pAUDITORIA_DATA.DSP_TP_MOTIVO_AUDITORIA  := vTpMotivoAuditoria;
  end if;
END;

PROCEDURE P_CHK_MOTIVO_AUD_MOT_AUD (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nCdMotivoAuditoria number;
    vTpAuditoria varchar2(4000);
    pbSnLevantaExecessao boolean;
    pbSnMostraMensagem boolean;
    pauditoria_conta AUDITORIA_CONTARec;
    pauditoria_data AUDITORIA_DATARec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pAUDITORIA_DATA.DSP_DS_MOTIVO_AUDITORIA:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_DATA.DSP_DS_MOTIVO_AUDITORIA');
        pAUDITORIA_DATA.DSP_TP_MOTIVO_AUDITORIA:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_DATA.DSP_TP_MOTIVO_AUDITORIA');
        pAUDITORIA_CONTA.DSP_DS_MOTIVO_AUDITORIA:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_CONTA.DSP_DS_MOTIVO_AUDITORIA');
        pAUDITORIA_CONTA.DSP_TP_MOTIVO_AUDITORIA:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_CONTA.DSP_TP_MOTIVO_AUDITORIA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        nCdMotivoAuditoria:= PKG_XML.Getnumber(xml, 'nCdMotivoAuditoria');
        vTpAuditoria:= PKG_XML.Getvarchar2(xml, 'vTpAuditoria');
        pbSnLevantaExecessao:= PKG_XML.Getboolean(xml, 'pbSnLevantaExecessao');
        pbSnMostraMensagem:= PKG_XML.Getboolean(xml, 'pbSnMostraMensagem');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_MOTIVO_AUD_MOT_AUD_E(xml) THEN
                P_CHK_MOTIVO_AUD_MOT_AUD(xml, pAUDITORIA_CONTA, pAUDITORIA_DATA, formParams, nCdMotivoAuditoria, vTpAuditoria, pbSnLevantaExecessao, pbSnMostraMensagem);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_MOTIVO_AUD_MOT_AUD_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_DATA.DSP_DS_MOTIVO_AUDITORIA', pAUDITORIA_DATA.DSP_DS_MOTIVO_AUDITORIA);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_DATA.DSP_TP_MOTIVO_AUDITORIA', pAUDITORIA_DATA.DSP_TP_MOTIVO_AUDITORIA);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_CONTA.DSP_DS_MOTIVO_AUDITORIA', pAUDITORIA_CONTA.DSP_DS_MOTIVO_AUDITORIA);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_CONTA.DSP_TP_MOTIVO_AUDITORIA', pAUDITORIA_CONTA.DSP_TP_MOTIVO_AUDITORIA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>VALIDA_PROIBICAO</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_VALIDA_PROIBICAO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec) IS
cursor c_Lanc is
    select cd_lancamento,
           dt_lancamento,
           cd_pro_fat,
           cd_guia
    from   DBAMV.itreg_fat
    where  cd_reg_fat = preg_fat.cd_reg_fat;

  Cursor C_guia(p_cd_guia guia.cd_guia%type, p_cd_pro_fat pro_fat.cd_pro_fat%type) is
      Select 1
        from DBAMV.guia,
             DBAMV.it_guia
       where guia.cd_guia = it_guia.cd_guia
         and guia.cd_guia = p_cd_guia
         and it_guia.cd_pro_fat = p_cd_pro_fat
         and guia.tp_situacao <> 'N';

  vProibicao     Varchar2(2);
  vMensagem      Varchar2(2000) := null;
  msg_Proibicao  Varchar2(2000) := null;
  nAutorizadoPorGuia number;
BEGIN
  FOR V_Lanc IN c_Lanc LOOP
      vProibicao := null;

    -- Consulta a proibio
        vMensagem := pack_ffcv.f_proibicao(preg_fat.cd_con_pla
                                                                                                ,preg_fat.cd_convenio
                                                                                                ,V_Lanc.cd_pro_fat
                                                                                                ,vProibicao
                                                                                                ,preg_fat.DSP_TP_ATENDIMENTO
                                                                                                ,V_Lanc.dt_lancamento);

    If vMensagem <> 'OK' then
        open c_guia(V_Lanc.cd_guia,V_Lanc.cd_pro_fat);
        fetch c_guia into nAutorizadoPorGuia;
        close c_guia;
        if nAutorizadoPorGuia is null then
            if msg_Proibicao is null then
              msg_Proibicao := V_Lanc.cd_pro_fat;
            else
              msg_Proibicao := SUBSTR(msg_Proibicao || ', ' || V_Lanc.cd_pro_fat, 1, 1000);
            end if;
        end if;
    end if;
  END LOOP;

  if msg_Proibicao is not null then
      pREG_FAT.CD_CONVENIO := pREG_FAT.CD_CONVENIO_OLD;
      pREG_FAT.CD_CON_PLA  := pREG_FAT.CD_CON_PLA_OLD;
      --MULTI-IDIOMA: Utiliza??o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_22)
      PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_22', 'PKG_FFCV_M_LAN_HOS', 'O Convênio não será alterado. Existem a(s) seguinte(s) proibições: %s', arg_list(msg_Proibicao)), 'E', true);
  end if;

END;

PROCEDURE P_VALIDA_PROIBICAO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.CD_CONVENIO_OLD:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO_OLD');
        pREG_FAT.CD_CON_PLA_OLD:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA_OLD');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_VALIDA_PROIBICAO_E(xml) THEN
                P_VALIDA_PROIBICAO(xml, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_VALIDA_PROIBICAO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO_OLD', pREG_FAT.CD_CONVENIO_OLD);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA_OLD', pREG_FAT.CD_CON_PLA_OLD);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>Valida_Proibicao_Carteira</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_VALIDA_PROIBICAO_CARTEIRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec) IS
Cursor cProibicao Is
    Select Sn_Carteira_Ativo
      From DBAMV.Proibicao_Carteira
     Where Nr_Carteira = preg_fat.dsp_nr_carteira
       And Cd_Convenio = preg_fat.Cd_Convenio
    Order by Dt_Vigencia Desc;

  vAtivo Char(1);
BEGIN
  Open cProibicao;
  Fetch cProibicao Into vAtivo;
  If cProibicao%FOUND Then
      If Nvl(vAtivo,'N') = 'N' Then
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_24)
          PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_24', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Carteira não autorizada pelo Convênio!'),'E',True);
      End If;
  End If;
  Close cProibicao;
END;

PROCEDURE P_VALIDA_PROIBICAO_CARTEIRA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_NR_CARTEIRA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NR_CARTEIRA');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_VALIDA_PROIBICAO_CARTEIRA_E(xml) THEN
                P_VALIDA_PROIBICAO_CARTEIRA(xml, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_VALIDA_PROIBICAO_CARTEIRA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NR_CARTEIRA', pREG_FAT.DSP_NR_CARTEIRA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CHK_AUDITORIA_IN_LOCO</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_AUDITORIA_IN_LOCO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,pdDt_referencia IN DATE
       ,pdhR_referencia IN DATE) IS
CURSOR cAuditoriaInLoco  IS
      SELECT COUNT(1)
        FROM DBAMV.auditoria_in_loco
       WHERE auditoria_in_loco.cd_reg_fat    = nvl(preg_fat.cd_conta_pai,preg_fat.cd_reg_fat)
         AND ((trunc(pdDt_referencia) = trunc(auditoria_in_loco.dt_inicio) and
               to_number(to_char(pdHr_referencia,'HH24MI')) between to_number(to_char(auditoria_in_loco.hr_inicio,'HH24MI')) and 2359)
             or
               (trunc(pdDt_referencia) = trunc(auditoria_in_loco.dt_termino) and
                to_number(to_char(pdHr_referencia,'HH24MI')) between 0000 and to_number(to_char(auditoria_in_loco.hr_termino,'HH24MI')))
             or
               (trunc(pdDt_referencia) > trunc(auditoria_in_loco.dt_inicio) and
                trunc(pdDt_referencia) < trunc(auditoria_in_loco.dt_termino)))
         AND xml.usuario = formParams.P_MIG_CD_USUARIO_AUDIT_IN_LOCO
         AND auditoria_in_loco.cd_usuario_cancelou is null;

  vQtd NUMBER;
BEGIN
     OPEN cAuditoriaInLoco;
    FETCH cAuditoriaInLoco INTO vQtd;
    CLOSE cAuditoriaInLoco;

  IF nvl(vQtd,0) <> 0 THEN
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_25)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_25', 'PKG_FFCV_M_LAN_HOS',
		  'O período no qual consta este item encontra-se travado para auditoria in-loco,  e seu usuário não possui permissão para alterar conta em auditoria'),'i',true);
  END IF;
END;

PROCEDURE P_CHK_AUDITORIA_IN_LOCO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdDt_referencia DATE;
    pdhR_referencia DATE;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONTA_PAI:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONTA_PAI');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        formParams.P_MIG_CD_USUARIO_AUDIT_IN_LOCO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO_AUDIT_IN_LOCO');
        pdDt_referencia:= PKG_XML.GetDATE(xml, 'pdDt_referencia');
        pdhR_referencia:= PKG_XML.GetDATE(xml, 'pdhR_referencia');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_AUDITORIA_IN_LOCO_E(xml) THEN
                P_CHK_AUDITORIA_IN_LOCO(xml, pREG_FAT, formParams, pdDt_referencia, pdhR_referencia);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_AUDITORIA_IN_LOCO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONTA_PAI', pREG_FAT.CD_CONTA_PAI);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO_AUDIT_IN_LOCO', formParams.P_MIG_CD_USUARIO_AUDIT_IN_LOCO);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ATUALIZA_DIARIAS</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_ATUALIZA_DIARIAS (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl_2 IN OUT NOCOPY CG$CTRL_2Rec) IS
cursor cAtendimento is
    select trunc( atendime.dt_atendimento ) dt_atendimento,
           trunc( atendime.dt_alta ) dt_alta
      from DBAMV.atendime
     where atendime.cd_atendimento = preg_fat.cd_atendimento;

  cursor cDiariasAtend is
    select sum( decode( pro_fat.tp_serv_hospitalar, 'DI', itreg_fat.qt_lancamento, 0 ) ) qt_DI,
           sum( decode( pro_fat.tp_serv_hospitalar, 'DU', itreg_fat.qt_lancamento, 0 ) ) qt_DU,
           sum( decode( pro_fat.tp_serv_hospitalar, 'DA', itreg_fat.qt_lancamento, 0 ) ) qt_DA
      from DBAMV.reg_fat,
           DBAMV.itreg_fat,
           DBAMV.pro_fat
     where reg_fat.cd_atendimento = preg_fat.cd_atendimento
       and itreg_fat.cd_reg_fat   = reg_fat.cd_reg_fat
       and pro_fat.cd_pro_fat     = itreg_fat.cd_pro_fat
       and pro_fat.tp_serv_hospitalar in ('DI','DU','DA');

  cursor cDiariasConta is
    select sum( decode( pro_fat.tp_serv_hospitalar, 'DI', itreg_fat.qt_lancamento, 0 ) ) qt_DI,
           sum( decode( pro_fat.tp_serv_hospitalar, 'DU', itreg_fat.qt_lancamento, 0 ) ) qt_DU,
           sum( decode( pro_fat.tp_serv_hospitalar, 'DA', itreg_fat.qt_lancamento, 0 ) ) qt_DA
      from DBAMV.itreg_fat,
           DBAMV.pro_fat
     where itreg_fat.cd_reg_fat   = preg_fat.cd_reg_fat
       and pro_fat.cd_pro_fat     = itreg_fat.cd_pro_fat
       and pro_fat.tp_serv_hospitalar in ('DI','DU','DA');

  vcAtendimento               cAtendimento%rowtype;
  vcDiarias                   cDiariasAtend%rowtype;

begin
 --
 -- dias de permanncia do atendimento
 open cAtendimento;
 fetch cAtendimento into vcAtendimento;
 close cAtendimento;
 pcg$ctrl_2.dsp_at_diaria_perm := trunc( nvl(vcAtendimento.dt_alta, sysdate) ) - trunc(vcAtendimento.dt_atendimento) + 1;
 --
 -- dias de permanncia na conta
 if trunc( preg_fat.dt_inicio) <= trunc(sysdate) then
   preg_fat.dsp_ct_diaria_perm := trunc( nvl(preg_fat.dt_final, sysdate) ) - trunc(preg_fat.dt_inicio) + 1;
  end if;
 --
  -- dirias do atendimento
  open cDiariasAtend;
  fetch cDiariasAtend into vcDiarias;
  close cDiariasAtend;
  pcg$ctrl_2.dsp_at_diaria_pac   := vcDiarias.qt_DI;
  pcg$ctrl_2.dsp_at_diaria_uti   := vcDiarias.qt_DU;
  pcg$ctrl_2.dsp_at_diaria_acomp := vcDiarias.qt_DA;
 --
  -- dirias da conta
  open cDiariasConta;
  fetch cDiariasConta into vcDiarias;
  close cDiariasConta;
  preg_fat.dsp_ct_diaria_pac   := vcDiarias.qt_DI;
  preg_fat.dsp_ct_diaria_uti   := vcDiarias.qt_DU;
  preg_fat.dsp_ct_diaria_acomp := vcDiarias.qt_DA;
 --
end;

PROCEDURE P_ATUALIZA_DIARIAS (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pcg$ctrl_2 CG$CTRL_2Rec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pCG$CTRL_2.DSP_AT_DIARIA_PERM:= PKG_XML.GetNUMBER(xml, 'CG$CTRL_2.DSP_AT_DIARIA_PERM');
        pCG$CTRL_2.DSP_AT_DIARIA_PAC:= PKG_XML.GetNUMBER(xml, 'CG$CTRL_2.DSP_AT_DIARIA_PAC');
        pCG$CTRL_2.DSP_AT_DIARIA_UTI:= PKG_XML.GetNUMBER(xml, 'CG$CTRL_2.DSP_AT_DIARIA_UTI');
        pCG$CTRL_2.DSP_AT_DIARIA_ACOMP:= PKG_XML.GetNUMBER(xml, 'CG$CTRL_2.DSP_AT_DIARIA_ACOMP');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.DT_INICIO:= PKG_XML.GetDate(xml, 'REG_FAT.DT_INICIO');
        pREG_FAT.DSP_CT_DIARIA_PERM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CT_DIARIA_PERM');
        pREG_FAT.DT_FINAL:= PKG_XML.GetDate(xml, 'REG_FAT.DT_FINAL');
        pREG_FAT.DSP_CT_DIARIA_PAC:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CT_DIARIA_PAC');
        pREG_FAT.DSP_CT_DIARIA_UTI:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CT_DIARIA_UTI');
        pREG_FAT.DSP_CT_DIARIA_ACOMP:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CT_DIARIA_ACOMP');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_ATUALIZA_DIARIAS_E(xml) THEN
                P_ATUALIZA_DIARIAS(xml, pREG_FAT, pCG$CTRL_2);
                Pkg_ffcv_M_LAN_HOS_C.P_ATUALIZA_DIARIAS_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'CG$CTRL_2.DSP_AT_DIARIA_PERM', pCG$CTRL_2.DSP_AT_DIARIA_PERM);
        PKG_XML.SetNUMBER(xml, 'CG$CTRL_2.DSP_AT_DIARIA_PAC', pCG$CTRL_2.DSP_AT_DIARIA_PAC);
        PKG_XML.SetNUMBER(xml, 'CG$CTRL_2.DSP_AT_DIARIA_UTI', pCG$CTRL_2.DSP_AT_DIARIA_UTI);
        PKG_XML.SetNUMBER(xml, 'CG$CTRL_2.DSP_AT_DIARIA_ACOMP', pCG$CTRL_2.DSP_AT_DIARIA_ACOMP);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_INICIO', pREG_FAT.DT_INICIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CT_DIARIA_PERM', pREG_FAT.DSP_CT_DIARIA_PERM);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_FINAL', pREG_FAT.DT_FINAL);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CT_DIARIA_PAC', pREG_FAT.DSP_CT_DIARIA_PAC);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CT_DIARIA_UTI', pREG_FAT.DSP_CT_DIARIA_UTI);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CT_DIARIA_ACOMP', pREG_FAT.DSP_CT_DIARIA_ACOMP);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>APAGA_CONTA_KIT</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_APAGA_CONTA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec) IS
BEGIN
   Delete from DBAMV.conta_kit
         where conta_kit.cd_atendimento = pREG_FAT.CD_ATENDIMENTO
           and conta_kit.cd_reg_fat = pREG_FAT.CD_REG_FAT;
END;

PROCEDURE P_APAGA_CONTA_KIT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_APAGA_CONTA_KIT_E(xml) THEN
                P_APAGA_CONTA_KIT(xml, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_APAGA_CONTA_KIT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>PRC_GERA_NF_QDO_FECHA_CONTA</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_GERA_NF_QDO_FECHA_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
vNomeFormulario varchar2(60):=null;
  nAmb            reg_amb.cd_reg_amb%TYPE := null;
  nCdConRec       number := null;
  vMensagemTemp   varchar2(2000);
BEGIN
    vMensagemTemp := M_PKG_FNFI_CONTAS_RECEBER.F_M_F_CHECA_FINCANCEIRO(xml, preg_fat.cd_reg_fat
                                                                                 ,preg_fat.cd_atendimento
                                                                                 ,null
                                                                                 ,'H'
                                                                                 ,pREG_FAT.DSP_TP_CONVENIO
                                                                                     ,formParams.p_mig_cd_multi_empresa
                                                                                     ,formParams.p_mig_cd_usuario
                                                                                     ,false
                                                                                     ,false
                                                                                     ,nCdConRec);

  pack_nota_fiscal.gera_nota_fiscal( p_cd_atendimento => preg_fat.cd_atendimento
                                          ,p_cd_reg_fat => preg_fat.cd_reg_fat
                                          ,p_cd_reg_Amb => nAmb
                                          ,p_con_rec_vl_desconto  => null
                                          ,p_con_rec_vl_acrescimo => null
                                          ,p_empresa => formParams.P_MIG_CD_MULTI_EMPRESA
                                          ,p_nome_formulario => vNomeFormulario
                                          ,p_nCdConRec => nCdConRec);
Exception
  --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_26)
  when others then  PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_26', 'PKG_FFCV_M_LAN_HOS', 'Erro ao gerar NF %s', arg_list(sqlerrm)), 'W', true);
end;

PROCEDURE P_GERA_NF_QDO_FECHA_CONTA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_GERA_NF_QDO_FECHA_CONTA_E(xml) THEN
                P_GERA_NF_QDO_FECHA_CONTA(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_GERA_NF_QDO_FECHA_CONTA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>PRC_VALIDA_PERIODO_LANCTO</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_VALIDA_PERIODO_LANCTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_RECORD_STATUS IN OUT NOCOPY varchar2) IS
BEGIN
  declare
    cursor cConvenioAtend is
    select nvl( a.cd_convenio_secundario, a.cd_convenio ) cd_convenio
        from DBAMV.atendime a
           , DBAMV.reg_fat r
       where a.cd_multi_empresa = formParams.P_MIG_CD_MULTI_EMPRESA
         and a.cd_atendimento = preg_fat.cd_atendimento and a.cd_atendimento = r.cd_atendimento
         and r.cd_reg_fat = preg_fat.cd_reg_fat
		 and r.cd_convenio = a.cd_convenio_secundario
         and exists (select cd_reg_fat
                          from DBAMV.reg_fat
                          where cd_atendimento = a.cd_atendimento
                          and cd_convenio = a.cd_convenio_secundario)
     union all
      select  a.cd_convenio
        from DBAMV.atendime a , DBAMV.reg_fat r
       where a.cd_multi_empresa = formParams.P_MIG_CD_MULTI_EMPRESA
         and a.cd_atendimento = preg_fat.cd_atendimento and a.cd_atendimento = r.cd_atendimento
         and r.cd_reg_fat = preg_fat.cd_reg_fat
	 /* pda RE 380388 - comentado:
         and not exists (select cd_reg_fat
                          from DBAMV.reg_fat
                          where cd_atendimento = a.cd_atendimento
                          and cd_convenio = a.cd_convenio_secundario) */
      ;

    --
	--PDA 296840(fim) - 09/07/2009 - Jansen Gallindo
    -- pda 259970 - fim
    --
    cursor cQtdFora is
    	select count(*) dt_lancamento
 	      from dbamv.itreg_fat
  	   where itreg_fat.cd_reg_fat = pREG_FAT.CD_REG_FAT
    	   and to_char(dt_lancamento,'YYYYMMDD')||to_char(hr_lancamento,'HH24:MI') > to_char(pReg_Fat.Dt_Final,'YYYYMMDDHH24:MI');

  	-- pda 349017 - fim
  	--
  	-- PDA 199694 24/08/2007 (fim) FLÁVIO LAGO

    -- OP 22486 - 20/08/2014 - Retirando max e colocando ordenação para pegar a última conta pela data inicial.
    --   Em determinada situação, a última conta não é a última parcial, então não permitia que o usuário informasse a data
    --   final na última parcial para fazer o desdobramento da conta.
  	CURSOR cUltimaConta(pConv number) IS
			SELECT reg_fat.cd_reg_fat
			  FROM dbamv.reg_fat
			 WHERE reg_fat.cd_atendimento = pREG_FAT.CD_ATENDIMENTO
			   and reg_fat.cd_convenio = pConv
			   and reg_fat.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa   -- OP 32466 - pro cliente 719 precisa filtrar pela empresa
       ORDER BY To_Char(dt_inicio,'yyyymmdd hh24miss') desc;

		nUltimaConta NUMBER(8);
      --
     -- Op 20401 03/06/2014
    CURSOR cContaDepois IS
      SELECT 'X' FROM dbamv.reg_fat
       WHERE cd_reg_fat > pREG_FAT.CD_REG_FAT
         AND sn_fechada = 'N'
		 AND cd_atendimento = pREG_FAT.CD_ATENDIMENTO /*OP 20610*/
         AND cd_convenio = pREG_FAT.CD_CONVENIO;


    vCdConvenioAtendime   atendime.cd_convenio%type;
    vQtdLancamentoFora       number := null;
    vContaDepois    VARCHAR2(01) := null;

	begin
      --
    if  FSV_Record_Status in ( 'INSERT', 'CHANGED' ) then
      --
      if ( to_char( pReg_Fat.Dt_Final,'YYYYMMDDHH24:MI') > to_char(Nvl( pReg_Fat.Dsp_Dt_Alta, sysdate),'YYYYMMDD')||to_char(Nvl( pReg_Fat.Dsp_hr_Alta, sysdate),'HH24:MI') ) then
        if  pReg_Fat.Dsp_Dt_Alta is not null then
          PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_27', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Data/hora final da fatura maior que a data/hora da alta!'),'W',true);
        else
          PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_28', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Data/hora final da fatura maior que hoje!'),'W', true);
        end if;
      end if;
      --
      if ( to_char( pReg_Fat.Dt_Final,'YYYYMMDDHH24:MI') < to_char(Nvl( pReg_Fat.Dsp_Dt_Atendimento, sysdate),'YYYYMMDD')||to_char(Nvl( pReg_Fat.Dsp_hr_Atendimento, sysdate),'HH24:MI') ) then
        if  pReg_Fat.Dsp_Dt_Atendimento is not null then
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_29)
          PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_29', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Data/hora final da fatura menor que a data/hora do atendimento!'),'W', true);
        else
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_30)
          PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_30', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Data/hora final da fatura menor que hoje!'),'W',true);
        end if;
      end if;
        --
      if  pREG_FAT.CD_REG_FAT is not null then
      --
        vCdConvenioAtendime  := null;
		nUltimaConta := null;

        open cConvenioAtend;
        fetch cConvenioAtend into vCdConvenioAtendime;
        close cConvenioAtend;

		open cUltimaConta(vCdConvenioAtendime);
        fetch cUltimaConta into nUltimaConta;
        close cUltimaConta;

        if  (pREG_FAT.CD_CONVENIO <> vCdConvenioAtendime
				or nUltimaConta <> pREG_FAT.CD_REG_FAT)		then

          open cQtdFora;
          fetch cQtdFora into vQtdLancamentoFora;
          close cQtdFora;

            if nvl(vQtdLancamentoFora,0) > 0 then
                --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_31)
                PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_31', 'PKG_FFCV_M_LAN_HOS', 'Atenção: há lançamentos fora do período da conta!'),'W',true);
            end if;
            --
		-- OP 37700 - 29/03/2016 - COmentado pois ser permitido abrir parciais com transferência autom?tica antes da ?ltima conta.
		/*
        -- OP 20401 - 03/06/2014 - validar contas do conv~enio do atendimento se houver parcial maior aberta
        ELSE

          open cQtdFora;
          fetch cQtdFora into vQtdLancamentoFora;
          close cQtdFora;
          OPEN  cContaDepois;
          FETCH cContaDepois INTO vContaDepois;
          CLOSE cContaDepois;
          if nvl(vQtdLancamentoFora,0) > 0 AND Nvl(vContaDepois,'Y') = 'X' then
            PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_59', 'PKG_FFCV_M_LAN_HOS',
              'Ateno: há lançamentos fora do período da Conta! Transfira manualmente estes lançamentos para uma Conta válida antes de efetuar a altera??o.'),'W',true);
          end if;
        -- OP 20401 - fim
            --
		*/
        end if;
      --
      end if;
      --
    end if;
    --
  end;
END;

PROCEDURE P_VALIDA_PERIODO_LANCTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.DT_FINAL:= PKG_XML.GetDate(xml, 'REG_FAT.DT_FINAL');
        pREG_FAT.DSP_DT_ALTA:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ALTA');
        pREG_FAT.DSP_HR_ALTA:= PKG_XML.GetDate(xml, 'REG_FAT.DSP_HR_ALTA');
        pREG_FAT.DSP_DT_ATENDIMENTO:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO');
        pREG_FAT.DSP_HR_ATENDIMENTO:= PKG_XML.GetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_VALIDA_PERIODO_LANCTO_E(xml) THEN
                P_VALIDA_PERIODO_LANCTO(xml, pREG_FAT, formParams, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_VALIDA_PERIODO_LANCTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_FINAL', pREG_FAT.DT_FINAL);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ALTA', pREG_FAT.DSP_DT_ALTA);
        PKG_XML.SetDate(xml, 'REG_FAT.DSP_HR_ALTA', pREG_FAT.DSP_HR_ALTA);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO', pREG_FAT.DSP_DT_ATENDIMENTO);
        PKG_XML.SetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO', pREG_FAT.DSP_HR_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_LE_CONFIGURACAO</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_LE_CONFIGURACAO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec) IS
vSnAlteraAuditoriaInLoco dbasgu.usuarios.sn_altera_auditoria_in_loco%type;

  nCount         Number := 0;
  --
  vLst_Param PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_ParamRet PKG_PARAMETRO.ID_LISTA_PARAM;
  --
Begin
    /******************************************************************************************************************************************
    * Lendo configurtaes da congif_ffcv                                                                                                     *
    *******************************************************************************************************************************************/
  --
  M_PKG_FFCV_CONFIG_FFCV.P_RETORNA_DADOS(xml, formParams.P_MIG_CD_MULTI_EMPRESA
                                                                              , formParams.P_MIG_CD_USUARIO
                                                                              , TRUE
                                                                              , TRUE
                                                                              , vLst_ParamRet);
  --
  -- Recupera lista de retorno
  --
  vLst_Param := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_ParamRet);
  --
  -- Recuperao dos parametros retornados pela Procedure
  --
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_PSDI_PEDIDO',               formParams.P_MIG_SN_PSDI_PEDIDO          , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_PSSD_PEDIDO',               formParams.P_MIG_SN_PSSD_PEDIDO          , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'TP_IMPRESSAO_FATURA',          formParams.P_MIG_TP_IMPRESSAO_FATURA     , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_REMESSA_AUTOMATICA',        formParams.P_MIG_SN_REMESSA_AUTOMATICA   , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'CD_CONVENIO_FAT_EXTRA',        formParams.P_MIG_CD_CONVENIO_FAT_EXTRA   , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'CD_CON_PLA_FAT_EXTRA',         formParams.P_MIG_CD_CON_PLA_FAT_EXTRA    , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_CONTROLE_PROC_PRINC_FATURA',formParams.P_MIG_SN_CONTRL_PROC_PRINC_FAT, false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_FILTRA_PROC_PRECO',         formParams.P_MIG_SN_FILTRA_PROC_PRECO    , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_MOSTRA_VL_ORIG',            formParams.P_MIG_SN_MOSTRA_VL_ORIG       , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_AUDITORIA_CONTA',           formParams.P_MIG_SN_AUDITORIA_CONTA      , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_AUDITA_APOS_IMPRESSAO',     formParams.P_MIG_SN_AUDITA_APOS_IMPRESSAO, false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'CD_ATI_MED_CLINICO',           formParams.P_MIG_CD_ATI_MED_CLINICO      , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_PRESTADOR_DUPLICADO',       formParams.P_MIG_SN_PRESTADOR_DUPLICADO  , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_CHECAGEM_AVI_CIR',          formParams.P_MIG_SN_CHECAGEM_AVI_CIR     , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_CREDENCIADO_AUTO',          formParams.P_MIG_SN_CREDENCIADO_AUTO     , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_PERMITE_AUDITAR_MAIOR',     formParams.P_MIG_SN_PERMITE_AUDITAR_MAIOR, false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_ESTORNO_SOLIC_DEVOL',       formParams.P_MIG_SN_ESTORNO_SOLIC_DEVOL  , false);
  --
  -- Limpando a lista de Parmetros
  --
  pkg_parametro.pr_limpar_lista_parametros(vLst_Param);

  /******************************************************************************************************************************************
   * Lendo configurtaes variveis da clobal do faturamento                                                                                              *
   ******************************************************************************************************************************************/
  formParams.P_MIG_SN_DEVOLUCAO_FAT_SOLIC   := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_DEVOLUCAO_FAT_SOLIC'))), 'N');
  formParams.P_MIG_SN_MULTIPLAS_REGRAS_PACO := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_MULTIPLAS_REGRAS_PACOTE'))), 'N');
  formParams.P_MIG_LCTO_SETOR_NAO_PRODUTIVO := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','LCTO_SETOR_NAO_PRODUTIVO'))), 'N');
  formParams.P_MIG_SN_CREDENCIADO_CENTAVOS  := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_CREDENCIADO_CENTAVOS'))), 'N');
  formParams.P_MIG_SN_CRIA_NF_AO_FECHAR_CT  := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_CRIA_NF_AO_FECHAR_CONTA'))), 'N');
  formParams.P_MIG_SN_DIFEP_OBRIGATORIO     := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_DIFEP_OBRIGATORIO'))), 'N');
  formParams.P_MIG_SN_HAB_DADOS_NOTA_LANC   := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_HAB_DADOS_NOTA_LANC'))), 'N');
  formParams.P_MIG_SN_PERMITE_KIT_PARCIAL   := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_PERMITE_KIT_PARCIAL'))), 'S');
  formParams.P_MIG_SN_PROIBE_LANC_FC        := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_PROIBE_LANC_FC'))), 'N');
  formParams.P_MIG_SN_PROIBE_LANC_NA        := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_PROIBE_LANC_NA'))), 'N');
  formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('FFCV','SN_VALIDA_VALOR_OPME_FATURA'))), 'N');

  /******************************************************************************************************************************************
   * Lendo configurtaes variveis da clobal do MGES                                                                                       *
   ******************************************************************************************************************************************/
  formParams.P_MIG_SN_CONFIRMA_CONSUMO_AVIS := nvl(ltrim(rtrim(pkg_mv2000.le_configuracao('MGES','SN_CONFIRMA_CONSUMO_AVISO'))), 'N');

  /******************************************************************************************************************************************
  * Lendo configuraes da tabela de usuários
  ******************************************************************************************************************************************/
    M_PKG_SGU_USUARIOS.P_RETORNA_DADOS(xml, formParams.P_MIG_CD_MULTI_EMPRESA
                                                                  , formParams.P_MIG_CD_USUARIO
                                                                        , TRUE
                                                                        , TRUE
                                                                        , vLst_ParamRet);

  --
  -- Recupera lista de retorno
  --
  vLst_Param := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_ParamRet);
  --
  -- Recuperao dos parametros retornados pela Procedure
  --
  pkg_parametro.pr_recupera_parametro(vLst_Param,'NM_USUARIO'                 ,formParams.P_MIG_NM_USUARIO         , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_ABRE_FECHA_CONTA'        ,formParams.P_MIG_SN_ABRE_FECHA_CONTA, false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_ALTERA_AUDITORIA_IN_LOCO',vSnAlteraAuditoriaInLoco            , false);
  --
  -- Limpando a lista de Parmetros
  --
  pkg_parametro.pr_limpar_lista_parametros(vLst_Param);

  if nvl(vSnAlteraAuditoriaInLoco, 'N') = 'N' then
    formParams.P_MIG_CD_USUARIO_AUDIT_IN_LOCO := formParams.P_MIG_CD_USUARIO;
  else
    formParams.P_MIG_CD_USUARIO_AUDIT_IN_LOCO := null;
  end if;

  /******************************************************************************************************************************************
  * Lendo configuraes da empresa
  ******************************************************************************************************************************************/
    M_PKG_GLOBAL_MULTI_EMPRESAS.P_RETORNA_DADOS(xml, formParams.P_MIG_CD_MULTI_EMPRESA
                                               , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                 , formParams.P_MIG_CD_USUARIO
                                                                                   , TRUE
                                                                                   , TRUE
                                                                                   , vLst_ParamRet);

  --
  -- Recupera lista de retorno
  --
  vLst_Param := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_ParamRet);
  --
  -- Recuperao dos parametros retornados pela Procedure
  --
  pkg_parametro.pr_recupera_parametro(vLst_Param,'SN_EMPRESA_RELACIONADA',   formParams.P_MIG_SN_RELACIONADA  , false);
  pkg_parametro.pr_recupera_parametro(vLst_Param,'DS_MULTI_EMPRESA', formParams.P_MIG_DS_MULTI_EMPRESA, false);
  --
  -- Limpando a lista de Parmetros
  --
  pkg_parametro.pr_limpar_lista_parametros(vLst_Param);

  /******************************************************************************************************************************************
  * Lendo configuraes sobre setor do usuário
  ******************************************************************************************************************************************/
  if M_PKG_FFCV_CONTA.F_EXISTE_REGRA_USUARIO_SE(xml,  formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                              ,  formParams.P_MIG_CD_USUARIO
                                                                                                 , false
                                                                                                 , false) then
    formParams.P_MIG_SN_USUARIO_SETOR := 'S';
    else
        formParams.P_MIG_SN_USUARIO_SETOR := 'N';
    end if;
END;

PROCEDURE P_LE_CONFIGURACAO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_MIG_SN_PSDI_PEDIDO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSDI_PEDIDO');
        formParams.P_MIG_SN_PSSD_PEDIDO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSSD_PEDIDO');
        formParams.P_MIG_TP_IMPRESSAO_FATURA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_TP_IMPRESSAO_FATURA');
        formParams.P_MIG_SN_REMESSA_AUTOMATICA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_REMESSA_AUTOMATICA');
        formParams.P_MIG_CD_CONVENIO_FAT_EXTRA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_CONVENIO_FAT_EXTRA');
        formParams.P_MIG_CD_CON_PLA_FAT_EXTRA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_CON_PLA_FAT_EXTRA');
        formParams.P_MIG_SN_CONTRL_PROC_PRINC_FAT:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CONTRL_PROC_PRINC_FAT');
        formParams.P_MIG_SN_FILTRA_PROC_PRECO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_FILTRA_PROC_PRECO');
        formParams.P_MIG_SN_MOSTRA_VL_ORIG:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MOSTRA_VL_ORIG');
        formParams.P_MIG_SN_AUDITORIA_CONTA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_AUDITORIA_CONTA');
        formParams.P_MIG_SN_AUDITA_APOS_IMPRESSAO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_AUDITA_APOS_IMPRESSAO');
        formParams.P_MIG_CD_ATI_MED_CLINICO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_ATI_MED_CLINICO');
        formParams.P_MIG_SN_PRESTADOR_DUPLICADO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PRESTADOR_DUPLICADO');
        formParams.P_MIG_SN_CHECAGEM_AVI_CIR:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CHECAGEM_AVI_CIR');
        formParams.P_MIG_SN_CREDENCIADO_AUTO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CREDENCIADO_AUTO');
        formParams.P_MIG_SN_PERMITE_AUDITAR_MAIOR:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PERMITE_AUDITAR_MAIOR');
        formParams.P_MIG_SN_ESTORNO_SOLIC_DEVOL:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ESTORNO_SOLIC_DEVOL');
        formParams.P_MIG_SN_DEVOLUCAO_FAT_SOLIC:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_DEVOLUCAO_FAT_SOLIC');
        formParams.P_MIG_SN_MULTIPLAS_REGRAS_PACO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MULTIPLAS_REGRAS_PACO');
        formParams.P_MIG_LCTO_SETOR_NAO_PRODUTIVO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_LCTO_SETOR_NAO_PRODUTIVO');
        formParams.P_MIG_SN_CREDENCIADO_CENTAVOS:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CREDENCIADO_CENTAVOS');
        formParams.P_MIG_SN_CRIA_NF_AO_FECHAR_CT:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CRIA_NF_AO_FECHAR_CT');
        formParams.P_MIG_SN_DIFEP_OBRIGATORIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_DIFEP_OBRIGATORIO');
        formParams.P_MIG_SN_HAB_DADOS_NOTA_LANC:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_HAB_DADOS_NOTA_LANC');
        formParams.P_MIG_SN_PERMITE_KIT_PARCIAL:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PERMITE_KIT_PARCIAL');
        formParams.P_MIG_SN_PROIBE_LANC_FC:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PROIBE_LANC_FC');
        formParams.P_MIG_SN_PROIBE_LANC_NA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PROIBE_LANC_NA');
        formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT');
        formParams.P_MIG_SN_CONFIRMA_CONSUMO_AVIS:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CONFIRMA_CONSUMO_AVIS');
        formParams.P_MIG_NM_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_NM_USUARIO');
        formParams.P_MIG_SN_ABRE_FECHA_CONTA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ABRE_FECHA_CONTA');
        formParams.P_MIG_CD_USUARIO_AUDIT_IN_LOCO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO_AUDIT_IN_LOCO');
        formParams.P_MIG_SN_RELACIONADA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_RELACIONADA');
        formParams.P_MIG_DS_MULTI_EMPRESA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_DS_MULTI_EMPRESA');
        formParams.P_MIG_SN_USUARIO_SETOR:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_USUARIO_SETOR');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_LE_CONFIGURACAO_E(xml) THEN
                P_LE_CONFIGURACAO(xml, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_LE_CONFIGURACAO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSDI_PEDIDO', formParams.P_MIG_SN_PSDI_PEDIDO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PSSD_PEDIDO', formParams.P_MIG_SN_PSSD_PEDIDO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_TP_IMPRESSAO_FATURA', formParams.P_MIG_TP_IMPRESSAO_FATURA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_REMESSA_AUTOMATICA', formParams.P_MIG_SN_REMESSA_AUTOMATICA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_CONVENIO_FAT_EXTRA', formParams.P_MIG_CD_CONVENIO_FAT_EXTRA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_CON_PLA_FAT_EXTRA', formParams.P_MIG_CD_CON_PLA_FAT_EXTRA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CONTRL_PROC_PRINC_FAT', formParams.P_MIG_SN_CONTRL_PROC_PRINC_FAT);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_FILTRA_PROC_PRECO', formParams.P_MIG_SN_FILTRA_PROC_PRECO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MOSTRA_VL_ORIG', formParams.P_MIG_SN_MOSTRA_VL_ORIG);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_AUDITORIA_CONTA', formParams.P_MIG_SN_AUDITORIA_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_AUDITA_APOS_IMPRESSAO', formParams.P_MIG_SN_AUDITA_APOS_IMPRESSAO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_ATI_MED_CLINICO', formParams.P_MIG_CD_ATI_MED_CLINICO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PRESTADOR_DUPLICADO', formParams.P_MIG_SN_PRESTADOR_DUPLICADO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CHECAGEM_AVI_CIR', formParams.P_MIG_SN_CHECAGEM_AVI_CIR);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CREDENCIADO_AUTO', formParams.P_MIG_SN_CREDENCIADO_AUTO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PERMITE_AUDITAR_MAIOR', formParams.P_MIG_SN_PERMITE_AUDITAR_MAIOR);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ESTORNO_SOLIC_DEVOL', formParams.P_MIG_SN_ESTORNO_SOLIC_DEVOL);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_DEVOLUCAO_FAT_SOLIC', formParams.P_MIG_SN_DEVOLUCAO_FAT_SOLIC);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_MULTIPLAS_REGRAS_PACO', formParams.P_MIG_SN_MULTIPLAS_REGRAS_PACO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_LCTO_SETOR_NAO_PRODUTIVO', formParams.P_MIG_LCTO_SETOR_NAO_PRODUTIVO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CREDENCIADO_CENTAVOS', formParams.P_MIG_SN_CREDENCIADO_CENTAVOS);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CRIA_NF_AO_FECHAR_CT', formParams.P_MIG_SN_CRIA_NF_AO_FECHAR_CT);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_DIFEP_OBRIGATORIO', formParams.P_MIG_SN_DIFEP_OBRIGATORIO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_HAB_DADOS_NOTA_LANC', formParams.P_MIG_SN_HAB_DADOS_NOTA_LANC);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PERMITE_KIT_PARCIAL', formParams.P_MIG_SN_PERMITE_KIT_PARCIAL);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PROIBE_LANC_FC', formParams.P_MIG_SN_PROIBE_LANC_FC);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PROIBE_LANC_NA', formParams.P_MIG_SN_PROIBE_LANC_NA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT', formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_CONFIRMA_CONSUMO_AVIS', formParams.P_MIG_SN_CONFIRMA_CONSUMO_AVIS);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_NM_USUARIO', formParams.P_MIG_NM_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_ABRE_FECHA_CONTA', formParams.P_MIG_SN_ABRE_FECHA_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO_AUDIT_IN_LOCO', formParams.P_MIG_CD_USUARIO_AUDIT_IN_LOCO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_RELACIONADA', formParams.P_MIG_SN_RELACIONADA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_DS_MULTI_EMPRESA', formParams.P_MIG_DS_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_USUARIO_SETOR', formParams.P_MIG_SN_USUARIO_SETOR);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_verifica_proibicao</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_VERIFICA_PROIBICAO (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pnCdConPla       in number
                               , pnCdConvenio     in number
                               , pvCdProFat       in varchar2
                               , pvTpAtendimento  in varchar2
                               , pdDtReferencia   in date
                               , pnCdSetor        in number default null
                               , pnCdMultiEmpresa in number default null
                               , pnCdAtendimento  in number default null
                               , pnQtdlanc        in number default null) IS
vMensagem          varchar2(4000);
  vTpProibicao       varchar2(100);
  bSn_Proibe_Lanc_Fc boolean;
  bSn_Proibe_Lanc_Na boolean;
begin
  vMensagem := pack_ffcv.f_proibicao (pnCdConPla
                                          , pnCdConvenio
                                          , pvCdProFat
                                          , vTpProibicao
                                          , pvTpAtendimento
                                          , pdDtReferencia
                                          , pnCdSetor
                                          , pnCdMultiEmpresa
                                          , pnCdAtendimento
                                          , pnQtdlanc);

  if vMensagem <> 'OK' then
      if vTpProibicao = 'FC' then
        if  formParams.P_MIG_SN_PROIBE_LANC_FC = 'S' then
            bSn_Proibe_Lanc_Fc := true;
        else
             bSn_Proibe_Lanc_Fc := false;
        end if;

      -- Alerta para procedimentos com proibio de fora da conta.
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
      PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'), vMensagem || '!', bSn_Proibe_Lanc_Fc);

	-- pda 468098 - 21/10/2011 - Amalia Arajo - não estava disparando mensagem de AG para o usuário na digita??o do item
	elsif vTpProibicao = 'AG' then
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_64)
      PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
			  pkg_rmi_traducao.extrair_pkg_msg('MSG_64', 'PKG_FFCV_M_LAN_HOS', '%s! Deve ser Autorizado por Guia.', arg_list(vMensagem)), false);
    -- pda 468098 - fim

    elsif vTpProibicao = 'NA' then
      --
        if  formParams.P_MIG_SN_PROIBE_LANC_NA = 'S' then
            bSn_Proibe_Lanc_Na := true;
        else
             bSn_Proibe_Lanc_Na := false;
        end if;

      -- Alerta para procedimentos com proibio de não Autorizado.
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
      PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'), vMensagem || '!', bSn_Proibe_Lanc_Na);
      end if;
  end if;
end;

PROCEDURE P_VERIFICA_PROIBICAO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pnCdConPla number;
    pnCdConvenio number;
    pvCdProFat varchar2(4000);
    pvTpAtendimento varchar2(4000);
    pdDtReferencia date;
    pnCdSetor number;
    pnCdMultiEmpresa number;
    pnCdAtendimento number;
    pnQtdlanc number;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_SN_PROIBE_LANC_FC:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PROIBE_LANC_FC');
        formParams.P_MIG_SN_PROIBE_LANC_NA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PROIBE_LANC_NA');
        pnCdConPla:= PKG_XML.Getnumber(xml, 'pnCdConPla');
        pnCdConvenio:= PKG_XML.Getnumber(xml, 'pnCdConvenio');
        pvCdProFat:= PKG_XML.Getvarchar2(xml, 'pvCdProFat');
        pvTpAtendimento:= PKG_XML.Getvarchar2(xml, 'pvTpAtendimento');
        pdDtReferencia:= PKG_XML.Getdate(xml, 'pdDtReferencia');
        pnCdSetor:= PKG_XML.Getnumber(xml, 'pnCdSetor');
        pnCdMultiEmpresa:= PKG_XML.Getnumber(xml, 'pnCdMultiEmpresa');
        pnCdAtendimento:= PKG_XML.Getnumber(xml, 'pnCdAtendimento');
        pnQtdlanc:= PKG_XML.Getnumber(xml, 'pnQtdlanc');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_VERIFICA_PROIBICAO_E(xml) THEN
                P_VERIFICA_PROIBICAO(xml, formParams, pnCdConPla, pnCdConvenio, pvCdProFat, pvTpAtendimento, pdDtReferencia, pnCdSetor, pnCdMultiEmpresa, pnCdAtendimento, pnQtdlanc);
                Pkg_ffcv_M_LAN_HOS_C.P_VERIFICA_PROIBICAO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PROIBE_LANC_FC', formParams.P_MIG_SN_PROIBE_LANC_FC);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PROIBE_LANC_NA', formParams.P_MIG_SN_PROIBE_LANC_NA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_checa_repasse_item</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
PROCEDURE P_CHECA_REPASSE_ITEM (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec,nCdRegFat in number, nCdLancamento in number) IS

  Cursor c_Repasse is
    Select it.cd_repasse
      FROM dbamv.it_repasse it
    WHERE it.cd_reg_fat = nCdRegFat
      AND it.cd_lancamento_fat = nCdLancamento;

  nCdRepasse number;
Begin
  Open  c_Repasse;
  Fetch c_Repasse into nCdRepasse;
  Close c_Repasse;

  If nCdRepasse is not null THEN
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_65)
    PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
		  pkg_rmi_traducao.extrair_pkg_msg('MSG_65', 'PKG_FFCV_M_LAN_HOS',
			  'Atenção..: Este lançamento já foi repassado, não pode ser excluido.%s..: Para altera-lo é necessário cancelar o repasse. ', arg_list(chr(10))), TRUE);
  End if;

    if Trunc(  pITREG_FAT.DT_LANCAMENTO ) = Trunc(  pREG_FAT.DSP_DT_ATENDIMENTO ) then
      if To_Date( To_Char( SysDate, 'dd/mm/yyyy' ) || ' ' ||  To_Char(  pITREG_FAT.HR_LANCAMENTO, 'hh24:mi' ), 'dd/mm/yyyy hh24:mi' ) <
         To_Date( To_Char( SysDate, 'dd/mm/yyyy' ) || ' ' ||  To_Char(  pREG_FAT.DSP_HR_ATENDIMENTO, 'hh24:mi' ), 'dd/mm/yyyy hh24:mi' ) then
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_52)
        PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
				  pkg_rmi_traducao.extrair_pkg_msg('MSG_52', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Data do lançamento não pode ser menor que data do atendimento!'), True);
      end if;
    end if;
end;

PROCEDURE P_CHECA_REPASSE_ITEM (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nCdRegFat number;
    nCdLancamento number;
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_DT_ATENDIMENTO:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO');
        pREG_FAT.DSP_HR_ATENDIMENTO:= PKG_XML.GetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT.HR_LANCAMENTO');
        nCdRegFat:= PKG_XML.Getnumber(xml, 'nCdRegFat');
        nCdLancamento:= PKG_XML.Getnumber(xml, 'nCdLancamento');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHECA_REPASSE_ITEM_E(xml) THEN
                P_CHECA_REPASSE_ITEM(xml, pITREG_FAT, pREG_FAT, nCdRegFat, nCdLancamento);
                Pkg_ffcv_M_LAN_HOS_C.P_CHECA_REPASSE_ITEM_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO', pREG_FAT.DSP_DT_ATENDIMENTO);
        PKG_XML.SetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO', pREG_FAT.DSP_HR_ATENDIMENTO);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT.HR_LANCAMENTO', pITREG_FAT.HR_LANCAMENTO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_checa_procedimento</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHECA_PROCEDIMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,
	                                FSV_RECORD_STATUS IN OUT NOCOPY varchar2) IS
BEGIN
    if  pITREG_FAT.CD_PRO_FAT is not null then
        pCG$CTRL.DSP_ERRO_VALOR := null;
      if  FSV_Record_Status <> 'QUERY' and Nvl(  pITREG_FAT.DSP_VL_INICIAL, 0 ) = 0 then
        Pkg_ffcv_M_LAN_HOS.P_CHK_VALORES_PROCEDIMENTO(xml, pITREG_FAT, pREG_FAT, formParams, pITREG_FAT.CD_PRO_FAT,
                                  pITREG_FAT.DSP_TP_GRU_FAT,
                                  pITREG_FAT.DT_LANCAMENTO,
                                  pITREG_FAT.HR_LANCAMENTO,
                                  pCG$CTRL.DSP_ERRO_VALOR) ;
        /* quando os procedimentos so procedimentos relacionados os não necessriamente precisa existir
           valor na tabela de preos do procedimento, com isso este alert não precisa ser executado, pois qunado for recalcular a conta sera
           pego o valor correto do relacionado, com isso neste if abaixo foi colocado para qunado o procedimento não for um item relacionado */
            if  pCG$CTRL.DSP_ERRO_VALOR is not null and  pitreg_fat.cd_lancamento_rel is null then
              --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_58)
              --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_66)
              PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_58', 'PKG_FFCV_M_LAN_HOS', 'Erro'),
							  pkg_rmi_traducao.extrair_pkg_msg('MSG_66', 'PKG_FFCV_M_LAN_HOS', 'Erro..%s', arg_list(pCG$CTRL.DSP_ERRO_VALOR)), True) ;
          end if ;
      end if ;
    end if;

    if  pITREG_FAT.TP_PAGAMENTO = 'X' then
      pITREG_FAT.TP_PAGAMENTO := 'C' ;
      pITREG_FAT.SN_PACIENTE_PAGA := 'S' ;
    else
      pITREG_FAT.SN_PACIENTE_PAGA := 'N' ;
    end if ;
END;

PROCEDURE P_CHECA_PROCEDIMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    pcg$ctrl CG$CTRLRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        pCG$CTRL.DSP_ERRO_VALOR:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.DSP_ERRO_VALOR');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.DSP_VL_INICIAL:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_VL_INICIAL');
        pITREG_FAT.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT.HR_LANCAMENTO');
        pITREG_FAT.CD_LANCAMENTO_REL:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO_REL');
        pITREG_FAT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO');
        pITREG_FAT.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA');
        pITREG_FAT.CD_ATI_MED:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_ATI_MED');
        pITREG_FAT.VL_PERCENTUAL_MULTIPLA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_MULTIPLA');
        pITREG_FAT.VL_OPERACIONAL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_OPERACIONAL_UNITARIO');
        pITREG_FAT.VL_HONORARIO_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_HONORARIO_UNITARIO');
        pITREG_FAT.VL_FILME_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_FILME_UNITARIO');
        pITREG_FAT.QT_CH_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_CH_UNITARIO');
        pITREG_FAT.VL_ACRESCIMO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_ACRESCIMO');
        pITREG_FAT.VL_DESCONTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_DESCONTO');
        pITREG_FAT.QT_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO');
        pITREG_FAT.VL_PERCENTUAL_PACIENTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE');
        pITREG_FAT.CD_FRANQUIA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA');
        pITREG_FAT.CD_REGRA_ACOPLAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_SETOR');
        pITREG_FAT.VL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_UNITARIO');
        pITREG_FAT.VL_TOTAL_CONTA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_TOTAL_CONTA');
        formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHECA_PROCEDIMENTO_E(xml) THEN
                P_CHECA_PROCEDIMENTO(xml, pITREG_FAT, pCG$CTRL, pREG_FAT, formParams, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_CHECA_PROCEDIMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM', pREG_FAT.DSP_CD_TIP_ACOM);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.DSP_ERRO_VALOR', pCG$CTRL.DSP_ERRO_VALOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_VL_INICIAL', pITREG_FAT.DSP_VL_INICIAL);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT', pITREG_FAT.DSP_TP_GRU_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT.HR_LANCAMENTO', pITREG_FAT.HR_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO_REL', pITREG_FAT.CD_LANCAMENTO_REL);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO', pITREG_FAT.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA', pITREG_FAT.SN_PACIENTE_PAGA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_ATI_MED', pITREG_FAT.CD_ATI_MED);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_MULTIPLA', pITREG_FAT.VL_PERCENTUAL_MULTIPLA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_OPERACIONAL_UNITARIO', pITREG_FAT.VL_OPERACIONAL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_HONORARIO_UNITARIO', pITREG_FAT.VL_HONORARIO_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_FILME_UNITARIO', pITREG_FAT.VL_FILME_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_CH_UNITARIO', pITREG_FAT.QT_CH_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_ACRESCIMO', pITREG_FAT.VL_ACRESCIMO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_DESCONTO', pITREG_FAT.VL_DESCONTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO', pITREG_FAT.QT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE', pITREG_FAT.VL_PERCENTUAL_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA', pITREG_FAT.CD_FRANQUIA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO', pITREG_FAT.CD_REGRA_ACOPLAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_SETOR', pITREG_FAT.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_UNITARIO', pITREG_FAT.VL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_TOTAL_CONTA', pITREG_FAT.VL_TOTAL_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT', formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_incrementa_auditoria_conta</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_INCREMENTA_AUDITORIA_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,pauditoria_conta IN OUT NOCOPY AUDITORIA_CONTARec) IS
begin
  pauditoria_conta.dt_auditoria    := sysdate;
  pauditoria_conta.cd_usuario_aud  := xml.usuario;
  if ( pauditoria_conta.cd_auditoria_conta is null) then
    pauditoria_conta.cd_auditoria_conta := Pkg_ffcv_M_LAN_HOS.F_RETORNA_SEQUENCIA_AUD_CONT(xml);
  end if;
end;

PROCEDURE P_INCREMENTA_AUDITORIA_CONTA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pauditoria_conta AUDITORIA_CONTARec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pAUDITORIA_CONTA.DT_AUDITORIA:= PKG_XML.GetDate(xml, 'AUDITORIA_CONTA.DT_AUDITORIA');
        pAUDITORIA_CONTA.CD_USUARIO_AUD:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_CONTA.CD_USUARIO_AUD');
        pAUDITORIA_CONTA.CD_AUDITORIA_CONTA:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_CONTA.CD_AUDITORIA_CONTA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_INCREMENTA_AUDITORIA_CONTA_E(xml) THEN
                P_INCREMENTA_AUDITORIA_CONTA(xml, pAUDITORIA_CONTA);
                Pkg_ffcv_M_LAN_HOS_C.P_INCREMENTA_AUDITORIA_CONTA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetDate(xml, 'AUDITORIA_CONTA.DT_AUDITORIA', pAUDITORIA_CONTA.DT_AUDITORIA);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_CONTA.CD_USUARIO_AUD', pAUDITORIA_CONTA.CD_USUARIO_AUD);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_CONTA.CD_AUDITORIA_CONTA', pAUDITORIA_CONTA.CD_AUDITORIA_CONTA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_altera_nr_auxiliar_digitad</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_ALTERA_NR_AUXILIAR_DIGITAD (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec) IS
cursor cQtdNrAuxiliar is
    SELECT count(1)
      FROM DBAMV.itlan_med itlan_med,
           DBAMV.ati_med   ati_med
     WHERE itlan_med.cd_reg_fat     =  pitreg_fat_REL.cd_reg_fat
       and itlan_med.cd_lancamento  =  pitreg_fat_REL.cd_lancamento
       and itlan_med.cd_ati_med     =  ati_med.cd_ati_med
       and ati_med.tp_funcao        =  'A';

  Cursor C_Medicos is
    Select itlan_med.cd_prestador
      From DBAMV.itlan_med
     Where itlan_med.cd_reg_fat = pITREG_FAT_REL.CD_REG_FAT
       and itlan_med.cd_lancamento = pITREG_FAT_REL.CD_LANCAMENTO ;

Begin
  pCG$CTRL.DSP_NR_AUX_DIGITADO_REL := null;
  pCG$CTRL.DSP_PREST_DIGITADO_REL  := Null ;

  open  cQtdNrAuxiliar;
  fetch cQtdNrAuxiliar into  pCG$CTRL.DSP_NR_AUX_DIGITADO_REL;
  close cQtdNrAuxiliar;

  For V_Medicos in C_Medicos Loop
    pCG$CTRL.DSP_PREST_DIGITADO_REL := pCG$CTRL.DSP_PREST_DIGITADO_REL || '*' || To_Char( V_Medicos.cd_prestador ) || '*' ;
  End Loop ;
end ;

PROCEDURE P_ALTERA_NR_AUXILIAR_DIGITAD (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_rel ITREG_FAT_RELRec;
    pcg$ctrl CG$CTRLRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT');
        pITREG_FAT_REL.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO');
        pCG$CTRL.DSP_NR_AUX_DIGITADO_REL:= PKG_XML.GetNUMBER(xml, 'CG$CTRL.DSP_NR_AUX_DIGITADO_REL');
        pCG$CTRL.DSP_PREST_DIGITADO_REL:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.DSP_PREST_DIGITADO_REL');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_ALTERA_NR_AUXILIAR_DIGITAD_E(xml) THEN
                P_ALTERA_NR_AUXILIAR_DIGITAD(xml, pITREG_FAT_REL, pCG$CTRL);
                Pkg_ffcv_M_LAN_HOS_C.P_ALTERA_NR_AUXILIAR_DIGITAD_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT', pITREG_FAT_REL.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO', pITREG_FAT_REL.CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'CG$CTRL.DSP_NR_AUX_DIGITADO_REL', pCG$CTRL.DSP_NR_AUX_DIGITADO_REL);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.DSP_PREST_DIGITADO_REL', pCG$CTRL.DSP_PREST_DIGITADO_REL);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_convenio_dados</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CONVENIO_DADOS (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,pCd_Convenio          in number                                                    -- Passagem da Chave
                             , pCd_Multi_Empresa     in number    Default dbamv.pkg_mv2000.le_empresa       -- Codigo da MultiEmpresa Logada
                             , pCd_Usuario           in varchar2  Default user                                    -- Nome Do Usuario Logado
                             , pRaise                in boolean   Default True                                    -- Ser ou não levantada a exceção - "Parar"
                             , pMostraMensagem       in boolean   Default True                                    -- Mostra ou não a Mensagem
                             , pNmConvenio           out varchar2
                             , pTpConvenio           out varchar2
                             , pSnFilantropia        out varchar2
                             , pTpFormaGerarConRec   out varchar2
                             , pTpFormaAgrupamento   out varchar2
                             , pTpImportarMatMed     out varchar2
                             , nCdForApre            out number
                             , pSnValidadeCarteira   out varchar2
                             , pSnGuia               out varchar2
                             , pSnCarteriaParticular out varchar2) IS
vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
  vCdForApre     varchar2(1000);
Begin
  --
  pTpConvenio           := null;
  pSnFilantropia        := 'N';
    pTpFormaGerarConRec   := null;
    pTpFormaAgrupamento   := null;
    pTpImportarMatMed     := null;
    nCdForApre            := to_Number(null);
    pSnValidadeCarteira   := 'N';
    pSnGuia               := 'N';
    pSnCarteriaParticular := 'N';

  if pcd_convenio is null then
    return;
  end if;
  --
  M_PKG_FFCV_CONVENIO.P_RETORNA_DADOS(xml, pCd_Convenio
                                     ,pCd_Multi_Empresa
                                     ,pCd_Usuario
                                     ,pRaise
                                     ,pMostraMensagem
                                     ,vLst_Retorno);
  --
  vLst_Local  := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_Retorno);
  --
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'NM_CONVENIO'           ,pNmConvenio          , false);
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'TP_CONVENIO'           ,pTpConvenio          , false);
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'SN_FILANTROPIA'        ,pSnFilantropia       , false);
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'TP_FORMA_GERAR_CON_REC',pTpFormaGerarConRec  , false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'TP_FORMA_AGRUPAMENTO'  ,pTpFormaAgrupamento  , false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'TP_IMPORTAR_MATMED'    ,pTpImportarMatMed    , false);
     PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'CD_FOR_APRE'           ,nCdForApre           , false);
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'SN_VALIDADE_CARTEIRA'  ,pSnValidadeCarteira  , false);
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'SN_GUIA'               ,pSnGuia              , false);
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local,'SN_CARTEIRA_PARTICULAR',pSnCarteriaParticular, false);
  --
  pkg_parametro.pr_limpar_lista_parametros(vLst_Local);
  --
end;

PROCEDURE P_CONVENIO_DADOS (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pCd_Convenio number;
    pCd_Multi_Empresa number;
    pCd_Usuario varchar2(4000);
    pRaise boolean;
    pMostraMensagem boolean;
    pNmConvenio varchar2(4000);
    pTpConvenio varchar2(4000);
    pSnFilantropia varchar2(4000);
    pTpFormaGerarConRec varchar2(4000);
    pTpFormaAgrupamento varchar2(4000);
    pTpImportarMatMed varchar2(4000);
    nCdForApre number;
    pSnValidadeCarteira varchar2(4000);
    pSnGuia varchar2(4000);
    pSnCarteriaParticular varchar2(4000);
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        pCd_Convenio:= PKG_XML.Getnumber(xml, 'pCd_Convenio');
        pCd_Multi_Empresa:= PKG_XML.Getnumber(xml, 'pCd_Multi_Empresa');
        pCd_Usuario:= PKG_XML.Getvarchar2(xml, 'pCd_Usuario');
        pRaise:= PKG_XML.Getboolean(xml, 'pRaise');
        pMostraMensagem:= PKG_XML.Getboolean(xml, 'pMostraMensagem');
        pNmConvenio:= PKG_XML.Getvarchar2(xml, 'pNmConvenio');
        pTpConvenio:= PKG_XML.Getvarchar2(xml, 'pTpConvenio');
        pSnFilantropia:= PKG_XML.Getvarchar2(xml, 'pSnFilantropia');
        pTpFormaGerarConRec:= PKG_XML.Getvarchar2(xml, 'pTpFormaGerarConRec');
        pTpFormaAgrupamento:= PKG_XML.Getvarchar2(xml, 'pTpFormaAgrupamento');
        pTpImportarMatMed:= PKG_XML.Getvarchar2(xml, 'pTpImportarMatMed');
        nCdForApre:= PKG_XML.Getnumber(xml, 'nCdForApre');
        pSnValidadeCarteira:= PKG_XML.Getvarchar2(xml, 'pSnValidadeCarteira');
        pSnGuia:= PKG_XML.Getvarchar2(xml, 'pSnGuia');
        pSnCarteriaParticular:= PKG_XML.Getvarchar2(xml, 'pSnCarteriaParticular');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CONVENIO_DADOS_E(xml) THEN
                P_CONVENIO_DADOS(xml, formParams, pCd_Convenio, pCd_Multi_Empresa, pCd_Usuario, pRaise, pMostraMensagem, pNmConvenio, pTpConvenio, pSnFilantropia, pTpFormaGerarConRec, pTpFormaAgrupamento, pTpImportarMatMed,
				                 nCdForApre, pSnValidadeCarteira, pSnGuia, pSnCarteriaParticular);
                Pkg_ffcv_M_LAN_HOS_C.P_CONVENIO_DADOS_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.Setvarchar2(xml, 'pNmConvenio', pNmConvenio);
        PKG_XML.Setvarchar2(xml, 'pTpConvenio', pTpConvenio);
        PKG_XML.Setvarchar2(xml, 'pSnFilantropia', pSnFilantropia);
        PKG_XML.Setvarchar2(xml, 'pTpFormaGerarConRec', pTpFormaGerarConRec);
        PKG_XML.Setvarchar2(xml, 'pTpFormaAgrupamento', pTpFormaAgrupamento);
        PKG_XML.Setvarchar2(xml, 'pTpImportarMatMed', pTpImportarMatMed);
        PKG_XML.Setnumber(xml, 'nCdForApre', nCdForApre);
        PKG_XML.Setvarchar2(xml, 'pSnValidadeCarteira', pSnValidadeCarteira);
        PKG_XML.Setvarchar2(xml, 'pSnGuia', pSnGuia);
        PKG_XML.Setvarchar2(xml, 'pSnCarteriaParticular', pSnCarteriaParticular);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_abre_conta</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_ABRE_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,pnCdRegFat in number) IS
BEGIN
  update DBAMV.reg_fat
     set sn_fechada = 'N'
   where cd_reg_fat = pnCdRegFat;
exception
    when others then
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_67)
      PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
			  pkg_rmi_traducao.extrair_pkg_msg('MSG_67', 'PKG_FFCV_M_LAN_HOS', 'Atenção..: não foi possível abrir a conta %s.%sMotivo..: %s', arg_list(pnCdRegFat, chr(10), sqlerrm)), true);

END;

PROCEDURE P_ABRE_CONTA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pnCdRegFat number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pnCdRegFat:= PKG_XML.Getnumber(xml, 'pnCdRegFat');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_ABRE_CONTA_E(xml) THEN
                P_ABRE_CONTA(xml, pnCdRegFat);
                Pkg_ffcv_M_LAN_HOS_C.P_ABRE_CONTA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_fecha_conta</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_FECHA_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,pnCdRegFat in number) IS
BEGIN
  update DBAMV.reg_fat
     set sn_fechada = 'S'
   where cd_reg_fat = pnCdRegFat;
exception
    when others then
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_68)
      PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
			  pkg_rmi_traducao.extrair_pkg_msg('MSG_68', 'PKG_FFCV_M_LAN_HOS', 'Atenção..: não foi possível fechar a conta %s.%sMotivo..: %s', arg_list(pnCdRegFat, chr(10), sqlerrm)), true);

END;

PROCEDURE P_FECHA_CONTA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pnCdRegFat number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pnCdRegFat:= PKG_XML.Getnumber(xml, 'pnCdRegFat');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_FECHA_CONTA_E(xml) THEN
                P_FECHA_CONTA(xml, pnCdRegFat);
                Pkg_ffcv_M_LAN_HOS_C.P_FECHA_CONTA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_atualiza_conta_pai</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_ATUALIZA_CONTA_PAI (xml IN OUT NOCOPY PKG_XML.XmlContext,formParams IN OUT NOCOPY FormParamsRec,nCdConta in number, vNmBloco in varchar2 default 'ITREG_FAT') IS
vSnContaOriginal varchar2(1);
BEGIN
  if vNmBloco = 'ITREG_FAT' then
      vSnContaOriginal := 'N';
    elsif vNmBloco = 'ITREG_FAT_ORIGINAL' then
    vSnContaOriginal := 'S';
    end if;

  M_PKG_FFCV_CONTA.P_ATUALIZA_CONTA_PAI_HOSP(xml, nCdConta
                                              ,vSnContaOriginal
                                              ,formParams.P_MIG_CD_MULTI_EMPRESA
                                              ,formParams.P_MIG_CD_USUARIO
                                              ,false
                                              ,false);
END;

PROCEDURE P_ATUALIZA_CONTA_PAI (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nCdConta number;
    vNmBloco varchar2(4000);
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        nCdConta:= PKG_XML.Getnumber(xml, 'nCdConta');
        vNmBloco:= PKG_XML.Getvarchar2(xml, 'vNmBloco');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_ATUALIZA_CONTA_PAI_E(xml) THEN
                P_ATUALIZA_CONTA_PAI(xml, formParams, nCdConta, vNmBloco);
                Pkg_ffcv_M_LAN_HOS_C.P_ATUALIZA_CONTA_PAI_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_valida_preenchimento_proc</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_VALIDA_PREENCHIMENTO_PROC (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, FSV_MODE IN OUT NOCOPY varchar2) IS
BEGIN
  if  pITREG_FAT.CD_PRO_FAT is null and  FSV_mode <> 'QUERY' then
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_69)
      PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
			  pkg_rmi_traducao.extrair_pkg_msg('MSG_69', 'PKG_FFCV_M_LAN_HOS', 'Atenção: é necessário informar um procedimento.'), true);
  end if;
END;

PROCEDURE P_VALIDA_PREENCHIMENTO_PROC (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    FSV_MODE VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        FSV_MODE:= PKG_XML.GetVARCHAR2(xml, 'FSV_MODE');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_VALIDA_PREENCHIMENTO_PROC_E(xml) THEN
                P_VALIDA_PREENCHIMENTO_PROC(xml, pITREG_FAT, FSV_MODE);
                Pkg_ffcv_M_LAN_HOS_C.P_VALIDA_PREENCHIMENTO_PROC_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'FSV_MODE', FSV_MODE);
        out_params := PKG_XML.GetOutputClob(xml);

END;



/*
<DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
<CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
<OBJETIVO>prc_chk_item_gerado_por_pacote</OBJETIVO>
<ALTERACOES></ALTERACOES>
*/
PROCEDURE P_CHK_ITEM_GERADO_POR_PACOTE (xml IN OUT NOCOPY PKG_XML.XmlContext,nCdRegFat in number, nCdLancamento in number) IS

     -- pda 475345 - 13/11/2011 - Amalia Arajo - ALterada condio para nÃ£o permitir excluir procedimento que originou o pacote (cd_lancamento_pac).

     cursor cItemPacote is

       select 'x'

           from dbamv.conta_pacote c

          where c.cd_reg_fat = nCdRegFat

            --and c.cd_lancamento_fat = nCdLancamento

   		 and ( c.cd_lancamento_fat = nCdLancamento OR c.cd_lancamento_pac = nCdLancamento )

            and exists (select 'x'

                          from dbamv.itreg_fat  i,

                               dbamv.pacote p

                       WHERE i.cd_reg_fat = nCdRegFat

                         AND i.cd_conta_pacote = c.cd_conta_pacote

                         AND p.cd_pacote = c.cd_pacote

                         AND i.cd_pro_fat = p.cd_pro_fat);

       cursor cOriginaPacote is

       select 'X'

           from dbamv.itreg_fat i,
                dbamv.conta_pacote c,
                dbamv.pacote p
          where i.cd_reg_fat = nCdRegFat
            AND i.cd_lancamento = nCdLancamento
            AND i.cd_conta_pacote = c.cd_conta_pacote
            AND c.cd_pacote = p.cd_pacote
            AND i.cd_pro_fat = p.cd_pro_fat;

     cSnItemPacote varchar2(1);

   BEGIN

       open cItemPacote;

       fetch cItemPacote into cSnItemPacote;

       if cItemPacote%found then

          close cItemPacote;

           --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)

           --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_70)

           PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),

   				  pkg_rmi_traducao.extrair_pkg_msg('MSG_70', 'PKG_FFCV_M_LAN_HOS',

   					  'Atenção..: Item originado mediante regra de pacote, não podendo ser alterado. %s..: Para excluir este item utilize a tela de manutenção de pacote.', arg_list(chr(10))),TRUE);

       end if;

     close cItemPacote;
     --
     IF  nCdRegFat IS NOT NULL AND  nCdLancamento IS NOT NULL THEN
       --
       cSnItemPacote:=NULL;
       --
       OPEN cOriginaPacote;
       FETCH cOriginaPacote INTO cSnItemPacote;
       CLOSE cOriginaPacote;
       --
       IF cSnItemPacote IS NOT NULL THEN
           PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),

   				  pkg_rmi_traducao.extrair_pkg_msg('MSG_70', 'PKG_FFCV_M_LAN_HOS',

   					  'Atenção..: Item originado mediante regra de pacote, não podendo ser alterado. %s..: Para excluir este item utilize a tela de manutenção de pacote.', arg_list(chr(10))),TRUE);
       END IF;
     END IF;


   END;


PROCEDURE P_CHK_ITEM_GERADO_POR_PACOTE (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nCdRegFat number;
    nCdLancamento number;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        nCdRegFat:= PKG_XML.Getnumber(xml, 'nCdRegFat');
        nCdLancamento:= PKG_XML.Getnumber(xml, 'nCdLancamento');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITEM_GERADO_POR_PACOTE_E(xml) THEN
                P_CHK_ITEM_GERADO_POR_PACOTE(xml, nCdRegFat, nCdLancamento);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_ITEM_GERADO_POR_PACOTE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_chk_compartilhamento_franq</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_COMPARTILHAMENTO_FRANQ (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec) IS
cursor c_Verif is
    select it.cd_pro_fat
      from DBAMV.itreg_fat it,
           DBAMV.reg_fat rg
     WHERE it.cd_reg_fat_pai      = pITREG_FAT.CD_REG_FAT
       and it.cd_lancamento_pai   = pITREG_FAT.CD_LANCAMENTO
       and rg.cd_reg_fat          = it.cd_reg_fat
       and Nvl(rg.sn_fechada,'N') = 'S';

  nCdProFat number;
BEGIN
  OPEN  c_Verif;
  FETCH c_Verif into nCdProFat;
  CLOSE c_Verif;

  IF nCdProFat is not null THEN
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_71)
    PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
		  pkg_rmi_traducao.extrair_pkg_msg('MSG_71', 'PKG_FFCV_M_LAN_HOS',
			  'Atenção..: O Procedimento %s existe em Conta Particular deste atendimento, já Fechada. não pode ser excluído.%s..: Desfazer a franquia para poder excluir o item.', arg_list(pITREG_FAT.CD_PRO_FAT, chr(10))), true);
  END IF;
END;

PROCEDURE P_CHK_COMPARTILHAMENTO_FRANQ (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        pITREG_FAT.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_COMPARTILHAMENTO_FRANQ_E(xml) THEN
                P_CHK_COMPARTILHAMENTO_FRANQ(xml, pITREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_COMPARTILHAMENTO_FRANQ_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO', pITREG_FAT.CD_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_chk_data_atendimento</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CHK_DATA_ATENDIMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,vNmBloco in varchar2) IS
BEGIN
    if vNmBloco = 'ITREG_FAT' then
        if Trunc(  pITREG_FAT.DT_LANCAMENTO ) = Trunc(  pREG_FAT.DSP_DT_ATENDIMENTO ) then
          if To_Date( To_Char( SysDate, 'dd/mm/yyyy' ) || ' ' ||  To_Char(  pITREG_FAT.HR_LANCAMENTO, 'hh24:mi' ), 'dd/mm/yyyy hh24:mi' ) <
             To_Date( To_Char( SysDate, 'dd/mm/yyyy' ) || ' ' ||  To_Char(  pREG_FAT.DSP_HR_ATENDIMENTO, 'hh24:mi' ), 'dd/mm/yyyy hh24:mi' ) then
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_52)
            PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
						  pkg_rmi_traducao.extrair_pkg_msg('MSG_52', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Data do lançamento não pode ser menor que data do atendimento!'), True);
          end if ;
        end if ;
    elsif vNmBloco = 'ITREG_FAT_REL' then
        if Trunc(  pITREG_FAT_REL.DT_LANCAMENTO ) = Trunc(  pREG_FAT.DSP_DT_ATENDIMENTO ) then
          if To_Date( To_Char( SysDate, 'dd/mm/yyyy' ) || ' ' ||  To_Char(  pITREG_FAT_REL.HR_LANCAMENTO, 'hh24:mi' ), 'dd/mm/yyyy hh24:mi' ) <
             To_Date( To_Char( SysDate, 'dd/mm/yyyy' ) || ' ' ||  To_Char(  pREG_FAT.DSP_HR_ATENDIMENTO, 'hh24:mi' ), 'dd/mm/yyyy hh24:mi' ) then
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_52)
            PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
						  pkg_rmi_traducao.extrair_pkg_msg('MSG_52', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Data do lançamento não pode ser menor que data do atendimento!'), True);
          end if;
        end if;
    end if;
END;

PROCEDURE P_CHK_DATA_ATENDIMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    vNmBloco varchar2(4000);
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO');
        pITREG_FAT_REL.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO');
        pREG_FAT.DSP_DT_ATENDIMENTO:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO');
        pREG_FAT.DSP_HR_ATENDIMENTO:= PKG_XML.GetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT.HR_LANCAMENTO');
        vNmBloco:= PKG_XML.Getvarchar2(xml, 'vNmBloco');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CHK_DATA_ATENDIMENTO_E(xml) THEN
                P_CHK_DATA_ATENDIMENTO(xml, pITREG_FAT, pREG_FAT, pITREG_FAT_REL, vNmBloco);
                Pkg_ffcv_M_LAN_HOS_C.P_CHK_DATA_ATENDIMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO', pITREG_FAT_REL.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO', pITREG_FAT_REL.HR_LANCAMENTO);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO', pREG_FAT.DSP_DT_ATENDIMENTO);
        PKG_XML.SetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO', pREG_FAT.DSP_HR_ATENDIMENTO);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT.HR_LANCAMENTO', pITREG_FAT.HR_LANCAMENTO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_lanca_sangue</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_LANCA_SANGUE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number) IS
Cursor C_Sangue is
    Select sangue_aviso.cd_aviso_cirurgia,
            Nvl( sangue_aviso.qt_realizado, sangue_aviso.qt_solicitado ) qt_realizado
      From DBAMV.sangue_aviso
      Where sangue_aviso.cd_cirurgia_aviso = nCdMvtoFalha
        and sangue_aviso.cd_sangue_derivados = nCdItemFalha ;

  nQtLancar Number ;
  nCdAvisoCir Number;

Begin

  Open C_Sangue ;
  Fetch C_Sangue into nCdAvisoCir, nQtLancar ;

  if C_Sangue%notfound then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  else
    pack_lanca_ffcv.lanca_sangue_ffcv( ncdavisocirurgia   => nCdAvisoCir  ,
                                              ncdsanguederivados => nCdItemFalha,
                                              ndiferenca   => nQtLancar,
                                              caction      => 'I',
                                              ncditemmvto  => nCdMvtoFalha ) ;
  end if;
  Close C_Sangue ;
End ;

PROCEDURE P_LANCA_SANGUE (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_LANCA_SANGUE_E(xml) THEN
                P_LANCA_SANGUE(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.P_LANCA_SANGUE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_lanca_equipamento</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_LANCA_EQUIPAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMVtoFalha in number, nCdItemFalha in number) IS
Cursor C_Equipamento is
    Select aviso_equipamentos.cd_aviso_cirurgia,
            Nvl( aviso_equipamentos.qt_utilizada, aviso_equipamentos.qt_solicitada ) qt_utilizada,
            aviso_equipamentos.cd_prestador,
            dt_data_hora_inicial,
            dt_data_hora_final
      From DBAMV.aviso_equipamentos
      Where aviso_equipamentos.cd_cirurgia_aviso = nCdMvtoFalha
        and aviso_equipamentos.cd_aparelho_equipamento = nCdItemFalha ;

  nQtLancar        Number ;
  nPrestador       Number ;
  nCdAvisoCir      Number;
  dDtDataHoraInicial   Date;
  dDtDataHoraFinal     Date;


Begin

  Open C_Equipamento ;
  Fetch C_Equipamento into nCdAvisoCir, nQtLancar, nPrestador, dDtDataHoraInicial, dDtDataHoraFinal ;

  if C_Equipamento%notfound then
    Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  else
    pack_lanca_ffcv.lanca_eqpto_ffcv( ncdavisocirurgia       => nCdAvisoCir,
                                            ncdaparelhoequipamento => nCdItemFalha,
                                            ndiferenca            => nQtLancar,
                                            caction         => 'I',
                                            ncdprestador        => nPrestador,
                                            ncditemmvto     => nCdMvtoFalha,
                                            p_dDtInicio     => dDtDataHoraInicial,
                                            p_dDtFim        => dDtDataHoraFinal
                                              );


  end if;
  Close C_Equipamento ;

End ;

PROCEDURE P_LANCA_EQUIPAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nCdMVtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMVtoFalha:= PKG_XML.Getnumber(xml, 'nCdMVtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_LANCA_EQUIPAMENTO_E(xml) THEN
                P_LANCA_EQUIPAMENTO(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMVtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.P_LANCA_EQUIPAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_lanca_ligacao</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_LANCA_LIGACAO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMvtoFalha in number) IS
Cursor cLigacaoPaciente is
    Select *
      From DBAMV.ligacao_paciente
     Where cd_ligacao_paciente = nCdMvtoFalha;

  vLigacao ligacao_paciente%rowtype;
Begin

    Open cLigacaoPaciente ;
    Fetch cLigacaoPaciente into vLigacao ;

    if cLigacaoPaciente%notfound then
      Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
    else
      pack_aux_ffcv.prc_lanca_ligacao_ffcv(vLigacao);
    end if;

    close cLigacaoPaciente;
end ;

PROCEDURE P_LANCA_LIGACAO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nCdMvtoFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMvtoFalha:= PKG_XML.Getnumber(xml, 'nCdMvtoFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_LANCA_LIGACAO_E(xml) THEN
                P_LANCA_LIGACAO(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMvtoFalha);
                Pkg_ffcv_M_LAN_HOS_C.P_LANCA_LIGACAO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_lanca_sangue_pbsa</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_LANCA_SANGUE_PBSA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMvtoFalha in number, nCdItemFalha in number) IS
cursor cPbsa is
    select it.cd_solic_sangue,
           it.cd_it_solic_sangue,
           it.cd_sangue_derivados,
           it.dt_realizado,
           it.hr_realizado,
           it.qt_realizado,
           it.nr_difep
      from DBAMV.it_solic_sangue it
     where it.cd_it_solic_sangue  = nCdMvtoFalha
       and it.cd_sangue_derivados = nCdItemFalha;

  vcPbsa         cPbsa%rowtype;
begin

  open cPbsa;
  Fetch cPbsa into vcPbsa;

  if cPbsa%notfound then
        Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  else
    pack_aux_ffcv.prc_lanca_sangue_pbsa_ffcv(
                            vcPbsa.cd_solic_sangue
                           ,vcPbsa.cd_it_solic_sangue
                           ,vcPbsa.cd_sangue_derivados
                           ,vcPbsa.qt_realizado
                           ,'I'     -- Insero
                           ,'I'     -- Item de solicitacao
                           ,to_date( to_char(vcPbsa.dt_realizado,'dd/mm/yyyy ')||
                                     to_char(vcPbsa.hr_realizado,'hh24:mi:ss')
                                 , 'dd/mm/yyyy hh24:mi:ss' )
                           ,vcPbsa.nr_difep
                           );
  end if;
  close cPbsa ;
end ;

PROCEDURE P_LANCA_SANGUE_PBSA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nCdMvtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMvtoFalha:= PKG_XML.Getnumber(xml, 'nCdMvtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_LANCA_SANGUE_PBSA_E(xml) THEN
                P_LANCA_SANGUE_PBSA(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMvtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.P_LANCA_SANGUE_PBSA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_lanca_sangue_componen_pbsa</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_LANCA_SANGUE_COMPONEN_PBSA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec,nCdMvtoFalha in number, nCdItemFalha in number) IS
cursor cPbsa is
    select it.cd_solic_sangue,
           itc.cd_it_solic_sangue,
           itc.cd_sangue_derivados,
           it.dt_realizado,
           it.hr_realizado,
           itc.qt_realizada,
           it.nr_difep
      from DBAMV.it_solic_sangue it,
           DBAMV.it_solic_sangue_comp itc
     where itc.cd_it_solic_sangue  = it.cd_it_solic_sangue
       and itc.cd_it_solic_sangue  = nCdMvtoFalha
       and itc.cd_sangue_derivados = nCdItemFalha;

  vcPbsa         cPbsa%rowtype;

begin

  open cPbsa;
  Fetch cPbsa into vcPbsa;

  if cPbsa%notfound then
        Pkg_ffcv_M_LAN_HOS.P_EXCLUI_LOGS(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO);
  else
    pack_aux_ffcv.prc_lanca_sangue_pbsa_ffcv(
                            vcPbsa.cd_solic_sangue
                           ,vcPbsa.cd_it_solic_sangue
                           ,vcPbsa.cd_sangue_derivados
                           ,vcPbsa.qt_realizada
                           ,'I'   -- Insero
                           ,'C'   -- Componente
                           ,to_date( to_char(vcPbsa.dt_realizado,'dd/mm/yyyy ')||
                                     to_char(vcPbsa.hr_realizado,'hh24:mi:ss')
                                 , 'dd/mm/yyyy hh24:mi:ss' )
                           ,vcPbsa.nr_difep);
  end if;
  close cPbsa ;
end ;

PROCEDURE P_LANCA_SANGUE_COMPONEN_PBSA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    nCdMvtoFalha number;
    nCdItemFalha number;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        nCdMvtoFalha:= PKG_XML.Getnumber(xml, 'nCdMvtoFalha');
        nCdItemFalha:= PKG_XML.Getnumber(xml, 'nCdItemFalha');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_LANCA_SANGUE_COMPONEN_PBSA_E(xml) THEN
                P_LANCA_SANGUE_COMPONEN_PBSA(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, nCdMvtoFalha, nCdItemFalha);
                Pkg_ffcv_M_LAN_HOS_C.P_LANCA_SANGUE_COMPONEN_PBSA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_processa_proibicao_ag</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_PROCESSA_PROIBICAO_AG (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
	                                   bEfetuaBaixaConsumo in boolean) IS
vnr_guias Number;
begin
    --
    -- Encontrando ou criando uma guia para o procedimento
    vnr_guias := pkg_ffcv_guia.fnc_obtem_guia_disponibilizada( preg_fat.cd_atendimento,
                                                                     preg_fat.cd_reg_fat,
                                                                     preg_fat.cd_convenio,
                                                                     plog_falha_importacao.cd_pro_fat,
                                                                     pitreg_fat.qt_lancamento,
                                                                     preg_fat.dsp_cd_tip_acom,
                                                                     null, null, null );
    --
    if bEfetuaBaixaConsumo and nvl( vnr_guias, 0 ) = 0 then
        pLOG_FALHA_IMPORTACAO.DSP_SN_OK := 'N';
        pLOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU := null;
  end if;
  --
end;

PROCEDURE P_PROCESSA_PROIBICAO_AG (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    bEfetuaBaixaConsumo boolean;
    preg_fat REG_FATRec;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    pitreg_fat ITREG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.DSP_CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM');
        pLOG_FALHA_IMPORTACAO.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.CD_PRO_FAT');
        pLOG_FALHA_IMPORTACAO.DSP_SN_OK:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.DSP_SN_OK');
        pLOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU');
        pITREG_FAT.QT_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO');
        bEfetuaBaixaConsumo:= PKG_XML.Getboolean(xml, 'bEfetuaBaixaConsumo');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_PROCESSA_PROIBICAO_AG_E(xml) THEN
                P_PROCESSA_PROIBICAO_AG(xml, pREG_FAT, pLOG_FALHA_IMPORTACAO, pITREG_FAT, bEfetuaBaixaConsumo);
                Pkg_ffcv_M_LAN_HOS_C.P_PROCESSA_PROIBICAO_AG_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM', pREG_FAT.DSP_CD_TIP_ACOM);
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.CD_PRO_FAT', pLOG_FALHA_IMPORTACAO.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.DSP_SN_OK', pLOG_FALHA_IMPORTACAO.DSP_SN_OK);
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU', pLOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO', pITREG_FAT.QT_LANCAMENTO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_carrega_dados_it_guia</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_CARREGA_DADOS_IT_GUIA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec) IS
cursor cCdGuia is
        select seq_guia.nextval from sys.dual;

  cursor cItGuia is
    select seq_it_guia.nextval from sys.dual;

    cursor cItens is
      select itreg_fat.cd_lancamento,
             itreg_fat.cd_pro_fat,
             itreg_fat.cd_guia,
             pro_fat.tp_serv_hospitalar,
             itreg_fat.dt_lancamento,
             itreg_fat.qt_lancamento,
             itreg_fat.cd_setor
        from DBAMV.itreg_fat,
             DBAMV.pro_fat
       where itreg_fat.cd_reg_fat = preg_fat.cd_reg_fat
         and pro_fat.cd_pro_fat   = itreg_fat.cd_pro_fat
         and itreg_fat.cd_guia    is null;
    --
    vcItens        cItens%rowtype;
    bRetorno       boolean;
    bGuiaP         boolean := false;
    bGuiaR         boolean := false;
    nCdGuia        guia.cd_guia%type;
    nCdItGuia      it_guia.cd_it_guia%type;
  aTableGuia     pkt_guia.TypTabela;
  aTableItGuia   pkt_it_guia.TypTabela;
    --
begin
    --
    for vcItens in cItens loop
        --
        bRetorno := false;
        --
        bRetorno := pkg_ffcv_guia.fnc_verifica_guia_obrigatoria( preg_fat.cd_atendimento,
                                                                       preg_fat.cd_reg_fat,
                                                                       vcItens.cd_pro_fat,
                                                                       null, null, null,
                                                                       vcItens.dt_lancamento,
                                                                       vcItens.cd_setor          );
        --
        if bRetorno then
            --
            if vcItens.tp_serv_hospitalar in ( 'DA', 'DI', 'DU' ) then
                --
                if not bGuiaR then
                    --
                    open  cCdGuia;
                    fetch cCdGuia into nCdGuia;
                    close cCdGuia;
                  --
                  aTableGuia(1).cd_guia                 := nCdGuia;
                  aTableGuia(1).tp_guia                 := 'R';
                  aTableGuia(1).cd_atendimento          := preg_fat.cd_atendimento;
                  aTableGuia(1).cd_convenio             := preg_fat.cd_convenio;
                  aTableGuia(1).ds_observacao           := 'Guia criada para as Diarias sem guia na Autorizacao Local.';
                  aTableGuia(1).dt_geracao              := sysdate;
                  aTableGuia(1).tp_situacao             := 'P';
                  --
                pkt_guia.insere( aTableGuia );
                    --
                    bGuiaR := true;
                    --
                end if;
                --
                open  cItGuia;
                fetch cItGuia into nCdItGuia;
                close cItGuia;
            --
            aTableItGuia(1).cd_guia                 := nCdGuia;
            aTableItGuia(1).cd_it_guia              := nCdItGuia;
            aTableItGuia(1).cd_pro_fat              := vcItens.cd_pro_fat;
            aTableItGuia(1).qt_autorizado           := nvl(vcItens.qt_lancamento,0);   /* não aceita nulo */
            aTableItGuia(1).dt_geracao              := sysdate;
            aTableItGuia(1).cd_usu_geracao          := xml.usuario;
            --
          pkt_it_guia.insere( aTableItGuia );
              --
            else
                --
                if not bGuiaP then
                    --
                    open  cCdGuia;
                    fetch cCdGuia into nCdGuia;
                    close cCdGuia;
                  --
                  aTableGuia(1).cd_guia                 := nCdGuia;
                  aTableGuia(1).tp_guia                 := 'P';
                  aTableGuia(1).cd_atendimento          := preg_fat.cd_atendimento;
                  aTableGuia(1).cd_convenio             := preg_fat.cd_convenio;
                  aTableGuia(1).ds_observacao           := 'Guia criada para Procedimentos sem guia na Autorizacao Local.';
                  aTableGuia(1).dt_geracao              := sysdate;
                  aTableGuia(1).tp_situacao             := 'P';
                  --
                pkt_guia.insere( aTableGuia );
                    --
                    bGuiaP := true;
                    --
                end if;
                --
                open  cItGuia;
                fetch cItGuia into nCdItGuia;
                close cItGuia;
            --
            aTableItGuia(1).cd_guia                 := nCdGuia;
            aTableItGuia(1).cd_it_guia              := nCdItGuia;
            aTableItGuia(1).cd_pro_fat              := vcItens.cd_pro_fat;
            aTableItGuia(1).qt_autorizado           := nvl(vcItens.qt_lancamento,0);   /* não aceita nulo */
            aTableItGuia(1).dt_geracao              := sysdate;
            aTableItGuia(1).cd_usu_geracao          := xml.usuario;
            --
          pkt_it_guia.insere( aTableItGuia );
              --
            end if;
            --
            update DBAMV.itreg_fat set cd_guia = nCdGuia
             where cd_reg_fat = preg_fat.cd_reg_fat and cd_lancamento = vcItens.cd_lancamento;
            --
        end if;
        --
    end loop;
    --
end;

PROCEDURE P_CARREGA_DADOS_IT_GUIA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_CARREGA_DADOS_IT_GUIA_E(xml) THEN
                P_CARREGA_DADOS_IT_GUIA(xml, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_CARREGA_DADOS_IT_GUIA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:02</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>prc_execucao_valida_qt_lanc</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_EXECUCAO_VALIDA_QT_LANC (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitcob_pre IN OUT NOCOPY ITCOB_PRERec,
	                                     formParams IN OUT NOCOPY FormParamsRec) IS
Cursor c_Setor (v_dt_lancamento  date) is
    Select unid_int.cd_setor
      From DBAMV.mov_int,
           DBAMV.leito,
           DBAMV.unid_int,
           DBAMV.setor
     Where mov_int.cd_atendimento = preg_fat.cd_atendimento
       and mov_int.cd_leito  = leito.cd_leito
       and leito.cd_unid_int = unid_int.cd_unid_int
       and to_date( to_char(mov_int.dt_mov_int, 'dd/mm/yyyy') || ' ' || to_char(mov_int.hr_mov_int, 'hh24:mi'), 'dd/mm/yyyy hh24:mi') <= v_Dt_Lancamento
       and unid_int.cd_setor = setor.cd_setor
       and setor.cd_multi_empresa = formParams.P_MIG_CD_MULTI_EMPRESA
       and ( mov_int.dt_lib_mov is null or
                  mov_int.dt_lib_mov = ( Select Max( mi.dt_lib_mov )
                                           From DBAMV.mov_int mi,
                                                DBAMV.leito le,
                                                DBAMV.unid_int ui,
                                                DBAMV.setor s
                                          Where mi.cd_leito = leito.cd_leito
                                            and le.cd_unid_int = ui.cd_unid_int
                                            and ui.cd_setor = s.cd_setor
                                            and s.cd_multi_empresa = formParams.P_MIG_CD_MULTI_EMPRESA
                                            and mi.cd_atendimento = preg_fat.cd_atendimento ) )
    Order by to_date( to_char(mov_int.dt_mov_int, 'dd/mm/yyyy') || ' ' || to_char(mov_int.hr_mov_int, 'hh24:mi'), 'dd/mm/yyyy hh24:mi') desc;

   dDtLancamento  date;
   nCdSetor       Number ;
   vtipo varchar2(2);
BEGIN
  If  pITREG_FAT.DSP_SN_CADASTRA_VALOR = 'S' AND
     pITCOB_PRE.VL_PRECO_TOTAL IS NOT NULL Then
    pITCOB_PRE.VL_PRECO_TOTAL := pITCOB_PRE.VL_PRECO_UNITARIO * NVL(pITREG_FAT.QT_LANCAMENTO, 1);
  End If;

  if  pITREG_FAT.CD_SETOR is not null then
    pITREG_FAT.DSP_QT_RATEIO := pITREG_FAT.QT_LANCAMENTO ;
  end if ;

  dDtLancamento := to_date( to_char(pitreg_fat.dt_lancamento, 'dd/mm/yyyy') || ' ' || to_char(pitreg_fat.hr_lancamento, 'hh24:mi'), 'dd/mm/yyyy hh24:mi');

  if  pITREG_FAT.CD_SETOR is null then
    Open c_Setor(dDtLancamento) ;
    Fetch c_Setor  into nCdSetor ;
    Close c_Setor ;
    pITREG_FAT.CD_SETOR := nCdSetor ;
  end if ;

    -- verifica se um procedimento do tipo OP
    vtipo:=null;

    M_PKG_FFCV_PRO_FAT.P_RETORNA_CAMPO(xml, pitreg_fat.cd_pro_fat
                                     , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                       , formParams.P_MIG_CD_USUARIO
                                                                       , TRUE
                                                                       , TRUE
                                       ,'TP_GRU_PRO'
                                       ,vtipo);

    if vtipo = 'OP' then
       -- verifica se existe  itcob_pre p/ o referido procediemnto
       update DBAMV.itcob_pre  set vl_preco_total = vl_preco_unitario * pitreg_fat.qt_lancamento
        where   cd_reg_fat = pitreg_fat.cd_reg_fat and cd_lancamento = pitreg_fat.cd_lancamento;
    end if;

END;

PROCEDURE P_EXECUCAO_VALIDA_QT_LANC (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;
    pitcob_pre ITCOB_PRERec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITCOB_PRE.VL_PRECO_TOTAL:= PKG_XML.GetNUMBER(xml, 'ITCOB_PRE.VL_PRECO_TOTAL');
        pITCOB_PRE.VL_PRECO_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITCOB_PRE.VL_PRECO_UNITARIO');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pITREG_FAT.DSP_SN_CADASTRA_VALOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_VALOR');
        pITREG_FAT.QT_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO');
        pITREG_FAT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_SETOR');
        pITREG_FAT.DSP_QT_RATEIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_QT_RATEIO');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT.HR_LANCAMENTO');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        pITREG_FAT.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_EXECUCAO_VALIDA_QT_LANC_E(xml) THEN
                P_EXECUCAO_VALIDA_QT_LANC(xml, pREG_FAT, pITREG_FAT, pITCOB_PRE, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_EXECUCAO_VALIDA_QT_LANC_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITCOB_PRE.VL_PRECO_TOTAL', pITCOB_PRE.VL_PRECO_TOTAL);
        PKG_XML.SetNUMBER(xml, 'ITCOB_PRE.VL_PRECO_UNITARIO', pITCOB_PRE.VL_PRECO_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_SN_CADASTRA_VALOR', pITREG_FAT.DSP_SN_CADASTRA_VALOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO', pITREG_FAT.QT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_SETOR', pITREG_FAT.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_QT_RATEIO', pITREG_FAT.DSP_QT_RATEIO);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT.HR_LANCAMENTO', pITREG_FAT.HR_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO', pITREG_FAT.CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CG$CTRL_2.DSP_TP_PAGAMENTO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_C2_DSP_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2) IS
BEGIN

declare
  v_tpconv     convenio.tp_convenio%type;
  cTpPagamento Char(1);

  CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

  vProced cProced%ROWTYPE;

begin
  IF  FSV_MODE = 'QUERY' THEN
    RETURN;
  END IF;


	OPEN cProced (pITREG_FAT.CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

  IF  pitreg_fat.tp_pagamento not in ('P', 'F', 'C', 'X') THEN
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_58)
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_72)
    PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_58', 'PKG_FFCV_M_LAN_HOS', 'Erro'),
		  pkg_rmi_traducao.extrair_pkg_msg('MSG_72', 'PKG_FFCV_M_LAN_HOS',
			  'Erro..: A forma de pagamento deve ser P - Produção ou C - Convênio ou F - Hospital ou X - Pago pelo Paciente.%s..: Verifica a forma de pagamento do procedimento.', arg_list(chr(10))), TRUE);
  END IF;

  if not (  pITREG_FAT.TP_PAGAMENTO = 'X' or nvl( pITREG_FAT.SN_PACIENTE_PAGA,'N') = 'S' ) then

      -- Consulta o tipo de Convênio
      M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, preg_fat.cd_convenio
                                        , formParams.P_MIG_CD_MULTI_EMPRESA
                                        , formParams.P_MIG_CD_USUARIO
                                        , false
                                        , false
                                        , 'TP_CONVENIO'
                                        , v_tpconv);

    if nvl(v_tpconv,'P')='P' then
        return;
    end if;

    IF  pITREG_FAT.TP_PAGAMENTO in ('P', 'F') THEN
      RETURN;
    END IF;

    cTpPagamento := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pITREG_FAT.CD_PRESTADOR,
                                                                     pREG_FAT.CD_CONVENIO,
                                                                     pREG_FAT.DSP_TP_ATENDIMENTO,
                                                                     pITREG_FAT.CD_PRO_FAT,
                                                                     pREG_FAT.DSP_CD_ORI_ATE, null, null,
																	 --FATURCONV-1726 INI
																	 pREG_FAT.CD_CON_PLA,
																	 pREG_FAT.CD_REGRA,
																	 vProced.cd_gru_pro
																	 --FATURCONV-1726 FIM
																	 );

    if  formParams.P_MIG_CD_HOSPITAL not in (444, 445, 446, 448, 449, 378, 427, 421) then
      IF cTpPagamento in ('F','P') AND  pITREG_FAT.TP_PAGAMENTO = 'C' THEN
                --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_58)
                --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_73)
                PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_58', 'PKG_FFCV_M_LAN_HOS', 'Erro'),
								  pkg_rmi_traducao.extrair_pkg_msg('MSG_73', 'PKG_FFCV_M_LAN_HOS',
									  'Erro..: Prestador não credenciado ou com exceção de credenciamento.%s..: Verificar o cadastro de credenciamento, no cadastro de prestadores', arg_list(CHR(10))), TRUE);
        pITREG_FAT.TP_PAGAMENTO := cTpPagamento;
      end if;
    end if;
  end if ;
end;
END P_I_WVI_C2_DSP_TP_PAGAMENTO;


PROCEDURE P_I_WVI_C2_DSP_TP_PAGAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    FSV_MODE VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
		--FATURCONV-1726 INI
		pREG_FAT.CD_CON_PLA := PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
		pREG_FAT.CD_REGRA := PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
		--FATURCONV-1726 FIM
        pITREG_FAT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO');
        pITREG_FAT.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        FSV_MODE:= PKG_XML.GetVARCHAR2(xml, 'FSV_MODE');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_C2_DSP_TP_PAGAMENTO_E(xml) THEN
                P_I_WVI_C2_DSP_TP_PAGAMENTO(xml, pITREG_FAT, pREG_FAT, formParams, FSV_MODE);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_C2_DSP_TP_PAGAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        --FATURCONV-1726 INI
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
		--FATURCONV-1726 FIM
		PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO', pITREG_FAT.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA', pITREG_FAT.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetVARCHAR2(xml, 'FSV_MODE', FSV_MODE);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>REG_FAT.CD_TIP_ACOM.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_RF_CD_TIP_ACOM (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_RECORD_STATUS IN OUT NOCOPY varchar2) IS
BEGIN

BEGIN
    -- Verifica se existe Tipo de acomodação
  Pkg_ffcv_M_LAN_HOS.P_CHK_REG_FAT_REG_FAT_TIP_A(xml, pREG_FAT, formParams, Pkg_ffcv_M_LAN_HOS.F_VALIDAR_REGISTRO(xml, FSV_RECORD_STATUS), Pkg_ffcv_M_LAN_HOS.F_VALIDAR_REGISTRO(xml, FSV_RECORD_STATUS));

  if Nvl(  pREG_FAT.DSP_SN_ACOMOD_CONTA, 'S' ) <> 'S' then
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_32)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_32', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Esta acomodação não é permitida para lançamento em conta.'), 'W', True) ;
  end if ;

    update DBAMV.reg_fat
       set cd_tip_acom = preg_fat.cd_tip_acom
     where cd_conta_pai = preg_fat.cd_reg_fat
       and cd_reg_fat <> preg_fat.cd_reg_fat;
EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END;
END P_I_WVI_RF_CD_TIP_ACOM;


PROCEDURE P_I_WVI_RF_CD_TIP_ACOM (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_SN_ACOMOD_CONTA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_ACOMOD_CONTA');
        pREG_FAT.CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_TIP_ACOM');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.DSP_DS_TIP_ACOM:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_TIP_ACOM');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_RF_CD_TIP_ACOM_E(xml) THEN
                P_I_WVI_RF_CD_TIP_ACOM(xml, pREG_FAT, formParams, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_RF_CD_TIP_ACOM_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_ACOMOD_CONTA', pREG_FAT.DSP_SN_ACOMOD_CONTA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_TIP_ACOM', pREG_FAT.CD_TIP_ACOM);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_TIP_ACOM', pREG_FAT.DSP_DS_TIP_ACOM);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>REG_FAT.CD_REGRA.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_RF_CD_REGRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_RECORD_STATUS IN OUT NOCOPY varchar2) IS
BEGIN

Pkg_ffcv_M_LAN_HOS.P_CHK_REGRA(xml, pREG_FAT, formParams, Pkg_ffcv_M_LAN_HOS.F_VALIDAR_REGISTRO(xml, FSV_RECORD_STATUS), Pkg_ffcv_M_LAN_HOS.F_VALIDAR_REGISTRO(xml, FSV_RECORD_STATUS));


update DBAMV.reg_fat
   set cd_regra = preg_fat.cd_regra
 where cd_conta_pai = preg_fat.cd_reg_fat
   and cd_reg_fat <> preg_fat.cd_reg_fat;
END P_I_WVI_RF_CD_REGRA;


PROCEDURE P_I_WVI_RF_CD_REGRA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.DSP_DS_REGRA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_DS_REGRA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_RF_CD_REGRA_E(xml) THEN
                P_I_WVI_RF_CD_REGRA(xml, pREG_FAT, formParams, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_RF_CD_REGRA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_DS_REGRA', pREG_FAT.DSP_DS_REGRA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>REG_FAT.DSP_NR_CARTEIRA.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_RF_DSP_NR_CARTEIRA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

DECLARE
  sErro varchar2(200);
  nCdGrupoVal number;
  vRetCarteira varchar(25);
BEGIN
  IF  formParams.P_NR_CARTEIRA <>  pREG_FAT.DSP_NR_CARTEIRA THEN
      IF  pREG_FAT.DSP_NR_CARTEIRA IS NOT NULL THEN

      Pkg_ffcv_M_LAN_HOS.P_VALIDA_PROIBICAO_CARTEIRA(xml, pREG_FAT);

          M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, preg_fat.cd_convenio
                                            , formParams.P_MIG_CD_MULTI_EMPRESA
                                            , formParams.P_MIG_CD_USUARIO
                                            , false
                                            , false
                                            , 'CD_GRUPO_VAL'
                                            , nCdGrupoVal);

      IF nCdGrupoVal is not null THEN
        sErro := pack_val_matricula.grupo_val_convenio(nCdGrupoVal,preg_fat.dsp_nr_carteira, vRetCarteira );
        IF sErro <> 'T' THEN
          PKG_XML_MGS.MSG_ALERT(xml, sErro, 'W', true);
        END IF;
        if vRetCarteira is not null then
            preg_fat.dsp_nr_carteira := vRetCarteira;
        end if;
      END IF;
    END IF;
  END IF;
END;
END P_I_WVI_RF_DSP_NR_CARTEIRA;


PROCEDURE P_I_WVI_RF_DSP_NR_CARTEIRA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_NR_CARTEIRA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_NR_CARTEIRA');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        formParams.P_NR_CARTEIRA:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_NR_CARTEIRA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_RF_DSP_NR_CARTEIRA_E(xml) THEN
                P_I_WVI_RF_DSP_NR_CARTEIRA(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_RF_DSP_NR_CARTEIRA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_NR_CARTEIRA', pREG_FAT.DSP_NR_CARTEIRA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_NR_CARTEIRA', formParams.P_NR_CARTEIRA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>REG_FAT.DSP_DT_VALIDADE.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_RF_DSP_DT_VALIDADE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

Declare
  Cursor c is
    select con_pla.sn_validade_indeterminada
      from DBAMV.con_pla
         , DBAMV.empresa_con_pla
       where empresa_con_pla.cd_convenio = con_pla.cd_convenio
         and empresa_con_pla.cd_con_pla = con_pla.cd_con_pla
         and Empresa_Con_Pla.Cd_Multi_Empresa = formParams.P_MIG_CD_MULTI_EMPRESA
         and con_pla.cd_convenio = preg_fat.cd_convenio
       and con_pla.cd_con_pla  = preg_fat.cd_con_pla;

  cSnIndeterminada varchar2(1):= null;
  cSnValidade      VarChar2(1);
Begin

  if  pREG_FAT.SN_FECHADA = 'N' then

      -- Verifica se deve validar o preenchimento da carteira
      M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, preg_fat.cd_convenio
                                        , formParams.P_MIG_CD_MULTI_EMPRESA
                                        , formParams.P_MIG_CD_USUARIO
                                        , false
                                        , false
                                        , 'SN_VALIDADE_CARTEIRA'
                                        , cSnValidade);
    OPEN  c;
    FETCH c INTO cSnIndeterminada;
    CLOSE c;

    if Nvl( cSnValidade, 'N' ) = 'S' then
      IF  pREG_FAT.DSP_DT_VALIDADE <  pREG_FAT.DSP_DT_ATENDIMENTO THEN
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_33)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_33', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Carteira Vencida !'), 'W', true);
      END IF ;
    end if ;

    if Nvl( cSnValidade, 'N' ) = 'S' then
        IF nvl(cSnIndeterminada, 'S') = 'N' then
          IF  preg_fat.dsp_dt_validade is null THEN
             --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_34)
             PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_34', 'PKG_FFCV_M_LAN_HOS', 'Informe a data de validade da carteira !'), 'E', true);
          END IF;
        END IF;
    end if;
  end if ;
End ;
END P_I_WVI_RF_DSP_DT_VALIDADE;


PROCEDURE P_I_WVI_RF_DSP_DT_VALIDADE (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.SN_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FECHADA');
        pREG_FAT.DSP_DT_VALIDADE:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_VALIDADE');
        pREG_FAT.DSP_DT_ATENDIMENTO:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_RF_DSP_DT_VALIDADE_E(xml) THEN
                P_I_WVI_RF_DSP_DT_VALIDADE(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_RF_DSP_DT_VALIDADE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FECHADA', pREG_FAT.SN_FECHADA);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_VALIDADE', pREG_FAT.DSP_DT_VALIDADE);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO', pREG_FAT.DSP_DT_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>REG_FAT.PRE-DELETE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PD_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

DECLARE
    --> Verifica se existi conta filha para a conta que ser excluda.
    cursor cQtdConta is
      select count(1)
        from DBAMV.reg_fat
       where cd_conta_pai = pREG_FAT.CD_REG_FAT;

  vTpConvenio           convenio.tp_convenio%type;
  vQtd                  number;
  bExisteNfEmitida      boolean;
  bExisteNfCancelada    boolean;
  bExisteConRec         Boolean;
  nCdConRec             Number;
  nCdNotaFiscal         Number;
  vMensagem             varchar2(2000);
BEGIN

    -- Consulta o tipo de Convênio
  M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, preg_fat.cd_convenio
                                    , formParams.P_MIG_CD_MULTI_EMPRESA
                                    , formParams.P_MIG_CD_USUARIO
                                    , false
                                    , false
                                    , 'TP_CONVENIO'
                                    , vTpConvenio);

  -- Consulta se existe nota fiscal emitida ou gravada para a conta
  bExisteNfEmitida := M_PKG_FFCV_NOTA_FISCAL.F_EXISTE_NOTA_VALIDA(xml
                                                                  , preg_fat.cd_reg_fat
                                                                  , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                  , formParams.P_MIG_CD_USUARIO
                                                                  , false
                                                                  , false

                                                                  , nCdNotaFiscal);
  /*
	PDA748874 - Inic?o
	Esse bloco de Código foi retirado de dentro da condi??o que verifica se o tipo do Convênio particular(if vTpConvenio = 'P' then),
	pois precisa ser executado independente do tipo de Convênio. Tido que ocorria casos em que a conta original era de Convênio,
	e o usuário alterava para particular, emitia a nota, em seguida cancelava a nota e depois alterava novamente a conta para Convênio.
	Com isso ao tentar excluir a conta ocorria (Erro de integridade (DBAMV.NOTA_FISCAL_REG_FAT_FK) - registro filho encontrado)
	pois não estava realizando o update na tebela de nota fiscal se o Convênio fosse diferente de particular
  */
  -- Consulta se existe nota fiscal cancelada vinculada a conta.
  bExisteNfCancelada := M_PKG_FFCV_NOTA_FISCAL.F_EXISTE_NOTA_CANCELADA(xml, preg_fat.cd_reg_fat
                                                                                                       , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                                         , formParams.P_MIG_CD_USUARIO
                                                                                                         , false
                                                                                                         , false);
  -- Se a NF estiver cancelada, apaga o atendimento e conta da tabela de NF para que possa excluir a conta no faturamento.
  If bExisteNfCancelada Then
	  Update DBAMV.nota_fiscal
		 Set cd_atendimento = null
		   , cd_reg_fat = null
	   where cd_atendimento = preg_fat.cd_atendimento
		 and cd_reg_fat = preg_fat.cd_reg_fat;
  End If;
 -- PDA748874 - Fim
  -- Se for Convênio particular
  if vTpConvenio = 'P' then

      -- Pesquisa contas a receber para o Convênio particular
      vMensagem := M_PKG_FNFI_CONTAS_RECEBER.F_M_F_CHECA_FINCANCEIRO(xml, preg_fat.cd_reg_fat               -- pCdConta
                                                                                                                                 ,preg_fat.cd_atendimento           -- pCdAtendimento
                                                                                                                                ,null                              -- pCdNotaFiscal
                                                                                                                                ,'H'                               -- pTpConta
                                                                                                                                ,vTpConvenio                       -- pTpConvenio
                                                                                                                                ,formParams.P_MIG_CD_MULTI_EMPRESA -- pCd_Multi_Empresa
                                                                                                                                ,formParams.P_MIG_CD_USUARIO       -- pCd_Usuario
                                                                                                                                ,false                             -- pRaise
                                                                                                                                ,false                             -- pMostraMensagem
                                                                                                                                ,nCdConRec);
  -- Se for NF de Convênio emite a mensagem
  Else
      -- Pesquisa contas a receber para o Convênio
      vMensagem := M_PKG_FNFI_CONTAS_RECEBER.F_M_F_CHECA_FINCANCEIRO(xml
                                                                   , null                              -- pCdConta
                                                                   , null                              -- pCdAtendimento
                                                                   , nCdNotaFiscal                     -- pCdNotaFiscal
                                                                   , 'H'                               -- pTpConta
                                                                   , vTpConvenio                       -- pTpConvenio
                                                                   , formParams.P_MIG_CD_MULTI_EMPRESA -- pCd_Multi_Empresa
                                                                   , formParams.P_MIG_CD_USUARIO       -- pCd_Usuario
                                                                   , false                             -- pRaise
                                                                   , false                             -- pMostraMensagem
                                                                   , nCdConRec);
  End if;

  DELETE FROM DBAMV.ITEXTRA_FATURA
  WHERE CD_REG_FAT = pREG_FAT.CD_REG_FAT;

  update DBAMV.documento_pasta_parcial
     set cd_reg_fat = null
   where cd_reg_fat = preg_fat.cd_reg_fat
     and cd_atendimento = preg_fat.cd_atendimento;

  -- Verifica se existi conta filha para a conta que ser excluda.
  open  cQtdConta;
  fetch cQtdConta into vQtd;
  close cQtdConta;

  if vQtd > 0 then
      -- exclui todos os registros que estejam se relacionando com as contas filhas
        DELETE FROM DBAMV.ITREG_FAT
      WHERE CD_REG_FAT_PAI IN (SELECT CD_REG_FAT
                                 FROM DBAMV.REG_FAT
                                WHERE REG_FAT.CD_CONTA_PAI = pREG_FAT.CD_REG_FAT);

      DELETE FROM DBAMV.ITCOB_PRE
      WHERE CD_REG_FAT IN (SELECT CD_REG_FAT
                             FROM DBAMV.REG_FAT
                            WHERE REG_FAT.CD_CONTA_PAI = pREG_FAT.CD_REG_FAT);

      DELETE FROM DBAMV.ITLAN_MED
      WHERE CD_REG_FAT IN (SELECT CD_REG_FAT
                             FROM DBAMV.REG_FAT
                            WHERE REG_FAT.CD_CONTA_PAI = pREG_FAT.CD_REG_FAT);

      DELETE FROM DBAMV.ITLAN_MED_ORIGINAL
      WHERE CD_REG_FAT IN (SELECT CD_REG_FAT
                             FROM DBAMV.REG_FAT
                            WHERE REG_FAT.CD_CONTA_PAI = pREG_FAT.CD_REG_FAT);

      DELETE FROM DBAMV.ITREG_FAT
      WHERE CD_REG_FAT_PAI IN (SELECT CD_REG_FAT
                                 FROM DBAMV.REG_FAT
                                WHERE REG_FAT.CD_CONTA_PAI = pREG_FAT.CD_REG_FAT);

      DELETE FROM DBAMV.ITREG_FAT
      WHERE CD_REG_FAT_REL IN (SELECT CD_REG_FAT
                                 FROM DBAMV.REG_FAT
                                WHERE REG_FAT.CD_CONTA_PAI = pREG_FAT.CD_REG_FAT);

      DELETE FROM DBAMV.ITREG_FAT
      WHERE CD_REG_FAT IN (SELECT CD_REG_FAT
                             FROM DBAMV.REG_FAT
                            WHERE REG_FAT.CD_CONTA_PAI = pREG_FAT.CD_REG_FAT);

      DELETE FROM DBAMV.ITREG_FAT_ORIGINAL
      WHERE CD_REG_FAT IN (SELECT CD_REG_FAT
                             FROM DBAMV.REG_FAT
                            WHERE REG_FAT.CD_CONTA_PAI = pREG_FAT.CD_REG_FAT);

      DELETE FROM DBAMV.REG_FAT
      WHERE CD_CONTA_PAI = pREG_FAT.CD_REG_FAT;

  end if;

  -- pda RE 386256 - incio
  begin
    delete from dbamv.auditoria_in_loco
     where cd_reg_fat = pREG_FAT.CD_REG_FAT
       and cd_usuario_cancelou is not null and NOT EXISTS (SELECT 'X'
	 					        FROM DBAMV.REMESSA_FATURA R
                                                       WHERE R.SN_FECHADA = 'S'
                                                         AND R.CD_REMESSA = pREG_FAT.CD_REMESSA);

  exception
	  when others then
	    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_74)
	    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_75)
	    PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_74', 'PKG_FFCV_M_LAN_HOS', 'Erro:'), pkg_rmi_traducao.extrair_pkg_msg('MSG_75', 'PKG_FFCV_M_LAN_HOS', 'Erro ao Excluir auditoria in Loco. %s', arg_list(SQLERRM)), true);
  end;
  -- pda RE 386256 - fim

end;
END P_B_PD_REG_FAT;


PROCEDURE P_B_PD_REG_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PD_REG_FAT_E(xml) THEN
                P_B_PD_REG_FAT(xml, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PD_REG_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>REG_FAT.ON-CHECK-DELETE-MASTER</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_OCDM_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec) IS
BEGIN

DECLARE
  Dummy_Define CHAR(1);
  --
  CURSOR ITREG_FAT_cur IS
    SELECT 1
      FROM DBAMV.ITREG_FAT D
     WHERE D.CD_CONTA_PAI = pREG_FAT.CD_REG_FAT;
BEGIN
  --
  OPEN ITREG_FAT_cur;
  FETCH ITREG_FAT_cur INTO Dummy_Define;
  IF ( ITREG_FAT_cur%found ) THEN
      CLOSE ITREG_FAT_cur;
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_76)
    PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
		  pkg_rmi_traducao.extrair_pkg_msg('MSG_76', 'PKG_FFCV_M_LAN_HOS',
			  'Atenção..: A conta não pode ser excluída porque foram localizados itens para a mesma.%s..: Deve-se excluir ou transferir os itens antes da exclusão da conta.', arg_list(chr(10))), true);
  END IF;
  CLOSE ITREG_FAT_cur;
  --
END;
END P_B_OCDM_REG_FAT;


PROCEDURE P_B_OCDM_REG_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_OCDM_REG_FAT_E(xml) THEN
                P_B_OCDM_REG_FAT(xml, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_B_OCDM_REG_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>REG_FAT.POST-UPDATE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PU_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec) IS
BEGIN

declare
     cursor cRegFatFilha is
        select cd_reg_fat, cd_multi_empresa
          from DBAMV.reg_fat
         where cd_conta_pai = preg_fat.cd_reg_fat;

    vRemessa number;
begin
    update DBAMV.reg_fat
       set dt_final = preg_fat.dt_final,
           CD_PRO_FAT_REALIZADO = pREG_FAT.CD_PRO_FAT_REALIZADO
     where cd_conta_pai = preg_fat.cd_reg_fat;

    if  preg_fat.cd_remessa is not null and
         nvl( pCG$CTRL.cd_remessa_ant,0) = 1 then

       for c1 in cRegFatFilha loop

          vRemessa := pkg_ffcv_remessa_fatura.fnc_obtem_remessa(pnCdMultiEmpresa => c1.cd_multi_empresa,
                                                                      pnCdRemessa => preg_fat.cd_remessa);
          update DBAMV.reg_fat
             set cd_remessa = vRemessa
           where cd_reg_fat = c1.cd_reg_fat;
       end loop;
    end if;
end;
END P_B_PU_REG_FAT;


PROCEDURE P_B_PU_REG_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pcg$ctrl CG$CTRLRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.DT_FINAL:= PKG_XML.GetDate(xml, 'REG_FAT.DT_FINAL');
        pREG_FAT.CD_PRO_FAT_REALIZADO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.CD_PRO_FAT_REALIZADO');
        pREG_FAT.CD_REMESSA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REMESSA');
        pCG$CTRL.CD_REMESSA_ANT:= PKG_XML.GetNUMBER(xml, 'CG$CTRL.CD_REMESSA_ANT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PU_REG_FAT_E(xml) THEN
                P_B_PU_REG_FAT(xml, pREG_FAT, pCG$CTRL);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PU_REG_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_FINAL', pREG_FAT.DT_FINAL);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.CD_PRO_FAT_REALIZADO', pREG_FAT.CD_PRO_FAT_REALIZADO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REMESSA', pREG_FAT.CD_REMESSA);
        PKG_XML.SetNUMBER(xml, 'CG$CTRL.CD_REMESSA_ANT', pCG$CTRL.CD_REMESSA_ANT);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT.SN_HORARIO_ESPECIAL.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IF_SN_HORARIO_ESPECI (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec) IS
BEGIN

if not pack_lanca_ffcv.IS_Hor_Esp(  pREG_FAT.CD_CONVENIO,
                                        pREG_FAT.CD_CON_PLA,
                                        pREG_FAT.DSP_TP_ATENDIMENTO,
                                        pITREG_FAT.DT_LANCAMENTO,
                                        pITREG_FAT.HR_LANCAMENTO,
                                        pITREG_FAT.CD_GRU_FAT,
                                        pITREG_FAT.CD_PRO_FAT,
                                        pREG_FAT.CD_REGRA,
                                        pitreg_fat.cd_prestador,
                                        pitreg_fat.cd_setor
                                       )
                and  pITREG_FAT.SN_HORARIO_ESPECIAL = 'S' then
  pITREG_FAT.SN_HORARIO_ESPECIAL := 'N' ;
end if ;
END P_I_WVI_IF_SN_HORARIO_ESPECI;


PROCEDURE P_I_WVI_IF_SN_HORARIO_ESPECI (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT.HR_LANCAMENTO');
        pITREG_FAT.CD_GRU_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_GRU_FAT');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_SETOR');
        pITREG_FAT.SN_HORARIO_ESPECIAL:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.SN_HORARIO_ESPECIAL');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IF_SN_HORARIO_ESPECI_E(xml) THEN
                P_I_WVI_IF_SN_HORARIO_ESPECI(xml, pREG_FAT, pITREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IF_SN_HORARIO_ESPECI_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT.HR_LANCAMENTO', pITREG_FAT.HR_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_GRU_FAT', pITREG_FAT.CD_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_SETOR', pITREG_FAT.CD_SETOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.SN_HORARIO_ESPECIAL', pITREG_FAT.SN_HORARIO_ESPECIAL);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT.CD_PRESTADOR.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IF_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, preg_fat IN OUT NOCOPY REG_FATRec,
	                                   pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec, pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec,
									   pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

Pkg_ffcv_M_LAN_HOS.P_CHK_ITREG_FAT_PRESTADOR(xml, pITREG_FAT, pITREG_FAT_REL, pITREG_FAT_SINTETICO, pITLAN_MED_REL, pITLAN_MED2, formParams, 'F', true, true);

IF  pITREG_FAT.CD_PRESTADOR IS NOT NULL THEN
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT.TP_PAGAMENTO','ENABLED',true);
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT.TP_PAGAMENTO','NAVIGABLE',true);
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT.TP_PAGAMENTO','UPDATEABLE',true);
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT.TP_PAGAMENTO','INSERT_ALLOWED',true);
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT.CD_ATI_MED','ENABLED',true);    -- OP 13549
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT.CD_ATI_MED','NAVIGABLE',true);    -- OP 13549
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT.CD_ATI_MED','UPDATEABLE',true);    -- OP 13549
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT.CD_ATI_MED','INSERT_ALLOWED',true);    -- OP 13549
    Pkg_ffcv_M_LAN_HOS.P_CHK_VALORES_PROCEDIMENTO(xml, pITREG_FAT, pREG_FAT, formParams, pITREG_FAT.CD_PRO_FAT,
                              pITREG_FAT.DSP_TP_GRU_FAT,
                              pITREG_FAT.DT_LANCAMENTO,
                              pITREG_FAT.HR_LANCAMENTO,
                              pCG$CTRL.DSP_ERRO_VALOR) ;
ELSE
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT.TP_PAGAMENTO','ENABLED',false);
END IF;


DECLARE

	CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

	vProced cProced%ROWTYPE;

BEGIN

	OPEN cProced (pITREG_FAT.CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

  if  pITREG_FAT.CD_PRESTADOR is not null then
                    pITREG_FAT.TP_PAGAMENTO := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pITREG_FAT.CD_PRESTADOR,
																						 pREG_FAT.CD_CONVENIO,
																						 pREG_FAT.DSP_TP_ATENDIMENTO,
																						 pITREG_FAT.CD_PRO_FAT,
																						 pREG_FAT.DSP_CD_ORI_ATE, null, null,
																						 --FATURCONV-1726 INI
																						 pREG_FAT.CD_CON_PLA,
																						 pREG_FAT.CD_REGRA,
																						 vProced.cd_gru_pro
																						 --FATURCONV-1726 FIM
																						 );
  end if ;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END;
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Declare
  Cursor C_PrestProib is
    Select Count(1)
      From DBAMV.prest_gru_pro_proibido pgpp
     Where pgpp.cd_prestador = pITREG_FAT.CD_PRESTADOR
       and pgpp.cd_gru_pro = pITREG_FAT.DSP_CD_GRU_PRO ;

  nQuantosTem Number ;
Begin

  Open C_PrestProib ;
  Fetch C_PrestProib into nQuantosTem ;
  Close C_PrestProib ;

  if Nvl( nQuantosTem, 0 ) > 0 then
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_35)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_35', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Este prestador não está autorizado para procedimentos do grupo %s !', arg_list(To_Char( pITREG_FAT.DSP_CD_GRU_PRO ))), 'W', True) ;
  end if ;

END;
END P_I_WVI_IF_CD_PRESTADOR;


PROCEDURE P_I_WVI_IF_CD_PRESTADOR (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    pcg$ctrl CG$CTRLRec;
    preg_fat REG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    pitreg_fat_sintetico ITREG_FAT_SINTETICORec;
    pitlan_med_rel ITLAN_MED_RELRec;
    pitlan_med2 ITLAN_MED2Rec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR');
        pITREG_FAT_REL.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_NM_PRESTADOR');
        pITLAN_MED_REL.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO');
        pITLAN_MED_REL.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR');
        pITLAN_MED_REL.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA');
        pITLAN_MED_REL.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        pCG$CTRL.DSP_ERRO_VALOR:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.DSP_ERRO_VALOR');
        pITREG_FAT_SINTETICO.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.CD_PRESTADOR');
        pITREG_FAT_SINTETICO.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_NM_PRESTADOR');
        pITLAN_MED2.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO');
        pITLAN_MED2.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR');
        pITLAN_MED2.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA');
        pITLAN_MED2.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT.HR_LANCAMENTO');
        pITREG_FAT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO');
        pITREG_FAT.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO');
        pITREG_FAT.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_NM_PRESTADOR');
        pITREG_FAT.DSP_VL_INICIAL:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_VL_INICIAL');
        pITREG_FAT.CD_ATI_MED:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_ATI_MED');
        pITREG_FAT.VL_PERCENTUAL_MULTIPLA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_MULTIPLA');
        pITREG_FAT.VL_OPERACIONAL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_OPERACIONAL_UNITARIO');
        pITREG_FAT.VL_HONORARIO_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_HONORARIO_UNITARIO');
        pITREG_FAT.VL_FILME_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_FILME_UNITARIO');
        pITREG_FAT.QT_CH_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_CH_UNITARIO');
        pITREG_FAT.VL_ACRESCIMO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_ACRESCIMO');
        pITREG_FAT.VL_DESCONTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_DESCONTO');
        pITREG_FAT.QT_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO');
        pITREG_FAT.VL_PERCENTUAL_PACIENTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE');
        pITREG_FAT.CD_FRANQUIA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA');
        pITREG_FAT.CD_REGRA_ACOPLAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO');
        pITREG_FAT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_SETOR');
        pITREG_FAT.VL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_UNITARIO');
        pITREG_FAT.VL_TOTAL_CONTA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_TOTAL_CONTA');
        formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IF_CD_PRESTADOR_E(xml) THEN
                P_I_WVI_IF_CD_PRESTADOR(xml, pITREG_FAT, pCG$CTRL, pREG_FAT, pITREG_FAT_REL, pITREG_FAT_SINTETICO, pITLAN_MED_REL, pITLAN_MED2, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IF_CD_PRESTADOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR', pITREG_FAT_REL.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_NM_PRESTADOR', pITREG_FAT_REL.DSP_NM_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO', pITLAN_MED_REL.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR', pITLAN_MED_REL.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA', pITLAN_MED_REL.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS', pITLAN_MED_REL.DSP_SN_OUTROS);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM', pREG_FAT.DSP_CD_TIP_ACOM);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.DSP_ERRO_VALOR', pCG$CTRL.DSP_ERRO_VALOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.CD_PRESTADOR', pITREG_FAT_SINTETICO.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_NM_PRESTADOR', pITREG_FAT_SINTETICO.DSP_NM_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO', pITLAN_MED2.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR', pITLAN_MED2.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA', pITLAN_MED2.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS', pITLAN_MED2.DSP_SN_OUTROS);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT', pITREG_FAT.DSP_TP_GRU_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT.HR_LANCAMENTO', pITREG_FAT.HR_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO', pITREG_FAT.TP_PAGAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO', pITREG_FAT.DSP_CD_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_NM_PRESTADOR', pITREG_FAT.DSP_NM_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_VL_INICIAL', pITREG_FAT.DSP_VL_INICIAL);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_ATI_MED', pITREG_FAT.CD_ATI_MED);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_MULTIPLA', pITREG_FAT.VL_PERCENTUAL_MULTIPLA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_OPERACIONAL_UNITARIO', pITREG_FAT.VL_OPERACIONAL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_HONORARIO_UNITARIO', pITREG_FAT.VL_HONORARIO_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_FILME_UNITARIO', pITREG_FAT.VL_FILME_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_CH_UNITARIO', pITREG_FAT.QT_CH_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_ACRESCIMO', pITREG_FAT.VL_ACRESCIMO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_DESCONTO', pITREG_FAT.VL_DESCONTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO', pITREG_FAT.QT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE', pITREG_FAT.VL_PERCENTUAL_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA', pITREG_FAT.CD_FRANQUIA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO', pITREG_FAT.CD_REGRA_ACOPLAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_SETOR', pITREG_FAT.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_UNITARIO', pITREG_FAT.VL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_TOTAL_CONTA', pITREG_FAT.VL_TOTAL_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT', formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT.TP_PAGAMENTO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IF_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2) IS
BEGIN

declare
  v_tpconv     convenio.tp_convenio%type;
  cTpPagamento Char(1);

  CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

  vProced cProced%ROWTYPE;

begin
  IF  FSV_MODE = 'QUERY' THEN
    RETURN;
  END IF;

	OPEN cProced (pITREG_FAT.CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

  IF  pitreg_fat.tp_pagamento not in ('P', 'F', 'C', 'X') THEN
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_36)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_36', 'PKG_FFCV_M_LAN_HOS', 'Erro: A forma de pagamento deve ser P - Produção ou C - Convênio ou F - Hospital ou X - Pago pelo Paciente.'), 'E', TRUE);
  END IF;

  /*OP 22385 / PDA 698857*/
  if  pITREG_FAT.TP_PAGAMENTO <> 'X' THEN
      pITREG_FAT.SN_PACIENTE_PAGA := 'N';
  END IF;
  /*OP 22385 / PDA 698857*/

  if not (  pITREG_FAT.TP_PAGAMENTO = 'X' or nvl( pITREG_FAT.SN_PACIENTE_PAGA,'N') = 'S' ) then
      -- Consulta o tipo de Convênio
      M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, preg_fat.cd_convenio
                                        , formParams.P_MIG_CD_MULTI_EMPRESA
                                        , formParams.P_MIG_CD_USUARIO
                                        , false
                                        , false
                                        , 'TP_CONVENIO'
                                        , v_tpconv);

    if nvl(v_tpconv,'P')='P' then
        return;
    end if;

    IF  pITREG_FAT.TP_PAGAMENTO in ('P', 'F') THEN
      RETURN;
    END IF;

    cTpPagamento := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pITREG_FAT.CD_PRESTADOR,
                                                                     pREG_FAT.CD_CONVENIO,
                                                                     pREG_FAT.DSP_TP_ATENDIMENTO,
                                                                     pITREG_FAT.CD_PRO_FAT,
                                                                     pREG_FAT.DSP_CD_ORI_ATE, null, null,
																	 --FATURCONV-1726 INI
																	pREG_FAT.CD_CON_PLA,
																	pREG_FAT.CD_REGRA,
																	vProced.cd_gru_pro
																	--FATURCONV-1726 FIM
																	 );

    if  formParams.P_MIG_CD_HOSPITAL not in (444, 445, 446, 448, 449, 714, 378, 427, 421) then
      IF cTpPagamento = 'P' AND  pITREG_FAT.TP_PAGAMENTO = 'C' THEN
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_58)
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_73)
          PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_58', 'PKG_FFCV_M_LAN_HOS', 'Erro'),
					  pkg_rmi_traducao.extrair_pkg_msg('MSG_73', 'PKG_FFCV_M_LAN_HOS',
						  'Erro..: Prestador não credenciado ou com exceção de credenciamento.%s..: Verificar o cadastro de credenciamento, no cadastro de prestadores', arg_list(CHR(10))), TRUE);
        pITREG_FAT.TP_PAGAMENTO := cTpPagamento;
      end if;
    end if;
  end if ;
end;
END P_I_WVI_IF_TP_PAGAMENTO;


PROCEDURE P_I_WVI_IF_TP_PAGAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    FSV_MODE VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
        pITREG_FAT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO');
        pITREG_FAT.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        FSV_MODE:= PKG_XML.GetVARCHAR2(xml, 'FSV_MODE');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IF_TP_PAGAMENTO_E(xml) THEN
                P_I_WVI_IF_TP_PAGAMENTO(xml, pITREG_FAT, pREG_FAT, formParams, FSV_MODE);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IF_TP_PAGAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO', pITREG_FAT.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA', pITREG_FAT.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetVARCHAR2(xml, 'FSV_MODE', FSV_MODE);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT.PRE-INSERT</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PI_ITREG_FAT_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec, formParams IN OUT NOCOPY FormParamsRec,
	                                FSV_RECORD_STATUS IN OUT NOCOPY varchar2, FSV_MODE IN OUT NOCOPY varchar2, FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2) IS

 /*OP 23258 - verifica configuração antes de atribuir a atividade mdica.*/
   CURSOR cCadastraAtiMed(PCD_FOR_APRE IN NUMBER, PCD_GRU_FAT IN Number ) IS
          Select I.SN_CADASTRA_ATI_MED
							   From dbamv.itfor_apre I
							        , dbamv.GRU_FAT G
							        Where I.cd_for_apre = PCD_FOR_APRE
							        and I.cd_gru_fat = PCD_GRU_FAT
							        AND I.CD_GRU_FAT = G.CD_GRU_FAT;

    CURSOR cForApre(pConv IN NUMBER) IS
         SELECT cd_for_apre
            FROM dbamv.convenio
            WHERE cd_convenio = pConv;

   CURSOR cGruFat(pProFat IN VARCHAR2, pTpGruFat IN VARCHAR2) is
    SELECT gf.cd_gru_fat
 FROM dbamv.gru_pro gp, dbamv.pro_fat pf, dbamv.gru_fat gf
 WHERE gp.cd_gru_pro = pf.cd_gru_pro
   AND pf.cd_pro_fat = pProFat
   AND gp.cd_gru_fat = gf.cd_gru_fat
   AND gf.tp_gru_fat =pTpGruFat;


    vCadastraAtiMed cCadastraAtiMed%ROWTYPE;
    vcForApre cForApre%ROWTYPE;
    vcGruFat cGruFat%ROWTYPE;
    /*OP 23258*/

BEGIN

/*OP 23258*/
 OPEN cGruFat(pitreg_fat.cd_pro_fat,pitreg_fat.DSP_TP_GRU_FAT );
 FETCH cGruFat INTO vcGruFat;
 CLOSE cGruFat;

 OPEN cForApre(preg_fat.cd_convenio);
 FETCH  cForApre INTO vcForApre;
 CLOSE cForApre;

 OPEN cCadastraAtiMed(vcForApre.cd_for_apre,vcGruFat.cd_gru_fat);
 FETCH cCadastraAtiMed INTO vCadastraAtiMed;
 CLOSE cCadastraAtiMed;
 /*OP 23258*/

Pkg_ffcv_M_LAN_HOS.P_VALIDA_PREENCHIMENTO_PROC(xml, pITREG_FAT, FSV_MODE);

pITREG_FAT.CD_REG_FAT := pREG_FAT.CD_REG_FAT;
pITREG_FAT.CD_USUARIO := formParams.P_MIG_CD_USUARIO;
pITREG_FAT.TP_MVTO := 'Faturamento';

if  pITREG_FAT.CD_PRO_FAT is not null then

    pCG$CTRL.DSP_ERRO_VALOR := null;
  if  FSV_Record_Status <> 'QUERY' and Nvl(  pITREG_FAT.DSP_VL_INICIAL, 0 ) = 0 then
    Pkg_ffcv_M_LAN_HOS.P_CHK_VALORES_PROCEDIMENTO(xml, pITREG_FAT, pREG_FAT, formParams, pITREG_FAT.CD_PRO_FAT,
                              pITREG_FAT.DSP_TP_GRU_FAT,
                              pITREG_FAT.DT_LANCAMENTO,
                              pITREG_FAT.HR_LANCAMENTO,
                              pCG$CTRL.DSP_ERRO_VALOR) ;
        if  pCG$CTRL.DSP_ERRO_VALOR is not null then
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_77)
          PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'), pkg_rmi_traducao.extrair_pkg_msg('MSG_77', 'PKG_FFCV_M_LAN_HOS', 'Atenção..:%s', arg_list(pCG$CTRL.DSP_ERRO_VALOR)), True) ;
      end if ;
  end if ;
end if;


pITREG_FAT.CD_LANCAMENTO := PKG_FFCV_IT_CONTA.FNC_OBTEM_SEQUENCIA(pREG_FAT.CD_REG_FAT,'H');


Pkg_ffcv_M_LAN_HOS.P_ATUALIZA_SN_FATURA_IMPRESS(xml, pREG_FAT, FSV_CURRENT_FIELD, FSV_FORM_STATUS, FSV_RECORD_STATUS);

if  pITREG_FAT.CD_ATI_MED is null and  formParams.P_MIG_CD_ATI_MED_CLINICO is not null and  pITREG_FAT.CD_PRESTADOR is not null
   AND Nvl(vCadastraAtiMed.SN_CADASTRA_ATI_MED,'N') = 'S'  THEN /*OP 23258*/
  pITREG_FAT.CD_ATI_MED := formParams.P_MIG_CD_ATI_MED_CLINICO ;
end if ;

if  pITREG_FAT.TP_PAGAMENTO = 'X' then
  pITREG_FAT.TP_PAGAMENTO := 'C' ;
  pITREG_FAT.SN_PACIENTE_PAGA := 'S' ;
end if ;
END P_B_PI_ITREG_FAT_PRE;


PROCEDURE P_B_PI_ITREG_FAT_PRE (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;
    pcg$ctrl CG$CTRLRec;
    formParams FormParamsRec;
    FSV_RECORD_STATUS VARCHAR2(4000);
    FSV_MODE VARCHAR2(4000);
    FSV_CURRENT_FIELD VARCHAR2(4000);
    FSV_FORM_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_TIP_ACOM:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pREG_FAT.DSP_TP_CONVENIO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO');
        pREG_FAT.SN_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FECHADA');
        pREG_FAT.SN_FATURA_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA');
        pREG_FAT.SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA');
        pREG_FAT.DSP_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA');
        pREG_FAT.DSP_SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA');
        pCG$CTRL.DSP_ERRO_VALOR:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.DSP_ERRO_VALOR');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        pITREG_FAT.CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_USUARIO');
        pITREG_FAT.TP_MVTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_MVTO');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.DSP_VL_INICIAL:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_VL_INICIAL');
        pITREG_FAT.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT.HR_LANCAMENTO');
        pITREG_FAT.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO');
        pITREG_FAT.CD_ATI_MED:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_ATI_MED');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO');
        pITREG_FAT.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA');
        pITREG_FAT.VL_PERCENTUAL_MULTIPLA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_MULTIPLA');
        pITREG_FAT.VL_OPERACIONAL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_OPERACIONAL_UNITARIO');
        pITREG_FAT.VL_HONORARIO_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_HONORARIO_UNITARIO');
        pITREG_FAT.VL_FILME_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_FILME_UNITARIO');
        pITREG_FAT.QT_CH_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_CH_UNITARIO');
        pITREG_FAT.VL_ACRESCIMO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_ACRESCIMO');
        pITREG_FAT.VL_DESCONTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_DESCONTO');
        pITREG_FAT.QT_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO');
        pITREG_FAT.VL_PERCENTUAL_PACIENTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE');
        pITREG_FAT.CD_FRANQUIA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA');
        pITREG_FAT.CD_REGRA_ACOPLAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO');
        pITREG_FAT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_SETOR');
        pITREG_FAT.VL_UNITARIO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_UNITARIO');
        pITREG_FAT.VL_TOTAL_CONTA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_TOTAL_CONTA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_MIG_CD_ATI_MED_CLINICO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_ATI_MED_CLINICO');
        formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        FSV_MODE:= PKG_XML.GetVARCHAR2(xml, 'FSV_MODE');
        FSV_CURRENT_FIELD:= PKG_XML.GetVARCHAR2(xml, 'FSV_CURRENT_FIELD');
        FSV_FORM_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_FORM_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PI_ITREG_FAT_PRE_E(xml) THEN
                P_B_PI_ITREG_FAT_PRE(xml, pITREG_FAT, pREG_FAT, pCG$CTRL, formParams, FSV_RECORD_STATUS, FSV_MODE, FSV_CURRENT_FIELD, FSV_FORM_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PI_ITREG_FAT_PRE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_TIP_ACOM', pREG_FAT.DSP_CD_TIP_ACOM);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_CONVENIO', pREG_FAT.DSP_TP_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FECHADA', pREG_FAT.SN_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA', pREG_FAT.SN_FATURA_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA', pREG_FAT.SN_CONTA_CALCULADA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA', pREG_FAT.DSP_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA', pREG_FAT.DSP_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA', pREG_FAT.DSP_SN_CONTA_CALCULADA);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.DSP_ERRO_VALOR', pCG$CTRL.DSP_ERRO_VALOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_USUARIO', pITREG_FAT.CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_MVTO', pITREG_FAT.TP_MVTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_VL_INICIAL', pITREG_FAT.DSP_VL_INICIAL);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_TP_GRU_FAT', pITREG_FAT.DSP_TP_GRU_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT.HR_LANCAMENTO', pITREG_FAT.HR_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO', pITREG_FAT.CD_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_ATI_MED', pITREG_FAT.CD_ATI_MED);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO', pITREG_FAT.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA', pITREG_FAT.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_MULTIPLA', pITREG_FAT.VL_PERCENTUAL_MULTIPLA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_OPERACIONAL_UNITARIO', pITREG_FAT.VL_OPERACIONAL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_HONORARIO_UNITARIO', pITREG_FAT.VL_HONORARIO_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_FILME_UNITARIO', pITREG_FAT.VL_FILME_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_CH_UNITARIO', pITREG_FAT.QT_CH_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_ACRESCIMO', pITREG_FAT.VL_ACRESCIMO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_DESCONTO', pITREG_FAT.VL_DESCONTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.QT_LANCAMENTO', pITREG_FAT.QT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE', pITREG_FAT.VL_PERCENTUAL_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_FRANQUIA', pITREG_FAT.CD_FRANQUIA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_REGRA_ACOPLAMENTO', pITREG_FAT.CD_REGRA_ACOPLAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_SETOR', pITREG_FAT.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_UNITARIO', pITREG_FAT.VL_UNITARIO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_TOTAL_CONTA', pITREG_FAT.VL_TOTAL_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_ATI_MED_CLINICO', formParams.P_MIG_CD_ATI_MED_CLINICO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_VALIDA_VALOR_OPME_FAT', formParams.P_MIG_SN_VALIDA_VALOR_OPME_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        PKG_XML.SetVARCHAR2(xml, 'FSV_MODE', FSV_MODE);
        PKG_XML.SetVARCHAR2(xml, 'FSV_CURRENT_FIELD', FSV_CURRENT_FIELD);
        PKG_XML.SetVARCHAR2(xml, 'FSV_FORM_STATUS', FSV_FORM_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



/*
<DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
<CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
<OBJETIVO>ITREG_FAT.PRE-DELETE</OBJETIVO>
<ALTERACOES></ALTERACOES>
*/
PROCEDURE P_B_PD_ITREG_FAT_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
								FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2, FSV_RECORD_STATUS IN OUT NOCOPY varchar2) IS
BEGIN

	Pkg_ffcv_M_LAN_HOS.P_CHK_ITEM_GERADO_POR_PACOTE(xml, preg_fat.cd_reg_fat, pitreg_fat.cd_lancamento);

	--> Verificar se o lancamento já foi repassado
	Pkg_ffcv_M_LAN_HOS.P_CHECA_REPASSE_ITEM(xml, pITREG_FAT, pREG_FAT, pITREG_FAT.CD_REG_FAT, pITREG_FAT.CD_LANCAMENTO);

	Pkg_ffcv_M_LAN_HOS.P_CHK_DATA_ATENDIMENTO(xml, pITREG_FAT, pREG_FAT, pITREG_FAT_REL, 'ITREG_FAT');

	-- Verificar se existe registro em Conta Particular fechada, compartilhado por franquia.
	Pkg_ffcv_M_LAN_HOS.P_CHK_COMPARTILHAMENTO_FRANQ(xml, pITREG_FAT);

	DELETE FROM DBAMV.itreg_fat
	Where itreg_fat.cd_reg_fat_pai = pITREG_FAT.CD_REG_FAT
	  and itreg_fat.cd_lancamento_pai = pITREG_FAT.CD_LANCAMENTO ;

	-- Removed builtin BELL
	-- null;
	-- Removed builtin SYNCHRONIZE
	-- null;

	Pkg_ffcv_M_LAN_HOS.P_ATUALIZA_SN_FATURA_IMPRESS(xml, pREG_FAT, FSV_CURRENT_FIELD, FSV_FORM_STATUS, FSV_RECORD_STATUS);

	/* pda 483786 - 03/01/2012 - Amalia Arajo - Chamadas comentadas para evitar a mensagem  "Seus Dados foram Alterados por..".
	   Em testes feitos, mesmo comentado, o processo continua sendo feito sem problemas (exclusao de contas com franquia, acoplamento
	   e regras de atendimento).
	if not pack_ffcv.Regra_Atendimento_Hosp( nCdRegFat =>  pREG_FAT.CD_REG_FAT,
													 nCdLcto =>  pITREG_FAT.CD_LANCAMENTO,
													 cAction => 'E' ) then
	  if not pack_ffcv.verif_acoplamento_hosp( nRegFat =>  pITREG_FAT.CD_REG_FAT,
													   nCdLcto =>     pITREG_FAT.CD_LANCAMENTO,
													   cAction => 'E' ) then
		pack_lanca_ffcv.Verif_Franquia_Hosp( nregfat => pITREG_FAT.CD_REG_FAT,
												   ncdlcto => pITREG_FAT.CD_LANCAMENTO,
												   cAction => 'E' ) ;
	  end if ;
	end if ;  */

	-- Default relation program section
	BEGIN
	  --
	   DELETE FROM DBAMV.ITCOB_PRE D
	   WHERE D.CD_REG_FAT = pITREG_FAT.CD_REG_FAT and D.CD_LANCAMENTO = pITREG_FAT.CD_LANCAMENTO;
	  --
	   DELETE FROM DBAMV.ITLAN_MED D
	   WHERE D.CD_REG_FAT = pITREG_FAT.CD_REG_FAT and D.CD_LANCAMENTO = pITREG_FAT.CD_LANCAMENTO;
	  --
	   DELETE FROM DBAMV.ITREG_FAT D
	   WHERE D.CD_REG_FAT_REL = pITREG_FAT.CD_REG_FAT and D.CD_LANCAMENTO_REL = pITREG_FAT.CD_LANCAMENTO;
	  --
	END;

END P_B_PD_ITREG_FAT_PRE;


PROCEDURE P_B_PD_ITREG_FAT_PRE (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    FSV_CURRENT_FIELD VARCHAR2(4000);
    FSV_FORM_STATUS VARCHAR2(4000);
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO');
        pITREG_FAT_REL.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.DSP_DT_ATENDIMENTO:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO');
        pREG_FAT.DSP_HR_ATENDIMENTO:= PKG_XML.GetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO');
        pREG_FAT.SN_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FECHADA');
        pREG_FAT.SN_FATURA_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA');
        pREG_FAT.SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA');
        pREG_FAT.DSP_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA');
        pREG_FAT.DSP_SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA');
        pITREG_FAT.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT.HR_LANCAMENTO');
        FSV_CURRENT_FIELD:= PKG_XML.GetVARCHAR2(xml, 'FSV_CURRENT_FIELD');
        FSV_FORM_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_FORM_STATUS');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_PRE_E(xml) THEN
                P_B_PD_ITREG_FAT_PRE(xml, pREG_FAT, pITREG_FAT, pITREG_FAT_REL, FSV_CURRENT_FIELD, FSV_FORM_STATUS, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_PRE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO', pITREG_FAT_REL.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO', pITREG_FAT_REL.HR_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO', pREG_FAT.DSP_DT_ATENDIMENTO);
        PKG_XML.SetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO', pREG_FAT.DSP_HR_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FECHADA', pREG_FAT.SN_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA', pREG_FAT.SN_FATURA_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA', pREG_FAT.SN_CONTA_CALCULADA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA', pREG_FAT.DSP_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA', pREG_FAT.DSP_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA', pREG_FAT.DSP_SN_CONTA_CALCULADA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO', pITREG_FAT.CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT.HR_LANCAMENTO', pITREG_FAT.HR_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'FSV_CURRENT_FIELD', FSV_CURRENT_FIELD);
        PKG_XML.SetVARCHAR2(xml, 'FSV_FORM_STATUS', FSV_FORM_STATUS);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT.POST-INSERT</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PI_ITREG_FAT_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec) IS
BEGIN
-- OP 47539 ini
 DECLARE

  CURSOR C_RegraAtend(nCdRegFat IN NUMBER) IS
        SELECT regra_atendimento.cd_regra_atendimento
          FROM dbamv.regra_atendimento , dbamv.reg_fat
         WHERE regra_atendimento.cd_atendimento = reg_fat.cd_atendimento
           AND reg_fat.cd_reg_fat = nCdRegFat;

      CURSOR C_RegraAtendProFat(nCdRegFat IN NUMBER) IS
        SELECT regra_atendimento_pro_fat.cd_regra_atendimento_pro_fat
          FROM dbamv.regra_atendimento_pro_fat , dbamv.reg_fat
         WHERE regra_atendimento_pro_fat.cd_atendimento = reg_fat.cd_atendimento
           AND reg_fat.cd_reg_fat = nCdRegFat;

   vRegraAtend number;
 BEGIN
  OPEN   C_RegraAtend (pREG_FAT.CD_REG_FAT);
  FETCH  C_RegraAtend INTO vRegraAtend;
  CLOSE  C_RegraAtend;
  IF vRegraAtend IS NULL THEN
   OPEN   C_RegraAtendProFat (pREG_FAT.CD_REG_FAT);
   FETCH  C_RegraAtendProFat INTO vRegraAtend;
   CLOSE  C_RegraAtendProFat;
  END IF;

 if Nvl(  pITREG_FAT.VL_PERCENTUAL_PACIENTE, 0 ) <> 100   OR  vRegraAtend IS NOT null THEN
  if not pack_ffcv.Regra_Atendimento_Hosp( nCdRegFat =>  pREG_FAT.CD_REG_FAT,
                                                   nCdLcto =>  pITREG_FAT.CD_LANCAMENTO,
                                                   cAction => 'I' ) then
      if not pack_ffcv.verif_acoplamento_hosp( nRegFat =>  pITREG_FAT.CD_REG_FAT,
                                                       nCdLcto =>  pITREG_FAT.CD_LANCAMENTO,
                                                       cAction => 'I' ) then
          pack_lanca_ffcv.Verif_Franquia_Hosp( nregfat => pITREG_FAT.CD_REG_FAT,
                                                     ncdlcto => pITREG_FAT.CD_LANCAMENTO,
                                                     cAction => 'I' ) ;
    end if ;
  end if ;
 end if ;
END; -- Op 47539 fim

if  pITREG_FAT.TP_PAGAMENTO = 'C' and  pITREG_FAT.SN_PACIENTE_PAGA = 'S' then
  pITREG_FAT.TP_PAGAMENTO := 'X' ;
end if ;
END P_B_PI_ITREG_FAT_POST;


PROCEDURE P_B_PI_ITREG_FAT_POST (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pITREG_FAT.VL_PERCENTUAL_PACIENTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE');
        pITREG_FAT.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        pITREG_FAT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO');
        pITREG_FAT.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PI_ITREG_FAT_POST_E(xml) THEN
                P_B_PI_ITREG_FAT_POST(xml, pITREG_FAT, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PI_ITREG_FAT_POST_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.VL_PERCENTUAL_PACIENTE', pITREG_FAT.VL_PERCENTUAL_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO', pITREG_FAT.CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO', pITREG_FAT.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA', pITREG_FAT.SN_PACIENTE_PAGA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT.POST-UPDATE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PU_ITREG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec) IS
BEGIN

if not pack_ffcv.Regra_Atendimento_Hosp( nCdRegFat =>  pREG_FAT.CD_REG_FAT,
                                                 nCdLcto =>  pITREG_FAT.CD_LANCAMENTO,
                                                 cAction => 'A' ) then
      if not pack_ffcv.verif_acoplamento_hosp( nRegFat =>  pITREG_FAT.CD_REG_FAT,
                                                                                                    nCdLcto =>  pITREG_FAT.CD_LANCAMENTO,
                                                                                                    cAction => 'A' ) then
      pack_lanca_ffcv.Verif_Franquia_Hosp( nregfat => pITREG_FAT.CD_REG_FAT,
                                                 ncdlcto => pITREG_FAT.CD_LANCAMENTO,
                                                 cAction => 'A' ) ;
    end if ;
end if ;

if  pITREG_FAT.TP_PAGAMENTO = 'C' and  pITREG_FAT.SN_PACIENTE_PAGA = 'S' then
  pITREG_FAT.TP_PAGAMENTO := 'X' ;
end if;
END P_B_PU_ITREG_FAT;


PROCEDURE P_B_PU_ITREG_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pITREG_FAT.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        pITREG_FAT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO');
        pITREG_FAT.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PU_ITREG_FAT_E(xml) THEN
                P_B_PU_ITREG_FAT(xml, pREG_FAT, pITREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PU_ITREG_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO', pITREG_FAT.CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_PAGAMENTO', pITREG_FAT.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.SN_PACIENTE_PAGA', pITREG_FAT.SN_PACIENTE_PAGA);
        out_params := PKG_XML.GetOutputClob(xml);

END;

    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT.POST-DELETE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PD_ITREG_FAT_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec) IS
BEGIN

begin
  delete from DBAMV.conta_pacote
   where cd_reg_fat = preg_fat.cd_reg_fat
     and Nvl(cd_conta_pacote,0) NOT in (select distinct Nvl(cd_conta_pacote,0)
                                          from DBAMV.itreg_fat
                                         where cd_reg_fat = preg_fat.cd_reg_fat);
end;
END P_B_PD_ITREG_FAT_POST;


PROCEDURE P_B_PD_ITREG_FAT_POST (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_POST_E(xml) THEN
                P_B_PD_ITREG_FAT_POST(xml, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_POST_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>FRANQUIA_REG_FAT.CD_PLANO_ACP.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_FRF_CD_PLANO_ACP (xml IN OUT NOCOPY PKG_XML.XmlContext,pfranquia_reg_fat IN OUT NOCOPY FRANQUIA_REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

if  pfranquia_reg_fat.cd_plano_acp is not null then
  pfranquia_reg_fat.dsp_plano_acp := M_PKG_FFCV_CON_PLA.F_RETORNA_DESCRICAO(xml, pfranquia_reg_fat.cd_plano_acp
                                                                                                              , pfranquia_reg_fat.cd_convenio_acp
                                                                                                              , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                                              , formParams.P_MIG_CD_USUARIO
                                                                                                              , TRUE
                                                                                                              , TRUE);
end if;
END P_I_WVI_FRF_CD_PLANO_ACP;


PROCEDURE P_I_WVI_FRF_CD_PLANO_ACP (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pfranquia_reg_fat FRANQUIA_REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pFRANQUIA_REG_FAT.CD_PLANO_ACP:= PKG_XML.GetNUMBER(xml, 'FRANQUIA_REG_FAT.CD_PLANO_ACP');
        pFRANQUIA_REG_FAT.DSP_PLANO_ACP:= PKG_XML.GetVARCHAR2(xml, 'FRANQUIA_REG_FAT.DSP_PLANO_ACP');
        pFRANQUIA_REG_FAT.CD_CONVENIO_ACP:= PKG_XML.GetNUMBER(xml, 'FRANQUIA_REG_FAT.CD_CONVENIO_ACP');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_FRF_CD_PLANO_ACP_E(xml) THEN
                P_I_WVI_FRF_CD_PLANO_ACP(xml, pFRANQUIA_REG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_FRF_CD_PLANO_ACP_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'FRANQUIA_REG_FAT.CD_PLANO_ACP', pFRANQUIA_REG_FAT.CD_PLANO_ACP);
        PKG_XML.SetVARCHAR2(xml, 'FRANQUIA_REG_FAT.DSP_PLANO_ACP', pFRANQUIA_REG_FAT.DSP_PLANO_ACP);
        PKG_XML.SetNUMBER(xml, 'FRANQUIA_REG_FAT.CD_CONVENIO_ACP', pFRANQUIA_REG_FAT.CD_CONVENIO_ACP);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_ORIGINAL.POST-QUERY</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PQ_ITREG_FAT_ORIGINAL (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_original IN OUT NOCOPY ITREG_FAT_ORIGINALRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

BEGIN
    declare
    vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
    vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
    vDsProFat      varchar2(1000);
    nNrAuxiliar    Number;
    nCdPorAne      Number;
    vTpSexo        varchar2(2);
    nCdGruPro      Number;
    nQtdMaxima     Number;
    vDsUnidade     varchar2(2000);
    vTpGruPro      varchar2(2000);
    vSnAtivo       varchar2(1);
  Begin
    --
    M_PKG_FFCV_PRO_FAT.P_RETORNA_DADOS(xml, pITREG_FAT_ORIGINAL.CD_PRO_FAT
                                                        ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                          ,formParams.P_MIG_CD_USUARIO
                                                          ,FALSE
                                                          ,FALSE
                                                          ,vLst_Retorno);
    --
    vLst_Local  := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_Retorno);
    --
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'DS_PRO_FAT' , vDsProFat  , false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'NR_AUXILIAR', nNrAuxiliar, false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'CD_POR_ANE' , nCdPorAne  , false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'TP_SEXO'    , vTpSexo    , false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'CD_GRU_PRO' , nCdGruPro  , false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'QTD_MAXIMA' , nQtdMaxima , false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'DS_UNIDADE' , vDsUnidade , false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'TP_GRU_PRO' , vTpGruPro  , false);
    PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'SN_ATIVO'   , vSnAtivo   , false);
    --
    pkg_parametro.pr_limpar_lista_parametros(vLst_Local);
    --
        pITREG_FAT_ORIGINAL.DSP_DS_PRO_FAT  := vDsProFat;
        pITREG_FAT_ORIGINAL.DSP_NR_AUXILIAR := nNrAuxiliar;
        pITREG_FAT_ORIGINAL.DSP_CD_POR_ANE  := nCdPorAne;
        pITREG_FAT_ORIGINAL.DSP_TP_SEXO     := vTpSexo;
        pITREG_FAT_ORIGINAL.DSP_CD_GRU_PRO  := nCdGruPro;
        pITREG_FAT_ORIGINAL.DSP_QTD_MAXIMA  := nQtdMaxima;
        pITREG_FAT_ORIGINAL.DSP_DS_UNIDADE  := vDsUnidade;
        pITREG_FAT_ORIGINAL.DSP_TP_GRU_PRO  := vTpGruPro;
        pITREG_FAT_ORIGINAL.DSP_PRO_FAT_SN_ATIVO := vSnAtivo;
    --
  end;

  Declare
      cursor cGruFat is
        SELECT GRU_FAT.DS_GRU_FAT
              ,GRU_FAT.TP_GRU_FAT
              ,ITFOR_APRE.SN_CADASTRA_QTD
              ,ITFOR_APRE.SN_CADASTRA_DATA
              ,ITFOR_APRE.SN_CADASTRA_CRM
              ,ITFOR_APRE.SN_CADASTRA_VALOR
              ,ITFOR_APRE.TP_DT_REFERENCIA_LANCAMENTO
              ,ITFOR_APRE.SN_CADASTRA_PERC_PACIENTE
          FROM DBAMV.GRU_FAT GRU_FAT
              ,DBAMV.ITFOR_APRE ITFOR_APRE
         WHERE GRU_FAT.CD_GRU_FAT = pITREG_FAT_ORIGINAL.CD_GRU_FAT
           AND ITFOR_APRE.CD_FOR_APRE = pREG_FAT.DSP_CD_FOR_APRE
           AND ITFOR_APRE.CD_GRU_FAT = GRU_FAT.CD_GRU_FAT;
      rGruFat    cGruFat%rowtype;
  BEGIN
      open  cGruFat;
      fetch cGruFat into rGruFat;
      close cGruFat;

    pITREG_FAT_ORIGINAL.DSP_DS_GRU_FAT                 := rGruFat.DS_GRU_FAT;
    pITREG_FAT_ORIGINAL.DSP_TP_GRU_FAT                 := rGruFat.TP_GRU_FAT;
    pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_QTD            := rGruFat.SN_CADASTRA_QTD;
    pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_DATA           := rGruFat.SN_CADASTRA_DATA;
    pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_CRM            := rGruFat.SN_CADASTRA_CRM;
    pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_VALOR          := rGruFat.SN_CADASTRA_VALOR;
    pITREG_FAT_ORIGINAL.DSP_TP_DT_REFERENCIA_LANCAMENT := rGruFat.TP_DT_REFERENCIA_LANCAMENTO;
    pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_PERC_PACIENTE  := rGruFat.SN_CADASTRA_PERC_PACIENTE;
  END;

  If  pITREG_FAT_ORIGINAL.DSP_TP_GRU_FAT = 'MM' Then
    pITREG_FAT_ORIGINAL.DSP_TP_GRU_FAT := 'M%';
  End If;

  If  pITREG_FAT_ORIGINAL.CD_PRESTADOR IS NOT NULL Then
       declare
      cursor cPrestador is
        SELECT PRESTADOR.NM_PRESTADOR
          FROM DBAMV.PRESTADOR PRESTADOR
         WHERE PRESTADOR.CD_PRESTADOR = pITREG_FAT_ORIGINAL.CD_PRESTADOR
           AND PRESTADOR.TP_SITUACAO = 'A' ;
      rPrestador    cPrestador%rowtype;
    begin
      open  cPrestador;
      fetch cPrestador into rPrestador;
      close cPrestador;

      pITREG_FAT_ORIGINAL.DSP_NM_PRESTADOR := rPrestador.NM_PRESTADOR;
    END;
   END IF;
   --
     IF  pITREG_FAT_ORIGINAL.cd_setor is not null THEN
          declare
                cursor cNmSetor is
                  SELECT SETOR.NM_SETOR
                 FROM DBAMV.SETOR SETOR
             WHERE SETOR.CD_SETOR = pitreg_fat_original.CD_SETOR
               and setor.sn_ativo = 'S';
         rNmSetor cNmSetor%rowtype;
          begin
               open  cNmSetor;
               fetch cNmSetor into rNmSetor;
               close cNmSetor;

               pITREG_FAT_ORIGINAL.DSP_NM_SETOR := rNmSetor.nm_setor;
       END;
     END IF;
     --
END;

--
if  pITREG_FAT_ORIGINAL.TP_PAGAMENTO = 'C' and  pITREG_FAT_ORIGINAL.SN_PACIENTE_PAGA = 'S' then
  pITREG_FAT_ORIGINAL.TP_PAGAMENTO := 'X' ;
end if ;
END P_B_PQ_ITREG_FAT_ORIGINAL;


PROCEDURE P_B_PQ_ITREG_FAT_ORIGINAL (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_original ITREG_FAT_ORIGINALRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_CD_FOR_APRE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_FOR_APRE');
        pITREG_FAT_ORIGINAL.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.CD_PRO_FAT');
        pITREG_FAT_ORIGINAL.DSP_DS_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_DS_PRO_FAT');
        pITREG_FAT_ORIGINAL.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_ORIGINAL.DSP_NR_AUXILIAR');
        pITREG_FAT_ORIGINAL.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_ORIGINAL.DSP_CD_POR_ANE');
        pITREG_FAT_ORIGINAL.DSP_TP_SEXO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_TP_SEXO');
        pITREG_FAT_ORIGINAL.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_ORIGINAL.DSP_CD_GRU_PRO');
        pITREG_FAT_ORIGINAL.DSP_QTD_MAXIMA:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_ORIGINAL.DSP_QTD_MAXIMA');
        pITREG_FAT_ORIGINAL.DSP_DS_UNIDADE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_DS_UNIDADE');
        pITREG_FAT_ORIGINAL.DSP_TP_GRU_PRO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_TP_GRU_PRO');
        pITREG_FAT_ORIGINAL.DSP_PRO_FAT_SN_ATIVO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_PRO_FAT_SN_ATIVO');
        pITREG_FAT_ORIGINAL.CD_GRU_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_GRU_FAT');
        pITREG_FAT_ORIGINAL.DSP_DS_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_DS_GRU_FAT');
        pITREG_FAT_ORIGINAL.DSP_TP_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_TP_GRU_FAT');
        pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_QTD:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_QTD');
        pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_DATA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_DATA');
        pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_CRM:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_CRM');
        pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_VALOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_VALOR');
        pITREG_FAT_ORIGINAL.DSP_TP_DT_REFERENCIA_LANCAMENT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_TP_DT_REFERENCIA_LANCAMENT');
        pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_PERC_PACIENTE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_PERC_PACIENTE');
        pITREG_FAT_ORIGINAL.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_PRESTADOR');
        pITREG_FAT_ORIGINAL.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_NM_PRESTADOR');
        pITREG_FAT_ORIGINAL.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_SETOR');
        pITREG_FAT_ORIGINAL.DSP_NM_SETOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_NM_SETOR');
        pITREG_FAT_ORIGINAL.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.TP_PAGAMENTO');
        pITREG_FAT_ORIGINAL.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.SN_PACIENTE_PAGA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_ITREG_FAT_ORIGINAL_E(xml) THEN
                P_B_PQ_ITREG_FAT_ORIGINAL(xml, pITREG_FAT_ORIGINAL, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_ITREG_FAT_ORIGINAL_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_FOR_APRE', pREG_FAT.DSP_CD_FOR_APRE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.CD_PRO_FAT', pITREG_FAT_ORIGINAL.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_DS_PRO_FAT', pITREG_FAT_ORIGINAL.DSP_DS_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_ORIGINAL.DSP_NR_AUXILIAR', pITREG_FAT_ORIGINAL.DSP_NR_AUXILIAR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_ORIGINAL.DSP_CD_POR_ANE', pITREG_FAT_ORIGINAL.DSP_CD_POR_ANE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_TP_SEXO', pITREG_FAT_ORIGINAL.DSP_TP_SEXO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_ORIGINAL.DSP_CD_GRU_PRO', pITREG_FAT_ORIGINAL.DSP_CD_GRU_PRO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_ORIGINAL.DSP_QTD_MAXIMA', pITREG_FAT_ORIGINAL.DSP_QTD_MAXIMA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_DS_UNIDADE', pITREG_FAT_ORIGINAL.DSP_DS_UNIDADE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_TP_GRU_PRO', pITREG_FAT_ORIGINAL.DSP_TP_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_PRO_FAT_SN_ATIVO', pITREG_FAT_ORIGINAL.DSP_PRO_FAT_SN_ATIVO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_GRU_FAT', pITREG_FAT_ORIGINAL.CD_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_DS_GRU_FAT', pITREG_FAT_ORIGINAL.DSP_DS_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_TP_GRU_FAT', pITREG_FAT_ORIGINAL.DSP_TP_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_QTD', pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_QTD);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_DATA', pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_DATA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_CRM', pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_CRM);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_VALOR', pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_VALOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_TP_DT_REFERENCIA_LANCAMENT', pITREG_FAT_ORIGINAL.DSP_TP_DT_REFERENCIA_LANCAMENT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_PERC_PACIENTE', pITREG_FAT_ORIGINAL.DSP_SN_CADASTRA_PERC_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_PRESTADOR', pITREG_FAT_ORIGINAL.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_NM_PRESTADOR', pITREG_FAT_ORIGINAL.DSP_NM_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_SETOR', pITREG_FAT_ORIGINAL.CD_SETOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.DSP_NM_SETOR', pITREG_FAT_ORIGINAL.DSP_NM_SETOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.TP_PAGAMENTO', pITREG_FAT_ORIGINAL.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_ORIGINAL.SN_PACIENTE_PAGA', pITREG_FAT_ORIGINAL.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_ORIGINAL.PRE-DELETE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PD_ITREG_FAT_ORIGINAL (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_original IN OUT NOCOPY ITREG_FAT_ORIGINALRec) IS
BEGIN

BEGIN
  --
  -- Begin ITLAN_MED_ORIGINAL detail program section
  --
   DELETE FROM DBAMV.ITLAN_MED_ORIGINAL D
   WHERE D.CD_REG_FAT = pITREG_FAT_ORIGINAL.CD_REG_FAT and D.CD_LANCAMENTO = pITREG_FAT_ORIGINAL.CD_LANCAMENTO;
  --
  -- End ITLAN_MED_ORIGINAL detail program section
  --
END;
END P_B_PD_ITREG_FAT_ORIGINAL;


PROCEDURE P_B_PD_ITREG_FAT_ORIGINAL (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_original ITREG_FAT_ORIGINALRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_ORIGINAL.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_REG_FAT');
        pITREG_FAT_ORIGINAL.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_LANCAMENTO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_ORIGINAL_E(xml) THEN
                P_B_PD_ITREG_FAT_ORIGINAL(xml, pITREG_FAT_ORIGINAL);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_ORIGINAL_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_REG_FAT', pITREG_FAT_ORIGINAL.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_ORIGINAL.CD_LANCAMENTO', pITREG_FAT_ORIGINAL.CD_LANCAMENTO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>DESC_GERAL.CD_REG_FAT.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_DG_CD_REG_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_geral IN OUT NOCOPY DESC_GERALRec, pfranquia_reg_fat IN OUT NOCOPY FRANQUIA_REG_FATRec, global IN OUT NOCOPY GlobalsRec) IS
BEGIN

declare
  cursor cDados(pcd_reg_fat in reg_fat.cd_reg_fat%type) is
      select NVL(REG_FAT.vl_desconto_conta,0) vl_desconto_conta
         , REG_FAT.DS_OBSERVACAO_FRANQUIA
      from DBAMV.REG_FAT
       where REG_FAT.CD_REG_FAT = pcd_reg_fat
       and nvl(REG_FAT.TP_DESCONTO,'X') = 'D';
  --
    vvl_desconto_conta             reg_fat.vl_desconto_conta%type;
  vds_observacao_franquia reg_fat.DS_OBSERVACAO_FRANQUIA%type;
  --
    vDsEmpresa             varchar2(80);
    nCdMultiEmpresa number;
begin

    if  global.Old_Vl_Franquia > 0 and  pdesc_geral.vl_desconto_conta > 0 and ( global.Old_Vl_Franquia <>  pdesc_geral.vl_desconto_conta) then
         pfranquia_reg_fat.vl_desconto_conta := global.Old_Vl_Franquia;
         --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
         --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_78)
         PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'), pkg_rmi_traducao.extrair_pkg_msg('MSG_78', 'PKG_FFCV_M_LAN_HOS', 'Atenção..: Para cancelar Franquia/Desconto, digite Zero.'), true);
    end if;

    if  pdesc_geral.cd_reg_fat is not null then
        if  pdesc_geral.cd_reg_fat = '%' or  pdesc_geral.cd_reg_fat is null then
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_79)
          PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'), pkg_rmi_traducao.extrair_pkg_msg('MSG_79', 'PKG_FFCV_M_LAN_HOS', 'Atenção..: O preenchimento da conta é obrigatório.'), true);
        else
        vDsEmpresa := Pkg_ffcv_M_LAN_HOS.F_DESCRICAO_EMPRESA(xml, pfranquia_reg_fat.cd_reg_fat, nCdMultiEmpresa);

            if vDsEmpresa is null then
                pdesc_geral.dsp_empresa := '';
                --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
                --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_80)
                PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'), pkg_rmi_traducao.extrair_pkg_msg('MSG_80', 'PKG_FFCV_M_LAN_HOS', 'Atenção..: A conta não é válida.'), true);
            else
                pdesc_geral.dsp_empresa := vDsEmpresa;
                pdesc_geral.cd_multi_empresa := nCdMultiEmpresa;
          --
                vvl_desconto_conta:= 0;
                vds_observacao_franquia := null;
                --
          open cDados(pdesc_geral.cd_reg_fat);
          fetch cDados into vvl_desconto_conta, vds_observacao_franquia;
          close cDados;
          --
          if nvl(vvl_desconto_conta,0) > 0 then
              pdesc_geral.vl_desconto_conta:= vvl_desconto_conta;
          end if;
          if vds_observacao_franquia is not null then
              pdesc_geral.ds_observacao_franquia:= vds_observacao_franquia;
          end if;
            end if;
        end if;
    end if;

end;
END P_I_WVI_DG_CD_REG_FAT;


PROCEDURE P_I_WVI_DG_CD_REG_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdesc_geral DESC_GERALRec;
    pfranquia_reg_fat FRANQUIA_REG_FATRec;
    global GlobalsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pFRANQUIA_REG_FAT.VL_DESCONTO_CONTA:= PKG_XML.GetNUMBER(xml, 'FRANQUIA_REG_FAT.VL_DESCONTO_CONTA');
        pFRANQUIA_REG_FAT.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'FRANQUIA_REG_FAT.CD_REG_FAT');
        pDESC_GERAL.VL_DESCONTO_CONTA:= PKG_XML.GetNUMBER(xml, 'DESC_GERAL.VL_DESCONTO_CONTA');
        pDESC_GERAL.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_GERAL.CD_REG_FAT');
        pDESC_GERAL.DSP_EMPRESA:= PKG_XML.GetVARCHAR2(xml, 'DESC_GERAL.DSP_EMPRESA');
        pDESC_GERAL.CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'DESC_GERAL.CD_MULTI_EMPRESA');
        pDESC_GERAL.DS_OBSERVACAO_FRANQUIA:= PKG_XML.GetVARCHAR2(xml, 'DESC_GERAL.DS_OBSERVACAO_FRANQUIA');
        global.OLD_VL_FRANQUIA:= PKG_XML.GetVARCHAR2(xml, 'GLOBAL.OLD_VL_FRANQUIA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_DG_CD_REG_FAT_E(xml) THEN
                P_I_WVI_DG_CD_REG_FAT(xml, pDESC_GERAL, pFRANQUIA_REG_FAT, global);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_DG_CD_REG_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'FRANQUIA_REG_FAT.VL_DESCONTO_CONTA', pFRANQUIA_REG_FAT.VL_DESCONTO_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'FRANQUIA_REG_FAT.CD_REG_FAT', pFRANQUIA_REG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'DESC_GERAL.VL_DESCONTO_CONTA', pDESC_GERAL.VL_DESCONTO_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GERAL.CD_REG_FAT', pDESC_GERAL.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GERAL.DSP_EMPRESA', pDESC_GERAL.DSP_EMPRESA);
        PKG_XML.SetNUMBER(xml, 'DESC_GERAL.CD_MULTI_EMPRESA', pDESC_GERAL.CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GERAL.DS_OBSERVACAO_FRANQUIA', pDESC_GERAL.DS_OBSERVACAO_FRANQUIA);
        PKG_XML.SetVARCHAR2(xml, 'GLOBAL.OLD_VL_FRANQUIA', global.OLD_VL_FRANQUIA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>DESC_GRU_PRO.CD_GRU_PRO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_DGP_CD_GRU_PRO (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pdesc_gru_pro IN OUT NOCOPY DESC_GRU_PRORec) IS
BEGIN

declare
    Cursor cDsGruPro is
      select distinct gru_pro.ds_gru_pro
          from DBAMV.gru_pro,
               DBAMV.pro_fat,
               DBAMV.reg_fat,
               DBAMV.itreg_fat
         where itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat
           and pro_fat.cd_gru_pro   = gru_pro.cd_gru_pro
           and itreg_fat.cd_reg_fat = preg_fat.cd_reg_fat
           and itreg_fat.cd_reg_fat = reg_fat.cd_reg_fat
           and reg_fat.cd_atendimento = preg_fat.cd_atendimento
           and gru_pro.cd_gru_pro = pdesc_gru_pro.cd_gru_pro;

  Cursor cJaTemDesconto_Gru is
      Select 'X' dummy
        From DBAMV.conta_desc_det
       where cd_gru_pro = pdesc_gru_pro.cd_gru_pro
         and cd_atendimento = preg_fat.cd_atendimento
         and cd_reg_fat = preg_fat.cd_reg_fat;

  Cursor cJaTemDesconto_Pro is
    Select 'X' dummy
      From DBAMV.conta_desc_det
     Where cd_pro_fat in ( Select cd_pro_fat
                             From DBAMV.pro_fat
                            Where pro_fat.cd_gru_pro = pDESC_GRU_PRO.CD_GRU_PRO )
       and cd_atendimento = preg_fat.cd_atendimento
       and cd_reg_fat = preg_fat.cd_reg_fat;

  dummy VarChar2(1);

BEGIN
    if     pdesc_gru_pro.cd_gru_pro is not null then
      open cDsGruPro;
      fetch cDsGruPro into  pdesc_gru_pro.nm_proced_gru;
      if cDsGruPro%notfound then
          pdesc_gru_pro.nm_proced_gru := null;
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_37)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_37', 'PKG_FFCV_M_LAN_HOS', 'Grupo de Procedimento não vinculado a conta.'),'E',TRUE);
      end if;
      close cDsGruPro;
    end if;

    Open cJaTemDesconto_Gru ;
    Fetch cJaTemDesconto_Gru into dummy ;
    if cJaTemDesconto_Gru%Found then
        Close cJaTemDesconto_Gru ;
        pdesc_gru_pro.cd_gru_pro := null;
        pdesc_gru_pro.nm_proced_gru := null;
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_38)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_38', 'PKG_FFCV_M_LAN_HOS', 'Atenção: já existe desconto para este grupo de procedimento'), 'E', True) ;
    end if ;
    Close cJaTemDesconto_Gru ;

    Open cJaTemDesconto_Pro ;
    Fetch cJaTemDesconto_Pro into dummy ;
    if cJaTemDesconto_Pro%Found then
        Close cJaTemDesconto_Pro ;
        pdesc_gru_pro.cd_gru_pro := null;
        pdesc_gru_pro.nm_proced_gru:= null;
        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_39)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_39', 'PKG_FFCV_M_LAN_HOS', 'Atenção: já existe desconto para procedimentos deste grupo'), 'W', True) ;
    end if ;
    Close cJaTemDesconto_Pro ;
END;
END P_I_WVI_DGP_CD_GRU_PRO;


PROCEDURE P_I_WVI_DGP_CD_GRU_PRO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pdesc_gru_pro DESC_GRU_PRORec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pDESC_GRU_PRO.CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'DESC_GRU_PRO.CD_GRU_PRO');
        pDESC_GRU_PRO.NM_PROCED_GRU:= PKG_XML.GetVARCHAR2(xml, 'DESC_GRU_PRO.NM_PROCED_GRU');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_DGP_CD_GRU_PRO_E(xml) THEN
                P_I_WVI_DGP_CD_GRU_PRO(xml, pREG_FAT, pDESC_GRU_PRO);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_DGP_CD_GRU_PRO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'DESC_GRU_PRO.CD_GRU_PRO', pDESC_GRU_PRO.CD_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GRU_PRO.NM_PROCED_GRU', pDESC_GRU_PRO.NM_PROCED_GRU);
        out_params := PKG_XML.GetOutputClob(xml);

END;
/*
<DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
<CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
<OBJETIVO>DESC_GRU_PRO.POST-INSERT</OBJETIVO>
<ALTERACOES></ALTERACOES>
*/
PROCEDURE P_B_PI_DESC_GRU_PRO_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_gru_pro IN OUT NOCOPY DESC_GRU_PRORec, preg_fat IN OUT NOCOPY REG_FATRec, pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec,
																	 formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare

	-- OP 12764 - 30/09/2013 - corrigindo rateio do desconto por grupo de procedimento
  cursor cItens is
    SELECT itf.CD_REG_FAT REG_FAT,
           itf.CD_lancamento,
		  		 itf.vl_total_conta VALOR_ATUAL,
           itf.vl_total_conta * (1-(pdesc_gru_pro.vl_perc_desconto/100)) VALOR_FINAL,
        	 itf.vl_total_conta * (pdesc_gru_pro.vl_perc_desconto/100) VALOR_DESCONTO

  FROM DBAMV.ITREG_FAT ITF
 		 Where cd_reg_fat = pdesc_gru_pro.cd_reg_fat
   		 and cd_pro_fat in ( Select cd_pro_fat
                   					 From dbamv.pro_fat
                   					Where cd_gru_pro = pdesc_gru_pro.cd_gru_pro);
  	/*SELECT itf.CD_REG_FAT REG_FAT,
           itf.CD_lancamento,
                     itf.vl_total_conta VALOR_ATUAL,
                     (itf.vl_total_conta - pdesc_gru_pro.vl_desconto) VALOR_FINAL,
                pdesc_gru_pro.vl_desconto VALOR_DESCONTO
      FROM dbamv.ITREG_FAT ITF
          Where cd_reg_fat = pdesc_gru_pro.cd_reg_fat
          and cd_pro_fat in ( Select cd_pro_fat
                                From dbamv.pro_fat
                                 Where cd_gru_pro = pDESC_GRU_PRO.CD_GRU_PRO);  */

  cursor cLancamentos is
    select itf.cd_reg_fat, itf.cd_lancamento
          ,itf.qt_lancamento          -- FATURCONV-2058
      from dbamv.itreg_fat itf, dbamv.pro_fat pft, dbamv.reg_fat rgf
     where itf.cd_pro_fat = pft.cd_pro_fat
       and pft.cd_gru_pro = pdesc_gru_pro.cd_gru_pro
       and rgf.cd_reg_fat = itf.cd_reg_fat
       and itf.cd_reg_fat = preg_fat.cd_reg_fat
       and rgf.cd_atendimento = preg_fat.cd_atendimento;

  vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;

  nvl_desconto_conta number;
  nvl_total_conta number;
  nvl_acumulado NUMBER := pdesc_gru_pro.vl_desconto;
  ncdLanc NUMBER;

begin

  Pkg_ffcv_M_LAN_HOS.P_ABRE_CONTA(xml, pDESC_GRU_PRO.cd_reg_fat);

  for cIrf in cItens loop
    if cIrf.valor_final <> 0 and cIrf.valor_desconto <> 0 then
      ncdLanc := cIrf.cd_lancamento;
      nvl_acumulado := nvl_acumulado -  cIrf.valor_desconto;
      Update dbamv.itreg_fat itf
         Set vl_total_conta = cIrf.valor_final,
             vl_desconto_conta = cIrf.valor_desconto
       Where cd_reg_fat = cIrf.reg_fat
         and cd_lancamento = cIrf.cd_lancamento;
    end if;
  end loop;
  -- Se houver diferença entre o desconto informado e o desconto aplicado, a diferença será adicionada no último item do loop.
  IF nvl_acumulado < pdesc_gru_pro.vl_desconto THEN
    Update dbamv.itreg_fat itf
        Set vl_total_conta = vl_total_conta - nvl_acumulado,
            vl_desconto_conta = Nvl(vl_desconto_conta,0) + nvl_acumulado
      Where cd_reg_fat = pdesc_gru_pro.cd_reg_fat
        and cd_lancamento = ncdLanc;
  END IF;

  -- Aplica o desconto em todos os lanÃ§amentos referentes ao procedimento do desconto incluso em ITLAN_MED
  for cIlm in cLancamentos loop
    update dbamv.itlan_med ilm
       set ilm.vl_ato = ilm.vl_ato * (1-(pdesc_gru_pro.vl_perc_desconto/100)),
           ilm.vl_desconto_conta = ilm.vl_ato * (pdesc_gru_pro.vl_perc_desconto/100)
          ,ilm.vl_liquido = ilm.vl_liquido * (1-(pdesc_gru_pro.vl_perc_desconto/100))       -- FATURCONV-2058
     where ilm.cd_reg_fat = cIlm.cd_reg_fat
       and ilm.cd_lancamento = cIlm.cd_lancamento;
  end loop;

  -- Consulta o valor total de desconto conta e o valor total dos itens
  M_PKG_FFCV_ITEM_CONTA.P_F_RETORNA_SOMATORIOS(xml, pDESC_GRU_PRO.cd_reg_fat --pdesc_pro_fat.cd_reg_fat JGDO
                                            ,null -- Cd_atendimento
                                            ,'H'  -- tp_conta
                                            ,formParams.p_mig_cd_multi_empresa
                                            ,formParams.p_mig_cd_usuario
                                            ,false
                                            ,false
                                            ,vLst_Retorno);

  vLst_Local  := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_Retorno);
  --
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'VL_DESCONTO_CONTA', nvl_desconto_conta, false);
  PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'VL_TOTAL_CONTA'   , nvl_total_conta   , false);
  -- Libera lista de retorno
  pkg_parametro.pr_limpar_lista_parametros(vLst_Local);

  nvl_total_conta := round(nvl_total_conta,2);

  Update DBAMV.reg_fat
     set vl_total_conta = nvl_total_conta,
         vl_desconto_conta = nvl_desconto_conta,
         tp_desconto = 'D'
   where cd_reg_fat= pDESC_GRU_PRO.cd_reg_fat;

  Pkg_ffcv_M_LAN_HOS.P_FECHA_CONTA(xml, pDESC_GRU_PRO.cd_reg_fat);



 -- Atualiza campo DS_OBSERVACAO_FRANQUIA em REG_FAT
  if pdesc_gru_pro.ds_observacao_franquia is not null then
    update DBAMV.reg_fat rgf
       set ds_observacao_franquia = pdesc_gru_pro.ds_observacao_franquia
     where rgf.cd_atendimento = preg_fat.cd_atendimento
       and rgf.cd_reg_fat = preg_fat.cd_reg_fat;
  end if;

end;
END P_B_PI_DESC_GRU_PRO_POST;


PROCEDURE P_B_PI_DESC_GRU_PRO_POST (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdesc_gru_pro DESC_GRU_PRORec;
    preg_fat REG_FATRec;
    pdesc_pro_fat DESC_PRO_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pDESC_PRO_FAT.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pDESC_GRU_PRO.VL_DESCONTO:= PKG_XML.GetNUMBER(xml, 'DESC_GRU_PRO.VL_DESCONTO');
        pDESC_GRU_PRO.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_GRU_PRO.CD_REG_FAT');
        pDESC_GRU_PRO.CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'DESC_GRU_PRO.CD_GRU_PRO');
        pDESC_GRU_PRO.VL_PERC_DESCONTO:= PKG_XML.GetNUMBER(xml, 'DESC_GRU_PRO.VL_PERC_DESCONTO');
        pDESC_GRU_PRO.DS_OBSERVACAO_FRANQUIA:= PKG_XML.GetVARCHAR2(xml, 'DESC_GRU_PRO.DS_OBSERVACAO_FRANQUIA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PI_DESC_GRU_PRO_POST_E(xml) THEN
                P_B_PI_DESC_GRU_PRO_POST(xml, pDESC_GRU_PRO, pREG_FAT, pDESC_PRO_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PI_DESC_GRU_PRO_POST_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT', pDESC_PRO_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'DESC_GRU_PRO.VL_DESCONTO', pDESC_GRU_PRO.VL_DESCONTO);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GRU_PRO.CD_REG_FAT', pDESC_GRU_PRO.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'DESC_GRU_PRO.CD_GRU_PRO', pDESC_GRU_PRO.CD_GRU_PRO);
        PKG_XML.SetNUMBER(xml, 'DESC_GRU_PRO.VL_PERC_DESCONTO', pDESC_GRU_PRO.VL_PERC_DESCONTO);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GRU_PRO.DS_OBSERVACAO_FRANQUIA', pDESC_GRU_PRO.DS_OBSERVACAO_FRANQUIA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>DESC_GRU_PRO.POST-QUERY</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PQ_DESC_GRU_PRO (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_gru_pro IN OUT NOCOPY DESC_GRU_PRORec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec,
	                               formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare
    nCdMultiEmpresa multi_empresas.cd_multi_empresa%type;
begin
  pdesc_gru_pro.dsp_empresa := Pkg_ffcv_M_LAN_HOS.F_DESCRICAO_EMPRESA(xml, pdesc_gru_pro.cd_reg_fat, nCdMultiEmpresa);
    if     pdesc_gru_pro.cd_gru_pro is not null then

       --PDA 416043(inicio)
       /*M_PKG_FFCV_PRO_FAT.P_RETORNA_CAMPO(xml, pitreg_fat.cd_pro_fat
                                         , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                           , formParams.P_MIG_CD_USUARIO
                                                                           , false
                                                                           , false
                                           , 'DS_GRU_PRO'
                                           , pdesc_gru_pro.nm_proced_gru);*/
      M_PKG_FFCV_GRU_PRO.P_RETORNA_CAMPO(xml, pdesc_gru_pro.cd_gru_pro
                                         , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                           , formParams.P_MIG_CD_USUARIO
                                                                           , false
                                                                           , false
                                           , 'DS_GRU_PRO'
                                           , pdesc_gru_pro.nm_proced_gru);

      --PDA 416043(fim)
    end if;

    pdesc_gru_pro.ds_observacao_franquia := preg_fat.ds_observacao_franquia;
end;
END P_B_PQ_DESC_GRU_PRO;


PROCEDURE P_B_PQ_DESC_GRU_PRO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdesc_gru_pro DESC_GRU_PRORec;
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DS_OBSERVACAO_FRANQUIA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DS_OBSERVACAO_FRANQUIA');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pDESC_GRU_PRO.DSP_EMPRESA:= PKG_XML.GetVARCHAR2(xml, 'DESC_GRU_PRO.DSP_EMPRESA');
        pDESC_GRU_PRO.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_GRU_PRO.CD_REG_FAT');
        pDESC_GRU_PRO.CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'DESC_GRU_PRO.CD_GRU_PRO');
        pDESC_GRU_PRO.NM_PROCED_GRU:= PKG_XML.GetVARCHAR2(xml, 'DESC_GRU_PRO.NM_PROCED_GRU');
        pDESC_GRU_PRO.DS_OBSERVACAO_FRANQUIA:= PKG_XML.GetVARCHAR2(xml, 'DESC_GRU_PRO.DS_OBSERVACAO_FRANQUIA');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_DESC_GRU_PRO_E(xml) THEN
                P_B_PQ_DESC_GRU_PRO(xml, pDESC_GRU_PRO, pITREG_FAT, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_DESC_GRU_PRO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DS_OBSERVACAO_FRANQUIA', pREG_FAT.DS_OBSERVACAO_FRANQUIA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GRU_PRO.DSP_EMPRESA', pDESC_GRU_PRO.DSP_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GRU_PRO.CD_REG_FAT', pDESC_GRU_PRO.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'DESC_GRU_PRO.CD_GRU_PRO', pDESC_GRU_PRO.CD_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GRU_PRO.NM_PROCED_GRU', pDESC_GRU_PRO.NM_PROCED_GRU);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GRU_PRO.DS_OBSERVACAO_FRANQUIA', pDESC_GRU_PRO.DS_OBSERVACAO_FRANQUIA);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>DESC_GRU_PRO.POST-DELETE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PD_DESC_GRU_PRO (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, pdesc_gru_pro IN OUT NOCOPY DESC_GRU_PRORec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare
  nvl_desconto_conta number;
  nvl_total_conta    number;
  vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
Begin
  nvl_desconto_conta := M_PKG_FFCV_ITEM_CONTA.F_VL_LANCAMENTO_POR_GRUPO(xml, pDESC_GRU_PRO.cd_reg_fat --pdesc_pro_fat.cd_reg_fat --PDA 416043
                                                                                                          ,null -- Cd_atendimento
                                                                                                          ,'H'  -- tp_conta
                                                                                                          ,pdesc_gru_pro.cd_gru_pro
                                                                                                          ,formParams.p_mig_cd_multi_empresa
                                                                                                          ,formParams.p_mig_cd_usuario
                                                                                                          ,false
                                                                                                          ,false);

    if nvl(nvl_desconto_conta,0) > 0 then

      Pkg_ffcv_M_LAN_HOS.P_ABRE_CONTA(xml, pDESC_GRU_PRO.cd_reg_fat);

      update dbamv.itreg_fat itf
         set itf.vl_total_conta = itf.vl_total_conta + itf.vl_desconto_conta
       where itf.cd_reg_fat = pDESC_GRU_PRO.cd_reg_fat
         and itf.cd_pro_fat in (select cd_pro_fat from dbamv.pro_fat where cd_gru_pro = pdesc_gru_pro.cd_gru_pro);

      update dbamv.itreg_fat itf
         set itf.vl_desconto_conta = 0
       where itf.cd_reg_fat = pDESC_GRU_PRO.cd_reg_fat
         and itf.cd_pro_fat in (select cd_pro_fat from dbamv.pro_fat where cd_gru_pro = pdesc_gru_pro.cd_gru_pro);

      update dbamv.itlan_med ilm
         set ilm.vl_ato = ilm.vl_ato + ilm.vl_desconto_conta
            ,ilm.vl_liquido = ilm.vl_liquido + ilm.vl_desconto_conta    -- FATURCONV-2058
       where ilm.cd_reg_fat = pDESC_GRU_PRO.cd_reg_fat
         and ilm.cd_lancamento in (select itf.cd_lancamento from dbamv.itreg_fat itf
                                    where itf.cd_reg_fat = pDESC_GRU_PRO.cd_reg_fat
                                      and itf.cd_pro_fat in (select cd_pro_fat from dbamv.pro_fat
                                                              where cd_gru_pro = pdesc_gru_pro.cd_gru_pro));

      update dbamv.itlan_med ilm
         set ilm.vl_desconto_conta = 0
       where ilm.cd_reg_fat = pDESC_GRU_PRO.cd_reg_fat
         and ilm.cd_lancamento in (select itf.cd_lancamento from dbamv.itreg_fat itf
                                    where itf.cd_reg_fat = pDESC_GRU_PRO.cd_reg_fat
                                      and itf.cd_pro_fat in (select cd_pro_fat from dbamv.pro_fat
                                                              where cd_gru_pro = pdesc_gru_pro.cd_gru_pro));

      -- Consulta o valor total de desconto conta e o valor total dos itens
      M_PKG_FFCV_ITEM_CONTA.P_F_RETORNA_SOMATORIOS(xml, pDESC_GRU_PRO.cd_reg_fat --desc_pro_fat.cd_reg_fat --PDA 416043
                                                         ,null -- Cd_atendimento
                                                         ,'H'  -- tp_conta
                                                         ,formParams.p_mig_cd_multi_empresa
                                                         ,formParams.p_mig_cd_usuario
                                                         ,false
                                                         ,false
                                                         ,vLst_Retorno);

      vLst_Local  := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_Retorno);
      --
      PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'VL_DESCONTO_CONTA', nvl_desconto_conta, false);
      PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'VL_TOTAL_CONTA'   , nvl_total_conta   , false);
      -- Libera lista de retorno
      pkg_parametro.pr_limpar_lista_parametros(vLst_Local);


        Update DBAMV.reg_fat
           set vl_total_conta = nvl_total_conta,
                vl_desconto_conta = nvl_desconto_conta
         where cd_reg_fat= pDESC_GRU_PRO.cd_reg_fat;

        if nvl(nvl_desconto_conta,0) = 0 then
            Update DBAMV.reg_fat
               set tp_desconto = null

where cd_reg_fat = pDESC_GRU_PRO.cd_reg_fat;
        end if;

      Pkg_ffcv_M_LAN_HOS.P_FECHA_CONTA(xml, pDESC_GRU_PRO.cd_reg_fat);



    end if;

Exception
  --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_40)
  When others then PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_40', 'PKG_FFCV_M_LAN_HOS', 'Erro ao excluir desconto. %s', arg_list(sqlerrm)),'E',true);
End;
END P_B_PD_DESC_GRU_PRO;


PROCEDURE P_B_PD_DESC_GRU_PRO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdesc_pro_fat DESC_PRO_FATRec;
    pdesc_gru_pro DESC_GRU_PRORec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pDESC_PRO_FAT.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT');
        pDESC_GRU_PRO.CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'DESC_GRU_PRO.CD_GRU_PRO');
        pDESC_GRU_PRO.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_GRU_PRO.CD_REG_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PD_DESC_GRU_PRO_E(xml) THEN
                P_B_PD_DESC_GRU_PRO(xml, pDESC_PRO_FAT, pDESC_GRU_PRO, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PD_DESC_GRU_PRO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT', pDESC_PRO_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'DESC_GRU_PRO.CD_GRU_PRO', pDESC_GRU_PRO.CD_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'DESC_GRU_PRO.CD_REG_FAT', pDESC_GRU_PRO.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>DESC_PRO_FAT.CD_PRO_FAT.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_DPF_CD_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

Declare
  Cursor cJaTemDescontoGrupo is
    Select 'X' dummy
      From DBAMV.conta_desc_det
     Where cd_pro_fat = pDESC_PRO_FAT.CD_PRO_FAT
       and cd_atendimento = preg_fat.cd_atendimento
       and cd_reg_fat = preg_fat.CD_REG_FAT ;

  dummy VarChar2(1);

begin
  if     pdesc_pro_fat.cd_pro_fat is not null then
      -- Busca Descrio Procedimento
    M_PKG_FFCV_PRO_FAT.P_RETORNA_CAMPO(xml, pdesc_pro_fat.cd_pro_fat
                                     , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                       , formParams.P_MIG_CD_USUARIO
                                                                       , TRUE
                                                                       , TRUE
                                                                       , 'DS_PRO_FAT'
                                                                       , pdesc_pro_fat.nm_proced);

      Open cJaTemDescontoGrupo;
      Fetch cJaTemDescontoGrupo into dummy;
      if cJaTemDescontoGrupo%Found then
          Close cJaTemDescontoGrupo;
          pdesc_pro_fat.nm_proced := null;
          pdesc_pro_fat.cd_pro_fat := Null;
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_41)
          PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_41', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Desconto já concedido ao Procedimento %s', arg_list(pDESC_PRO_FAT.CD_PRO_FAT))  , 'I', True) ;
      end if ;
      Close cJaTemDescontoGrupo ;
    end if;
end;
END P_I_WVI_DPF_CD_PRO_FAT;


PROCEDURE P_I_WVI_DPF_CD_PRO_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdesc_pro_fat DESC_PRO_FATRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pDESC_PRO_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_PRO_FAT');
        pDESC_PRO_FAT.NM_PROCED:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.NM_PROCED');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_DPF_CD_PRO_FAT_E(xml) THEN
                P_I_WVI_DPF_CD_PRO_FAT(xml, pDESC_PRO_FAT, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_DPF_CD_PRO_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_PRO_FAT', pDESC_PRO_FAT.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.NM_PROCED', pDESC_PRO_FAT.NM_PROCED);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>DESC_PRO_FAT.PRE-INSERT</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PI_DESC_PRO_FAT_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, preg_fat IN OUT NOCOPY REG_FATRec) IS
BEGIN

  DECLARE

    CURSOR cSeq is
      select SEQ_CONTA_DESC_DET.NEXTVAL
        from sys.dual;

    -- pda RE 371805 - incio
    cursor cTotal is
  	  select round(sum(vl_total_conta),2)
     	  from dbamv.itreg_fat itf
      where itf.cd_reg_fat = pDESC_PRO_FAT.cd_reg_fat
        and itf.cd_pro_fat = pDESC_PRO_FAT.cd_pro_fat
        and nvl(sn_pertence_pacote, 'N') = 'N'
        and nvl(sn_paciente_paga,'N') = 'N'
        and nvl(tp_pagamento, 'P') <> 'C' ;
    nvl_total_conta number;
    -- pda RE 371805 - fim

  BEGIN

    -- Busca sequence da conta
    OPEN  cSeq;
    fetch cSeq into  pDESC_PRO_FAT.CD_CONTA_DESC_DET;
    close cSeq;
    pdesc_pro_fat.cd_reg_amb := null;
    pdesc_pro_fat.cd_atendimento := preg_fat.cd_atendimento;

    -- pda RE 371805 - incio
    Open cTotal;
    fetch cTotal into nvl_total_conta ;
    close cTotal;
    pDESC_PRO_FAT.VL_DESCONTO := nvl_total_conta * (pDESC_PRO_FAT.vl_perc_desconto/100);
    -- pda RE 371805 - fim

  end;

END P_B_PI_DESC_PRO_FAT_PRE;


PROCEDURE P_B_PI_DESC_PRO_FAT_PRE (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdesc_pro_fat DESC_PRO_FATRec;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pDESC_PRO_FAT.CD_CONTA_DESC_DET:= PKG_XML.GetNUMBER(xml, 'DESC_PRO_FAT.CD_CONTA_DESC_DET');
        pDESC_PRO_FAT.CD_REG_AMB:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_AMB');
        pDESC_PRO_FAT.CD_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PI_DESC_PRO_FAT_PRE_E(xml) THEN
                P_B_PI_DESC_PRO_FAT_PRE(xml, pDESC_PRO_FAT, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PI_DESC_PRO_FAT_PRE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'DESC_PRO_FAT.CD_CONTA_DESC_DET', pDESC_PRO_FAT.CD_CONTA_DESC_DET);
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_AMB', pDESC_PRO_FAT.CD_REG_AMB);
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_ATENDIMENTO', pDESC_PRO_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>DESC_PRO_FAT.POST-INSERT</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PI_DESC_PRO_FAT_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare

    cursor cValorItensHosp is
        select sum(nvl(itlan_med.vl_liquido, itreg_fat.vl_total_conta)) vl_total_conta
           , sum(nvl(nvl(itlan_med.vl_desconto_conta, itreg_fat.vl_desconto_conta), 0)) vl_desconto_conta
          from dbamv.itreg_fat
              , dbamv.itlan_med
          Where itreg_fat.cd_reg_fat = pDESC_PRO_FAT.cd_reg_fat
            and itlan_med.cd_reg_fat(+) = itreg_fat.cd_reg_fat
            and itlan_med.cd_lancamento(+) = itreg_fat.cd_lancamento
            and nvl(itreg_fat.sn_pertence_pacote, 'N') = 'N'
            and nvl(itreg_fat.sn_paciente_paga,'N') = 'N'
            and nvl( itlan_med.tp_pagamento, nvl( itreg_fat.tp_pagamento, 'P' ) ) <> 'C';

    CURSOR cVerificaConfiguracao IS
      SELECT nvl(sn_desconto_por_lancamento, 'N')
        FROM dbamv.config_ffcv
       WHERE cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;

    nvl_desconto_conta number;
    nvl_total_conta number;
    snVerificaConfiguracao VARCHAR2(1);
begin

  update DBAMV.reg_fat
     set sn_fechada = 'N'
   where cd_reg_fat = pDESC_PRO_FAT.cd_reg_fat;

  OPEN cVerificaConfiguracao;
  FETCH cVerificaConfiguracao INTO snVerificaConfiguracao;
  CLOSE cVerificaConfiguracao;

  IF snVerificaConfiguracao = 'S' THEN  --FATURCONV-9204

    update dbamv.itreg_fat
     	 set vl_total_conta = (vl_total_conta -(pDESC_PRO_FAT.VL_DESCONTO)),
	         vl_desconto_conta = pDESC_PRO_FAT.VL_DESCONTO
     where cd_pro_fat = pDESC_PRO_FAT.cd_pro_fat
		   and cd_reg_fat = pDESC_PRO_FAT.cd_reg_fat
		  and cd_lancamento = pDESC_PRO_FAT.DSP_CD_LANCAMENTO;


		-- Aplica o desconto em todos os lançamentos referentes ao procedimento do desconto incluso em ITLAN_MED
		update dbamv.itlan_med ilm
		   set ilm.vl_ato = ilm.vl_ato * (1-(pDESC_PRO_FAT.VL_PERC_DESCONTO/100)),
		    	 ilm.vl_desconto_conta = ilm.vl_ato * (pDESC_PRO_FAT.VL_PERC_DESCONTO/100),
		    	 ilm.vl_liquido =  ilm.vl_liquido * (1-(pDESC_PRO_FAT.vl_perc_desconto/100))  -- PDA 293478 - Incluindo coluna no update
		  where ilm.cd_lancamento = pDESC_PRO_FAT.DSP_CD_LANCAMENTO -- PDA 293478 teste
  	    and ilm.cd_reg_fat = pDESC_PRO_FAT.cd_reg_fat;
   ELSE
-- pda RE 371805 - correo no update da itreg-fat - colocada a restrio sn_pertence_pacote,tp_pagamento,sn_paciente_paga
  update DBAMV.itreg_fat
     Set vl_total_conta    = vl_total_conta * (1-(pDESC_PRO_FAT.vl_perc_desconto/100)),
         vl_desconto_conta = vl_total_conta * (pDESC_PRO_FAT.vl_perc_desconto/100)
   where cd_pro_fat = pdesc_pro_fat.cd_pro_fat
     and cd_reg_fat = pdesc_pro_fat.cd_reg_fat
		 and nvl(sn_pertence_pacote, 'N') = 'N'
     and nvl(sn_paciente_paga,'N') = 'N'
     and nvl(tp_pagamento, 'P') = 'P';

  -- Aplica o desconto em todos os lançamentos referentes ao procedimento do desconto incluso em ITLAN_MED
  update DBAMV.itlan_med ilm
     set ilm.vl_ato = ilm.vl_ato * (1-(pDESC_PRO_FAT.VL_PERC_DESCONTO/100)),
           ilm.vl_desconto_conta = ilm.vl_ato * (pDESC_PRO_FAT.VL_PERC_DESCONTO/100),
           vl_liquido = vl_liquido * (1-(pDESC_PRO_FAT.vl_perc_desconto/100))  --FATURCONV-9204
   where ilm.cd_lancamento in (select cd_lancamento
                                 from DBAMV.itreg_fat
                                where cd_pro_fat = pdesc_pro_fat.cd_pro_fat
                                  and cd_reg_fat = pdesc_pro_fat.cd_reg_fat)
     and ilm.cd_reg_fat = pdesc_pro_fat.cd_reg_fat;
  END IF;
  -- Consulta o valor total de desconto conta e o valor total dos itens
  OPEN cValorItensHosp;
  FETCH cValorItensHosp INTO nvl_total_conta, nvl_desconto_conta;
  CLOSE cValorItensHosp;


  Update DBAMV.reg_fat
     set vl_total_conta = nvl_total_conta,
           vl_desconto_conta = nvl_desconto_conta,
           tp_desconto = 'D'
   where cd_reg_fat= pdesc_pro_fat.cd_reg_fat;

    update DBAMV.reg_fat
     set sn_fechada = 'S'
   where cd_reg_fat = pDESC_PRO_FAT.cd_reg_fat;

    if     pdesc_pro_fat.ds_observacao_franquia is not null then
        update DBAMV.reg_fat rgf
           set ds_observacao_franquia = pdesc_pro_fat.ds_observacao_franquia
         where rgf.cd_atendimento = preg_fat.cd_atendimento
              and rgf.cd_reg_fat = pdesc_pro_fat.cd_reg_fat;

    end if;
exception
    when others then PKG_XML_MGS.MSG_ALERT(xml, sqlerrm, 'W', false);
end;
END P_B_PI_DESC_PRO_FAT_POST;


PROCEDURE P_B_PI_DESC_PRO_FAT_POST (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdesc_pro_fat DESC_PRO_FATRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pDESC_PRO_FAT.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT');
        pDESC_PRO_FAT.VL_DESCONTO:= PKG_XML.GetNUMBER(xml, 'DESC_PRO_FAT.VL_DESCONTO');
        pDESC_PRO_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_PRO_FAT');
        pDESC_PRO_FAT.VL_PERC_DESCONTO:= PKG_XML.GetNUMBER(xml, 'DESC_PRO_FAT.VL_PERC_DESCONTO');
        pDESC_PRO_FAT.DS_OBSERVACAO_FRANQUIA:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.DS_OBSERVACAO_FRANQUIA');
        pDESC_PRO_FAT.DSP_CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'DESC_PRO_FAT.DSP_CD_LANCAMENTO');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PI_DESC_PRO_FAT_POST_E(xml) THEN
                P_B_PI_DESC_PRO_FAT_POST(xml, pDESC_PRO_FAT, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PI_DESC_PRO_FAT_POST_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT', pDESC_PRO_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'DESC_PRO_FAT.VL_DESCONTO', pDESC_PRO_FAT.VL_DESCONTO);
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_PRO_FAT', pDESC_PRO_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'DESC_PRO_FAT.VL_PERC_DESCONTO', pDESC_PRO_FAT.VL_PERC_DESCONTO);
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.DS_OBSERVACAO_FRANQUIA', pDESC_PRO_FAT.DS_OBSERVACAO_FRANQUIA);
        PKG_XML.SetNUMBER(xml, 'DESC_PRO_FAT.DSP_CD_LANCAMENTO', pDESC_PRO_FAT.DSP_CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>DESC_PRO_FAT.POST-QUERY</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PQ_DESC_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, preg_fat IN OUT NOCOPY REG_FATRec,
	                                formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare
    nCdMultiEmpresa multi_empresas.cd_multi_empresa%type;
begin
  pdesc_pro_fat.dsp_empresa := Pkg_ffcv_M_LAN_HOS.F_DESCRICAO_EMPRESA(xml, pdesc_pro_fat.cd_reg_fat, nCdMultiEmpresa);

  -- Verifica se o procedimento pode ser lanado em pacote
  M_PKG_FFCV_PRO_FAT.P_RETORNA_CAMPO(xml, pdesc_pro_fat.CD_PRO_FAT --pITREG_FAT.CD_PRO_FAT --PDA 416043
                                     , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                 , formParams.P_MIG_CD_USUARIO
                                                                  , TRUE
                                                                     , TRUE
                                                                     , 'DS_PRO_FAT'
                                                                     , pdesc_pro_fat.nm_proced);

  pdesc_pro_fat.ds_observacao_franquia := preg_fat.ds_observacao_franquia;
end;
END P_B_PQ_DESC_PRO_FAT;


PROCEDURE P_B_PQ_DESC_PRO_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdesc_pro_fat DESC_PRO_FATRec;
    pitreg_fat ITREG_FATRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pDESC_PRO_FAT.DSP_EMPRESA:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.DSP_EMPRESA');
        pDESC_PRO_FAT.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT');
        pDESC_PRO_FAT.NM_PROCED:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.NM_PROCED');
        pDESC_PRO_FAT.DS_OBSERVACAO_FRANQUIA:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.DS_OBSERVACAO_FRANQUIA');
        pREG_FAT.DS_OBSERVACAO_FRANQUIA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DS_OBSERVACAO_FRANQUIA');
        --pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');--PDA 416043
        pDESC_PRO_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_PRO_FAT'); --PDA 416043
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_DESC_PRO_FAT_E(xml) THEN
                P_B_PQ_DESC_PRO_FAT(xml, pDESC_PRO_FAT, pITREG_FAT, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_DESC_PRO_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.DSP_EMPRESA', pDESC_PRO_FAT.DSP_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT', pDESC_PRO_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.NM_PROCED', pDESC_PRO_FAT.NM_PROCED);
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.DS_OBSERVACAO_FRANQUIA', pDESC_PRO_FAT.DS_OBSERVACAO_FRANQUIA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DS_OBSERVACAO_FRANQUIA', pREG_FAT.DS_OBSERVACAO_FRANQUIA);
        --PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT); --PDA 416043
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_PRO_FAT', pDESC_PRO_FAT.CD_PRO_FAT); --PDA 416043
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>DESC_PRO_FAT.POST-DELETE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PD_DESC_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pdesc_pro_fat IN OUT NOCOPY DESC_PRO_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare

  -- pda RE 371805 - incio
  cursor cTotal is
    /*	select sum(itf.vl_desconto_conta),
    	       round(sum(vl_total_conta),2)
       	from dbamv.itreg_fat itf
       where itf.cd_reg_fat = pdesc_pro_fat.cd_reg_fat
         and nvl(sn_pertence_pacote, 'N') = 'N'
         and nvl(sn_paciente_paga,'N') = 'N'
         and nvl(tp_pagamento, 'P') <> 'C' ;*/
  -- pda RE 371805 - fim

   select sum(distinct nvl(ilm.vl_desconto_conta, itf.vl_desconto_conta)),  --FATURCONV-9204
		        round(sum(nvl(ilm.vl_liquido, itf.vl_total_conta)),2)
	   	  from   dbamv.itreg_fat itf,
	   	        dbamv.itlan_med ilm
	    where itf.cd_reg_fat = pdesc_pro_fat.cd_reg_fat
	      and ilm.cd_reg_fat(+) = itf.cd_reg_fat
	      and itf.cd_lancamento = ilm.cd_lancamento(+)
	      and nvl(itf.sn_pertence_pacote, 'N') = 'N'
	      and nvl(itf.sn_paciente_paga,'N') = 'N'
	      and nvl(nvl(ilm.tp_pagamento,itf.tp_pagamento), 'P') <> 'C';

  CURSOR verificaConfiguracao IS                    --FATURCONV-9204
    SELECT Nvl(sn_desconto_por_lancamento, 'N')
      FROM dbamv.config_ffcv
     WHERE cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;

  nvl_desconto_conta number;
  nvl_total_conta    number;
  vSnVerificaConfiguracao VARCHAR2(1);
  vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_Retorno PKG_PARAMETRO.ID_LISTA_PARAM;
Begin

  -- Grava a soma do desconto na REG_FAT e atualiza com tipo de desconto "D"
  nvl_desconto_conta := M_PKG_FFCV_ITEM_CONTA.F_VL_LANCAMENTO_POR_PROCED(xml, pdesc_pro_fat.cd_reg_fat
                                                                                                       ,null -- Cd_atendimento
                                                                                                       ,'H'  -- tp_conta
                                                                                                       ,pdesc_pro_fat.cd_pro_fat
                                                                                                       ,formParams.p_mig_cd_multi_empresa
                                                                                                       ,formParams.p_mig_cd_usuario
                                                                                                       ,false
                                                                                                       ,false);
	OPEN verificaConfiguracao;
    FETCH verificaConfiguracao INTO vSnVerificaConfiguracao;
    CLOSE verificaConfiguracao;

    if nvl(nvl_desconto_conta,0) > 0 then

      update DBAMV.reg_fat
         set sn_fechada = 'N'
       where cd_reg_fat = pdesc_pro_fat.cd_reg_fat; -- pitreg_fat.cd_reg_fat); PDA 416043

        -- Retira o desconto em todos os lançamentos referentes ao procedimento do desconto incluso em ITREG_FAT
      IF vSnVerificaConfiguracao = 'S' THEN  --FATURCONV-9204

          update dbamv.itreg_fat
		        set vl_total_conta = vl_total_conta + vl_desconto_conta, --vl_desconto,
		            vl_desconto_conta = 0
		      where cd_pro_fat = pdesc_pro_fat.cd_pro_fat
		        and cd_reg_fat = pdesc_pro_fat.cd_reg_fat-- :itreg_fat.cd_reg_fat;
		        and cd_lancamento = pdesc_pro_fat.DSP_CD_LANCAMENTO;-- PDA 351651
      ELSE
          update DBAMV.itreg_fat
          set vl_total_conta = vl_total_conta + vl_desconto_conta, --vl_desconto, PDA 416043
              vl_desconto_conta = 0
        where cd_pro_fat = pdesc_pro_fat.cd_pro_fat
          and cd_reg_fat = pdesc_pro_fat.cd_reg_fat;  -- pda 367445 RE - pitreg_fat.cd_reg_fat;
		  END IF;
        -- Retira o desconto em todos os lançamentos referentes ao procedimento do desconto incluso em ITLAN_MED
        update DBAMV.itlan_med ilm
           set ilm.vl_ato = ilm.vl_ato + ilm.vl_desconto_conta,
                  ilm.vl_desconto_conta = 0
         where ilm.cd_reg_fat = pdesc_pro_fat.cd_reg_fat  -- pda 367445 RE - pitreg_fat.cd_reg_fat
           and ilm.cd_lancamento in (select cd_lancamento from DBAMV.itreg_fat where cd_pro_fat = pdesc_pro_fat.cd_pro_fat
                                                                       and cd_reg_fat = pitreg_fat.cd_reg_fat);

    -- Grava a soma do desconto na REG_FAT e atualiza com tipo de desconto "D"
      M_PKG_FFCV_ITEM_CONTA.P_F_RETORNA_SOMATORIOS(xml, pdesc_pro_fat.cd_reg_fat
                                                         ,null -- Cd_atendimento
                                                         ,'H'  -- tp_conta
                                                         ,formParams.p_mig_cd_multi_empresa
                                                         ,formParams.p_mig_cd_usuario
                                                         ,false
                                                         ,false
                                                         ,vLst_Retorno);

      vLst_Local  := PKG_PARAMETRO.FN_RECUPERA_LISTA_PARAMETROS(vLst_Retorno);


      --PDA 416043(inico)
      -- pda RE 371805 - incio
      /*open cTotal;
      fetch cTotal into nvl_desconto_conta,nvl_total_conta;
      close cTotal;*/
      -- pda RE 371805 - fim
      --PDA 416043(fim)

      PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'VL_DESCONTO_CONTA', nvl_desconto_conta, false);
      PKG_PARAMETRO.PR_RECUPERA_PARAMETRO(vLst_Local, 'VL_TOTAL_CONTA'   , nvl_total_conta   , false);
      -- Libera lista de retorno
      pkg_parametro.pr_limpar_lista_parametros(vLst_Local);

      Update DBAMV.reg_fat
         set vl_total_conta = nvl_total_conta,
              vl_desconto_conta = nvl_desconto_conta
       where cd_reg_fat= pdesc_pro_fat.cd_reg_fat;  -- pda 367445 RE - pitreg_fat.cd_reg_fat;

      if nvl(nvl_desconto_conta,0) = 0 then
        Update DBAMV.reg_fat
           set tp_desconto = null
         	  ,DS_OBSERVACAO_FRANQUIA = NULL   --FATURCONV-9204
         where cd_reg_fat = pdesc_pro_fat.cd_reg_fat;  -- pda 367445 RE - pitreg_fat.cd_reg_fat;
    end if;

    Update dbamv.reg_fat
  	   set sn_fechada = 'S'
  	 where cd_reg_fat = pdesc_pro_fat.cd_reg_fat;  -- pda 367445 RE - pitreg_fat.cd_reg_fat);


    end if;
Exception
  --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_40)
  When others then PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_40', 'PKG_FFCV_M_LAN_HOS', 'Erro ao excluir desconto. %s', arg_list(sqlerrm)),'E',true);
End;
END P_B_PD_DESC_PRO_FAT;


PROCEDURE P_B_PD_DESC_PRO_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pdesc_pro_fat DESC_PRO_FATRec;
    pitreg_fat ITREG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pDESC_PRO_FAT.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT');
        pDESC_PRO_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'DESC_PRO_FAT.CD_PRO_FAT');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        pDESC_PRO_FAT.DSP_CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'DESC_PRO_FAT.DSP_CD_LANCAMENTO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PD_DESC_PRO_FAT_E(xml) THEN
                P_B_PD_DESC_PRO_FAT(xml, pDESC_PRO_FAT, pITREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PD_DESC_PRO_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_REG_FAT', pDESC_PRO_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'DESC_PRO_FAT.CD_PRO_FAT', pDESC_PRO_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'DESC_PRO_FAT.DSP_CD_LANCAMENTO', pDESC_PRO_FAT.DSP_CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITLAN_MED2.CD_PRESTADOR.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IM_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec,
	                                   pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

pITLAN_MED2.DSP_NM_PRESTADOR := Pkg_ffcv_M_LAN_HOS.F_CHECA_PRESTADOR(xml, pITLAN_MED_REL, pITLAN_MED2, formParams, pITLAN_MED2.CD_PRESTADOR
                                                  , true
                                                  , true
                                                  , 'ITLAN_MED2');
--
BEGIN

IF  pITLAN_MED2.DSP_TP_FUNCAO = 'A' AND
    pITLAN_MED2.DSP_SN_AUXILIAR = 'N' THEN /* Auxiliar */
   --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_42)
   PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_42', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Médico não cadastrado para esta Atividade!'), 'W', TRUE);
END IF;

IF  pITLAN_MED2.DSP_TP_FUNCAO = 'N' AND
    pITLAN_MED2.DSP_SN_ANESTESISTA = 'N' THEN /* Anestesista */
   --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_42)
   PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_42', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Médico não cadastrado para esta Atividade!'), 'W', TRUE);
END IF;

IF  pITLAN_MED2.DSP_TP_FUNCAO = 'C' AND
    pITLAN_MED2.DSP_SN_CIRURGIAO = 'N' THEN /* Cirurgiao */
   --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_42)
   PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_42', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Médico não cadastrado para esta Atividade!'), 'W', TRUE);
END IF;

IF  pITLAN_MED2.DSP_TP_FUNCAO = 'O' AND
    pITLAN_MED2.DSP_SN_OUTROS = 'N' THEN /* Outros */
   --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_42)
   PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_42', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Médico não cadastrado para esta Atividade!'), 'W', TRUE);
END IF;

END;
--
DECLARE
  v_tpconv            convenio.tp_convenio%type;
  cTpPagamento    itlan_med.tp_pagamento%type;

  CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

  vProced cProced%ROWTYPE;
BEGIN

	OPEN cProced (pITREG_FAT.CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

  IF  pITLAN_MED2.TP_PAGAMENTO is null THEN
     pITLAN_MED2.TP_PAGAMENTO := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pITLAN_MED2.CD_PRESTADOR,
                                                                                  pREG_FAT.CD_CONVENIO,
                                                                                  pREG_FAT.DSP_TP_ATENDIMENTO,
                                                                                  pITREG_FAT.CD_PRO_FAT,
                                                                                  pREG_FAT.DSP_CD_ORI_ATE, null, null,
																				  --FATURCONV-1726 INI
																				  pREG_FAT.CD_CON_PLA,
																				  pREG_FAT.CD_REGRA,
																				  vProced.cd_gru_pro
																				  --FATURCONV-1726 FIM
																				  );
  END IF;

  --
    -- Consulta o tipo de Convênio
  M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, preg_fat.cd_convenio
                                    , formParams.P_MIG_CD_MULTI_EMPRESA
                                    , formParams.P_MIG_CD_USUARIO
                                    , false
                                    , false
                                    , 'TP_CONVENIO'
                                    , v_tpconv);
  --
    if nvl(v_tpconv,'P')<>'P' then
      IF  pITLAN_MED2.TP_PAGAMENTO NOT IN ('P', 'F') THEN
      cTpPagamento := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pITLAN_MED2.CD_PRESTADOR,
                                                                         pREG_FAT.CD_CONVENIO,
                                                                         pREG_FAT.DSP_TP_ATENDIMENTO,
                                                                         pITREG_FAT.CD_PRO_FAT,
                                                                         pREG_FAT.DSP_CD_ORI_ATE, null, null,
																		 --FATURCONV-1726 INI
																		 pREG_FAT.CD_CON_PLA,
																		 pREG_FAT.CD_REGRA,
																		 vProced.cd_gru_pro
																		 --FATURCONV-1726 FIM
																		 );

      if  formParams.P_MIG_CD_HOSPITAL not in (444, 445, 446, 448, 449, 378, 427, 421) then
        IF cTpPagamento = 'P' AND  pITLAN_MED2.TP_PAGAMENTO = 'C' THEN
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_58)
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_73)
          PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_58', 'PKG_FFCV_M_LAN_HOS', 'Erro'),
					  pkg_rmi_traducao.extrair_pkg_msg('MSG_73', 'PKG_FFCV_M_LAN_HOS',
						  'Erro..: Prestador não credenciado ou com exceção de credenciamento.%s..: Verificar o cadastro de credenciamento, no cadastro de prestadores', arg_list(CHR(10))), TRUE);
          pITLAN_MED2.TP_PAGAMENTO := cTpPagamento;
        END IF;
      end if;
    END IF;
  end if;
  --
END;

  /* pda Q 403981 - isto ser controlado na tela, por causa da alterA??o de prestador que não está considerando.
  if  formParams.P_MIG_SN_PRESTADOR_DUPLICADO = 'N' then
    if Nvl( Instr(   pCG$CTRL.DSP_PREST_DIGITADO, '*' || To_Char(  pITLAN_MED2.CD_PRESTADOR ) || '*' ), 0 ) > 0 then
      PKG_XML_MGS.MSG_ALERT(xml, 'Ateno: Este prestador já foi informado nesta equipe !', 'W', true) ;
    end if ;
  end if ;

  pCG$CTRL.DSP_PREST_DIGITADO := pCG$CTRL.DSP_PREST_DIGITADO || '*' || To_Char( pITLAN_MED2.CD_PRESTADOR ) || '*';
  */


Declare

  Cursor C_PrestProib is
    Select Count(1)
      From DBAMV.prest_gru_pro_proibido pgpp
     Where pgpp.cd_prestador = pITLAN_MED2.CD_PRESTADOR
       and pgpp.cd_gru_pro = pITREG_FAT.DSP_CD_GRU_PRO ;

  nQuantosTem Number ;

Begin

  Open C_PrestProib ;
  Fetch C_PrestProib into nQuantosTem ;
  Close C_PrestProib ;

  if Nvl( nQuantosTem, 0 ) > 0 then
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_35)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_35', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Este prestador não está autorizado para procedimentos do grupo %s !', arg_list(To_Char( pITREG_FAT.DSP_CD_GRU_PRO ))), 'W', True) ;
  end if ;

END;
END P_I_WVI_IM_CD_PRESTADOR;


PROCEDURE P_I_WVI_IM_CD_PRESTADOR (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitlan_med2 ITLAN_MED2Rec;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;
    pcg$ctrl CG$CTRLRec;
    pitlan_med_rel ITLAN_MED_RELRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITLAN_MED_REL.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO');
        pITLAN_MED_REL.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR');
        pITLAN_MED_REL.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA');
        pITLAN_MED_REL.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
		--FATURCONV-1726 INI
		pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
		pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
		--FATURCONV-1726 FIM
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
        pCG$CTRL.DSP_PREST_DIGITADO:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.DSP_PREST_DIGITADO');
        pITLAN_MED2.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_NM_PRESTADOR');
        pITLAN_MED2.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITLAN_MED2.CD_PRESTADOR');
        pITLAN_MED2.DSP_TP_FUNCAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_TP_FUNCAO');
        pITLAN_MED2.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR');
        pITLAN_MED2.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA');
        pITLAN_MED2.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO');
        pITLAN_MED2.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS');
        pITLAN_MED2.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.TP_PAGAMENTO');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        formParams.P_MIG_SN_PRESTADOR_DUPLICADO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PRESTADOR_DUPLICADO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IM_CD_PRESTADOR_E(xml) THEN
                P_I_WVI_IM_CD_PRESTADOR(xml, pITLAN_MED2, pREG_FAT, pITREG_FAT, pCG$CTRL, pITLAN_MED_REL, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IM_CD_PRESTADOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO', pITLAN_MED_REL.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR', pITLAN_MED_REL.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA', pITLAN_MED_REL.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS', pITLAN_MED_REL.DSP_SN_OUTROS);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
		--FATURCONV-1726 INI
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        --FATURCONV-1726 FIM
		PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.DSP_PREST_DIGITADO', pCG$CTRL.DSP_PREST_DIGITADO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_NM_PRESTADOR', pITLAN_MED2.DSP_NM_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'ITLAN_MED2.CD_PRESTADOR', pITLAN_MED2.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_TP_FUNCAO', pITLAN_MED2.DSP_TP_FUNCAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR', pITLAN_MED2.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA', pITLAN_MED2.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO', pITLAN_MED2.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS', pITLAN_MED2.DSP_SN_OUTROS);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.TP_PAGAMENTO', pITLAN_MED2.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO', pITREG_FAT.DSP_CD_GRU_PRO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PRESTADOR_DUPLICADO', formParams.P_MIG_SN_PRESTADOR_DUPLICADO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITLAN_MED2.TP_PAGAMENTO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IM_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
	                                   formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2) IS
BEGIN

DECLARE
  v_tpconv    convenio.tp_convenio%type;
  cTpPagamento Char(1);

	CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

	vProced cProced%ROWTYPE;

BEGIN

	OPEN cProced (pITREG_FAT.CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

    IF  FSV_MODE = 'QUERY' THEN
       RETURN;
    END IF;

    IF  pitlan_med2.tp_pagamento not in ('P', 'F', 'C', 'X') THEN
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_36)
      PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_36', 'PKG_FFCV_M_LAN_HOS', 'Erro: A forma de pagamento deve ser P - Produção ou C - Convênio ou F - Hospital ou X - Pago pelo Paciente.'), 'E', TRUE);
    END IF;

  if not (  pITLAN_MED2.TP_PAGAMENTO = 'X' or nvl( pITLAN_MED2.SN_PACIENTE_PAGA,'N') = 'S' ) then
    cTpPagamento := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pITLAN_MED2.CD_PRESTADOR,
                                                                     pREG_FAT.CD_CONVENIO,
                                                                     pREG_FAT.DSP_TP_ATENDIMENTO,
                                                                     pITREG_FAT.CD_PRO_FAT,
                                                                     pREG_FAT.DSP_CD_ORI_ATE, null, null,
																	 --FATURCONV-1726 INI
																	 pREG_FAT.CD_CON_PLA,
																	 pREG_FAT.CD_REGRA,
																	 vProced.cd_gru_pro
																	 --FATURCONV-1726 FIM
																	 );

      -- Consulta o tipo de Convênio
      M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, preg_fat.cd_convenio
                                        , formParams.P_MIG_CD_MULTI_EMPRESA
                                        , formParams.P_MIG_CD_USUARIO
                                        , false
                                        , false
                                        , 'TP_CONVENIO'
                                        , v_tpconv);

    if nvl(v_tpconv,'P')='P' then
         return;
    end if;

    IF  pITLAN_MED2.TP_PAGAMENTO in ('P', 'F') THEN
       RETURN;
    END IF;

    if  formParams.P_MIG_CD_HOSPITAL not in (444, 445, 446, 448, 449, 737, 378, 427, 421) then
       IF cTpPagamento = 'P' AND  pITLAN_MED2.TP_PAGAMENTO = 'C' THEN
         --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_58)
         --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_73)
         PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_58', 'PKG_FFCV_M_LAN_HOS', 'Erro'),
				   pkg_rmi_traducao.extrair_pkg_msg('MSG_73', 'PKG_FFCV_M_LAN_HOS',
					   'Erro..: Prestador não credenciado ou com exceção de credenciamento.%s..: Verificar o cadastro de credenciamento, no cadastro de prestadores', arg_list(CHR(10))), TRUE);

         pITLAN_MED2.TP_PAGAMENTO := cTpPagamento;
       END IF;
       end if;
  end if ;
END;
END P_I_WVI_IM_TP_PAGAMENTO;


PROCEDURE P_I_WVI_IM_TP_PAGAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitlan_med2 ITLAN_MED2Rec;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;
    formParams FormParamsRec;
    FSV_MODE VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
		--FATURCONV-1726 INI
		pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
		pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
		--FATURCONV-1726 FIM
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
        pITLAN_MED2.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.TP_PAGAMENTO');
        pITLAN_MED2.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.SN_PACIENTE_PAGA');
        pITLAN_MED2.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITLAN_MED2.CD_PRESTADOR');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        FSV_MODE:= PKG_XML.GetVARCHAR2(xml, 'FSV_MODE');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IM_TP_PAGAMENTO_E(xml) THEN
                P_I_WVI_IM_TP_PAGAMENTO(xml, pITLAN_MED2, pREG_FAT, pITREG_FAT, formParams, FSV_MODE);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IM_TP_PAGAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
		--FATURCONV-1726 INI
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
		--FATURCONV-1726 FIM
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.TP_PAGAMENTO', pITLAN_MED2.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.SN_PACIENTE_PAGA', pITLAN_MED2.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'ITLAN_MED2.CD_PRESTADOR', pITLAN_MED2.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetVARCHAR2(xml, 'FSV_MODE', FSV_MODE);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITLAN_MED2.PRE-BLOCK</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PB_ITLAN_MED2 (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pcg$ctrl IN OUT NOCOPY CG$CTRLRec) IS
BEGIN

declare
    cursor cQtdAuxiliar is
      SELECT count(1)
      FROM DBAMV.itlan_med itlan_med,
           DBAMV.ati_med   ati_med
     WHERE itlan_med.cd_reg_fat    = pitreg_fat.cd_reg_fat
       and itlan_med.cd_lancamento = pitreg_fat.cd_lancamento
       and itlan_med.cd_ati_med    = ati_med.cd_ati_med
       and ati_med.tp_funcao       = 'A';

  Cursor C_Medicos is
    Select itlan_med.cd_prestador
      From DBAMV.itlan_med
     Where itlan_med.cd_reg_fat = pITREG_FAT.CD_REG_FAT
       and itlan_med.cd_lancamento = pITREG_FAT.CD_LANCAMENTO;
BEGIN
    pCG$CTRL.DSP_NR_AUX_DIGITADO := null;
    open  cQtdAuxiliar;
    fetch cQtdAuxiliar into  pCG$CTRL.DSP_NR_AUX_DIGITADO;
    close cQtdAuxiliar;

    pCG$CTRL.DSP_PREST_DIGITADO := Null;
  For V_Medicos in C_Medicos Loop
    pCG$CTRL.DSP_PREST_DIGITADO := pCG$CTRL.DSP_PREST_DIGITADO || '*' || To_Char( V_Medicos.cd_prestador ) || '*' ;
  End Loop ;

end ;
END P_B_PB_ITLAN_MED2;


PROCEDURE P_B_PB_ITLAN_MED2 (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    pcg$ctrl CG$CTRLRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pCG$CTRL.DSP_NR_AUX_DIGITADO:= PKG_XML.GetNUMBER(xml, 'CG$CTRL.DSP_NR_AUX_DIGITADO');
        pCG$CTRL.DSP_PREST_DIGITADO:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.DSP_PREST_DIGITADO');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        pITREG_FAT.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PB_ITLAN_MED2_E(xml) THEN
                P_B_PB_ITLAN_MED2(xml, pITREG_FAT, pCG$CTRL);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PB_ITLAN_MED2_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'CG$CTRL.DSP_NR_AUX_DIGITADO', pCG$CTRL.DSP_NR_AUX_DIGITADO);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.DSP_PREST_DIGITADO', pCG$CTRL.DSP_PREST_DIGITADO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO', pITREG_FAT.CD_LANCAMENTO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITLAN_MED_ORIGINAL.POST-QUERY</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PQ_ITLAN_MED_ORIGINAL (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_original IN OUT NOCOPY ITLAN_MED_ORIGINALRec, FSV_RECORD_STATUS IN OUT NOCOPY varchar2) IS
BEGIN

declare
    cursor cPrestador is
      SELECT PRESTADOR.NM_PRESTADOR
            ,PRESTADOR.SN_CIRURGIAO
            ,PRESTADOR.SN_AUXILIAR
            ,PRESTADOR.SN_ANESTESISTA
            ,PRESTADOR.SN_OUTROS
        FROM DBAMV.PRESTADOR PRESTADOR
       WHERE PRESTADOR.CD_PRESTADOR = pITLAN_MED_ORIGINAL.CD_PRESTADOR
         AND PRESTADOR.TP_SITUACAO = 'A';

  cursor cAtividadeMedica is
      SELECT ATI_MED.DS_ATI_MED
            ,ATI_MED.VL_PERCENTUAL_PAGO
            ,ATI_MED.TP_FUNCAO
        FROM DBAMV.ATI_MED ATI_MED
       WHERE ATI_MED.CD_ATI_MED = pITLAN_MED_ORIGINAL.CD_ATI_MED;

  rPrestador       cPrestador%rowtype;
  rAtividadeMedica cAtividadeMedica%rowtype;
BEGIN
    open  cPrestador;
    fetch cPrestador into rPrestador;
    close cPrestador;

  pITLAN_MED_ORIGINAL.DSP_NM_PRESTADOR   := rPrestador.NM_PRESTADOR;
  pITLAN_MED_ORIGINAL.DSP_SN_CIRURGIAO   := rPrestador.SN_CIRURGIAO;
  pITLAN_MED_ORIGINAL.DSP_SN_AUXILIAR    := rPrestador.SN_AUXILIAR;
  pITLAN_MED_ORIGINAL.DSP_SN_ANESTESISTA := rPrestador.SN_ANESTESISTA;
  pITLAN_MED_ORIGINAL.DSP_SN_OUTROS      := rPrestador.SN_OUTROS;

  open  cAtividadeMedica;
  fetch cAtividadeMedica into rAtividadeMedica;
  close cAtividadeMedica;

    pITLAN_MED_ORIGINAL.DSP_DS_ATI_MED         := rAtividadeMedica.DS_ATI_MED;
    pITLAN_MED_ORIGINAL.DSP_VL_PERCENTUAL_PAGO := rAtividadeMedica.VL_PERCENTUAL_PAGO;
    pITLAN_MED_ORIGINAL.DSP_TP_FUNCAO          := rAtividadeMedica.TP_FUNCAO;

    if  pITLAN_MED_ORIGINAL.SN_PACIENTE_PAGA = 'S' then
        If  FSV_RECORD_STATUS <> 'QUERY' THEN
        pITLAN_MED_ORIGINAL.TP_PAGAMENTO := 'X' ;
      end if;
    end if ;
END;
END P_B_PQ_ITLAN_MED_ORIGINAL;


PROCEDURE P_B_PQ_ITLAN_MED_ORIGINAL (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitlan_med_original ITLAN_MED_ORIGINALRec;
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITLAN_MED_ORIGINAL.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITLAN_MED_ORIGINAL.CD_PRESTADOR');
        pITLAN_MED_ORIGINAL.CD_ATI_MED:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.CD_ATI_MED');
        pITLAN_MED_ORIGINAL.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_NM_PRESTADOR');
        pITLAN_MED_ORIGINAL.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_SN_CIRURGIAO');
        pITLAN_MED_ORIGINAL.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_SN_AUXILIAR');
        pITLAN_MED_ORIGINAL.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_SN_ANESTESISTA');
        pITLAN_MED_ORIGINAL.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_SN_OUTROS');
        pITLAN_MED_ORIGINAL.DSP_DS_ATI_MED:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_DS_ATI_MED');
        pITLAN_MED_ORIGINAL.DSP_VL_PERCENTUAL_PAGO:= PKG_XML.GetNUMBER(xml, 'ITLAN_MED_ORIGINAL.DSP_VL_PERCENTUAL_PAGO');
        pITLAN_MED_ORIGINAL.DSP_TP_FUNCAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_TP_FUNCAO');
        pITLAN_MED_ORIGINAL.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.SN_PACIENTE_PAGA');
        pITLAN_MED_ORIGINAL.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.TP_PAGAMENTO');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_ITLAN_MED_ORIGINAL_E(xml) THEN
                P_B_PQ_ITLAN_MED_ORIGINAL(xml, pITLAN_MED_ORIGINAL, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_ITLAN_MED_ORIGINAL_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITLAN_MED_ORIGINAL.CD_PRESTADOR', pITLAN_MED_ORIGINAL.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.CD_ATI_MED', pITLAN_MED_ORIGINAL.CD_ATI_MED);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_NM_PRESTADOR', pITLAN_MED_ORIGINAL.DSP_NM_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_SN_CIRURGIAO', pITLAN_MED_ORIGINAL.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_SN_AUXILIAR', pITLAN_MED_ORIGINAL.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_SN_ANESTESISTA', pITLAN_MED_ORIGINAL.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_SN_OUTROS', pITLAN_MED_ORIGINAL.DSP_SN_OUTROS);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_DS_ATI_MED', pITLAN_MED_ORIGINAL.DSP_DS_ATI_MED);
        PKG_XML.SetNUMBER(xml, 'ITLAN_MED_ORIGINAL.DSP_VL_PERCENTUAL_PAGO', pITLAN_MED_ORIGINAL.DSP_VL_PERCENTUAL_PAGO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.DSP_TP_FUNCAO', pITLAN_MED_ORIGINAL.DSP_TP_FUNCAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.SN_PACIENTE_PAGA', pITLAN_MED_ORIGINAL.SN_PACIENTE_PAGA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_ORIGINAL.TP_PAGAMENTO', pITLAN_MED_ORIGINAL.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CONTA_KIT.CD_PRESTADOR.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_CK_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

Declare
  Cursor C_Prest IS
    Select prestador.nm_prestador,
           Nvl(prestador_tipo_vinculo.tp_vinculo_conv, prestador.tp_vinculo) tp_vinculo -- ALLS PDA 721480
      From DBAMV.prestador, DBAMV.prestador_tipo_vinculo  -- ALLS PDA 721480
     Where prestador.cd_prestador = pconta_kit.CD_PRESTADOR
       and prestador_tipo_vinculo.cd_prestador (+) = prestador.cd_prestador -- ALLS PDA 721480
       and Nvl(prestador_tipo_vinculo.cd_multi_empresa ,dbamv.pkg_mv2000.le_empresa) =  dbamv.pkg_mv2000.le_empresa -- ALLS PDA 721480
       /*AND nvl(prestador_tipo_vinculo.tp_vinculo_conv , prestador.tp_vinculo )  = 'U' -- ALLS PDA 721480*/ /*OP 30533 - PDA 756461*/
       and prestador.tp_situacao = 'A' ;


  CURSOR C_PRES_CON IS
     SELECT COUNT(1)
       FROM DBAMV.PRES_CON PRES_CON
      WHERE PRES_CON.CD_PRESTADOR = pCONTA_KIT.CD_PRESTADOR
        AND PRES_CON.CD_CONVENIO  = pREG_FAT.CD_CONVENIO
        and (pres_con.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa or pres_con.cd_multi_empresa is null )  -- OP 3396 - 25/04/2013
        --FATURCONV-1726 INI
		AND (pres_con.cd_con_pla = pREG_FAT.CD_CON_PLA or pres_con.cd_con_pla is null)
		AND (pres_con.cd_pro_fat = formParams.P_TEMP_CD_PRO_FAT or pres_con.cd_pro_fat is null)
		AND (pres_con.cd_gru_pro = (SELECT CD_GRU_PRO FROM DBAMV.PRO_FAT WHERE CD_PRO_FAT = formParams.P_TEMP_CD_PRO_FAT) or pres_con.cd_gru_pro is null)
		AND (pres_con.cd_regra = pREG_FAT.cd_regra or pres_con.cd_regra is null)
		--FATURCONV-1726 FIM
		AND PRES_CON.SN_PAGA_PELO_CONVENIO = 'S';

  vTpVinculo VarChar2(1);
  nQtd_Registro NUMBER;

  cNmPrestador VarChar2( 60 );

  CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

  vProced cProced%ROWTYPE;

Begin

	OPEN cProced (formParams.P_TEMP_CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

  if  pconta_kit.CD_PRESTADOR is not null then

    Open C_Prest ;
    Fetch C_Prest into cNmPrestador, vTpVinculo ;
    Close C_Prest ;

    -- pda RE 376214 - incio
    pCONTA_KIT.TP_PAGAMENTO := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(
								 pCONTA_KIT.CD_PRESTADOR,
								 preg_fat.CD_CONVENIO,
								 preg_fat.DSP_TP_ATENDIMENTO,
								 formParams.P_TEMP_CD_PRO_FAT,
								 preg_fat.DSP_CD_ORI_ATE,
                                 null, null,
								 --FATURCONV-1726 INI
								 pREG_FAT.CD_CON_PLA,
								 pREG_FAT.CD_REGRA,
								 vProced.cd_gru_pro
								 --FATURCONV-1726 FIM
								);
    /*
    OPEN C_PRES_CON;
    FETCH C_PRES_CON INTO nQtd_Registro;
    CLOSE C_PRES_CON;

    IF NVL( nQtd_Registro, 0 ) = 1 THEN
      pCONTA_KIT.TP_PAGAMENTO := 'C';
    ELSIF NVL( nQtd_Registro, 0 ) = 0 THEN
        if vTpVinculo = 'U' then
          pCONTA_KIT.TP_PAGAMENTO := 'F';
        else
            pCONTA_KIT.TP_PAGAMENTO := 'P';
        end if;
    END IF;
    */
    -- pda RE 376214 - fim

    if cNmPrestador is null then
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_43)
      PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_43', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Este Prestador não existe !'), 'W', True) ;
    end if ;

    pconta_kit.DSP_NM_PRESTADOR := cNmPrestador ;

  end if ;

End ;

  -- Valida o KIT
  pconta_kit.ds_padrao := M_PKG_FFCV_PADRAO_COBRANCA.F_VALIDA_KIT(xml, pconta_kit.cd_padrao
                                                                 ,pconta_kit.CD_PRESTADOR
                                                                                       ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                       ,formParams.P_MIG_CD_USUARIO
                                                                                       ,TRUE
                                                                                       ,TRUE);
END P_I_WVI_CK_CD_PRESTADOR;


PROCEDURE P_I_WVI_CK_CD_PRESTADOR (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pconta_kit CONTA_KITRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
		--FATURCONV-1726 INI
		pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
		pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
		--FATURCONV-1726 FIM
        pCONTA_KIT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR');
        pCONTA_KIT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.TP_PAGAMENTO');
        pCONTA_KIT.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.DSP_NM_PRESTADOR');
        pCONTA_KIT.DS_PADRAO:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.DS_PADRAO');
        pCONTA_KIT.CD_PADRAO:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PADRAO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_CD_PRESTADOR_E(xml) THEN
                P_I_WVI_CK_CD_PRESTADOR(xml, pCONTA_KIT, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_CD_PRESTADOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR', pCONTA_KIT.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.TP_PAGAMENTO', pCONTA_KIT.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.DSP_NM_PRESTADOR', pCONTA_KIT.DSP_NM_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.DS_PADRAO', pCONTA_KIT.DS_PADRAO);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PADRAO', pCONTA_KIT.CD_PADRAO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CONTA_KIT.CD_PADRAO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_CK_CD_PADRAO (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare
    nCDPrestador number;
begin
  pconta_kit.ds_padrao := M_PKG_FFCV_PADRAO_COBRANCA.F_VALIDA_KIT(xml, pconta_kit.cd_padrao
                                                                 ,pconta_kit.CD_PRESTADOR
                                                                                       ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                       ,formParams.P_MIG_CD_USUARIO
                                                                                       ,false
                                                                                       ,TRUE);

  M_PKG_FFCV_PADRAO_COBRANCA.P_RETORNA_CAMPO(xml, pconta_kit.cd_padrao
                                            ,formParams.P_MIG_CD_MULTI_EMPRESA
                                            ,formParams.P_MIG_CD_USUARIO
                                            ,false
                                            ,false
                                            ,'CD_PRESTADOR'
                                            ,nCDPrestador);
  --
  if nCDPrestador is not null then
        pCONTA_KIT.CD_PRESTADOR := nCDPrestador;
        PKG_XML.SetPropBoolean(xml, 'ITEM','CONTA_KIT.CD_PRESTADOR','ENABLED',false);
  else
       PKG_XML.SetPropBoolean(xml, 'ITEM','CONTA_KIT.CD_PRESTADOR','ENABLED',true);
       PKG_XML.SetPropBoolean(xml, 'ITEM','CONTA_KIT.CD_PRESTADOR','NAVIGABLE',true);
       PKG_XML.SetPropBoolean(xml, 'ITEM','CONTA_KIT.CD_PRESTADOR','UPDATEABLE',true);
  end if;
END;
END P_I_WVI_CK_CD_PADRAO;


PROCEDURE P_I_WVI_CK_CD_PADRAO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pconta_kit CONTA_KITRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pCONTA_KIT.DS_PADRAO:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.DS_PADRAO');
        pCONTA_KIT.CD_PADRAO:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PADRAO');
        pCONTA_KIT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_CD_PADRAO_E(xml) THEN
                P_I_WVI_CK_CD_PADRAO(xml, pCONTA_KIT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_CD_PADRAO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.DS_PADRAO', pCONTA_KIT.DS_PADRAO);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PADRAO', pCONTA_KIT.CD_PADRAO);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR', pCONTA_KIT.CD_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CONTA_KIT.CD_SETOR.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_CK_CD_SETOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

DECLARE
  bSetorValido boolean;
BEGIN
   IF  pCONTA_KIT.CD_SETOR IS NULL THEN
      RETURN;
   END IF;

    if  formParams.P_MIG_SN_USUARIO_SETOR = 'S' then
      -- Valida se o usuário pode lanar no setor
    bSetorValido := M_PKG_FFCV_ITEM_CONTA.F_PERMITE_LANCAMENTO_SETOR(xml, pCONTA_KIT.CD_SETOR
                                                                                            , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                            , formParams.P_MIG_CD_USUARIO
                                                                                            , true
                                                                                            , true);
  end if;

  pCONTA_KIT.dsp_nm_setor := Pkg_ffcv_M_LAN_HOS.F_POPULA_NM_SETOR(xml, formParams, pCONTA_KIT.cd_setor, true, true);
END;
END P_I_WVI_CK_CD_SETOR;


PROCEDURE P_I_WVI_CK_CD_SETOR (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pconta_kit CONTA_KITRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pCONTA_KIT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_SETOR');
        pCONTA_KIT.DSP_NM_SETOR:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.DSP_NM_SETOR');
        formParams.P_MIG_SN_USUARIO_SETOR:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_USUARIO_SETOR');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_CD_SETOR_E(xml) THEN
                P_I_WVI_CK_CD_SETOR(xml, pCONTA_KIT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_CD_SETOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_SETOR', pCONTA_KIT.CD_SETOR);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.DSP_NM_SETOR', pCONTA_KIT.DSP_NM_SETOR);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_USUARIO_SETOR', formParams.P_MIG_SN_USUARIO_SETOR);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CONTA_KIT.DSP_DT_SESSAO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_CK_DSP_DT_SESSAO (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

DECLARE
  bRetorno      boolean;
BEGIN
    IF  pCONTA_KIT.CD_PADRAO IS NULL THEN
      RETURN;
    END IF;

    if  formParams.P_MIG_SN_USUARIO_SETOR = 'S' then
        bRetorno := M_PKG_FFCV_ITEM_CONTA.F_PERMITE_LANCAMENTO_SETOR(xml, pCONTA_KIT.CD_SETOR
                                                                            ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                            ,formParams.P_MIG_CD_USUARIO
                                                                            ,TRUE
                                                                            ,TRUE);
  end if;

  -- Valida o KIT
  pconta_kit.ds_padrao := M_PKG_FFCV_PADRAO_COBRANCA.F_VALIDA_KIT(xml, pconta_kit.cd_padrao
                                                                 ,pconta_kit.CD_PRESTADOR
                                                                                       ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                       ,formParams.P_MIG_CD_USUARIO
                                                                                       ,true
                                                                                       ,TRUE);
END;
END P_I_WVI_CK_DSP_DT_SESSAO;


PROCEDURE P_I_WVI_CK_DSP_DT_SESSAO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pconta_kit CONTA_KITRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pCONTA_KIT.CD_PADRAO:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PADRAO');
        pCONTA_KIT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_SETOR');
        pCONTA_KIT.DS_PADRAO:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.DS_PADRAO');
        pCONTA_KIT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR');
        formParams.P_MIG_SN_USUARIO_SETOR:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_USUARIO_SETOR');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_DSP_DT_SESSAO_E(xml) THEN
                P_I_WVI_CK_DSP_DT_SESSAO(xml, pCONTA_KIT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_DSP_DT_SESSAO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PADRAO', pCONTA_KIT.CD_PADRAO);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_SETOR', pCONTA_KIT.CD_SETOR);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.DS_PADRAO', pCONTA_KIT.DS_PADRAO);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR', pCONTA_KIT.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_USUARIO_SETOR', formParams.P_MIG_SN_USUARIO_SETOR);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CONTA_KIT.TP_PAGAMENTO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_CK_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, formParams IN OUT NOCOPY FormParamsRec,
                                    	FSV_MODE IN OUT NOCOPY varchar2) IS
BEGIN

IF  FSV_MODE = 'QUERY' THEN
   RETURN;
END IF;

IF  pconta_kit.tp_pagamento not in ('P', 'F', 'C') THEN
  --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_44)
  PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_44', 'PKG_FFCV_M_LAN_HOS', 'Erro: A forma de pagamento deve ser P - Produo ou C - Convênio ou F - Hospital.'), 'E', TRUE);
END IF;

DECLARE
 cTpPagamento char(1);
 CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

  vProced cProced%ROWTYPE;
BEGIN

	OPEN cProced (pITREG_FAT.CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

	IF  pconta_kit.TP_PAGAMENTO in ('P', 'F') THEN
       RETURN;
    END IF;

    cTpPagamento := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pconta_kit.CD_PRESTADOR,
                                                                     preg_fat.CD_CONVENIO,
                                                                     preg_fat.DSP_TP_ATENDIMENTO,
                                                                     pitreg_fat.CD_PRO_FAT,
                                                                     preg_fat.DSP_CD_ORI_ATE,
                                                                     null,
                                                                     null,
																	 --FATURCONV-1726 INI
																	 pREG_FAT.CD_CON_PLA,
																	 pREG_FAT.CD_REGRA,
																	 vProced.cd_gru_pro
																	 --FATURCONV-1726 FIM
																	 );

  if  formParams.P_MIG_CD_HOSPITAL not in (444, 445, 446, 448, 449, 714, 427) then
    IF cTpPagamento = 'P' AND  pconta_kit.TP_PAGAMENTO = 'C' THEN
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_81)
      PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
			  pkg_rmi_traducao.extrair_pkg_msg('MSG_81', 'PKG_FFCV_M_LAN_HOS',
	        'Ateno..: Este Prestador não está credenciado para este tipo de pagamento ou existe uma exceção cadastrada para este prestador.%s..:
					Substitua o prestador ou altere as configuraes de credenciamento do prestador na tela de cadastro de prestador.', arg_list(chr(10))), true);
        pconta_kit.TP_PAGAMENTO := cTpPagamento;
     END IF;
  end if;
END;
END P_I_WVI_CK_TP_PAGAMENTO;


PROCEDURE P_I_WVI_CK_TP_PAGAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pconta_kit CONTA_KITRec;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;
    formParams FormParamsRec;
    FSV_MODE VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
		--FATURCONV-1726 INI
		pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
		pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
		--FATURCONV-1726 FIM
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
        pCONTA_KIT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.TP_PAGAMENTO');
        pCONTA_KIT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        FSV_MODE:= PKG_XML.GetVARCHAR2(xml, 'FSV_MODE');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_TP_PAGAMENTO_E(xml) THEN
                P_I_WVI_CK_TP_PAGAMENTO(xml, pCONTA_KIT, pREG_FAT, pITREG_FAT, formParams, FSV_MODE);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_CK_TP_PAGAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
		--FATURCONV-1726 INI
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
		--FATURCONV-1726 FIM
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.TP_PAGAMENTO', pCONTA_KIT.TP_PAGAMENTO);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR', pCONTA_KIT.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetVARCHAR2(xml, 'FSV_MODE', FSV_MODE);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CONTA_KIT.PRE-INSERT</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PI_CONTA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, preg_fat IN OUT NOCOPY REG_FATRec, var IN OUT NOCOPY VARRec) IS
BEGIN

DECLARE
  cursor cSeqContaKit is
    Select SEQ_CONTA_KIT.nextval
      From sys.dual;

  nSeqContaKit                       number;
BEGIN
  open cSeqContaKit;
  fetch cSeqContaKit into nSeqContaKit;
  close cSeqContaKit;

  pCONTA_KIT.cd_conta_kit := nSeqContaKit;
  var.vTpAlteracaoKit := 'I';
  pCONTA_KIT.cd_atendimento := preg_fat.cd_atendimento;
  pCONTA_KIT.cd_reg_fat := preg_fat.cd_reg_fat;
  -- pda RE 367474 - incio
  IF pCONTA_KIT.hr_lancamento IS NULL THEN
    pCONTA_KIT.hr_lancamento := SYSDATE;
  END IF;
  -- pda RE 367474 - fim
END;
END P_B_PI_CONTA_KIT;


PROCEDURE P_B_PI_CONTA_KIT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pconta_kit CONTA_KITRec;
    preg_fat REG_FATRec;
    var VARRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pCONTA_KIT.CD_CONTA_KIT:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.CD_CONTA_KIT');
        pCONTA_KIT.CD_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.CD_ATENDIMENTO');
        pCONTA_KIT.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.CD_REG_FAT');
        var.vTpAlteracaoKit:= PKG_XML.Getvarchar2(xml, 'VAR.VTPALTERACAOKIT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PI_CONTA_KIT_E(xml) THEN
                P_B_PI_CONTA_KIT(xml, pCONTA_KIT, pREG_FAT, VAR);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PI_CONTA_KIT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.CD_CONTA_KIT', pCONTA_KIT.CD_CONTA_KIT);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.CD_ATENDIMENTO', pCONTA_KIT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.CD_REG_FAT', pCONTA_KIT.CD_REG_FAT);
        PKG_XML.Setvarchar2(xml, 'VAR.VTPALTERACAOKIT', var.vTpAlteracaoKit);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CONTA_KIT.PRE-UPDATE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PU_CONTA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec) IS
BEGIN

declare
    cursor cPadraoCobranca (pCdProFat in varchar2) is
      select cd_pro_Fat,
             nvl(qt_padrao,1) qt_padrao
        from DBAMV.itpadrao_cobranca
       where cd_padrao = pCONTA_KIT.cd_padrao
         and cd_pro_fat = pCdProFat;

  Cursor c_itpadrao is
    Select ic.cd_pro_Fat,
           ic.qt_padrao qt_padrao
      From DBAMV.itpadrao_cobranca ic
     Where ic.cd_padrao = pconta_kit.cd_padrao;

  CURSOR cContaKitBanco is
    SELECT cd_conta_kit
         , cd_reg_fat
         , cd_reg_amb
         , cd_atendimento
         , cd_padrao
         , dt_lancamento
         , hr_lancamento
         , dt_sessao
         , qt_lancamento
         , cd_setor
         , cd_prestador
         , tp_pagamento
         , cd_ati_med
      FROM dbamv.conta_kit
     where cd_conta_kit = pconta_kit.cd_conta_kit;

    rContaKitBanco     cContaKitBanco%rowtype;
    nCdSetor           number;
    nCdPrestador       number;
    dtSessao           date;
    vTppagamento       varchar2(1);
    DtLancamento       date;
    dtHrlancamento     date;
    bAlterou           boolean;
    bLocalizouNaBase   boolean;
begin
  open  cContaKitBanco;
  fetch cContaKitBanco into rContaKitBanco;
  bLocalizouNaBase := cContaKitBanco%found;
  close cContaKitBanco;

  if bLocalizouNaBase then
    if  pconta_kit.QT_PADRAO <> rContaKitBanco.qt_lancamento then
        for vItPadrao in c_itpadrao loop
            begin
                update DBAMV.itreg_fat
                   set qt_lancamento = nvl(vItPadrao.qt_padrao,1) * nvl(pconta_kit.QT_PADRAO,0)
                where cd_reg_Fat = pconta_kit.cd_reg_fat
                  and cd_conta_kit = pconta_kit.cd_conta_kit
                  and cd_pro_fat = vItPadrao.cd_pro_fat;
            exception
                when others then
                    null;
            end;
        end loop;
        bAlterou := true;
    end if;

    if   pconta_kit.cd_setor <> rContaKitBanco.cd_setor then
        nCdSetor  := pconta_kit.cd_setor;
        bAlterou := true;
    end if;

    if   pconta_kit.cd_prestador <> rContaKitBanco.cd_prestador then
        nCdPrestador:= pconta_kit.cd_prestador;
        bAlterou := true;
    end if;

    -- OP 19191 - 13/05/2014 - colocando to_date para evitar erro de execuo do script nos clientes
    if  trunc(to_Date(pconta_kit.DSP_DT_SESSAO,'dd/mm/yyyy')) <>  trunc(to_Date(rContaKitBanco.dt_sessao,'dd/mm/yyyy')) then
        dtSessao := trunc(pconta_kit.DSP_DT_SESSAO);
        bAlterou := true;
    end if;

    if   pconta_kit.TP_PAGAMENTO <> rContaKitBanco.tp_pagamento then
        vTppagamento := pconta_kit.tp_pagamento;
        bAlterou := true;
    end if;

    if  pconta_kit.dt_lancamento <> rContaKitBanco.dt_lancamento then
        DtLancamento := pconta_kit.dt_lancamento;
        bAlterou := true;
    end if;

    if   pconta_kit.hr_lancamento <> rContaKitBanco.hr_lancamento then
          dtHrlancamento := pconta_kit.hr_lancamento;
	  -- pda RE 367474 - Preencher a hora caso o usuário não preencha.
	  if pconta_kit.hr_lancamento is null then
	  	pconta_kit.hr_lancamento := sysdate;
	  	dtHrlancamento := pconta_kit.hr_lancamento;
	  end if;
	  -- pda 367474 - fim
          bAlterou := true;
    end if;

    if bAlterou then
       update DBAMV.itreg_fat
          set cd_setor      = nvl(nCdSetor,cd_setor),
		      cd_setor_produziu = nvl(nCdSetor,cd_setor_produziu),
              cd_prestador  = nvl(nCdPrestador,cd_prestador),
              TP_PAGAMENTO  = nvl(vTppagamento,TP_PAGAMENTO),
              dt_lancamento = nvl(DtLancamento, dt_lancamento),
              hr_lancamento = nvl(dtHrlancamento,hr_lancamento)
        where cd_conta_kit  = pconta_kit.cd_conta_kit;

        --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_45)
        PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_45', 'PKG_FFCV_M_LAN_HOS', 'Kit atualizado com sucesso'),'I',false);
    end if;
  end if;
end;
END P_B_PU_CONTA_KIT;


PROCEDURE P_B_PU_CONTA_KIT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pconta_kit CONTA_KITRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pCONTA_KIT.CD_PADRAO:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PADRAO');
        pCONTA_KIT.QT_PADRAO:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.QT_PADRAO');
        pCONTA_KIT.CD_REG_FAT:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.CD_REG_FAT');
        pCONTA_KIT.CD_CONTA_KIT:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.CD_CONTA_KIT');
        pCONTA_KIT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_SETOR');
        pCONTA_KIT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR');
        pCONTA_KIT.DSP_DT_SESSAO:= PKG_XML.GetDATE(xml, 'CONTA_KIT.DSP_DT_SESSAO');
        pCONTA_KIT.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.TP_PAGAMENTO');
        pCONTA_KIT.DT_LANCAMENTO:= PKG_XML.GetDate(xml, 'CONTA_KIT.DT_LANCAMENTO');
        pCONTA_KIT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'CONTA_KIT.HR_LANCAMENTO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PU_CONTA_KIT_E(xml) THEN
                P_B_PU_CONTA_KIT(xml, pCONTA_KIT);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PU_CONTA_KIT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PADRAO', pCONTA_KIT.CD_PADRAO);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.QT_PADRAO', pCONTA_KIT.QT_PADRAO);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.CD_REG_FAT', pCONTA_KIT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.CD_CONTA_KIT', pCONTA_KIT.CD_CONTA_KIT);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_SETOR', pCONTA_KIT.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR', pCONTA_KIT.CD_PRESTADOR);
        PKG_XML.SetDATE(xml, 'CONTA_KIT.DSP_DT_SESSAO', pCONTA_KIT.DSP_DT_SESSAO);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.TP_PAGAMENTO', pCONTA_KIT.TP_PAGAMENTO);
        PKG_XML.SetDate(xml, 'CONTA_KIT.DT_LANCAMENTO', pCONTA_KIT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'CONTA_KIT.HR_LANCAMENTO', pCONTA_KIT.HR_LANCAMENTO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>CONTA_KIT.POST-QUERY</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PQ_CONTA_KIT (xml IN OUT NOCOPY PKG_XML.XmlContext,pconta_kit IN OUT NOCOPY CONTA_KITRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

pCONTA_KIT.ds_padrao := M_PKG_FFCV_PADRAO_COBRANCA.F_RETORNA_DESCRICAO(xml, pCONTA_KIT.cd_padrao
                                                                        ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                        ,formParams.P_MIG_CD_USUARIO
                                                                        ,TRUE
                                                                        ,TRUE);

  pCONTA_KIT.dsp_nm_setor := M_PKG_GLOBAL_SETOR.F_RETORNA_DESCRICAO(xml, pCONTA_KIT.cd_setor
                                                                     ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                     ,formParams.P_MIG_CD_USUARIO
                                                                     ,TRUE
                                                                     ,TRUE);


  pCONTA_KIT.dsp_nm_prestador := M_PKG_AMDC_PRESTADOR.F_RETORNA_DESCRICAO(xml, pconta_kit.CD_PRESTADOR
                                                                         ,formParams.P_MIG_CD_MULTI_EMPRESA
                                                                         ,formParams.P_MIG_CD_USUARIO
                                                                         ,TRUE
                                                                         ,TRUE);
END P_B_PQ_CONTA_KIT;


PROCEDURE P_B_PQ_CONTA_KIT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pconta_kit CONTA_KITRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pCONTA_KIT.DS_PADRAO:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.DS_PADRAO');
        pCONTA_KIT.CD_PADRAO:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PADRAO');
        pCONTA_KIT.DSP_NM_SETOR:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.DSP_NM_SETOR');
        pCONTA_KIT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_SETOR');
        pCONTA_KIT.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'CONTA_KIT.DSP_NM_PRESTADOR');
        pCONTA_KIT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_CONTA_KIT_E(xml) THEN
                P_B_PQ_CONTA_KIT(xml, pCONTA_KIT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_CONTA_KIT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.DS_PADRAO', pCONTA_KIT.DS_PADRAO);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PADRAO', pCONTA_KIT.CD_PADRAO);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.DSP_NM_SETOR', pCONTA_KIT.DSP_NM_SETOR);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_SETOR', pCONTA_KIT.CD_SETOR);
        PKG_XML.SetVARCHAR2(xml, 'CONTA_KIT.DSP_NM_PRESTADOR', pCONTA_KIT.DSP_NM_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'CONTA_KIT.CD_PRESTADOR', pCONTA_KIT.CD_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;

    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>LOG_FALHA_IMPORTACAO.POST-QUERY</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PQ_LOG_FALHA_IMPORTACAO (xml IN OUT NOCOPY PKG_XML.XmlContext,plog_falha_importacao IN OUT NOCOPY LOG_FALHA_IMPORTACAORec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare
  vLst_Local PKG_PARAMETRO.ID_LISTA_PARAM;
  vLst_ParamRet PKG_PARAMETRO.ID_LISTA_PARAM;
begin
  if  pLOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU is null then
    pLOG_FALHA_IMPORTACAO.DSP_SN_OK := 'N' ;
  else
    pLOG_FALHA_IMPORTACAO.DSP_SN_OK := 'S' ;
  end if ;

  M_PKG_FFCV_LOG_FALHA_IMPORT.P_VALIDA_LOG_FALHA_IMPORT(xml, pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA -- pCd_Item_Falha
                                                          , pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA -- pCd_Mvto_Falha
                                                          , pLOG_FALHA_IMPORTACAO.CD_PRO_FAT    -- pCd_Pro_Fat
                                                          , pLOG_FALHA_IMPORTACAO.TP_IMPORTACAO -- pTp_Importacao
                                                          , pLOG_FALHA_IMPORTACAO.TP_ERRO       -- pTp_Erro
                                                          , formParams.P_MIG_CD_MULTI_EMPRESA   -- pCd_Multi_Empresa
                                                          , formParams.P_MIG_CD_USUARIO         -- pCd_Usuario
                                                          , FALSE                               -- pRaise
                                                          , FALSE                               -- pMostraMensagem
                                                          , vLst_ParamRet);

    --
    -- Recuperao da lista de parmetro retornada pela Procedure
    vLst_Local := pkg_parametro.fn_recupera_lista_parametros(vLst_ParamRet);
    --
    -- Recuperao dos parametros
    pkg_parametro.pr_recupera_parametro(vLst_Local, 'DS_PRO_FAT'   , pLOG_FALHA_IMPORTACAO.DSP_DS_PRO_FAT   , false);
    pkg_parametro.pr_recupera_parametro(vLst_Local, 'DS_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.DSP_DS_ITEM_FALHA, false);
    pkg_parametro.pr_recupera_parametro(vLst_Local, 'CD_PRODUTO'   , pLOG_FALHA_IMPORTACAO.CD_PRODUTO       , false);
    --
    -- Remove da memoria do servidor as variaveis que não sero mais utilizadas
    pkg_parametro.pr_limpar_lista_parametros(vLst_Local);
end;
END P_B_PQ_LOG_FALHA_IMPORTACAO;


PROCEDURE P_B_PQ_LOG_FALHA_IMPORTACAO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    plog_falha_importacao LOG_FALHA_IMPORTACAORec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pLOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU');
        pLOG_FALHA_IMPORTACAO.DSP_SN_OK:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.DSP_SN_OK');
        pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.CD_PRO_FAT');
        pLOG_FALHA_IMPORTACAO.TP_IMPORTACAO:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.TP_IMPORTACAO');
        pLOG_FALHA_IMPORTACAO.TP_ERRO:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.TP_ERRO');
        pLOG_FALHA_IMPORTACAO.DSP_DS_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.DSP_DS_PRO_FAT');
        pLOG_FALHA_IMPORTACAO.DSP_DS_ITEM_FALHA:= PKG_XML.GetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.DSP_DS_ITEM_FALHA');
        pLOG_FALHA_IMPORTACAO.CD_PRODUTO:= PKG_XML.GetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_PRODUTO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_LOG_FALHA_IMPORTACAO_E(xml) THEN
                P_B_PQ_LOG_FALHA_IMPORTACAO(xml, pLOG_FALHA_IMPORTACAO, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PQ_LOG_FALHA_IMPORTACAO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU', pLOG_FALHA_IMPORTACAO.NM_USUARIO_BAIXOU);
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.DSP_SN_OK', pLOG_FALHA_IMPORTACAO.DSP_SN_OK);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.CD_ITEM_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_MVTO_FALHA', pLOG_FALHA_IMPORTACAO.CD_MVTO_FALHA);
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.CD_PRO_FAT', pLOG_FALHA_IMPORTACAO.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.TP_IMPORTACAO', pLOG_FALHA_IMPORTACAO.TP_IMPORTACAO);
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.TP_ERRO', pLOG_FALHA_IMPORTACAO.TP_ERRO);
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.DSP_DS_PRO_FAT', pLOG_FALHA_IMPORTACAO.DSP_DS_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'LOG_FALHA_IMPORTACAO.DSP_DS_ITEM_FALHA', pLOG_FALHA_IMPORTACAO.DSP_DS_ITEM_FALHA);
        PKG_XML.SetNUMBER(xml, 'LOG_FALHA_IMPORTACAO.CD_PRODUTO', pLOG_FALHA_IMPORTACAO.CD_PRODUTO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>AUDITORIA_DATA.QT_LANCAMENTO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_AD_QT_LANCAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare
    cursor cQtdLancamentos is
    select sum(nvl(qt_lancamento,0)) qtd, sum(nvl(vl_total_conta,0)) soma
        from DBAMV.itreg_fat
       where cd_reg_fat = pitreg_fat.cd_reg_fat
         and cd_pro_fat = pauditoria_data.cd_pro_fat
         and trunc(dt_lancamento) = trunc(nvl(pAUDITORIA_DATA.DT_lancamento,dt_lancamento))
         and nvl(cd_setor,1) = nvl(pAUDITORIA_DATA.cd_setor,nvl(cd_setor,1))
         and nvl(cd_setor_produziu,1) = nvl(pAUDITORIA_DATA.cd_setor_produziu,nvl(cd_setor_produziu,1));

  rQtdLancamentos cQtdLancamentos%rowtype;
Begin
    open  cQtdLancamentos;
    fetch cQtdLancamentos into rQtdLancamentos;
    close cQtdLancamentos;

  if  pauditoria_data.qt_lancamento > rQtdLancamentos.qtd
       and  formParams.P_MIG_SN_PERMITE_AUDITAR_MAIOR = 'N' then
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_21)
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_82)
      PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_21', 'PKG_FFCV_M_LAN_HOS', 'Atenção'),
			  pkg_rmi_traducao.extrair_pkg_msg('MSG_82', 'PKG_FFCV_M_LAN_HOS',
				   'Atenção..: não pode ser informada quantidade maior que a lançada para o procedimento: %s', arg_list(rQtdLancamentos.qtd)),true);
  else
       pauditoria_data.qt_auxiliar := rQtdLancamentos.qtd ;
       pauditoria_data.vl_total:= rQtdLancamentos.soma;
  end if;
End;
END P_I_WVI_AD_QT_LANCAMENTO;


PROCEDURE P_I_WVI_AD_QT_LANCAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    pauditoria_data AUDITORIA_DATARec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pAUDITORIA_DATA.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_DATA.CD_PRO_FAT');
        pAUDITORIA_DATA.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'AUDITORIA_DATA.DT_LANCAMENTO');
        pAUDITORIA_DATA.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.CD_SETOR');
        pAUDITORIA_DATA.CD_SETOR_PRODUZIU:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.CD_SETOR_PRODUZIU');
        pAUDITORIA_DATA.QT_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.QT_LANCAMENTO');
        pAUDITORIA_DATA.QT_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.QT_AUXILIAR');
        pAUDITORIA_DATA.VL_TOTAL:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.VL_TOTAL');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        formParams.P_MIG_SN_PERMITE_AUDITAR_MAIOR:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PERMITE_AUDITAR_MAIOR');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_AD_QT_LANCAMENTO_E(xml) THEN
                P_I_WVI_AD_QT_LANCAMENTO(xml, pITREG_FAT, pAUDITORIA_DATA, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_AD_QT_LANCAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_DATA.CD_PRO_FAT', pAUDITORIA_DATA.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'AUDITORIA_DATA.DT_LANCAMENTO', pAUDITORIA_DATA.DT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.CD_SETOR', pAUDITORIA_DATA.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.CD_SETOR_PRODUZIU', pAUDITORIA_DATA.CD_SETOR_PRODUZIU);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.QT_LANCAMENTO', pAUDITORIA_DATA.QT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.QT_AUXILIAR', pAUDITORIA_DATA.QT_AUXILIAR);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.VL_TOTAL', pAUDITORIA_DATA.VL_TOTAL);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PERMITE_AUDITAR_MAIOR', formParams.P_MIG_SN_PERMITE_AUDITAR_MAIOR);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>AUDITORIA_DATA.DT_LANCAMENTO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_AD_DT_LANCAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, var IN OUT NOCOPY VARRec, global IN OUT NOCOPY GlobalsRec) IS
BEGIN

declare
    Cursor  c_data is
      select distinct trunc(dt_lancamento) dt_lancamento
      from DBAMV.itreg_fat  it
     where it.cd_reg_fat = pitreg_fat.cd_reg_fat
       and it.cd_pro_fat = pauditoria_data.cd_pro_fat;

  cursor cQtdLancamentos is
    select sum(qt_lancamento) qtd
      from DBAMV.itreg_fat
     where cd_reg_fat = pitreg_fat.cd_reg_fat
       and cd_pro_fat = pauditoria_data.cd_pro_fat
         and trunc(dt_lancamento) = trunc(nvl(pAUDITORIA_DATA.DT_lancamento,dt_lancamento))
         and nvl(cd_setor,1) = nvl(pAUDITORIA_DATA.cd_setor,nvl(cd_setor,1))
         and nvl(cd_setor_produziu,1) = nvl(pAUDITORIA_DATA.cd_setor_produziu,nvl(cd_setor_produziu,1));

  vachou varchar2(1):='0';
Begin

  if nvl( global.cancelando,'N') <> 'S' then -- acrescentado essa checagem, pois qundo clicava no boto btn_confirma estava disparando  esse validate.
    if     pauditoria_data.dt_lancamento is not null then
          if var.vAgrupamento = 'DA' then
            for  record_data in c_data loop
              if record_data.dt_lancamento =  pauditoria_data.dt_lancamento then
                vachou:='1';
              end if;
          end loop;
          if vachou = '0' then
              --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_46)
              PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_46', 'PKG_FFCV_M_LAN_HOS', 'Atenção: não há lançamento para esse Procedimento nesta data.'),'W',true);
          end if;
          end if;
      end if;

    open  cQtdLancamentos;
    fetch cQtdLancamentos into  pauditoria_data.qt_lancamento;
    close cQtdLancamentos;
  end if;
End;
END P_I_WVI_AD_DT_LANCAMENTO;


PROCEDURE P_I_WVI_AD_DT_LANCAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    pauditoria_data AUDITORIA_DATARec;
    var VARRec;
    global GlobalsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pAUDITORIA_DATA.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_DATA.CD_PRO_FAT');
        pAUDITORIA_DATA.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'AUDITORIA_DATA.DT_LANCAMENTO');
        pAUDITORIA_DATA.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.CD_SETOR');
        pAUDITORIA_DATA.CD_SETOR_PRODUZIU:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.CD_SETOR_PRODUZIU');
        pAUDITORIA_DATA.QT_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.QT_LANCAMENTO');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        var.vAgrupamento:= PKG_XML.Getvarchar2(xml, 'VAR.VAGRUPAMENTO');
        global.CANCELANDO:= PKG_XML.GetVARCHAR2(xml, 'GLOBAL.CANCELANDO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_AD_DT_LANCAMENTO_E(xml) THEN
                P_I_WVI_AD_DT_LANCAMENTO(xml, pITREG_FAT, pAUDITORIA_DATA, VAR, global);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_AD_DT_LANCAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_DATA.CD_PRO_FAT', pAUDITORIA_DATA.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'AUDITORIA_DATA.DT_LANCAMENTO', pAUDITORIA_DATA.DT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.CD_SETOR', pAUDITORIA_DATA.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.CD_SETOR_PRODUZIU', pAUDITORIA_DATA.CD_SETOR_PRODUZIU);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.QT_LANCAMENTO', pAUDITORIA_DATA.QT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.Setvarchar2(xml, 'VAR.VAGRUPAMENTO', var.vAgrupamento);
        PKG_XML.SetVARCHAR2(xml, 'GLOBAL.CANCELANDO', global.CANCELANDO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>AUDITORIA_DATA.CD_PRO_FAT.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_AD_CD_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, pitreg_fat IN OUT NOCOPY ITREG_FATRec, var IN OUT NOCOPY VARRec,
	                                 global IN OUT NOCOPY GlobalsRec) IS
BEGIN

Declare
    Cursor c_procedimentos is
      Select distinct '1'
      from DBAMV.itreg_fat it
     where it.cd_reg_fat = pREG_FAT.CD_REG_FAT
       and it.cd_pro_fat = pauditoria_data.cd_pro_fat
       and it.cd_reg_fat_pai is null;

  Cursor C_Data is
    Select trunc(dt_lancamento)
        from DBAMV.itreg_fat
     where cd_pro_fat = pauditoria_data.cd_pro_fat
         and cd_reg_fat = pitreg_fat.cd_reg_fat
         and cd_reg_fat_pai is null
         and rownum = 1
       order by dt_lancamento, hr_lancamento;

  Cursor cDescr is
        Select distinct pr.ds_pro_fat
          from DBAMV.pro_fat pr
         where pr.cd_pro_fat = pauditoria_data.cd_pro_fat;

  vproced varchar2(1);
  vdata  date;
Begin
    if nvl( global.cancelando,'N') <> 'S' then
        open c_procedimentos;
        fetch c_procedimentos into vproced;
        close c_procedimentos;

      if nvl(vproced,'0') <> '1'      then
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_47)
          PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_47', 'PKG_FFCV_M_LAN_HOS', 'Atenão: Procedimento não existente na conta ou procedimento faz parte  de um Acoplamento.'),'W',true);
      else
             if var.vAgrupamento = 'DA' then

            vdata:=null;
            open c_data;
            fetch c_data into vdata;
            close c_data;
            pauditoria_data.dt_lancamento:= vdata;

                If     pauditoria_data.cd_pro_fat is not null then
                  open cDescr;
                   fetch cDescr into  pauditoria_data.dsp_ds_pro_fat;
                   close cDescr;
                End if;

             end if;
        end if;
    end if;
End;
END P_I_WVI_AD_CD_PRO_FAT;


PROCEDURE P_I_WVI_AD_CD_PRO_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pauditoria_data AUDITORIA_DATARec;
    pitreg_fat ITREG_FATRec;
    var VARRec;
    global GlobalsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pAUDITORIA_DATA.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_DATA.CD_PRO_FAT');
        pAUDITORIA_DATA.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'AUDITORIA_DATA.DT_LANCAMENTO');
        pAUDITORIA_DATA.DSP_DS_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_DATA.DSP_DS_PRO_FAT');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        var.vAgrupamento:= PKG_XML.Getvarchar2(xml, 'VAR.VAGRUPAMENTO');
        global.CANCELANDO:= PKG_XML.GetVARCHAR2(xml, 'GLOBAL.CANCELANDO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_AD_CD_PRO_FAT_E(xml) THEN
                P_I_WVI_AD_CD_PRO_FAT(xml, pREG_FAT, pAUDITORIA_DATA, pITREG_FAT, VAR, global);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_AD_CD_PRO_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_DATA.CD_PRO_FAT', pAUDITORIA_DATA.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'AUDITORIA_DATA.DT_LANCAMENTO', pAUDITORIA_DATA.DT_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_DATA.DSP_DS_PRO_FAT', pAUDITORIA_DATA.DSP_DS_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.Setvarchar2(xml, 'VAR.VAGRUPAMENTO', var.vAgrupamento);
        PKG_XML.SetVARCHAR2(xml, 'GLOBAL.CANCELANDO', global.CANCELANDO);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>AUDITORIA_DATA.PRE-BLOCK</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PB_AUDITORIA_DATA (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pauditoria_data IN OUT NOCOPY AUDITORIA_DATARec, pauditoria_conta IN OUT NOCOPY AUDITORIA_CONTARec,
                                    	formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare
    cursor cMvtoEstoque is
      SELECT MVTO_ESTOQUE.CD_USUARIO CD_USUARIO_MVTO,
             SOLSAI_PRO.CD_USUARIO
          FROM DBAMV.MVTO_ESTOQUE,
               SOLSAI_PRO  ,
                      ESTOQUE
       WHERE MVTO_ESTOQUE.CD_MVTO_ESTOQUE = pITREG_FAT.CD_MVTO
         AND MVTO_ESTOQUE.CD_SOLSAI_PRO   = SOLSAI_PRO.CD_SOLSAI_PRO(+)
             AND MVTO_ESTOQUE.CD_ESTOQUE      = ESTOQUE.CD_ESTOQUE
             AND ESTOQUE.CD_MULTI_EMPRESA     = formParams.P_MIG_CD_MULTI_EMPRESA;

  cursor cUsuarioPreMed is
        SELECT NM_USUARIO
         FROM DBAMV.PRE_MED
        WHERE CD_PRE_MED = pITREG_FAT.CD_MVTO;

  cursor cUsuarioPedRx is
        SELECT NM_USUARIO
          FROM DBAMV.PED_RX
         WHERE CD_PED_RX = pITREG_FAT.CD_MVTO;

  cursor cUsuarioPedLab is
        SELECT NM_USUARIO
          FROM DBAMV.PED_LAB
         WHERE CD_PED_LAB = pITREG_FAT.CD_MVTO;

  cursor cUsuarioAviCir is
        SELECT CD_USUARIO
          FROM DBAMV.AVISO_CIRURGIA
          WHERE CD_AVISO_CIRURGIA = pITREG_FAT.CD_MVTO;

  rMvtoEstoque   cMvtoEstoque%rowtype;
  rUsuarioPreMed cUsuarioPreMed%rowtype;
  rUsuarioPedRx  cUsuarioPedRx%rowtype;
  rUsuarioPedLab cUsuarioPedLab%rowtype;
  rUsuarioAviCir cUsuarioAviCir%rowtype;
begin
  pAUDITORIA_DATA.CD_MVTO := pITREG_FAT.CD_MVTO;
  pAUDITORIA_DATA.CD_MOTIVO_AUDITORIA := NULL;

     IF  UPPER( pITREG_FAT.TP_MVTO) = 'PRODUTO' THEN
    open  cMvtoEstoque;
    fetch cMvtoEstoque into rMvtoEstoque;
    close cMvtoEstoque;

    pAUDITORIA_DATA.CD_USUARIO_REL := rMvtoEstoque.CD_USUARIO_MVTO;
    pAUDITORIA_DATA.CD_USUARIO_SOL := rMvtoEstoque.CD_USUARIO;
  ELSIF UPPER( pITREG_FAT.TP_MVTO) = 'PRESCRICAO' THEN
    open  cUsuarioPreMed;
    fetch cUsuarioPreMed into rUsuarioPreMed;
    close cUsuarioPreMed;

    pAUDITORIA_CONTA.CD_USUARIO_REL := rUsuarioPreMed.NM_USUARIO;
  ELSIF UPPER( pITREG_FAT.TP_MVTO) = 'IMAGEM' THEN
    open  cUsuarioPedRx;
    fetch cUsuarioPedRx into rUsuarioPedRx;
    close cUsuarioPedRx;

    pAUDITORIA_DATA.CD_USUARIO_REL := rUsuarioPedRx.NM_USUARIO;
  ELSIF UPPER( pITREG_FAT.TP_MVTO) = 'SADT' THEN
    open  cUsuarioPedLab;
    fetch cUsuarioPedLab into rUsuarioPedLab;
    close cUsuarioPedLab;

    pAUDITORIA_DATA.CD_USUARIO_REL := rUsuarioPedLab.NM_USUARIO;
  ELSIF UPPER( pITREG_FAT.TP_MVTO) in ('SANGUE', 'EQUIPAMENTO', 'CIRURGIA') THEN
    open  cUsuarioAviCir;
    fetch cUsuarioAviCir into rUsuarioAviCir;
    close cUsuarioAviCir;

    pAUDITORIA_DATA.CD_USUARIO_REL := rUsuarioAviCir.CD_USUARIO;
  END IF;

End;
END P_B_PB_AUDITORIA_DATA;


PROCEDURE P_B_PB_AUDITORIA_DATA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    pauditoria_data AUDITORIA_DATARec;
    pauditoria_conta AUDITORIA_CONTARec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pAUDITORIA_DATA.CD_MVTO:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.CD_MVTO');
        pAUDITORIA_DATA.CD_MOTIVO_AUDITORIA:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_DATA.CD_MOTIVO_AUDITORIA');
        pAUDITORIA_DATA.CD_USUARIO_REL:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_DATA.CD_USUARIO_REL');
        pAUDITORIA_DATA.CD_USUARIO_SOL:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_DATA.CD_USUARIO_SOL');
        pAUDITORIA_CONTA.CD_USUARIO_REL:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_CONTA.CD_USUARIO_REL');
        pITREG_FAT.CD_MVTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_MVTO');
        pITREG_FAT.TP_MVTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_MVTO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PB_AUDITORIA_DATA_E(xml) THEN
                P_B_PB_AUDITORIA_DATA(xml, pITREG_FAT, pAUDITORIA_DATA, pAUDITORIA_CONTA, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PB_AUDITORIA_DATA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.CD_MVTO', pAUDITORIA_DATA.CD_MVTO);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_DATA.CD_MOTIVO_AUDITORIA', pAUDITORIA_DATA.CD_MOTIVO_AUDITORIA);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_DATA.CD_USUARIO_REL', pAUDITORIA_DATA.CD_USUARIO_REL);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_DATA.CD_USUARIO_SOL', pAUDITORIA_DATA.CD_USUARIO_SOL);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_CONTA.CD_USUARIO_REL', pAUDITORIA_CONTA.CD_USUARIO_REL);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_MVTO', pITREG_FAT.CD_MVTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_MVTO', pITREG_FAT.TP_MVTO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>AUDITORIA_CONTA.PRE-BLOCK</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PB_AUDITORIA_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat IN OUT NOCOPY ITREG_FATRec, pauditoria_conta IN OUT NOCOPY AUDITORIA_CONTARec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare
    cursor cMvtoEstoque is
      SELECT MVTO_ESTOQUE.CD_USUARIO CD_USUARIO_MVTO,
             SOLSAI_PRO.CD_USUARIO
          FROM DBAMV.MVTO_ESTOQUE,
               SOLSAI_PRO  ,
                      ESTOQUE
       WHERE MVTO_ESTOQUE.CD_MVTO_ESTOQUE = pITREG_FAT.CD_MVTO
         AND MVTO_ESTOQUE.CD_SOLSAI_PRO   = SOLSAI_PRO.CD_SOLSAI_PRO(+)
             AND MVTO_ESTOQUE.CD_ESTOQUE      = ESTOQUE.CD_ESTOQUE
             AND ESTOQUE.CD_MULTI_EMPRESA     = formParams.P_MIG_CD_MULTI_EMPRESA;

  cursor cUsuarioPreMed is
        SELECT NM_USUARIO
         FROM DBAMV.PRE_MED
        WHERE CD_PRE_MED = pITREG_FAT.CD_MVTO;

  cursor cUsuarioPedRx is
        SELECT NM_USUARIO
          FROM DBAMV.PED_RX
         WHERE CD_PED_RX = pITREG_FAT.CD_MVTO;

  cursor cUsuarioPedLab is
        SELECT NM_USUARIO
          FROM DBAMV.PED_LAB
         WHERE CD_PED_LAB = pITREG_FAT.CD_MVTO;

  cursor cUsuarioAviCir is
        SELECT CD_USUARIO
          FROM DBAMV.AVISO_CIRURGIA
          WHERE CD_AVISO_CIRURGIA = pITREG_FAT.CD_MVTO;

  rMvtoEstoque   cMvtoEstoque%rowtype;
  rUsuarioPreMed cUsuarioPreMed%rowtype;
  rUsuarioPedRx  cUsuarioPedRx%rowtype;
  rUsuarioPedLab cUsuarioPedLab%rowtype;
  rUsuarioAviCir cUsuarioAviCir%rowtype;
  vqt_lanc number;
  vValor  number;

begin
  pAUDITORIA_CONTA.CD_MVTO := pITREG_FAT.CD_MVTO;
  pAUDITORIA_CONTA.CD_MOTIVO_AUDITORIA := NULL;

     IF  UPPER( pITREG_FAT.TP_MVTO) = 'PRODUTO' THEN
    open  cMvtoEstoque;
    fetch cMvtoEstoque into rMvtoEstoque;
    close cMvtoEstoque;

    pAUDITORIA_CONTA.CD_USUARIO_REL := rMvtoEstoque.CD_USUARIO_MVTO;
    pAUDITORIA_CONTA.CD_USUARIO_SOL := rMvtoEstoque.CD_USUARIO;
  ELSIF UPPER( pITREG_FAT.TP_MVTO) = 'PRESCRICAO' THEN
    open  cUsuarioPreMed;
    fetch cUsuarioPreMed into rUsuarioPreMed;
    close cUsuarioPreMed;

    pAUDITORIA_CONTA.CD_USUARIO_REL := rUsuarioPreMed.NM_USUARIO;
  ELSIF UPPER( pITREG_FAT.TP_MVTO) = 'IMAGEM' THEN
    open  cUsuarioPedRx;
    fetch cUsuarioPedRx into rUsuarioPedRx;
    close cUsuarioPedRx;

    pAUDITORIA_CONTA.CD_USUARIO_REL := rUsuarioPedRx.NM_USUARIO;
  ELSIF UPPER( pITREG_FAT.TP_MVTO) = 'SADT' THEN
    open  cUsuarioPedLab;
    fetch cUsuarioPedLab into rUsuarioPedLab;
    close cUsuarioPedLab;

    pAUDITORIA_CONTA.CD_USUARIO_REL := rUsuarioPedLab.NM_USUARIO;
  ELSIF UPPER( pITREG_FAT.TP_MVTO) in ('SANGUE', 'EQUIPAMENTO', 'CIRURGIA') THEN
    open  cUsuarioAviCir;
    fetch cUsuarioAviCir into rUsuarioAviCir;
    close cUsuarioAviCir;

    pAUDITORIA_CONTA.CD_USUARIO_REL := rUsuarioAviCir.CD_USUARIO;
  END IF;

End;
END P_B_PB_AUDITORIA_CONTA;


PROCEDURE P_B_PB_AUDITORIA_CONTA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat ITREG_FATRec;
    pauditoria_conta AUDITORIA_CONTARec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pAUDITORIA_CONTA.CD_MVTO:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_CONTA.CD_MVTO');
        pAUDITORIA_CONTA.CD_MOTIVO_AUDITORIA:= PKG_XML.GetNUMBER(xml, 'AUDITORIA_CONTA.CD_MOTIVO_AUDITORIA');
        pAUDITORIA_CONTA.CD_USUARIO_REL:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_CONTA.CD_USUARIO_REL');
        pAUDITORIA_CONTA.CD_USUARIO_SOL:= PKG_XML.GetVARCHAR2(xml, 'AUDITORIA_CONTA.CD_USUARIO_SOL');
        pITREG_FAT.CD_MVTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_MVTO');
        pITREG_FAT.TP_MVTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.TP_MVTO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PB_AUDITORIA_CONTA_E(xml) THEN
                P_B_PB_AUDITORIA_CONTA(xml, pITREG_FAT, pAUDITORIA_CONTA, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PB_AUDITORIA_CONTA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_CONTA.CD_MVTO', pAUDITORIA_CONTA.CD_MVTO);
        PKG_XML.SetNUMBER(xml, 'AUDITORIA_CONTA.CD_MOTIVO_AUDITORIA', pAUDITORIA_CONTA.CD_MOTIVO_AUDITORIA);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_CONTA.CD_USUARIO_REL', pAUDITORIA_CONTA.CD_USUARIO_REL);
        PKG_XML.SetVARCHAR2(xml, 'AUDITORIA_CONTA.CD_USUARIO_SOL', pAUDITORIA_CONTA.CD_USUARIO_SOL);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_MVTO', pITREG_FAT.CD_MVTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.TP_MVTO', pITREG_FAT.TP_MVTO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>COMUM.CD_CONTA.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_C_CD_CONTA (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pcomum IN OUT NOCOPY COMUMRec) IS
BEGIN

declare
    cursor cContaEmpresa is
        select multi_empresas.ds_multi_empresa
        from DBAMV.reg_fat, DBAMV.multi_empresas
        where reg_fat.cd_multi_empresa = multi_empresas.cd_multi_empresa
         and nvl(reg_fat.cd_conta_pai, reg_fat.cd_reg_fat) = preg_fat.cd_reg_fat
         and reg_fat.cd_reg_fat = pcomum.cd_conta;

    vDsEmpresa varchar2(80);
begin

    if  pcomum.cd_conta = '%' or  pcomum.cd_conta is null then
        pcomum.ds_empresa := 'Todas';
    else

        open cContaEmpresa;
        fetch cContaEmpresa into vDsEmpresa;
        close cContaEmpresa;

        if vDsEmpresa is null then
            --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_50)
            PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_50', 'PKG_FFCV_M_LAN_HOS', 'Atenção: A conta não é válida!'),'e', true);
            pcomum.ds_empresa := '';
        else
            pcomum.ds_empresa := vDsEmpresa;
        end if;

    end if;

end;
END P_I_WVI_C_CD_CONTA;


PROCEDURE P_I_WVI_C_CD_CONTA (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pcomum COMUMRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pCOMUM.CD_CONTA:= PKG_XML.GetVARCHAR2(xml, 'COMUM.CD_CONTA');
        pCOMUM.DS_EMPRESA:= PKG_XML.GetVARCHAR2(xml, 'COMUM.DS_EMPRESA');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_C_CD_CONTA_E(xml) THEN
                P_I_WVI_C_CD_CONTA(xml, pREG_FAT, pCOMUM);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_C_CD_CONTA_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'COMUM.CD_CONTA', pCOMUM.CD_CONTA);
        PKG_XML.SetVARCHAR2(xml, 'COMUM.DS_EMPRESA', pCOMUM.DS_EMPRESA);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_REL.DT_LANCAMENTO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IFR_DT_LANCAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
	                                     pitreg_fat_relacionado IN OUT NOCOPY ITREG_FAT_RELACIONADORec, pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec) IS
BEGIN

declare
  p_erro varchar2(200);
  dReferencia Date ;
begin
   --
   dReferencia := Nvl( pItReg_Fat_REL.Dt_Lancamento, pReg_Fat.Dt_Inicio ) ;
   --
   -- Incluir o comando trunc na condio abaixo para não considerar a hora da data.
   If trunc(dReferencia) < trunc( pReg_Fat.Dt_Inicio) OR
      trunc(dReferencia) > trunc(Nvl( pReg_Fat.Dt_Final, sysdate)) Then
       --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_51)
       PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_51', 'PKG_FFCV_M_LAN_HOS', 'Erro: Data de lançamento deve estar entre o período da Conta !'),'E', true);
   End If;
   --
   Pkg_ffcv_M_LAN_HOS.P_CHK_ITREG_FAT_ITREG_FAT_A(xml, pREG_FAT, pITREG_FAT, pITREG_FAT_REL, pITREG_FAT_RELACIONADO, pITREG_FAT_SINTETICO, TRUE,'E');
   --
EXCEPTION
  WHEN OTHERS THEN
    RAISE;
end;

Begin
  if pack_lanca_ffcv.IS_Hor_Esp(  pREG_FAT.CD_CONVENIO,
                                        pREG_FAT.CD_CON_PLA,
                                        pREG_FAT.DSP_TP_ATENDIMENTO,
                                        pITREG_FAT_REL.DT_LANCAMENTO,
                                        pITREG_FAT_REL.HR_LANCAMENTO,
                                        pITREG_FAT_REL.CD_GRU_FAT,
                                        pITREG_FAT_REL.CD_PRO_FAT,
                                        pREG_FAT.CD_REGRA,
                                        pitreg_fat.cd_prestador,
                                        pitreg_fat.cd_setor
                                       )  then

    PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.SN_HORARIO_ESPECIAL','ENABLED',true) ;
    PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.SN_HORARIO_ESPECIAL','UPDATE_ALLOWED',true) ;
    PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.SN_HORARIO_ESPECIAL','INSERT_ALLOWED',true) ;

    if  pITREG_FAT_REL.DT_LANCAMENTO is not null then
      pITREG_FAT_REL.SN_HORARIO_ESPECIAL := 'S' ;
    end if ;

  else
    if  pITREG_FAT_REL.SN_HORARIO_ESPECIAL = 'S' then
      pITREG_FAT_REL.SN_HORARIO_ESPECIAL := 'N' ;
    end if ;
    PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.SN_HORARIO_ESPECIAL','ENABLED',false) ;
  end if ;
end ;
END P_I_WVI_IFR_DT_LANCAMENTO;


PROCEDURE P_I_WVI_IFR_DT_LANCAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_rel ITREG_FAT_RELRec;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;
    pitreg_fat_relacionado ITREG_FAT_RELACIONADORec;
    pitreg_fat_sintetico ITREG_FAT_SINTETICORec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO');
        pITREG_FAT_REL.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO');
        pITREG_FAT_REL.CD_GRU_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_GRU_FAT');
        pITREG_FAT_REL.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT');
        pITREG_FAT_REL.SN_HORARIO_ESPECIAL:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.SN_HORARIO_ESPECIAL');
        pITREG_FAT_REL.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_POR_ANE');
        pITREG_FAT_REL.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_NR_AUXILIAR');
        pREG_FAT.DT_INICIO:= PKG_XML.GetDate(xml, 'REG_FAT.DT_INICIO');
        pREG_FAT.DT_FINAL:= PKG_XML.GetDate(xml, 'REG_FAT.DT_FINAL');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pITREG_FAT_SINTETICO.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.CD_PRO_FAT');
        pITREG_FAT_SINTETICO.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_SINTETICO.DT_LANCAMENTO');
        pITREG_FAT_SINTETICO.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_CD_POR_ANE');
        pITREG_FAT_SINTETICO.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_NR_AUXILIAR');
        pITREG_FAT_RELACIONADO.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.CD_PRO_FAT');
        pITREG_FAT_RELACIONADO.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_RELACIONADO.DT_LANCAMENTO');
        pITREG_FAT_RELACIONADO.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_CD_POR_ANE');
        pITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_SETOR');
        pITREG_FAT.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO');
        pITREG_FAT.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.DSP_CD_POR_ANE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_CD_POR_ANE');
        pITREG_FAT.DSP_NR_AUXILIAR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.DSP_NR_AUXILIAR');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFR_DT_LANCAMENTO_E(xml) THEN
                P_I_WVI_IFR_DT_LANCAMENTO(xml, pITREG_FAT_REL, pREG_FAT, pITREG_FAT, pITREG_FAT_RELACIONADO, pITREG_FAT_SINTETICO);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFR_DT_LANCAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO', pITREG_FAT_REL.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO', pITREG_FAT_REL.HR_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_GRU_FAT', pITREG_FAT_REL.CD_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT', pITREG_FAT_REL.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.SN_HORARIO_ESPECIAL', pITREG_FAT_REL.SN_HORARIO_ESPECIAL);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_POR_ANE', pITREG_FAT_REL.DSP_CD_POR_ANE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_NR_AUXILIAR', pITREG_FAT_REL.DSP_NR_AUXILIAR);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_INICIO', pREG_FAT.DT_INICIO);
        PKG_XML.SetDate(xml, 'REG_FAT.DT_FINAL', pREG_FAT.DT_FINAL);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.CD_PRO_FAT', pITREG_FAT_SINTETICO.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT_SINTETICO.DT_LANCAMENTO', pITREG_FAT_SINTETICO.DT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_CD_POR_ANE', pITREG_FAT_SINTETICO.DSP_CD_POR_ANE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.DSP_NR_AUXILIAR', pITREG_FAT_SINTETICO.DSP_NR_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_RELACIONADO.CD_PRO_FAT', pITREG_FAT_RELACIONADO.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT_RELACIONADO.DT_LANCAMENTO', pITREG_FAT_RELACIONADO.DT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_CD_POR_ANE', pITREG_FAT_RELACIONADO.DSP_CD_POR_ANE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR', pITREG_FAT_RELACIONADO.DSP_NR_AUXILIAR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_SETOR', pITREG_FAT.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_CD_GRU_PRO', pITREG_FAT.DSP_CD_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.CD_PRO_FAT', pITREG_FAT.CD_PRO_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_CD_POR_ANE', pITREG_FAT.DSP_CD_POR_ANE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.DSP_NR_AUXILIAR', pITREG_FAT.DSP_NR_AUXILIAR);
        out_params := PKG_XML.GetOutputClob(xml);

END;

    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_REL.SN_HORARIO_ESPECIAL.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IFR_SN_HORARIO_ESPEC (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec) IS
BEGIN

if not pack_lanca_ffcv.IS_Hor_Esp(  pREG_FAT.CD_CONVENIO,
                                        pREG_FAT.CD_CON_PLA,
                                        pREG_FAT.DSP_TP_ATENDIMENTO,
                                        pITREG_FAT_REL.DT_LANCAMENTO,
                                        pITREG_FAT_REL.HR_LANCAMENTO,
                                        pITREG_FAT_REL.CD_GRU_FAT,
                                        pITREG_FAT_REL.CD_PRO_FAT,
                                        pREG_FAT.CD_REGRA,
                                        pitreg_fat.cd_prestador,
                                        pitreg_fat.cd_setor
                                       )
                and  pITREG_FAT_REL.SN_HORARIO_ESPECIAL = 'S' then
  pITREG_FAT_REL.SN_HORARIO_ESPECIAL := 'N' ;
end if ;
END P_I_WVI_IFR_SN_HORARIO_ESPEC;


PROCEDURE P_I_WVI_IFR_SN_HORARIO_ESPEC (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    pitreg_fat ITREG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO');
        pITREG_FAT_REL.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO');
        pITREG_FAT_REL.CD_GRU_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_GRU_FAT');
        pITREG_FAT_REL.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT');
        pITREG_FAT_REL.SN_HORARIO_ESPECIAL:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.SN_HORARIO_ESPECIAL');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_SETOR');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFR_SN_HORARIO_ESPEC_E(xml) THEN
                P_I_WVI_IFR_SN_HORARIO_ESPEC(xml, pREG_FAT, pITREG_FAT_REL, pITREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFR_SN_HORARIO_ESPEC_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO', pITREG_FAT_REL.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO', pITREG_FAT_REL.HR_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_GRU_FAT', pITREG_FAT_REL.CD_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT', pITREG_FAT_REL.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.SN_HORARIO_ESPECIAL', pITREG_FAT_REL.SN_HORARIO_ESPECIAL);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_SETOR', pITREG_FAT.CD_SETOR);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_REL.CD_PRESTADOR.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IFR_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
 pitreg_fat_sintetico IN OUT NOCOPY ITREG_FAT_SINTETICORec, pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

Pkg_ffcv_M_LAN_HOS.P_CHK_ITREG_FAT_PRESTADOR(xml, pITREG_FAT, pITREG_FAT_REL, pITREG_FAT_SINTETICO, pITLAN_MED_REL, pITLAN_MED2, formParams, 'E', true, true);

IF  pITREG_FAT_REL.CD_PRESTADOR IS NOT NULL THEN
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.TP_PAGAMENTO','ENABLED',true);
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.TP_PAGAMENTO','NAVIGABLE',true);
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.TP_PAGAMENTO','UPDATEABLE',true);
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.TP_PAGAMENTO','INSERT_ALLOWED',true);
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.CD_ATI_MED','ENABLED',true);           -- OP 13549
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.CD_ATI_MED','NAVIGABLE',true);         -- OP 13549
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.CD_ATI_MED','UPDATEABLE',true);        -- OP 13549
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.CD_ATI_MED','INSERT_ALLOWED',true);    -- OP 13549
ELSE
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.TP_PAGAMENTO','ENABLED',false);
   PKG_XML.SetPropBoolean(xml, 'ITEM','ITREG_FAT_REL.CD_ATI_MED','ENABLED',false);          -- OP 13549
END IF;

DECLARE
CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

	vProced cProced%ROWTYPE;

BEGIN
	OPEN cProced (pITREG_FAT.CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

  if  pITREG_FAT_REL.CD_PRESTADOR is not null then
    IF  pITREG_FAT_REL.TP_PAGAMENTO is null THEN
       pITREG_FAT_REL.TP_PAGAMENTO := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pITREG_FAT_REL.CD_PRESTADOR,
                                                                                       pREG_FAT.CD_CONVENIO,
                                                                                       pREG_FAT.DSP_TP_ATENDIMENTO,
                                                                                       pITREG_FAT_REL.CD_PRO_FAT,
                                                                                       pREG_FAT.DSP_CD_ORI_ATE, null, null,
																					   --FATURCONV-1726 INI
																					   pREG_FAT.CD_CON_PLA,
																					   pREG_FAT.CD_REGRA,
																					   vProced.cd_gru_pro
																					   --FATURCONV-1726 FIM
																					   );
    END IF;
  end if ;
END;
Declare

  Cursor C_PrestProib is
    Select Count(1)
      From DBAMV.prest_gru_pro_proibido pgpp
     Where pgpp.cd_prestador = pITREG_FAT_REL.CD_PRESTADOR
       and pgpp.cd_gru_pro = pITREG_FAT_REL.DSP_CD_GRU_PRO ;

  nQuantosTem Number ;

Begin

  Open C_PrestProib ;
  Fetch C_PrestProib into nQuantosTem ;
  Close C_PrestProib ;

  if Nvl( nQuantosTem, 0 ) > 0 then
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_35)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_35', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Este prestador não está autorizado para procedimentos do grupo %s !', arg_list(To_Char( pITREG_FAT_REL.DSP_CD_GRU_PRO ))), 'W', True) ;
  end if ;

END;
END P_I_WVI_IFR_CD_PRESTADOR;


PROCEDURE P_I_WVI_IFR_CD_PRESTADOR (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_rel ITREG_FAT_RELRec;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;
    pitreg_fat_sintetico ITREG_FAT_SINTETICORec;
    pitlan_med_rel ITLAN_MED_RELRec;
    pitlan_med2 ITLAN_MED2Rec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR');
        pITREG_FAT_REL.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO');
        pITREG_FAT_REL.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT');
        pITREG_FAT_REL.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_GRU_PRO');
        pITREG_FAT_REL.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_NM_PRESTADOR');
        pITLAN_MED_REL.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO');
        pITLAN_MED_REL.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR');
        pITLAN_MED_REL.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA');
        pITLAN_MED_REL.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
		--FATURCONV-1726 INI
		pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
		pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
		--FATURCONV-1726 FIM
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
        pITREG_FAT_SINTETICO.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_SINTETICO.CD_PRESTADOR');
        pITREG_FAT_SINTETICO.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_NM_PRESTADOR');
        pITLAN_MED2.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO');
        pITLAN_MED2.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR');
        pITLAN_MED2.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA');
        pITLAN_MED2.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS');
        pITREG_FAT.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR');
        pITREG_FAT.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT.DSP_NM_PRESTADOR');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFR_CD_PRESTADOR_E(xml) THEN
                P_I_WVI_IFR_CD_PRESTADOR(xml, pITREG_FAT_REL, pREG_FAT, pITREG_FAT, pITREG_FAT_SINTETICO, pITLAN_MED_REL, pITLAN_MED2, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFR_CD_PRESTADOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR', pITREG_FAT_REL.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO', pITREG_FAT_REL.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT', pITREG_FAT_REL.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_GRU_PRO', pITREG_FAT_REL.DSP_CD_GRU_PRO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.DSP_NM_PRESTADOR', pITREG_FAT_REL.DSP_NM_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO', pITLAN_MED_REL.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR', pITLAN_MED_REL.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA', pITLAN_MED_REL.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS', pITLAN_MED_REL.DSP_SN_OUTROS);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
		--FATURCONV-1726 INI
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
		--FATURCONV-1726 FIM
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_SINTETICO.CD_PRESTADOR', pITREG_FAT_SINTETICO.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_SINTETICO.DSP_NM_PRESTADOR', pITREG_FAT_SINTETICO.DSP_NM_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO', pITLAN_MED2.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR', pITLAN_MED2.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA', pITLAN_MED2.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS', pITLAN_MED2.DSP_SN_OUTROS);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_PRESTADOR', pITREG_FAT.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT.DSP_NM_PRESTADOR', pITREG_FAT.DSP_NM_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_REL.TP_PAGAMENTO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IFR_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec,
 FSV_MODE IN OUT NOCOPY varchar2) IS
BEGIN

IF  FSV_MODE = 'QUERY' THEN
   RETURN;
END IF;

IF  pitreg_fat_REL.tp_pagamento not in ('P', 'F', 'C', 'X') THEN
  --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_36)
  PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_36', 'PKG_FFCV_M_LAN_HOS', 'Erro: A forma de pagamento deve ser P - Produção ou C - Convênio ou F - Hospital ou X - Pago pelo Paciente.'), 'E', TRUE);
END IF;

DECLARE
  CURSOR C IS
   SELECT COUNT(1), CONVENIO.TP_CONVENIO
     FROM DBAMV.PRES_CON PRES_CON, DBAMV.CONVENIO
         ,DBAMV.EMPRESA_CONVENIO
    WHERE PRES_CON.CD_PRESTADOR = pITREG_FAT_REL.CD_PRESTADOR
      AND PRES_CON.CD_CONVENIO  = pREG_FAT.CD_CONVENIO
      AND PRES_CON.SN_PAGA_PELO_CONVENIO = 'S'
      and (pres_con.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa or pres_con.cd_multi_empresa is null )  -- OP 3396 - 25/04/2013
	  --FATURCONV-1726 INI
	  AND (pres_con.cd_con_pla = pREG_FAT.CD_CON_PLA or pres_con.cd_con_pla is null)
	  AND (pres_con.cd_pro_fat = pITREG_FAT_REL.cd_pro_fat or pres_con.cd_pro_fat is null)
	  AND (pres_con.cd_gru_pro = (SELECT CD_GRU_PRO FROM DBAMV.PRO_FAT WHERE CD_PRO_FAT = pITREG_FAT_REL.cd_pro_fat) or pres_con.cd_gru_pro is null)
	  AND (pres_con.cd_regra = pREG_FAT.cd_regra or pres_con.cd_regra is null)
	  --FATURCONV-1726 FIM
      AND Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
      AND Empresa_Convenio.Cd_Multi_Empresa = formParams.P_MIG_CD_MULTI_EMPRESA
      AND CONVENIO.CD_CONVENIO  = pREG_FAT.CD_CONVENIO
    GROUP BY CONVENIO.TP_CONVENIO;

  nQtd_Registro NUMBER;
  v_tpconv      convenio.tp_convenio%type;

BEGIN

  if not (  pITREG_FAT_REL.TP_PAGAMENTO = 'X' or  pITREG_FAT_REL.SN_PACIENTE_PAGA = 'S' ) then

    OPEN C;
    FETCH C INTO nQtd_Registro, v_tpconv;
    CLOSE C;

      -- Consulta o tipo de Convênio
      M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, preg_fat.cd_convenio
                                        , formParams.P_MIG_CD_MULTI_EMPRESA
                                        , formParams.P_MIG_CD_USUARIO
                                        , false
                                        , false
                                        , 'TP_CONVENIO'
                                        , v_tpconv);

    if nvl(v_tpconv,'P')='P' then
         return;
    end if;

    IF NVL( nQtd_Registro, 0 ) = 0 AND  pITREG_FAT_REL.TP_PAGAMENTO in ('P', 'F') THEN
       RETURN;
    END IF;

    if  formParams.P_MIG_CD_HOSPITAL not in (444, 445, 446, 448, 449, 427, 421) then
      IF NVL( nQtd_Registro, 0 ) = 0 AND  pITREG_FAT_REL.TP_PAGAMENTO = 'C' THEN
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_58)
          --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_73)
          PKG_XML_MGS.CHAMA_MENSAGEM(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_58', 'PKG_FFCV_M_LAN_HOS', 'Erro'),
					  pkg_rmi_traducao.extrair_pkg_msg('MSG_73',
						  'PKG_FFCV_M_LAN_HOS',
							'Erro..: Prestador não credenciado ou com exceção de credenciamento.%s..: Verificar o cadastro de credenciamento, no cadastro de prestadores', arg_list(CHR(10))), TRUE);
      END IF;
    end if;

  end if ;

END;
END P_I_WVI_IFR_TP_PAGAMENTO;


PROCEDURE P_I_WVI_IFR_TP_PAGAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_rel ITREG_FAT_RELRec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;
    FSV_MODE VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO');
        pITREG_FAT_REL.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR');
        pITREG_FAT_REL.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.SN_PACIENTE_PAGA');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        --FATURCONV-1726 INI
		pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
		pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
		pITREG_FAT_REL.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT');
		--FATURCONV-1726 FIM
		formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        FSV_MODE:= PKG_XML.GetVARCHAR2(xml, 'FSV_MODE');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFR_TP_PAGAMENTO_E(xml) THEN
                P_I_WVI_IFR_TP_PAGAMENTO(xml, pITREG_FAT_REL, pREG_FAT, formParams, FSV_MODE);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFR_TP_PAGAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO', pITREG_FAT_REL.TP_PAGAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR', pITREG_FAT_REL.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.SN_PACIENTE_PAGA', pITREG_FAT_REL.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
		--FATURCONV-1726 INI
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
		PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_PRO_FAT', pITREG_FAT_REL.CD_PRO_FAT);
		--FATURCONV-1726 FIM
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetVARCHAR2(xml, 'FSV_MODE', FSV_MODE);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_REL.PRE-INSERT</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PI_ITREG_FAT_REL_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
 formParams IN OUT NOCOPY FormParamsRec, FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2, FSV_RECORD_STATUS IN OUT NOCOPY varchar2) IS
BEGIN

pITREG_FAT_REL.CD_USUARIO := xml.usuario;
pITREG_FAT_REL.TP_MVTO := 'Faturamento';

-- Consulta o prximo nmero de lançamento disponível
pITREG_FAT_REL.CD_LANCAMENTO := PKG_FFCV_IT_CONTA.FNC_OBTEM_SEQUENCIA(pREG_FAT.CD_REG_FAT,'H');

Pkg_ffcv_M_LAN_HOS.P_ATUALIZA_SN_FATURA_IMPRESS(xml, pREG_FAT, FSV_CURRENT_FIELD, FSV_FORM_STATUS, FSV_RECORD_STATUS);

  if  pITREG_FAT_REL.CD_ATI_MED is null and  formParams.P_MIG_CD_ATI_MED_CLINICO is not null and  pITREG_FAT_REL.CD_PRESTADOR is not null then
    pITREG_FAT_REL.CD_ATI_MED := formParams.P_MIG_CD_ATI_MED_CLINICO;
  end if ;

if  pITREG_FAT_REL.TP_PAGAMENTO = 'X' then
  pITREG_FAT_REL.TP_PAGAMENTO := 'C' ;
  pITREG_FAT_REL.SN_PACIENTE_PAGA := 'S' ;
end if ;

pITREG_FAT_REL.CD_REG_FAT_REL := pITREG_FAT.CD_REG_FAT;
pITREG_FAT_REL.CD_LANCAMENTO_REL := pITREG_FAT.CD_LANCAMENTO;

pITREG_FAT_REL.CD_REG_FAT := pREG_FAT.CD_REG_FAT;
END P_B_PI_ITREG_FAT_REL_PRE;


PROCEDURE P_B_PI_ITREG_FAT_REL_PRE (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_rel ITREG_FAT_RELRec;
    preg_fat REG_FATRec;
    pitreg_fat ITREG_FATRec;
    formParams FormParamsRec;
    FSV_CURRENT_FIELD VARCHAR2(4000);
    FSV_FORM_STATUS VARCHAR2(4000);
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_USUARIO');
        pITREG_FAT_REL.TP_MVTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.TP_MVTO');
        pITREG_FAT_REL.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO');
        pITREG_FAT_REL.CD_ATI_MED:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_ATI_MED');
        pITREG_FAT_REL.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR');
        pITREG_FAT_REL.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO');
        pITREG_FAT_REL.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.SN_PACIENTE_PAGA');
        pITREG_FAT_REL.CD_REG_FAT_REL:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT_REL');
        pITREG_FAT_REL.CD_LANCAMENTO_REL:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO_REL');
        pITREG_FAT_REL.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.SN_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FECHADA');
        pREG_FAT.SN_FATURA_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA');
        pREG_FAT.SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA');
        pREG_FAT.DSP_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA');
        pREG_FAT.DSP_SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA');
        pITREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT');
        pITREG_FAT.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO');
        formParams.P_MIG_CD_ATI_MED_CLINICO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_ATI_MED_CLINICO');
        FSV_CURRENT_FIELD:= PKG_XML.GetVARCHAR2(xml, 'FSV_CURRENT_FIELD');
        FSV_FORM_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_FORM_STATUS');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PI_ITREG_FAT_REL_PRE_E(xml) THEN
                P_B_PI_ITREG_FAT_REL_PRE(xml, pITREG_FAT_REL, pREG_FAT, pITREG_FAT, formParams, FSV_CURRENT_FIELD, FSV_FORM_STATUS, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PI_ITREG_FAT_REL_PRE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_USUARIO', pITREG_FAT_REL.CD_USUARIO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.TP_MVTO', pITREG_FAT_REL.TP_MVTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO', pITREG_FAT_REL.CD_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_ATI_MED', pITREG_FAT_REL.CD_ATI_MED);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_PRESTADOR', pITREG_FAT_REL.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO', pITREG_FAT_REL.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.SN_PACIENTE_PAGA', pITREG_FAT_REL.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT_REL', pITREG_FAT_REL.CD_REG_FAT_REL);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO_REL', pITREG_FAT_REL.CD_LANCAMENTO_REL);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT', pITREG_FAT_REL.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FECHADA', pREG_FAT.SN_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA', pREG_FAT.SN_FATURA_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA', pREG_FAT.SN_CONTA_CALCULADA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA', pREG_FAT.DSP_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA', pREG_FAT.DSP_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA', pREG_FAT.DSP_SN_CONTA_CALCULADA);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_REG_FAT', pITREG_FAT.CD_REG_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT.CD_LANCAMENTO', pITREG_FAT.CD_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_ATI_MED_CLINICO', formParams.P_MIG_CD_ATI_MED_CLINICO);
        PKG_XML.SetVARCHAR2(xml, 'FSV_CURRENT_FIELD', FSV_CURRENT_FIELD);
        PKG_XML.SetVARCHAR2(xml, 'FSV_FORM_STATUS', FSV_FORM_STATUS);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_REL.PRE-DELETE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PD_ITREG_FAT_REL_PRE (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, pitreg_fat IN OUT NOCOPY ITREG_FATRec,
 FSV_CURRENT_FIELD IN OUT NOCOPY varchar2, FSV_FORM_STATUS IN OUT NOCOPY varchar2, FSV_RECORD_STATUS IN OUT NOCOPY varchar2) IS
BEGIN

Pkg_ffcv_M_LAN_HOS.P_CHK_ITEM_GERADO_POR_PACOTE(xml, preg_fat.cd_reg_fat, pitreg_fat_rel.cd_lancamento);

-- Verificar se o lancamento já foi repassado
Pkg_ffcv_M_LAN_HOS.P_CHECA_REPASSE_ITEM(xml, pITREG_FAT, pREG_FAT, pITREG_FAT_REL.CD_REG_FAT, pITREG_FAT_REL.CD_LANCAMENTO);

Pkg_ffcv_M_LAN_HOS.P_CHK_DATA_ATENDIMENTO(xml, pITREG_FAT, pREG_FAT, pITREG_FAT_REL, 'ITREG_FAT_REL');

Pkg_ffcv_M_LAN_HOS.P_ATUALIZA_SN_FATURA_IMPRESS(xml, pREG_FAT, FSV_CURRENT_FIELD, FSV_FORM_STATUS, FSV_RECORD_STATUS);

if not pack_ffcv.Regra_Atendimento_Hosp( nCdRegFat =>  pREG_FAT.CD_REG_FAT,
                                                 nCdLcto =>  pITREG_FAT_REL.CD_LANCAMENTO,
                                                 cAction => 'E' ) then

  if not pack_ffcv.verif_acoplamento_hosp( nRegFat =>  pITREG_FAT_REL.CD_REG_FAT,
                                                   nCdLcto =>  pITREG_FAT_REL.CD_LANCAMENTO,
                                                   cAction => 'E' ) then

    pack_lanca_ffcv.Verif_Franquia_Hosp( nregfat   => pITREG_FAT_REL.CD_REG_FAT,
                                               ncdlcto   => pITREG_FAT_REL.CD_LANCAMENTO,
                                               cAction => 'E' ) ;
  end if ;
end if ; --

BEGIN
  --
  -- Begin ITLAN_MED_REL detail program section
  --
   DELETE FROM DBAMV.ITLAN_MED D
   WHERE D.CD_REG_FAT = pITREG_FAT_REL.CD_REG_FAT and D.CD_LANCAMENTO = pITREG_FAT_REL.CD_LANCAMENTO;
  --
  -- End ITLAN_MED_REL detail program section
  --
  --
  -- Begin ITCOB_PRE_REL detail program section
  --
   DELETE FROM DBAMV.ITCOB_PRE D
   WHERE D.CD_REG_FAT = pITREG_FAT_REL.CD_REG_FAT and D.CD_LANCAMENTO = pITREG_FAT_REL.CD_LANCAMENTO;
  --
  -- End ITCOB_PRE_REL detail program section
  --
END;
END P_B_PD_ITREG_FAT_REL_PRE;


PROCEDURE P_B_PD_ITREG_FAT_REL_PRE (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    pitreg_fat ITREG_FATRec;
    FSV_CURRENT_FIELD VARCHAR2(4000);
    FSV_FORM_STATUS VARCHAR2(4000);
    FSV_RECORD_STATUS VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO');
        pITREG_FAT_REL.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT');
        pITREG_FAT_REL.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO');
        pITREG_FAT_REL.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        pREG_FAT.DSP_DT_ATENDIMENTO:= PKG_XML.GetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO');
        pREG_FAT.DSP_HR_ATENDIMENTO:= PKG_XML.GetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO');
        pREG_FAT.SN_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FECHADA');
        pREG_FAT.SN_FATURA_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA');
        pREG_FAT.SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_FECHADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA');
        pREG_FAT.DSP_IMPRESSA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA');
        pREG_FAT.DSP_SN_CONTA_CALCULADA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA');
        pITREG_FAT.DT_LANCAMENTO:= PKG_XML.GetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO');
        pITREG_FAT.HR_LANCAMENTO:= PKG_XML.GetDate(xml, 'ITREG_FAT.HR_LANCAMENTO');
        FSV_CURRENT_FIELD:= PKG_XML.GetVARCHAR2(xml, 'FSV_CURRENT_FIELD');
        FSV_FORM_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_FORM_STATUS');
        FSV_RECORD_STATUS:= PKG_XML.GetVARCHAR2(xml, 'FSV_RECORD_STATUS');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_REL_PRE_E(xml) THEN
                P_B_PD_ITREG_FAT_REL_PRE(xml, pREG_FAT, pITREG_FAT_REL, pITREG_FAT, FSV_CURRENT_FIELD, FSV_FORM_STATUS, FSV_RECORD_STATUS);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_REL_PRE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO', pITREG_FAT_REL.CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT', pITREG_FAT_REL.CD_REG_FAT);
        PKG_XML.SetDATE(xml, 'ITREG_FAT_REL.DT_LANCAMENTO', pITREG_FAT_REL.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT_REL.HR_LANCAMENTO', pITREG_FAT_REL.HR_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        PKG_XML.SetDATE(xml, 'REG_FAT.DSP_DT_ATENDIMENTO', pREG_FAT.DSP_DT_ATENDIMENTO);
        PKG_XML.SetDate(xml, 'REG_FAT.DSP_HR_ATENDIMENTO', pREG_FAT.DSP_HR_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FECHADA', pREG_FAT.SN_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_FATURA_IMPRESSA', pREG_FAT.SN_FATURA_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.SN_CONTA_CALCULADA', pREG_FAT.SN_CONTA_CALCULADA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_FECHADA', pREG_FAT.DSP_FECHADA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_IMPRESSA', pREG_FAT.DSP_IMPRESSA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_CONTA_CALCULADA', pREG_FAT.DSP_SN_CONTA_CALCULADA);
        PKG_XML.SetDATE(xml, 'ITREG_FAT.DT_LANCAMENTO', pITREG_FAT.DT_LANCAMENTO);
        PKG_XML.SetDate(xml, 'ITREG_FAT.HR_LANCAMENTO', pITREG_FAT.HR_LANCAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'FSV_CURRENT_FIELD', FSV_CURRENT_FIELD);
        PKG_XML.SetVARCHAR2(xml, 'FSV_FORM_STATUS', FSV_FORM_STATUS);
        PKG_XML.SetVARCHAR2(xml, 'FSV_RECORD_STATUS', FSV_RECORD_STATUS);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_REL.POST-INSERT</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PI_ITREG_FAT_REL_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec, preg_fat IN OUT NOCOPY REG_FATRec) IS
BEGIN
-- OP 47539 ini
 DECLARE

  CURSOR C_RegraAtend(nCdRegFat IN NUMBER) IS
        SELECT regra_atendimento.cd_regra_atendimento
          FROM dbamv.regra_atendimento , dbamv.reg_fat
         WHERE regra_atendimento.cd_atendimento = reg_fat.cd_atendimento
           AND reg_fat.cd_reg_fat = nCdRegFat;

      CURSOR C_RegraAtendProFat(nCdRegFat IN NUMBER) IS
        SELECT regra_atendimento_pro_fat.cd_regra_atendimento_pro_fat
          FROM dbamv.regra_atendimento_pro_fat , dbamv.reg_fat
         WHERE regra_atendimento_pro_fat.cd_atendimento = reg_fat.cd_atendimento
           AND reg_fat.cd_reg_fat = nCdRegFat;

   vRegraAtend number;
 BEGIN
  OPEN   C_RegraAtend (pREG_FAT.CD_REG_FAT);
  FETCH  C_RegraAtend INTO vRegraAtend;
  CLOSE  C_RegraAtend;
  IF vRegraAtend IS NULL THEN
   OPEN   C_RegraAtendProFat (pREG_FAT.CD_REG_FAT);
   FETCH  C_RegraAtendProFat INTO vRegraAtend;
   CLOSE  C_RegraAtendProFat;
  END IF;


 if Nvl(  pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE, 0 ) <> 100  OR  vRegraAtend IS NOT null THEN
  if not pack_ffcv.Regra_Atendimento_Hosp( nCdRegFat =>  pREG_FAT.CD_REG_FAT,
                                                                                                nCdLcto   =>  pITREG_FAT_REL.CD_LANCAMENTO,
                                                                                                cAction   => 'I' ) then
      if not pack_ffcv.verif_acoplamento_hosp( nRegFat =>  pITREG_FAT_REL.CD_REG_FAT,
                                                                                                   nCdLcto =>  pITREG_FAT_REL.CD_LANCAMENTO,
                                                                                                   cAction =>'I' ) then
          pack_lanca_ffcv.Verif_Franquia_Hosp( nregfat    => pITREG_FAT_REL.CD_REG_FAT,
                                                                                               ncdlcto    => pITREG_FAT_REL.CD_LANCAMENTO,
                                                                                               cAction  => 'I' ) ;
    end if ;
  end if ;
 end if ;

END; -- Op 47539 fim

if  pITREG_FAT_REL.TP_PAGAMENTO = 'C' and  pITREG_FAT_REL.SN_PACIENTE_PAGA = 'S' then
  pITREG_FAT_REL.TP_PAGAMENTO := 'X' ;
end if ;
END P_B_PI_ITREG_FAT_REL_POST;


PROCEDURE P_B_PI_ITREG_FAT_REL_POST (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_rel ITREG_FAT_RELRec;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.VL_PERCENTUAL_PACIENTE');
        pITREG_FAT_REL.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO');
        pITREG_FAT_REL.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT');
        pITREG_FAT_REL.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO');
        pITREG_FAT_REL.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.SN_PACIENTE_PAGA');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PI_ITREG_FAT_REL_POST_E(xml) THEN
                P_B_PI_ITREG_FAT_REL_POST(xml, pITREG_FAT_REL, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PI_ITREG_FAT_REL_POST_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.VL_PERCENTUAL_PACIENTE', pITREG_FAT_REL.VL_PERCENTUAL_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO', pITREG_FAT_REL.CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT', pITREG_FAT_REL.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO', pITREG_FAT_REL.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.SN_PACIENTE_PAGA', pITREG_FAT_REL.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_REL.POST-UPDATE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PU_ITREG_FAT_REL (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec) IS
BEGIN

if not pack_ffcv.Regra_Atendimento_Hosp( nCdRegFat =>  pREG_FAT.CD_REG_FAT,
                                                                                             nCdLcto   =>  pITREG_FAT_REL.CD_LANCAMENTO,
                                                                                             cAction   => 'A' ) then
      if not pack_ffcv.verif_acoplamento_hosp( nRegFat =>  pITREG_FAT_REL.CD_REG_FAT,
                                                                                                   nCdLcto =>  pITREG_FAT_REL.CD_LANCAMENTO,
                                                                                                   cAction => 'A' ) then
      pack_lanca_ffcv.Verif_Franquia_Hosp( nregfat  => pITREG_FAT_REL.CD_REG_FAT,
                                                                                           ncdlcto  => pITREG_FAT_REL.CD_LANCAMENTO,
                                                                                           cAction  => 'A' ) ;
    end if ;
end if ;
if  pITREG_FAT_REL.TP_PAGAMENTO = 'C' and  pITREG_FAT_REL.SN_PACIENTE_PAGA = 'S' then
  pITREG_FAT_REL.TP_PAGAMENTO := 'X' ;
end if ;
END P_B_PU_ITREG_FAT_REL;


PROCEDURE P_B_PU_ITREG_FAT_REL (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_LANCAMENTO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO');
        pITREG_FAT_REL.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT');
        pITREG_FAT_REL.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO');
        pITREG_FAT_REL.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.SN_PACIENTE_PAGA');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PU_ITREG_FAT_REL_E(xml) THEN
                P_B_PU_ITREG_FAT_REL(xml, pREG_FAT, pITREG_FAT_REL);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PU_ITREG_FAT_REL_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_LANCAMENTO', pITREG_FAT_REL.CD_LANCAMENTO);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.CD_REG_FAT', pITREG_FAT_REL.CD_REG_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.TP_PAGAMENTO', pITREG_FAT_REL.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.SN_PACIENTE_PAGA', pITREG_FAT_REL.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_REL.POST-DELETE</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_PD_ITREG_FAT_REL_POST (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec) IS
BEGIN

begin
    delete from DBAMV.conta_pacote
    where cd_reg_fat = preg_fat.cd_reg_fat
      and Nvl(cd_conta_pacote,0) NOT in (select distinct Nvl(cd_conta_pacote,0)
                                    from DBAMV.itreg_fat
                                   where cd_reg_fat = preg_fat.cd_reg_fat);
end;
END P_B_PD_ITREG_FAT_REL_POST;


PROCEDURE P_B_PD_ITREG_FAT_REL_POST (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_REL_POST_E(xml) THEN
                P_B_PD_ITREG_FAT_REL_POST(xml, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_B_PD_ITREG_FAT_REL_POST_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITLAN_MED_REL.CD_PRESTADOR.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IMR_CD_PRESTADOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
 pcg$ctrl IN OUT NOCOPY CG$CTRLRec, pitlan_med2 IN OUT NOCOPY ITLAN_MED2Rec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

pITLAN_MED_REL.DSP_NM_PRESTADOR := Pkg_ffcv_M_LAN_HOS.F_CHECA_PRESTADOR(xml, pITLAN_MED_REL, pITLAN_MED2, formParams, pITLAN_MED_REL.CD_PRESTADOR
                                                      , true
                                                      , true
                                                      , 'ITLAN_MED_REL');

--
BEGIN

IF  pITLAN_MED_REL.DSP_TP_FUNCAO = 'A' AND
    pITLAN_MED_REL.DSP_SN_AUXILIAR = 'N' THEN /* Auxiliar */
   --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_42)
   PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_42', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Médico não cadastrado para esta Atividade!'), 'W', TRUE);
END IF;

IF  pITLAN_MED_REL.DSP_TP_FUNCAO = 'N' AND
    pITLAN_MED_REL.DSP_SN_ANESTESISTA = 'N' THEN /* Anestesista */
   --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_42)
   PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_42', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Médico não cadastrado para esta Atividade!'), 'W', TRUE);
END IF;

IF  pITLAN_MED_REL.DSP_TP_FUNCAO = 'C' AND
    pITLAN_MED_REL.DSP_SN_CIRURGIAO = 'N' THEN /* Cirurgiao */
   --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_42)
   PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_42', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Médico não cadastrado para esta Atividade!'), 'W', TRUE);
END IF;

IF  pITLAN_MED_REL.DSP_TP_FUNCAO = 'O' AND
    pITLAN_MED_REL.DSP_SN_OUTROS = 'N' THEN /* Outros */
   --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_42)
   PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_42', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Médico não cadastrado para esta Atividade!'), 'W', TRUE);
END IF;

END;
--
DECLARE
CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

  vProced cProced%ROWTYPE;
BEGIN

	OPEN cProced (pITREG_FAT_REL.CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

       pITLAN_MED_REL.TP_PAGAMENTO := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pITLAN_MED_REL.CD_PRESTADOR,
                                                                                       pREG_FAT.CD_CONVENIO,
                                                                                       pREG_FAT.DSP_TP_ATENDIMENTO,
                                                                                       pITREG_FAT_REL.CD_PRO_FAT,
                                                                                       pREG_FAT.DSP_CD_ORI_ATE, null, null,
																					   --FATURCONV-1726 INI
																						pREG_FAT.CD_CON_PLA,
																						pREG_FAT.CD_REGRA,
																						vProced.cd_gru_pro
																						--FATURCONV-1726 FIM
																					   );

  if  formParams.P_MIG_SN_PRESTADOR_DUPLICADO = 'N' then
    if Nvl( Instr(   pCG$CTRL.DSP_PREST_DIGITADO_REL, '*' || To_Char(  pITLAN_MED_REL.CD_PRESTADOR ) || '*' ), 0 ) > 0 then
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_53)
      PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_53', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Este prestador já foi informado nesta equipe !'), 'W', False) ;
    end if ;
  end if ;
END;
  pCG$CTRL.DSP_PREST_DIGITADO_REL := pCG$CTRL.DSP_PREST_DIGITADO_REL || '*' || To_Char( pITLAN_MED_REL.CD_PRESTADOR ) || '*';

Declare

  Cursor C_PrestProib is
    Select Count(1)
      From DBAMV.prest_gru_pro_proibido pgpp
     Where pgpp.cd_prestador = pITLAN_MED_REL.CD_PRESTADOR
       and pgpp.cd_gru_pro = pITREG_FAT_REL.DSP_CD_GRU_PRO ;

  nQuantosTem Number ;

Begin

  Open C_PrestProib ;
  Fetch C_PrestProib into nQuantosTem ;
  Close C_PrestProib ;

  if Nvl( nQuantosTem, 0 ) > 0 then
    --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_35)
    PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_35', 'PKG_FFCV_M_LAN_HOS', 'Atenção: Este prestador não está autorizado para procedimentos do grupo %s !', arg_list(To_Char( pITREG_FAT_REL.DSP_CD_GRU_PRO ))), 'W', True) ;
  end if ;

END;
END P_I_WVI_IMR_CD_PRESTADOR;


PROCEDURE P_I_WVI_IMR_CD_PRESTADOR (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitlan_med_rel ITLAN_MED_RELRec;
    preg_fat REG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    pcg$ctrl CG$CTRLRec;
    pitlan_med2 ITLAN_MED2Rec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT');
        pITREG_FAT_REL.DSP_CD_GRU_PRO:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_GRU_PRO');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
		--FATURCONV-1726 INI
		pREG_FAT.CD_CON_PLA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CON_PLA');
		pREG_FAT.CD_REGRA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REGRA');
		--FATURCONV-1726 FIM
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
        pITLAN_MED_REL.DSP_NM_PRESTADOR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_NM_PRESTADOR');
        pITLAN_MED_REL.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITLAN_MED_REL.CD_PRESTADOR');
        pITLAN_MED_REL.DSP_TP_FUNCAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_TP_FUNCAO');
        pITLAN_MED_REL.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR');
        pITLAN_MED_REL.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA');
        pITLAN_MED_REL.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO');
        pITLAN_MED_REL.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS');
        pITLAN_MED_REL.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.TP_PAGAMENTO');
        pCG$CTRL.DSP_PREST_DIGITADO_REL:= PKG_XML.GetVARCHAR2(xml, 'CG$CTRL.DSP_PREST_DIGITADO_REL');
        pITLAN_MED2.DSP_SN_CIRURGIAO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO');
        pITLAN_MED2.DSP_SN_AUXILIAR:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR');
        pITLAN_MED2.DSP_SN_ANESTESISTA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA');
        pITLAN_MED2.DSP_SN_OUTROS:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS');
        formParams.P_MIG_SN_PRESTADOR_DUPLICADO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PRESTADOR_DUPLICADO');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IMR_CD_PRESTADOR_E(xml) THEN
                P_I_WVI_IMR_CD_PRESTADOR(xml, pITLAN_MED_REL, pREG_FAT, pITREG_FAT_REL, pCG$CTRL, pITLAN_MED2, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IMR_CD_PRESTADOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT', pITREG_FAT_REL.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_REL.DSP_CD_GRU_PRO', pITREG_FAT_REL.DSP_CD_GRU_PRO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
		--FATURCONV-1726 INI
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CON_PLA', pREG_FAT.CD_CON_PLA);
		PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REGRA', pREG_FAT.CD_REGRA);
		--FATURCONV-1726 FIM
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_NM_PRESTADOR', pITLAN_MED_REL.DSP_NM_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'ITLAN_MED_REL.CD_PRESTADOR', pITLAN_MED_REL.CD_PRESTADOR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_TP_FUNCAO', pITLAN_MED_REL.DSP_TP_FUNCAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_AUXILIAR', pITLAN_MED_REL.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_ANESTESISTA', pITLAN_MED_REL.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_CIRURGIAO', pITLAN_MED_REL.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.DSP_SN_OUTROS', pITLAN_MED_REL.DSP_SN_OUTROS);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.TP_PAGAMENTO', pITLAN_MED_REL.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'CG$CTRL.DSP_PREST_DIGITADO_REL', pCG$CTRL.DSP_PREST_DIGITADO_REL);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_CIRURGIAO', pITLAN_MED2.DSP_SN_CIRURGIAO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_AUXILIAR', pITLAN_MED2.DSP_SN_AUXILIAR);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_ANESTESISTA', pITLAN_MED2.DSP_SN_ANESTESISTA);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED2.DSP_SN_OUTROS', pITLAN_MED2.DSP_SN_OUTROS);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_SN_PRESTADOR_DUPLICADO', formParams.P_MIG_SN_PRESTADOR_DUPLICADO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITLAN_MED_REL.TP_PAGAMENTO.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IMR_TP_PAGAMENTO (xml IN OUT NOCOPY PKG_XML.XmlContext,pitlan_med_rel IN OUT NOCOPY ITLAN_MED_RELRec, preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_rel IN OUT NOCOPY ITREG_FAT_RELRec,
 formParams IN OUT NOCOPY FormParamsRec, FSV_MODE IN OUT NOCOPY varchar2) IS
BEGIN

IF  FSV_MODE = 'QUERY' THEN
   RETURN;
END IF;

IF  pitlan_med_REL.tp_pagamento not in ('P', 'F', 'C', 'X') THEN
  --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_36)
  PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_36', 'PKG_FFCV_M_LAN_HOS', 'Erro: A forma de pagamento deve ser P - Produção ou C - Convênio ou F - Hospital ou X - Pago pelo Paciente.'), 'E', TRUE);
END IF;

DECLARE
  v_tpconv      convenio.tp_convenio%type;
  cTpPagamento char(1);
  CURSOR cProced(vCdProfat in varchar2) IS
	select 	cd_gru_pro
	from 	dbamv.pro_fat
	where 	cd_pro_fat = vCdProfat;

  vProced cProced%ROWTYPE;
BEGIN

	OPEN cProced (pITREG_FAT_REL.CD_PRO_FAT);
	FETCH cProced INTO vProced;
	CLOSE cProced;

    if not (  pITLAN_MED_REL.TP_PAGAMENTO = 'X' or  pITLAN_MED_REL.SN_PACIENTE_PAGA = 'S' ) then
          -- Consulta o tipo de Convênio
          M_PKG_FFCV_CONVENIO.P_RETORNA_CAMPO(xml, preg_fat.cd_convenio
                                            , formParams.P_MIG_CD_MULTI_EMPRESA
                                            , formParams.P_MIG_CD_USUARIO
                                            , false
                                            , false
                                            , 'TP_CONVENIO'
                                            , v_tpconv);

        if nvl(v_tpconv,'P')='P' then
             return;
        end if;

         IF  pITLAN_MED_REL.TP_PAGAMENTO IN ('P', 'F') THEN
          RETURN;
       END IF;

     cTpPagamento := dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(pITLAN_MED_REL.CD_PRESTADOR,
                                                                        pREG_FAT.CD_CONVENIO,
                                                                        pREG_FAT.DSP_TP_ATENDIMENTO,
                                                                        pITREG_FAT_REL.CD_PRO_FAT,
                                                                        pREG_FAT.DSP_CD_ORI_ATE, null, null,
																		--FATURCONV-1726 INI
																		pREG_FAT.CD_CON_PLA,
																		pREG_FAT.CD_REGRA,
																		vProced.cd_gru_pro
																		--FATURCONV-1726 FIM
																		);

       if  formParams.P_MIG_CD_HOSPITAL not in (444, 445, 446, 448, 449, 378, 427, 421) then
         IF cTpPagamento = 'P' AND  pITLAN_MED_REL.TP_PAGAMENTO = 'C' THEN
             --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_58)
             --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_73)
             PKG_XML_MGS.CHAMA_MENSAGEM(xml,
						   pkg_rmi_traducao.extrair_pkg_msg(
							   'MSG_58',
								 'PKG_FFCV_M_LAN_HOS', 'Erro'),
							 pkg_rmi_traducao.extrair_pkg_msg(
							   'MSG_73', 'PKG_FFCV_M_LAN_HOS',
								 'Erro..: Prestador não credenciado ou com exceção de credenciamento.%s..: Verificar o cadastro de credenciamento, no cadastro de prestadores', arg_list(CHR(10))), TRUE);
           pITLAN_MED_REL.TP_PAGAMENTO := cTpPagamento;
         END IF;
       end if;
    end if;

END;
END P_I_WVI_IMR_TP_PAGAMENTO;


PROCEDURE P_I_WVI_IMR_TP_PAGAMENTO (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitlan_med_rel ITLAN_MED_RELRec;
    preg_fat REG_FATRec;
    pitreg_fat_rel ITREG_FAT_RELRec;
    formParams FormParamsRec;
    FSV_MODE VARCHAR2(4000);

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_REL.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT');
        pREG_FAT.CD_CONVENIO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_CONVENIO');
        pREG_FAT.DSP_TP_ATENDIMENTO:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO');
        pREG_FAT.DSP_CD_ORI_ATE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE');
        pITLAN_MED_REL.TP_PAGAMENTO:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.TP_PAGAMENTO');
        pITLAN_MED_REL.SN_PACIENTE_PAGA:= PKG_XML.GetVARCHAR2(xml, 'ITLAN_MED_REL.SN_PACIENTE_PAGA');
        pITLAN_MED_REL.CD_PRESTADOR:= PKG_XML.GetNUMBER(xml, 'ITLAN_MED_REL.CD_PRESTADOR');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        formParams.P_MIG_CD_HOSPITAL:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL');
        FSV_MODE:= PKG_XML.GetVARCHAR2(xml, 'FSV_MODE');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IMR_TP_PAGAMENTO_E(xml) THEN
                P_I_WVI_IMR_TP_PAGAMENTO(xml, pITLAN_MED_REL, pREG_FAT, pITREG_FAT_REL, formParams, FSV_MODE);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IMR_TP_PAGAMENTO_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_REL.CD_PRO_FAT', pITREG_FAT_REL.CD_PRO_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_CONVENIO', pREG_FAT.CD_CONVENIO);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_TP_ATENDIMENTO', pREG_FAT.DSP_TP_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_ORI_ATE', pREG_FAT.DSP_CD_ORI_ATE);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.TP_PAGAMENTO', pITLAN_MED_REL.TP_PAGAMENTO);
        PKG_XML.SetVARCHAR2(xml, 'ITLAN_MED_REL.SN_PACIENTE_PAGA', pITLAN_MED_REL.SN_PACIENTE_PAGA);
        PKG_XML.SetNUMBER(xml, 'ITLAN_MED_REL.CD_PRESTADOR', pITLAN_MED_REL.CD_PRESTADOR);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_HOSPITAL', formParams.P_MIG_CD_HOSPITAL);
        PKG_XML.SetVARCHAR2(xml, 'FSV_MODE', FSV_MODE);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>TRANSF_CONTAS.CD_REG_FAT_DEST.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_TC_CD_REG_FAT_DEST (xml IN OUT NOCOPY PKG_XML.XmlContext,ptransf_contas IN OUT NOCOPY TRANSF_CONTASRec, preg_fat IN OUT NOCOPY REG_FATRec, global IN OUT NOCOPY GlobalsRec,
 formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

DECLARE

  VCD_CON_PLA   Number;
  V_TP_CONVENIO VARCHAR2(1);

  Cursor C Is
      Select convenio.tp_convenio,
             reg_fat.cd_con_pla,
             reg_fat.dt_inicio,
             reg_fat.dt_final,
             convenio.nm_convenio
        from DBAMV.convenio,
             DBAMV.reg_fat
       where reg_fat.cd_convenio  = convenio.cd_convenio
         AND REG_FAT.CD_MULTI_EMPRESA = formParams.P_MIG_CD_MULTI_EMPRESA
       and convenio.cd_convenio = pTRANSF_CONTAS.CD_CONVENIO_DEST
         and reg_fat.cd_reg_fat   = pTRANSF_CONTAS.CD_REG_FAT_DEST;

    Cursor C1 Is
         select carteira.cd_categoria_plano,
                carteira.sn_titular,
                carteira.sn_pensionista
         from DBAMV.carteira carteira
             ,DBAMV.con_pla con_pla
             ,DBAMV.categoria_plano
         ,empresa_con_pla
        where empresa_con_pla.cd_convenio = con_pla.cd_convenio
        and empresa_con_pla.cd_con_pla = con_pla.cd_con_pla
        and Empresa_Con_Pla.Cd_Multi_Empresa = formParams.P_MIG_CD_MULTI_EMPRESA
        and carteira.cd_paciente = pREG_FAT.DSP_CD_PACIENTE
         and   carteira.cd_convenio = pTRANSF_CONTAS.CD_CONVENIO_DEST
         and   carteira.cd_con_pla  = VCD_CON_PLA
         and   carteira.cd_con_pla  = con_pla.cd_con_pla
         and   carteira.cd_convenio = con_pla.cd_convenio
         and   carteira.cd_categoria_plano = categoria_plano.cd_categoria_plano (+) ;

  cursor c_conv is
   select cd_convenio
     from DBAMV.reg_fat
    where cd_reg_fat = pTRANSF_CONTAS.CD_REG_FAT_DEST
      AND REG_FAT.CD_MULTI_EMPRESA = formParams.P_MIG_CD_MULTI_EMPRESA;

  bExiste    boolean;
  v_convenio number;
BEGIN
    IF  pTRANSF_CONTAS.CD_REG_FAT_DEST IS NOT NULL THEN
        bExiste := M_PKG_FFCV_CONTA.F_EXISTE_CONTA_TRANSFEREN(xml, pREG_FAT.CD_ATENDIMENTO           -- pCd_Atendimento
                                                              , pTRANSF_CONTAS.CD_REG_FAT         -- pCd_Conta
                                                              , pTRANSF_CONTAS.CD_REG_FAT_DEST    -- pCd_Conta_Transferecia
                                                                                    , pTRANSF_CONTAS.DSP_DT_LANCAMENTO  -- pDt_Transferencia
                                                                                    , pTRANSF_CONTAS.CD_CONVENIO_DEST   -- pCd_Convenio
                                                                                    , formParams.P_MIG_CD_MULTI_EMPRESA -- pCd_Multi_Empresa
                                                                                    , formParams.P_MIG_CD_USUARIO       -- pCd_Usuario
                                                                                    , true                              -- pRaise
                                                                                    , true);

    open c_conv;
    fetch c_conv into   pTRANSF_CONTAS.CD_CONVENIO_DEST;
    close c_conv;

    END IF;

    OPEN C;
    FETCH C INTO V_TP_CONVENIO, VCD_CON_PLA,
                  pTRANSF_CONTAS.DT_INICIO_DEST,
                  pTRANSF_CONTAS.DT_FINAL_DEST,
                  pTRANSF_CONTAS.DSP_NM_CONVENIO_DEST;
    CLOSE C;



  IF V_TP_CONVENIO <> 'P' THEN

    Open C1;
    Fetch C1 Into  pREG_FAT.DSP_CD_CATEGORIA
                 , pREG_FAT.DSP_SN_TITULAR
                 , pREG_FAT.DSP_SN_PENSIONISTA;
    Close C1;
  ELSE
      pTRANSF_CONTAS.DSP_CD_CATEGORIA        := Null ;
      pTRANSF_CONTAS.DSP_SN_TITULAR          := 'S' ;
      pTRANSF_CONTAS.DSP_SN_PENSIONISTA      := 'S' ;
  END IF;

  global.Conta_Dest := pTRANSF_CONTAS.CD_REG_FAT_DEST;

END;
END P_I_WVI_TC_CD_REG_FAT_DEST;


PROCEDURE P_I_WVI_TC_CD_REG_FAT_DEST (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    ptransf_contas TRANSF_CONTASRec;
    preg_fat REG_FATRec;
    global GlobalsRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pREG_FAT.DSP_CD_PACIENTE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE');
        pREG_FAT.CD_ATENDIMENTO:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO');
        pREG_FAT.DSP_CD_CATEGORIA:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA');
        pREG_FAT.DSP_SN_TITULAR:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_TITULAR');
        pREG_FAT.DSP_SN_PENSIONISTA:= PKG_XML.GetVARCHAR2(xml, 'REG_FAT.DSP_SN_PENSIONISTA');
        pTRANSF_CONTAS.CD_CONVENIO_DEST:= PKG_XML.GetNUMBER(xml, 'TRANSF_CONTAS.CD_CONVENIO_DEST');
        pTRANSF_CONTAS.CD_REG_FAT_DEST:= PKG_XML.GetNUMBER(xml, 'TRANSF_CONTAS.CD_REG_FAT_DEST');
        pTRANSF_CONTAS.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'TRANSF_CONTAS.CD_REG_FAT');
        pTRANSF_CONTAS.DSP_DT_LANCAMENTO:= PKG_XML.GetDate(xml, 'TRANSF_CONTAS.DSP_DT_LANCAMENTO');
        pTRANSF_CONTAS.DT_INICIO_DEST:= PKG_XML.GetDATE(xml, 'TRANSF_CONTAS.DT_INICIO_DEST');
        pTRANSF_CONTAS.DT_FINAL_DEST:= PKG_XML.GetDATE(xml, 'TRANSF_CONTAS.DT_FINAL_DEST');
        pTRANSF_CONTAS.DSP_NM_CONVENIO_DEST:= PKG_XML.GetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_NM_CONVENIO_DEST');
        pTRANSF_CONTAS.DSP_CD_CATEGORIA:= PKG_XML.GetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_CATEGORIA');
        pTRANSF_CONTAS.DSP_SN_TITULAR:= PKG_XML.GetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_SN_TITULAR');
        pTRANSF_CONTAS.DSP_SN_PENSIONISTA:= PKG_XML.GetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_SN_PENSIONISTA');
        global.CONTA_DEST:= PKG_XML.GetVARCHAR2(xml, 'GLOBAL.CONTA_DEST');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_TC_CD_REG_FAT_DEST_E(xml) THEN
                P_I_WVI_TC_CD_REG_FAT_DEST(xml, pTRANSF_CONTAS, pREG_FAT, global, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_TC_CD_REG_FAT_DEST_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_PACIENTE', pREG_FAT.DSP_CD_PACIENTE);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_ATENDIMENTO', pREG_FAT.CD_ATENDIMENTO);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_CATEGORIA', pREG_FAT.DSP_CD_CATEGORIA);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_TITULAR', pREG_FAT.DSP_SN_TITULAR);
        PKG_XML.SetVARCHAR2(xml, 'REG_FAT.DSP_SN_PENSIONISTA', pREG_FAT.DSP_SN_PENSIONISTA);
        PKG_XML.SetNUMBER(xml, 'TRANSF_CONTAS.CD_CONVENIO_DEST', pTRANSF_CONTAS.CD_CONVENIO_DEST);
        PKG_XML.SetNUMBER(xml, 'TRANSF_CONTAS.CD_REG_FAT_DEST', pTRANSF_CONTAS.CD_REG_FAT_DEST);
        PKG_XML.SetNUMBER(xml, 'TRANSF_CONTAS.CD_REG_FAT', pTRANSF_CONTAS.CD_REG_FAT);
        PKG_XML.SetDate(xml, 'TRANSF_CONTAS.DSP_DT_LANCAMENTO', pTRANSF_CONTAS.DSP_DT_LANCAMENTO);
        PKG_XML.SetDATE(xml, 'TRANSF_CONTAS.DT_INICIO_DEST', pTRANSF_CONTAS.DT_INICIO_DEST);
        PKG_XML.SetDATE(xml, 'TRANSF_CONTAS.DT_FINAL_DEST', pTRANSF_CONTAS.DT_FINAL_DEST);
        PKG_XML.SetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_NM_CONVENIO_DEST', pTRANSF_CONTAS.DSP_NM_CONVENIO_DEST);
        PKG_XML.SetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_CD_CATEGORIA', pTRANSF_CONTAS.DSP_CD_CATEGORIA);
        PKG_XML.SetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_SN_TITULAR', pTRANSF_CONTAS.DSP_SN_TITULAR);
        PKG_XML.SetVARCHAR2(xml, 'TRANSF_CONTAS.DSP_SN_PENSIONISTA', pTRANSF_CONTAS.DSP_SN_PENSIONISTA);
        PKG_XML.SetVARCHAR2(xml, 'GLOBAL.CONTA_DEST', global.CONTA_DEST);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_LANC_PACOTE.CD_GRU_FAT.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IFLP_CD_GRU_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec, preg_fat IN OUT NOCOPY REG_FATRec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

declare
  bRegistroValido boolean;
BEGIN
  if  pITREG_FAT_LANC_PACOTE.CD_GRU_FAT is not null then
    pITREG_FAT_LANC_PACOTE.DSP_DS_GRU_FAT := M_PKG_FFCV_GRU_FAT.F_RETORNA_DESCRICAO(xml, pITREG_FAT_LANC_PACOTE.CD_GRU_FAT
                                                                                  , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                  , formParams.P_MIG_CD_USUARIO
                                                                                  , TRUE
                                                                                  , TRUE);


    bRegistroValido := M_PKG_FFCV_ITFOR_APRE.F_SN_GRU_FAT_CADASTRADO(xml, pREG_FAT.DSP_CD_FOR_APRE
                                                                   , pITREG_FAT_LANC_PACOTE.CD_GRU_FAT
                                                                   , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                   , formParams.P_MIG_CD_USUARIO
                                                                   , TRUE
                                                                   , TRUE);

  end if ;
END;
END P_I_WVI_IFLP_CD_GRU_FAT;


PROCEDURE P_I_WVI_IFLP_CD_GRU_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_lanc_pacote ITREG_FAT_LANC_PACOTERec;
    preg_fat REG_FATRec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_LANC_PACOTE.CD_GRU_FAT:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_GRU_FAT');
        pITREG_FAT_LANC_PACOTE.DSP_DS_GRU_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.DSP_DS_GRU_FAT');
        pREG_FAT.DSP_CD_FOR_APRE:= PKG_XML.GetNUMBER(xml, 'REG_FAT.DSP_CD_FOR_APRE');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFLP_CD_GRU_FAT_E(xml) THEN
                P_I_WVI_IFLP_CD_GRU_FAT(xml, pITREG_FAT_LANC_PACOTE, pREG_FAT, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFLP_CD_GRU_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_GRU_FAT', pITREG_FAT_LANC_PACOTE.CD_GRU_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.DSP_DS_GRU_FAT', pITREG_FAT_LANC_PACOTE.DSP_DS_GRU_FAT);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.DSP_CD_FOR_APRE', pREG_FAT.DSP_CD_FOR_APRE);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_LANC_PACOTE.CD_PRO_FAT.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IFLP_CD_PRO_FAT (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

BEGIN
  if  pITREG_FAT_LANC_PACOTE.CD_PRO_FAT is not null then
      -- Consulta descrio do procedimento
    M_PKG_FFCV_PRO_FAT.P_RETORNA_CAMPO(xml, pITREG_FAT_LANC_PACOTE.CD_PRO_FAT
                                     , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                       , formParams.P_MIG_CD_USUARIO
                                                                       , false
                                                                       , false
                                                                       , 'DS_PRO_FAT'
                                                                       , pITREG_FAT_LANC_PACOTE.DSP_DS_PRO_PCT);
  end if ;
END;
END P_I_WVI_IFLP_CD_PRO_FAT;


PROCEDURE P_I_WVI_IFLP_CD_PRO_FAT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_lanc_pacote ITREG_FAT_LANC_PACOTERec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_LANC_PACOTE.CD_PRO_FAT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.CD_PRO_FAT');
        pITREG_FAT_LANC_PACOTE.DSP_DS_PRO_PCT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.DSP_DS_PRO_PCT');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFLP_CD_PRO_FAT_E(xml) THEN
                P_I_WVI_IFLP_CD_PRO_FAT(xml, pITREG_FAT_LANC_PACOTE, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFLP_CD_PRO_FAT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.CD_PRO_FAT', pITREG_FAT_LANC_PACOTE.CD_PRO_FAT);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.DSP_DS_PRO_PCT', pITREG_FAT_LANC_PACOTE.DSP_DS_PRO_PCT);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_LANC_PACOTE.CD_SETOR.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IFLP_CD_SETOR (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec, formParams IN OUT NOCOPY FormParamsRec) IS
BEGIN

BEGIN
  pITREG_FAT_LANC_PACOTE.DSP_NM_SETOR_PRO_PCT := M_PKG_GLOBAL_SETOR.F_RETORNA_DESCRICAO(xml, pITREG_FAT_LANC_PACOTE.CD_SETOR
                                                                                                                                        , formParams.P_MIG_CD_MULTI_EMPRESA
                                                                                                                                                                          , formParams.P_MIG_CD_USUARIO
                                                                                                                                                                          , TRUE
                                                                                                                                                                          , TRUE);

END;
END P_I_WVI_IFLP_CD_SETOR;


PROCEDURE P_I_WVI_IFLP_CD_SETOR (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_lanc_pacote ITREG_FAT_LANC_PACOTERec;
    formParams FormParamsRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_LANC_PACOTE.DSP_NM_SETOR_PRO_PCT:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.DSP_NM_SETOR_PRO_PCT');
        pITREG_FAT_LANC_PACOTE.CD_SETOR:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_SETOR');
        formParams.P_MIG_CD_MULTI_EMPRESA:= PKG_XML.GetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA');
        formParams.P_MIG_CD_USUARIO:= PKG_XML.GetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFLP_CD_SETOR_E(xml) THEN
                P_I_WVI_IFLP_CD_SETOR(xml, pITREG_FAT_LANC_PACOTE, formParams);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFLP_CD_SETOR_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.DSP_NM_SETOR_PRO_PCT', pITREG_FAT_LANC_PACOTE.DSP_NM_SETOR_PRO_PCT);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_SETOR', pITREG_FAT_LANC_PACOTE.CD_SETOR);
        PKG_XML.SetNUMBER(xml, 'PARAMETER.P_MIG_CD_MULTI_EMPRESA', formParams.P_MIG_CD_MULTI_EMPRESA);
        PKG_XML.SetVARCHAR2(xml, 'PARAMETER.P_MIG_CD_USUARIO', formParams.P_MIG_CD_USUARIO);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_LANC_PACOTE.SN_PERTENCE_PACOTE.WHEN-CHECKBOX-CHANGED</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WCC_IFLP_SN_PERTENCE_PAC (xml IN OUT NOCOPY PKG_XML.XmlContext,preg_fat IN OUT NOCOPY REG_FATRec, pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec) IS
BEGIN

Declare

  Cursor C_PertPcte is
    SELECT CONTA_PACOTE.CD_CONTA_PACOTE
     FROM DBAMV.CONTA_PACOTE
    WHERE CONTA_PACOTE.CD_REG_FAT = pREG_FAT.CD_REG_FAT
      AND CONTA_PACOTE.SN_PRINCIPAL = 'S';


  Cursor C_Pcte is
    SELECT PACOTE.CD_PACOTE
     FROM DBAMV.PACOTE
    WHERE sn_protocolo_de_pacote='N';

  nCdContaPacote Number ;

Begin

  if  pitreg_fat_lanc_pacote.sn_pertence_pacote = 'S' then

     Open C_PertPcte;
     Fetch C_PertPcte into nCdContaPacote;
     Close C_PertPcte ;

     if nCdContaPacote is null then

        Open C_Pcte;
        Fetch C_Pcte into nCdContaPacote;
        Close C_Pcte ;

        if nCdContaPacote is not null then

             --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_54)
             PKG_XML_MGS.MSG_ALERT(xml,
						    pkg_rmi_traducao.extrair_pkg_msg(
								  'MSG_54',
									'PKG_FFCV_M_LAN_HOS', 'O Hospital trabalha com regras de pacote pré-definidas, e a conta ainda não possui pacotes vinculados. Item não pode ser associado a pacote, pois é necessário, primeiro, gerar algum pacote.'),'i',true);

        end if;

        pitreg_fat_lanc_pacote.cd_conta_pacote := null;

     else

        pitreg_fat_lanc_pacote.cd_conta_pacote := nCdContaPacote;

     end if;

  end if ;

end ;
END P_I_WCC_IFLP_SN_PERTENCE_PAC;


PROCEDURE P_I_WCC_IFLP_SN_PERTENCE_PAC (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    preg_fat REG_FATRec;
    pitreg_fat_lanc_pacote ITREG_FAT_LANC_PACOTERec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_LANC_PACOTE.SN_PERTENCE_PACOTE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.SN_PERTENCE_PACOTE');
        pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WCC_IFLP_SN_PERTENCE_PAC_E(xml) THEN
                P_I_WCC_IFLP_SN_PERTENCE_PAC(xml, pREG_FAT, pITREG_FAT_LANC_PACOTE);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WCC_IFLP_SN_PERTENCE_PAC_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.SN_PERTENCE_PACOTE', pITREG_FAT_LANC_PACOTE.SN_PERTENCE_PACOTE);
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE', pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);

END;



    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE.WHEN-VALIDATE-ITEM</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_I_WVI_IFLP_CD_CONTA_PACOTE (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec, preg_fat IN OUT NOCOPY REG_FATRec) IS
BEGIN

declare
    cursor cContaPacote is
      SELECT CONTA_PACOTE.cd_CONTA_PACOTE
      FROM DBAMV.CONTA_PACOTE
      WHERE CONTA_PACOTE.CD_CONTA_PACOTE = pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE
        AND CONTA_PACOTE.CD_REG_FAT = pREG_FAT.CD_REG_FAT;
  bLocalizouRegistro boolean;
BEGIN
  if  pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE is not null then
      open  cContaPacote;
      fetch cContaPacote into  pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE;
      bLocalizouRegistro := cContaPacote%found;
      close cContaPacote;

      if not bLocalizouRegistro then
      pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE := Null ;
      --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_55)
      PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_55', 'PKG_FFCV_M_LAN_HOS', 'Código inexistente! Pacote ainda não vinculado a conta.'),'e',true);
      end if ;
  end if;
END;
END P_I_WVI_IFLP_CD_CONTA_PACOTE;


PROCEDURE P_I_WVI_IFLP_CD_CONTA_PACOTE (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_lanc_pacote ITREG_FAT_LANC_PACOTERec;
    preg_fat REG_FATRec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE');
        pREG_FAT.CD_REG_FAT:= PKG_XML.GetNUMBER(xml, 'REG_FAT.CD_REG_FAT');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFLP_CD_CONTA_PACOTE_E(xml) THEN
                P_I_WVI_IFLP_CD_CONTA_PACOTE(xml, pITREG_FAT_LANC_PACOTE, pREG_FAT);
                Pkg_ffcv_M_LAN_HOS_C.P_I_WVI_IFLP_CD_CONTA_PACOTE_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE', pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE);
        PKG_XML.SetNUMBER(xml, 'REG_FAT.CD_REG_FAT', pREG_FAT.CD_REG_FAT);
        out_params := PKG_XML.GetOutputClob(xml);

END;
    /*
    <DATA_CRIACAO>13/06/2010 00:03</DATA_CRIACAO>
    <CRIADO_POR>Ferramenta de Migrao ATX</CRIADO_POR>
    <OBJETIVO>ITREG_FAT_LANC_PACOTE.WHEN-VALIDATE-RECORD</OBJETIVO>
    <ALTERACOES></ALTERACOES>
    */
	PROCEDURE P_B_WVR_ITREG_FAT_LANC_PACOT (xml IN OUT NOCOPY PKG_XML.XmlContext,pitreg_fat_lanc_pacote IN OUT NOCOPY ITREG_FAT_LANC_PACOTERec) IS
BEGIN

Declare
     Cursor C_Pcte is
       SELECT PACOTE.CD_PACOTE
         FROM DBAMV.PACOTE
        WHERE sn_protocolo_de_pacote='N';

     nCdContaPacote Number ;

    Begin

     Open C_Pcte;
     Fetch C_Pcte into nCdContaPacote;
     Close C_Pcte ;

        if nCdContaPacote is not null then

             if  pitreg_fat_lanc_pacote.cd_conta_pacote is null and  pitreg_fat_lanc_pacote.sn_pertence_pacote = 'S' then

             --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_56)
             PKG_XML_MGS.MSG_ALERT(xml,
						 pkg_rmi_traducao.extrair_pkg_msg(
						 'MSG_56', 'PKG_FFCV_M_LAN_HOS',
						 'O Hospital trabalha com regras de pacote pré-definidas, e a conta ainda não possui pacotes vinculados. Item não pode ser associado a pacote, sem que o pacote seja informado.'),'i',true);

           end if;

             if  pitreg_fat_lanc_pacote.cd_conta_pacote is not null and  pitreg_fat_lanc_pacote.sn_pertence_pacote = 'N' then

             --MULTI-IDIOMA: Utilizao do pkg_rmi_traducao.extrair_msg para mensagens (MSG_57)
             PKG_XML_MGS.MSG_ALERT(xml, pkg_rmi_traducao.extrair_pkg_msg('MSG_57', 'PKG_FFCV_M_LAN_HOS', 'O item não pode estar associado a um pacote, já que o mesmo não está incluso no pacote.'),'i',true);

           end if;

        end if;

     end;
END P_B_WVR_ITREG_FAT_LANC_PACOT;


PROCEDURE P_B_WVR_ITREG_FAT_LANC_PACOT (in_params in Clob, out_params out Clob) IS
    xml PKG_XML.XmlContext;
    pitreg_fat_lanc_pacote ITREG_FAT_LANC_PACOTERec;

BEGIN
        xml := PKG_XML.Init(in_params);
        -- extract input parameters from the XML
        pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE:= PKG_XML.GetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE');
        pITREG_FAT_LANC_PACOTE.SN_PERTENCE_PACOTE:= PKG_XML.GetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.SN_PERTENCE_PACOTE');
        BEGIN
            IF Pkg_ffcv_M_LAN_HOS_C.P_B_WVR_ITREG_FAT_LANC_PACOT_E(xml) THEN
                P_B_WVR_ITREG_FAT_LANC_PACOT(xml, pITREG_FAT_LANC_PACOTE);
                Pkg_ffcv_M_LAN_HOS_C.P_B_WVR_ITREG_FAT_LANC_PACOT_S(xml);
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            PKG_XML.AddException(xml, SQLCODE, SQLERRM);
        END;
        -- save output parameters to the XML
        PKG_XML.SetNUMBER(xml, 'ITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE', pITREG_FAT_LANC_PACOTE.CD_CONTA_PACOTE);
        PKG_XML.SetVARCHAR2(xml, 'ITREG_FAT_LANC_PACOTE.SN_PERTENCE_PACOTE', pITREG_FAT_LANC_PACOTE.SN_PERTENCE_PACOTE);
        out_params := PKG_XML.GetOutputClob(xml);

END;

END Pkg_ffcv_M_LAN_HOS;