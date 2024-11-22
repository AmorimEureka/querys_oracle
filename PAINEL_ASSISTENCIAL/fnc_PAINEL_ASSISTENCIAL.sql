

CREATE OR REPLACE Function DBAMV.fnc_painel_assistencial
  (P_Atendimento IN number,P_Tipo in VARCHAR2, P_Empresa IN number)

RETURN Char IS
Resposta Char(1000);

Cursor cResultadoExames is
---Resultados de Exames de Hoje---
Select Decode(Resultado.Resultado,3,3,1) ResultadoExame
  from Dbamv.Ped_Lab
     , Dbamv.Atendime
     , (SELECT Ped_Lab.Cd_Atendimento, 3 Resultado
          FROM Dbamv.Ped_Lab
             , Dbamv.ItPed_lab
         WHERE Ped_Lab.Cd_Ped_Lab = ItPed_Lab.Cd_Ped_Lab
           AND ItPed_lab.Dt_Laudo between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+.99999
           AND Rownum = 1
             ) Resultado
 where Ped_Lab.cd_Atendimento  = Atendime.cd_atendimento
   AND Atendime.Cd_Atendimento = Resultado.Cd_Atendimento(+)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   And atendime.Cd_Atendimento   = P_Atendimento;

Cursor cResultadoImagens is
---Resultados de Exames de Hoje---
select Decode(Resultado.Resultado,3,3,1) ResultadoImagem
  from Dbamv.Ped_Rx
     , Dbamv.Atendime
     , (SELECT DISTINCT Ped_Rx.Cd_Atendimento, 3 Resultado
          FROM Dbamv.Ped_Rx
             , Dbamv.ItPed_Rx
         WHERE Ped_Rx.Cd_Ped_Rx = ItPed_Rx.Cd_Ped_Rx
           and ItPed_Rx.Dt_Realizado between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+.99999
           AND Rownum = 1
              ) Resultado
 where Ped_Rx.cd_Atendimento     = Atendime.cd_atendimento
   AND Atendime.Cd_Atendimento   = Resultado.Cd_Atendimento(+)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.Cd_Atendimento   = P_Atendimento;

cursor cAgendaEndoscopia is
-- Agenda de Endoscopia --
SELECT 1 Sn_Agenda_Bloco
   FROM Dbamv.Age_Cir
      , Dbamv.Aviso_Cirurgia
      , Dbamv.Atendime
      , Dbamv.Cirurgia_Aviso
      , Dbamv.Cirurgia
      , Dbamv.Pro_Fat          Pro_Fat_Conv
      , Dbamv.Procedimento_Sus Pro_Fat_Sus
  WHERE (Pro_Fat_Conv.Cd_Gru_Pro IN (23,24) OR Pro_Fat_Sus.Cd_Grupo_Procedimento in ('02')  AND Cd_Sub_Grupo_Procedimento IN ('09')) --Endoscopia
    AND Aviso_Cirurgia.Cd_Aviso_Cirurgia = Cirurgia_Aviso.Cd_Aviso_Cirurgia
    AND Cirurgia_Aviso.cd_Cirurgia       = Cirurgia.Cd_Cirurgia
    AND Cirurgia.Cd_Pro_Fat              = Pro_fat_Conv.Cd_Pro_Fat(+)
    AND Cirurgia.Cd_Procedimento_Sih     = Pro_Fat_Sus.Cd_Procedimento(+)
    AND Age_Cir.Cd_Aviso_Cirurgia        = Aviso_Cirurgia.Cd_Aviso_Cirurgia
    AND Atendime.Cd_Atendimento          = Aviso_Cirurgia.Cd_Atendimento
    AND Aviso_Cirurgia.Tp_Situacao       = 'G'
    AND age_cir.dt_inicio_age_cir between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+.99999
    AND Rownum = 1
    AND Atendime.Cd_Multi_Empresa        = P_Empresa
    AND atendime.cd_atendimento          = P_Atendimento;

Cursor cAgendaHemodinamica is
-- Agenda de Hemodinamica --
SELECT 1 Sn_Agenda_Bloco
   FROM Dbamv.Age_Cir
      , Dbamv.Aviso_Cirurgia
      , Dbamv.Atendime
      , Dbamv.Cirurgia_Aviso
      , Dbamv.Cirurgia
      , Dbamv.Pro_Fat          Pro_Fat_Conv
      , Dbamv.Procedimento_Sus Pro_Fat_Sus
  WHERE (Pro_Fat_Conv.Cd_Gru_Pro IN (40) OR Pro_Fat_Sus.Cd_Procedimento in ('0211020010','0211020028'))--HEMODINAMICA
    AND Aviso_Cirurgia.Cd_Aviso_Cirurgia = Cirurgia_Aviso.Cd_Aviso_Cirurgia
    AND Cirurgia_Aviso.cd_Cirurgia       = Cirurgia.Cd_Cirurgia
    AND Cirurgia.Cd_Pro_Fat              = Pro_fat_Conv.Cd_Pro_Fat(+)
    AND Cirurgia.Cd_Procedimento_Sih     = Pro_Fat_Sus.Cd_Procedimento(+)
    AND Age_Cir.Cd_Aviso_Cirurgia        = Aviso_Cirurgia.Cd_Aviso_Cirurgia
    AND Atendime.Cd_Atendimento          = Aviso_Cirurgia.Cd_Atendimento
    AND Aviso_Cirurgia.Tp_Situacao       = 'G'
    AND age_cir.dt_inicio_age_cir between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+.99999
    AND Rownum = 1
    AND Atendime.Cd_Multi_Empresa        = P_Empresa
    AND atendime.cd_atendimento          = P_Atendimento;

cursor cAgendaBlocoCirurgico is
-- Agenda Bloco Cirurgico--
SELECT 1 Sn_Agenda_Bloco
   FROM Dbamv.Age_Cir
      , Dbamv.Aviso_Cirurgia
      , Dbamv.Atendime
      , Dbamv.Cirurgia_Aviso
      , Dbamv.Cirurgia
      , Dbamv.Pro_Fat          Pro_Fat_Conv
      , Dbamv.Procedimento_Sus Pro_Fat_Sus
  WHERE (Pro_Fat_Conv.Cd_Gru_Pro not IN (23,24,40) OR Pro_Fat_Sus.Cd_Grupo_Procedimento NOT in ('02') AND Cd_Sub_Grupo_Procedimento NOT IN ('09')
          AND Pro_Fat_Sus.Cd_Procedimento not in ('0211020010','0211020028'))--DEMAIS PROCEDIMENTOS
    AND Aviso_Cirurgia.Cd_Aviso_Cirurgia = Cirurgia_Aviso.Cd_Aviso_Cirurgia
    AND Cirurgia_Aviso.cd_Cirurgia       = Cirurgia.Cd_Cirurgia
    AND Cirurgia.Cd_Pro_Fat              = Pro_fat_Conv.Cd_Pro_Fat(+)
    AND Cirurgia.Cd_Procedimento_Sih     = Pro_Fat_Sus.Cd_Procedimento(+)
    AND Age_Cir.Cd_Aviso_Cirurgia        = Aviso_Cirurgia.Cd_Aviso_Cirurgia
    AND Atendime.Cd_Atendimento          = Aviso_Cirurgia.Cd_Atendimento
    AND Aviso_Cirurgia.Tp_Situacao       = 'G'
    AND age_cir.dt_inicio_age_cir between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+.99999
    AND Rownum = 1
    AND Atendime.Cd_Multi_Empresa        = P_Empresa
    AND atendime.cd_atendimento          = P_Atendimento;

cursor cProtocoloTevClinico is
---Protocolo Tev Clínico ---
Select 1 Protocolo_Tev
  From Dbamv.Atendime
 where not exists (Select 'X'
                     FROM Dbamv.Pw_Documento_Clinico   Pdc
                        , Dbamv.Pw_Editor_Clinico      Pec
                        , Dbamv.Editor_Registro_Campo  Erc
                        , Dbamv.Atendime               Ate
                        , Dbamv.Editor_Campo           Ecp
                        , Dbamv.Pw_Documento_Objeto    Dob
                        , Dbamv.Pagu_Objeto            Pob
                    WHERE Pec.Cd_Documento_Clinico     = Pdc.Cd_Documento_Clinico
                      AND Erc.Cd_Registro              = Pec.Cd_Editor_Registro
                      AND Pdc.Cd_Atendimento           = Ate.Cd_Atendimento
                      AND Ecp.Cd_Campo                 = Erc.Cd_campo
                      AND Ate.Cd_Atendimento           = Atendime.cd_atendimento
                      AND Dob.Cd_Documento             = Pec.Cd_Documento
                      AND Dob.Cd_Objeto                = Pob.Cd_Objeto
                      AND Pob.Cd_Tema_Clinico IN (47) --Seleciona os documentos do tema protocolo tev
                      AND (Pdc.Dh_Impresso IS NOT Null
                          OR Pdc.Dh_Fechamento IS NOT NULL)
                      AND Pdc.Cd_Documento_Cancelado IS Null
                      AND Ate.Cd_Multi_Empresa = P_Empresa
                      AND ate.cd_atendimento = P_Atendimento)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento;

cursor cProtocoloTevCirurgico is
---Protocolo Tev Cirurgico ---
Select 1 Protocolo_Tev
  From Dbamv.Atendime
 where not exists (Select 'X'
                     FROM Dbamv.Pw_Documento_Clinico   Pdc
                        , Dbamv.Pw_Editor_Clinico      Pec
                        , Dbamv.Editor_Registro_Campo  Erc
                        , Dbamv.Atendime               Ate
                        , Dbamv.Editor_Campo           Ecp
                        , Dbamv.Pw_Documento_Objeto    Dob
                        , Dbamv.Pagu_Objeto            Pob
                    WHERE Pec.Cd_Documento_Clinico     = Pdc.Cd_Documento_Clinico
                      AND Erc.Cd_Registro              = Pec.Cd_Editor_Registro
                      AND Pdc.Cd_Atendimento           = Ate.Cd_Atendimento
                      AND Ecp.Cd_Campo                 = Erc.Cd_campo
                      AND Ate.Cd_Atendimento           = Atendime.cd_atendimento
                      AND Dob.Cd_Documento             = Pec.Cd_Documento
                      AND Dob.Cd_Objeto                = Pob.Cd_Objeto
                      AND Pob.Cd_Tema_Clinico IN (69) --Seleciona os documentos do tema protocolo tev
                      AND (Pdc.Dh_Impresso IS NOT Null
                          OR Pdc.Dh_Fechamento IS NOT NULL)
                      AND Pdc.Cd_Documento_Cancelado IS Null
                      AND Ate.Cd_Multi_Empresa = P_Empresa
                      AND ate.cd_atendimento = P_Atendimento)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento;

cursor cPrescricaoTevClinico is
---Retorna se Existe a Prescricao de Medicamentos para Protocolo Tev Clinico---
Select 1 Precricao_Protocolo_Tev
  FROM Dbamv.Pw_Documento_Clinico   Pdc
     , Dbamv.Pw_Editor_Clinico      Pec
     , Dbamv.Editor_Registro_Campo  Erc
     , Dbamv.Atendime               Ate
     , Dbamv.Editor_Campo           Ecp
     , Dbamv.Pw_Documento_Objeto    Dob
     , Dbamv.Pagu_Objeto            Pob
     , Dbamv.Pre_Pad                Prp
     , Dbamv.ItPre_Pad              Itp
 WHERE Pec.Cd_Documento_Clinico     = Pdc.Cd_Documento_Clinico
   AND Erc.Cd_Registro              = Pec.Cd_Editor_Registro
   AND Pdc.Cd_Atendimento           = Ate.Cd_Atendimento
   AND Ecp.Cd_Campo                 = Erc.Cd_campo
   AND Dob.Cd_Documento             = Pec.Cd_Documento
   AND Dob.Cd_Objeto                = Pob.Cd_Objeto
   AND Cast(Erc.Lo_Valor as Varchar2(4)) = Cast(Prp.Cd_Pre_Pad as Varchar2(4))
   AND Itp.Cd_Pre_Pad               = Prp.Cd_Pre_Pad
   AND Itp.Cd_Tip_Presc NOT IN (Select Cd_Tip_Presc
                                  FROM Dbamv.Pre_Med
                                     , Dbamv.ItPre_Med
                                     , Dbamv.Atendime
                                 where Pre_Med.Cd_Pre_Med = ItPre_Med.Cd_Pre_Med
                                   AND Atendime.Cd_Atendimento = Pre_Med.Cd_Atendimento
                                   AND ItPre_Med.Cd_Tip_Presc  = Itp.Cd_Tip_Presc
                                   AND Ate.Cd_Multi_Empresa    = P_Empresa
                                   AND ate.cd_atendimento      = P_Atendimento) --Verifica se todos os itens da Prescricao Padrao foi prescrito
   AND Pob.Cd_Tema_Clinico IN (47) --Seleciona os documentos do tema protocolo tev
   AND Pdc.Dh_Fechamento IS NOT NULL
   AND Pdc.Cd_Documento_Cancelado IS NULL
   AND Cast(Erc.Lo_Valor as VARCHAR2(1000)) IS NOT NULL
   AND Upper(Ecp.Ds_Identificador) = Upper('CD_PRESCRICAO_PADRAO_1')
   AND Rownum = 1
   AND Ate.Cd_Multi_Empresa = P_Empresa
   AND ate.cd_atendimento   = P_Atendimento;

cursor cPrescricaoTevCirurgico is
---Retorna se Existe a Prescricao de Medicamentos para Protocolo Tev Clinico---
Select 1 Precricao_Protocolo_Tev
  FROM Dbamv.Pw_Documento_Clinico   Pdc
     , Dbamv.Pw_Editor_Clinico      Pec
     , Dbamv.Editor_Registro_Campo  Erc
     , Dbamv.Atendime               Ate
     , Dbamv.Editor_Campo           Ecp
     , Dbamv.Pw_Documento_Objeto    Dob
     , Dbamv.Pagu_Objeto            Pob
     , Dbamv.Pre_Pad                Prp
     , Dbamv.ItPre_Pad              Itp
 WHERE Pec.Cd_Documento_Clinico     = Pdc.Cd_Documento_Clinico
   AND Erc.Cd_Registro              = Pec.Cd_Editor_Registro
   AND Pdc.Cd_Atendimento           = Ate.Cd_Atendimento
   AND Ecp.Cd_Campo                 = Erc.Cd_campo
   AND Dob.Cd_Documento             = Pec.Cd_Documento
   AND Dob.Cd_Objeto                = Pob.Cd_Objeto
   AND Cast(Erc.Lo_Valor as Varchar2(4)) = Cast(Prp.Cd_Pre_Pad as Varchar2(4))
   AND Itp.Cd_Pre_Pad               = Prp.Cd_Pre_Pad
   AND Itp.Cd_Tip_Presc NOT IN (Select Cd_Tip_Presc
                                  FROM Dbamv.Pre_Med
                                     , Dbamv.ItPre_Med
                                     , Dbamv.Atendime
                                 where Pre_Med.Cd_Pre_Med = ItPre_Med.Cd_Pre_Med
                                   AND Atendime.Cd_Atendimento = Pre_Med.Cd_Atendimento
                                   AND ItPre_Med.Cd_Tip_Presc  = Itp.Cd_Tip_Presc
                                   AND Ate.Cd_Multi_Empresa    = P_Empresa
                                   AND ate.cd_atendimento      = P_Atendimento) --Verifica se todos os itens da Prescricao Padrao foi prescrito
   AND Pob.Cd_Tema_Clinico IN (69) --Seleciona os documentos do tema protocolo tev cirurgico
   AND Pdc.Dh_Fechamento IS NOT NULL
   AND Pdc.Cd_Documento_Cancelado IS NULL
   AND Cast(Erc.Lo_Valor as VARCHAR2(1000)) IS NOT NULL
   AND Upper(Ecp.Ds_Identificador) = Upper('CD_PRESCRICAO_PADRAO_1')
   AND Rownum = 1
   AND Ate.Cd_Multi_Empresa = P_Empresa
   AND ate.cd_atendimento   = P_Atendimento;

cursor cSolicitacaoCti is
---Solicitacao de Internacao no CTI ---
Select 1 SolicitacaoCti
  From Dbamv.Atendime
 where exists (Select 'X'
               FROM Dbamv.Pw_Documento_Clinico   Pdc
                  , Dbamv.Pw_Editor_Clinico      Pec
                  , Dbamv.Editor_Registro_Campo  Erc
                  , Dbamv.Atendime               Ate
                  , Dbamv.Editor_Campo           Ecp
              WHERE Pec.Cd_Documento_Clinico     = Pdc.Cd_Documento_Clinico
                AND Erc.Cd_Registro              = Pec.Cd_Editor_Registro
                AND Pdc.Cd_Atendimento           = Ate.Cd_Atendimento
                AND Ecp.Cd_Campo                 = Erc.Cd_campo
                AND Ate.Cd_Atendimento           = Atendime.cd_atendimento
                AND To_Char(Pec.Cd_Documento) IN (SELECT VALOR
                                                    FROM DBAMV.CONFIGURACAO
                                                   WHERE CHAVE = 'COD_DOCUMENTO_SOLICITACAO_CTI'
                                                     AND CD_SISTEMA = 'PAINEL'
                                                     AND VALOR IS NOT NULL
                                                     AND Rownum = 1
                                                     AND CD_MULTI_EMPRESA = P_Empresa)
                AND Cast(Erc.Lo_Valor as VARCHAR2(1000)) IS NOT NULL
                AND (Pdc.Dh_Impresso IS NOT Null
                    OR Pdc.Dh_Fechamento IS NOT NULL)
                AND Pdc.Cd_Documento_Cancelado IS Null
                AND ate.cd_atendimento = P_Atendimento)
                AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento;

cursor cEvolucaoEnfermeira is
---Envolucao da Enfermeira---
Select Case When To_Char(SYSDATE,'hh24:mi') > (SELECT VALOR
                                                 FROM DBAMV.CONFIGURACAO
                                                WHERE CHAVE = 'HORA_LIMITE_EVOLUCAO_ENFERMAGEM'
                                                  AND CD_SISTEMA = 'PAINEL'
                                                  AND VALOR IS NOT NULL
                                                  AND Rownum = 1
                                                  AND CD_MULTI_EMPRESA = P_EMPRESA)
            Then 1
            Else 2
             END Evolucao
  From Dbamv.Atendime
 where not exists (Select 'X'
                     FROM Dbamv.Pw_Documento_Clinico   Pdc
                        , Dbamv.Pw_Editor_Clinico      Pec
                        , Dbamv.Editor_Registro_Campo  Erc
                        , Dbamv.Atendime               Ate
                        , Dbamv.Editor_Campo           Ecp
                        , Dbamv.Pw_Documento_Objeto    Dob
                        , Dbamv.Pagu_Objeto            Pob
                    WHERE Pec.Cd_Documento_Clinico     = Pdc.Cd_Documento_Clinico
                      AND Erc.Cd_Registro              = Pec.Cd_Editor_Registro
                      AND Pdc.Cd_Atendimento           = Ate.Cd_Atendimento
                      AND Ecp.Cd_Campo                 = Erc.Cd_campo
                      AND Ate.Cd_Atendimento           = Atendime.cd_atendimento
                      AND Dob.Cd_Documento             = Pec.Cd_Documento
                      AND Dob.Cd_Objeto                = Pob.Cd_Objeto
                      AND Pob.Cd_Tema_Clinico IN (7) --Seleciona os documentos do tema evolução da enfermaira
                      AND Cast(Erc.Lo_Valor as VARCHAR2(1000)) IS NOT NULL
                      AND (Pdc.Dh_Impresso IS NOT Null
                          OR Pdc.Dh_Fechamento IS NOT NULL)
                      AND Pdc.Cd_Documento_Cancelado IS Null
                      AND Ate.Cd_Multi_Empresa = P_Empresa
                      AND ate.cd_atendimento = P_Atendimento)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento;

cursor cAnotacaoEnfermagem is
---Anotação da Enfermagem---
Select Case When To_Char(SYSDATE,'hh24:mi') > (SELECT VALOR
                                                 FROM DBAMV.CONFIGURACAO
                                                WHERE CHAVE = 'HORA_LIMITE_ANOTACAO_ENFERMAGEM'
                                                  AND CD_SISTEMA = 'PAINEL'
                                                  AND VALOR IS NOT NULL
                                                  AND Rownum = 1
                                                  AND CD_MULTI_EMPRESA = P_EMPRESA)
            Then 1
            Else 2
             END Anotacao
  From Dbamv.Atendime
 where not exists (Select 'X'
                     FROM Dbamv.Pw_Documento_Clinico   Pdc
                        , Dbamv.Pw_Editor_Clinico      Pec
                        , Dbamv.Editor_Registro_Campo  Erc
                        , Dbamv.Atendime               Ate
                        , Dbamv.Editor_Campo           Ecp
                        , Dbamv.Pw_Documento_Objeto    Dob
                        , Dbamv.Pagu_Objeto            Pob
                    WHERE Pec.Cd_Documento_Clinico     = Pdc.Cd_Documento_Clinico
                      AND Erc.Cd_Registro              = Pec.Cd_Editor_Registro
                      AND Pdc.Cd_Atendimento           = Ate.Cd_Atendimento
                      AND Ecp.Cd_Campo                 = Erc.Cd_campo
                      AND Ate.Cd_Atendimento           = Atendime.cd_atendimento
                      AND Dob.Cd_Documento             = Pec.Cd_Documento
                      AND Dob.Cd_Objeto                = Pob.Cd_Objeto
                      AND Pob.Cd_Tema_Clinico IN (54) --Seleciona os documentos do tema anotacao da enfermagem
                      AND Cast(Erc.Lo_Valor as VARCHAR2(1000)) IS NOT NULL
                      AND (Pdc.Dh_Impresso IS NOT Null
                          OR Pdc.Dh_Fechamento IS NOT NULL)
                      AND Pdc.Cd_Documento_Cancelado IS Null
                      AND Ate.Cd_Multi_Empresa = P_Empresa
                      AND ate.cd_atendimento = P_Atendimento)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento;

cursor cEvolucaoMedica is
---Evolucao Medica---
Select Case When To_Char(SYSDATE,'hh24:mi') > (SELECT VALOR
                                                 FROM DBAMV.CONFIGURACAO
                                                WHERE CHAVE = 'HORA_LIMITE_EVOLUCAO_MEDICA'
                                                  AND CD_SISTEMA = 'PAINEL'
                                                  AND VALOR IS NOT NULL
                                                  AND Rownum = 1
                                                  AND CD_MULTI_EMPRESA = P_EMPRESA)
            Then 1
            Else 2
             END Evolucao
  From Dbamv.Atendime
 where not exists (Select 'X'
                     FROM Dbamv.Pw_Documento_Clinico   Pdc
                        , Dbamv.Pw_Editor_Clinico      Pec
                        , Dbamv.Editor_Registro_Campo  Erc
                        , Dbamv.Atendime               Ate
                        , Dbamv.Editor_Campo           Ecp
                        , Dbamv.Pw_Documento_Objeto    Dob
                        , Dbamv.Pagu_Objeto            Pob
                    WHERE Pec.Cd_Documento_Clinico     = Pdc.Cd_Documento_Clinico
                      AND Erc.Cd_Registro              = Pec.Cd_Editor_Registro
                      AND Pdc.Cd_Atendimento           = Ate.Cd_Atendimento
                      AND Ecp.Cd_Campo                 = Erc.Cd_campo
                      AND Ate.Cd_Atendimento           = Atendime.cd_atendimento
                      AND Dob.Cd_Documento             = Pec.Cd_Documento
                      AND Dob.Cd_Objeto                = Pob.Cd_Objeto
                      AND Pob.Cd_Tema_Clinico IN (6) --Seleciona os documentos do tema evolução médica
                      AND Cast(Erc.Lo_Valor as VARCHAR2(1000)) IS NOT NULL
                      AND (Pdc.Dh_Impresso IS NOT Null
                          OR Pdc.Dh_Fechamento IS NOT NULL)
                      AND Pdc.Cd_Documento_Cancelado IS Null
                      AND Ate.Cd_Multi_Empresa = P_Empresa
                      AND ate.cd_atendimento = P_Atendimento)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento;

cursor cPrescricaoMedica is
---Prescricao Médica---
Select Case When To_Char(SYSDATE,'hh24:mi') > (SELECT VALOR
                                                 FROM DBAMV.CONFIGURACAO
                                                WHERE CHAVE = 'HORA_LIMITE_PRESCRICAO_MEDICA'
                                                  AND CD_SISTEMA = 'PAINEL'
                                                  AND VALOR IS NOT NULL
                                                  AND Rownum = 1
                                                  AND CD_MULTI_EMPRESA = P_EMPRESA)
            Then 1
            Else 2
             END Sn_Prescrito
  From Dbamv.Atendime
 where not exists (Select 'X'
                     From Dbamv.Pre_Med
                        , Dbamv.Atendime Atend
                    where Pre_Med.Dt_Pre_Med between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+.99999
                      and Pre_Med.Cd_Atendimento  = Atendime.Cd_Atendimento
                      and Pre_Med.Cd_Atendimento  = Atend.Cd_Atendimento
                      and atend.dt_alta is null
                      and Atend.tp_atendimento = 'I'
                      and Pre_Med.Tp_Pre_Med = 'M'
                      and Pre_Med.Fl_Impresso = 'S'
                      AND Rownum = 1)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento;

cursor cPedidoFarmaciaPendente is
--solicitação pendente de pedidos de farmacia---
Select 1 PedidoFarmaciaPendente
  From Dbamv.Solsai_Pro   Solsa
     , Dbamv.Atendime     Atend
     , Dbamv.itsolsai_pro ItSol
     , Dbamv.HrItPre_Med  HrItP
 Where Atend.Cd_Atendimento = Solsa.Cd_Atendimento
   and Solsa.cd_solsai_Pro  = ItSol.Cd_Solsai_Pro(+)
   and ItSol.cd_itpre_med   = HrItP.Cd_Itpre_Med (+)
   and Solsa.Tp_Situacao = 'P'
   and Solsa.tp_solsai_pro in ('P','S')
   AND Rownum = 1
   AND Atend.Cd_Multi_Empresa = P_Empresa
   AND atend.cd_atendimento = P_Atendimento;

cursor cPedidoFarmaciaAtrasado is
--solicitação pendente de pedidos atrasados para a medicacao---
Select 1 PedidoFarmaciaAtrasado
  From Dbamv.Solsai_Pro   Solsa
     , Dbamv.Atendime     Atend
     , Dbamv.itsolsai_pro ItSol
     , Dbamv.ItPre_Med    ItPre
     , Dbamv.HrItPre_Med  HrItP
     , Dbamv.Estoque      Estoq
     , Dbamv.Tip_Presc    TipPr
     , Dbamv.Tip_Esq      TipEs
 where Atend.Cd_Atendimento = Solsa.Cd_Atendimento
   and ItSol.cd_itpre_med   = ItPre.cd_itpre_med
   and Estoq.Cd_Estoque     = Solsa.Cd_Estoque
   and TipPr.Cd_Tip_Presc   = ItPre.Cd_Tip_Presc
   and TipPr.Cd_Tip_Esq     = TipEs.Cd_Tip_Esq
   and Solsa.cd_solsai_Pro  = ItSol.Cd_Solsai_Pro(+)
   and ItSol.cd_itpre_med   = HrItP.Cd_Itpre_Med (+)
   and Nvl(ItPre.Tp_Situacao,'N') <> 'S' --Nao comsidera se necessario
   and Solsa.Tp_Situacao = 'P' --so os pendentes
   and TipEs.Sn_Tipo = 'S' -- so Medicamentos
   and Solsa.tp_solsai_pro in ('P','S')
   and (Round(((Sysdate-HrItP.Dh_Medicacao)*24)*60,0)+(SELECT VALOR
                                                         FROM DBAMV.CONFIGURACAO
                                                        WHERE CHAVE = 'MINUTOS_LIMITE_ATENDIMENTO_FARMACIA'
                                                          AND CD_SISTEMA = 'PAINEL'
                                                          AND VALOR IS NOT NULL
                                                          AND Rownum = 1
                                                          AND CD_MULTI_EMPRESA = P_EMPRESA)) > 0
   AND Rownum = 1
   AND Atend.Cd_Multi_Empresa = P_Empresa
   AND atend.cd_atendimento = P_Atendimento;

cursor cMedicacaoAtrasada is
--Medicacao pendente de pedidos atrasados para a medicacao---
Select Decode(TipPr.Ds_Tip_Presc,NULL,NULL,'Medicação Atrasada:'||TipPr.Ds_Tip_Presc) MedicacaoAtrasada
  From Dbamv.Solsai_Pro   Solsa
     , Dbamv.Atendime     Atend
     , Dbamv.itsolsai_pro ItSol
     , Dbamv.ItPre_Med    ItPre
     , Dbamv.HrItPre_Med  HrItP
     , Dbamv.Estoque      Estoq
     , Dbamv.Tip_Presc    TipPr
     , Dbamv.Tip_Esq      TipEs
 where Atend.Cd_Atendimento = Solsa.Cd_Atendimento
   and ItSol.cd_itpre_med   = ItPre.cd_itpre_med
   and Estoq.Cd_Estoque     = Solsa.Cd_Estoque
   and TipPr.Cd_Tip_Presc   = ItPre.Cd_Tip_Presc
   and TipPr.Cd_Tip_Esq     = TipEs.Cd_Tip_Esq
   and Solsa.cd_solsai_Pro  = ItSol.Cd_Solsai_Pro(+)
   and ItSol.cd_itpre_med   = HrItP.Cd_Itpre_Med (+)
   and Nvl(ItPre.Tp_Situacao,'N') <> 'S' --Nao comsidera se necessario
   and Solsa.Tp_Situacao = 'P' --so os pendentes
   and TipEs.Sn_Tipo = 'S' -- so Medicamentos
   and Solsa.tp_solsai_pro in ('P','S')
   and (Round(((Sysdate-HrItP.Dh_Medicacao)*24)*60,0)+(SELECT VALOR
                                                         FROM DBAMV.CONFIGURACAO
                                                        WHERE CHAVE = 'MINUTOS_LIMITE_ATENDIMENTO_FARMACIA'
                                                          AND CD_SISTEMA = 'PAINEL'
                                                          AND VALOR IS NOT NULL
                                                          AND Rownum = 1
                                                          AND CD_MULTI_EMPRESA = P_EMPRESA)) > 0
   AND Rownum = 1
   AND Atend.Cd_Multi_Empresa = P_Empresa
   AND atend.cd_atendimento = P_Atendimento;

cursor cPedidoMedicacaoAtrasada is
--Codigo do Pedido Medicacao atrasados para o paciente---
Select Decode(Solsa.Cd_SolSai_Pro,NULL,NULL,'Pedido:'||Solsa.Cd_SolSai_Pro) PedidoMedicacaoAtrasada
  From Dbamv.Solsai_Pro   Solsa
     , Dbamv.Atendime     Atend
     , Dbamv.itsolsai_pro ItSol
     , Dbamv.ItPre_Med    ItPre
     , Dbamv.HrItPre_Med  HrItP
     , Dbamv.Estoque      Estoq
     , Dbamv.Tip_Presc    TipPr
     , Dbamv.Tip_Esq      TipEs
 where Atend.Cd_Atendimento = Solsa.Cd_Atendimento
   and ItSol.cd_itpre_med   = ItPre.cd_itpre_med
   and Estoq.Cd_Estoque     = Solsa.Cd_Estoque
   and TipPr.Cd_Tip_Presc   = ItPre.Cd_Tip_Presc
   and TipPr.Cd_Tip_Esq     = TipEs.Cd_Tip_Esq
   and Solsa.cd_solsai_Pro  = ItSol.Cd_Solsai_Pro(+)
   and ItSol.cd_itpre_med   = HrItP.Cd_Itpre_Med (+)
   and Nvl(ItPre.Tp_Situacao,'N') <> 'S' --Nao comsidera se necessario
   and Solsa.Tp_Situacao = 'P' --so os pendentes
   and TipEs.Sn_Tipo = 'S' -- so Medicamentos
   and Solsa.tp_solsai_pro in ('P','S')
   and (Round(((Sysdate-HrItP.Dh_Medicacao)*24)*60,0)+(SELECT VALOR
                                                         FROM DBAMV.CONFIGURACAO
                                                        WHERE CHAVE = 'MINUTOS_LIMITE_ATENDIMENTO_FARMACIA'
                                                          AND CD_SISTEMA = 'PAINEL'
                                                          AND VALOR IS NOT NULL
                                                          AND Rownum = 1
                                                          AND CD_MULTI_EMPRESA = P_EMPRESA)) > 0
   AND Rownum = 1
   AND Atend.Cd_Multi_Empresa = P_Empresa
   AND atend.cd_atendimento = P_Atendimento;

cursor cPedidoFarmaciaDevolucao is
--solicitação pendente de devolucoes de farmacia---
Select Case When Atendime.Dt_Alta_Medica IS Null
            Then 1
            Else 2
             END Sn_Prescrito
  From Dbamv.Atendime
 where exists (Select 'X'
                From Dbamv.Solsai_Pro Solsa
                   , Dbamv.Atendime   Atend
               where SolSa.Cd_Atendimento = Atendime.Cd_Atendimento
                 and Atend.Cd_Atendimento = Solsa.Cd_Atendimento
                 and Solsa.Tp_Situacao = 'P'
                 and Solsa.tp_solsai_pro in ('D','C')
                 AND Rownum = 1)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   and atendime.cd_atendimento = P_Atendimento;

cursor cChecagemMedicacao IS
---Checagens Pendentes---
SELECT 1 Checagem
  FROM (SELECT Itp.Cd_ItPre_Med
          FROM Dbamv.Atendime  Ate
             , Dbamv.Pre_Med   Pre
             , Dbamv.ItPre_Med Itp
             , Dbamv.Tip_Esq   Esq
         where Ate.Dt_Atendimento > SYSDATE-10
           AND Pre.Dt_Pre_Med > SYSDATE-10
           AND Ate.Tp_Atendimento = 'I'
           AND Ate.Dt_Alta IS NULL
           AND Itp.Cd_Pre_Med = Pre.Cd_Pre_Med
           AND Nvl(Itp.Tp_Situacao,'N')  = 'N'
           AND Nvl(Itp.Sn_Cancelado,'N') = 'N'
           AND Pre.Tp_Pre_Med IN ('M','E')
           AND Esq.Cd_Tip_Esq = Itp.Cd_Tip_Esq
           AND Esq.Tp_Checagem = 'CC'
           AND Ate.Cd_Atendimento = Pre.Cd_Atendimento
           AND Rownum = 1
           AND Ate.Cd_Multi_Empresa = P_Empresa
           AND Ate.Cd_Atendimento = P_Atendimento
             ) Ate
      , Dbamv.HrItPre_Med
      , Dbamv.ItPre_Med
      , Dbamv.Pre_Med
      , Dbamv.HrItpre_Cons
      , Dbamv.Tip_Presc
      , Dbamv.Config_Pagu_Setor
 WHERE Ate.Cd_ItPre_Med  = HrItPre_Med.Cd_ItPre_Med
   AND Ate.Cd_ItPre_Med = ItPre_Med.Cd_ItPre_Med
   AND HrItPre_Cons.Cd_ItPre_Med(+) = HrItPre_Med.Cd_ItPre_Med
   AND HrItPre_Cons.Dh_Medicacao(+) = HrItPre_Med.Dh_Medicacao
   AND ItPre_Med.Cd_Tip_Presc       = Tip_Presc.Cd_Tip_Presc
   AND ItPre_Med.Cd_Pre_Med         = Pre_Med.Cd_Pre_Med
   AND Pre_Med.Cd_Setor             = Config_Pagu_Setor.Cd_Setor
   AND HrItPre_Med.Dh_Medicacao > SYSDATE-10
   AND HrItPre_Cons.Dh_Medicacao IS NULL
   AND Rownum = 1
   AND ((sysdate-HrItPre_Med.Dh_Medicacao)*24)*60 > Config_Pagu_Setor.Qt_Atraso_Checagem; --Maior que o tempo informado na configuracao

cursor cBalancoHidrico is
---Balanco Hidrico---
Select 1 Balancohidrico
  From (SELECT Atendime.Cd_Atendimento, Atendime.Cd_Multi_Empresa
          FROM Dbamv.Atendime
         WHERE Atendime.Cd_Multi_Empresa = P_Empresa
           AND Atendime.Dt_Atendimento > SYSDATE-10
           AND Atendime.Dt_Alta IS NULL
           AND Atendime.Tp_Atendimento = 'I') Ate
     , Dbamv.Balanco_Hidrico
 Where Ate.Cd_Atendimento = Balanco_Hidrico.Cd_Atendimento
   and (sysdate-balanco_hidrico.dt_referencia)*24 > 24 --Maior que 24 Horas
   and (balanco_hidrico.cd_atendimento,to_char(balanco_hidrico.dt_referencia,'dd/mm/yyyy'))
       not in (select Balanco_Hidrico_Fechamento.Cd_atendimento
                   , to_char(balanco_hidrico_fechamento.dt_referencia,'dd/mm/yyyy')
                from Dbamv.balanco_Hidrico_Fechamento
                   , Dbamv.Atendime
               where Atendime.Dt_Atendimento > SYSDATE-10
                 AND balanco_hidrico_fechamento.cd_atendimento = atendime.cd_atendimento
                 and balanco_Hidrico_Fechamento.Tp_Fechamento = 'T'
                 AND Rownum = 1
                 AND balanco_hidrico_fechamento.cd_atendimento = P_Atendimento)
   AND Ate.Cd_Multi_Empresa = P_Empresa
   AND Ate.Cd_Atendimento = P_Atendimento;

cursor cAltaMedica is
---Alta Medica---
Select 1 AltaMedica
  From dbamv.Atendime
 where Atendime.Dt_Alta_medica is not NULL
   AND Atendime.Tp_Atendimento = 'I'
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND Atendime.Cd_Atendimento = P_Atendimento;

cursor cAvisoAlergiaDoc is
---Alergia Informada em Documento---
Select 1 AvisoAlergiaDoc
 From (SELECT Cd_Atendimento
         FROM Dbamv.Atendime
        WHERE Atendime.Tp_Atendimento = 'I'
          AND Atendime.Dt_Atendimento > SYSDATE-10
          AND Atendime.Dt_Alta IS NULL
          AND Atendime.Cd_Atendimento = P_Atendimento) Ate
  where exists (Select 'X'
                  FROM Dbamv.Pw_Documento_Clinico   Pdc
                     , Dbamv.Pw_Editor_Clinico      Pec
                     , Dbamv.Editor_Registro_Campo  Erc
                     , Dbamv.Atendime               Ate
                     , Dbamv.Editor_Campo           Ecp
                 WHERE Pec.Cd_Documento_Clinico = Pdc.Cd_Documento_Clinico
                   AND Erc.Cd_Registro          = Pec.Cd_Editor_Registro
                   AND Pdc.Cd_Atendimento       = Ate.Cd_Atendimento
                   AND Ecp.Cd_Campo             = Erc.Cd_campo
                   AND Cast(Erc.Lo_Valor as VARCHAR2(1000)) IS NOT null
                   AND (Pdc.Dh_Impresso IS NOT Null
                        OR Pdc.Dh_Fechamento IS NOT NULL)
                   AND Pdc.Cd_Documento_Cancelado IS Null
                   AND To_Char(Ecp.Cd_Metadado) IN (SELECT VALOR
                                                      FROM DBAMV.CONFIGURACAO
                                                     WHERE CHAVE = 'COD_PERGUNTA_DOC_ALERGIA'
                                                       AND CD_SISTEMA = 'PAINEL'
                                                       AND VALOR IS NOT NULL
                                                       AND Rownum = 1
                                                       AND CD_MULTI_EMPRESA = P_Empresa) ---Perguntas dos documentos que se referenm a ALERGIAS
                   AND Ate.Dt_Atendimento > SYSDATE-10
                   and Pdc.Dh_Referencia BETWEEN Ate.dt_atendimento AND SYSDATE
                   AND Ate.Tp_Atendimento = 'I'
                   AND Rownum = 1
                   AND Ate.Cd_Multi_Empresa = P_Empresa
                   AND ate.cd_atendimento = P_Atendimento);

Cursor cAvisoAlergiaTela is
---Alergia Informada em Tela de Atendimento---
Select 1 AvisoAlergiaTela
 From Dbamv.Atendime
where exists (Select Atend.Cd_Atendimento
                FROM Dbamv.Subs_Pac
                   , Dbamv.Atendime Atend
               WHERE Subs_Pac.Cd_Paciente = Atend.Cd_Paciente
                 AND Atend.Cd_Paciente    = Atendime.cd_Paciente
                 AND To_Char(Subs_Pac.Cd_Substancia) NOT IN (SELECT VALOR
                                                               FROM DBAMV.CONFIGURACAO
                                                              WHERE CHAVE = 'COD_SUBSTANCIA_NEGA_ALERGIA'
                                                                AND CD_SISTEMA = 'PAINEL'
                                                                AND VALOR IS NOT NULL
                                                                AND Rownum = 1
                                                                AND CD_MULTI_EMPRESA = P_EMPRESA))
  AND Atendime.Cd_Multi_Empresa = P_Empresa
  AND Rownum = 1
  AND Atendime.Dt_Atendimento > SYSDATE-10
  AND Atendime.Cd_Atendimento = P_Atendimento;

Cursor cMonitoramento is
---Monitoramento (Equipamento e Gases)---
Select 1 Monitoramento
  From Dbamv.Mvto_Gases
     , Dbamv.Atendime
 WHERE Mvto_Gases.Cd_Atendimento = Atendime.Cd_Atendimento
   AND Mvto_Gases.Hr_Desliga IS NULL
   AND Atendime.Dt_Atendimento > SYSDATE-10
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento;

Cursor cProximohorario is
---Proximo Horario da Medicacao---
SELECT To_Char(HrItPre_Med.Dh_Medicacao,'hh24:mi') ProximoHorario
  FROM (SELECT Cd_Atendimento, Cd_Multi_Empresa
          FROM Dbamv.Atendime
         WHERE Atendime.Cd_Multi_Empresa = P_Empresa
           AND Atendime.Dt_Atendimento > SYSDATE-10
             ) Atendime
     , Dbamv.HrItPre_Med  HrItPre_Med
     , Dbamv.ItPre_Med    ItPre_Med
     , Dbamv.tip_esq      Tip_Esq
     , Dbamv.Pre_Med      Pre_Med
     , Dbamv.Tip_Presc    Tip_Presc
     , Dbamv.Config_Pagu_setor Conf_Set
 WHERE HrItPre_Med.Cd_ItPre_Med  = ItPre_Med.Cd_ItPre_Med
   AND Tip_Esq.Cd_Tip_Esq        = ItPre_Med.Cd_Tip_Esq
   AND Pre_Med.Cd_Pre_Med        = ItPre_Med.Cd_Pre_Med
   AND Pre_Med.Cd_Setor          = Conf_Set.Cd_Setor
   and Atendime.Cd_Atendimento   = Pre_Med.Cd_Atendimento
   AND Tip_Presc.Cd_Tip_Presc    = ItPre_Med.Cd_Tip_Presc
   and Tip_Presc.Cd_Tip_Presc    = ItPre_Med.Cd_Tip_Presc
   and Tip_Presc.Cd_Tip_Esq      = Tip_Esq.Cd_Tip_Esq
   and Nvl(ItPre_Med.Tp_Situacao,'N') <> 'S' --Nao comsidera se necessario
   AND Pre_Med.Tp_Pre_Med IN ('M','E')
   AND Tip_Esq.Tp_Checagem = 'CC'
   AND Nvl(ItPre_Med.Tp_Situacao,'N') = 'N'
   AND Nvl(ItPre_Med.Sn_Cancelado,'N') = 'N'
   AND Nvl(Tip_Esq.Sn_Tipo,'N') = 'S' ---Visualiza apenas as medicações
   AND HrItPre_Med.Dh_Medicacao between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+2 --medicacao de hoje até 2 dias
   AND HrItPre_Med.Dh_Medicacao >= SYSDATE --Veifica o proximo horario desconsiderando as checagem atrasadas
   AND NOT exists (SELECT 'X'
                     FROM (SELECT Cd_Atendimento
                             FROM Dbamv.Atendime
                            WHERE Atendime.Dt_Atendimento > SYSDATE-10
                                ) Atend
                        , Dbamv.Hritpre_Cons HrCons
                        , Dbamv.ItPre_Med    ItPreM
                        , Dbamv.Tip_esq      TipEsq
                        , Dbamv.Pre_Med      PreMed
                        , Dbamv.Config_Pagu_setor Conf_Set
                    WHERE HrCons.Cd_ItPre_Med  = ItPreM.Cd_ItPre_Med
                      AND TipEsq.Cd_Tip_Esq    = ItPreM.Cd_Tip_Esq
                      AND PreMed.Cd_Pre_Med    = ItPreM.Cd_Pre_Med
                      and Atend.Cd_Atendimento = PreMed.Cd_Atendimento
                      AND PreMed.Cd_Pre_Med    = Pre_Med.Cd_Pre_Med
                      AND Pre_Med.Cd_Setor     = Conf_Set.Cd_Setor
                      AND PreMed.Tp_Pre_Med IN ('M','E')
                      AND TipEsq.Tp_Checagem   = 'CC'
                      AND Nvl(ItPreM.Tp_Situacao,'N') = 'N'
                      AND Nvl(ItPreM.Sn_Cancelado,'N') = 'N'
                      AND Nvl(Tip_Esq.Sn_Tipo,'N') = 'S' ---Visualiza apenas as medicações
                      AND HrItPre_Med.Dh_Medicacao between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+2 --Medicacao de hoje até 2 dias
                      AND ItPreM.Cd_ItPre_Med  = HrItPre_Med.Cd_ItPre_Med
                      AND HrCons.Dh_Medicacao  = HrItPre_Med.Dh_Medicacao
                      AND Rownum = 1
                      AND Atend.Cd_Atendimento = P_Atendimento) --Medicacao de hoje
      AND Atendime.Cd_Multi_Empresa = P_Empresa
      AND Atendime.Cd_Atendimento = P_Atendimento
    ORDER BY HrItPre_Med.Dh_Medicacao;

Cursor cProximaMedicacao is
---Proxima Medicacao---
SELECT Decode(Tip_Presc.Ds_Tip_Presc,NULL,NULL,'Próxima Medicação:'||Tip_Presc.Ds_Tip_Presc)  ProximaMedicacao
  FROM (SELECT Cd_Atendimento, Cd_Multi_Empresa
          FROM Dbamv.Atendime
         WHERE Atendime.Cd_Multi_Empresa = P_Empresa
           AND Atendime.Dt_Atendimento > SYSDATE-10
             ) Atendime
     , Dbamv.HrItPre_Med  HrItPre_Med
     , Dbamv.ItPre_Med    ItPre_Med
     , Dbamv.tip_esq      Tip_Esq
     , Dbamv.Pre_Med      Pre_Med
     , Dbamv.Tip_Presc    Tip_Presc
     , Dbamv.Prestador    Prestador
     , Dbamv.Config_Pagu_setor Conf_Set
 WHERE Pre_Med.Cd_Prestador     = Prestador.Cd_Prestador
   AND HrItPre_Med.Cd_ItPre_Med = ItPre_Med.Cd_ItPre_Med
   AND Tip_Esq.Cd_Tip_Esq       = ItPre_Med.Cd_Tip_Esq
   AND Pre_Med.Cd_Pre_Med       = ItPre_Med.Cd_Pre_Med
   AND Pre_Med.Cd_Setor         = Conf_Set.Cd_Setor
   and Atendime.Cd_Atendimento  = Pre_Med.Cd_Atendimento
   AND Tip_Presc.Cd_Tip_Presc   = ItPre_Med.Cd_Tip_Presc
   and Tip_Presc.Cd_Tip_Presc   = ItPre_Med.Cd_Tip_Presc
   and Tip_Presc.Cd_Tip_Esq     = Tip_Esq.Cd_Tip_Esq
   and Nvl(ItPre_Med.Tp_Situacao,'N') <> 'S' --Nao comsidera se necessario
   AND Pre_Med.Tp_Pre_Med IN ('M','E')
   AND Tip_Esq.Tp_Checagem = 'CC'
   AND Nvl(ItPre_Med.Tp_Situacao,'N') = 'N'
   AND Nvl(ItPre_Med.Sn_Cancelado,'N') = 'N'
   AND Nvl(Tip_Esq.Sn_Tipo,'N') = 'S' ---Visualiza apenas as medicações
   AND HrItPre_Med.Dh_Medicacao between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+2 --medicacao de hoje até 2 dias
   AND HrItPre_Med.Dh_Medicacao >= SYSDATE --Veifica o proximo horario desconsiderando as checagem atrasadas
   AND NOT exists (SELECT 'X'
                     FROM (SELECT Cd_Atendimento
                             FROM Dbamv.Atendime
                            WHERE Atendime.Cd_Multi_Empresa = P_Empresa
                              AND Atendime.Dt_Atendimento > SYSDATE-10
                                ) Atend
                        , Dbamv.Hritpre_Cons HrCons
                        , Dbamv.ItPre_Med    ItPreM
                        , Dbamv.Tip_esq      TipEsq
                        , Dbamv.Pre_Med      PreMed
                        , Dbamv.Config_Pagu_setor Conf_Set
                    WHERE HrCons.Cd_ItPre_Med   = ItPreM.Cd_ItPre_Med
                      AND TipEsq.Cd_Tip_Esq     = ItPreM.Cd_Tip_Esq
                      AND PreMed.Cd_Pre_Med     = ItPreM.Cd_Pre_Med
                      and Atend.Cd_Atendimento  = PreMed.Cd_Atendimento
                      AND PreMed.Cd_Pre_Med     = Pre_Med.Cd_Pre_Med
                      AND Pre_Med.Cd_Setor      = Conf_Set.Cd_Setor
                      AND PreMed.Tp_Pre_Med IN ('M','E')
                      AND TipEsq.Tp_Checagem = 'CC'
                      AND Nvl(ItPreM.Tp_Situacao,'N') = 'N'
                      AND Nvl(ItPreM.Sn_Cancelado,'N') = 'N'
                      AND Nvl(Tip_Esq.Sn_Tipo,'N') = 'S' ---Visualiza apenas as medicações
                      AND HrItPre_Med.Dh_Medicacao between TRUNC(SYSDATE) AND TRUNC(SYSDATE)+2  --medicacao de hoje até tres dias
                      AND ItPreM.Cd_ItPre_Med  = HrItPre_Med.Cd_ItPre_Med
                      AND HrCons.Dh_Medicacao  = HrItPre_Med.Dh_Medicacao
                      AND Rownum = 1
                      AND Atend.Cd_Atendimento = Atendime.Cd_Atendimento) --Medicacao de hoje
    AND Atendime.Cd_Multi_Empresa = P_Empresa
    AND Atendime.Cd_Atendimento   = P_Atendimento
  ORDER BY HrItPre_Med.Dh_Medicacao;

Cursor cAprazamento is
---Aprazamento Aberto---
SELECT 1 Aprazamento
  FROM (SELECT Cd_Atendimento, Cd_Multi_Empresa
          FROM Dbamv.Atendime
         WHERE Atendime.Cd_Multi_Empresa = P_Empresa
           AND Atendime.Dt_Atendimento > SYSDATE-10
             ) Atendime
     , Dbamv.HrItPre_Med       HrItPre_Med
     , Dbamv.ItPre_Med         ItPre_Med
     , Dbamv.tip_esq           Tip_Esq
     , Dbamv.Pre_Med           Pre_Med
     , Dbamv.Config_Pagu_setor Conf_Set
 WHERE HrItPre_Med.Cd_ItPre_Med(+) = ItPre_Med.Cd_ItPre_Med
   AND Tip_Esq.Cd_Tip_Esq          = ItPre_Med.Cd_Tip_Esq
   AND Pre_Med.Cd_Pre_Med          = ItPre_Med.Cd_Pre_Med
   AND Pre_Med.Cd_Setor            = Conf_Set.Cd_Setor
   and Atendime.Cd_Atendimento     = Pre_Med.Cd_Atendimento
   AND Pre_Med.Tp_Pre_Med IN ('M','E')
   AND Tip_Esq.Tp_Checagem = 'CC'
   AND Nvl(ItPre_Med.Tp_Situacao,'N') = 'N'
   AND Nvl(ItPre_Med.Sn_Cancelado,'N') = 'N'
   AND Nvl(ItPre_Med.Tp_Situacao,'N')  = 'N' -- Elimina os itens se necessário que não é obrigatorio ter prescricao
   AND HrItPre_Med.Cd_ItPre_Med Is NULL -- Medicamentos Não Aprazados
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND Atendime.Cd_Atendimento = P_Atendimento;

Cursor cPrescricaoaberta is
---Prescricao Aberta---
SELECT 1 PrescricaoAberta
  FROM Dbamv.Pre_Med  Pre_Med
     , Dbamv.Atendime Atendime
 WHERE Atendime.Cd_Atendimento = Pre_Med.Cd_Atendimento
   AND Pre_Med.Tp_Pre_Med IN ('M','E')
   AND Nvl(Pre_Med.Fl_Impresso,'N') = 'N' --Prescricao Aberta (No memorial Guararapes tinha Fl_Impresso 'S' e Fl_Fechada = 'N')
   AND Atendime.Dt_Atendimento > SYSDATE-10
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND Atendime.Cd_Atendimento = P_Atendimento;

Cursor cAuditoriaChecagem is
---Fechamento da Auditoria de Checagem (Fechemento da Checagem pela enfermagem)---
Select 1 AuditoriaChecagem
  FROM (SELECT Cd_Atendimento, Cd_Multi_Empresa
          FROM Dbamv.Atendime
         WHERE Atendime.Cd_Multi_Empresa = P_Empresa
           AND Atendime.Dt_Alta IS NULL
           AND Atendime.Tp_Atendimento = 'I'
           AND Atendime.Dt_Atendimento > SYSDATE-10
             ) Atendime
     , Dbamv.ItPre_Med
     , Dbamv.Pre_Med
     , Dbamv.Tip_Esq
 where ItPre_Med.Cd_Pre_Med = Pre_Med.Cd_Pre_Med
   AND ItPre_Med.cd_Tip_Esq = Tip_Esq.cd_Tip_Esq
   AND Tip_Esq.Tp_Checagem  = 'CC'
   AND Nvl(ItPre_Med.Tp_Situacao,'N')  = 'N'
   AND Nvl(ItPre_Med.Sn_Cancelado,'N') = 'N'
   AND Pre_Med.Tp_Pre_Med IN ('M','E')
   AND Pre_Med.Dt_Pre_Med > SYSDATE-10
   AND (SYSDATE-Pre_Med.Dt_Pre_Med)*24 > 24   --Após 24 horas
   AND exists (SELECT 'X'
                 FROM Dbamv.HrItPre_Cons
                WHERE HrItPre_Cons.Cd_ItPre_Med = ItPre_Med.Cd_ItPre_Med
                  AND HrItPre_Cons.Cd_Fechamento IS NULL
                  AND Rownum = 1)
   AND Atendime.Cd_Atendimento = Pre_Med.Cd_Atendimento
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND Atendime.Cd_Atendimento = P_Atendimento;

Cursor cLocalblococirurgico is
---Local do Paciente no Bloco Cirurgico---
 SELECT CASE WHEN Dt_Centro_Cirurgico IS NOT NULL
              AND DT_Entrada_Rpa IS null
              AND Dt_Saida_Rpa IS null
             THEN 1 --Esta no Bloco Cirurgico
             WHEN DT_Entrada_Rpa IS NOT NULL
              AND Dt_Saida_Rpa IS null
             THEN 2 --Entrou no RPA
             WHEN Dt_Saida_Rpa IS NOT NULL
             THEN 3 --Está no leito
              END LocPaciente
   FROM Dbamv.Mov_CC_Rpa
      , Dbamv.Atendime
  WHERE Mov_CC_Rpa.Cd_Atendimento = Atendime.cd_Atendimento
    AND Rownum = 1
    AND Atendime.Cd_Multi_Empresa = P_Empresa
    AND Mov_CC_Rpa.Cd_Atendimento = P_Atendimento;

Cursor cVlrScorePainelEnfermagem is
---Resultado a Ultima Avaliação (Score da Enfermagem Configurado no Parametro Geral)---
Select Round(Vl_Resultado,2) VlrScoreEnfermagem
  From DBAMV.Pagu_Avaliacao
     , Dbamv.Pagu_Formula
     , Dbamv.Atendime
 where Pagu_Avaliacao.Cd_Formula = Pagu_Formula.Cd_Formula
   AND Atendime.Cd_Atendimento = Pagu_Avaliacao.Cd_Atendimento
   And Pagu_Formula.Cd_Formula IN (SELECT VALOR
                                     FROM DBAMV.CONFIGURACAO
                                    WHERE CHAVE = 'COD_AVALIACAO_PAINEL_ENFERMAGEM'
                                      AND CD_SISTEMA = 'PAINEL'
                                      AND VALOR IS NOT NULL
                                      AND Rownum = 1
                                      AND CD_MULTI_EMPRESA = P_EMPRESA)
   And Pagu_Avaliacao.Cd_Avaliacao
       In (Select Max(Avaliacao.Cd_Avaliacao)
             From Dbamv.Pagu_Avaliacao Avaliacao
                , Dbamv.Pagu_Formula Formula
            where Avaliacao.Cd_Formula = Formula.Cd_Formula
              And Avaliacao.Cd_Atendimento = Pagu_Avaliacao.Cd_Atendimento
              And Formula.Tp_Formula = Pagu_Formula.Tp_Formula
            Group By Avaliacao.Cd_Atendimento)
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND Rownum = 1
   And Pagu_Avaliacao.Cd_Atendimento = P_Atendimento;

Cursor cVlrScorePainelMedico is
---Resultado a Ultima Avaliação (Score do Medico Configurado no Parametro Geral)---
Select Round(Vl_Resultado,2) VlrScoreMedico
  From DBAMV.Pagu_Avaliacao
     , Dbamv.Pagu_Formula
     , Dbamv.Atendime
 where Pagu_Avaliacao.Cd_Formula = Pagu_Formula.Cd_Formula
   And Pagu_Avaliacao.Cd_Atendimento = Pagu_Avaliacao.Cd_Atendimento
   And Pagu_Formula.Cd_Formula IN (SELECT VALOR
                                     FROM DBAMV.CONFIGURACAO
                                    WHERE CHAVE = 'COD_AVALIACAO_PAINEL_MEDICO'
                                      AND CD_SISTEMA = 'PAINEL'
                                      AND VALOR IS NOT NULL
                                      AND Rownum = 1
                                      AND CD_MULTI_EMPRESA = P_EMPRESA)
   And Pagu_Avaliacao.Cd_Avaliacao
       In (Select Max(Avaliacao.Cd_Avaliacao)
             From Dbamv.Pagu_Avaliacao Avaliacao
                , Dbamv.Pagu_Formula   Formula
            where Avaliacao.Cd_Formula = Formula.Cd_Formula
              And Avaliacao.Cd_Atendimento = Pagu_Avaliacao.Cd_Atendimento
              And Formula.Tp_Formula = Pagu_Formula.Tp_Formula
            Group By Avaliacao.Cd_Atendimento)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   And Pagu_Avaliacao.Cd_Atendimento = P_Atendimento;

Cursor cVlrScoreEnfermagem is
---Resultado a Ultima Avaliação (Score da Enfermagem)---
Select Round(Vl_Resultado,2) VlrScoreEnfermagem
  From DBAMV.Pagu_Avaliacao
     , Dbamv.Pagu_Formula
     , Dbamv.Atendime
 where Pagu_Avaliacao.Cd_Formula = Pagu_Formula.Cd_Formula
   AND Atendime.Cd_Atendimento = Pagu_Avaliacao.Cd_Atendimento
   And Pagu_Formula.Tp_Formula IN ('E')
   And Pagu_Avaliacao.Cd_Avaliacao
       In (Select Max(Avaliacao.Cd_Avaliacao)
             From Dbamv.Pagu_Avaliacao Avaliacao
                , Dbamv.Pagu_Formula Formula
            where Avaliacao.Cd_Formula = Formula.Cd_Formula
              And Avaliacao.Cd_Atendimento = Pagu_Avaliacao.Cd_Atendimento
              And Formula.Tp_Formula = Pagu_Formula.Tp_Formula
            Group By Avaliacao.Cd_Atendimento)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   And Pagu_Avaliacao.Cd_Atendimento = P_Atendimento;

Cursor cVlrScoreMedico is
---Resultado a Ultima Avaliação (Score da Medico)---
Select Round(Vl_Resultado,2) VlrScoreMedico
  From DBAMV.Pagu_Avaliacao
     , Dbamv.Pagu_Formula
     , Dbamv.Atendime
 where Pagu_Avaliacao.Cd_Formula = Pagu_Formula.Cd_Formula
   And Pagu_Avaliacao.Cd_Atendimento = Pagu_Avaliacao.Cd_Atendimento
   And Pagu_Formula.Tp_Formula IN ('M')
   And Pagu_Avaliacao.Cd_Avaliacao
       In (Select Max(Avaliacao.Cd_Avaliacao)
             From Dbamv.Pagu_Avaliacao Avaliacao
                , Dbamv.Pagu_Formula   Formula
            where Avaliacao.Cd_Formula = Formula.Cd_Formula
              And Avaliacao.Cd_Atendimento = Pagu_Avaliacao.Cd_Atendimento
              And Formula.Tp_Formula = Pagu_Formula.Tp_Formula
            Group By Avaliacao.Cd_Atendimento)
   AND Rownum = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   And Pagu_Avaliacao.Cd_Atendimento = P_Atendimento;

Cursor cSituacaoSolicitacaoLeito is
---Situação da Solicitação de Leitos (Transferência)---
SELECT Decode(stl.tp_situacao||stl.sn_prioridade,NULL,0,'SN',1,'SS',2,'AN',3,'AS',3) SolicitacaoLeito
  FROM dbamv.solic_transferencia_leito stl
     , dbamv.atendime
     , dbamv.leito
     , dbamv.paciente
 WHERE stl.cd_atendimento = atendime.cd_atendimento
   AND atendime.cd_paciente = paciente.cd_paciente
   AND atendime.cd_leito = leito.cd_leito
   AND stl.tp_situacao IN ('S' ,'A')
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   And Atendime.Cd_Atendimento = P_Atendimento;

Cursor cTempoPermanencia is
---Retorna o tempo de permanencia do Paciente---
SELECT Decode(Atendime.Tp_Atendimento,'I',Trunc(SYSDATE-Dt_Atendimento)||' Dia(s)',(Trunc(SYSDATE-Dt_Atendimento)*60)||' Hr(s)') Dias
  FROM Dbamv.Atendime
 where Atendime.Cd_Multi_Empresa = P_Empresa
   And Atendime.Cd_Atendimento   = P_Atendimento;

Cursor cDataEntradaSame is
---Retorna  a Data de Entrada do Documento no Same---
SELECT to_char(Max(DT_ENTRADA),'dd/mm/yyyy hh24:mi') data
  FROM Dbamv.it_same
     , Dbamv.Atendime
 where It_Same.Cd_Atendimento = Atendime.Cd_Atendimento
   and Atendime.Cd_Multi_Empresa = P_Empresa
   And Atendime.Cd_Atendimento   = P_Atendimento;

Cursor cCorKamBam Is
---Retorna a Cor do Kambam---
SELECT CASE WHEN DiferencaDiasPermanencia <= KambamVerde.Verde
            THEN 1
            WHEN DiferencaDiasPermanencia <= KambamAmarela.Amarela
            THEN 2
            WHEN DiferencaDiasPermanencia >= KambamVermelha.Vermelha
            THEN 3
            ELSE 1
             END  CorKambam
  FROM (SELECT Decode(Convenio.Tp_Convenio,'H',(Round(SYSDATE-Atendime.Dt_Atendimento)-PermanenciaSus.Nr_Dias_Internacao),'C',(Round(SYSDATE-Atendime.Dt_Atendimento)-PermanenciaConvenio.Nr_Dias_Internacao),'P',0)  DiferencaDiasPermanencia
          FROM Dbamv.Atendime
             , Dbamv.Convenio
             , Dbamv.Procedimento_SUS PermanenciaSus
             , (SELECT Guia.Cd_Atendimento
                     , Nvl(Sum(Nr_Dias_Autorizados),0) Nr_Dias_Internacao
                  FROM dbamv.guia
                     , dbamv.it_guia
                 WHERE guia.cd_guia = it_guia.cd_guia(+)
                   AND guia.tp_Guia = 'I'
                   AND guia.cd_atendimento = P_Atendimento
                 GROUP BY Guia.Cd_Atendimento
                     )  PermanenciaConvenio
         WHERE Atendime.Cd_Convenio      = Convenio.Cd_Convenio(+)
           AND Atendime.Cd_procedimento  = PermanenciaSus.Cd_procedimento(+)
           AND Atendime.Cd_Atendimento   = PermanenciaConvenio.Cd_Atendimento(+)
           AND Atendime.Cd_Multi_Empresa = P_Empresa
           AND Atendime.Cd_Atendimento   = P_Atendimento
             ) DiasInternado
       , (SELECT Valor Verde FROM Dbamv.Configuracao WHERE cd_sistema = 'PAINEL' AND CHAVE = 'QTDE_DIAS_LIMITE_KAMBAM_VERDE' AND Cd_Multi_Empresa = P_Empresa)       KambamVerde
       , (SELECT Valor Amarela FROM Dbamv.Configuracao WHERE cd_sistema = 'PAINEL' AND CHAVE = 'QTDE_DIAS_LIMITE_KAMBAM_AMARELA' AND Cd_Multi_Empresa = P_Empresa)   KambamAmarela
       , (SELECT Valor Vermelha FROM Dbamv.Configuracao WHERE cd_sistema = 'PAINEL' AND CHAVE = 'QTDE_DIAS_LIMITE_KAMBAM_VERMELHA' AND Cd_Multi_Empresa = P_Empresa) KambamVermelha
       ;

BEGIN

if P_Tipo='CHECAGEMMEDICACAO' then
   open cChecagemMedicacao;
  fetch cChecagemMedicacao into Resposta;
  close cChecagemMedicacao;
end if;

if P_Tipo='PEDIDOFARMACIAPENDENTE' then
   open cPedidoFarmaciaPendente;
  fetch cPedidoFarmaciaPendente into resposta;
  close cPedidoFarmaciaPendente;
end if;

if P_Tipo='PRESCRICAOMEDICA' then
   open cPrescricaoMedica;
  fetch cPrescricaoMedica into Resposta;
  close cPrescricaoMedica;
end if;

if P_Tipo='EVOLUCAOMEDICA' then
   open cEvolucaoMedica;
  fetch cEvolucaoMedica into Resposta;
  close cEvolucaoMedica;
end if;

if P_Tipo='EVOLUCAOENFERMEIRA' then
   open cEvolucaoEnfermeira;
  fetch cEvolucaoEnfermeira into Resposta;
  close cEvolucaoEnfermeira;
end if;

if P_Tipo='ANOTACAOENFERMAGEM' then
   open cAnotacaoEnfermagem;
  fetch cAnotacaoEnfermagem into Resposta;
  close cAnotacaoEnfermagem;
end if;

if P_Tipo='PROTOCOLOTEVCLINICO' then
   open cProtocoloTevClinico;
  fetch cProtocoloTevClinico into Resposta;
  close cProtocoloTevClinico;
end if;

if P_Tipo='PROTOCOLOTEVCIRURGICO' then
   open cProtocoloTevCirurgico;
  fetch cProtocoloTevCirurgico into Resposta;
  close cProtocoloTevCirurgico;
end if;

if P_Tipo='PRESCRICAOTEVCLINICO' then
   open cPrescricaoTevClinico;
  fetch cPrescricaoTevClinico into Resposta;
  close cPrescricaoTevClinico;
end if;

if P_Tipo='PRESCRICAOTEVCIRURGICO' then
   open cPrescricaoTevCirurgico;
  fetch cPrescricaoTevCirurgico into Resposta;
  close cPrescricaoTevCirurgico;
end if;

if P_Tipo='SOLICITACAOCTI' then
   open cSolicitacaoCti;
  fetch cSolicitacaoCti into Resposta;
  close cSolicitacaoCti;
end if;

if P_Tipo='AGENDABLOCOCIRURGICO' then
   open cAgendaBlocoCirurgico;
  fetch cAgendaBlocoCirurgico into Resposta;
  close cAgendaBlocoCirurgico;
end if;

if P_Tipo='AGENDAHEMODINAMICA' then
   open cAgendaHemodinamica;
  fetch cAgendaHemodinamica into Resposta;
  close cAgendaHemodinamica;
end if;

if P_Tipo='AGENDAENDOSCOPIA' then
   open cAgendaEndoscopia;
  fetch cAgendaEndoscopia into Resposta;
  close cAgendaEndoscopia;
end if;

if P_Tipo='AVISOALERGIADOC' then
   open cAvisoAlergiaDoc;
  fetch cAvisoAlergiaDoc into Resposta;
  close cAvisoAlergiaDoc;
end if;

if P_Tipo='RESULTADOEXAMES' then
   open cResultadoExames;
  fetch cResultadoExames into Resposta;
  close cResultadoExames;
end if;

if P_Tipo='PEDIDOFARMACIADEVOLUCAO' then
   open cPedidoFarmaciaDevolucao;
  fetch cPedidoFarmaciaDevolucao into Resposta;
  close cPedidoFarmaciaDevolucao;
end if;

if P_Tipo='BALANCOHIDRICO' then
   open cBalancoHidrico;
  fetch cBalancoHidrico into Resposta;
  close cBalancoHidrico;
end if;

if P_Tipo='ALTAMEDICA' then
   open cAltaMedica;
  fetch cAltaMedica into Resposta;
  close cAltaMedica;
end if;

if P_Tipo='AVISOALERGIATELA' then
   open cAvisoAlergiaTela;
  fetch cAvisoAlergiaTela into Resposta;
  close cAvisoAlergiaTela;
end if;

if P_Tipo='RESULTADOIMAGENS' then
   open cResultadoImagens;
  fetch cResultadoImagens into Resposta;
  close cResultadoImagens;
end if;

if P_Tipo='MONITORAMENTO' then
   open cMonitoramento;
  fetch cMonitoramento into Resposta;
  close cMonitoramento;
end if;

if P_Tipo='PROXIMOHORARIO' then
   open cProximohorario;
  fetch cProximohorario into Resposta;
  close cProximohorario;
end if;

if P_Tipo='APRAZAMENTO' then
   open cAprazamento;
  fetch cAprazamento into Resposta;
  close cAprazamento;
end if;

if P_Tipo='PRESCRICAOABERTA' then
   open cPrescricaoaberta;
  fetch cPrescricaoaberta into Resposta;
  close cPrescricaoaberta;
end if;

if P_Tipo='PROXIMAMEDICACAO' then
   open cProximaMedicacao;
  fetch cProximaMedicacao into Resposta;
  close cProximaMedicacao;
end if;

if P_Tipo='AUDITORIACHECAGEM' then
   open cAuditoriaChecagem;
  fetch cAuditoriaChecagem into Resposta;
  close cAuditoriaChecagem;
end if;

if P_Tipo='PEDIDOFARMACIAATRASADO' then
   open cPedidoFarmaciaAtrasado;
  fetch cPedidoFarmaciaAtrasado into Resposta;
  close cPedidoFarmaciaAtrasado;
end if;

if P_Tipo='MEDICACAOATRASADA' then
   open cMedicacaoAtrasada;
  fetch cMedicacaoAtrasada into Resposta;
  close cMedicacaoAtrasada;
end if;

if P_Tipo='PEDIDOMEDICACAOATRASADA' then
   open cPedidoMedicacaoAtrasada;
  fetch cPedidoMedicacaoAtrasada into Resposta;
  close cPedidoMedicacaoAtrasada;
end if;

if P_Tipo='LOCALPACIENTE' then
   open cLocalblococirurgico;
  fetch cLocalblococirurgico into Resposta;
  close cLocalblococirurgico;
end if;

if P_Tipo='VLRSCOREPAINELENFERMAGEM' then
   open cVlrScorePainelEnfermagem;
  fetch cVlrScorePainelEnfermagem into Resposta;
  close cVlrScorePainelEnfermagem;
end if;

if P_Tipo='VLRSCOREPAINELMEDICO' then
   open cVlrScorePainelMedico;
  fetch cVlrScorePainelMedico into Resposta;
  close cVlrScorePainelMedico;
end if;

if P_Tipo='VLRSCOREENFERMAGEM' then
   open cVlrScoreEnfermagem;
  fetch cVlrScoreEnfermagem into Resposta;
  close cVlrScoreEnfermagem;
end if;

if P_Tipo='VLRSCOREMEDICO' then
   open cVlrScoreMedico;
  fetch cVlrScoreMedico into Resposta;
  close cVlrScoreMedico;
end if;

if P_Tipo='SITUACAOSOLICITACAOLEITO' then
   open cSituacaoSolicitacaoLeito;
  fetch cSituacaoSolicitacaoLeito into Resposta;
  close cSituacaoSolicitacaoLeito;
end if;

if P_Tipo='TEMPOPERMANENCIA' then
   open cTempoPermanencia;
  fetch cTempoPermanencia into Resposta;
  close cTempoPermanencia;
end if;

if P_Tipo='DATAENTRADASAME' then
   open cDataEntradaSame;
  fetch cDataEntradaSame into Resposta;
  close cDataEntradaSame;
end if;

if P_Tipo='CORKAMBAM' then
  open cCorKambam;
 fetch cCorKambam into Resposta;
 close cCorKambam;
end if;

Return Resposta;
END;