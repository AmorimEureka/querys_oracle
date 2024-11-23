
/* ************************************************************************************************************************* */
/* ************************************************************************************************************************* */

-- QUERY ORIGINAL CEDIDA POR HOSPITAL PARCEIRO

SELECT P_Unidade
      , P_Linha
      , Leito
      , Paciente
      , Registro
      , Medico
      , Convenio
      , Internacao
      , Prev_Alta
      , Dias
      , BLC
      --, HMD
      --, END
      , EVM
      , EVE
      , PRM
      , PRA
      , APZ
      , CKG
      --, AUD
      --, PXH
      , BLH
      --, TEV
      --, SCE
      --, SCM
      --, PAR
      --, PCT
      --, PGT
      , ALE
      , MON
      , EXA
      , IMG
      , PED
      , DEV
      , SIT
      , Hint
      , cd_atendimento CDATENDIMENTO
      , cd_paciente CDPACIENTE
      , 'urlPep' urlPep
      FROM (
      select Cd_Unid_Int P_Unidade
      , Rownum P_Linha
      , Cd_Leito
      , Leito
      , Paciente
      , Registro
      , Cd_atendimento
      , Cd_paciente
      , Medico
      , Convenio
      , Internacao
      , Prev_Alta
      , Dias
      , Decode(Paciente,null,null,Decode(AgendaBlocoCirurgico,1,'<img src="../img/painel/setadireita.gif" >',null)) BLC
      , Decode(Paciente,null,null,Decode(AgendaHemodinamica,1,'<img src="../img/painel/setadireita.gif" >',null)) HMD
      , Decode(Paciente,null,null,Decode(AgendaEndoscopia,1,'<img src="../img/painel/setadireita.gif" >',null)) END
      , Decode(Paciente,null,null,Decode(EvolucaoMedica,1,'<img src="../img/dash/situacaovermelha.gif" >',2,'<img src="../img/dash/situacaoamarela.gif" >','<img src="../img/dash/situacaoverde.gif" >')) EVM
      , Decode(Paciente,null,null,Decode(EvolucaoEnfermagem,1,'<img src="../img/dash/situacaovermelha.gif" >',2,'<img src="../img/painel/situacaoamarela.gif" >','<img src="../img/dash/situacaoverde.gif" >')) EVE
      , Decode(Paciente,null,null,Decode(PrescricaoMedica,1,'<img src="../img/dash/situacaovermelha.gif" >',2,'<img src="../img/painel/situacaoamarela.gif" >','<img src="../img/dash/situacaoverde.gif" >')) PRM
      , Decode(Paciente,null,null,Decode(PrescricaoAberta,1,'<img src="../img/dash/situacaovermelha.gif" >','<img src="../img/dash/situacaoverde.gif" >')) PRA
      , Decode(Paciente,null,null,Decode(ChecagemMedicacao,1,'<img src="../img/dash/situacaovermelha.gif" >','<img src="../img/dash/situacaoverde.gif" >')) CKG
      , Decode(Paciente,null,null,Proximohorario) PXH
      , Decode(Paciente,null,null,Decode(Aprazamento,1,'<img src="../img/dash/situacaovermelha.gif" >','<img src="../img/dash/situacaoverde.gif" >')) APZ
      , Decode(Paciente,null,null,Decode(ProtocoloTev,1,'<img src="imagens/documentopreenchido.gif" >',null)) TEV
      , Decode(Paciente,null,null,VlrScoreEnfermagem) SCE
      , Decode(Paciente,null,null,VlrScoreMedico) SCM
      , Decode(Paciente,null,null,Decode(PrecaucaoAr,1,'<img src="../img/painel/atencaoalerta.gif" >','<img src="../img/dash/situacaoverde.gif" >')) PAR
      , Decode(Paciente,null,null,Decode(PrecaucaoContato,1,'<img src="../img/painel/atencaoalerta.gif" >','<img src="../img/dash/situacaoverde.gif" >')) PCT
      , Decode(Paciente,null,null,Decode(PrecaucaoGoticula,1,'<img src="../img/painel/atencaoalerta.gif" >','<img src="../img/dash/situacaoverde.gif" >')) PGT
      , Decode(Paciente,null,null,Decode(PrecaucaoMaxima,1,'<img src="../img/painel/atencaoalerta.gif" >','<img src="../img/dash/situacaoverde.gif" >')) PMX
      , Decode(Paciente,null,null,Decode(PrecaucaoPadrao,1,'<img src="../img/painel/atencaoalerta.gif" >','<img src="../img/dash/situacaoverde.gif" >')) PPD
      , Decode(Paciente,null,null,Decode(AvisoAlergia,1,'<img src="../img/painel/atencaoalerta.gif" >',null)) ALE
      , Decode(Paciente,null,null,Decode(Monitoramento,1,'<img src="../img/painel/situacaoamarela.gif" >','<img src="../img/dash/situacaoverde.gif" >')) MON
      , Decode(Paciente,null,null,Decode(BalancoHidrico,1,'<img src="../img/dash/situacaovermelha.gif" >','<img src="../img/dash/situacaoverde.gif" >')) BLH
      , Decode(Paciente,null,null,Decode(ResultadoExames,1,'<img src="../img/painel/pedidoexame.gif" >',3,'<img src="../img/painel/documentopreenchido.gif" >')) EXA
      , Decode(Paciente,null,null,Decode(ResultadoImagens,1,'<img src="../img/painel/pedidoimagem.gif" >',3,'<img src="../img/painel/documentopreenchido.gif" >')) IMG
      , Decode(Paciente,null,null,Decode(PedidoFarmaciaAtrasado,1,'<img src="../img/dash/situacaovermelha.gif">'
      , Decode(PedidoFarmaciaPendente,1,'<img src="../img/painel/pedidosfarmacia.gif" >','<img src="../img/dash/situacaoverde.gif" >'))) PED
      , Decode(Paciente,null,null,Decode(PedidoFarmaciaDevolucao,1,'<img src="../img/painel/pedidosfarmacia.gif">',2,'<img src="../img/dash/situacaovermelha.gif" >','<img src="../img/dash/situacaoverde.gif" >')) DEV
      , Decode(Paciente,NULL,NULL,Decode(AuditoriaChecagem,1,'<img src="../img/dash/situacaovermelha.gif" >','<img src="../img/dash/situacaoverde.gif" >')) AUD
      , Decode(LocalPaciente,1,'<img src="../img/painel/blococirurgico.gif" >',2,'<img src="../img/painel/salarecuperacao.gif" >'
      , Decode(AltaMedica,1,'<img src="../img/painel/ico_altamedica.gif" >'
      , Decode(Tp_Ocupacao,'O','<img src="="../img/painel/ico_leitoocupado.gif" >','R','<img src="../img/painel/ico_reserva.gif">','M','<img src="../img/painel/ico_manutencao.gif" >','I','<img src="../img/painel/ico_leitoinfectado.gif" >','A','<img src="../img/painel/ico_acompanhante.gif" >', 'V', '<img src="../img/painel/ico_leitovago.gif" >'
      , Decode(StatusLimpeza,'L','<img src="../img/painel/ico_higienizacao.gif" >','H','<img src="../img/painel/ico_limpeza.gif" >','C','<img src="imagens/ico_Camareira.gif" >','P','<img src="../img/painel/ico_poslimpeza.gif" >', Decode(TP_ocupacao, 'L','<img src="../img/painel/ico_limpeza.gif" >'))))) Sit
      , Decode(Paciente,null,NULL,Hint) Hint
      From (
            select Leitos.Cd_Leito
            , Leitos.Cd_Unid_Int
            , Leitos.Cd_Setor
            , Leitos.Ds_Resumo Leito
            , Movimento.Registro
            , Movimento.Paciente
            , Movimento.Medico
            , Movimento.Convenio
            , Movimento.Internacao
            , Movimento.Prev_Alta
            , Movimento.Dias
            , Movimento.AgendaBlocoCirurgico
            , Movimento.AgendaHemodinamica
            , Movimento.AgendaEndoscopia
            , Movimento.ChecagemMedicacao
            , Movimento.PedidoFarmaciaPendente
            , MOvimento.PedidoFarmaciaAtrasado
            , Movimento.PrescricaoMedica
            , Movimento.PrescricaoAberta
            , Movimento.ProximoHorario
            , Movimento.Aprazamento
            , Movimento.EvolucaoMedica
            , Movimento.EvolucaoEnfermagem
            , Movimento.ProtocoloTev
            , Movimento.VlrScoreEnfermagem
            , Movimento.VlrScoreMedico
            , Movimento.PrecaucaoGoticula
            , Movimento.PrecaucaoContato
            , Movimento.PrecaucaoAr
            , Movimento.PrecaucaoMaxima
            , Movimento.PrecaucaoPadrao
            , Movimento.AvisoAlergia
            , Movimento.ResultadoExames
            , Movimento.ResultadoImagens
            , Movimento.PedidoFarmaciaDevolucao
            , Movimento.BalancoHidrico
            , Movimento.Monitoramento
            , Movimento.AuditoriaChecagem
            , Movimento.Hint
            , Movimento.AltaMedica
            , Movimento.cd_atendimento
            , Movimento.Cd_Paciente
            , Movimento.LocalPaciente
            , Leitos.Tp_Ocupacao
            , Movimento.ItensApagar
            , Leitos.Cd_Leito_Aih
            , Leitos.StatusLimpeza
            from (
                  SELECT
                    Decode(Substr(Paciente.nm_paciente,16,22),null,Paciente.nm_paciente,Substr(Paciente.nm_paciente,1,40)||'...') Paciente
                  , atendime.cd_atendimento Registro
                  , Decode(Substr(Prestador.nm_prestador,9,12),null,prestador.nm_prestador,Substr(prestador.nm_prestador,1,8)||'...') Medico
                  , Decode(Substr(Convenio.Nm_Convenio,7,10),NULL,Convenio.Nm_Convenio,Substr(Convenio.Nm_Convenio,1,6)||'...') Convenio
                  , To_Char(Atendime.Dt_Atendimento,'dd/mm/yy')||'-'||To_Char(Atendime.Hr_Atendimento,'hh24:mi') Internacao
                  , To_Char(Atendime.Dt_Prevista_Alta,'dd/mm/yy') Prev_Alta
                  , trunc(sysdate-Atendime.dt_atendimento) Dias
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'CHECAGEMMEDICACAO',Atendime.Cd_Multi_Empresa) ChecagemMedicacao
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PROXIMOHORARIO',Atendime.Cd_Multi_Empresa) ProximoHorario
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'APRAZAMENTO',Atendime.Cd_Multi_Empresa) Aprazamento
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PEDIDOFARMACIAPENDENTE',Atendime.Cd_Multi_Empresa) PedidoFarmaciaPendente
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PEDIDOFARMACIAATRASADO',Atendime.Cd_Multi_Empresa) PedidoFarmaciaAtrasado
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PRESCRICAOMEDICA',Atendime.Cd_Multi_Empresa)  PrescricaoMedica
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PRESCRICAOABERTA',Atendime.Cd_Multi_Empresa) PrescricaoAberta
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'EVOLUCAOMEDICA',Atendime.Cd_Multi_Empresa)  EvolucaoMedica
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'EVOLUCAOENFERMAGEM',Atendime.Cd_Multi_Empresa) EvolucaoEnfermagem
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PROTOCOLOTEV_SEMINDICE',Atendime.Cd_Multi_Empresa) ProtocoloTev
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'VLRSCOREENFERMAGEM',Atendime.Cd_Multi_Empresa) VlrScoreEnfermagem
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'VLRSCOREMEDICO',Atendime.Cd_Multi_Empresa) VlrScoreMedico
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'AGENDABLOCOCIRURGICO',Atendime.Cd_Multi_Empresa) AgendaBlocoCirurgico
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'AGENDAHEMODINAMICA',Atendime.Cd_Multi_Empresa) AgendaHemodinamica
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'AGENDAENDOSCOPIA',Atendime.Cd_Multi_Empresa)  AgendaEndoscopia
                  , Dbamv.Fnc_Painel_Vigilancia_Epidemio(Atendime.cd_atendimento,'PRECAUCAOGOTICULA',Atendime.Cd_Multi_Empresa) PrecaucaoGoticula
                  , Dbamv.Fnc_Painel_Vigilancia_Epidemio(Atendime.cd_atendimento,'PRECAUCAOCONTATO',Atendime.Cd_Multi_Empresa) PrecaucaoContato
                  , Dbamv.Fnc_Painel_Vigilancia_Epidemio(Atendime.cd_atendimento,'PRECAUCAOAR',Atendime.Cd_Multi_Empresa) PrecaucaoAr
                  , Dbamv.Fnc_Painel_Vigilancia_Epidemio(Atendime.cd_atendimento,'PRECAUCAOMAXIMA',Atendime.Cd_Multi_Empresa)  PrecaucaoMaxima
                  , Dbamv.Fnc_Painel_Vigilancia_Epidemio(Atendime.cd_atendimento,'PRECAUCAOPADRAO',Atendime.Cd_Multi_Empresa) PrecaucaoPadrao
                  , Nvl(Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'AVISOALERGIATELA',Atendime.Cd_Multi_Empresa)
                  , Dbamv.Fnc_Painel_Assistencial(cd_atendimento,'AVISOALERGIATELA',Atendime.Cd_Multi_Empresa)) AvisoAlergia
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'RESULTADOEXAMES',Atendime.Cd_Multi_Empresa) ResultadoExames
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PEDIDOFARMACIADEVOLUCAO',Atendime.Cd_Multi_Empresa) PedidoFarmaciaDevolucao
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'BALANCOHIDRICO',Atendime.Cd_Multi_Empresa) BalancoHidrico
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'ALTAMEDICA',Atendime.Cd_Multi_Empresa) AltaMedica
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'RESULTADOIMAGENS',Atendime.Cd_Multi_Empresa) ResultadoImagens
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'MONITORAMENTO',Atendime.Cd_Multi_Empresa) Monitoramento
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'AUDITORIACHECAGEM',Atendime.Cd_Multi_Empresa) AuditoriaChecagem
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'LOCALPACIENTE',Atendime.Cd_Multi_Empresa) LocalPaciente
                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'ITENSAPAGAR',Atendime.Cd_Multi_Empresa) ItensApagar
                  , Rtrim(Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PROXIMAMEDICACAO',Atendime.Cd_Multi_Empresa))||' '||
                    Rtrim(Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PEDIDOMEDICACAOATRASADA',Atendime.Cd_Multi_Empresa))||' '||
                    Rtrim(Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'MEDICACAOATRASADA',Atendime.Cd_Multi_Empresa)) Hint
                  , Atendime.cd_atendimento Cd_atendimento
                  , Atendime.Cd_Paciente
                  , Leito.Cd_Leito_Aih Cd_Laito_Aih
                  , Leito.Cd_leito Cd_leito
                  FROM Dbamv.Atendime
                     , Dbamv.Leito
                     , Dbamv.Paciente
                     , Dbamv.Prestador
                     , Dbamv.Convenio
                     , Dbamv.Unid_Int
                  where Atendime.Cd_Leito = Leito.Cd_Leito
                    and Atendime.Cd_Paciente = paciente.cd_paciente
                    and atendime.cd_prestador = prestador.cd_prestador
                    and Atendime.Cd_convenio = Convenio.Cd_Convenio
                    and Atendime.Tp_Atendimento = 'I'
                    and Atendime.Dt_Alta is NULL
                    and Atendime.Cd_Multi_Empresa = 1
                    and Unid_Int.Cd_Unid_Int = Leito.Cd_Unid_Int
                    and Unid_Int.Cd_Setor = 215
                  ) Movimento
                  , (SELECT Leito.Cd_leito
                          , Leito.Cd_Leito_Aih
                          , Leito.Cd_Unid_Int
                          , Leito.Sn_Extra
                          , Leito.Ds_Resumo
                          , Leito.Tp_Ocupacao
                          , SolicLimpeza.StatusLimpeza
                          , Unid_Int.Cd_Setor
                  FROM Dbamv.Leito
                  , Dbamv.Unid_Int
                  , ( SELECT Solic_Limpeza.Cd_Leito
                  , Decode(Solic_Limpeza.Dt_Inicio_Higieniza, NULL, 'H',Decode(solic_limpeza.dt_hr_fim_higieniza,NULL, 'L',Decode(Solic_Limpeza.Dt_Hr_Fim_Rouparia, NULL, 'C', Decode(Solic_Limpeza.Dt_Hr_Fim_Pos_higieniza, NULL,'P',Decode(Solic_Limpeza.Dt_Realizado, NULL,'L'))))) StatusLimpeza
                  FROM Dbamv.Solic_Limpeza
                  WHERE To_Char(Solic_Limpeza.Dt_Solic_Limpeza,'dd/mm/rrrr')||''||To_Char(Solic_Limpeza.Hr_Solic_Limpeza,'hh24:mi') IS NOT NULL
                    AND To_Char(Solic_Limpeza.Dt_Hr_Fim_pos_higieniza,'dd/mm/rrrr hh24:mi') IS null
                    AND (Solic_Limpeza.Cd_Leito,To_Date(To_Char(Solic_Limpeza.Dt_Solic_Limpeza,'dd/mm/rrrr')||''||To_Char(Solic_Limpeza.Hr_Solic_Limpeza,'hh24:mi'),'dd/mm/yyyy hh24:mi'))
                  in (SELECT Solic_Limpeza.Cd_Leito
                  , Max(To_Date(To_Char(Solic_Limpeza.Dt_Solic_Limpeza,'dd/mm/rrrr')||'
                  '||To_Char(Solic_Limpeza.Hr_Solic_Limpeza,'hh24:mi'),'dd/mm/yyyy hh24:mi')) DtInicioLimpeza
                  FROM Dbamv.solic_limpeza
                  Group By Solic_limpeza.cd_leito)
                  ) SolicLimpeza
                  WHERE Leito.Cd_Leito = SolicLimpeza.Cd_Leito(+)
                  AND Unid_Int.Cd_Unid_Int = Leito.Cd_Unid_Int
                  AND Leito.Dt_Desativacao is NULL ) Leitos
                  where Leitos.Cd_leito = Movimento.Cd_leito(+)
                  and Decode(Leitos.Sn_Extra,'S',Movimento.Registro,Leitos.Cd_Leito) Is Not NULL
                  Order by Leito
                  ) mov
                  where mov.Cd_Setor = 215)
;

/* ******************************************************************************************************************************************************************** */
/* ******************************************************************* QUERY FINAL - PAINEL MV ************************************************************************ */
SELECT 
     DS_UNID_INT
	, P_Linha
        , Leito
	, cd_atendimento CDATENDIMENTO
--	, cd_paciente CDPACIENTE
       , Paciente
	-- , Registro
  	, Medico
	, Convenio
	, Internacao
	, Prev_Alta
	, Dias
	, CC
	, PRM
	, APZ
	, CKG
	, EXA
	, IMG
	, PED
	, DEV
	, 'urlPep' urlPep
FROM ( -- 1 FROM
	  SELECT 
		  Cd_Unid_Int P_Unidade
          , DS_UNID_INT
          , Rownum P_Linha
          , Cd_Leito
          , Leito
          , Paciente
          , Registro
          , Cd_atendimento
          , Cd_paciente
          , Medico
          , Convenio
          , Internacao
          , Prev_Alta
          , Dias
          , Decode(Paciente,null,null,Decode(AgendaBlocoCirurgico,1,'<img src="../img/painel/setadireita.gif" >',null)) CC
          , Decode(Paciente,null,null,Decode(AgendaHemodinamica,1,'<img src="../img/painel/setadireita.gif" >',null)) HMD
          , Decode(Paciente,null,null,Decode(PrescricaoMedica,1,'<img src="../img/dash/situacaovermelha.gif" >',2,'<img src="../img/painel/situacaoamarela.gif" >','<img src="../img/dash/situacaoverde.gif" >')) PRM
          , Decode(Paciente,null,null,Decode(ChecagemMedicacao,1,'<img src="../img/dash/situacaovermelha.gif" >','<img src="../img/dash/situacaoverde.gif" >')) CKG
          , Decode(Paciente,null,null,Proximohorario) PXH
          , Decode(Paciente,null,null,Decode(Aprazamento,1,'<img src="../img/dash/situacaovermelha.gif" >','<img src="../img/dash/situacaoverde.gif" >')) APZ
          , Decode(Paciente,null,null,VlrScoreEnfermagem) SCE
          , Decode(Paciente,null,null,VlrScoreMedico) SCM
          , Decode(Paciente,null,null,Decode(ResultadoExames,1,'<img src="../img/painel/pedidoexame.gif" >',3,'<img src="../img/painel/documentopreenchido.gif" >')) EXA
          , Decode(Paciente,null,null,Decode(ResultadoImagens,1,'<img src="../img/painel/pedidoimagem.gif" >',3,'<img src="../img/painel/documentopreenchido.gif" >')) IMG
          , Decode(PedidoFarmaciaPendente,1,'<img src="../img/painel/pedidosfarmacia.gif" >','<img src="../img/dash/situacaoverde.gif" >') PED
          , Decode(Paciente,null,null,Decode(PedidoFarmaciaDevolucao,1,'<img src="../img/painel/pedidosfarmacia.gif">',2,'<img src="../img/dash/situacaovermelha.gif" >','<img src="../img/dash/situacaoverde.gif" >')) DEV
	  FROM ( -- 2 FROM
	        SELECT 
	        	Leitos.Cd_Leito
	            , Leitos.Cd_Unid_Int
	            , Leitos.Cd_Setor
	            , Leitos.Ds_Resumo Leito
	            , Movimento.Registro
	            , Movimento.Paciente
	            , Movimento.Medico
	            , Movimento.Convenio
	            , Movimento.Internacao
	            , Movimento.Prev_Alta
	            , Movimento.Dias
	            , Movimento.AgendaBlocoCirurgico
	            , Movimento.AgendaHemodinamica
	            , Movimento.ChecagemMedicacao
	            , Movimento.PedidoFarmaciaPendente
	            , MOvimento.PedidoFarmaciaAtrasado
	            , Movimento.PrescricaoMedica
	            , Movimento.PrescricaoAberta
	            , Movimento.ProximoHorario
	            , Movimento.Aprazamento
	            , Movimento.EvolucaoMedica
	            , Movimento.EvolucaoEnfermagem
	            , Movimento.ProtocoloTev
	            , Movimento.VlrScoreEnfermagem
	            , Movimento.VlrScoreMedico
	            , Movimento.AvisoAlergia
	            , Movimento.ResultadoExames
	            , Movimento.ResultadoImagens
	            , Movimento.PedidoFarmaciaDevolucao
	            , Movimento.BalancoHidrico
	            , Movimento.Monitoramento
	            , Movimento.AuditoriaChecagem
	            , Movimento.Hint
	            , Movimento.AltaMedica
	            , Movimento.cd_atendimento
	            , Movimento.Cd_Paciente
	            , Movimento.LocalPaciente
	            , Leitos.Tp_Ocupacao
	            , Movimento.ItensApagar
	            , Leitos.Cd_Leito_Aih
	            , Leitos.StatusLimpeza
                , Leitos.DS_UNID_INT
	        FROM ( -- 3 FROM
	        		SELECT 
	        			Decode(Substr(Paciente.nm_paciente,16,22),null,Paciente.nm_paciente,Substr(Paciente.nm_paciente,1,40)||'...') Paciente
	                  , atendime.cd_atendimento Registro
	                  , Decode(Substr(Prestador.nm_prestador,9,12),null,prestador.nm_prestador,Substr(prestador.nm_prestador,1,8)||'...') Medico
	                  , Decode(Substr(Convenio.Nm_Convenio,7,10),NULL,Convenio.Nm_Convenio,Substr(Convenio.Nm_Convenio,1,6)||'...') Convenio
	                  , To_Char(Atendime.Dt_Atendimento,'dd/mm/yy')||'-'||To_Char(Atendime.Hr_Atendimento,'hh24:mi') Internacao
	                  , To_Char(Atendime.Dt_Prevista_Alta,'dd/mm/yy') Prev_Alta
	                  , trunc(sysdate-Atendime.dt_atendimento) Dias
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'CHECAGEMMEDICACAO',Atendime.Cd_Multi_Empresa) ChecagemMedicacao
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PROXIMOHORARIO',Atendime.Cd_Multi_Empresa) ProximoHorario
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'APRAZAMENTO',Atendime.Cd_Multi_Empresa) Aprazamento
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PEDIDOFARMACIAPENDENTE',Atendime.Cd_Multi_Empresa) PedidoFarmaciaPendente
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PEDIDOFARMACIAATRASADO',Atendime.Cd_Multi_Empresa) PedidoFarmaciaAtrasado
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PRESCRICAOMEDICA',Atendime.Cd_Multi_Empresa)  PrescricaoMedica
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PRESCRICAOABERTA',Atendime.Cd_Multi_Empresa) PrescricaoAberta
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'EVOLUCAOMEDICA',Atendime.Cd_Multi_Empresa)  EvolucaoMedica
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'EVOLUCAOENFERMAGEM',Atendime.Cd_Multi_Empresa) EvolucaoEnfermagem
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PROTOCOLOTEV_SEMINDICE',Atendime.Cd_Multi_Empresa) ProtocoloTev
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'VLRSCOREENFERMAGEM',Atendime.Cd_Multi_Empresa) VlrScoreEnfermagem
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'VLRSCOREMEDICO',Atendime.Cd_Multi_Empresa) VlrScoreMedico
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'AGENDABLOCOCIRURGICO',Atendime.Cd_Multi_Empresa) AgendaBlocoCirurgico
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'AGENDAHEMODINAMICA',Atendime.Cd_Multi_Empresa) AgendaHemodinamica
	                 , Nvl(Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'AVISOALERGIATELA',Atendime.Cd_Multi_Empresa)
	                  , Dbamv.Fnc_Painel_Assistencial(cd_atendimento,'AVISOALERGIATELA',Atendime.Cd_Multi_Empresa)) AvisoAlergia
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'RESULTADOEXAMES',Atendime.Cd_Multi_Empresa) ResultadoExames
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PEDIDOFARMACIADEVOLUCAO',Atendime.Cd_Multi_Empresa) PedidoFarmaciaDevolucao
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'BALANCOHIDRICO',Atendime.Cd_Multi_Empresa) BalancoHidrico
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'ALTAMEDICA',Atendime.Cd_Multi_Empresa) AltaMedica
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'RESULTADOIMAGENS',Atendime.Cd_Multi_Empresa) ResultadoImagens
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'MONITORAMENTO',Atendime.Cd_Multi_Empresa) Monitoramento
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'AUDITORIACHECAGEM',Atendime.Cd_Multi_Empresa) AuditoriaChecagem
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'LOCALPACIENTE',Atendime.Cd_Multi_Empresa) LocalPaciente
	                  , Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'ITENSAPAGAR',Atendime.Cd_Multi_Empresa) ItensApagar
	                  , Rtrim(Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PROXIMAMEDICACAO',Atendime.Cd_Multi_Empresa))||' '||
	                    Rtrim(Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'PEDIDOMEDICACAOATRASADA',Atendime.Cd_Multi_Empresa))||' '||
	                    Rtrim(Dbamv.Fnc_Painel_Assistencial(Atendime.cd_atendimento,'MEDICACAOATRASADA',Atendime.Cd_Multi_Empresa)) Hint
	                  , Atendime.cd_atendimento Cd_atendimento
	                  , Atendime.Cd_Paciente
	                  , Leito.Cd_Leito_Aih Cd_Laito_Aih
	                  , Leito.Cd_leito Cd_leito
	          		FROM Dbamv.Atendime
	             		 , Dbamv.Leito
	             		 , Dbamv.Paciente
	             		 , Dbamv.Prestador
	             		 , Dbamv.Convenio
	             		 , Dbamv.Unid_Int
	          		WHERE Atendime.Cd_Leito = Leito.Cd_Leito
	            		  and Atendime.Cd_Paciente = paciente.cd_paciente
	            		  and atendime.cd_prestador = prestador.cd_prestador
	            		  and Atendime.Cd_convenio = Convenio.Cd_Convenio
	            		  and Atendime.Tp_Atendimento = 'I'
	            		  and Atendime.Dt_Alta is NULL
	            		  and Atendime.Cd_Multi_Empresa = 1
	            		  and Unid_Int.Cd_Unid_Int = Leito.Cd_Unid_Int
	            		--   and Unid_Int.Cd_Setor = 31
	             ) Movimento ,
	             ( -- 4 FROM
	              	SELECT 
	                	Leito.Cd_leito
	                  , Leito.Cd_Leito_Aih
	                  , Leito.Cd_Unid_Int
	                  , Leito.Sn_Extra
	                  , Leito.Ds_Resumo
	                  , Leito.Tp_Ocupacao
	                  , SolicLimpeza.StatusLimpeza
	                  , Unid_Int.Cd_Setor
                      , Unid_Int.DS_UNID_INT
	                FROM Dbamv.Leito
	              	     , Dbamv.Unid_Int
	                  	 , ( 
		                  	 	SELECT 
		                  	 		Solic_Limpeza.Cd_Leito
		                  	 		, Decode(Solic_Limpeza.Dt_Inicio_Higieniza, NULL, 'H',Decode(solic_limpeza.dt_hr_fim_higieniza,NULL, 'L',Decode(Solic_Limpeza.Dt_Hr_Fim_Rouparia, NULL, 'C', Decode(Solic_Limpeza.Dt_Hr_Fim_Pos_higieniza, NULL,'P',Decode(Solic_Limpeza.Dt_Realizado, NULL,'L'))))) StatusLimpeza
		                  		FROM Dbamv.Solic_Limpeza
		                  		WHERE To_Char(Solic_Limpeza.Dt_Solic_Limpeza,'dd/mm/rrrr')||''||To_Char(Solic_Limpeza.Hr_Solic_Limpeza,'hh24:mi') IS NOT NULL
		                    		  AND To_Char(Solic_Limpeza.Dt_Hr_Fim_pos_higieniza,'dd/mm/rrrr hh24:mi') IS null
		                    		  AND (Solic_Limpeza.Cd_Leito,To_Date(To_Char(Solic_Limpeza.Dt_Solic_Limpeza,'dd/mm/rrrr')||''||To_Char(Solic_Limpeza.Hr_Solic_Limpeza,'hh24:mi'),'dd/mm/yyyy hh24:mi'))
						                  in (
								                  SELECT 
								                  		Solic_Limpeza.Cd_Leito
								                  		, Max(To_Date(To_Char(Solic_Limpeza.Dt_Solic_Limpeza,'dd/mm/rrrr')||'
								                  		'||To_Char(Solic_Limpeza.Hr_Solic_Limpeza,'hh24:mi'),'dd/mm/yyyy hh24:mi')) DtInicioLimpeza
								                  FROM Dbamv.solic_limpeza
								                  GROUP BY Solic_limpeza.cd_leito 
							                  										)
	                  				) SolicLimpeza
	              	WHERE Leito.Cd_Leito = SolicLimpeza.Cd_Leito(+)
	              		  AND Unid_Int.Cd_Unid_Int = Leito.Cd_Unid_Int
	              		  AND Leito.Dt_Desativacao is NULL 
				 ) Leitos -- 4 FROM
	        WHERE Leitos.Cd_leito = Movimento.Cd_leito(+)
	              AND Decode(Leitos.Sn_Extra,'S',Movimento.Registro,Leitos.Cd_Leito) Is Not NULL
	        ORDER BY Leito
	       ) mov -- 2 FROM
WHERE mov.Cd_Unid_Int = 1
-- WHERE mov.Paciente IS NOT NULL
     )
;