CODE REVIEW TABIA - CAMPO DS_OBSERVACAO_GERAL
===

<br>
<br>

### OBJETIVO DOS TESTES:
Mapear, a partir de manipulações em tela, como o campo `DS_OBSERVACAO_GERAL` é persistido na tabela e refletido na view.

<br>

### CENÁRIOS VALIDADOS:
- M_RECEPCAO_MANUT_AGENDA
- M_RECEPCAO_AGENDA
- VALIDAÇÕES FINAIS EM BANCO

---

<details>
      <summary><strong>⛧ CENÁRIO 1 - M_RECEPCAO_MANUT_AGENDA:</strong></summary>

### CONTEXTO:
- Teste para identificar update no campo `DS_OBSERVACAO_GERAL`.
- `UPDATE` na view `VDIC_RECEPCAO_AGENDA` não mostra explicitamente `DS_OBSERVACAO_GERAL`.
- Há indicação de processamento pela rotina `Pkg_SCMA_M_RECEPCAO_MANU_AGE.P_CHK_AGENDA_CENTRAL`.

### 1) CHAMADA DE PACOTE:
```sql
BEGIN Pkg_SCMA_M_RECEPCAO_MANU_AGE.P_CHK_AGENDA_CENTRAL(:1 , :2 ); END;
```

### 2) UPDATE NA VIEW `DBAMV.VDIC_RECEPCAO_AGENDA`:
```sql
UPDATE dbamv.VDIC_RECEPCAO_AGENDA SET HR_AGENDA = :1 , CD_PACIENTE = :2 , CD_GRUPO_AGENDA = :3 , NM_PACIENTE = :4 , CD_ITEM_AGENDAMENTO = :5 , SN_ATENDIDO = :6 , SN_PUBLICO_IAC = :7 , CD_ATENDIMENTO = :8 , CD_ATENDIMENTO_PAI = :9 , CD_SER_DIS = :10 , CD_TIP_MAR = :11 , TP_SITUACAO = :12 , CD_GRU_ATE = :13 , CD_IT_AGENDA_PAI = :14 , CD_IT_AGENDA_CENTRAL = :15 , VL_PERC_DESCONTO = :16 , VL_NEGOCIADO = :17 , SN_ENCAIXE = :18 , DS_SENHA_PAINEL = :19 , QT_PESO = :20 , VL_ALTURA = :21 , SN_DISPENSA_EQUIPAMENTOS = :22 , SN_SESSAO = :23 , NR_GUIA_SESSAO = :24 , DT_SOLIC_SESSAO = :25 , CD_SENHA_SESSAO = :26 , DT_VALID_SESSAO = :27 , SN_BLOQUEADO = :28 , CD_TIPO_BLOQUEIO = :29 , TP_PRESENCA_FALTA = :30 , DH_PRESENCA_FALTA = :31 , CD_USUARIO_PRESENCA_FALTA = :32 , NR_ID_ENVIO_SMS = :33
WHERE (HR_AGENDA = :34
      OR HR_AGENDA IS NULL
      AND :35 IS NULL)
      AND (CD_PACIENTE = :36
      OR CD_PACIENTE IS NULL
      AND :37 IS NULL)
      AND (CD_GRUPO_AGENDA = :38
      OR CD_GRUPO_AGENDA IS NULL
      AND :39 IS NULL)
      AND (NM_PACIENTE = :40
      OR NM_PACIENTE IS NULL
      AND :41 IS NULL)
      AND (CD_ITEM_AGENDAMENTO = :42
      OR CD_ITEM_AGENDAMENTO IS NULL
      AND :43 IS NULL)
      AND (SN_ATENDIDO = :44
      OR SN_ATENDIDO IS NULL
      AND :45 IS NULL)
      AND (SN_PUBLICO_IAC = :46
      OR SN_PUBLICO_IAC IS NULL
      AND :47 IS NULL)
      AND (CD_ATENDIMENTO = :48
      OR CD_ATENDIMENTO IS NULL
      AND :49 IS NULL)
      AND (CD_ATENDIMENTO_PAI = :50
      OR CD_ATENDIMENTO_PAI IS NULL
      AND :51 IS NULL)
      AND (CD_SER_DIS = :52
      OR CD_SER_DIS IS NULL
      AND :53 IS NULL)
      AND (CD_TIP_MAR = :54
      OR CD_TIP_MAR IS NULL
      AND :55 IS NULL)
      AND (TP_SITUACAO = :56
      OR TP_SITUACAO IS NULL
      AND :57 IS NULL)
      AND (CD_GRU_ATE = :58
      OR CD_GRU_ATE IS NULL
      AND :59 IS NULL)
      AND (CD_IT_AGENDA_PAI = :60
      OR CD_IT_AGENDA_PAI IS NULL
      AND :61 IS NULL)
      AND (CD_IT_AGENDA_CENTRAL = :62
      OR CD_IT_AGENDA_CENTRAL IS NULL
      AND :63 IS NULL)
      AND (VL_PERC_DESCONTO = :64
      OR VL_PERC_DESCONTO IS NULL
      AND :65 IS NULL)
      AND (VL_NEGOCIADO = :66
      OR VL_NEGOCIADO IS NULL
      AND :67 IS NULL)
      AND (SN_ENCAIXE = :68
      OR SN_ENCAIXE IS NULL
      AND :69 IS NULL)
      AND (DS_SENHA_PAINEL = :70
      OR DS_SENHA_PAINEL IS NULL
      AND :71 IS NULL)
      AND (QT_PESO = :72
      OR QT_PESO IS NULL
      AND :73 IS NULL)
      AND (VL_ALTURA = :74
      OR VL_ALTURA IS NULL
      AND :75 IS NULL)
      AND (SN_DISPENSA_EQUIPAMENTOS = :76
      OR SN_DISPENSA_EQUIPAMENTOS IS NULL
      AND :77 IS NULL)
      AND (SN_SESSAO = :78
      OR SN_SESSAO IS NULL
      AND :79 IS NULL)
      AND (NR_GUIA_SESSAO = :80
      OR NR_GUIA_SESSAO IS NULL
      AND :81 IS NULL)
      AND (DT_SOLIC_SESSAO = :82
      OR DT_SOLIC_SESSAO IS NULL
      AND :83 IS NULL)
      AND (CD_SENHA_SESSAO = :84
      OR CD_SENHA_SESSAO IS NULL
      AND :85 IS NULL)
      AND (DT_VALID_SESSAO = :86
      OR DT_VALID_SESSAO IS NULL
      AND :87 IS NULL)
      AND (CD_TIPO_BLOQUEIO = :88
      OR CD_TIPO_BLOQUEIO IS NULL
      AND :89 IS NULL)
      AND (TP_PRESENCA_FALTA = :90
      OR TP_PRESENCA_FALTA IS NULL
      AND :91 IS NULL)
      AND (DH_PRESENCA_FALTA = :92
      OR DH_PRESENCA_FALTA IS NULL
      AND :93 IS NULL)
      AND (CD_USUARIO_PRESENCA_FALTA = :94
      OR CD_USUARIO_PRESENCA_FALTA IS NULL
      AND :95 IS NULL)
      AND (NR_ID_ENVIO_SMS = :96
      OR NR_ID_ENVIO_SMS IS NULL
      AND :97 IS NULL)
```

### 3) SELECT DE RECARGA NA VIEW `DBAMV.VDIC_RECEPCAO_AGENDA`:
```sql
SELECT *
      FROM (SELECT ROWNUM
            AS RECNUM, f2n_table.*
            from (SELECT DT_AGENDA, HR_AGENDA, CD_AGENDA_CENTRAL, HR_INICIO, HR_FIM, CD_PACIENTE, CD_GRUPO_AGENDA, NM_PACIENTE, CD_ITEM_AGENDAMENTO, SN_FALTA, SN_ATENDIDO, SN_PUBLICO_AC, SN_PUBLICO_IAC, NR_FONE, CD_ATENDIMENTO, CD_ATENDIMENTO_PAI, CD_CONVENIO, CD_CON_PLA, CD_SUB_PLANO, CD_PRESTADOR, CD_SER_DIS, CD_SETOR, CD_TIP_MAR, CD_RECURSO_CENTRAL, TP_SITUACAO, CD_UNIDADE_ATENDIMENTO, CD_GRU_ATE, CD_IT_AGENDA_PAI, CD_IT_AGENDA_CENTRAL, TP_AGENDA, DS_OBSERVACAO, DS_OBSERVACAO_GERAL, CD_ANESTESISTA, VL_PERC_DESCONTO, VL_NEGOCIADO, SN_ANESTESISTA, SN_SIA, QT_ATENDIMENTO, QT_MARCADOS, QT_ENCAIXES, SN_ENCAIXE, SN_AGENDA_DINAMICA, QT_TEMPO_MEDIO, QT_ENCAIXES_MARCADOS, DS_CONSULTORIO, DS_SENHA_PAINEL, TP_PRODUCAO, QT_PESO, VL_ALTURA, SN_DISPENSA_EQUIPAMENTOS, SN_SESSAO, NR_GUIA_SESSAO, DT_SOLIC_SESSAO, CD_SENHA_SESSAO, DT_VALID_SESSAO, SN_BLOQUEADO, NR_DDD_FONE, NR_DDD_CELULAR, NR_CELULAR, CD_TIPO_BLOQUEIO, TP_PRESENCA_FALTA, DH_PRESENCA_FALTA, CD_USUARIO_PRESENCA_FALTA, NR_DDI_TELEFONE, NR_DDI_CELULAR, NR_ID_ENVIO_SMS
                  FROM dbamv.VDIC_RECEPCAO_AGENDA
                        WHERE pkg_central_marcacoes.fnc_usuario_acessa_horario(user,cd_agenda_central,cd_it_agenda_central) = :"SYS_B_0"
                              and dt_liberacao <= trunc(sysdate)
                              and cd_agenda_central = :1
                              and (cd_paciente||nm_paciente||cd_grupo_agenda is not null)
                              and (cd_it_agenda_pai is null)
                              and dt_agenda between :2
                              and :3 order by dt_agenda asc, hr_agenda asc, cd_agenda_central desc) f2n_table)
                              WHERE RECNUM <= :"SYS_B_1"
```

</details>

---

<details>
      <summary><strong>⛧ CENÁRIO 2 - M_RECEPCAO_AGENDA:</strong></summary>

### CONTEXTO:
- Teste para identificar update no campo `DS_OBSERVACAO_GERAL`.
- `UPDATE` na view `VDIC_RECEPCAO_AGENDA` não contém `DS_OBSERVACAO_GERAL`.
- `UPDATE` na tabela `IT_AGENDA_CENTRAL` contém `DS_OBSERVACAO_GERAL`.

### 1) UPDATE NA VIEW `DBAMV.VDIC_RECEPCAO_AGENDA`:
```sql
UPDATE dbamv.VDIC_RECEPCAO_AGENDA SET HR_AGENDA = :1 , CD_PACIENTE = :2 , CD_GRUPO_AGENDA = :3 , NM_PACIENTE = :4 , CD_ITEM_AGENDAMENTO = :5 , SN_ATENDIDO = :6 , SN_PUBLICO_IAC = :7 , CD_ATENDIMENTO = :8 , CD_ATENDIMENTO_PAI = :9 , CD_SER_DIS = :10 , CD_TIP_MAR = :11 , TP_SITUACAO = :12 , CD_GRU_ATE = :13 , CD_IT_AGENDA_PAI = :14 , CD_IT_AGENDA_CENTRAL = :15 , VL_PERC_DESCONTO = :16 , VL_NEGOCIADO = :17 , SN_ENCAIXE = :18 , DS_SENHA_PAINEL = :19 , QT_PESO = :20 , VL_ALTURA = :21 , SN_DISPENSA_EQUIPAMENTOS = :22 , DT_GRAVACAO = :23 , SN_SESSAO = :24 , NR_GUIA_SESSAO = :25 , DT_SOLIC_SESSAO = :26 , CD_SENHA_SESSAO = :27 , DT_VALID_SESSAO = :28 , SN_BLOQUEADO = :29 , CD_TIPO_BLOQUEIO = :30 , DH_PRESENCA_FALTA = :31 , TP_PRESENCA_FALTA = :32 , CD_USUARIO_PRESENCA_FALTA = :33 , NR_ID_ENVIO_SMS = :34
WHERE (HR_AGENDA = :35
      OR HR_AGENDA IS NULL
      AND :36 IS NULL)
      AND (CD_GRUPO_AGENDA = :37
      OR CD_GRUPO_AGENDA IS NULL
      AND :38 IS NULL)
      AND (CD_ITEM_AGENDAMENTO = :39
      OR CD_ITEM_AGENDAMENTO IS NULL
      AND :40 IS NULL)
      AND (SN_ATENDIDO = :41
      OR SN_ATENDIDO IS NULL
      AND :42 IS NULL)
      AND (SN_PUBLICO_IAC = :43
      OR SN_PUBLICO_IAC IS NULL
      AND :44 IS NULL)
      AND (CD_ATENDIMENTO = :45
      OR CD_ATENDIMENTO IS NULL
      AND :46 IS NULL)
      AND (CD_ATENDIMENTO_PAI = :47
      OR CD_ATENDIMENTO_PAI IS NULL
      AND :48 IS NULL)
      AND (CD_SER_DIS = :49
      OR CD_SER_DIS IS NULL
      AND :50 IS NULL)
      AND (CD_TIP_MAR = :51
      OR CD_TIP_MAR IS NULL
      AND :52 IS NULL)
      AND (TP_SITUACAO = :53
      OR TP_SITUACAO IS NULL
      AND :54 IS NULL)
      AND (CD_GRU_ATE = :55
      OR CD_GRU_ATE IS NULL
      AND :56 IS NULL)
      AND (CD_IT_AGENDA_PAI = :57
      OR CD_IT_AGENDA_PAI IS NULL
      AND :58 IS NULL)
      AND (CD_IT_AGENDA_CENTRAL = :59
      OR CD_IT_AGENDA_CENTRAL IS NULL
      AND :60 IS NULL)
      AND (VL_PERC_DESCONTO = :61
      OR VL_PERC_DESCONTO IS NULL
      AND :62 IS NULL)
      AND (VL_NEGOCIADO = :63
      OR VL_NEGOCIADO IS NULL
      AND :64 IS NULL)
      AND (SN_ENCAIXE = :65
      OR SN_ENCAIXE IS NULL
      AND :66 IS NULL)
      AND (DS_SENHA_PAINEL = :67
      OR DS_SENHA_PAINEL IS NULL
      AND :68 IS NULL)
      AND (QT_PESO = :69
      OR QT_PESO IS NULL
      AND :70 IS NULL)
      AND (VL_ALTURA = :71
      OR VL_ALTURA IS NULL
      AND :72 IS NULL)
      AND (SN_DISPENSA_EQUIPAMENTOS = :73
      OR SN_DISPENSA_EQUIPAMENTOS IS NULL
      AND :74 IS NULL)
      AND (DT_GRAVACAO = :75
      OR DT_GRAVACAO IS NULL
      AND :76 IS NULL)
      AND (SN_SESSAO = :77
      OR SN_SESSAO IS NULL
      AND :78 IS NULL)
      AND (NR_GUIA_SESSAO = :79
      OR NR_GUIA_SESSAO IS NULL
      AND :80 IS NULL)
      AND (DT_SOLIC_SESSAO = :81
      OR DT_SOLIC_SESSAO IS NULL
      AND :82 IS NULL)
      AND (CD_SENHA_SESSAO = :83
      OR CD_SENHA_SESSAO IS NULL
      AND :84 IS NULL)
      AND (DT_VALID_SESSAO = :85
      OR DT_VALID_SESSAO IS NULL
      AND :86 IS NULL)
      AND (CD_TIPO_BLOQUEIO = :87
      OR CD_TIPO_BLOQUEIO IS NULL
      AND :88 IS NULL)
      AND (DH_PRESENCA_FALTA = :89
      OR DH_PRESENCA_FALTA IS NULL
      AND :90 IS NULL)
      AND (TP_PRESENCA_FALTA = :91
      OR TP_PRESENCA_FALTA IS NULL
      AND :92 IS NULL)
      AND (CD_USUARIO_PRESENCA_FALTA = :93
      OR CD_USUARIO_PRESENCA_FALTA IS NULL
      AND :94 IS NULL)
      AND (NR_ID_ENVIO_SMS = :95
      OR NR_ID_ENVIO_SMS IS NULL
      AND :96 IS NULL)
```

### 2) UPDATE NA TABELA `DBAMV.IT_AGENDA_CENTRAL` (COM `DS_OBSERVACAO_GERAL`):
```sql
UPDATE dbamv.it_agenda_central
SET nr_fone             = :1,
      cd_convenio         = :2,
      NR_DDI_TELEFONE     = :3,
      NR_DDD_FONE         = :4,
      NR_DDI_CELULAR      = :5,
      NR_DDD_CELULAR      = :6,
      NR_CELULAR          = :7,
      cd_con_pla          = :8,
      ds_observacao_geral = :9,
      cd_anestesista      = :10,
      sn_anestesista      = :11
WHERE cd_it_agenda_central = :12
    OR cd_it_agenda_pai = :13;
```

### 3) SELECT DE RECARGA NA VIEW `DBAMV.VDIC_RECEPCAO_AGENDA`:
```sql
SELECT *
FROM (
            SELECT
                  ROWNUM AS RECNUM,
                  f2n_table.*
            FROM (
                        SELECT
                              CD_AGENDA_CENTRAL, HR_AGENDA, DT_AGENDA, HR_INICIO, HR_FIM, CD_PACIENTE, CD_GRUPO_AGENDA, NM_PACIENTE, CD_ITEM_AGENDAMENTO, SN_FALTA, SN_ATENDIDO, SN_PUBLICO_AC, SN_PUBLICO_IAC, NR_FONE, CD_ATENDIMENTO, CD_ATENDIMENTO_PAI, CD_CONVENIO, CD_CON_PLA, CD_SUB_PLANO, CD_PRESTADOR, CD_SER_DIS, CD_SETOR, CD_TIP_MAR, CD_RECURSO_CENTRAL, TP_SITUACAO, CD_UNIDADE_ATENDIMENTO, CD_GRU_ATE, CD_IT_AGENDA_PAI, CD_IT_AGENDA_CENTRAL, TP_AGENDA, DS_OBSERVACAO, DS_OBSERVACAO_GERAL, VL_PERC_DESCONTO, CD_ANESTESISTA, VL_NEGOCIADO, SN_ANESTESISTA, SN_SIA, QT_ATENDIMENTO, QT_MARCADOS, QT_ENCAIXES, SN_ENCAIXE, SN_AGENDA_DINAMICA, QT_TEMPO_MEDIO, QT_ENCAIXES_MARCADOS, DS_CONSULTORIO, DS_SENHA_PAINEL, TP_PRODUCAO, QT_PESO, VL_ALTURA, SN_DISPENSA_EQUIPAMENTOS, DT_GRAVACAO, SN_SESSAO, NR_GUIA_SESSAO, DT_SOLIC_SESSAO, CD_SENHA_SESSAO, DT_VALID_SESSAO, SN_BLOQUEADO, NR_DDD_FONE, NR_DDD_CELULAR, NR_CELULAR,     CD_TIPO_BLOQUEIO, DH_PRESENCA_FALTA, TP_PRESENCA_FALTA, CD_USUARIO_PRESENCA_FALTA, NR_DDI_TELEFONE, NR_DDI_CELULAR, NR_ID_ENVIO_SMS
                        FROM dbamv.VDIC_RECEPCAO_AGENDA
                        WHERE cd_multi_empresa = pkg_mv2000.le_empresa AND
                        pkg_central_marcacoes.fnc_usuario_permissao_setor(user, cd_setor, cd_unidade_atendimento) = :"SYS_B_00" AND
                              (
                                    (
                                          SELECT
                                          SN_AGENDA_PUBLICA
                                          FROM DBAMV.AGENDA_CENTRAL
                                          WHERE AGENDA_CENTRAL.CD_AGENDA_CENTRAL = vdic_recepcao_agenda.CD_AGENDA_CENTRAL
                                          ) = :"SYS_B_01" OR
                                          EXISTS(
                                                      SELECT :"SYS_B_02"
                                                      FROM DBAMV.AGENDA_CENTRAL_USUARIO
                                                      WHERE AGENDA_CENTRAL_USUARIO.CD_AGENDA_CENTRAL = vdic_recepcao_agenda.CD_AGENDA_CENTRAL AND
                                                                  AGENDA_CENTRAL_USUARIO.CD_USUARIO = USER
                                                            )
                                    ) AND
                                          dt_liberacao <= trunc(sysdate) AND
                                          cd_paciente = :1 and( (cd_paciente||nm_paciente||cd_grupo_agenda is not null) OR
                                          nvl(sn_bloqueado,:"SYS_B_03") = :"SYS_B_04" )
                                          nvl(sn_bloqueado,:"SYS_B_05") = :"SYS_B_06" AND
                                          (cd_it_agenda_pai is null) AND
                                          dt_agenda >= trunc(:2 ) AND
                                          dt_agenda <= ((trunc(:3 ) + :"SYS_B_07")- :"SYS_B_08"/:"SYS_B_09"/:"SYS_B_10" ) AND
                                          dt_agenda = :4 ORDER BY dt_agenda asc, hr_agenda asc, cd_agenda_central desc
                        ) f2n_table
            )
WHERE RECNUM <= :"SYS_B_11"
;
```

</details>

---

<details>
      <summary><strong>⛧ VALIDAÇÕES FINAIS EM BANCO:</strong></summary>

### 1) VALIDAÇÃO NA VIEW:
```sql
SELECT
      CD_AGENDA_CENTRAL,
      CD_PACIENTE,
      NM_PACIENTE,
      CD_ITEM_AGENDAMENTO,
      CD_ATENDIMENTO,
      DS_OBSERVACAO,
      DS_OBSERVACAO_GERAL
FROM VDIC_RECEPCAO_AGENDA
WHERE CD_AGENDA_CENTRAL = 45120
   AND CD_PACIENTE = 48053;
```

### 2) VALIDAÇÃO NA TABELA:
```sql
SELECT
      CD_AGENDA_CENTRAL,
      CD_PACIENTE,
      NM_PACIENTE,
      CD_ITEM_AGENDAMENTO,
      CD_ATENDIMENTO,
      DS_OBSERVACAO,
      DS_OBSERVACAO_GERAL
FROM IT_AGENDA_CENTRAL
WHERE CD_AGENDA_CENTRAL = 45120
   AND CD_PACIENTE = 48053;
```

</details>

---

### RESUMO TÉCNICO:
- Nos dois fluxos, o `UPDATE` da view não expõe `DS_OBSERVACAO_GERAL` diretamente.
- No fluxo da tela `M_RECEPCAO_AGENDA`, a atualização ocorre explicitamente em `IT_AGENDA_CENTRAL`.
- No fluxo da tela `M_RECEPCAO_MANUT_AGENDA`, os comentários indicam participação da rotina `Pkg_SCMA_M_RECEPCAO_MANU_AGE.P_CHK_AGENDA_CENTRAL` para refletir persistência/consistência.
- As consultas de validação confirmam o campo atualizado tanto na tabela quanto na view.
