

WITH TUSS22_LATEST AS (
  SELECT cd_pro_fat, cd_tuss, ds_tuss
  FROM (
    SELECT
      t.*,
      ROW_NUMBER() OVER (
        PARTITION BY t.cd_pro_fat
        ORDER BY t.dt_inicio_vigencia DESC NULLS LAST
      ) rn
    FROM DBAMV.TUSS t
    WHERE t.cd_tip_tuss = 22
  )
  WHERE rn = 1
),
RX AS (
  SELECT
    ped.cd_ped_rx                           AS "id",
    'order'                                 AS "intent",
    ''                                      AS "priority",

    '[' ||
      '{"use":"official",' ||
      '"value":"' || ped.CD_PED_RX || '","system":"https://hospitalprontocardio.com.br/"' || '}' ||
    ']' AS "identifiers",

    CASE
      WHEN atd.cd_pro_int IS NULL THEN NULL
      ELSE
      '{'||
        '"codes":['||
          '{'||
            '"system":"MV",'||
            '"code":"'    || REPLACE(atd.cd_pro_int,'"','\"') || '",'||
            '"display":"' || REPLACE(prof.ds_pro_fat,'"','\"') || '"'||
          '}' ||
          CASE WHEN ts.cd_tuss IS NOT NULL THEN
            ',{'||
              '"system":"TUSS",'||
              '"code":"'    || REPLACE(ts.cd_tuss,'"','\"') || '",'||
              '"display":"' || REPLACE(NVL(ts.ds_tuss, prof.ds_pro_fat),'"','\"') || '"'||
            '}'
          ELSE '' END
        || '],'||
        '"text":"' || REPLACE(prof.ds_pro_fat,'"','\"') || '"'||
      '}'
    END                                     AS "code",

    CASE
      WHEN atd.cd_cid IS NULL THEN NULL
      ELSE '['||'{'||
        '"codes":[{'||
          '"system":"http://hl7.org/fhir/ValueSet/icd-10",'||
          '"code":"'    || REPLACE(atd.cd_cid,'"','\"') || '",'||
          '"display":"' || REPLACE(atd.cd_cid,'"','\"') || '"'||
        '}],'||
        '"text":"' || REPLACE(atd.cd_cid,'"','\"') || '"'||
      '}]'
    END                                     AS "reasonCodes",

    TO_CHAR(NVL(ped.dt_solicitacao, ped.dt_pedido),'YYYY-MM-DD') || 'T' ||
    NVL(TO_CHAR(ped.hr_pedido,'HH24:MI:SS'),'00:00:00')          AS "authoredOn",

    '{'||'"reference":"' || TO_CHAR(pac.cd_paciente) || '",'||
       '"display":"'   || REPLACE(NVL(NULLIF(TRIM(pac.nm_social_paciente),''), pac.nm_paciente),'"','\"') || '"'||
    '}'                                     AS "subject",

    '{'||'"reference":"' || TO_CHAR(ped.cd_prestador) || '",'||
       '"display":"'   || REPLACE(NVL(pr.nm_prestador,''), '"','\"') || '"'||
    '}'                                    AS "requester",
    '[' ||
      '{' ||
        '"display":"Hospital Geral Prontocardio",' ||
        '"reference":' || '"1"' || '}' || ']'
    AS "locations",

    CASE WHEN atd.cd_atendimento IS NULL THEN NULL
         ELSE '{'||'"reference":"' || TO_CHAR(atd.cd_atendimento) || '"}'
    END                                     AS "encounter",

    LOWER(COALESCE(NULLIF(TRIM(pac.nm_social_paciente),''), pac.nm_paciente))
                                            AS "filter_patient_name",
    pac.cd_paciente                         AS "filter_medical_record_id",
    NVL(ped.dt_solicitacao, ped.dt_pedido)  AS "filter_encounter_date",
    'active'                                AS "status"
  FROM DBAMV.PED_RX ped
  LEFT JOIN DBAMV.ATENDIME atd
    ON atd.cd_atendimento = ped.cd_atendimento
  JOIN DBAMV.PACIENTE pac
    ON pac.cd_paciente = atd.cd_paciente
  LEFT JOIN DBAMV.PRESTADOR pr
    ON pr.cd_prestador = ped.cd_prestador
  LEFT JOIN DBAMV.PRO_FAT prof
    ON prof.cd_pro_fat = atd.cd_pro_int
  LEFT JOIN TUSS22_LATEST ts
    ON ts.cd_pro_fat = prof.cd_pro_fat
  WHERE atd.cd_pro_int IS NOT NULL
),
LAB AS (
  SELECT
    pl.cd_ped_lab                          AS "id",
    ''                                     AS "intent",
    ''                                     AS "priority",

    '[' ||
      '{"use":"official",' ||
      '"value":"' || pl.cd_ped_lab || '","system":"https://hospitalprontocardio.com.br/"' || '}' ||
    ']' AS "identifiers",

    CASE
      WHEN atd.cd_pro_int IS NULL THEN NULL
      ELSE
      '{'||
        '"codes":['||
          '{'||
            '"system":"MV",'||
            '"code":"'    || REPLACE(atd.cd_pro_int,'"','\"') || '",'||
            '"display":"' || REPLACE(prof.ds_pro_fat,'"','\"') || '"'||
          '}' ||
          CASE WHEN ts.cd_tuss IS NOT NULL THEN
            ',{'||
              '"system":"TUSS",'||
              '"code":"'    || REPLACE(ts.cd_tuss,'"','\"') || '",'||
              '"display":"' || REPLACE(NVL(ts.ds_tuss, prof.ds_pro_fat),'"','\"') || '"'||
            '}'
          ELSE '' END
        || '],'||
        '"text":"' || REPLACE(prof.ds_pro_fat,'"','\"') || '"'||
      '}'
    END                                    AS "code",

    CASE
      WHEN atd.cd_cid IS NULL THEN NULL
      ELSE '['||'{'||
        '"codes":[{'||
          '"system":"http://hl7.org/fhir/ValueSet/icd-10",'||
          '"code":"'    || REPLACE(atd.cd_cid,'"','\"') || '",'||
          '"display":"' || REPLACE(atd.cd_cid,'"','\"') || '"'||
        '}],'||
        '"text":"' || REPLACE(atd.cd_cid,'"','\"') || '"'||
      '}]'
    END                                    AS "reasonCodes",

    TO_CHAR(NVL(pl.dt_solicitacao, pl.dt_pedido),'YYYY-MM-DD"T"HH24:MI:SS') AS "authoredOn",

    '{'||'"reference":"' || TO_CHAR(pac.cd_paciente) || '",'||
       '"display":"'   || REPLACE(NVL(NULLIF(TRIM(pac.nm_social_paciente),''), pac.nm_paciente),'"','\"') || '"'||
    '}'                                    AS "subject",

    '{'||'"reference":"' || TO_CHAR(pl.cd_prestador) || '",'||
       '"display":"'   || REPLACE(NVL(pr.nm_prestador,''), '"','\"') || '"'||
    '}'                                    AS "requester",

     '[' ||
      '{' ||
        '"display":"Hospital Geral Prontocardio",' ||
        '"reference":' || '"1"' || '}' || ']'
    AS "locations",

    CASE WHEN atd.cd_atendimento IS NULL THEN NULL
         ELSE '{'||'"reference":"' || TO_CHAR(atd.cd_atendimento) || '"}'
    END                                    AS "encounter",

    LOWER(COALESCE(NULLIF(TRIM(pac.nm_social_paciente),''), pac.nm_paciente))
                                           AS "filter_patient_name",
    pac.cd_paciente                        AS "filter_medical_record_id",
    NVL(pl.dt_solicitacao, pl.dt_pedido)   AS "filter_encounter_date",
    'active'                               AS "status"
  FROM DBAMV.PED_LAB pl
  LEFT JOIN DBAMV.ATENDIME atd
    ON atd.cd_atendimento = pl.cd_atendimento
  JOIN DBAMV.PACIENTE pac
    ON pac.cd_paciente = atd.cd_paciente
  LEFT JOIN DBAMV.PRESTADOR pr
    ON pr.cd_prestador = pl.cd_prestador
  LEFT JOIN DBAMV.PRO_FAT prof
    ON prof.cd_pro_fat = atd.cd_pro_int
  LEFT JOIN TUSS22_LATEST ts
    ON ts.cd_pro_fat = prof.cd_pro_fat
  WHERE atd.cd_pro_int IS NOT NULL
)
SELECT
  fe."id",
  fe."identifiers",
  fe."status",
  fe."intent",
  fe."priority",
  fe."code",
  fe."reasonCodes",
  fe."authoredOn",
  fe."subject",
  fe."requester",
  fe."encounter",
  fe."locations"
FROM (
  SELECT * FROM RX
  UNION ALL
  SELECT * FROM LAB
) fe


;


-- ################################################ REFACT ################################################


WITH TUSS22_LATEST
    AS (
        SELECT
            cd_pro_fat,
            cd_tuss,
            ds_tuss
        FROM (
            SELECT
                t.*,
            ROW_NUMBER() OVER (
                PARTITION BY t.cd_pro_fat
                ORDER BY t.dt_inicio_vigencia DESC NULLS LAST
            ) rn
            FROM DBAMV.TUSS t
            WHERE t.cd_tip_tuss = 22
        )
        WHERE rn = 1
),
RX
    AS (
        SELECT

            atd.cd_atendimento,
            pac.cd_paciente,
            pac.nm_paciente,
            ped.cd_ped_rx AS PEDIDO,
            'IMAGEM'      AS TIPO,

            ped.cd_ped_rx                           AS "id",
            ''                                      AS "intent",
            ''                                      AS "priority",
            atd.cd_pro_int                          AS "sr_type_code",
            prof.ds_pro_fat                         AS "sr_display",
            atd.tp_atendimento                      AS "encounter_type_code",

            CASE
                WHEN atd.tp_atendimento = 'E' THEN 'Externo'
                WHEN atd.tp_atendimento = 'A' THEN 'Ambulatorial'
                WHEN atd.tp_atendimento = 'I' THEN 'Internacao'
                WHEN atd.tp_atendimento = 'U' THEN 'Urgencia'
                WHEN atd.tp_atendimento = 'H' THEN 'Home Care'
                WHEN atd.tp_atendimento = 'B' THEN 'Busca Ativa'
                WHEN atd.tp_atendimento = 'S' THEN 'SUS - AIH'
                WHEN atd.tp_atendimento = 'O' THEN 'Obito (nao utilizado)'
                ELSE 'Indefinido'
            END                                     AS "encounter_display",

            'I'                                     AS "appointment_type_code",
            'Diagnostico Por Imagem'                AS "appointment_display",

            CASE
                WHEN atd.cd_pro_int IS NULL THEN NULL
                ELSE
                '{'||
                    '"codes":['||
                    '{'||
                        '"system":"MV",'||
                        '"code":"'    || REPLACE(atd.cd_pro_int,'"','\"') || '",'||
                        '"display":"' || REPLACE(prof.ds_pro_fat,'"','\"') || '"'||
                    '}' ||
                    CASE WHEN ts.cd_tuss IS NOT NULL THEN
                        ',{'||
                        '"system":"TUSS",'||
                        '"code":"'    || REPLACE(ts.cd_tuss,'"','\"') || '",'||
                        '"display":"' || REPLACE(NVL(ts.ds_tuss, prof.ds_pro_fat),'"','\"') || '"'||
                        '}'
                    ELSE '' END
                    || '],'||
                    '"text":"' || REPLACE(prof.ds_pro_fat,'"','\"') || '"'||
                '}'
            END                                     AS "code",

            CASE
                WHEN atd.cd_cid IS NULL THEN NULL
                ELSE '['||'{'||
                    '"codes":[{'||
                    '"system":"http://hl7.org/fhir/ValueSet/icd-10",'||
                    '"code":"'    || REPLACE(atd.cd_cid,'"','\"') || '",'||
                    '"display":"' || REPLACE(atd.cd_cid,'"','\"') || '"'||
                    '}],'||
                    '"text":"' || REPLACE(atd.cd_cid,'"','\"') || '"'||
                '}]'
            END                                     AS "reasonCodes",

            TO_CHAR(NVL(ped.dt_solicitacao, ped.dt_pedido),'YYYY-MM-DD') || 'T' ||
            NVL(TO_CHAR(ped.hr_pedido,'HH24:MI:SS'),'00:00:00')          AS "authoredOn",

            '{'||'"reference":"' || TO_CHAR(pac.cd_paciente) || '",'||
            '"display":"'   || REPLACE(NVL(NULLIF(TRIM(pac.nm_social_paciente),''), pac.nm_paciente),'"','\"') || '"'||
            '}'                                     AS "subject",

            '{'||'"reference":"' || TO_CHAR(ped.cd_prestador) || '",'||
            '"display":"'   || REPLACE(NVL(pr.nm_prestador,''), '"','\"') || '"'||
            '}'                                     AS "requester",

            NULL                                    AS "locations",

            CASE
                WHEN atd.cd_atendimento IS NULL THEN NULL
                ELSE '{'||'"reference":"' || TO_CHAR(atd.cd_atendimento) || '"}'
            END                                     AS "encounter",

            NULL                                    AS "appointment",

            LOWER(COALESCE(NULLIF(TRIM(pac.nm_social_paciente),''), pac.nm_paciente))
                                                    AS "filter_patient_name",

            pac.cd_paciente                         AS "filter_medical_record_id",

            NVL(ped.dt_solicitacao, ped.dt_pedido)  AS "filter_encounter_date",

            TO_CHAR(NVL(ped.dt_solicitacao, ped.dt_pedido), 'DD/MM/YYYY') ||
            CASE
                WHEN ped.hr_pedido IS NOT NULL THEN
                    ', ' || TO_CHAR(ped.hr_pedido,'HH24:MI')
                ELSE ''
            END                                     AS "ui_requested_at",

            prof.ds_pro_fat                         AS "ui_request_display",

            NVL(atd.cd_cid, 'Não definido')         AS "ui_reason_cid",

            'active'                                AS "ui_status_display"

        FROM DBAMV.PED_RX ped
        LEFT JOIN DBAMV.ATENDIME atd ON atd.cd_atendimento = ped.cd_atendimento
        JOIN DBAMV.PACIENTE pac      ON pac.cd_paciente = atd.cd_paciente
        LEFT JOIN DBAMV.PRESTADOR pr ON pr.cd_prestador = ped.cd_prestador
        LEFT JOIN DBAMV.PRO_FAT prof ON prof.cd_pro_fat = atd.cd_pro_int
        LEFT JOIN TUSS22_LATEST ts   ON ts.cd_pro_fat = prof.cd_pro_fat
        WHERE atd.cd_pro_int IS NOT NULL
),
LAB
    AS (
        SELECT

            atd.cd_atendimento,
            pac.cd_paciente,
            pac.nm_paciente,
            pl.cd_ped_lab AS PEDIDO,
            'LABORATORIO' AS TIPO,


            pl.cd_ped_lab                          AS "id",
            ''                                     AS "intent",
            ''                                     AS "priority",
            atd.cd_pro_int                         AS "sr_type_code",
            prof.ds_pro_fat                        AS "sr_display",
            atd.tp_atendimento                     AS "encounter_type_code",

            CASE
                WHEN atd.tp_atendimento = 'E' THEN 'Externo'
                WHEN atd.tp_atendimento = 'A' THEN 'Ambulatorial'
                WHEN atd.tp_atendimento = 'I' THEN 'Internacao'
                WHEN atd.tp_atendimento = 'U' THEN 'Urgencia'
                WHEN atd.tp_atendimento = 'H' THEN 'Home Care'
                WHEN atd.tp_atendimento = 'B' THEN 'Busca Ativa'
                WHEN atd.tp_atendimento = 'S' THEN 'SUS - AIH'
                WHEN atd.tp_atendimento = 'O' THEN 'Obito (nao utilizado)'
                ELSE 'Indefinido'
            END                                    AS "encounter_display",

            'L'                                    AS "appointment_type_code",
            'Laboratorio'                          AS "appointment_display",

            CASE
                WHEN atd.cd_pro_int IS NULL THEN NULL
            ELSE
                '{'||
                    '"codes":['||
                    '{'||
                        '"system":"MV",'||
                        '"code":"'    || REPLACE(atd.cd_pro_int,'"','\"') || '",'||
                        '"display":"' || REPLACE(prof.ds_pro_fat,'"','\"') || '"'||
                    '}' ||
                    CASE WHEN ts.cd_tuss IS NOT NULL THEN
                        ',{'||
                        '"system":"TUSS",'||
                        '"code":"'    || REPLACE(ts.cd_tuss,'"','\"') || '",'||
                        '"display":"' || REPLACE(NVL(ts.ds_tuss, prof.ds_pro_fat),'"','\"') || '"'||
                        '}'
                    ELSE '' END
                    || '],'||
                    '"text":"' || REPLACE(prof.ds_pro_fat,'"','\"') || '"'||
                '}'
            END                                    AS "code",

            CASE
                WHEN atd.cd_cid IS NULL THEN NULL
                ELSE '['||'{'||
                    '"codes":[{'||
                    '"system":"http://hl7.org/fhir/ValueSet/icd-10",'||
                    '"code":"'    || REPLACE(atd.cd_cid,'"','\"') || '",'||
                    '"display":"' || REPLACE(atd.cd_cid,'"','\"') || '"'||
                    '}],'||
                    '"text":"' || REPLACE(atd.cd_cid,'"','\"') || '"'||
                '}]'
            END                                    AS "reasonCodes",

            TO_CHAR(NVL(pl.dt_solicitacao, pl.dt_pedido),'YYYY-MM-DD"T"HH24:MI:SS') AS "authoredOn",

            '{'||'"reference":"' || TO_CHAR(pac.cd_paciente) || '",'||
            '"display":"'   || REPLACE(NVL(NULLIF(TRIM(pac.nm_social_paciente),''), pac.nm_paciente),'"','\"') || '"'||
            '}'                                    AS "subject",

            '{'||'"reference":"' || TO_CHAR(pl.cd_prestador) || '",'||
            '"display":"'   || REPLACE(NVL(pr.nm_prestador,''), '"','\"') || '"'||
            '}'                                    AS "requester",

            NULL                                   AS "locations",

            CASE
                WHEN atd.cd_atendimento IS NULL THEN NULL
                ELSE '{'||'"reference":"' || TO_CHAR(atd.cd_atendimento) || '"}'
            END                                    AS "encounter",

            NULL                                   AS "appointment",

            LOWER(COALESCE(NULLIF(TRIM(pac.nm_social_paciente),''), pac.nm_paciente))
                                                   AS "filter_patient_name",

            pac.cd_paciente                        AS "filter_medical_record_id",

            NVL(pl.dt_solicitacao, pl.dt_pedido)   AS "filter_encounter_date",

            TO_CHAR(NVL(pl.dt_solicitacao, pl.dt_pedido), 'DD/MM/YYYY, HH24:MI') AS "ui_requested_at",

            prof.ds_pro_fat                        AS "ui_request_display",
            NVL(atd.cd_cid, 'Não definido')        AS "ui_reason_cid",
            'active'                               AS "ui_status_display"

        FROM DBAMV.PED_LAB pl
        LEFT JOIN DBAMV.ATENDIME atd    ON atd.cd_atendimento = pl.cd_atendimento
        JOIN DBAMV.PACIENTE pac         ON pac.cd_paciente = atd.cd_paciente
        LEFT JOIN DBAMV.PRESTADOR pr    ON pr.cd_prestador = pl.cd_prestador
        LEFT JOIN DBAMV.PRO_FAT prof    ON prof.cd_pro_fat = atd.cd_pro_int
        LEFT JOIN TUSS22_LATEST ts      ON ts.cd_pro_fat = prof.cd_pro_fat
        WHERE atd.cd_pro_int IS NOT NULL
)
SELECT

    fe.cd_atendimento,
    fe.cd_paciente,
    fe.nm_paciente,
    fe.PEDIDO,
    fe.TIPO,

    fe."id",
    fe."intent",
    fe."priority",
    fe."code",
    fe."reasonCodes",
    fe."authoredOn",
    fe."sr_type_code",
    fe."sr_display",
    fe."appointment_type_code",
    fe."appointment_display",
    fe."encounter_type_code",
    fe."encounter_display",
    fe."subject",
    fe."requester",
    fe."locations",
    fe."encounter",
    fe."appointment",
    fe."ui_requested_at"    AS "Data da solicitação",
    fe."ui_request_display" AS "Solicitação",
    fe."ui_reason_cid"      AS "CID do motivo",
    fe."ui_status_display"  AS "status"
FROM (
      SELECT * FROM RX
      UNION ALL
      SELECT * FROM LAB
) fe
WHERE
    fe."filter_encounter_date" >= TO_DATE('2025-10-01','YYYY-MM-DD')
ORDER BY
    fe.cd_atendimento,
    fe.PEDIDO
;


-- **********************************************************
-- **********************************************************


-- TABELA COM OS ITENS DE PRESCRICAO
-- TABELA PRINCIPAL P/ FILTRAR FILTRAR O TIPO DE PRESCRICAO
SELECT
    CD_ITPRE_MED, -- TABELA ID

    CD_PRE_MED,   -- TABELA ESQUERDA
    CD_TIP_PRESC, -- TABELA DIREITA

    CD_TIP_ESQ,
    CD_SET_EXA,
    CD_PRESTADOR
FROM DBAMV.ITPRE_MED
WHERE
    CD_TIP_ESQ IN('EXI', 'EXL')
;


-- TABELA COM AS PRESCRICOES [SOLICITACOES DE EXAMES]
-- TABELA ESQUERDA
SELECT
    CD_PRE_MED,
    CD_ATENDIMENTO,
    CD_PRESTADOR,
    DT_PRE_MED,
    HR_PRE_MED,
    DT_VALIDADE
FROM DBAMV.PRE_MED
;


-- TABELA COM OS TIPO DE PRESCRICAO
-- TABELA DIREITA
SELECT
    CD_TIP_PRESC,
    CD_TIP_ESQ,
    DS_TIP_PRESC,
    CD_EXA_LAB,
    CD_EXA_RX,
    SN_ATIVO
FROM DBAMV.TIP_PRESC
WHERE
    CD_TIP_ESQ IN('EXI', 'EXL')
;


-- **********************************************************


-- TABELA C/ ITENS DO PEDIDO DE EXAME DE IMAGEM
-- TABELA PRINCIPAL
SELECT
    CD_ITPED_RX,  -- TABELA ID

    CD_PED_RX,    -- TABELA ESQUERDA

    CD_EXA_RX,    -- TABELA DIREITA

    CD_ITPRE_MED, -- TABELA BAIXO

    CD_LAUDO,
    CD_PRESTADOR,
    CD_RECURSO

    DT_REALIZADO,
    DT_ENTREGA,
    DT_VALIDADE
FROM DBAMV.ITPED_RX
WHERE CD_PED_RX = 382912
;


-- TABELA ESQUERDA
SELECT
    CD_PED_RX,

    CD_ATENDIMENTO,

    CD_PRE_MED,

    CD_PRESTADOR,
    CD_SET_EXA,
    CD_SETOR,
    -- CD_GUIA,
    NM_USUARIO,
    CD_CONVENIO,

    NM_PRESTADOR,

    DT_PEDIDO,
    HR_PEDIDO,

    DT_SOLICITACAO,
    DT_AUTORIZACAO,

    DT_ENTREGA,
    HR_ENTREGA,

    DT_VALIDADE
FROM DBAMV.PED_RX
-- WHERE CD_PED_RX = 382912
WHERE CD_ATENDIMENTO = 281839
;


-- TABELA DIREITA
SELECT
    CD_EXA_RX,

    EXA_RX_CD_PRO_FAT,

    DS_EXA_RX,
    SN_ATIVO
FROM DBAMV.EXA_RX
WHERE CD_EXA_RX = 862
;


SELECT
    CD_ATENDIMENTO,
    CD_PACIENTE,
    CD_CONVENIO,
    TP_ATENDIMENTO
FROM DBAMV.ATENDIME
WHERE
    TP_ATENDIMENTO IN('A', 'E')
    -- CD_ATENDIMENTO = 281839
;


-- **********************************************************
-- **********************************************************


-- TABELA C/ ITENS DO PEDIDO DE EXAME LABORATORIAL
-- TABELA PRINCIPAL
SELECT
    CD_ITPED_LAB,  -- TABELA ID

    CD_PED_LAB,    -- TABELA ESQUERDA

    CD_EXA_LAB,    -- TABELA DIREITA

    CD_ITPRE_MED, -- TABELA BAIXO

    DT_ENTREGA,
    DT_VALIDADE
FROM DBAMV.ITPED_LAB

;


-- TABELA ESQUERDA
SELECT
    CD_PED_LAB,

    CD_ATENDIMENTO,

    CD_PRE_MED,

    CD_PRESTADOR,
    CD_SET_EXA,
    CD_SETOR,
    -- CD_GUIA,
    NM_USUARIO,
    CD_CONVENIO,

    NM_PRESTADOR,

    DT_PEDIDO,

    DT_SOLICITACAO,
    DT_AUTORIZACAO,

    DT_ENTREGA,
    -- HR_ENTREGA,

    DT_VALIDADE
FROM DBAMV.PED_LAB


;


-- TABELA DIREITA
SELECT
    CD_EXA_LAB,

    CD_PRO_FAT,

    NM_EXA_LAB,
    SN_ATIVO
FROM DBAMV.EXA_LAB
;


-- **********************************************************
-- **********************************************************


-- PRESCRICAO SEM PEDIDO
-- PRESCRICAO COM PEDIDO
-- PEDIDO SEM PRESCRICAO
WITH JN_PRESCRICAO
    AS (
        SELECT
            itm.CD_PRE_MED,   -- TABELA ESQUERDA
            itm.CD_ITPRE_MED, -- TABELA ID
            pm.CD_ATENDIMENTO,

            COALESCE(er.CD_EXA_RX, el.CD_EXA_LAB) AS CD_EXA,
            COALESCE(er.DS_EXA_RX, el.NM_EXA_LAB) AS DS_EXA,

            pm.CD_PRESTADOR  AS CD_PRESTADOR_PRESCRICAO,
            itm.CD_PRESTADOR AS CD_PRESTADOR_ITEM_PRESCRICAO,

            itm.CD_TIP_ESQ,
            itm.CD_SET_EXA,


            pm.DT_PRE_MED,
            pm.HR_PRE_MED,
            pm.DT_VALIDADE
        FROM DBAMV.ITPRE_MED itm
        INNER JOIN DBAMV.PRE_MED pm   ON itm.CD_PRE_MED = pm.CD_PRE_MED
        INNER JOIN DBAMV.TIP_PRESC tp ON itm.CD_TIP_PRESC = tp.CD_TIP_PRESC
        LEFT JOIN DBAMV.EXA_RX er     ON tp.CD_EXA_RX = er.CD_EXA_RX
        LEFT JOIN DBAMV.EXA_LAB el    ON tp.CD_EXA_LAB = el.CD_EXA_LAB
        WHERE
            itm.CD_TIP_ESQ IN('EXI', 'EXL') AND
            pm.CD_ATENDIMENTO = 279452 --281839
),
JN_PEDIDOS_IMAGEM
    AS (
        SELECT
            itr.CD_PED_RX,    -- TABELA ESQUERDA
            itr.CD_ITPED_RX,  -- TABELA ID

            pr.CD_PRE_MED,
            itr.CD_ITPRE_MED, -- TABELA BAIXO

            pr.CD_ATENDIMENTO,
            pr.CD_CONVENIO,


            itr.CD_EXA_RX,    -- TABELA DIREITA
            er.DS_EXA_RX,

            -- itr.CD_LAUDO,
            pr.CD_PRESTADOR  AS CD_PRESTADOR_PEDIDO,
            -- itr.CD_PRESTADOR AS CD_PRESTADOR_EXAME,

            -- pr.HR_PEDIDO,
            -- itr.DT_REALIZADO,
            itr.DT_ENTREGA,

            pr.CD_SET_EXA

        FROM DBAMV.ITPED_RX itr
        INNER JOIN DBAMV.PED_RX  pr ON itr.CD_PED_RX = pr.CD_PED_RX
        INNER JOIN DBAMV. EXA_RX er ON itr.CD_EXA_RX= er.CD_EXA_RX
        WHERE pr.CD_ATENDIMENTO = 279452 --281839
),
JN_PEDIDOS_LABORATORIO
    AS (
        SELECT
            itl.CD_PED_LAB,    -- TABELA ESQUERDA
            itl.CD_ITPED_LAB,  -- TABELA ID

            pl.CD_PRE_MED,
            itl.CD_ITPRE_MED, -- TABELA BAIXO

            pl.CD_ATENDIMENTO,
            pl.CD_CONVENIO,


            itl.CD_EXA_LAB,    -- TABELA DIREITA
            el.NM_EXA_LAB,

            pl.CD_PRESTADOR  AS CD_PRESTADOR_PEDIDO,

            itl.DT_ENTREGA,

            itl.CD_SET_EXA

        FROM DBAMV.ITPED_LAB itl
        INNER JOIN DBAMV.PED_LAB  pL ON itl.CD_PED_LAB = pl.CD_PED_LAB
        INNER JOIN DBAMV.EXA_LAB el ON itl.CD_EXA_LAB= el.CD_EXA_LAB
        WHERE pl.CD_ATENDIMENTO = 279452 --281839
)
SELECT
    *
FROM JN_PRESCRICAO
;



-- CTEs de relacionamento entre prescrições e pedidos


-- WITH JN_REGRA_AMBULATORIO
--     AS (
--         SELECT
--             ia.CD_ATENDIMENTO,
--             pf.CD_PRO_FAT,
--             pf.DS_PRO_FAT,
--              p.CD_PRESTADOR,
--              p.NM_PRESTADOR
--         FROM DBAMV.ITREG_AMB ia
--         LEFT JOIN DBAMV.PRO_FAT pf     ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
--         LEFT JOIN DBAMV.REG_AMB ra     ON ia.CD_REG_AMB = ra.CD_REG_AMB
--         LEFT JOIN DBAMV.PRESTADOR p    ON ia.CD_PRESTADOR = p.CD_PRESTADOR
-- ),
-- JN_REGRA_HOSPITALAR
--     AS (
--             SELECT
--                 rf.CD_ATENDIMENTO,
--                 pf.CD_PRO_FAT,
--                 pf.DS_PRO_FAT,
--                 p.CD_PRESTADOR,
--                 p.NM_PRESTADOR
--             FROM DBAMV.ITREG_FAT itf
--             LEFT JOIN DBAMV.PRO_FAT pf ON itf.CD_PRO_FAT = pf.CD_PRO_FAT
--             LEFT JOIN DBAMV.REG_FAT rf ON itf.CD_REG_FAT = rf.CD_REG_FAT
--             LEFT JOIN DBAMV.PRESTADOR p    ON itf.CD_PRESTADOR = p.CD_PRESTADOR
-- ),



-- LEFT JOIN  DBAMV.PROCEDIMENTO_SUS PS ON PS.CD_PROCEDIMENTO    = A.CD_PROCEDIMENTO




WITH JN_PRESCRICAO
    AS (
        SELECT
            itm.CD_PRE_MED,
            itm.CD_ITPRE_MED,
            pm.CD_ATENDIMENTO,

            COALESCE(er.CD_EXA_RX, el.CD_EXA_LAB) AS CD_EXA,
            COALESCE(er.DS_EXA_RX, el.NM_EXA_LAB) AS DS_EXA,

            COALESCE(pm.CD_PRESTADOR, itm.CD_PRESTADOR) AS CD_PRESTADOR_PRESCRICAO,

            itm.CD_TIP_ESQ,

            itm.CD_SET_EXA,
            COALESCE(COALESCE(tp.CD_PRO_FAT, er.EXA_RX_CD_PRO_FAT),el.CD_PRO_FAT) AS CD_PRO_FAT,
            pm.DT_PRE_MED AS DT_PRESCRICAO

        FROM DBAMV.ITPRE_MED itm
        INNER JOIN DBAMV.PRE_MED pm   ON itm.CD_PRE_MED = pm.CD_PRE_MED
        INNER JOIN DBAMV.TIP_PRESC tp ON itm.CD_TIP_PRESC = tp.CD_TIP_PRESC
        LEFT JOIN DBAMV.EXA_RX er     ON tp.CD_EXA_RX = er.CD_EXA_RX
        LEFT JOIN DBAMV.EXA_LAB el    ON tp.CD_EXA_LAB = el.CD_EXA_LAB
        WHERE itm.CD_TIP_ESQ IN('EXI', 'EXL')
        --   AND pm.CD_ATENDIMENTO =  257238 --281839 -- 279452
),
JN_PEDIDOS_IMAGEM
    AS (
        SELECT
            itr.CD_PED_RX,
            itr.CD_ITPED_RX,
            pr.CD_PRE_MED,
            itr.CD_ITPRE_MED,
            pr.CD_ATENDIMENTO,
            pr.CD_CONVENIO,
            itr.CD_EXA_RX,
            er.DS_EXA_RX,
            pr.CD_PRESTADOR AS CD_PRESTADOR_PEDIDO,

            pr.CD_SET_EXA,
            er.EXA_RX_CD_PRO_FAT AS CD_PRO_FAT,
            pr.DT_PEDIDO AS DT_PEDIDO

        FROM DBAMV.ITPED_RX itr
        INNER JOIN DBAMV.PED_RX  pr ON itr.CD_PED_RX = pr.CD_PED_RX
        INNER JOIN DBAMV.EXA_RX er ON itr.CD_EXA_RX = er.CD_EXA_RX
        -- WHERE pr.CD_ATENDIMENTO = 281839 -- 279452
),
JN_PEDIDOS_LABORATORIO
    AS (
        SELECT
            itl.CD_PED_LAB,
            itl.CD_ITPED_LAB,
            pl.CD_PRE_MED,
            itl.CD_ITPRE_MED,
            pl.CD_ATENDIMENTO,
            pl.CD_CONVENIO,
            itl.CD_EXA_LAB,
            el.NM_EXA_LAB,
            pl.CD_PRESTADOR AS CD_PRESTADOR_PEDIDO,

            itl.CD_SET_EXA,
            el.CD_PRO_FAT,
            pl.DT_PEDIDO AS DT_PEDIDO

        FROM DBAMV.ITPED_LAB itl
        INNER JOIN DBAMV.PED_LAB pl ON itl.CD_PED_LAB = pl.CD_PED_LAB
        INNER JOIN DBAMV.EXA_LAB el ON itl.CD_EXA_LAB = el.CD_EXA_LAB
        -- WHERE pl.CD_ATENDIMENTO = 281839 -- 279452
),
JN_PEDIDOS
    AS (
        SELECT
            'I' AS TIPO_PEDIDO,
            CD_PED_RX AS CD_PEDIDO,
            CD_ITPED_RX AS CD_ITPEDIDO,
            CD_PRE_MED,
            CD_ITPRE_MED,
            CD_ATENDIMENTO,
            CD_CONVENIO,
            CD_EXA_RX AS CD_EXA,
            DS_EXA_RX AS DS_EXA,
            CD_PRESTADOR_PEDIDO,
            DT_PEDIDO,
            CD_SET_EXA,
            CD_PRO_FAT
        FROM JN_PEDIDOS_IMAGEM
        UNION ALL
        SELECT
            'L' AS TIPO_PEDIDO,
            CD_PED_LAB     AS CD_PEDIDO,
            CD_ITPED_LAB   AS CD_ITPEDIDO,
            CD_PRE_MED,
            CD_ITPRE_MED,
            CD_ATENDIMENTO,
            CD_CONVENIO,
            CD_EXA_LAB     AS CD_EXAME,
            NM_EXA_LAB     AS DS_EXAME,
            CD_PRESTADOR_PEDIDO,
            DT_PEDIDO,
            CD_SET_EXA,
            CD_PRO_FAT
        FROM JN_PEDIDOS_LABORATORIO
),
JN_ATENDIMENTO
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            a.CD_PACIENTE,
            a.CD_CONVENIO,
            c.CD_CID,
            a.CD_PRO_INT,
            a.TP_ATENDIMENTO,
            c.DS_CID
        FROM DBAMV.ATENDIME a
        LEFT JOIN DBAMV.CID c ON a.CD_CID = c.CD_CID
),
JN_PACIENTE
    AS (
        SELECT
            CD_PACIENTE,
            NM_PACIENTE
        FROM DBAMV.PACIENTE
),
JN_PRESTADOR
    AS (
        SELECT
            CD_PRESTADOR,
            NM_PRESTADOR
        FROM DBAMV.PRESTADOR
),
JN_TUSS
    AS (
        SELECT
            t.CD_TUSS AS CODIGO_TUSS,
            p.CD_PRO_FAT AS CODIGO_PRO_FAT,
            t.CD_CONVENIO,
            t.DS_TUSS AS DESCRICAO_TUSS,
            p.DS_PRO_FAT AS DESCRICAO_PRO_FAT
        FROM DBAMV.PRO_FAT p
        LEFT JOIN  DBAMV.TUSS t ON t.CD_PRO_FAT = p.CD_PRO_FAT
        -- WHERE p.CD_PRO_FAT = '40805026'
),
JN_PRESCRICAO_COM_PEDIDO
    AS (
        SELECT
            'PRESCRICAO_COM_PEDIDO' AS ORIGEM,

            p.CD_ATENDIMENTO,

            p.CD_PRO_FAT,

            p.CD_PRE_MED AS CD_PRESCRICAO,
            p.CD_ITPRE_MED,
            p.CD_PRESTADOR_PRESCRICAO,
            p.DT_PRESCRICAO,

            d.CD_PEDIDO,
            d.CD_ITPEDIDO,
            d.TIPO_PEDIDO,
            d.CD_PRESTADOR_PEDIDO,
            d.DT_PEDIDO,

            p.CD_EXA,
            p.DS_EXA,

            p.CD_TIP_ESQ,

            COALESCE(p.CD_SET_EXA, d.CD_SET_EXA) AS CD_SET_EXA


        FROM JN_PRESCRICAO p
        INNER JOIN JN_PEDIDOS d ON p.CD_ITPRE_MED = d.CD_ITPRE_MED
),
JN_PRESCRICAO_SEM_PEDIDO
    AS (
        SELECT
            'PRESCRICAO_SEM_PEDIDO' AS ORIGEM,

            p.CD_ATENDIMENTO,

            p.CD_PRO_FAT,

            p.CD_PRE_MED AS CD_PRESCRICAO,
            p.CD_ITPRE_MED,
            p.CD_PRESTADOR_PRESCRICAO,
            p.DT_PRESCRICAO,

            NULL AS CD_PEDIDO,
            NULL AS CD_ITPEDIDO,
            NULL AS TIPO_PEDIDO,
            NULL AS CD_PRESTADOR_PEDIDO,
            NULL AS DT_PEDIDO,

            p.CD_EXA,
            p.DS_EXA,

            p.CD_TIP_ESQ,

            p.CD_SET_EXA

        FROM JN_PRESCRICAO p
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM JN_PEDIDOS d
                WHERE p.CD_ITPRE_MED = d.CD_ITPRE_MED
            )
),
JN_PEDIDO_SEM_PRESCRICAO
    AS (
        SELECT
            'PEDIDO_SEM_PRESCRICAO' AS ORIGEM,

            d.CD_ATENDIMENTO,

            d.CD_PRO_FAT,

            d.CD_PRE_MED AS CD_PRESCRICAO,
            d.CD_ITPRE_MED,
            NULL AS CD_PRESTADOR_PRESCRICAO,
            NULL AS DT_PRESCRICAO,

            d.CD_PEDIDO,
            d.CD_ITPEDIDO,
            d.TIPO_PEDIDO,
            d.CD_PRESTADOR_PEDIDO,
            d.DT_PEDIDO,

            d.CD_EXA,
            d.DS_EXA,

            NULL AS CD_TIP_ESQ,

            d.CD_SET_EXA

        FROM JN_PEDIDOS d
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM JN_PRESCRICAO p
                WHERE p.CD_ITPRE_MED = d.CD_ITPRE_MED
            )
),
JN_REGRAS
    AS (
        SELECT * FROM JN_PRESCRICAO_COM_PEDIDO
        UNION ALL
        SELECT * FROM JN_PRESCRICAO_SEM_PEDIDO
        UNION ALL
        SELECT * FROM JN_PEDIDO_SEM_PRESCRICAO
),
TREATS
    AS (
        SELECT
            r.ORIGEM,
            COALESCE(r.CD_PRESCRICAO, 0) || '-' ||
            COALESCE(r.CD_PEDIDO, 0)  || '-' ||
            COALESCE(r.CD_EXA, 0)                              AS "id",
            ''                                                 AS "intent",
            ''                                                 AS "priority",

            '[' ||
            '{"use":"official",' ||
            '"value":"' || r.CD_PRESCRICAO || '","system":"https://hospitalprontocardio.com.br/"' || '}' ||
            ']'                                                AS "identifiers",

            t.CD_CONVENIO,

            r.CD_PRO_FAT,
            t.CODIGO_TUSS,
            t.CODIGO_PRO_FAT,

            '{'||
                '"codes":['||
                '{'||
                    '"system":"MV",'||
                    '"code":"'    || REPLACE(COALESCE(t.CODIGO_PRO_FAT, r.CD_PRO_FAT),'"','\"') || '",'||
                    '"display":"' || REPLACE(COALESCE(t.DESCRICAO_PRO_FAT, r.DS_EXA),'"','\"') || '"'||
                '}' ||
                        ',{'||
                        '"system":"TUSS",'||
                        '"code":"'    || REPLACE(t.CODIGO_TUSS,'"','\"') || '",'||
                        '"display":"' || REPLACE(t.DESCRICAO_TUSS,'"','\"') || '"'||
                        '}'
                || '],'||
                '"text":"' || REPLACE(t.DESCRICAO_PRO_FAT,'"','\"') || '"'||
            '}'                                        AS "code",

            CASE
                WHEN a.CD_CID IS NULL THEN NULL
                ELSE '['||'{'||
                    '"codes":[{'||
                    '"system":"http://hl7.org/fhir/ValueSet/icd-10",'||
                    '"code":"'    || REPLACE(a.CD_CID,'"','\"') || '",'||
                    '"display":"' || REPLACE(a.CD_CID,'"','\"') || '"'||
                    '}],'||
                    '"text":"' || REPLACE(a.CD_CID,'"','\"') || '"'||
                '}]'
            END                                                AS "reasonCodes",

            TO_CHAR(r.DT_PRESCRICAO,'YYYY-MM-DD"T"HH24:MI:SS') AS "authoredOn",

            '{'||'"reference":"' || TO_CHAR(p.CD_PACIENTE) || '",'||
            '"display":"'   || REPLACE(NULLIF(TRIM(p.NM_PACIENTE),''),'"','\"') || '"'||
            '}'                                                AS "subject",

            '{'||'"reference":"' || TO_CHAR(pr.CD_PRESTADOR) || '",'||
            '"display":"'   || REPLACE(NVL(pr.NM_PRESTADOR,''), '"','\"') || '"'||
            '}'                                                AS "requester",

            '[' ||
            '{' ||
                '"display":"Hospital Geral Prontocardio",' ||
                '"reference":' || '"1"' || '}' || ']'          AS "locations",

            CASE
                WHEN a.CD_ATENDIMENTO IS NULL THEN NULL
                ELSE '{'||'"reference":"' || TO_CHAR(a.CD_ATENDIMENTO) || '"}'
            END                                                AS "encounter",

            LOWER(NULLIF(TRIM(p.NM_PACIENTE),''))              AS "filter_patient_name",
            p.CD_PACIENTE                                      AS "filter_medical_record_id",
            r.DT_PEDIDO                                        AS "filter_encounter_date",
            'active'                                           AS "status"
            -- r.ORIGEM,
            -- r.CD_ATENDIMENTO,
            -- p.CD_PACIENTE
            -- p.NM_PACIENTE,
            -- r.CD_PRO_FAT,
            -- t.CODIGO,
            -- t.DESCRICAO,
            -- r.CD_PRE_MED,
            -- r.CD_ITPRE_MED,
            -- r.CD_PRESTADOR_PRESCRICAO,
            -- pr.NM_PRESTADOR NM_PRESTADOR_PRESCRICAO,
            -- r.DT_PRESCRICAO,
            -- r.CD_PEDIDO,
            -- r.CD_ITPEDIDO,
            -- r.TIPO_PEDIDO,
            -- r.CD_PRESTADOR_PEDIDO,
            -- pr1.NM_PRESTADOR NM_PRESTADOR_PEDIDO,
            -- r.DT_PEDIDO,
            -- r.CD_EXA,
            -- r.DS_EXA,
            -- r.CD_TIP_ESQ,
            -- r.CD_SET_EXA,
            -- a.TP_ATENDIMENTO
        FROM JN_REGRAS r
        INNER JOIN JN_ATENDIMENTO a ON r.CD_ATENDIMENTO = a.CD_ATENDIMENTO
        LEFT JOIN JN_PACIENTE p     ON a.CD_PACIENTE = p.CD_PACIENTE
        LEFT JOIN JN_PRESTADOR pr   ON r.CD_PRESTADOR_PRESCRICAO = pr.CD_PRESTADOR
        LEFT JOIN JN_PRESTADOR pr1  ON r.CD_PRESTADOR_PEDIDO = pr1.CD_PRESTADOR
        LEFT JOIN JN_TUSS t         ON r.CD_PRO_FAT = COALESCE(t.CODIGO_TUSS ,t.CODIGO_PRO_FAT) AND a.CD_CONVENIO =  t.CD_CONVENIO
        WHERE COALESCE(r.DT_PRESCRICAO, r.DT_PEDIDO) >= TO_DATE('2025-10-01','YYYY-MM-DD')
            -- AND  a.CD_ATENDIMENTO = 257238 --265933
)

SELECT
  fe."id",
  fe."identifiers",
  fe."status",
  fe."intent",
  fe."priority",
  fe."code",
  fe."reasonCodes",
  fe."authoredOn",
  fe."subject",
  fe."requester",
  fe."encounter",
  fe."locations"
FROM TREATS fe
;





-- ################################################ README ################################################


WITH JN_PRESCRICAO
    AS (
        SELECT
            itm.CD_PRE_MED,
            itm.CD_ITPRE_MED,
            pm.CD_ATENDIMENTO,

            COALESCE(er.CD_EXA_RX, el.CD_EXA_LAB) AS CD_EXA,
            COALESCE(er.DS_EXA_RX, el.NM_EXA_LAB) AS DS_EXA,

            COALESCE(pm.CD_PRESTADOR, itm.CD_PRESTADOR) AS CD_PRESTADOR_PRESCRICAO,

            itm.CD_TIP_ESQ,

            itm.CD_SET_EXA,
            COALESCE(COALESCE(tp.CD_PRO_FAT, er.EXA_RX_CD_PRO_FAT),el.CD_PRO_FAT) AS CD_PRO_FAT,
            pm.DT_PRE_MED AS DT_PRESCRICAO

        FROM DBAMV.ITPRE_MED itm
        INNER JOIN DBAMV.PRE_MED pm   ON itm.CD_PRE_MED = pm.CD_PRE_MED
        INNER JOIN DBAMV.TIP_PRESC tp ON itm.CD_TIP_PRESC = tp.CD_TIP_PRESC
        LEFT JOIN DBAMV.EXA_RX er     ON tp.CD_EXA_RX = er.CD_EXA_RX
        LEFT JOIN DBAMV.EXA_LAB el    ON tp.CD_EXA_LAB = el.CD_EXA_LAB
        WHERE itm.CD_TIP_ESQ IN('EXI', 'EXL')
),
JN_PEDIDOS_IMAGEM
    AS (
        SELECT
            itr.CD_PED_RX,
            itr.CD_ITPED_RX,
            pr.CD_PRE_MED,
            itr.CD_ITPRE_MED,
            pr.CD_ATENDIMENTO,
            pr.CD_CONVENIO,
            itr.CD_EXA_RX,
            er.DS_EXA_RX,
            pr.CD_PRESTADOR AS CD_PRESTADOR_PEDIDO,

            pr.CD_SET_EXA,
            er.EXA_RX_CD_PRO_FAT AS CD_PRO_FAT,
            pr.DT_PEDIDO AS DT_PEDIDO

        FROM DBAMV.ITPED_RX itr
        INNER JOIN DBAMV.PED_RX  pr ON itr.CD_PED_RX = pr.CD_PED_RX
        INNER JOIN DBAMV.EXA_RX er ON itr.CD_EXA_RX = er.CD_EXA_RX
),
JN_PEDIDOS_LABORATORIO
    AS (
        SELECT
            itl.CD_PED_LAB,
            itl.CD_ITPED_LAB,
            pl.CD_PRE_MED,
            itl.CD_ITPRE_MED,
            pl.CD_ATENDIMENTO,
            pl.CD_CONVENIO,
            itl.CD_EXA_LAB,
            el.NM_EXA_LAB,
            pl.CD_PRESTADOR AS CD_PRESTADOR_PEDIDO,

            itl.CD_SET_EXA,
            el.CD_PRO_FAT,
            pl.DT_PEDIDO AS DT_PEDIDO

        FROM DBAMV.ITPED_LAB itl
        INNER JOIN DBAMV.PED_LAB pl ON itl.CD_PED_LAB = pl.CD_PED_LAB
        INNER JOIN DBAMV.EXA_LAB el ON itl.CD_EXA_LAB = el.CD_EXA_LAB
),
JN_PEDIDOS
    AS (
        SELECT
            'I' AS TIPO_PEDIDO,
            CD_PED_RX AS CD_PEDIDO,
            CD_ITPED_RX AS CD_ITPEDIDO,
            CD_PRE_MED,
            CD_ITPRE_MED,
            CD_ATENDIMENTO,
            CD_CONVENIO,
            CD_EXA_RX AS CD_EXA,
            DS_EXA_RX AS DS_EXA,
            CD_PRESTADOR_PEDIDO,
            DT_PEDIDO,
            CD_SET_EXA,
            CD_PRO_FAT
        FROM JN_PEDIDOS_IMAGEM
        UNION ALL
        SELECT
            'L' AS TIPO_PEDIDO,
            CD_PED_LAB     AS CD_PEDIDO,
            CD_ITPED_LAB   AS CD_ITPEDIDO,
            CD_PRE_MED,
            CD_ITPRE_MED,
            CD_ATENDIMENTO,
            CD_CONVENIO,
            CD_EXA_LAB     AS CD_EXAME,
            NM_EXA_LAB     AS DS_EXAME,
            CD_PRESTADOR_PEDIDO,
            DT_PEDIDO,
            CD_SET_EXA,
            CD_PRO_FAT
        FROM JN_PEDIDOS_LABORATORIO
),
JN_ATENDIMENTO
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            a.CD_PACIENTE,
            a.CD_CONVENIO,
            c.CD_CID,
            a.CD_PRO_INT,
            a.TP_ATENDIMENTO,
            c.DS_CID
        FROM DBAMV.ATENDIME a
        LEFT JOIN DBAMV.CID c ON a.CD_CID = c.CD_CID
),
JN_PACIENTE
    AS (
        SELECT
            CD_PACIENTE,
            NM_PACIENTE
        FROM DBAMV.PACIENTE
),
JN_PRESTADOR
    AS (
        SELECT
            CD_PRESTADOR,
            NM_PRESTADOR
        FROM DBAMV.PRESTADOR
),
JN_TUSS
    AS (
        SELECT
            t.CD_TUSS AS CODIGO_TUSS,
            p.CD_PRO_FAT AS CODIGO_PRO_FAT,
            t.CD_CONVENIO,
            t.DS_TUSS AS DESCRICAO_TUSS,
            p.DS_PRO_FAT AS DESCRICAO_PRO_FAT
        FROM DBAMV.PRO_FAT p
        LEFT JOIN  DBAMV.TUSS t ON t.CD_PRO_FAT = p.CD_PRO_FAT
),
JN_PRESCRICAO_COM_PEDIDO
    AS (
        SELECT
            'PRESCRICAO_COM_PEDIDO' AS ORIGEM,

            p.CD_ATENDIMENTO,

            p.CD_PRO_FAT,

            p.CD_PRE_MED AS CD_PRESCRICAO,
            p.CD_ITPRE_MED,
            p.CD_PRESTADOR_PRESCRICAO,
            p.DT_PRESCRICAO,

            d.CD_PEDIDO,
            d.CD_ITPEDIDO,
            d.TIPO_PEDIDO,
            d.CD_PRESTADOR_PEDIDO,
            d.DT_PEDIDO,

            p.CD_EXA,
            p.DS_EXA,

            p.CD_TIP_ESQ,

            COALESCE(p.CD_SET_EXA, d.CD_SET_EXA) AS CD_SET_EXA


        FROM JN_PRESCRICAO p
        INNER JOIN JN_PEDIDOS d ON p.CD_ITPRE_MED = d.CD_ITPRE_MED
),
JN_PRESCRICAO_SEM_PEDIDO
    AS (
        SELECT
            'PRESCRICAO_SEM_PEDIDO' AS ORIGEM,

            p.CD_ATENDIMENTO,

            p.CD_PRO_FAT,

            p.CD_PRE_MED AS CD_PRESCRICAO,
            p.CD_ITPRE_MED,
            p.CD_PRESTADOR_PRESCRICAO,
            p.DT_PRESCRICAO,

            NULL AS CD_PEDIDO,
            NULL AS CD_ITPEDIDO,
            NULL AS TIPO_PEDIDO,
            NULL AS CD_PRESTADOR_PEDIDO,
            NULL AS DT_PEDIDO,

            p.CD_EXA,
            p.DS_EXA,

            p.CD_TIP_ESQ,

            p.CD_SET_EXA

        FROM JN_PRESCRICAO p
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM JN_PEDIDOS d
                WHERE p.CD_ITPRE_MED = d.CD_ITPRE_MED
            )
),
JN_PEDIDO_SEM_PRESCRICAO
    AS (
        SELECT
            'PEDIDO_SEM_PRESCRICAO' AS ORIGEM,

            d.CD_ATENDIMENTO,

            d.CD_PRO_FAT,

            d.CD_PRE_MED AS CD_PRESCRICAO,
            d.CD_ITPRE_MED,
            NULL AS CD_PRESTADOR_PRESCRICAO,
            NULL AS DT_PRESCRICAO,

            d.CD_PEDIDO,
            d.CD_ITPEDIDO,
            d.TIPO_PEDIDO,
            d.CD_PRESTADOR_PEDIDO,
            d.DT_PEDIDO,

            d.CD_EXA,
            d.DS_EXA,

            NULL AS CD_TIP_ESQ,

            d.CD_SET_EXA

        FROM JN_PEDIDOS d
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM JN_PRESCRICAO p
                WHERE p.CD_ITPRE_MED = d.CD_ITPRE_MED
            )
),
JN_REGRAS
    AS (
        SELECT * FROM JN_PRESCRICAO_COM_PEDIDO
        UNION ALL
        SELECT * FROM JN_PRESCRICAO_SEM_PEDIDO
        UNION ALL
        SELECT * FROM JN_PEDIDO_SEM_PRESCRICAO
),
TREATS
    AS (
        SELECT

            COALESCE(r.CD_PRESCRICAO, 0) || '-' ||
            COALESCE(r.CD_PEDIDO, 0)  || '-' ||
            COALESCE(r.CD_EXA, 0)                              AS "id",
            ''                                                 AS "intent",
            ''                                                 AS "priority",

            '[' ||
            '{"use":"official",' ||
            '"value":"' || r.CD_PRESCRICAO || '","system":"https://hospitalprontocardio.com.br/"' || '}' ||
            ']'                                                AS "identifiers",

            '{'||
                '"codes":['||
                '{'||
                    '"system":"MV",'||
                    '"code":"'    || REPLACE(COALESCE(t.CODIGO_PRO_FAT, r.CD_PRO_FAT),'"','\"') || '",'||
                    '"display":"' || REPLACE(COALESCE(t.DESCRICAO_PRO_FAT, r.DS_EXA),'"','\"') || '"'||
                '}' ||
                        ',{'||
                        '"system":"TUSS",'||
                        '"code":"'    || REPLACE(t.CODIGO_TUSS,'"','\"') || '",'||
                        '"display":"' || REPLACE(t.DESCRICAO_TUSS,'"','\"') || '"'||
                        '}'
                || '],'||
                '"text":"' || REPLACE(t.DESCRICAO_PRO_FAT,'"','\"') || '"'||
            '}'                                        AS "code",


            CASE
                WHEN a.CD_CID IS NULL THEN NULL
                ELSE '['||'{'||
                    '"codes":[{'||
                    '"system":"http://hl7.org/fhir/ValueSet/icd-10",'||
                    '"code":"'    || REPLACE(a.CD_CID,'"','\"') || '",'||
                    '"display":"' || REPLACE(a.CD_CID,'"','\"') || '"'||
                    '}],'||
                    '"text":"' || REPLACE(a.CD_CID,'"','\"') || '"'||
                '}]'
            END                                                AS "reasonCodes",


            TO_CHAR(r.DT_PRESCRICAO,'YYYY-MM-DD"T"HH24:MI:SS') AS "authoredOn",


            '{'||'"reference":"' || TO_CHAR(p.CD_PACIENTE) || '",'||
            '"display":"'   || REPLACE(NULLIF(TRIM(p.NM_PACIENTE),''),'"','\"') || '"'||
            '}'                                                AS "subject",


            '{'||'"reference":"' || TO_CHAR(pr.CD_PRESTADOR) || '",'||
            '"display":"'   || REPLACE(NVL(pr.NM_PRESTADOR,''), '"','\"') || '"'||
            '}'                                                AS "requester",


            '[' ||
            '{' ||
                '"display":"Hospital Geral Prontocardio",' ||
                '"reference":' || '"1"' || '}' || ']'          AS "locations",


            CASE
                WHEN a.CD_ATENDIMENTO IS NULL THEN NULL
                ELSE '{'||'"reference":"' || TO_CHAR(a.CD_ATENDIMENTO) || '"}'
            END                                                AS "encounter",


            LOWER(NULLIF(TRIM(p.NM_PACIENTE),''))              AS "filter_patient_name",
            p.CD_PACIENTE                                      AS "filter_medical_record_id",
            r.DT_PEDIDO                                        AS "filter_encounter_date",
            'active'                                           AS "status"

        FROM JN_REGRAS r
        INNER JOIN JN_ATENDIMENTO a ON r.CD_ATENDIMENTO = a.CD_ATENDIMENTO
        LEFT JOIN JN_PACIENTE p     ON a.CD_PACIENTE = p.CD_PACIENTE
        LEFT JOIN JN_PRESTADOR pr   ON r.CD_PRESTADOR_PRESCRICAO = pr.CD_PRESTADOR
        LEFT JOIN JN_PRESTADOR pr1  ON r.CD_PRESTADOR_PEDIDO = pr1.CD_PRESTADOR
        LEFT JOIN JN_TUSS t         ON r.CD_PRO_FAT = COALESCE(t.CODIGO_TUSS ,t.CODIGO_PRO_FAT) AND a.CD_CONVENIO =  t.CD_CONVENIO
)
SELECT
fe."id",
fe."identifiers",
fe."status",
fe."intent",
fe."priority",
fe."code",
fe."reasonCodes",
fe."authoredOn",
fe."subject",
fe."requester",
fe."encounter",
fe."locations"
FROM TREATS fe
;
