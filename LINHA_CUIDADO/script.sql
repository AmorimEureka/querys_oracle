

insert into dbamv.itpre_med (
    qt_itpre_med,
    tp_situacao,
    sn_cancelado,
    sn_urgente,
    cd_pre_med,
    cd_grupo_prescricao_itpre_med,
    cd_produto,
    cd_tip_presc,
    cd_uni_pro,
    cd_tip_esq,
    nr_ordem,
    sn_horario_gerado,
    sn_cronico,
    sn_pesquisa_cientifica,
    cd_itpre_med
)
values (:1 , :2 , :3 , :4 , :5 , :6 , :7 , :8 , :9 , :10 , :11 , :12 , :13 , :14 , :15 )
;

-- =============================================================================================

insert into dbamv.pw_documento_clinico (
    cd_tipo_documento,
    cd_paciente,
    cd_atendimento,
    cd_usuario,
    cd_prestador,
    tp_status,
    dh_criacao,
    cd_documento_clinico
)
values (:1 , :2 , :3 , :4 , :5 , :6 , :7 , :8 )
;


SELECT
    cd_tipo_documento,
    cd_paciente,
    cd_atendimento,
    cd_usuario,
    cd_prestador,
    tp_status,
    dh_criacao,
    cd_documento_clinico
FROM dbamv.pw_documento_clinico
WHERE cd_atendimento = 302831

;



-- ANALISE:
--  PW_DOCUMENTO_CLINICO: Armazena dados basicos sobre todos os documentos gerados atraves do MVPEP ou de sistemas que geram
-- os mesmos documentos do MVPEP, esta tabela é populada e atualizada atraves de triggers nas tabelas
-- que representam os documentos cli­nicos, ex.: PRE_MED, RECEITA, AFERICAO, etc.
--      TABELA 'PW_DOCUMENTO_CLINICO':
--          - CD_ATENDIMENTO
--          - CD_PRESTADOR
--          - DH_CRIACAO | DH_FECHAMENTO | DH_REFERENCIA | DH_DOCUMENTO

-- PW_EDITOR_CLINICO: Tabela que armazena a associação do documento clinico com o novo editor

-- EDITOR_DOCUMENTO:Tabela para armazenar os documento do editor

-- EDITOR_REGISTRO_CAMPO: Tabela para armazenar as respostas de cada campo
--      O CAMPO 'LO_VALOR' ARMAZENA OS VALORES DOS CAMPOS PREENCHIDOS NO DOCUMENTO

SELECT
    erc.*
FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
INNER JOIN DBAMV.PW_EDITOR_CLINICO pec      ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
INNER JOIN DBAMV.PW_TIPO_DOCUMENTO ptd      ON pdc.CD_TIPO_DOCUMENTO = ptd.CD_TIPO_DOCUMENTO
LEFT JOIN  DBAMV.EDITOR_REGISTRO_CAMPO erc  ON erc.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
LEFT JOIN  DBAMV.EDITOR_DOCUMENTO doc       ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
LEFT JOIN  DBAMV.EDITOR_CAMPO eca           ON eca.CD_CAMPO = erc.CD_CAMPO
INNER JOIN DBAMV.ATENDIME a                 ON pdc.CD_ATENDIMENTO = a.CD_ATENDIMENTO
WHERE pdc.CD_ATENDIMENTO = 248529 AND
      ptd.CD_TIPO_DOCUMENTO NOT IN (36, 44) AND
	  doc.CD_DOCUMENTO IN ('935')
;

-- =============================================================================================
