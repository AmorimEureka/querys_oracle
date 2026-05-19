CREATE OR REPLACE PROCEDURE DBAMV.PRC_PAGU_FECHAR_PRESCRICAO ( PIPREMED INTEGER, PVNM_USUARIO_AUTORIZADOR VARCHAR2 DEFAULT NULL) IS
  --
  vRecPre_Med      Pkg_Pagu_ItPreMed.TypRec_PreMed;
  --
  vTp_Aprazamento             Varchar2(2); --PDA 288861
  vTp_Suspende_Sol_Farm_Presc Varchar2(50); -- OP 39982
  --
  Cursor cEvolucao Is -- OP 29467 (inicio)
     Select Ds_Evolucao
       From Dbamv.Pre_Med
      Where Cd_Pre_Med = piPreMed;
  --
  vDs_Evolucao Varchar2(32000); -- OP 29467 (fim)
  --

Cursor cPreMed Is
   Select Pre_Med.Cd_Setor
        , Pre_Med.Cd_Atendimento
        , Pre_Med.Dt_Referencia
        , Pre_Med.Tp_Pre_Med
        , Count(Cd_Itpre_Med) Qt_Itens
        , Pre_Med.Cd_unid_int
        , Pagu_Objeto.Tp_Objeto     -- Pda 449044
        , Pagu_Objeto.Cd_Objeto
        , Pre_Med.Cd_Pre_Med_Tratmt -- Pda 449044
        , Pre_Med.Cd_Documento_Clinico
        , Pre_med.dt_pre_med
        , Pre_med.NM_USUARIO
        , Dbamv.Fnc_Mv_Recupera_Data_Hora (Pre_med.Dt_Pre_Med, Pre_Med.Hr_Pre_Med) Dh_Pre_Med -- OP 39982
     From Dbamv.Itpre_Med
        , Dbamv.Pre_Med
        , Dbamv.Pagu_Objeto -- Pda 449044
   Where Pre_Med.Cd_Pre_Med = piPreMed
     and ItPre_Med.Cd_Pre_Med (+)= Pre_Med.Cd_Pre_Med
     And Pre_Med.Cd_Objeto  = Pagu_Objeto.Cd_Objeto (+) -- Pda 449044
   Group By Pre_Med.Cd_Setor
          , Pre_Med.Cd_Atendimento
          , Pre_Med.Dt_Referencia
          , Pre_Med.Tp_Pre_Med
          , Pre_Med.Cd_unid_int
          , Pagu_Objeto.Tp_Objeto      -- Pda 449044
          , Pagu_Objeto.Cd_Objeto
          , Pre_Med.Cd_Pre_Med_Tratmt -- Pda 449044
          , Pre_Med.Cd_Documento_Clinico
		      , Pre_med.dt_pre_med
          ,Pre_med.NM_USUARIO
          , Dbamv.Fnc_Mv_Recupera_Data_Hora (Pre_med.Dt_Pre_Med, Pre_Med.Hr_Pre_Med);  --
   rPreMed  cPreMed%RowType;
   --
   Cursor C_Apraz Is
     Select Cd_Fechamento
          , Cd_Setor
          , Cd_Unid_int
       From Dbamv.Fechamento_Pagu
      Where Cd_Pre_Med = piPreMed
        and Tp_Fechamento = 'A' -->> Aprazamento quando é automático
        and Dh_Fechamento Is Null; -->> Só considera os aprazamentos abertos
   --
   rApraz  C_Apraz%Rowtype;
   --
   Cursor C_Setor_unid_int(pCdUnidInt in number) is
      select cd_setor
        from Dbamv.Unid_Int
       where cd_unid_int = pCdUnidInt;
   --
   rCdSetorUnidInt C_Setor_unid_int%Rowtype;

  -- Função para recuperar a configuração do PAGU
   Cursor C_Config_Pagu_TpObjeto (pCd_Obj In Varchar2) is
    Select CD_CONFIGURACAO_PAGU_PRESC, SN_PRESC_FUTURA, CD_OBJETO,
           TP_CENTRO_CUSTO, CD_SETOR, CD_SETOR_CONFIG, CD_UNID_INT
      From Dbamv.Config_Pagu_Prescricao
     Where Cd_Objeto = pCd_Obj
     Order By Nvl( Cd_Setor, 0 );
   --
   vConfig_Pagu_TpObj C_Config_Pagu_TpObjeto%ROWTYPE;
   --
   vFlPrincipal  Varchar2(01);  -->> Inicializado com Null
   --
    vConfChecagem Varchar2(01);
   --
    bAptaParaAprazar Boolean := True; -- Pda 449044
   --
   Cursor cData_Atualiza_Alta is  -- Pda 481387
      Select dh_inicial
     from dbamv.prE_med,
          dbamv.itpre_med
          ,dbamv.tip_presc
    where pre_med.cd_pre_med = piPreMed
      and pre_med.cD_pre_med= itpre_med.cd_pre_med
      AND tip_presc.cd_tip_presc =   itpre_med.cd_tip_presc
       AND tip_presc.tp_tip_presc = 'M' ;
	   --
   	vData_Atualiza_Alta date;   -- Pda 481387

   Cursor cConfigPaguSetor( p_cd_setor Number, pTp_Pre_Med In Varchar2 ) Is
   Select Tp_Aprazamento, Decode(pTp_Pre_Med, 'E', Tp_Suspende_Sol_Farm_Presc_Enf, Tp_Suspende_Sol_Farm_Presc_Med) Tp_Suspende_Sol_Farm
     From Dbamv.Config_Pagu_Setor
    Where Cd_Setor = p_cd_setor;
   --
   Cursor cAvaliacao Is
    Select 'S' Sn_Presc_Interv_Farmaceutica
      From Dbamv.Pw_Avaliacao_Pre_Med
     Where Cd_Pre_Med_Substituta = piPreMed;
   --
   rAvaliacao cAvaliacao%ROWTYPE;
   --
  --PDA 423873 - Retorna os dados para o processo de prorrogação atm -- PDA 538560 (inicio)
  CURSOR cDadosProrrogacao (pCdPreMed NUMBER )is
    SELECT tip_presc.cd_produto,
           itpre_med.nr_dia,
           itpre_med.cd_itpre_med
      FROM dbamv.itpre_med,
           dbamv.tip_presc
     where itpre_med.cd_tip_presc = tip_presc.cd_tip_presc
       AND itpre_med.cd_pre_med   = pCdPreMed;
  --
  CURSOR cTipoObjeto (pCdPreMed NUMBER )is
    SELECT pw_tipo_documento.tp_documento
      FROM dbamv.pre_med
         , dbamv.pagu_objeto
         , dbamv.pw_tipo_documento
     where pre_med.cd_objeto             = pagu_objeto.cd_objeto
       AND pagu_objeto.cd_tipo_documento = pw_tipo_documento.cd_tipo_documento
       AND pre_med.cd_pre_med            = pCdPreMed;
  --
  CURSOR cPreMedCopiada (pCdPreMed NUMBER )is
    SELECT DISTINCT(item.cd_pre_med)
      FROM dbamv.itpre_med item
     WHERE EXISTS (SELECT itpre_med.cd_itpre_med_copia
                     FROM dbamv.itpre_med
                    WHERE itpre_med.cd_itpre_med_copia = item.cd_itpre_med
                      AND itpre_med.cd_itpre_med_copia IS NOT NULL
                      AND itpre_med.cd_pre_med = pCdPreMed);

CURSOR cIsPremedSubstituta IS
    SELECT 'S'
      FROM Dbamv.Pw_Avaliacao_Pre_med p
     WHERE p.cd_pre_med_substituta = piPreMed;
  vDadosProrrogacao cDadosProrrogacao%ROWTYPE;
  vMensagem        VARCHAR2(3000) := NULL;
  vAcaoProrrogacao VARCHAR2(1);
  vcTipoObjeto     cTipoObjeto%RowType;
  vExistePremedSubstituta VARCHAR2(1);
  --
  FUNCTION Fnc_verif_tp_susp_sol_farmacia(pTp_Suspende_Sol_Farm Varchar2) RETURN BOOLEAN IS
  BEGIN

	IF Nvl(pTp_Suspende_Sol_Farm, '') = 'ITEM' Or Nvl(pTp_Suspende_Sol_Farm, '') = 'PRESCRICAO' Or Nvl(pTp_Suspende_Sol_Farm, '') = 'DATA_REFERENCIA' THEN
		RETURN true;
	ELSE
		RETURN false;
	END IF;

  END;
  --
BEGIN
  Open  cData_Atualiza_Alta; -- Pda 481387
  Fetch cData_Atualiza_Alta Into vData_Atualiza_Alta;
  Close cData_Atualiza_Alta;
  -- Pda 481387 inicio
  Dbamv.Prc_Pagu_Valida_Previs_Alta (Pkg_Pagu_ItPreMed.Fn_PreMed().Cd_Pre_Med);
	vData_Atualiza_Alta := Fnc_Mv_Recupera_Data_Hora(vData_Atualiza_Alta ,vData_Atualiza_Alta);

  -- *** Abre o cursor e verifica se existem itens prescritos. ***
  Open  cPreMed;
  Fetch cPreMed Into rPreMed;
  Close cPreMed;
  --
  Open  cEvolucao; -- OP 29467 (inicio)
  Fetch cEvolucao Into vDs_Evolucao;
  Close cEvolucao;
  --
  Open cIsPremedSubstituta;
   fetch cIsPremedSubstituta into vExistePremedSubstituta;
  Close cIsPremedSubstituta;
  --
  vDs_Evolucao := Replace(vDs_Evolucao, Chr(13), Chr(10) ); -- OP 29467 (fim)
  --
  Dbamv.Prc_Pagu_Atualiza_Previs_Alta(Pkg_Pagu_ItPreMed.Fn_PreMed().Cd_Pre_Med, rPreMed.cd_atendimento, vData_Atualiza_Alta );
  --
  -- Pda 481387 fim
  vConfChecagem := dbamv.pkg_mv2000.le_configuracao('PAGU','CHECAGEM_ENFERMAGEM'); --> PDA 364464 (MRVS)
  --
  -- *** Se não existir itens a prescrição não será a principal. Pode ser apenas com evolução ***
  If Nvl(rPreMed.Qt_Itens,0) = 0 Then
    --
    vFlPrincipal := 'N';
    --
  End If;
  --** Marca os itens da prescrição quando forem cópia perferita, sem alterações após a cópia, com exceção da justificativa.
    dbamv.prc_mvpep_verif_copia_perf (piPreMed ) ;
  --
  -- *** Marca a prescrição como impressa, evitando assim qualquer alteração ***
  Update Dbamv.Pre_Med
     Set Fl_Impresso             = 'S'
        ,Dh_Impressao            = Sysdate
        ,Fl_Principal            = Nvl( vFlPrincipal, Fl_Principal )
        ,Nm_Usuario_Autorizador  = pvNm_Usuario_Autorizador
   Where Cd_Pre_Med = piPreMed
     and Fl_Impresso = 'N';

     --GGMS -OP 30505- Trecho retirado da trg_u_pre_med - 02/06/2015
     --inserir registro de infecção automaticamente
     -- Insere registro de infecção em DBAMV.Prc_Psih_Insere_Registro_Infec
     --PDA 423873 - processo de prorrogação atm -- PDA 538560 (inicio)
        For x In cDadosProrrogacao(piPreMed) LOOP
          DBAMV.PRC_PSIH_AUDITA_PRORROGACAO( rPreMed.cd_atendimento,
                                              x.cd_Produto,
                                              rPreMed.dt_pre_med,
                                              x.nr_dia,
                                              x.cd_itpre_med,
                                             'T',
                                              vMensagem,
                                              vAcaoProrrogacao
                                           );
        END LOOP;
     --

  -- *** Fecha o documento clínico ***
  UPDATE Dbamv.Pw_Documento_Clinico SET Tp_Status = 'FECHADO' , cd_usuario = rPreMed.NM_USUARIO, cd_usuario_autorizador = pvNm_Usuario_Autorizador, Dh_Fechamento = Sysdate, Dh_Impresso = Sysdate
   WHERE Cd_Documento_Clinico = rPreMed.Cd_Documento_Clinico;
  --
  Open  cConfigPaguSetor(rPreMed.Cd_Setor, rPreMed.Tp_Pre_Med); -- OP 39982
    Fetch cConfigPaguSetor Into vTp_Aprazamento, vTp_Suspende_Sol_Farm_Presc; -- OP 39982
  Close cConfigPaguSetor;
  --
  If Nvl(vExistePremedSubstituta,'N') = 'N' AND Fnc_verif_tp_susp_sol_farmacia(vTp_Suspende_Sol_Farm_Presc) And rPreMed.Tp_Pre_Med Not In ('F', 'A') Then
     Dbamv.Prc_Pagu_Cancela_Solic_Pend (piPreMed, rPreMed.Dh_Pre_Med);
  End If; -- OP 39982 (fim)
  --
  --
  -- *** Busca saber se a prescrição que esta sendo fechada, foi gerada a partir de uma intervenção farmaceutica ***
  Open  cAvaliacao;
  Fetch cAvaliacao Into rAvaliacao;
  Close cAvaliacao;
  --
  -- Aprazamento Automático.
  Open  C_Apraz;
  Fetch C_Apraz Into rApraz;
  --PDA 288861 (ini)
 --HSR -- sempre aprazar automático as prescrições de enfermagem.

  If (rPreMed.Tp_Pre_Med = 'E' and vConfChecagem =  'S')      --> PDA 364464 (MRVS)
    OR (rAvaliacao.Sn_Presc_Interv_Farmaceutica = 'S' ) Then  -->> Prescrições geradas automaticamente pelo processo de intervenção farmaceutica, não tem necessidade de ser aprazado pela enfermagem
    vTp_Aprazamento := 'A' ;
  End If;

  --
  --HSR
  --PDA 288861 (fim)
  -- Pda 449044 Inicio
  If  rPreMed.Tp_Objeto          = 'TRATMT' And
      rPreMed.Cd_Pre_Med_Tratmt Is NOT Null Then
      bAptaParaAprazar := False;
  End If;
  -- Pda 449044 Fim
  --
     Open cTipoObjeto(piPreMed);
	   Fetch cTipoObjeto Into vcTipoObjeto;
	   Close cTipoObjeto;

 	  If Nvl(vcTipoObjeto.tp_documento, '*') Not In ('RECEIT') Then
		--
		  Dbamv.prc_mvpep_cria_aval_farm(piPreMed);
		--
	   End If;
  --
  If (C_Apraz%NotFound And rPreMed.Tp_Pre_Med Not In ('A', 'F') And rPreMed.Tp_Objeto <> 'RECEIT' or rPreMed.Tp_Pre_Med = 'E') --PDA 400768 -- Parenteses inicial e inal incluidos pelo Pda 449044
    And bAptaParaAprazar Then  -- Pda 449044

     -- Busca configuração do PAGU
    Open C_Config_Pagu_TpObjeto(rPreMed.Cd_Objeto);
    Fetch C_Config_Pagu_TpObjeto Into vConfig_Pagu_TpObj;
    Close C_Config_Pagu_TpObjeto;

		-- É necessário que a rotina de criar avaliação seja executado antes do fechar aprazamento, pois usamos o artifício de que não existir a avaliação para saber que foi uma prescrição feita antes de ativar este processo de avaliação ***
	   Open cTipoObjeto(piPreMed);
	   Fetch cTipoObjeto Into vcTipoObjeto;
	   Close cTipoObjeto;
		--
	   If Nvl(vcTipoObjeto.tp_documento, '*') Not In ('RECEIT') Then
		--
		  Dbamv.prc_mvpep_cria_aval_farm(piPreMed);
		--
	   End If;

   --OP 4705(PDA 572671 e 573374)
    --Ao criar o aprazamento, verificar se o TP_CENTRO_CUSTO configurado é ATENDIMENTO, se for,
    --deve ser passado por parâmetro o setor associado é unidade de internação, para gerar corretamente a solicitação ao estoque.
    IF rPreMed.Cd_Unid_Int IS NOT NULL And vConfig_Pagu_TpObj.TP_CENTRO_CUSTO = 'ATENDIMENTO' THEN

      -- Busca informacoes da unidade de internacao
      Open  C_Setor_unid_int(rPreMed.Cd_Unid_Int);
      Fetch C_Setor_unid_int Into rCdSetorUnidInt;
      Close C_Setor_unid_int;

     Dbamv.Pkg_Pagu_Aprazamento.Prc_Criar_Aprazamento( rPreMed.Cd_Atendimento, rPreMed.Dt_referencia,  vTp_Aprazamento , piPreMed, rPreMed.Cd_Unid_Int, rCdSetorUnidInt.Cd_Setor);

     ELSE
      Dbamv.Pkg_Pagu_Aprazamento.Prc_Criar_Aprazamento( rPreMed.Cd_Atendimento, rPreMed.Dt_referencia,  vTp_Aprazamento , piPreMed, rPreMed.Cd_Unid_Int, rPreMed.Cd_Setor);
    END IF;

    rApraz.Cd_Fechamento := Dbamv.Pkg_Pagu_Aprazamento.Fnc_Aprazamento().Cd_Fechamento;
  End If;
  --

  --
  Dbamv.Pkg_Pagu_Aprazamento.Prc_Fechar_Aprazamento( rApraz.Cd_Fechamento, rPreMed.Cd_Atendimento, piPreMed);
  --
  If Pkg_Pagu_ItPreMed.Fn_PreMed().Cd_Pre_Med = piPreMed Then
    Pkg_Pagu_ItPreMed.Pr_PreMed( vRecPre_Med );  -->> Limpa a variável de prescrição indicando que não há mais prescrição aberta
  End If;
  --OP 35300
  DBAMV.PRC_PAGU_GERAR_ETIQU_PREPARO(piPreMed);
  --
  -- Atualizando as prescrições que foram copiadas
  FOR rPreMedCopiada In cPreMedCopiada(piPreMed) LOOP
    UPDATE dbamv.pre_med SET sn_copiada = 'S'
     WHERE pre_med.cd_pre_med = rPreMedCopiada.cd_pre_med;
  END LOOP;
  --
End;