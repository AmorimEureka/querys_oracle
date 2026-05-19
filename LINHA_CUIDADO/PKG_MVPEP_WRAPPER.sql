CREATE OR REPLACE PACKAGE BODY DBAMV.PKG_MVPEP_WRAPPER IS
   --
   Procedure prc_pagu_copia_presc_padrao( rCursor   in out TypCur_Ref_Cursor
                                        , piPre_Pad in     number
                                        , rCodeErro in out number
                                        , rTextErro in out varchar2 ) IS
   Begin
     dbamv.prc_pagu_copia_presc_padrao(piPre_Pad/*, rCodeErro, rTextErro*/);
     OPEN rCursor FOR SELECT rCodeErro, rTextErro FROM dual;
   End;
   --
   Procedure prc_pish_audita_atend_produto( rCursor      in out TypCur_Ref_Cursor,
                                           piAtend             Integer,
                                           piCd_Produto        Integer,
                                           pDt_Pre_Med         Date,
                                           pHr_Pre_Med         Date,
                                           vAcao        in out Varchar2,
                                           vMensagem    in out Varchar2 ) IS
   Begin
     Dbamv.prc_pish_audita_atend_produto( piAtend,piCd_Produto,pDt_Pre_Med,pHr_Pre_Med,vAcao,vMensagem );
     OPEN rCursor FOR SELECT vAcao,vMensagem FROM dual;
   End;
   --
   Procedure prc_psih_retorna_pre_pad(rCursor OUT TypCur_Ref_Cursor
                                     ,pncd_atendimento in  dbamv.atendime.cd_atendimento%type
								     ,pncd_pre_pad     out dbamv.pre_pad.cd_pre_pad%type
								     ,pMensagem        out varchar2) is
   Begin
     Dbamv.prc_psih_retorna_pre_pad(pncd_atendimento,pncd_pre_pad,pMensagem);
     OPEN rCursor FOR SELECT pncd_pre_pad,pMensagem FROM dual;
   End;
   --
   Procedure PRC_MVPEP_COPIAR_PRESCRICAO( rCursor OUT TypCur_Ref_Cursor
                                         ,PDATA_BASE         IN DATE := NULL
                                         , VALORES            VARCHAR2
                                         , PIPRE_DES          NUMBER
                                         , PDPRE_INI          DATE
                                         , PDPRE_VAL          DATE
                                         , PTP_PRE_MED        IN VARCHAR2
                                         , PCD_ATENDIMENTO    IN NUMBER
                                         , PDT_REFERENCIA     IN DATE
                                         , P_MENSAGEM_RETORNO OUT VARCHAR2
                                         , P_SISTEMA          IN VARCHAR2 := 'PAGU'
                                         , PCD_USUARIO        IN VARCHAR2
                                         , PCD_SETOR          IN NUMBER ) IS
   Begin
     Dbamv.PRC_MVPEP_COPIAR_PRESCRICAO( PDATA_BASE, VALORES, PIPRE_DES, PDPRE_INI, PDPRE_VAL, PTP_PRE_MED
                                        , PCD_ATENDIMENTO, PDT_REFERENCIA, P_MENSAGEM_RETORNO
                                        , P_SISTEMA, PCD_USUARIO, PCD_SETOR);
     OPEN rCursor FOR SELECT P_MENSAGEM_RETORNO FROM dual;
   End;
   --
   Function busca_set_exa( pUnid_Int Number
                          ,pSetor        Number
                          ,PCd_Tip_Presc Number
                          ,pDh_Solic     Date   := Sysdate
                          ,pCd_Tip_Esq   Varchar2 := Null
                          ,pCd_Exa_Rx    Number := Null
                          ,pCd_Exa_Lab   Number := Null ) Return TypCur_Ref_Cursor IS
     --
     rCursor TypCur_Ref_Cursor;
     nRetorno  Number;
     --
   Begin
     nRetorno := dbamv.busca_set_exa( pUnid_Int,pSetor,PCd_Tip_Presc,pDh_Solic,pCd_Tip_Esq,pCd_Exa_Rx,pCd_Exa_Lab);
     OPEN rCursor  FOR SELECT nRetorno FROM dual;
     Return rCursor;
   End;
   --
   Function fnc_mvpep_confirmar_diagnost( pCd_Atendimento In Number
                                         , pCd_Paciente In Number
                                         , pCd_CID In Varchar2
                                         , pTp_Sexo In Varchar2
                                         , pCd_Tip_Res In Number
                                         , pDt_Alta In Date
                                         , pHr_Alta In Date
                                         , pTp_Tempo_Doenca In Varchar2
                                         , pNr_Tempo_Doenca In Number
                                         , pTp_Doenca In Varchar2
                                         , pCd_Setor_Obito In Number
                                         , pSn_Obito In Varchar2
                                         , pNrDeclaracaoObito In Varchar2
                                         , pCd_Prestador In Number
                                         , pCd_Convenio In Number
                                         , pDs_Atendimento In Varchar2
                                         , pDs_Obs_Alta In Varchar2
                                         , pSn_Flag_Alta In Out Varchar2
                                         , pDsp_Mensagem In Out Varchar2 ) Return TypCur_Ref_Cursor Is
     --
     rCursor TypCur_Ref_Cursor;
     vRetorno Integer;
     --
   Begin
     vRetorno := Dbamv.fnc_mvpep_confirmar_diagnost( pCd_Atendimento, pCd_Paciente, pCd_CID, pTp_Sexo, pCd_Tip_Res
                                                     , pDt_Alta, pHr_Alta, pTp_Tempo_Doenca, pNr_Tempo_Doenca
                                                     , pTp_Doenca, pCd_Setor_Obito, pSn_Obito,pNrDeclaracaoObito, pCd_Prestador, pCd_Convenio
                                                     , pDs_Atendimento, pDs_Obs_Alta, pSn_Flag_Alta, pDsp_Mensagem);
     OPEN rCursor FOR SELECT vRetorno,pSn_Flag_Alta,pDsp_Mensagem FROM dual;
     Return rCursor;
   End;
   --
   Function  fnc_pagu_criar_prescricao(pCd_Atendimento In Number
                                     , pTp_Acao_Tela In Varchar2
                                     , pDt_Prescricao In Date Default Null
                                     , pCd_Setor In Number Default Null
                                     , pTp_Objeto In Varchar2 Default Null
                                     , pCd_Setor_Maquina in Number default Null
									 , pCd_Objeto In Number Default Null
                                     , pCd_Unid_Int In Number Default Null
									 , pdh_pre_med In Date Default Null
                   , pDh_Validade In Date Default Null -- OP 39982
                   ) Return TypCur_Ref_Cursor Is
     --
     rCursor TypCur_Ref_Cursor;
     vCd_Pre_Med     Dbamv.Pre_Med.Cd_Pre_Med%Type;
     --
   Begin
     vCd_Pre_Med := Dbamv.fnc_pagu_criar_prescricao(pCd_Atendimento, pTp_Acao_Tela, pDt_Prescricao
                                                   , pCd_Setor, pTp_Objeto, pCd_Setor_Maquina, pCd_Objeto, pCd_Unid_Int, pdh_pre_med, pDh_Validade); -- OP 39982
     OPEN rCursor FOR SELECT  vCd_Pre_Med FROM dual;
     Return rCursor;
   End;
   --
   Function  fnc_mvpep_criar_prescricao(pCd_Atendimento In Number
                                     , pTp_Acao_Tela In Varchar2
                                     , pDt_Prescricao In Date Default Null
                                     , pCd_Setor In Number Default Null
                                     , pTp_Objeto In Varchar2 Default Null
                                     , pCd_Setor_Maquina in Number default Null
									                   , pCd_Objeto In Number Default Null
                                     , pCd_Unid_Int In Number Default Null
									                   , pdh_pre_med In Date Default Null
                                     , pDh_Validade In Date Default Null -- OP 39982
                   ) Return TypCur_Ref_Cursor Is
     --
     rCursor TypCur_Ref_Cursor;
     vCd_Pre_Med     Dbamv.Pre_Med.Cd_Pre_Med%Type;
     --
   Begin
     vCd_Pre_Med := Dbamv.fnc_mvpep_criar_prescricao(pCd_Atendimento, pTp_Acao_Tela, pDt_Prescricao
                                                   , pCd_Setor, pTp_Objeto, pCd_Setor_Maquina, pCd_Objeto, pCd_Unid_Int, pdh_pre_med, pDh_Validade); -- OP 39982
     OPEN rCursor FOR SELECT  vCd_Pre_Med FROM dual;
     Return rCursor;
   End;
   --
   Function  Fnc_MVSacr_Recupera_Triagem( pnCdAtendimento Number ) Return TypCur_Ref_Cursor Is
     --
     rCursor TypCur_Ref_Cursor;
     nRetorno Number;
     --
   Begin
     nRetorno := Dbamv.Fnc_MVSacr_Recupera_Triagem( pnCdAtendimento);
     OPEN rCursor FOR SELECT nRetorno FROM dual;
     Return rCursor;
   End;
   --
   Function fnc_pagu_grava_horario (p_cd_itpre_med NUMBER
                                   ,pitpre_copia NUMBER
                                   ,pDh_Inicial DATE DEFAULT NULL
                                   ,pDh_Final DATE DEFAULT NULL
                                   ,pVerificaConfigCriacaoHorarios VARCHAR2 DEFAULT 'N'
                                   ) Return TypCur_Ref_Cursor Is
     --
     rCursor TypCur_Ref_Cursor;
     nRetFunc         Integer;
     --pitpre_copia     Number := Null;
     pinsere          Boolean := True;
     pdia             Date := Null;
     prespelho        pkg_pagu_itpremed.typrec_espelho  := pkg_pagu_itpremed.fn_espelho;
     verificaConfigCriacaoHorarios Boolean := (pVerificaConfigCriacaoHorarios = 'S');
     --
   Begin
     nRetFunc := Dbamv.fnc_pagu_grava_horario(p_cd_itpre_med,pitpre_copia,pinsere,pdia,prespelho,pDh_Inicial,pDh_Final,verificaConfigCriacaoHorarios);
     OPEN rCursor FOR SELECT nRetFunc  FROM dual;
     Return rCursor;
   End;
   --
   Function f_proibicao(p_cd_con_pla         IN      NUMBER
                        , p_cd_convenio      IN      NUMBER
                        , p_cd_pro_fat       IN      VARCHAR2
                        , p_tp_proibicao     OUT     VARCHAR2
                        , p_tp_atendimento   IN      VARCHAR2
                        , p_dt_referencia    IN      DATE ) RETURN TypCur_Ref_Cursor IS
     --
     rCursor TypCur_Ref_Cursor;
     vRetFunc          VARCHAR2(1000);
     p_cd_setor        NUMBER := NULL;
     p_empresa         NUMBER := NULL;
     ncdatendimento    NUMBER := NULL;
     nqtdlanc          NUMBER := NULL;
     --
   Begin
     vRetFunc := DBAMV.PACK_FFCV.f_proibicao(p_cd_con_pla, p_cd_convenio, p_cd_pro_fat, p_tp_proibicao, p_tp_atendimento
                                            ,p_dt_referencia ,p_cd_setor ,p_empresa ,ncdatendimento ,nqtdlanc );
     OPEN rCursor FOR SELECT vRetFunc,p_tp_proibicao  FROM dual;
     Return rCursor;
   End;
   --
   Function Fnc_mvpainel_verifica_penden( pCdAtendimento Number ) Return TypCur_Ref_Cursor is
     --
     rCursor TypCur_Ref_Cursor;
     vRetorno VARCHAR(09);
     --
   Begin
     vRetorno := Dbamv.Fnc_mvpainel_verifica_penden( pCdAtendimento );
     OPEN rCursor FOR SELECT vRetorno FROM dual;
     Return rCursor;
   End;
   --
   Function fnc_pagu_retorna_dsunidade( pncd_tip_presc    number
                                        ,pnCd_uni_presc    number
                                        ,pnCd_Uni_Pro      number
                                        ,pnCd_Unidade      varchar2
                                        ,pnCd_Itpre_med    number
                                        ,pvTp_Item varchar2) Return TypCur_Ref_Cursor is
               --
     rCursor TypCur_Ref_Cursor;
     vRetorno VARCHAR2(50);
               --
   Begin
    vRetorno := Dbamv.fnc_pagu_retorna_dsunidade( pncd_tip_presc, pnCd_uni_presc, pnCd_Uni_Pro, pnCd_Unidade, pnCd_Itpre_med, pvTp_Item );
    OPEN rCursor FOR SELECT vRetorno FROM dual;
    Return rCursor;
   End;
   --
   FUNCTION FNC_MVPEP_GERA_SOLICITACAO ( pnCdPreMed      in dbamv.pre_med.cd_pre_med%type,
                                            pnCdSolicAtd    in dbamv.solic_atd.cd_solic_atd%type,
                                            pnCdAtendimento in dbamv.atendime.cd_atendimento%type,
                                            pnCdPrestador   in dbamv.prestador.cd_prestador%type,
                                            pvTpObjeto      in dbamv.pagu_objeto.tp_objeto%type,
                                            --
                                            pvMsg           out varchar2,
                                            --
                                            pvReserva       in varchar2) return TypCur_Ref_Cursor is
    --
	Cursor CconvenioTiss_Atd is
        Select cd_convenio
        From dbamv.atendime
        Where cd_atendimento  = pnCdAtendimento;

    --
    vCdConvenio NUMBER;
    rCursor TypCur_Ref_Cursor;
    vResult varchar2(2000);
	vReserva VARCHAR2(200);
    vReturnMsg VARCHAR2(4000);
    --
    begin
    --

    IF pnCdAtendimento IS NOT NULL THEN
       vReserva := pnCdAtendimento;
    END IF;

    IF pnCdPrestador IS NOT NULL THEN
       vReserva := vReserva || '#' || pnCdPrestador;
    END IF;

    IF pvTpObjeto IS NOT NULL THEN
       vReserva := vReserva || '#' || pvTpObjeto;
    END IF;

    IF pnCdAtendimento IS NOT NULL AND pnCdPrestador IS NULL AND pvTpObjeto IS NULL THEN
      vReserva := vReserva || '#';
    END IF;

	Open  CconvenioTiss_Atd;
    Fetch CconvenioTiss_Atd into vCdConvenio;
    Close CconvenioTiss_Atd;

    vResult := dbamv.fnc_ffcv_gera_tiss  (vCdConvenio
                                        ,'F_GERA_GUIA_SOLIC'
                                        ,pnCdAtendimento
                                        ,null
                                        ,null
                                        ,pnCdPrestador --E4
                                        ,pnCdPreMed
                                        ,null
                                        ,'INTERNACAO'
                                        ,null
                                        ,pnCdSolicAtd
                                        ,vReturnMsg
                                        ,vReserva);

     OPEN rCursor FOR SELECT vResult, vReturnMsg  FROM dual;
     Return rCursor;
     --
   END FNC_MVPEP_GERA_SOLICITACAO;
  --
FUNCTION FNC_MVPEP_GERA_SOLIC_QUIMIO ( pnCdPreMed      in dbamv.pre_med.cd_pre_med%type,
                                       pnCdAtendimento in dbamv.atendime.cd_atendimento%type) return TypCur_Ref_Cursor is

  Cursor CconvenioTiss_Atd is
      Select cd_convenio
      From dbamv.atendime
      Where cd_atendimento  = pnCdAtendimento;

  CURSOR cGuiaTiss(ID_GUIA NUMBER) IS
   SELECT NR_GUIA
     FROM DBAMV.TISS_SOL_GUIA
    WHERE ID = ID_GUIA;

  CURSOR cRecuperaGuia IS
  SELECT G.CD_GUIA
    FROM DBAMV.GUIA G
   WHERE G.CD_PRE_MED = pnCdPreMed
     AND G.CD_ATENDIMENTO = pnCdAtendimento;
  --

  CURSOR CverificaGuia(ID_GUIA NUMBER) IS
    SELECT NR_GUIA FROM DBAMV.GUIA
     WHERE GUIA.CD_GUIA = ID_GUIA;

  vCdGuia NUMBER;
  vCdConvenio NUMBER;
  vIdTiss NUMBER;
  vNrGuiaTiss NUMBER;
  rCursor TypCur_Ref_Cursor;
  vResult varchar2(2000);
  vReturnMsg VARCHAR2(4000);
  vNrGuia NUMBER;
  --
  BEGIN
  --
  Open  CconvenioTiss_Atd;
  Fetch CconvenioTiss_Atd into vCdConvenio;
  Close CconvenioTiss_Atd;

  Open  cRecuperaGuia;
  Fetch cRecuperaGuia into vCdGuia;
  Close cRecuperaGuia;

  -- Validação para não ficar regerando a tiss.
  OPEN  CverificaGuia(vCdGuia);
  FETCH CverificaGuia INTO vNrGuia;
  CLOSE CverificaGuia;

  IF vNrGuia IS NOT NULL THEN
    vCdGuia := NULL;
  END IF;

  vResult := dbamv.fnc_ffcv_gera_tiss  (vCdConvenio                    -- Convenio
                                      ,'F_ctm_anexoSolicitacaoQuimio'  -- Func?o
                                      ,NULL
                                      ,1738                            -- 1738 'F_ctm_anexoSolicitacaoQuimio'
                                      ,pnCdAtendimento                 -- Atendimento
                                      ,pnCdPreMed                      -- Prescricao
                                      ,vCdGuia                         -- Tratamento (Nulo)
                                      ,NULL                            -- Ciclo (Nulo)
                                      ,NULL                            -- Sess?o (Nulo)
                                      ,NULL                            -- guia
                                      ,NULL
                                      ,vReturnMsg
                                      ,NULL);

    IF vResult IS NOT NULL AND vReturnMsg IS NULL  THEN

      vIdTiss := TO_NUMBER( SubStr(vResult,0,Length(vResult) - 1) );

      Open  cGuiaTiss(vIdTiss);
      Fetch cGuiaTiss into vNrGuiaTiss;
      Close cGuiaTiss;

      IF vNrGuiaTiss IS NOT NULL THEN
        UPDATE DBAMV.GUIA
           SET nr_guia = vNrGuiaTiss
         WHERE cd_guia = vCdGuia;
      END IF;
    END IF;

   OPEN rCursor FOR SELECT vResult, vReturnMsg  FROM dual;

   Return rCursor;

   --

END FNC_MVPEP_GERA_SOLIC_QUIMIO;
  --
  FUNCTION FNC_MVPEP_GERA_SOLIC_CONSULT ( pnCdAtendime IN dbamv.atendime.cd_atendimento%type,
                                            pnTpAtendimento in dbamv.atendime.tp_atendimento%type,
                                            pvMsg           out varchar2,
                                            pvReserva       in varchar2) return TypCur_Ref_Cursor is
    --
    cursor Cconveniotiss_Atd is
      select r.Cd_Reg_Amb  Cd_Conta
            ,i.Cd_Convenio Cd_Convenio
        from Dbamv.Reg_Amb   r
            ,Dbamv.Itreg_Amb i
            ,Dbamv.Convenio  c
       where r.Cd_Reg_Amb = i.Cd_Reg_Amb
         and i.Cd_Convenio = c.Cd_Convenio
         and c.Tp_Convenio = 'C'
         and i.Cd_Atendimento = Pncdatendime;
    Vresult     varchar2(2000);
    Rcursor     Typcur_Ref_Cursor;
    Vmsgerro    varchar2(2000);
    Vcdconvenio number;
    Vcdconta    number;
    --
  begin
    --
    open Cconveniotiss_Atd;
    fetch Cconveniotiss_Atd
      into Vcdconta
          ,Vcdconvenio;
    close Cconveniotiss_Atd;
    begin
      --
      Dbamv.Pack_Ffcv.Valores_Conta_Ambula(Vcdconta
                                          ,Vmsgerro
                                          ,Pncdatendime);
      --
    end;
    --Raise_Application_Error(-20999,'vCdConvenio -> ' || vCdConvenio || ' | pnTpAtendimento -> ' || pnTpAtendimento || ' | pnCdAtendime -> ' || pnCdAtendime);
    Vresult := Dbamv.Fnc_Ffcv_Gera_Tiss(Vcdconvenio --código do convenio
                                       ,'FNC_GERA_TISS' --Nome da Função, que no PEP é a SOLIC
                                       ,'A' --Tipo de atendimento
                                       ,Pncdatendime --Atendimento
                                       ,Vcdconta --Numero da conta (se tiver)
                                       ,'G' --Parâmetro que significa G=Gerar
                                       ,null --Parâmetro 5 nulo
                                       ,null --Parâmetro 6 nulo
                                       ,null --Parâmetro 7 nulo
                                       ,null --Parâmetro 8 nulo
                                       ,null --Parâmetro 9 nulo
                                       ,Pvmsg --retorno da função
                                       ,null);
    open Rcursor for
      select Vresult
            ,Pvmsg
        from Dual;
    return Rcursor;
    --
  END FNC_MVPEP_GERA_SOLIC_CONSULT;
  --
  FUNCTION FNC_MVPEP_GERA_SOLIC_PRO ( pnCdPreMed      in dbamv.pre_med.cd_pre_med%type,
                                            pnCdSolicAtd    in dbamv.solic_atd.cd_solic_atd%type,
                                            pnCdAtendimento in dbamv.atendime.cd_atendimento%type,
                                            pnCdPrestador   in dbamv.prestador.cd_prestador%type,
                                            pvTpObjeto      in dbamv.pagu_objeto.tp_objeto%type,
                                            --
                                            pvMsg           out varchar2,
                                            --
                                            pvReserva       in varchar2) return TypCur_Ref_Cursor is
    --
	Cursor CconvenioTiss_Atd is
        Select cd_convenio
        From dbamv.atendime
        Where cd_atendimento  = pnCdAtendimento;

    --
    vCdConvenio NUMBER;
    rCursor TypCur_Ref_Cursor;
    vResult varchar2(2000);
	vReserva VARCHAR2(200);
    vReturnMsg VARCHAR2(4000);
    --
    begin
    --

    IF pnCdAtendimento IS NOT NULL THEN
       vReserva := pnCdAtendimento;
    END IF;

    IF pnCdPrestador IS NOT NULL THEN
       vReserva := vReserva || '#' || pnCdPrestador;
    END IF;

    IF pvTpObjeto IS NOT NULL THEN
       vReserva := vReserva || '#' || pvTpObjeto;
    END IF;

    IF pnCdAtendimento IS NOT NULL AND pnCdPrestador IS NULL AND pvTpObjeto IS NULL THEN
      vReserva := vReserva || '#';
    END IF;

	Open  CconvenioTiss_Atd;
    Fetch CconvenioTiss_Atd into vCdConvenio;
    Close CconvenioTiss_Atd;

    vResult := dbamv.fnc_ffcv_gera_tiss  (vCdConvenio
                                        ,'F_GERA_GUIA_SOLIC'
                                        ,pnCdAtendimento
                                        ,pnCdPrestador --:E4
                                        ,null
                                        ,null
                                        ,pnCdPreMed
                                        ,null
                                        ,'PRORROGACAO'
                                        ,null
                                        ,pnCdSolicAtd
                                        ,vReturnMsg
                                        ,vReserva);

     OPEN rCursor FOR SELECT vResult, vReturnMsg  FROM dual;
     Return rCursor;
     --
   END FNC_MVPEP_GERA_SOLIC_PRO;
   --
   FUNCTION FNC_MVPEP_APAGA_TISS ( pvTpConta         in varchar2,
                                  pnAtendimento     in number,
                                  pnConta           in number,
                                  pvReserva         in varchar2,
                                  pvMsgErro         out varchar2) return TypCur_Ref_Cursor is
    --
    rCursor TypCur_Ref_Cursor;
    vResult varchar2(2000);
    --
    begin
    --
    vResult := dbamv.pkg_ffcv_tiss_pii.fnc_apaga_tiss( pvTpConta,
                                                     pnAtendimento,
                                                     pnConta,
                                                     pvReserva,
                                                     pvMsgErro);
     OPEN rCursor FOR SELECT vResult, pvMsgErro  FROM dual;
     Return rCursor;
   END FNC_MVPEP_APAGA_TISS;
   --
   Function fnc_gera_solic ( pnCdPreMed    in dbamv.pre_med.cd_pre_med%type,
                             pnCdSolicAtd  in dbamv.solic_atd.cd_solic_atd%type,
                             pvMsg         out varchar2,
                             pvReserva     in varchar2) return TypCur_Ref_Cursor is
     --
     rCursor TypCur_Ref_Cursor;
     vRetFunc varchar2(2000);
     --
   Begin
     vRetFunc := DBAMV.PKG_FFCV_TISS_PII.fnc_gera_solic( pnCdPreMed,pnCdSolicAtd,pvMsg,pvReserva);
     OPEN rCursor FOR SELECT vRetFunc,pvMsg  FROM dual;
     Return rCursor;
   End;
   --
   Function FNC_PAGU_CALCULA_INFUSAO( pRetorno   Varchar2 := 'QTD'
                                    ,pTip_Presc Number
                                    ,pQtd       Number
                                    ,pUni_Pro   Number
                                    ,PUni_Inf   Number
                                    ,pTp_Tempo  Varchar2
                                    ,pFreq      Integer := Null
                                    ,pQt_Inf    Number  := Null ) Return TypCur_Ref_Cursor is
     --
     rCursor TypCur_Ref_Cursor;
     nRetorno NUMBER(04);
     --
   Begin
     nRetorno := Dbamv.FNC_PAGU_CALCULA_INFUSAO( pRetorno ,pTip_Presc ,pQtd ,pUni_Pro ,PUni_Inf
                                                            ,pTp_Tempo ,pFreq ,pQt_Inf );
     OPEN rCursor FOR SELECT nRetorno FROM dual;
     Return rCursor;
   End;
   --
   Function  FNC_PAGU_SETOR_ATENDIMENTO( pnCdAtendimento Number, pvTpAtendimento Varchar2 ) Return TypCur_Ref_Cursor Is
     --
     rCursor TypCur_Ref_Cursor;
     nRetorno Number;
     --
   Begin
     nRetorno := Dbamv.FNC_PAGU_SETOR_ATENDIMENTO(pnCdAtendimento, pvTpAtendimento);
     OPEN rCursor FOR SELECT nRetorno FROM dual;
     Return rCursor;
   End;
   --
   Function fnc_mvpep_valor_uso_antimicrob(pcd_produto  in number,
                                           pcd_atendimento in number,
                                            pdt_pre_med     in date ) return TypCur_Ref_Cursor is
     --
     rCursor TypCur_Ref_Cursor;
     vRetorno Integer;
     --
   Begin
     vRetorno := Dbamv.fnc_mvpep_valor_uso_antimicrob(pcd_produto,pcd_atendimento,
                                          pdt_pre_med );
     OPEN rCursor FOR SELECT vRetorno FROM dual;
     Return rCursor;
   End;
   --
   Function fnc_traduz_proc( pvTipo          in varchar2,
                             pnCdAtendimento in dbamv.atendime.cd_atendimento%type,
  	                         pnCdConta       in dbamv.itreg_fat.cd_reg_fat%type,
                             pnCdLancamento  in dbamv.itreg_fat.cd_lancamento%type,
 	                         pnCdConvenio    in dbamv.convenio.cd_convenio%type,
 	                         pvTpAtend       in dbamv.atendime.tp_atendimento%type,
 	                         pvProFat        in dbamv.pro_fat.cd_pro_fat%type,
                             pnCdSetor		in dbamv.setor.cd_setor%type,
                       	     pvReserva       in varchar2) return TypCur_Ref_Cursor Is
     --
     rCursor TypCur_Ref_Cursor;
     vResult varchar2(500);
     pMsg VARCHAR2(32000);
     --
   Begin
     vResult := dbamv.fnc_ffcv_gera_tiss ( pnCdConvenio
											,'FNC_TRADUZ_PROC'
											, pvTipo -- C / D / T (código, descrição, tabela tiss)
											, pnCdAtendimento -- atendimento ¿ 1 opção de parametros
											, pnCdConta -- conta in varchar2
											, pnCdLancamento -- cd_lancamento in varchar2
											, pnCdConvenio -- convenio ¿ 2 opção de parametros
											, pvTpAtend -- tp_atend in varchar2
											, pvProFat -- pro_fat in varchar2
											, pnCdSetor -- setor in varchar2
											, null -- null in varchar2
											, pMsg
											, null
											);
     OPEN rCursor FOR SELECT vResult FROM dual;
     Return rCursor;
   End;
   --
   Function FNC_PAGU_VALIDA_TIPPRESC_NOVA ( piAtend Integer
                                           ,pdReferencia Date
                                           ,piTip_Presc  Integer
                                           ,piItPre_Med  Integer
                                           ,piPre_Med Integer := NULL ) Return TypCur_Ref_Cursor is
     --
     rCursor TypCur_Ref_Cursor;
     oRetorno     DBAMV.Typ_Itpremed_Espelho_Obj;
	 --
   Begin
     oRetorno := Dbamv.FNC_PAGU_VALIDA_TIPPRESC_NOVA ( piAtend ,pdReferencia ,piTip_Presc
                                                      ,piItPre_Med, piPre_Med);
     OPEN rCursor FOR SELECT
                     oretorno.Cd_ItPre_Med
                    ,oRetorno.Cd_Pre_Med
                    ,oRetorno.Cd_Tip_Presc
                    ,oRetorno.Cd_Tip_Fre
                    ,oRetorno.Cd_Tip_Fre_Det
                    ,oRetorno.Dh_Inicial
                    ,oRetorno.Hr_Inicial
                    ,oRetorno.Dh_Final
                    ,oRetorno.Sn_Cancelado
                    ,oRetorno.Tp_Situacao
                    ,oRetorno.Sn_Urgente
                    ,oRetorno.Cd_Prestador
                    ,oRetorno.Qt_ItPre_Med
                    ,oRetorno.Qt_Infusao
                    ,oRetorno.Cd_Uni_Pro
                    ,oRetorno.Cd_Unidade
                    ,oRetorno.Cd_Uni_Pro_Inf
                    ,oRetorno.Tp_Tempo
                    ,oRetorno.Cd_Set_Exa
                    ,oRetorno.Cd_For_Apl
                    ,oRetorno.Nr_Dia
                    ,oRetorno.Qt_Dias
                    ,oRetorno.Ds_NPadronizado
                    ,oRetorno.Cd_NPadronizado
                    ,oRetorno.Ds_ItPre_Med
                    ,oRetorno.Cd_itpre_Med_Justificativa
                    ,oRetorno.Ds_Justificativa
                    ,oRetorno.Tp_Justificativa
                    ,oRetorno.Tp_Det_Justificativa
                    ,oRetorno.Cd_ItPre_Med_Canc
                    ,oRetorno.Cd_Prest_Canc
                    ,oRetorno.Dh_Cancelado
                    ,oRetorno.Cd_ItPre_Pad
                    ,oRetorno.Sn_Justificativa
                    ,oRetorno.Sn_Solicita
                    ,oRetorno.Qt_ItPre_Med_Calculado
                    ,oRetorno.cd_uni_presc
                    ,oRetorno.cd_uni_presc_inf
                    ,oRetorno.Cd_Formula
                    ,oRetorno.Hr_Duracao FROM dual;
     Return rCursor;
   End;
   --
   Function fnc_pagu_unidade_prescricao(pnCdTipPresc in number
                                       ,pnCdProduto  in number) return TypCur_Ref_Cursor is
     --
     rCursor TypCur_Ref_Cursor;
     vRetorno varchar(10);
     --
   Begin
     vRetorno := Dbamv.fnc_pagu_unidade_prescricao(pnCdTipPresc, pnCdProduto);
     OPEN rCursor FOR SELECT vRetorno FROM dual;
     Return rCursor;
   End;
   --
   Function fnc_conf ( pvOpcao      in varchar2,
                       pnCdConv     in number,
                       PvReserva    in varchar2) return  TypCur_Ref_Cursor is
     --
     rCursor TypCur_Ref_Cursor;
     vRetorno  varchar2(200);
     --
   Begin
     vRetorno := Dbamv.PKG_FFCV_TISS_PII.fnc_conf ( pvOpcao,pnCdConv,PvReserva );
     OPEN rCursor FOR SELECT vRetorno FROM dual;
     Return rCursor;
   End;
   --
   Procedure Insere( pCd_Impressao   Number
                    ,pTitulo         Varchar2
                    ,pNm_Relatorio   Varchar2
                    ,pNm_Usuario     Varchar2
                    ,pDestino        Varchar2
                    ,pSolicitante    Varchar2
                    ,pTp_Acao        Varchar2 ) IS
     pDt_Solicitacao Date := SYSDATE;
     pDt_Impressao   Date;
   Begin
     Dbamv.PKG$IMPRESSAO.insere(pCd_Impressao,pTitulo,pNm_Relatorio,pNm_Usuario,pDestino,pSolicitante ,pDt_Solicitacao,pDt_Impressao,pTp_Acao);
   End;

   Procedure InsereNoCentralizador( pCd_Impressao   Number
                                  ,pTitulo         Varchar2
                                  ,pNm_Relatorio   Varchar2
                                  ,pNm_Usuario     Varchar2
                                  ,pDestino        Varchar2
                                  ,pSolicitante    Varchar2
                                  ,pTp_Acao        VARCHAR2
                                  ,pArrayNmParametro Dbamv.TypeMvpepTabVarchar
                                  ,pArrayDsValor Dbamv.TypeMvpepTabVarchar ) Is
      pDt_Solicitacao Date := SYSDATE;
      pDt_Impressao   Date;
   Begin
      Dbamv.PKG$IMPRESSAO.insere(pCd_Impressao,pTitulo,pNm_Relatorio,pNm_Usuario,pDestino,pSolicitante ,pDt_Solicitacao,pDt_Impressao,pTp_Acao);

      For i in 1..pArrayNmParametro.last Loop
        DBAMV.PKG$IMPRESSAO.PARAMETRO(null, pArrayNmParametro(i), pArrayDsValor(i));
      End Loop;

      DBAMV.PKG$IMPRESSAO.GRAVAR();
   End;

   --
   Function Fnc_Retorna_Documentos( pnCdPreMed   IN NUMBER
                                   ,pnCdItPreMed IN NUMBER
                                   ,pdData       IN DATE
								   ,pTpEditor IN varchar2 DEFAULT 'OCX'
								   ,pCdPrestador IN NUMBER DEFAULT NULL , pCdTipPresc IN NUMBER DEFAULT NULL) Return TypTabDoc PIPELINED
                                   is TabDoc  Dbamv.Pkg_Pagu_Documento.TypTabDocObrig;
   Begin
	 --
	 DBAMV.PRC_RETORNA_DOCUMENTOS(PNCDPREMED, PNCDITPREMED, PDDATA, TabDoc, pTpEditor, pCdTipPresc, pCdPrestador);
	 --
	 For I In 1..nvl(TabDoc.Last,0) Loop
	   Pipe Row(TabDoc(I));
	 End Loop;
	 Return;
   End;
   --
   Procedure Prc_Retorna_Documentos(rCursor OUT TypCur_Ref_Cursor
                          ,pnCdPreMed   IN NUMBER
                          ,pnCdItPreMed IN NUMBER
                          ,pdData       IN DATE
						  ,pTpEditor IN varchar2 DEFAULT 'OCX'
						  ,pCdPrestador IN NUMBER DEFAULT NULL , pCdTipPresc IN NUMBER DEFAULT NULL) Is
   cdTipPresc NUMBER;
   BEGIN
   cdTipPresc :=  pCdTipPresc;
   IF cdTipPresc IS NOT NULL AND cdTipPresc = 0 then
     cdTipPresc := NULL;
   END IF;
	  OPEN rCursor FOR SELECT tp_forma_preenchimento, sn_obrigatorio, cd_documento, ds_documento, cd_itpre_med , sn_valida_componente, cd_tip_presc
						FROM TABLE(Fnc_Retorna_Documentos( pnCdPreMed,pnCdItPreMed,pdData,pTpEditor,pCdPrestador , cdTipPresc )) dual;
   End;

   Function fnc_psih_verif_vigil_restrita(vncd_paciente dbamv.paciente.cd_paciente%type,
										  pCdAtendimento dbamv.atendime.cd_atendimento%TYPE DEFAULT NULL,
										  pTpAtendimento dbamv.atendime.tp_atendimento%TYPE DEFAULT NULL) return TypCur_Ref_Cursor is
		vRetorno varchar2(2000);
		rCursor TypCur_Ref_Cursor;
		Begin
		vRetorno := Dbamv.fnc_psih_verif_vigil_restrita(vncd_paciente, pCdAtendimento, pTpAtendimento);
		OPEN rCursor FOR SELECT vRetorno FROM dual;
		Return rCursor;
		End;

   Function fnc_psih_verifica_vigilancia(vncd_paciente dbamv.paciente.cd_paciente%type) return TypCur_Ref_Cursor is
		vRetorno varchar2(2000);
		rCursor TypCur_Ref_Cursor;
		Begin
		vRetorno := Dbamv.fnc_psih_verifica_vigilancia(vncd_paciente);
		OPEN rCursor FOR SELECT vRetorno FROM dual;
		Return rCursor;
		End;
    Function Fnc_Mv_Parametro_Default( pvModulo Varchar2, pvParametro Varchar2, pvValor_ParamModulo Varchar2 := Null ) return TypCur_Ref_Cursor is
      vRetorno varchar2(2000);
      rCursor TypCur_Ref_Cursor;
     Begin
      vRetorno := DBASGU.Fnc_Mv_Parametro_Default(pvModulo,pvParametro,pvValor_ParamModulo);
      OPEN rCursor FOR SELECT vRetorno FROM dual;
      Return rCursor;
     End;
procedure prc_pagu_copia_itpresc_padrao( rCursor   in out TypCur_Ref_Cursor
                                         , pCd_Pre_Med IN Number
                                         , pLstitPre_Pad in VarChar2
                                         , rCodeErro in out number
                                         , rTextErro in out varchar2
										 , pValidaTipoPrescricao in Varchar2 := 'S' ) IS
      -- Dados do Item Atual a ser Copiado
      Cursor cItens_Pre_Pad(pCd_itPre_Pad number) is
          Select CD_itPre_Pad
            , To_Number(null) CD_Tip_Presc
          From Dbamv.itpre_pad
          Where CD_itPre_Pad = pCd_itPre_Pad;
      -- Dados da Prescrição
      CURSOR cPre_Med(pCd_Pre_Med number) IS
          SELECT Cd_Pre_Med
                , Cd_Atendimento
                , Dt_Referencia
                , Cd_Prestador
                , Cd_Unid_Int
                , Cd_Setor
                , To_Date(To_Char(dt_pre_med,'dd/mm/yyyy')||' '||To_char(hr_pre_med,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') Dh_Pre_Med
                , dt_validade Dh_Validade
                , Tp_Pre_Med
                , Fl_Principal
                , Nm_Usuario
                , Sn_Transcricao
                , Fl_Impresso
                , Cd_Pre_Pad
                , Cd_Objeto
            FROM Dbamv.Pre_Med
            Where Cd_Pre_Med = pCd_Pre_Med;
      -- Codigo da Prescrição Padrão
      CURSOR cCd_Pre_Pad(pCd_itPre_Pad number) IS
          Select itpre_pad.Cd_Pre_pad
               , pre_pad.cd_protocolo
            From Dbamv.itPre_Pad
               , Dbamv.Pre_Pad
           Where pre_pad.cd_pre_pad = itpre_pad.cd_pre_pad
             AND cd_itPre_Pad = pCd_itPre_Pad;

       -- MRVS INCIO
       Cursor CpremedObjeto is
           Select Tp_objeto
             From Dbamv.Pagu_objeto ,
                  Dbamv.Pre_med
            Where Pre_med.cd_objeto =  Pagu_objeto.cd_objeto
              And Pre_Med.Cd_pre_med  = pCd_Pre_Med;
       --
        Cursor C_ItprePad (pCd_itPre_Pad number) is
         Select tip_esq.sn_exa_rx,tip_esq.sn_exa_lab
           from dbamv.itpre_pad
               ,dbamv.tip_esq
         where itpre_pad.cd_tip_esq = tip_esq.cd_tip_esq
           And itpre_pad.cd_itpre_pad = pCd_itPre_Pad;
        --
        CURSOR C_CITPREPAD (pCdItprePad Number)IS
          SELECT CITPRE_PAD.CD_ITPRE_PAD
               , CITPRE_PAD.CD_TIP_PRESC
            FROM DBAMV.CITPRE_PAD
           WHERE CITPRE_PAD.CD_ITPRE_PAD = pCdItprePad;
       -- MRVS FIM
       --
      vText VARCHAR2(32000) := pLstitPre_Pad;
      vItem VARCHAR2(32000)    := '';
      vPosProximoSeparador  NUMBER := 0;
      vDs_Mensagem          VarChar2(10000);
      vCd_Pre_Med           Dbamv.pre_med.cd_pre_med%TYPE;
      vCd_Pre_Pad           Dbamv.pre_pad.cd_pre_pad%TYPE;
      vCd_Protocolo         Dbamv.pre_pad.CD_PROTOCOLO%TYPE;
      vCd_itPre_Pad         Dbamv.itpre_pad.cd_itpre_pad%TYPE;
      rItPresc_Copia        Pkg_pagu_itpremed.TypRec_Copia;
      rpPre_Med             Pkg_Pagu_ItPreMed.TypRec_PreMed;
      vTp_objeto            Dbamv.pagu_objeto.tp_objeto%TYPE;
      vSn_exa_rx            Dbamv.Tip_esq.sn_exa_rx%TYPE;
      vSn_exa_lab           Dbamv.Tip_esq.sn_exa_lab%TYPE;
      vCount                NUMBER :=0;
      --
  	  Type TypRec_Copia_Comp Is Record(
                  Cd_tip_presc    Dbamv.CItPre_Pad.Cd_tip_presc%TYPE
                , Cd_ItPre_Pad    Dbamv.Itpre_Pad.Cd_ItPre_Pad%TYPE
      );
      --
      Type TypTab_Copia_Comp Is Table Of TypRec_Copia_Comp Index By Binary_Integer;
      --
      tCItpre_pad     TypTab_Copia_Comp;
	    vComponente VARCHAR2(32000) := '';
	    vSeparadorItemComp  NUMBER  := 0;
      indece number := 0;

  Begin

      --Carregando os Dados da Prescrição
      vCd_Pre_Med   := pCd_Pre_Med;
      for regPre_Med in cPre_Med(vCd_Pre_Med) loop
          rpPre_Med.Cd_Pre_Med     := RegPre_Med.Cd_Pre_Med;
          rpPre_Med.Cd_Atendimento := RegPre_Med.Cd_Atendimento;
          rpPre_Med.Dt_Referencia  := RegPre_Med.Dt_Referencia;
          rpPre_Med.Cd_Prestador   := RegPre_Med.Cd_Prestador;
          rpPre_Med.Cd_Unid_Int    := RegPre_Med.Cd_Unid_Int;
          rpPre_Med.Cd_Setor       := RegPre_Med.Cd_Setor;
          rpPre_Med.Dh_Pre_Med     := RegPre_Med.Dh_Pre_Med;
          rpPre_Med.Dh_Validade    := RegPre_Med.Dh_Validade;
          rpPre_Med.Tp_Pre_Med     := RegPre_Med.Tp_Pre_Med;
          rpPre_Med.Fl_Principal   := RegPre_Med.Fl_Principal;
          rpPre_Med.Nm_Usuario     := RegPre_Med.Nm_Usuario;
          rpPre_Med.Sn_Transcricao := RegPre_Med.Sn_Transcricao;
          rpPre_Med.Fl_Impresso    := RegPre_Med.Fl_Impresso;
          rpPre_Med.Cd_Pre_Pad     := RegPre_Med.Cd_Pre_Pad;
          rpPre_Med.Cd_Objeto      := RegPre_Med.Cd_Objeto;

          dbamv.pkg_pagu_itpremed.Pr_PreMed(rpPre_Med);
      end loop;
      -- Loop dos Itens
      LOOP

        vPosProximoSeparador := InStr(vtext,';');

        SELECT SubStr(vText,0,vPosProximoSeparador - 1 ) INTO vItem FROM  Dual;

        IF vItem IS NULL THEN
            vItem := vText;
        END IF;

        SELECT SubStr(vText,vPosProximoSeparador + 1 ) INTO vText FROM  Dual;

        vSeparadorItemComp := InStr(vItem,'|');

	      if vSeparadorItemComp > 0 Then
         --
         vComponente  := substr( vItem, vSeparadorItemComp+1 );
         vItem := substr( vItem, 1, vSeparadorItemComp-1 );
         --
         loop
           --
           vSeparadorItemComp := InStr(vComponente,'|');
           if Nvl(vSeparadorItemComp,0) > 0 Then
             --
             indece := indece + 1;
             tCItpre_pad( indece ).Cd_tip_presc := substr( vComponente, 1, vSeparadorItemComp-1 );
             tCItpre_pad( indece ).Cd_ItPre_Pad := vItem;
             vComponente := substr( vComponente, vSeparadorItemComp+1 );
             --
           else
             exit;
           end if;
           --
         end loop;
         --
         indece := 0;
        end if;

        -- Atibuições
        vCd_itPre_Pad := To_NUMBER(vItem);

        OPEN cCd_Pre_Pad(vCd_itPre_Pad);
            FETCH cCd_Pre_Pad INTO vCd_Pre_Pad, vCd_Protocolo;
        CLOSE cCd_Pre_Pad;

        dbamv.pkg_pagu_itpremed.atribui_prescricao_padrao(vCd_Pre_Pad);

        -- Carregando os dados dos Itens a ser Copiados
        for regItens_Pre_Pad in cItens_Pre_Pad(vCd_itPre_Pad) loop
          Open CpremedObjeto;
          Fetch CpremedObjeto into vTp_objeto;
          Close CpremedObjeto;

          Open C_ItprePad(vCd_itPre_Pad);
          Fetch C_ItprePad into vSn_exa_rx,vSn_exa_lab;
          Close C_ItprePad;

            rItpresc_Copia.cd_itpre_copia   := regItens_Pre_Pad.cd_itpre_pad;
            rItpresc_Copia.cd_tip_presc     := regItens_Pre_Pad.cd_tip_presc;
            rItpresc_Copia.sn_marcado       := 'S';

            If pValidaTipoPrescricao = 'S' Then
			  If vTp_objeto = 'SOLIMA' and vSn_exa_rx = 'S' Then
				  dbamv.pkg_pagu_itpremed.Itpresc_Copia_Insert(rItpresc_Copia);
				  vCount := vCount+1;
			  Else
				    dbamv.pkg_pagu_itpremed.Itpresc_Copia_Delete;
				    If  vTp_objeto = 'SOLLAB' and vSn_exa_lab = 'S' Then
					    dbamv.pkg_pagu_itpremed.Itpresc_Copia_Insert(rItpresc_Copia);
					    vCount := vCount+1;
				    Else
					    dbamv.pkg_pagu_itpremed.Itpresc_Copia_Delete;
					    If vSn_exa_rx = 'N' and vSn_exa_lab = 'N' and  vTp_objeto not in  ('SOLIMA','SOLLAB')  Then
						    dbamv.pkg_pagu_itpremed.Itpresc_Copia_Insert(rItpresc_Copia);
						    vCount := vCount+1;
					    Else
						    dbamv.pkg_pagu_itpremed.Itpresc_Copia_Delete;
					    End  if;
				    End if;
			    End if;
		    Else
			    dbamv.pkg_pagu_itpremed.Itpresc_Copia_Insert(rItpresc_Copia);
                vCount := vCount+1;
		    End if;

			IF tCItpre_pad.first IS NOT NULL THEN
			  FOR rCitprePad IN C_CITPREPAD(vCd_itPre_Pad) LOOP
				rItpresc_Copia.cd_itpre_copia   := rCitprePad.cd_itpre_pad;
				rItpresc_Copia.cd_tip_presc     := rCitprePad.cd_tip_presc;
				rItpresc_Copia.sn_marcado       := 'N';
				  FOR f IN tCItpre_pad.first..tCItpre_pad.last loop
					IF (tCItpre_pad(f).Cd_Tip_Presc = rCitprePad.cd_tip_presc) THEN
					  rItpresc_Copia.sn_marcado       := 'S';
					END IF;
				  END LOOP;
				dbamv.pkg_pagu_itpremed.Itpresc_Copia_Insert(rItpresc_Copia);
			  END LOOP;
			ELSIF (vCd_Protocolo IS NULL) THEN
			  FOR rCitprePad IN C_CITPREPAD(vCd_itPre_Pad) LOOP
				rItpresc_Copia.cd_itpre_copia   := rCitprePad.cd_itpre_pad;
				rItpresc_Copia.cd_tip_presc     := rCitprePad.cd_tip_presc;
				rItpresc_Copia.sn_marcado       := 'N';
				dbamv.pkg_pagu_itpremed.Itpresc_Copia_Insert(rItpresc_Copia);
			  END LOOP;
			END IF;

		-- MRVS FIM
        end loop;

        -- Executando a Copia
        dbamv.Prc_Pagu_Copia_Presc_Padrao( vCd_Pre_Pad );

        -- Limpando os Dados de Memoria
        dbamv.pkg_pagu_itpremed.Itpresc_Copia_Delete;
        dbamv.pkg_pagu_itpremed.apaga_prescricao_copia;

        OPEN rCursor FOR SELECT rCodeErro, rTextErro FROM dual;

    EXIT WHEN vPosProximoSeparador = 0 OR vPosProximoSeparador is null;
    END LOOP;
         If vCount =  0  Then
           Raise_Application_Error(-20001, 'Não existe nenhum item deste segmento na prescrição padrão selecionada!' );
          END IF;


    Exception When Others Then
     dbamv.pkg_pagu_itpremed.Itpresc_Copia_Delete;  -->> Evita que fique sujeira se houver algum erro
      dbamv.pkg_pagu_itpremed.apaga_prescricao_copia;
      Dbms_Output.Put_Line('rCodeErro:'||rCodeErro||'  - rTextErro:'||rTextErro);
      RAISE;
   End;
    Function fnc_le_ultimo_acesso(p_usuario in varchar2, p_chave in varchar2) return TypCur_Ref_Cursor is
      vRetorno varchar2(400);
      rCursor TypCur_Ref_Cursor;
      begin
        vRetorno := dbamv.pkg_pagu_usuario_ult_acesso.fnc_le_ultimo_acesso (p_usuario, p_chave);
        open rCursor for select vRetorno from dual;
        return rCursor;
      end;

	Procedure prc_le_mensagem_pagu(pDesempilhar in CHAR,
									 p_dsMensagem out varchar2,
									 p_dsModulo out varchar2,
									 p_Codigo out INTEGER,
									 p_dsBotao1 out varchar2,
									 p_dsBotao2 out varchar2) IS
      vDesempilhar BOOLEAN := true;
      Begin
        typRec_msg := dbamv.pkg_pagu.fn_mensagem(vDesempilhar);
        p_dsMensagem := typRec_msg.Mensagem;
        p_dsModulo := typRec_msg.Modulo;
        p_Codigo := typRec_msg.Codigo;
        p_dsBotao1 := typRec_msg.Btn1;
        p_dsBotao2 := typRec_msg.Btn2;
      End;
	Function fnc_pagu_retorna_set_unid ( pCd_Atendimento In Number,
                                          pCd_Objeto in Number Default Null) return  TypCur_Ref_Cursor is
     --
     rCursor TypCur_Ref_Cursor;
     pCd_unid_int number;
     pCd_Setor  number;
     --
     Begin
         dbamv.prc_pagu_retorna_set_unid( pCd_Atendimento,pCd_Objeto,pCd_unid_int, pCd_Setor );
         OPEN rCursor FOR SELECT pCd_unid_int,pCd_Setor  FROM dual;
         Return rCursor;
     End;

 	Function fnc_pari_canc_alta (pCd_Atendimento In Number) return  TypCur_Ref_Cursor is
     --
     rCursor TypCur_Ref_Cursor;
     pMsg VARCHAR2(60);
     --
     Begin
         pMsg := dbamv.fnc_pari_canc_alta(pCd_Atendimento, pMsg);
         OPEN rCursor FOR SELECT pMsg FROM dual;
         Return rCursor;
     End;

  Function fnc_cancela_diagnostico(pCd_Atendimento In Number, pApagaCid In Varchar2) return  TypCur_Ref_Cursor IS
     rCursor TypCur_Ref_Cursor;
	 vApagaCid Boolean := FALSE;
     Begin
	   If pApagaCid = 'S' Then
          vApagaCid := TRUE;
       End If;
       dbamv.prc_cancela_diagnostico(pCd_Atendimento, vApagaCid);
       OPEN rCursor FOR SELECT pCd_Atendimento FROM dual;
       RETURN rCursor;
     End;

   Procedure  PRC_FFCV_ALTERA_DT_LANCA(rCursor out TypCur_Ref_Cursor,
                                        PCDATENDIMENTO  IN  DBAMV.ATENDIME.CD_ATENDIMENTO%TYPE,
                                        PCDCONTA IN NUMBER ,
                                        PCDLANCA IN NUMBER ,
                                        PCDMVTO IN NUMBER  ,
                                        PCDITMVTO IN NUMBER ,
                                        PTPMVTO VARCHAR2,
										                    PPROFAT IN DBAMV.PRO_FAT.CD_PRO_FAT%TYPE ,
                                        PNEWDTLANCAMENTO IN DATE ,
                                        PNEWHRLANCAMENTO IN DATE ,
                                        PRESERVA IN VARCHAR2
                                                ) IS

    vRetorno VARCHAR2(20000);

    BEGIN

      DBAMV.PRC_FFCV_ALTERA_DT_LANCA(PCDATENDIMENTO,
                                          PCDCONTA ,
                                          PCDLANCA,
                                          PCDMVTO,
                                          PCDITMVTO,
                                          PTPMVTO,
										                      PPROFAT,
                                          PNEWDTLANCAMENTO,
                                          PNEWHRLANCAMENTO,
                                          PRESERVA ,
                                          vRetorno);

      open rCursor for select vRetorno from dual;

    END;
  Function leConfiguracao(pCd_Sistema Varchar2, pCd_Chave Varchar2) return  TypCur_Ref_Cursor IS
     rCursor TypCur_Ref_Cursor;
     pValor VARCHAR2(60);
     Begin
       pValor := dbamv.pkg_mv2000.LE_CONFIGURACAO(pCd_Sistema, pCd_Chave);
       OPEN rCursor FOR SELECT pValor FROM dual;
       RETURN rCursor;
     End;

   Function FNC_MVPEP_VERSAO_TISS (pCdConvenio Varchar2) return TypCur_Ref_Cursor IS
    vResult VARCHAR2(2000);
    rCursor TypCur_Ref_Cursor;

    BEGIN

      vResult := dbamv.fnc_Ffcv_Conf_Tiss('CD_VERSAO_TISS', pCdConvenio, NULL);

      OPEN rCursor FOR SELECT vResult FROM dual;
      Return rCursor;
    END;

	FUNCTION FNC_MVPEP_RELATORIO_TISS(pId NUMBER) return TypCur_Ref_Cursor IS
      vResult VARCHAR2(2000);
      vReturnMsg VARCHAR2(4000);
      rCursor TypCur_Ref_Cursor;
    BEGIN
      vResult := DBAMV.FNC_FFCV_RELATORIO_TISS(pId, 'SOLIC_PEP', vReturnMsg,NULL);

      OPEN rCursor FOR SELECT vResult, vReturnMsg FROM dual;
      Return rCursor;
    END;

    FUNCTION prc_troca_tp_doc_clinico (pCdPaciente NUMBER, pCdObjeto NUMBER) RETURN TypCur_Ref_Cursor IS

      CURSOR cDocumentAlta IS
        SELECT cd_documento_clinico
          FROM dbamv.pw_documento_clinico
        WHERE cd_paciente = pCdPaciente AND
            cd_tipo_documento IN (SELECT cd_tipo_documento
                                    FROM dbamv.pw_tipo_documento
                                  WHERE tp_documento = 'ALTA_MED');

        CURSOR cTipoDocumento IS
           SELECT cd_tipo_documento FROM dbamv.pw_tipo_documento WHERE tp_documento = 'ALTMED';


        PRAGMA AUTONOMOUS_TRANSACTION;

        vCdTipoDocumento NUMBER;
        vResult VARCHAR2(2000);
        rCursor TypCur_Ref_Cursor;

        BEGIN

            OPEN cTipoDocumento;
            FETCH cTipoDocumento INTO vCdTipoDocumento;
            CLOSE cTipoDocumento;

            vResult := 'N';

            FOR c IN cDocumentAlta LOOP
              UPDATE dbamv.pw_documento_clinico SET cd_tipo_documento = vCdTipoDocumento, cd_objeto = pCdObjeto
                WHERE cd_documento_clinico = c.cd_documento_clinico;
              vResult := 'S';
            END LOOP;

            COMMIT;

            OPEN rCursor FOR SELECT vResult FROM dual;
            Return rCursor;
        END;

   Function fnc_mvpep_processar_protocolo (pvTpDocumento   In Varchar2
                                                              , pvCdAtendimento In Number
                                                              , pvCdTriagem     In Number
															  , pvCdDocumentoClinico IN NUMBER DEFAULT NULL ) return TypCur_Ref_Cursor IS
      vResult Varchar2(10);
      vResultFunction Boolean;
      rCursor TypCur_Ref_Cursor;

      BEGIN

         vResultFunction := dbamv.pkg_mvpep_protocolo_clinico.fnc_mvpep_processar_protocolo(pvTpDocumento, pvCdAtendimento, pvCdTriagem , null , pvCdDocumentoClinico);

         IF vResultFunction Then
            vResult := 'true';
         ELSE
            vResult := 'false';
         END IF;

         OPEN rCursor FOR SELECT vResult FROM dual;
         Return rCursor;
      END;

   Procedure prc_mvpep_evoluir_caso_proto( pnCdPaciente NUMBER
                                         , pnCdAlertaProtocolo NUMBER
                                         , pnCdCasoProtocolo NUMBER
                                         , pvTpEtapa VARCHAR2
                                         , pvJustificativa VARCHAR2
                                         , pvCdEtapaProtocolo NUMBER
                                         , pvCdJustificativa NUMBER) Is

      BEGIN

         dbamv.pkg_mvpep_protocolo_clinico.prc_mvpep_evoluir_caso_proto(pnCdPaciente, pnCdAlertaProtocolo, pnCdCasoProtocolo, pvTpEtapa, pvJustificativa, pvCdEtapaProtocolo, pvCdJustificativa);
      END;

	  FUNCTION fnc_mvpep_sugere_cbo_prestador ( pnCdProcedimento IN dbamv.atendime.cd_procedimento%TYPE,
                                                pnCdPreMed       IN dbamv.pre_med.cd_pre_med%TYPE,
                                                pnCompetencia    IN DATE
                                              ) return TypCur_Ref_Cursor is

          --
        vResult   varchar2(2000);
        rCursor TypCur_Ref_Cursor;
          --
        begin
          --
          vResult := PKG_SUS_REGRA_CBO.F_SUGERE_CBO_PRESTADOR(pnCdProcedimento, pnCdPreMed, pnCompetencia);
          --
         OPEN rCursor FOR SELECT vResult FROM dual;
         Return rCursor;
         --

        END ;

	FUNCTION FNC_MVPEP_LISTAITEMPRESCRICAO( pCdPrescricao   In Number
                                         , pCdObjeto In Number
                                         , pCdAtendimento     In Number
                                         , pCdSetor     In Number) return TypCur_Ref_Cursor is
	vResult   CLOB;
	rCursor TypCur_Ref_Cursor;
	begin
		vResult := dbamv.Fnc_MVPEP_ListaItemPrescricao(pCdPrescricao, pCdObjeto, pCdAtendimento, pCdSetor);

		OPEN rCursor FOR SELECT vResult FROM dual;

		Return rCursor;
    END ;

Function FNC_MVPEP_LISTAITEMPRESCRICOES( pCdsPrescricoes In VARCHAR2
											, pCdObjeto In Number
											, pCdAtendimento In Number
											, pCdSetor In Number) return TypCur_Ref_Cursor Is

	vResult   CLOB;
	rCursor TypCur_Ref_Cursor;
	begin
		vResult := dbamv.FNC_MVPEP_LISTAITEMPRESCRICOES(pCdsPrescricoes, pCdObjeto, pCdAtendimento, pCdSetor);

		OPEN rCursor FOR SELECT vResult FROM dual;

		Return rCursor;
    END ;



	FUNCTION FNC_MVPEP_CONSULTARINFRECEITA( pCdPaciente In Number
											, pDtReferencia In Varchar2
											, pCdObjeto In Number
											, pCdPrestadorLogado In Number
											, pCdPrescricao In Number
											, pCdAtendimento In Number) return TypCur_Ref_Cursor is
	vResult   CLOB;
	rCursor TypCur_Ref_Cursor;
	begin
		vResult := dbamv.Fnc_Mvpep_ConsultarInfReceita(pCdPaciente, pDtReferencia, pCdObjeto, pCdPrestadorLogado, null, pCdPrescricao, pCdAtendimento);

		OPEN rCursor FOR SELECT vResult FROM dual;

		Return rCursor;
    END ;
	--
	Function Fnc_Retorna_Multi_Resistente( pCdPaciente IN NUMBER ) Return tGermes PIPELINED
                                   is TabDoc Dbamv.PKG_PSIH_BACTERIA_MTRESISTENTE.tGermes;
      --
	  vRetorno boolean;
	  --
	Begin
	  --
	  vRetorno := DBAMV.PKG_PSIH_BACTERIA_MTRESISTENTE.FNC_RETORNA_MULTI_RESISTENTE( pCdPaciente, TabDoc);
	  --
	  For I In 1..nvl(TabDoc.Last,0) Loop
	    --
	    Pipe Row(TabDoc(I));
	    --
	  End Loop;
	  --
	  Return;
     --
   End;
   --
   Procedure Prc_Retorna_Multi_Resistente( rCursor       OUT TypCur_Ref_Cursor
                                         , pCdPaciente   IN NUMBER
                                         ) Is
   BEGIN
     --
	 OPEN rCursor FOR SELECT ds_germe, dt_cadastro
						FROM TABLE(Fnc_Retorna_Multi_Resistente( pCdPaciente )) dual;
     --
   End;
   --
   Function Fnc_Retorna_Colonizacao( pCdPaciente IN NUMBER ) Return tGermes PIPELINED
                                   is TabDoc Dbamv.PKG_PSIH_BACTERIA_MTRESISTENTE.tGermes;
      --
	  vRetorno boolean;
	  --
	Begin
	  --
	  vRetorno := DBAMV.PKG_PSIH_BACTERIA_MTRESISTENTE.FNC_RETORNA_COLONIZACAO( pCdPaciente, TabDoc);
	  --
	  For I In 1..nvl(TabDoc.Last,0) Loop
	    --
	    Pipe Row(TabDoc(I));
	    --
	  End Loop;
	  --
	  Return;
     --
   End;
   --
   Procedure Prc_Retorna_Colonizacao( rCursor       OUT TypCur_Ref_Cursor
                                    , pCdPaciente   IN NUMBER
                                    ) Is
   BEGIN
     --
	 OPEN rCursor FOR SELECT ds_germe, dt_cadastro
						FROM TABLE(Fnc_Retorna_Colonizacao( pCdPaciente )) dual;
     --
   End;
   --
   Procedure prc_processa_indicacao_pac ( pCdAtendimento           In  Number
                                        , pCdTriagem               In  Number
										                    , pTpDocumento             In  Varchar2 default null
										                    , pCdUsuario               In  Varchar2
                                        , pCdDocumentoClinico      IN NUMBER        ) Is
     --
	 vRetornoCdIndicacaoPac Number(10);
	 --
   Begin
     --
	 dbamv.prc_processa_indicacao_pac ( null                   --pDsIdentificadorProcesso In  Varchar2
                                    , pCdAtendimento         --pCdAtendimento           In  Number
                                    , pCdTriagem             --pCdTriagem               In  Number
									                  , null                   --pConfCCIH                In  Varchar2 default null
									                  , pTpDocumento           --pTpDocumento             In  Varchar2 default null
									                  , vRetornoCdIndicacaoPac --pRetornoCdIndicacaoPac   Out Number
									                  , pCdUsuario             --pCdUsuario               In Varchar2
                                    , pCdDocumentoClinico  );
	 --
   End;
   --
   Procedure prc_controla_isolamento ( pCdPreMed In  Number, pCdDocumentoClinico IN NUMBER) Is
     --
	 Cursor cDadosPreMedControlaIsolamento Is
       Select pre_med.cd_atendimento
            , itpre_med.cd_itpre_med
            , itpre_med.sn_cancelado
			, itpre_med.cd_itpre_med_canc
         From dbamv.pre_med
            , dbamv.itpre_med
            , dbamv.tip_presc
        where pre_med.cd_pre_med     = itpre_med.cd_pre_med
          And itpre_med.cd_tip_presc = tip_presc.cd_tip_presc
          And pre_med.cd_pre_med     = pCdPreMEd
          And tip_presc.tp_isolamento_paciente IS NOT NULL;
	 --
   Begin
     --
	 For cReg In cDadosPreMedControlaIsolamento Loop
	   --
	   If (cReg.sn_cancelado = 'S') Then
	     --
		 dbamv.prc_exclui_reg_iso( cReg.cd_atendimento, cReg.cd_itpre_med_canc);
		 --
	   Else
	     --
	     dbamv.prc_controla_isolamento (cReg.cd_atendimento, cReg.cd_itpre_med, NULL, pCdDocumentoClinico);
	     --
	   End If;
	   --
	 End Loop;
	 --
   End;
   --
   FUNCTION FNC_MVPEP_VALIDA_ITENSPRESC(cdPreMed In Number) return TypCur_Ref_Cursor is

	   vResult   CLOB;

       rCursor TypCur_Ref_Cursor;
    begin
 	   vResult := dbamv.fnc_mvpep_valida_itens_presc(cdPreMed);

   	   OPEN rCursor FOR SELECT vResult FROM dual;

       return rCursor;

	END ;
	--
	FUNCTION FNC_PSSD_GET_OBRIGA_CID( pCdProcedimento In Varchar2
									  , pCdAtendimento In Number) return TypCur_Ref_Cursor is
	vResult Varchar2(10);
	vResultFunction Boolean;
	rCursor TypCur_Ref_Cursor;
	begin


		vResultFunction := DBAMV.FNC_PSSD_GET_OBRIGA_CID(pCdProcedimento, pCdAtendimento);

		If vResultFunction Then
			vResult := 'true';
		Else
			vResult := 'false';
		End If;

		OPEN rCursor FOR SELECT vResult FROM dual;


		Return rCursor;
    END ;
    --
    FUNCTION FNC_PSSD_RG_CID_PRINCIPAL(pCdProcedimento In Varchar2
    								  , pCdPaciente In Number
									  , pDtAtendimento In Date) return TypCur_Ref_Cursor IS

		vResult                        Varchar2(4000);
	    iCursor                        Integer;
	    vCdCid                         VARCHAR2(40);
	    vDsCid                         VARCHAR2(250);
	    iRetorno                       Integer;

	    vRetorno                       CLOB := '[';
		rCursor                        TypCur_Ref_Cursor;

	Begin
		vResult := DBAMV.FNC_PSSD_RG_CID_PRINCIPAL(pCdProcedimento, pCdPaciente, pDtAtendimento);

	    iCursor := DBMS_SQL.Open_cursor;
	    DBMS_SQL.parse (iCursor, vResult, 1);
	    DBMS_SQL.define_column (iCursor, 1, vCdCid, 40);
	    DBMS_SQL.define_column (iCursor, 2, vDsCid, 250);
	    iRetorno := DBMS_SQL.Execute (iCursor);

	    Loop
	      Exit When DBMS_SQL.FETCH_ROWS(iCursor) = 0;

	        DBMS_SQL.column_value(iCursor,1,vCdCid);
	        DBMS_SQL.column_value(iCursor,2,vDsCid);

	        Dbms_Lob.Append(vRetorno,'{"cdCid":"'||REPLACE(vCdCid,'"','')||'","dsCid":"'||REPLACE(vDsCid,'"','')||'"'||'},');
	    End Loop;

	    DBMS_SQL.Close_cursor (iCursor);

	    vRetorno := RTrim(vRetorno,',')||']';

		OPEN rCursor FOR SELECT vRetorno FROM dual;

		Return rCursor;
    END ;
	--
	Function fnc_retorna_dias_uso_paciente(pCdPaciente Number, pCdTipPresc Number, pDtReferencia Date, pCdItPreMed Number) return TypCur_Ref_Cursor IS
      --
      vResult NUMBER;
      --
      rCursor TypCur_Ref_Cursor;
      --
    BEGIN
      --
      vResult := dbamv.fn_retorna_dias_uso_paciente(pCdPaciente, pCdTipPresc, pDtReferencia, pCdItPreMed);
      --
      OPEN rCursor FOR SELECT vResult FROM dual;
      --
		  Return rCursor;
      --
    END ;
    --
	FUNCTION FNC_SUGESTAO_PROTOCOLO( pCdAtendimento In Number ) return TypCur_Ref_Cursor IS
		--
		vResult   CLOB;
		--
		rCursor TypCur_Ref_Cursor;
		--
	BEGIN
		--
		vResult := Dbamv.FNC_SUGESTAO_PROTOCOLO( pCdAtendimento );
		--
		OPEN rCursor FOR SELECT vResult FROM dual;
		--
		Return rCursor;
    END ;
	--
	Function FNC_INSERIR_MOV_INV(
							  pDT_MOV_INV 			In DATE,
							  pCD_ATENDIMENTO 		In NUMBER,
							  pCD_PRO_INVASIVO 		In NUMBER,
							  pDT_INICIO 			In DATE,
							  pHR_INICIO 			In DATE,
							  pUSER_APLICACAO 		In VARCHAR2,
							  pCD_LOCAL_AFERICAO 	In NUMBER,
							  pDT_FIM 				In DATE 		DEFAULT NULL,
							  pHR_FIM 				In DATE 		DEFAULT NULL,
							  pUSER_RETIRADA 		In VARCHAR2 	DEFAULT NULL,
							  pCD_AVISO_CIRURGIA 	In NUMBER 		DEFAULT NULL ) Return TypCur_Ref_Cursor IS

	vResult NUMBER;
		--
		rCursor TypCur_Ref_Cursor;
		--
	BEGIN
		--
		vResult := Dbamv.FNC_PSIH_INSERIR_MOV_INV(pDT_MOV_INV, pCD_ATENDIMENTO, pCD_PRO_INVASIVO, pDT_INICIO, pHR_INICIO, pUSER_APLICACAO, pCD_LOCAL_AFERICAO, pDT_FIM, pHR_FIM, pUSER_RETIRADA, pCD_AVISO_CIRURGIA);
		--
		OPEN rCursor FOR SELECT vResult FROM dual;
		--
		Return rCursor;
		--
    END ;

	--PEP 1067
	FUNCTION FNC_MVPEP_SESSOES_DIA_PACIENTE(P_CD_PRE_MED IN NUMBER,P_CD_PACIENTE IN NUMBER, P_CD_DATA IN DATE) return TypCur_Ref_Cursor is
	 vResult   CLOB;
	 rCursor TypCur_Ref_Cursor;
	 begin
	  vResult := dbamv.FNC_SESSOES_DIA_PACIENTE(P_CD_PRE_MED, P_CD_PACIENTE, P_CD_DATA);

	  OPEN rCursor FOR SELECT vResult FROM dual;

	  Return rCursor;
    END ;
  --

  Function FNC_TRANSFERE_AGENDAMENTO( p_cd_multi_empresa NUMBER,
                                      p_cd_recurso_onco_ori NUMBER,
                                      p_data_hora_inicial_ori DATE,
                                      p_data_hora_final_ori DATE,
                                      p_cd_recurso_onco_dest NUMBER,
                                      p_data_hora_inicial_dest DATE,
                                      p_data_hora_final_dest DATE,
                                      p_cd_solic_agendamento NUMBER
                                    ) Return TypCur_Ref_Cursor Is
    --
    rCursor TypCur_Ref_Cursor;
    vRetorno Number;
    pr_mensagem_erro Varchar2(1000);
    --
  Begin
    vRetorno := Dbamv.pkg_scma_oncologia.fnc_transfere_agendamento( p_cd_multi_empresa,
                                                                    p_cd_recurso_onco_ori,
                                                                    p_data_hora_inicial_ori,
                                                                    p_data_hora_final_ori,
                                                                    p_cd_recurso_onco_dest,
                                                                    p_data_hora_inicial_dest,
                                                                    p_data_hora_final_dest,
                                                                    p_cd_solic_agendamento,
                                                                    pr_mensagem_erro
                                                                  );

    OPEN rCursor FOR SELECT vRetorno, pr_mensagem_erro FROM dual;
    Return rCursor;
  End;
  --

  Function FNC_CANCELA_AGENDAMENTO( p_cd_multi_empresa NUMBER,
                                    p_cd_agendamento_oncologico NUMBER DEFAULT NULL,
                                    p_cd_recurso_oncologico NUMBER,
                                    p_data_hora_inicial DATE,
                                    p_data_hora_final DATE,
                                    p_cd_itpre_med NUMBER
                                  ) Return TypCur_Ref_Cursor Is
    --
    rCursor TypCur_Ref_Cursor;
    vRetorno Number;
    pr_mensagem_erro Varchar2(1000);
    --
  Begin
    vRetorno := Dbamv.pkg_scma_oncologia.fnc_cancela_agendamento( p_cd_multi_empresa,
                                                                  p_cd_agendamento_oncologico,
                                                                  p_cd_recurso_oncologico,
                                                                  p_data_hora_inicial,
                                                                  p_data_hora_final,
                                                                  p_cd_itpre_med,
                                                                  pr_mensagem_erro
                                                                );

    OPEN rCursor FOR SELECT vRetorno, pr_mensagem_erro FROM dual;
    Return rCursor;
  End;

FUNCTION fnc_insere_aviso_cirurgia( pCD_PACIENTE IN NUMBER, pDS_CIRURGIA IN LONG ) RETURN TypCur_Ref_Cursor IS
	rCursor TypCur_Ref_Cursor;
	vRetorno Number;
	pr_mensagem_erro Varchar2(1000);

	pOCD_AVISO_CIRURGIA NUMBER;
BEGIN


	vRetorno := dbamv.pkg_fscc_aviso_cirurgia.fnc_insere_aviso_cirurgia(
	        pOCD_AVISO_CIRURGIA, null, null, null, null, null,  null, null,
	        null, null, null, null, null, null, null, null, null, null, null,
	        null, null, null, null, null, null, null, null, null, null, null,
	        null, pCD_PACIENTE, null, null, null, null, null, null, null,
	        null, null, null, null, null, null, null, null, null,
	        null, null, null, null, null, null, null, null, null,
	        null, null, null, null, pDS_CIRURGIA , NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, pr_mensagem_erro);

	OPEN rCursor FOR SELECT vRetorno, pr_mensagem_erro FROM dual;
	Return rCursor;
END;
--
FUNCTION fnc_pssd_material_complementar(pCdExame NUMBER,pCdMaterial NUMBER) return TypCur_Ref_Cursor IS
	vResult BOOLEAN;
	rCursor TypCur_Ref_Cursor;
BEGIN
	vResult := dbamv.fnc_pssd_material_complementar(pCdExame, pCdMaterial);

	IF vResult = TRUE THEN
		OPEN rCursor FOR SELECT 'true' FROM dual;
	ELSE
		OPEN rCursor FOR SELECT 'false' FROM dual;
	END IF;

	Return rCursor;
END;
--

FUNCTION fnc_mvpep_cabecalho_relatorios( pCdDocClinico IN NUMBER DEFAULT NULL, pvTemplate IN VARCHAR2 DEFAULT NULL
                                                                , pIdentRel IN VARCHAR2 DEFAULT NULL
                                                                , pCdDiagRealizado IN NUMBER DEFAULT NULL) return TypCur_Ref_Cursor IS
  rCursor TypCur_Ref_Cursor;

  -- Cursor Historico Enfermagem
  CURSOR cHistEnf (pDocClinico NUMBER) IS
    SELECT SAE_HIST_ENF.CD_ATENDIMENTO                       AS CD_ATENDIMENTO
         , SAE_HIST_ENF.CD_PACIENTE                          AS CD_PACIENTE
         , SAE_HIST_ENF.CD_HISTORICO_ENFERMAGEM              AS CD_HIST_ENF
         , SAE_HIST_ENF.CD_DOCUMENTO_CLINICO                 AS CD_DOC_CLI

    FROM DBAMV.SAE_HISTORICO_ENFERMAGEM SAE_HIST_ENF

    WHERE SAE_HIST_ENF.CD_DOCUMENTO_CLINICO = pDocClinico;

  -- Cursor Atendimento
  CURSOR cAtendimento (pCdAtendimento NUMBER, pCdPaciente NUMBER) IS
    SELECT ATENDIMENTO.CD_ATENDIMENTO                        AS CD_ATENDIMENTO
         , ATENDIMENTO.DT_ATENDIMENTO                        AS DT_ATENDIMENTO
         , ATENDIMENTO.HR_ATENDIMENTO                        AS HR_ATENDIMENTO
         , ATENDIMENTO.DT_CHEGADA_PACIENTE                   AS DT_CGA_PACIENTE
         , ATENDIMENTO.DT_ALTA                               AS DT_ALTA
         , ATENDIMENTO.NR_CARTEIRA                           AS NR_CARTEIRA
         , ATENDIMENTO.CD_CONVENIO                           AS CD_CONVENIO
         , ATENDIMENTO.CD_LEITO                              AS CD_LEITO
         , ATENDIMENTO.CD_PRESTADOR                          AS CD_PRESTADOR
         , CID.CD_CID                                        AS CD_CID
         , CID.DS_CID                                        AS DS_CID
         , TIP_ACOM.DS_TIP_ACOM                              AS DS_TIP_ACOM
         , ESPECIALIDADE.DS_ESPECIALID                       AS DS_ESPECIALID

    FROM DBAMV.ATENDIME ATENDIMENTO
        , DBAMV.CID CID
        , DBAMV.TIP_ACOM TIP_ACOM
        , DBAMV.ESPECIALID ESPECIALIDADE

    WHERE ATENDIMENTO.CD_ATENDIMENTO = pCdAtendimento
        AND ATENDIMENTO.CD_CID = CID.CD_CID
        AND ATENDIMENTO.CD_ESPECIALID = ESPECIALIDADE.CD_ESPECIALID;

  -- Cursor Paciente
  CURSOR cPaciente (pCdPaciente NUMBER) IS
    SELECT PACIENTE.CD_PACIENTE                              AS CD_PACIENTE
        , PACIENTE.NM_PACIENTE                               AS NM_PACIENTE
        , PACIENTE.TP_SEXO                                   AS TP_SEXO
        , PACIENTE.TP_SANGUINEO                              AS TP_SANGUINEO
        , PACIENTE.DT_NASCIMENTO                             AS DT_NASCIMENTO
        , PACK_INTERNAMENTO.RETORNA_IDADE(PACIENTE.DT_NASCIMENTO, SYSDATE) AS NR_IDADE
        , PACIENTE.NR_FONE                                   AS NR_FONE
        , PACIENTE.NR_DDD_FONE                               AS NR_DDD_FONE
        , PACIENTE.NR_CELULAR                                AS NR_CELULAR
        , PACIENTE.NR_DDD_CELULAR                            AS NR_DDD_CELULAR
        , PACIENTE.TP_ESTADO_CIVIL                           AS TP_ESTADO_CIVIL
        , PACIENTE.CD_PROFISSAO                              AS CD_PROFISSAO
        , PACIENTE.NM_MAE                                    AS NM_MAE
        , PACIENTE.NM_PAI                                    AS NM_PAI
        , PACIENTE.EMAIL                                     AS EMAIL
        , PACIENTE.CD_CIDADE                                 AS CD_CIDADE
        , PACIENTE.DS_ENDERECO                               AS DS_ENDERECO
        , PACIENTE.NR_ENDERECO                               AS NR_ENDERECO
        , PACIENTE.DS_COMPLEMENTO                            AS DS_COMPLEMENTO
        , PACIENTE.NR_CEP                                    AS NR_CEP
        , PACIENTE.NM_BAIRRO                                 AS NM_BAIRRO
        , PACIENTE.NM_SOCIAL_PACIENTE                        AS NM_SOCIAL_PACIENTE
        , PACIENTE.NR_CNS                                    AS NR_CNS
        , CIDADE.NM_CIDADE                                   AS NM_CIDADE
        , (SELECT NM_CIDADE
           FROM DBAMV.PACIENTE PAC, DBAMV.CIDADE CIDAD
           WHERE PAC.CD_NATURALIDADE = CIDAD.CD_CIDADE
               AND PAC.CD_PACIENTE = pCdPaciente)            AS NATURALIDADE

    FROM DBAMV.PACIENTE PACIENTE
        , DBAMV.CIDADE CIDADE

    WHERE PACIENTE.CD_PACIENTE = pCdPaciente
        AND CIDADE.CD_CIDADE = PACIENTE.CD_CIDADE;

  CURSOR cDiagnosticoRealizado IS
    SELECT DIAGNOSTICO_REALIZADO.CD_PACIENTE                 AS CD_PACIENTE
        , DIAGNOSTICO_REALIZADO.CD_ATENDIMENTO               AS CD_ATENDIMENTO
        , DIAGNOSTICO_REALIZADO.CD_DOCUMENTO_CLINICO         AS CD_DOC_CLINICO

    FROM DBAMV.SAE_DIAGNOSTICO_REALIZADO DIAGNOSTICO_REALIZADO

    WHERE DIAGNOSTICO_REALIZADO.CD_DIAGNOSTICO_REALIZADO = pCdDiagRealizado;

  -- Cursor Profissao
  CURSOR cProfissao (pCdProfissao NUMBER) IS
    SELECT PROFISSAO.CD_PROFISSAO                            AS CD_PROFISSAO
        , PROFISSAO.NM_PROFISSAO                             AS NM_PROFISSAO

    FROM DBAMV.PROFISSAO PROFISSAO

    WHERE PROFISSAO.CD_PROFISSAO = pCdProfissao;

  -- Cursor Prestador
  CURSOR cPrestador (pCdPrestador NUMBER) IS
    SELECT PRESTADOR.CD_PRESTADOR                            AS CD_PRESTADOR
        , PRESTADOR.NM_PRESTADOR                             AS NM_PRESTADOR
        , PRESTADOR.TP_PRESTADOR                             AS TP_PRESTADOR
        , PRESTADOR.DS_CODIGO_CONSELHO                       AS DS_CODIGO_CONSELHO
        , CONSELHO.CD_CONSELHO                               AS CD_CONSELHO
        , CONSELHO.DS_CONSELHO                               AS DS_CONSELHO

    FROM DBAMV.PRESTADOR PRESTADOR
        , DBAMV.CONSELHO CONSELHO

    WHERE PRESTADOR.CD_PRESTADOR = pCdPrestador
        AND PRESTADOR.CD_CONSELHO = CONSELHO.CD_CONSELHO;

  -- Cursor Documento Clinico
  CURSOR cDocClinico (pCdDocCli NUMBER) IS
    SELECT DOC_CLINICO.CD_DOCUMENTO_CLINICO                  AS CD_DOC_CLINICO
        , DOC_CLINICO.DH_DOCUMENTO                           AS DH_DOCUMENTO
        , DOC_CLINICO.DH_REFERENCIA                          AS DH_REFERENCIA
        , DOC_CLINICO.CD_PACIENTE                            AS CD_PACIENTE
        , DOC_CLINICO.CD_ATENDIMENTO                         AS CD_ATENDIMENTO

    FROM DBAMV.PW_DOCUMENTO_CLINICO DOC_CLINICO

    WHERE DOC_CLINICO.CD_DOCUMENTO_CLINICO = pCdDocCli;

  -- Cursor Convenio
  CURSOR cConvenio (pCdConvenio NUMBER) IS
    SELECT CONVENIO.CD_CONVENIO                              AS CD_CONVENIO
        , CONVENIO.NM_CONVENIO                               AS NM_CONVENIO
        , PLANO.CD_CON_PLA                                   AS CD_CON_PLA
        , PLANO.DS_CON_PLA                                   AS DS_CON_PLA

    FROM DBAMV.CONVENIO CONVENIO
        , DBAMV.CON_PLA PLANO

    WHERE CONVENIO.CD_CONVENIO = PLANO.CD_CONVENIO
        AND CONVENIO.CD_CONVENIO = pCdConvenio;

  -- Cursor Leito
  CURSOR cLeito (pCdLeito NUMBER) IS
    SELECT LEITO.CD_LEITO                                    AS CD_LEITO
        , LEITO.DS_LEITO                                     AS DS_LEITO
        , LEITO.DS_ENFERMARIA                                AS DS_ENFERMARIA
        , UNID_INT.CD_UNID_INT                               AS CD_UNID_INT
        , UNID_INT.DS_UNID_INT                               AS DS_UNID_INT
        , SETOR.CD_SETOR                                     AS CD_SETOR
        , SETOR.NM_SETOR                                     AS NM_SETOR

    FROM DBAMV.LEITO LEITO
        , DBAMV.UNID_INT UNID_INT
        , DBAMV.SETOR SETOR

    WHERE LEITO.CD_LEITO = pCdLeito
        AND LEITO.CD_UNID_INT = UNID_INT.CD_UNID_INT
        AND UNID_INT.CD_SETOR = SETOR.CD_SETOR;

  -- Cursor Prescricao Medica
  CURSOR cPreMed (pCdPrestador NUMBER, pCdAtendimento NUMBER) IS
    SELECT PRE_MED.DH_IMPRESSAO                              AS DH_IMPRESSAO
        , PRE_MED.CD_PRE_MED                                 AS CD_PRE_MED
        , PRE_MED.CD_ATENDIMENTO                             AS CD_ATENDIMENTO
        , PRE_MED.DT_REFERENCIA                              AS DT_REFERENCIA

    FROM DBAMV.PRE_MED PRE_MED

    WHERE PRE_MED.CD_PRESTADOR = pCdPrestador
        AND PRE_MED.CD_ATENDIMENTO = pCdAtendimento;

  -- Cursor Peso Altura inicial
  CURSOR cPesoAlturaInicial (pCdPreMed NUMBER ,  pIdentificador VARCHAR2) IS
    SELECT PRE_MED_RESP_FORMULA.VL_RESPOSTA                  AS VALOR_RESP

    FROM DBAMV.PAGU_OBJETO_PERG_FORMULA PAGU_OBJETO
        , DBAMV.PAGU_PERGUNTA PAGU_PERGUNTA
        , DBAMV.PRE_MED_RESPOSTA_FORMULA PRE_MED_RESP_FORMULA
        , DBAMV.PRE_MED PRE_MED

    WHERE PAGU_OBJETO.CD_OBJETO = PRE_MED.CD_OBJETO
        AND PAGU_PERGUNTA.CD_PERGUNTA = PAGU_OBJETO.CD_PERGUNTA
        AND UPPER(PAGU_PERGUNTA.NM_IDENTIFICADOR) = UPPER(pIdentificador)
        AND PRE_MED_RESP_FORMULA.CD_PERGUNTA = PAGU_PERGUNTA.CD_PERGUNTA
        AND PRE_MED_RESP_FORMULA.CD_PRE_MED = PRE_MED.CD_PRE_MED
        AND PAGU_PERGUNTA.TP_PERGUNTA = 'N';

  -- Cursor Peso Altura
  CURSOR cPesoAltura (pCdPreMed NUMBER, pIdentificador VARCHAR2) IS
    SELECT PRE_MED_RESP_FORMULA.VL_RESPOSTA                 AS VALOR_RESP

    FROM DBAMV.PAGU_OBJETO_PERG_FORMULA PAGU_OBJETO
        , DBAMV.PAGU_PERGUNTA PAGU_PERGUNTA
        , DBAMV.PRE_MED_RESPOSTA_FORMULA PRE_MED_RESP_FORMULA
        , DBAMV.PRE_MED PRE_MED

     WHERE PAGU_OBJETO.CD_OBJETO = PRE_MED.CD_OBJETO
        AND PAGU_PERGUNTA.CD_PERGUNTA  = PAGU_OBJETO.CD_PERGUNTA
        AND UPPER(PAGU_PERGUNTA.NM_IDENTIFICADOR) = UPPER(pIdentificador)
        AND PRE_MED_RESP_FORMULA.CD_PERGUNTA = PAGU_PERGUNTA.CD_PERGUNTA
        AND PRE_MED_RESP_FORMULA.CD_PRE_MED = PRE_MED.CD_PRE_MED
        AND PAGU_PERGUNTA.TP_PERGUNTA  = 'N'
        AND PRE_MED.CD_PRE_MED = pCdPreMed AND ROWNUM = 1;

  -- Cursor Descricao Unidade formula
  CURSOR cDsUnidadeFormula(pCdFormula NUMBER) IS
    SELECT PW_UNIDADE_FORMULA.DS_UNIDADE_FORMULA            AS DS_UNIDADE_FORMULA

    FROM DBAMV.PAGU_FORMULA
        , DBAMV.PW_UNIDADE_FORMULA

    WHERE PAGU_FORMULA.CD_UNIDADE_FORMULA = PW_UNIDADE_FORMULA.CD_UNIDADE_FORMULA
        AND PAGU_FORMULA.cd_formula = pCdFormula;

  -- Declaracao de variaveis
  vHistEnf              cHistEnf%Rowtype;
  vAtendimento          cAtendimento%Rowtype;
  vPaciente             cPaciente%Rowtype;
  vProfissao            cProfissao%Rowtype;
  vPrestador            cPrestador%Rowtype;
  vDocClinico           cDocClinico%Rowtype;
  vConvenio             cConvenio%Rowtype;
  vLeito                cLeito%Rowtype;
  vPreMed               cPreMed%Rowtype;
  vDiagnosticoRealizado cDiagnosticoRealizado%Rowtype;

  rRegClassRisco   DBAMV.PKG_PAGU_CLASSIFICACAO_RISCO.TypRec_VisualAtribute;

  vAltura          NUMBER;
  vPeso            NUMBER;
  vSupCorp         NUMBER;
  vDsUniFormula    DBAMV.PW_UNIDADE_FORMULA.DS_UNIDADE_FORMULA%Type;

  vCdAtendimento   NUMBER;
  vCdPaciente      NUMBER;
  vCdDocClinico    NUMBER;

  vTpSexo          VARCHAR2(20);
  vTpEstadoCivil   VARCHAR2(20);
  vTpPrestador     VARCHAR2(20);
  vRetorno         VARCHAR2(32000) := pvTemplate;
  --

  BEGIN
    vTpSexo         := null;
    vTpEstadoCivil  := null;
    vTpPrestador    := null;
    vAltura         := null;
    vPeso           := null;
    vSupCorp        := null;
    vCdAtendimento  := null;
    vCdPaciente     := null;
    vCdDocClinico   := null;


    IF pIdentRel = 'R_HISENF' THEN
      OPEN cHistEnf(pCdDocClinico);
        FETCH cHistEnf INTO vHistEnf;
      CLOSE cHistEnf;

      vCdAtendimento    := vHistEnf.CD_ATENDIMENTO;
      vCdPaciente       := vHistEnf.CD_PACIENTE;
      vCdDocClinico     := vHistEnf.CD_DOC_CLI;

      OPEN cDocClinico(vCdDocClinico);
        FETCH cDocClinico INTO vDocClinico;
      CLOSE cDocClinico;
    ELSIF pIdentRel = 'R_DIAENF' THEN
      OPEN cDiagnosticoRealizado;
        FETCH cDiagnosticoRealizado INTO vDiagnosticoRealizado;
      CLOSE cDiagnosticoRealizado;

      vCdAtendimento    := vDiagnosticoRealizado.CD_ATENDIMENTO;
      vCdPaciente       := vDiagnosticoRealizado.CD_PACIENTE;
      vCdDocClinico     := vDiagnosticoRealizado.CD_DOC_CLINICO;

      OPEN cDocClinico(vCdDocClinico);
        FETCH cDocClinico INTO vDocClinico;
      CLOSE cDocClinico;
    ELSIF (pIdentRel = 'R_RESENF') THEN
      OPEN cDocClinico(pCdDocClinico);
        FETCH cDocClinico INTO vDocClinico;
      CLOSE cDocClinico;

      vCdAtendimento    := vDocClinico.CD_ATENDIMENTO;
      vCdPaciente       := vDocClinico.CD_PACIENTE;
      vCdDocClinico     := vDocClinico.CD_DOC_CLINICO;
    END IF;

    OPEN cAtendimento(vCdAtendimento, vCdPaciente);
      FETCH cAtendimento INTO vAtendimento;
    CLOSE cAtendimento;

    OPEN cPaciente(vCdPaciente);
      FETCH cPaciente INTO vPaciente;
    CLOSE cPaciente;

    OPEN cProfissao(vPaciente.CD_PROFISSAO);
      FETCH cProfissao INTO vProfissao;
    CLOSE cProfissao;

    OPEN cPrestador(vAtendimento.CD_PRESTADOR);
      FETCH cPrestador INTO vPrestador;
    CLOSE cPrestador;

    OPEN cConvenio(vAtendimento.CD_CONVENIO);
      FETCH cConvenio INTO vConvenio;
    CLOSE cConvenio;

    OPEN cLeito(vAtendimento.CD_LEITO);
      FETCH cLeito INTO vLeito;
    CLOSE cLeito;

    OPEN cPreMed(vAtendimento.CD_PRESTADOR, vAtendimento.CD_ATENDIMENTO);
      FETCH cPreMed INTO vPreMed;
    CLOSE cPreMed;

    rRegClassRisco := DBAMV.FNC_PAGU_CLASSE_RISCO(vPreMed.CD_ATENDIMENTO);

    OPEN cPesoAlturaInicial (vPreMed.CD_PRE_MED, 'PESO');
      FETCH cPesoAlturaInicial INTO vPeso;
    CLOSE cPesoAlturaInicial;

    OPEN cPesoAlturaInicial (vPreMed.CD_PRE_MED, 'ALTURA');
      FETCH cPesoAlturaInicial INTO vAltura;
    CLOSE cPesoAlturaInicial;

    OPEN cPesoAlturaInicial (vPreMed.CD_PRE_MED, 'SC');
      FETCH cPesoAlturaInicial INTO vSupCorp;
    CLOSE cPesoAlturaInicial;

    -- Validacao de super corporea
    IF vSupCorp IS NULL THEN
      OPEN cPesoAltura(vPreMed.CD_PRE_MED , 'SC');
        FETCH cPesoAltura INTO vSupCorp;
      CLOSE cPesoAltura;
    END IF;

    IF vSupCorp IS NOT NULL THEN
      vSupCorp := Round(vSupCorp, 4);

      OPEN cDsUnidadeFormula(pkg_pagu.fn_config_pagu().cd_formula_sup_cor);
        FETCH cDsUnidadeFormula INTO vDsUniFormula;
      CLOSE cDsUnidadeFormula;
    ELSE
      vSupCorp := 0;
    END IF;

    -- Validacao de peso
    IF vPeso IS NULL THEN
      OPEN cPesoAltura(vPreMed.CD_PRE_MED, 'PESO');
        FETCH cPesoAltura INTO vPeso;
      CLOSE cPesoAltura;

      IF vPeso IS NULL THEN
        vPeso := 0;
      END IF;
    END IF;

    -- Validacao de altura
    IF vAltura IS NULL THEN
      OPEN cPesoAltura(vPreMed.CD_PRE_MED, 'ALTURA');
        FETCH cPesoAltura INTO vAltura;
      CLOSE cPesoAltura;

      IF vAltura IS NULL THEN
        vAltura := 0;
      END IF;
    END IF;

    -- Formatacao do valor do campo TP_SEXO
    IF vPaciente.TP_SEXO IS NOT NULL THEN

      IF vPaciente.TP_SEXO = 'F' THEN
        vTpSexo := 'Feminino';

      ELSIF vPaciente.TP_SEXO = 'M' THEN
        vTpSexo := 'Masculino';

      ELSE
        vTpSexo := 'Não informado';

      END IF;
    ELSE
      vTpSexo := 'Não informado';

    END IF;

    -- Formatacao do valor do campo TP_ESTADO_CIVIL
    IF vPaciente.TP_ESTADO_CIVIL IS NOT NULL THEN

      IF vPaciente.TP_ESTADO_CIVIL = 'S' THEN
        vTpEstadoCivil := 'Solteiro';

      ELSIF vPaciente.TP_ESTADO_CIVIL = 'C' THEN
        vTpEstadoCivil := 'Casado';

      ELSIF vPaciente.TP_ESTADO_CIVIL = 'V' THEN
        vTpEstadoCivil := 'Viúvo';

      ELSIF vPaciente.TP_ESTADO_CIVIL = 'D' THEN
        vTpEstadoCivil := 'Desquitado';

      ELSIF vPaciente.TP_ESTADO_CIVIL = 'I' THEN
        vTpEstadoCivil := 'Divorciado';

      ELSIF vPaciente.TP_ESTADO_CIVIL = 'U' THEN
        vTpEstadoCivil := 'União-estável';

      ELSE
        vTpEstadoCivil := 'Não informado';

      END IF;
    ELSE
        vTpEstadoCivil := 'Não informado';

    END IF;

    -- Formatacao do valor do campo TP_PRESTADOR
    IF vPrestador.TP_PRESTADOR IS NOT NULL THEN

      IF vPrestador.TP_PRESTADOR = 'A' THEN
        vTpPrestador := 'Aluno';

      ELSIF vPrestador.TP_PRESTADOR = 'P' THEN
        vTpPrestador := 'Professor';

      ELSIF vPrestador.TP_PRESTADOR = 'O' THEN
        vTpPrestador := 'Outros';

      ELSE
        vTpPrestador := 'Não informado';
      END IF;
    ELSE
      vTpPrestador := 'Não informado';
    END IF;

  --------------------------------------------------------

  vRetorno := replace(vRetorno,'#',' ');
  vRetorno := replace(vRetorno,'@',chr(10));

  vRetorno :=  REGEXP_REPLACE(vRetorno, '<b>'                             ,'<style isBold="true" pdfFontName="Helvetica-Bold">', 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '</b>'                            ,'</style>', 1, 0, 'i');

  vRetorno :=  REGEXP_REPLACE(vRetorno, '<CD_ATENDIMENTO>'                ,vCdAtendimento, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<CD_PACIENTE>'                   ,vPaciente.CD_PACIENTE, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_PACIENTE>'                   ,vPaciente.NM_PACIENTE, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<TP_SEXO>'                       ,vTpSexo, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<TP_SANGUINEO>'                  ,vPaciente.TP_SANGUINEO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DT_NASCIMENTO>'                 ,TO_CHAR(vPaciente.DT_NASCIMENTO, 'DD/MM/YYYY'), 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_IDADE>'                      ,vPaciente.NR_IDADE, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_FONE>'                       ,vPaciente.NR_DDD_FONE || ' ' || vPaciente.NR_FONE, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_CELULAR>'                    ,vPaciente.NR_DDD_CELULAR || ' ' || vPaciente.NR_CELULAR, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<TP_ESTADO_CIVIL>'               ,vTpEstadoCivil, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_PROFISSAO>'                  ,vProfissao.NM_PROFISSAO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_MAE>'                        ,vPaciente.NM_MAE, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_PAI>'                        ,vPaciente.NM_PAI, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<EMAIL>'                         ,vPaciente.EMAIL, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NATURALIDADE>'                  ,vPaciente.NATURALIDADE, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_CIDADE>'                     ,vPaciente.NM_CIDADE, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_ENDERECO>'                   ,vPaciente.DS_ENDERECO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_ENDERECO>'                   ,vPaciente.NR_ENDERECO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_COMPLEMENTO>'                ,vPaciente.DS_COMPLEMENTO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_CEP>'                        ,vPaciente.NR_CEP, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_BAIRRO>'                     ,vPaciente.NM_BAIRRO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_SOCIAL_PACIENTE>'            ,vPaciente.NM_SOCIAL_PACIENTE, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_CNS>'                        ,vPaciente.NR_CNS, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DT_ATENDIMENTO>'                ,TO_CHAR(vAtendimento.DT_ATENDIMENTO, 'DD/MM/YYYY hh24:mi'), 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<HR_ATENDIMENTO>'                ,TO_CHAR(vAtendimento.HR_ATENDIMENTO, 'hh24:mi'), 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_DIAS_INTERNADO>'             ,TRUNC(vPreMed.DT_REFERENCIA - vAtendimento.DT_ATENDIMENTO), 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<CD_UNID_INT>'                   ,vLeito.CD_UNID_INT, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_UNID_INT>'                   ,vLeito.DS_UNID_INT, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_LEITO>'                      ,vLeito.DS_LEITO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<CD_CID>'                        ,vAtendimento.CD_CID, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_CID>'                        ,vAtendimento.DS_CID, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_PRESTADOR>'                  ,vPrestador.NM_PRESTADOR, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<TP_PRESTADOR>'                  ,vTpPrestador, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_CONSELHO>'                   ,vPrestador.DS_CONSELHO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_CODIGO_CONSELHO>'            ,vPrestador.DS_CODIGO_CONSELHO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_CONSELHO>'                   ,vPrestador.DS_CONSELHO || ' - ' || vPrestador.DS_CODIGO_CONSELHO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_ESPECIALID>'                 ,vAtendimento.DS_ESPECIALID, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_CONVENIO>'                   ,vConvenio.NM_CONVENIO, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<CD_DOCUMENTO_CLINICO>'          ,vCdDocClinico, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DH_DOCUMENTO>'                  ,TO_CHAR(vDocClinico.DH_DOCUMENTO, 'dd/mm/yyyy hh24:mi'), 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DH_REFERENCIA>'                 ,vDocClinico.DH_REFERENCIA, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<CD_HISTORICO_ENFERMAGEM>'       ,vHistEnf.CD_HIST_ENF, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<CD_CLASSIFICACAO_RISCO>'        ,rRegClassRisco.NM_COR, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_CON_PLA>'                    ,vConvenio.DS_CON_PLA, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_CARTEIRA>'                   ,vAtendimento.NR_CARTEIRA, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_TIP_ACOM>'                   ,vAtendimento.Ds_Tip_Acom, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NM_SETOR>'                      ,vLeito.NM_SETOR, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DS_ENFERMARIA>'                 ,vLeito.DS_ENFERMARIA, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<DH_IMPRESSAO>'                  ,TO_CHAR(vPreMed.DH_IMPRESSAO, 'dd/mm/yyyy hh24:mi'), 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_SUP_CORP>'                   ,TO_CHAR(vSupCorp, '99990.9999') || ' ' || vDsUniFormula, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_PESO>'                       ,vPeso, 1, 0, 'i');
  vRetorno :=  REGEXP_REPLACE(vRetorno, '<NR_ALTURA>'                     ,vAltura, 1, 0, 'i');

  vRetorno := replace(vRetorno,'&','');

  OPEN rCursor FOR SELECT vRetorno FROM dual;

  Return rCursor;

END;
--

Function Fnc_Retorna_Documentos_presc( pCdPrestador IN NUMBER DEFAULT NULL , vListPrescs VARCHAR2 ) Return TypTabDoc PIPELINED
     is

     TabDoc  Dbamv.Pkg_Pagu_Documento.TypTabDocObrig;

      vText VARCHAR2(32000) ;

      vItem VARCHAR2(32000)    := '';

      vPosProximoSeparador  NUMBER := 0;

     BEGIN
           vText:= vListPrescs;

     LOOP

        vPosProximoSeparador := InStr(vtext,';');



        SELECT SubStr(vText,0,vPosProximoSeparador - 1 ) INTO vItem FROM  Dual;


        IF vItem IS NULL THEN

            vItem := vText;

        END IF;



        SELECT SubStr(vText,vPosProximoSeparador + 1 ) INTO vText FROM  Dual;


        FOR cItPremed IN (   SELECT  pre.cd_pre_med ,
                                     it.cd_itpre_med ,
                                     pre.dt_referencia ,
                                     it.cd_tip_presc ,
                                     'I' tp_item
                                FROM dbamv.itpre_med it, dbamv.pre_med pre
                                   WHERE it.cd_pre_med = pre.cd_pre_med and  it.cd_pre_med  = vItem

                               UNION ALL

                               SELECT  pre.cd_pre_med ,
                                     it.cd_itpre_med ,
                                     pre.dt_referencia ,
                                     ct.cd_tip_presc ,
                                     'C' tp_item
                                FROM dbamv.itpre_med it, dbamv.pre_med pre,
                                     dbamv.CITPRE_MED ct
                                   WHERE it.cd_pre_med = pre.cd_pre_med and  it.cd_pre_med  = vItem
                                   AND ct.CD_ITPRE_MED = it.CD_ITPRE_MED


                          ) LOOP

                IF cItPremed.tp_item = 'I' THEN

           	        DBAMV.PRC_RETORNA_DOCUMENTOS(cItPremed.cd_pre_med, cItPremed.cd_itpre_med, cItPremed.dt_referencia, TabDoc, 'flex', null, pCdPrestador);

	                  For I In 1..nvl(TabDoc.Last,0) Loop

	                    Pipe Row(TabDoc(I));
                    End Loop;

                END IF;

                IF cItPremed.tp_item = 'C' THEN

                  DBAMV.PRC_RETORNA_DOCUMENTOS(cItPremed.cd_pre_med, cItPremed.cd_itpre_med, cItPremed.dt_referencia, TabDoc, 'flex', cItPremed.cd_tip_presc, pCdPrestador);

	                For I In 1..nvl(TabDoc.Last,0) Loop

	                  Pipe Row(TabDoc(I));

	                End Loop;

                END IF;

        END LOOP cItPremed;


     EXIT WHEN vPosProximoSeparador = 0 OR vPosProximoSeparador is null;

     END LOOP;


   END;

   Procedure Prc_Retorna_Documentos_presc(rCursor OUT TypCur_Ref_Cursor , pCdPrestador IN NUMBER DEFAULT NULL ,vListPrescs VARCHAR2)
    IS
    BEGIN

       OPEN rCursor FOR SELECT tp_forma_preenchimento, sn_obrigatorio, cd_documento, ds_documento, cd_itpre_med , sn_valida_componente, cd_tip_presc
						FROM TABLE(Fnc_Retorna_Documentos_presc( pCdPrestador , vListPrescs )) dual;

    END;

--

End Pkg_MvPep_Wrapper;