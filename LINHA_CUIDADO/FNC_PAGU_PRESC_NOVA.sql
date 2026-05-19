CREATE OR REPLACE FUNCTION DBAMV.FNC_PAGU_PRESC_NOVA( PATENDIMENTO NUMBER
                                   ,pDt_Referencia DATE
                                   ,pTp_Pre_Med Varchar2
                                   ,pCd_Objeto Number
                                   ,pCd_Prestador Number
                                   ,pDt_Pre_Med DATE
                                   ,pHr_Pre_Med DATE
                                   ,pDt_Validade IN OUT DATE
                                   ,pHr_Validade DATE
                                   ,pCd_Cid Varchar2
                                   ,pCd_Diagnostico Number
                                   ,pCd_Setor Number
                                   ,pCd_Unid_Int Number
                                   ,pSn_Presc_Futura Varchar2
                                   ,pSn_Transcricao Varchar2
                                   ,piPre_Pad Number := Null
                                   ,pTp_Acao_Tela varchar2 := null
                                   ,pSn_Dia_Seguinte varchar2 := 'N') -- PDA 201867
                                   Return Pkg_Pagu_ItPreMed.TypRec_PreMed Is
  --
  Cursor C_Diag is
    Select 'X'
      From dbamv.diagnostico_atendime diagAtend
     Where diagAtend.cd_diagnostico_atendime = ( select Max(diag.cd_diagnostico_atendime) diag
                                                   from dbamv.diagnostico_atendime diag
                                                  where diag.cd_atendimento = pAtendimento )
       and diagAtend.cd_diagnostico = pCd_Diagnostico
       and diagAtend.cd_cid         = pCd_Cid;
  --
  Cursor C_Seq_Pre Is
    Select Dbamv.Seq_Pre_Med.NextVal, User_Users.User_Id
      From User_Users;
  --
  Cursor C_Pre_Med( piPad Integer ) Is
    Select Fl_Principal
      From Dbamv.Pre_Med
     Where Cd_Atendimento = pAtendimento
       and Dt_Referencia  = To_Date( pDt_Referencia, 'dd/mm/yyyy hh24:mi:ss' )
       and Tp_Pre_Med     = pTp_Pre_Med
       and Sn_Transcricao = 'N'
       and (piPad Is Null
        or  Cd_Pre_Pad     = piPad );  -->> A prescriï¿½ï¿½o padrï¿½o passada ï¿½ de caminho crï¿½tico
  --
   --PDA 147694(Inicio) - Cursor para retornar o cod.do Hospital.
   Cursor cHospital is
    Select Cd_hospital
      From Dbamv.Hospital
     Where Hospital.Cd_Multi_Empresa = Dbamv.Pkg_Mv2000.Le_Empresa;
  --
    -- PDA 198528 - Sï¿½rgio Fregapani Marques - 20/12/2007
  -- Alterado por Cicero Lisboa em 05/03/2008
  -- Motivo: Nï¿½o ï¿½ necessario validar os setores de objetos como prescricao de internado
  Cursor c_cps is
     select Pagu_Objeto.Nm_Objeto
          , Pagu_Objeto.Tp_Objeto
          , Config_Pagu_Prescricao.Cd_Objeto
          , Config_Pagu_Prescricao.cd_setor_config
          , Config_Pagu_Prescricao.cd_unid_int
          , Config_Pagu_Prescricao.Sn_Presc_Futura
       from dbamv.config_pagu_prescricao
          , Dbamv.Pagu_Objeto
      where Pagu_Objeto.Cd_Objeto = Config_Pagu_Prescricao.Cd_Objeto(+)
        And Pagu_Objeto.Cd_Objeto = pCd_Objeto;
  r_cps c_cps%rowtype;
  vDiagAtendime varchar2(1);

  -- PDA 198528 -- FIM
  vcd_hospital Number;
  --
  CURSOR CTipoDocumento( pTp_Documento VARCHAR2 ) IS
    SELECT Cd_Tipo_Documento
      FROM Dbamv.Pw_Tipo_Documento
     WHERE Tp_Documento = pTp_Documento;
  --
  vPre_Med  Pkg_Pagu_ItPreMed.TypRec_PreMed;
  vId_Usuario Number;
  ncd_documento_clinico  NUMBER;
  nCdTipoDocumento       NUMBER;
  nCdPaciente            NUMBER;
  nDs_Exibicao_Grupo VARCHAR2(15);
  vTpStatus              Varchar2(100);

  CURSOR CGrupoPrescricao IS
    SELECT ogp.Cd_Grupo_Prescricao, ogp.Nr_Ordem_Exibicao, ogp.Ds_Exibicao, gp.Ds_Grupo_Prescricao
      FROM Dbamv.Pw_Objeto_Grupo_Prescricao ogp, Dbamv.Pw_Grupo_Prescricao gp
     WHERE ogp.Cd_objeto = pCd_Objeto
        AND ogp.Cd_Grupo_Prescricao = gp.Cd_Grupo_Prescricao
     ORDER BY ogp.Nr_Ordem_Exibicao;
  --
  -- PDA 524030 (inicio)
  --
  Cursor cSetor Is
     Select Sn_Ativo
       From Dbamv.Setor
      Where Cd_Setor = pCd_Setor;
     --
  vSn_Setor_Ativo Varchar2(1);
  --
  -- PDA 524030 (fim)
  --
  --OP 23158 (inicio)
  Cursor C_Prestador( pPresta Number ) Is
     Select PreMed_Tip_Presta.Cd_Tip_Presta
       From Dbamv.PreMed_Tip_Presta
           ,Dbamv.Prestador
      Where Prestador.Cd_Prestador   = pPresta
        And PreMed_Tip_Presta.Cd_Tip_Presta (+)= Prestador.Cd_Tip_Presta;
  vPrest  C_Prestador%RowType;
  --
  Cursor C_Prescricao is
     Select Pre_Med.Nm_Usuario
           ,prestador.cd_tip_presta
           ,Pre_Med.Tp_Pre_Med
       From Dbamv.Pre_Med
           ,Dbamv.Prestador
      Where Cd_Atendimento = pAtendimento
        And Tp_Pre_Med     = pTp_Pre_Med
        And ( ( Fl_Impresso     = 'N'
        and     Sn_Transcricao  = 'N' )
         or   ( Dt_Referencia   > pDt_Referencia )  )
        And pre_med.cd_prestador = prestador.cd_prestador;
  --
  vPrescricao     C_Prescricao%RowType;
  vPrescAberta    Number;
  vNmPrestaAberta Varchar2(30);
  --
  Cursor C_PrescAberta Is
    Select  Cd_Pre_Med
           ,Dt_Pre_Med
           ,Nm_Usuario
      From Dbamv.Pre_Med
     Where Cd_Atendimento       = pAtendimento
       And Nvl(Fl_Impresso,'N') = 'N'
       And Nvl(Tp_Pre_med,'M')  = 'M'
    Order By Dt_Pre_Med  desc;

	Cursor C_Atendimento IS
		Select a.Tp_Atendimento Tp_Atendimento
		     , Dbamv.Fnc_Mv_Recupera_Data_Hora(a.Dt_Atendimento, a.Hr_Atendimento) Dh_Atendimento
			 , Dbamv.Fnc_Mv_Recupera_Data_Hora(a.Dt_Alta, a.Hr_Alta) Dh_Alta
		  From Dbamv.Atendime a
		 Where a.Cd_Atendimento = pAtendimento;

  vValidaPrescAbert C_PrescAberta%RowType;
  rAtendimento     C_Atendimento%Rowtype;
  dDtValidPrescTrt DATE := NULL;
  -- OP 23158 (fim)
  Procedure CHK_CONSUMO_NAO_LANCADO( pAtend Number, pDh_Check Date, pSetor Number ) Is
    v_mensagem  Varchar2(200);
  v_funcao    Number:= 0;
   BEGIN
   v_funcao:= dbamv.F_Proibe_Movimentacao(pAtend
                                         ,pDh_Check
                                         ,'PAGU'
                                         ,pSetor
                                         ,'P'
                                         -- PDA 123016 (Inicio) - Henrique Antunes - 06/07/2005
                                         ,pDh_Check
                                         -- PDA 123016 (Fim)
                                         ,v_mensagem);
    if nvl(v_funcao,0) = 1 then
       Raise_Application_Error(-20600,v_mensagem);
   end if;
  END;
  --
Begin
  --PDA 147694(Inicio)- A validaï¿½ï¿½o da checagem de 24hs tinha sido comentada. GGMS-27/03/06. Liberada apenas pro HSR.
  Open cHospital;
  Fetch cHospital Into vcd_hospital;
  --
  --PDA 147694(Fim)
  -- PDA 198528 -- Sï¿½rgio Fregapani Marques - 20/12/2007
  -- Alterado por Cicero Lisboa em 05/03/2008
  -- Motivo: As regras de negocio estavam erradas, precisamos validar os tipos de prescricao que nï¿½o sao mï¿½dicas
  open c_cps;
  fetch c_cps into r_cps;
  if (c_cps%notfound Or (R_Cps.Cd_Objeto Is Null And R_Cps.Tp_Objeto Not In ('INTERN','ADMISS'))) then
     close c_cps;
      --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_1)
      Raise_Application_Error(-20600,pkg_rmi_traducao.extrair_proc_msg('MSG_1', 'FNC_PAGU_PRESC_NOVA', 'Setor/Unidade não configurado para o Tipo de Objeto.'));
     Return vPre_Med;
  else
     close c_cps;
  end if;
  If Pkg_Pagu.Fn_Atendimento(pAtendimento).Tp_Atendimento In ('I','H','B') And
     R_Cps.Tp_Objeto In ('INTERN') Then
     --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_2)
     Raise_Application_Error(-20600,pkg_rmi_traducao.extrair_proc_msg('MSG_2', 'FNC_PAGU_PRESC_NOVA', 'Prescrição de internado só pode ser criada em atendimentos ambulatoriais!'));
     Return vPre_Med;
  End If;
  -- PDA 198528 FIM
  --
  -- PDA 524030 (inicio)
  Open  cSetor;
  Fetch cSetor Into vSn_Setor_Ativo;
  Close cSetor;
  --
  If vSn_Setor_Ativo = 'N' Then
     --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_25)
     Raise_Application_Error(-20530, pkg_rmi_traducao.extrair_proc_msg('MSG_25', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Não é possível criar uma Prescrição para um Setor inativo.'));
  End If;
  --
  -- PDA 524030 (fim)
  --
  Begin
    --
    --PDA 143352(Inicio)- Inicializando a variï¿½rel.
    --Default_Value( '0', 'Global.Cd_Pre_Pad' );
    --
	Open C_Atendimento;
		Fetch C_Atendimento Into rAtendimento;
	Close C_Atendimento;

    -- *** Validaï¿½ï¿½es ***
    If Nvl( Dbamv.Verif_Licenca_Prestador( pCd_Prestador, pDt_Pre_Med ), 'N' ) = 'S' Then
       --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_3)
       Raise_Application_Error(-20600,pkg_rmi_traducao.extrair_proc_msg('MSG_3', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Este Médico esta de licença nesta data.'));
       Return vPre_Med;
    End If;
    If Pkg_Pagu.Fn_Config_Pagu().Sn_Cid = 'S' and pCd_Cid is null and pTp_Pre_Med in ('M', 'A', 'F') and pSn_Transcricao = 'N' and R_Cps.Tp_Objeto != 'TRATMT' Then
   --    Go_Item( 'Nova_Pre_Med.Cd_Cid' );
       --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_4)
       Raise_Application_Error(-20600,pkg_rmi_traducao.extrair_proc_msg('MSG_4', 'FNC_PAGU_PRESC_NOVA', 'Atenção: CID obrigatório para o Atendimento.'));
       Return vPre_Med;
    End If;
    --
    --PDA 160053 (Inicio)ggms- Colocada a mesma atribuiï¿½ï¿½o que ï¿½ feita no W-V-I, pois em alguns momentos nï¿½o estï¿½ entrando
    --                         na validaï¿½ï¿½o do campo dt_validade.
    pDt_Validade := Fnc_Mv_Recupera_Data_Hora( pDt_Validade, pHr_Validade );
    --PDA 160053 (Fim)
    If Fnc_Mv_Recupera_Data_Hora( pDt_Pre_Med, pHr_Pre_Med ) > pDt_Validade Then
       --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_5)
       Raise_Application_Error(-20600,pkg_rmi_traducao.extrair_proc_msg('MSG_5', 'FNC_PAGU_PRESC_NOVA', 'Atenção: A data de validade está menor que a data da Prescrição.'));
       Return vPre_Med;
    End If;
    --
    -- *** Configurado com o CID obrigatï¿½rio ***
    If pTp_Pre_Med = 'M'
	  and R_Cps.Tp_Objeto != 'TRATMT'
      and Pkg_Pagu.Fn_Config_Pagu().Sn_Cid = 'S'
      and pCd_Diagnostico Is Null
      and pCd_Cid Is Null
	  and pSn_Transcricao = 'N' Then
       --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_6)
       Raise_Application_Error(-20600,pkg_rmi_traducao.extrair_proc_msg('MSG_6', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Não será possível criar uma Prescrição nova%sMotivo.: É obrigatório informar o Diagnóstico ou CID%sAção...: Informe um Diagnóstico para o paciente', arg_list(chr(10), chr(10))));
       Return vPre_Med;
    End If;
    --
    -- *** Verifica se a data da prescriï¿½ï¿½o estï¿½ dentro do perï¿½odo de atendimento
    --PDA 317049 --Foi retirada a validaï¿½ï¿½o dos segundos.

    IF R_Cps.Tp_Objeto = 'TRATMT'  THEN
       dDtValidPrescTrt:= To_Date (to_char(SYSDATE ,'DD/MM/YYYY hh24:mi'),'DD/MM/YYYY hh24:mi');
    END IF;

    If (rAtendimento.Tp_Atendimento In ('I','H','B','E')   -- PDA 154034 --PDA 428729
     and to_date(To_Char(Fnc_Mv_Recupera_Data_Hora( pDt_Pre_Med,Nvl(dDtValidPrescTrt,pHr_Pre_Med) ),'DD/MM/YYYY hh24:mi'),'DD/MM/YYYY hh24:mi')
                                       < To_Date (to_char(rAtendimento.Dh_Atendimento,'DD/MM/YYYY hh24:mi'),'DD/MM/YYYY hh24:mi'))
      or (R_Cps.Tp_Objeto != 'TRATMT'
		and to_date(To_Char(Fnc_Mv_Recupera_Data_Hora( pDt_Pre_Med, pHr_Pre_Med ),'DD/MM/YYYY hh24:mi'),'DD/MM/YYYY hh24:mi')  -- PDA 154034
                                       > To_Date (to_char(rAtendimento.Dh_Alta,'DD/MM/YYYY hh24:mi'),'DD/MM/YYYY hh24:mi')) Then
       --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_7)
       Raise_Application_Error(-20600,pkg_rmi_traducao.extrair_proc_msg('MSG_7', 'FNC_PAGU_PRESC_NOVA', 'Atenção: A data da Prescrição esta fora do período da Internação, Admissão(%s) - Alta(%s)', arg_list(Pkg_Pagu.Fn_Atendimento(pAtendimento).Dh_Atendimento, Pkg_Pagu.Fn_Atendimento(pAtendimento).Dh_Alta)));

       Return vPre_Med;
    -- vPre_Med.Tp_Objeto != 'TRATMT' - Alteraï¿½ï¿½o para o tratamento pep - Gilberto C. Lupatini
    Elsif Pkg_Pagu.Fn_Atendimento(pAtendimento).Tp_Atendimento Not In ('I','H','B','E')  -- PDA 154034 --PDA 428729
      and Fnc_Mv_Recupera_Data_Hora( pDt_Pre_Med, pHr_Pre_Med ) > (Pkg_Pagu.Fn_Atendimento(pAtendimento).Dh_Atendimento + 1)
      and Nvl(pSn_Presc_Futura,'N') <> 'S'
      AND R_Cps.Tp_Objeto != 'TRATMT'
      AND Nvl(Dbamv.PKg_Mv2000.Le_Configuracao('PAEU', 'SN_REALIZA_ALTA_APOS_24_HORAS'),'N') = 'N'
      Then  -->> Pda 185994
      --
      if pTp_Acao_Tela = 'EVO'  then
       --
         --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_8)
         Raise_Application_Error(-20600, pkg_rmi_traducao.extrair_proc_msg('MSG_8', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Não será possível criar a evolução%sMotivo.: Este tipo de atendimento só permite evoluir no dia de seu atendimento%sAção...: Informe a data de referência para: %s', arg_list(chr(10), chr(10), to_char(Pkg_Pagu.Fn_Atendimento(pAtendimento).Dh_Atendimento,'dd/mm/yyyy'))));
       --
      else
      --
         --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_9)
         Raise_Application_Error(-20600, pkg_rmi_traducao.extrair_proc_msg('MSG_9', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Não será possível criar a Prescrição%sMotivo.: Este tipo de atendimento só permite prescrever no dia de seu atendimento%sAção...: Informe a data de referência para: %s', arg_list(chr(10), chr(10), to_char(Pkg_Pagu.Fn_Atendimento(pAtendimento).Dh_Atendimento,'dd/mm/yyyy'))));
       --
       end if;
       Return vPre_Med;
      --
    End If;
    --

    If dbamv.pkg_mv2000.le_cliente  <>  970 Then
      -- Validaï¿½ï¿½o de Movimentaï¿½ï¿½es para Evitar Consumos Nï¿½o Lanï¿½ados
      If pAtendimento is not null and pDt_Referencia Is Not Null and R_Cps.Tp_Objeto != 'RECEIT' and R_Cps.Tp_Objeto != 'TRATMT' and
         -- PDA 217969 (inicio)
         (pTp_Pre_Med in ('M','E') and nvl(pSn_Presc_Futura, 'N') = 'N') Then
         -- PDA 217969 (fim
         Chk_Consumo_Nao_Lancado( pAtendimento
                                 ,Fnc_Mv_Recupera_Data_Hora(pDt_Pre_Med, pHr_Pre_Med)
                                 ,pCd_Setor );
      End If;
    End If;
    --
    -- *** Dados da Prescriï¿½ï¿½o padrï¿½o selecionada ***
    If piPre_Pad Is Not Null Then
      --
      If Pkt_Pre_Pad.Retorna_Campo(piPre_Pad,'Tp_Pre_Pad') <> 'A' and pTp_Pre_Med <> Pkt_Pre_Pad.Retorna_Campo(piPre_Pad,'Tp_Pre_Pad') Then
        --
        --
       --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_10)
       Raise_Application_Error(-20600,pkg_rmi_traducao.extrair_proc_msg('MSG_10', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Prescrição padrão selecionada não é valida%sMotivo.: Tipo clínico da Prescrição padrão diferente do tipo desta Prescrição%sAção...: Selecionar outra Prescrição padrão', arg_list(chr(10), chr(10))));
       Return vPre_Med;
      End If;
      --
    End If;
    --
    vPre_Med.Cd_Atendimento := pAtendimento;
    vPre_Med.Cd_Prestador   := pCd_Prestador;
    vPre_Med.Cd_Unid_Int    := pCd_Unid_Int;
    vPre_Med.Dh_Pre_Med     := Fnc_Mv_Recupera_Data_Hora( pDt_Pre_Med,  pHr_Pre_Med );
    vPre_Med.Dh_Validade    := Fnc_Mv_Recupera_Data_Hora( pDt_Validade, pHr_Validade );
    if pCd_Cid Is Not Null --caminho critico rep (alterando o cid)
      and pCd_Cid <> Nvl(Pkg_Pagu.Fn_Atendimento( vPre_Med.Cd_Atendimento ).Cd_Cid,'0') Then
      --
      Update Dbamv.Atendime
         Set Cd_Cid = pCd_Cid
       Where Cd_Atendimento = vPre_Med.Cd_Atendimento;
      --
    End If;
    --
    -- *** Identifica se a prescriï¿½ï¿½o a ser criada ï¿½ a principal ***
    If piPre_Pad Is Not Null Then     -- PDA 251950
      Open  C_Pre_Med( Pkt_Pre_Pad.Retorna_Campo(piPre_Pad,'Cd_Pre_Pad') );  -->> Verifica se a prescriï¿½ï¿½o padrï¿½o selecionada automaticamente jï¿½ foi criada
    Else
      Open  C_Pre_Med( Null );
    End If;
    --
    Fetch C_Pre_Med Into vPre_Med.Fl_Principal;  -->> Foi usado a variï¿½vel ao lado na clausula into para nï¿½o ter de criar uma nova variï¿½vel
    If C_Pre_Med%NotFound Then
      vPre_Med.Fl_Principal   := 'S';  -->> Indica que ï¿½ a primeira prescriï¿½ï¿½o o dia
    Else
      vPre_Med.Fl_Principal   := 'N';  -->> Indica que ï¿½ uma intercorrï¿½ncia
    End If;
    --
    -->> Pda 185994 (Inicio)
    -- *** Prescriï¿½ï¿½o futura ***
    If pSn_Presc_Futura = 'S' Then
      vPre_Med.Tp_Pre_Med   := 'F';
    Else
      vPre_Med.Tp_Pre_Med := pTp_Pre_Med;
      If R_Cps.Tp_Objeto = 'INTERN' Then
         vPre_Med.Tp_Pre_Med := 'A';
      ElsIf R_Cps.Tp_Objeto = 'ADMISS' Then
         vPre_Med.Tp_Pre_Med := 'I';
      End If;
    End If;
    -->> Pda 185994 (Fim)
    --
    vPre_Med.Nm_Usuario     := dbamv.pkg_mv_variaveis.fnc_get_usuario;
    vPre_Med.Cd_Setor       := pCd_Setor;
    vPre_Med.Dt_Referencia  := pDt_Referencia; --PDA 296031
    vPre_Med.Sn_Transcricao := pSn_Transcricao;
    --
    -- *** Se jï¿½ tiver uma prescriï¿½ï¿½o aberta, serï¿½ nela que os itens serï¿½o incluï¿½dos ***
    If Pkg_Pagu_ItPreMed.Fn_PreMed().Cd_Pre_Med Is Null
      or Pkg_Pagu_ItPreMed.Fn_PreMed().Nm_Usuario <> Pkg_Mv_Variaveis.fnc_get_usuario() Then  --**
      --
      -- para prescriï¿½ï¿½o de tratamento irï¿½ utilizar documento clinico do tipo TRATMT para os demais serï¿½ PRESCR
      IF R_Cps.Tp_Objeto  <> 'TRATMT' THEN
		  IF pTp_Acao_Tela = 'EVO' THEN -- [OP1517] AJVC
          OPEN  CTipoDocumento( 'EVOMED' );
        ELSIF pTp_Acao_Tela = 'AVA' THEN -- [OP24001] LHBG
          OPEN  CTipoDocumento( 'AVAFAR' );
        ELSE
		     if(vPre_Med.Tp_Pre_Med = 'E') THEN
		            OPEN  CTipoDocumento( 'ENFERM' );
        ELSIF(vPre_Med.Tp_Pre_Med = 'A') THEN
		            OPEN  CTipoDocumento( 'INTERN' );
        ELSE
				      	OPEN  CTipoDocumento( 'PRESCR' );
              END IF;
        END IF;
        FETCH CTipoDocumento INTO nCdTipoDocumento;
        IF CTipoDocumento%NOTFOUND THEN
          CLOSE CTipoDocumento;
          --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_11)
          Raise_Application_Error(-20601,pkg_rmi_traducao.extrair_proc_msg('MSG_11', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Não será possível criar esta Prescrição%sMotivo.: Falta o tipo de documento "PRESCR" na tabela PW_TIPO_DOCUMENTO%sAção...: Informar a TI para tomar prodidências', arg_list(chr(10), chr(10))));
        END IF;
        CLOSE CTipoDocumento;
      ELSE
        OPEN  CTipoDocumento('TRATMT');
        FETCH CTipoDocumento INTO nCdTipoDocumento;
        IF CTipoDocumento%NOTFOUND THEN
          CLOSE CTipoDocumento;
          --MULTI-IDIOMA: Utilizaï¿½ï¿½o do pkg_rmi_traducao.extrair_msg para mensagens (MSG_26)
          Raise_Application_Error(-20601,pkg_rmi_traducao.extrair_proc_msg('MSG_26', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Não será possível criar esta Prescrição%sMotivo.: Falta o tipo de documento "TRATMT" na tabela PW_TIPO_DOCUMENTO%sAção...: Informar a TI para tomar prodidências', arg_list(chr(10), chr(10))));
        END IF;
        CLOSE CTipoDocumento;
      END IF;

      --obs.: Nï¿½O serï¿½o criados documentos clinicos para prescriï¿½ï¿½es filhas da prescriï¿½ï¿½o de tratamento.
      -- verifica se nï¿½o ï¿½ prescriï¿½ï¿½o de tratamento, caso nï¿½o for cria documento clï¿½nico,
      -- caso for prescriï¿½ï¿½o de tratamento somente irï¿½ criar documento clï¿½nico na pre_med pai.
      IF R_Cps.Tp_Objeto <> 'TRATMT' OR vPre_Med.Tp_Pre_Med <> 'F' AND R_Cps.Tp_Objeto = 'TRATMT' THEN
        -- Obtï¿½m o cï¿½digo para inserir na pw_documento_clinico
        select dbamv.seq_pw_documento_clinico.nextval
          into ncd_documento_clinico
          from dual;
        --
        nCdPaciente := dbamv.pkg_pagu.fn_atendimento(vPre_Med.Cd_Atendimento).Cd_Paciente;
        --Raise_Application_Error(-20999,'ncd_documento_clinico: ' || ncd_documento_clinico);
        -- Inserindo no documento clinico, tabela esta que consolida todos os documentos de prontuï¿½rio passï¿½veis de impressï¿½o
		    insert into dbamv.pw_documento_clinico (cd_documento_clinico
                                              ,cd_tipo_documento
                                              ,tp_status
                                              ,dh_referencia
                                              ,dh_criacao
                                              ,dh_fechamento
                                              ,dh_impresso
                                              ,cd_paciente
                                              ,cd_prestador
                                              ,cd_atendimento
                                              ,cd_usuario
											  ,cd_objeto
											  ,dh_documento)
		                                  values (ncd_documento_clinico
                                              ,nCdTipoDocumento
                                              ,'ABERTO'  -->> tp_status
                                              ,vPre_Med.Dt_Referencia
                                              ,SYSDATE
                                              ,NULL
                                              ,Null
                                              ,nCdPaciente
                                              ,vPre_Med.Cd_Prestador
                                              ,vPre_Med.Cd_Atendimento
                                              ,vPre_Med.Nm_Usuario
											  ,pCd_Objeto
											  ,vPre_Med.Dh_Pre_Med);
      END IF;

      -- *** Cria a nova prescriï¿½ï¿½o ***
      Open  C_Seq_Pre;
      Fetch C_Seq_Pre Into vPre_Med.Cd_Pre_Med, vId_Usuario;
      Close C_Seq_Pre;
      --
      -- OP 23158 (inicio)
	  If Nvl(dbamv.pkg_mv2000.le_formulario,'N') <> 'MVPEP' Then
		  Open  C_PrescAberta;
		  Fetch C_PrescAberta Into vValidaPrescAbert;
		  Close C_PrescAberta;
		  --
			-- PDA 276701(Inicio) - Realizado tratamento para nï¿½o permitir que dois usuï¿½rios diferentes abram prescriï¿½ï¿½o para o mesmo atendimento ao mesmo tempo.
			vPrescAberta := dbamv.Fnc_Pagu_Retorna_Presc_Aberta(pAtendimento, pTp_Pre_Med, pSn_Transcricao );
			--
			vNmPrestaAberta := Dbamv.Pkg_Pagu_ItPreMed.Fn_Retorna_PreMed(vPrescAberta).Nm_Usuario;
			--
			If Nvl(vPrescAberta,0) <> 0 Then
			 Raise_Application_Error(-20601,pkg_rmi_traducao.extrair_proc_msg('MSG_11', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Existe outra Prescrição sendo feita pelo usuário: "'
									|| vValidaPrescAbert.Nm_Usuario
									  || '" no dia: ' || To_Char(vValidaPrescAbert.Dt_pre_med, 'dd/mm/yyyy' )
									  || ',para o atendimento selecionado. Prescrição:'||vPrescAberta -- OP 22402 - Adicionado "Prescriï¿½ï¿½o:"
									  || chr(10) || 'Não é permitido prescrever para o mesmo paciente simultaneamente', arg_list(chr(10), chr(10))));
			End If;
			--
			Open  C_Prescricao;
		  Fetch C_Prescricao Into vPrescricao;
		  Close C_Prescricao;
		  --
		  Open  c_prestador(pkg_pagu.fn_prestador().cd_prestador);
		  Fetch c_prestador into vPrest;
		  Close c_prestador;
		  --
			If vPre_Med.Nm_Usuario Is Not Null and vPre_Med.Nm_Usuario != Dbamv.Pkg_Mv_Variaveis.Fnc_Get_Usuario Then
				 If (pSn_Transcricao = 'N' and vPrescricao.Tp_Pre_Med = 'M') or (vPrescricao.Tp_Pre_Med = 'E' and vPrest.cd_tip_presta = vPrescricao.cd_tip_presta) then
					  --
					  Raise_Application_Error(-20601,pkg_rmi_traducao.extrair_proc_msg('MSG_26', 'FNC_PAGU_PRESC_NOVA', 'Atenção: Existe outra Prescrição sendo feita pelo usuário: "'|| vPrescricao.NM_USUARIO|| ',para o atendimento selecionado.'
										  || chr(10) || 'Não é permitido prescrever para o mesmo paciente simultaneamente', arg_list(chr(10), chr(10))));
				 End If;
			End If;
	  End If;
      --
  	  -- OP 23158 (fim)
      --
      Insert Into Dbamv.Pre_Med ( Cd_Pre_Med
                                 ,Cd_Atendimento
                                 ,Cd_Prestador
                                 ,Cd_Unid_Int
                                 ,Dt_Pre_Med
                                 ,Hr_Pre_Med
                                 ,Ds_Evolucao
                                 ,Cd_Id_Usuario
                                 ,Cd_SolSai_Pro
                                 ,Sn_Fechado
                                 ,Sn_Rn
                                 ,Dt_Validade
                                 ,Fl_Principal
                                 ,Fl_Impresso
                                 ,Tp_Pre_Med
                                 ,Nm_Usuario
                                 ,Cd_Setor
                                 ,Dt_Referencia
                                 ,Sn_Transcricao
                                 ,Dh_Criacao
                                 ,Cd_Pre_Pad
                                 ,cd_objeto -- PDA 198528 - Sï¿½rgio Fregapani Marques - 30/10/2007
                                 ,cd_documento_clinico
								                 ,sn_prescricao_dia_seguinte) -- PDA 201867
                         Values ( vPre_Med.Cd_Pre_Med
                                 ,vPre_Med.Cd_Atendimento
                                 ,vPre_Med.Cd_Prestador
                                 ,vPre_Med.Cd_Unid_Int
                                 ,Trunc(vPre_Med.Dh_Pre_Med)
                                 ,trunc(vPre_Med.Dh_Pre_Med,'mi')
                                 ,Null         -- vPre_Med.Ds_Evolucao
                                 ,vId_Usuario  -- vPre_Med.Cd_Id_Usuario
                                 ,Null         -- vPre_Med.Cd_SolSai_Pro
                                 ,'N'          -- vPre_Med.Sn_Fechado
                                 ,'N'          -- vPre_Med.Sn_Rn
                                 ,vPre_Med.Dh_Validade
                                 ,vPre_Med.Fl_Principal
                                 ,'N'          -- vPre_Med.Fl_Impresso
                                 ,vPre_Med.Tp_Pre_Med  -->> Pda 185994
                                 ,vPre_Med.Nm_Usuario
                                 ,vPre_Med.Cd_Setor
                                 ,vPre_Med.Dt_Referencia
                                 ,vPre_Med.Sn_Transcricao
                                 ,Sysdate
                                 ,piPre_Pad
                                 ,pCd_Objeto -- PDA 198528 - Sï¿½rgio Fregapani Marques - 30/10/2007
                                 ,ncd_documento_clinico
								                 ,pSn_Dia_Seguinte); -- PDA 201867
                                 --PDA 143352(Inicio)- Alterado para pegar o cod.da prescriï¿½ï¿½o padrï¿½o corretamente.
      --
      Pkg_Pagu_ItPreMed.Pr_PreMed( vPre_Med );  -->> Indica da criaï¿½ï¿½o da prescriï¿½ï¿½o

	  For pGrupo In CGrupoPrescricao Loop
        If pGrupo.Ds_Exibicao Is Null Or Trim(pGrupo.Ds_Exibicao) = '' Then
            nDs_Exibicao_Grupo := pGrupo.Ds_Grupo_Prescricao;
        Else
            nDs_Exibicao_Grupo := pGrupo.Ds_Exibicao;
        End if;

        Insert Into Dbamv.Pw_Grupo_Prescricao_Itpre_Med (Cd_Grupo_Prescricao_Itpre_Med,
                                                         Cd_Grupo_Prescricao,
                                                         Cd_Pre_Med,
                                                         Ds_Exibicao,
                                                         Nr_Ordem_Exibicao)
                                                 Values (Seq_Grupo_Prescricao_Itpre_Med.NextVal,
                                                         pGrupo.Cd_Grupo_Prescricao,
                                                         vPre_Med.Cd_Pre_Med,
                                                         nDs_Exibicao_Grupo,
                                                         pGrupo.Nr_Ordem_Exibicao);
      End Loop;

      Open  C_Diag;
      Fetch C_Diag into vDiagAtendime;
      --
      If C_Diag%notfound Then
         If   pCd_Diagnostico  is not null  Then
         --
         Pkg_Pagu_Diagnostico_Atendime.Insere( vPre_Med.Cd_Atendimento
                                              ,pCd_Diagnostico
                                              ,pCd_Cid
                                              ,vPre_Med.Cd_Pre_Med
                                              ,null
                                              ,null );
        End if;
         --
      End if;
      --
      Close C_Diag;
      --
   Else
      vPre_Med.Cd_Pre_Med := Pkg_Pagu_ItPreMed.Fn_PreMed().Cd_Pre_Med;
   End If; -->> Criaï¿½ï¿½o da Prescriï¿½ï¿½o
   --
  Return vPre_Med;
  --
 End;
end;