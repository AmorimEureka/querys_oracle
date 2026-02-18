

-- QUERY DA VIEW 'HPC_V_IMG_LAUDOS_CHPC'

  SELECT
    a.cd_atendimento,
    a.tp_atendimento AS tipo_atendimento,
    a.cd_paciente,
    p.nm_paciente AS nome_paciente,
    e.cd_exa_rx AS cd_exame,
    INITCAP(e.ds_exa_rx) AS nome_exa_rx,
    r.id_exame_pedido AS id_exame_pedido,
    r.ds_laudo_rtf AS ds_laudo_pdf,
    r.ds_laudo_txt AS ds_laudo_pdf_marcadagua,
    r.ds_laudo_rtf AS layout_novo_editor,
    l.dt_laudo,
    l.cd_laudo_integra
FROM atendime a
LEFT JOIN ped_rx pe
    ON pe.cd_atendimento = a.cd_atendimento
LEFT JOIN laudo_rx l
    ON l.cd_ped_rx = pe.cd_ped_rx
LEFT JOIN idce.rs_lau_exame_pedido r
    ON r.id_exame_pedido = l.cd_laudo_integra
LEFT JOIN itped_rx i
    ON i.cd_ped_rx = pe.cd_ped_rx
LEFT JOIN exa_rx e
    ON e.cd_exa_rx = i.cd_exa_rx
LEFT JOIN paciente p
    ON p.cd_paciente = a.cd_paciente
WHERE a.tp_atendimento IN ('E','U','A')
  AND e.cd_exa_rx IN ('706')
--   AND a.CD_ATENDIMENTO IN (293114, 292976)
;


-- QUERY REFATORADA UTILIZANDO VIEW 'RS_VW_EXAME_PEDIDO_MULTI_LOGIN'
-- DO SCHEMA IDCE
SELECT
    CD_ATENDIMENTO_HIS AS CD_ATENDIMENTO,
    CD_STATUS          AS TIPO_ATENDIMENTO,
    CD_PACIENTE_HIS    AS CD_PACIENTE,
    NM_PACIENTE        AS NOME_PACIENTE,
    CD_EXAME_HIS       AS CD_EXAME,
    NM_EXAME           AS NOME_EXA_RX,
    ID_EXAME_PEDIDO,
    DS_LAUDO_RTF       AS DS_LAUDO_PDF,
    DS_LAUDO_TXT       AS DS_LAUDO_PDF_MARCADAGUA,
    DS_LAUDO_RTF       AS LAYOUT_NOVO_EDITOR,
    DT_LAUDADO,
    NULL               AS CD_LAUDO_INTEGRA  -- NÃO EXISTE ESSE CAMPO NESSA VIEW, AVALIAR A NECESSIDADE
FROM IDCE.RS_VW_EXAME_PEDIDO_MULTI_LOGIN    -- ISSO JÁ É UMA VIEW QUE EXISTE NO SCHEMA 'IDCE'
WHERE
    CD_STATUS IN ('E','U','A') AND
    CD_EXAME_HIS = 706
    -- AND CD_ATENDIMENTO_HIS IN (293114, 292976) -- APAGAR ESSA LINHA
ORDER BY DT_LAUDADO DESC
;