
-- ################################################ ORIGINAL ################################################


WITH fhir_encounters AS
(
  SELECT
    A.CD_PACIENTE                                                   AS "filter_medical_record_id",
    LOWER(P.NM_PACIENTE)                                            AS "filter_patient_name",
    TO_DATE(TO_CHAR(NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO),'YYYY-MM-DD'),'YYYY-MM-DD') AS "filter_encounter_date",
    TO_DATE(TO_CHAR(NVL(A.DT_ALTA, A.DT_ATENDIMENTO),'YYYY-MM-DD'),'YYYY-MM-DD')             AS "filter_updated_date",

    A.CD_ATENDIMENTO     AS "id",
    CASE
        WHEN A.DT_ATENDIMENTO >= CURRENT_TIMESTAMP THEN 'planned'
        WHEN A.DT_ATENDIMENTO IS NULL THEN 'cancelled'
        WHEN A.DH_ALTA_LANCADA IS NOT NULL THEN 'completed'
        WHEN A.DH_ALTA_LANCADA IS NULL THEN
            CASE
                WHEN A.TP_ATENDIMENTO IN ('E','A') THEN 'completed'
                WHEN A.TP_ATENDIMENTO IN ('I','U') THEN 'in-progress'
                ELSE 'completed'
            END
        ELSE 'on-hold'
    END AS "status",

    REPLACE(
      NVL(
        CASE
          WHEN PS.CD_PROCEDIMENTO IS NULL THEN C.DS_CIRURGIA
          WHEN A.CD_PRO_INT     IS NULL THEN PS.DS_PROCEDIMENTO
          ELSE C.DS_CIRURGIA
        END,
        NVL(PF.DS_PRO_FAT,
            CASE
              WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
              WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
              WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
              WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
              WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
              WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
              WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
              WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
              ELSE 'Indefinido'
            END
        )
      ),
    '"','\"')                                                       AS "type",

    '{' ||
      '"reference":"' || TO_CHAR(A.CD_PACIENTE) || '",' ||
      '"display":"'   || REPLACE(NVL(P.NM_PACIENTE,''),'"','\"') || '"' ||
    '}'                                                             AS "subject",

    CASE
      WHEN NVL(PP.CD_PRESTADOR,0) = 0 THEN NULL
      ELSE
        '[' ||
          '{' ||
            '"type":"PROFESSIONAL",' ||
            '"actor":{' ||
              '"reference":"' || TO_CHAR(PP.CD_PRESTADOR) || '",' ||
              '"display":"'   || REPLACE(NVL(PP.NM_PRESTADOR,''),'"','\"') || '"' ||
            '}' ||
          '}' ||
        ']'
    END                                                             AS "participants",

    CASE
      WHEN NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO) IS NULL THEN NULL
      ELSE TO_CHAR(NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO),'YYYY-MM-DD"T"HH24:MI:SS')
    END                                                             AS "start",

    CASE
      WHEN A.DT_ALTA IS NULL THEN NULL
      ELSE TO_CHAR(A.DT_ALTA,'YYYY-MM-DD"T"HH24:MI:SS')
    END                                                             AS "end",

    '{' ||
      '"code":"",' ||
      '"display":"' ||
        REPLACE(
          NVL(
            CASE
              WHEN PS.CD_PROCEDIMENTO IS NULL THEN C.DS_CIRURGIA
              WHEN A.CD_PRO_INT     IS NULL THEN PS.DS_PROCEDIMENTO
              ELSE C.DS_CIRURGIA
            END,
            NVL(PF.DS_PRO_FAT,
                CASE
                  WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
                  WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
                  WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
                  WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
                  WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
                  WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
                  WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
                  WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
                  ELSE 'Indefinido'
                END
            )
          ),
        '"','\"'
        )
      || '"' ||
    '}'                                                             AS "encounterClass",

    NULL                                                            AS "serviceProvider",

    CASE
      WHEN M.CD_MULTI_EMPRESA IS NULL THEN '[]'
      ELSE
        '[' ||
          '{"reference":"' || TO_CHAR(M.CD_MULTI_EMPRESA) || '","display":"' ||
            CASE
              WHEN M.CD_MULTI_EMPRESA = 1 THEN 'HOSPITAL PRONTOCARDIO'

              ELSE 'Nao Cadastrado'
            END
          || '"}]'
    END                                                             AS "locations",

    (
      SELECT
        CASE
          WHEN COUNT(*) = 0 THEN '[]'
          ELSE
            '[' || LISTAGG(
                   '{"reference":"' || TO_CHAR(AC2.CD_AVISO_CIRURGIA) ||
                   '","display":"Aviso Cirurgia ' || TO_CHAR(AC2.CD_AVISO_CIRURGIA) || '"}'
                   , ','
                 ) WITHIN GROUP (ORDER BY AC2.CD_AVISO_CIRURGIA)
            || ']'
        END
      FROM dbamv.AVISO_CIRURGIA AC2
      WHERE AC2.CD_ATENDIMENTO = A.CD_ATENDIMENTO
    )                                                              AS "appointments"

  FROM
    dbamv.ATENDIME A
    JOIN dbamv.PACIENTE P              ON P.CD_PACIENTE      = A.CD_PACIENTE
    LEFT JOIN dbamv.PRESTADOR PP       ON PP.CD_PRESTADOR    = A.CD_PRESTADOR
    LEFT JOIN dbamv.AVISO_CIRURGIA AC  ON AC.CD_ATENDIMENTO  = A.CD_ATENDIMENTO
    LEFT JOIN dbamv.CIRURGIA_AVISO CA  ON CA.CD_AVISO_CIRURGIA = AC.CD_AVISO_CIRURGIA
    LEFT JOIN dbamv.CIRURGIA C         ON C.CD_CIRURGIA      = CA.CD_CIRURGIA
    LEFT JOIN dbamv.PROCEDIMENTO_SUS PS ON PS.CD_PROCEDIMENTO = A.CD_PROCEDIMENTO
    LEFT JOIN dbamv.COD_PRO PRO        ON PRO.CD_COD_PRO     = A.CD_PRO_INT
    LEFT JOIN dbamv.PRO_FAT PF         ON PF.CD_PRO_FAT      = PRO.CD_PRO_FAT
    LEFT JOIN dbamv.MULTI_EMPRESAS M   ON M.CD_MULTI_EMPRESA = A.CD_MULTI_EMPRESA
  WHERE
    NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO) >= TO_DATE('2025-01-01','YYYY-MM-DD')
)

SELECT
  fe."id",
  fe."status",
  fe."type",
  fe."subject",
  fe."participants",
  fe."start",
  fe."end",
  fe."encounterClass",
  fe."serviceProvider",
  fe."locations",
  fe."appointments"
FROM fhir_encounters fe
-- WHERE
--     (NULLIF( :searchTerm1 , 'null') IS NULL OR fe."filter_patient_name"       LIKE LOWER('%'|| :searchTerm2 ||'%'))
--     AND (NULLIF( :medicalRecordId1 , 'null') IS NULL OR fe."filter_medical_record_id" = :medicalRecordId2 )
--     AND (NULLIF( :fromDate1 , 'null') IS NULL OR fe."filter_encounter_date"    >= TO_DATE( :fromDate2 , 'YYYY-MM-DD'))
--     AND (NULLIF( :toDate1 , 'null') IS NULL OR fe."filter_encounter_date" <= TO_DATE( :toDate2 , 'YYYY-MM-DD'))

WHERE
    -- fe."id" IN(180817, 180793)
    fe."id" IN( 275757, 275765, 275765, 276930, 276925, 276920, 276553, 194776)
;

-- ################################################ REFACT ################################################


WITH JN_REGRA_AMBULATORIO
    AS (
        SELECT
            ia.CD_ATENDIMENTO,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
             p.CD_PRESTADOR,
             p.NM_PRESTADOR
        FROM DBAMV.ITREG_AMB ia
        LEFT JOIN DBAMV.PRO_FAT pf     ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_AMB ra     ON ia.CD_REG_AMB = ra.CD_REG_AMB
        LEFT JOIN DBAMV.PRESTADOR p    ON ia.CD_PRESTADOR = p.CD_PRESTADOR
),
JN_REGRA_HOSPITALAR
    AS (
            SELECT
                rf.CD_ATENDIMENTO,
                pf.CD_PRO_FAT,
                pf.DS_PRO_FAT,
                p.CD_PRESTADOR,
                p.NM_PRESTADOR
            FROM DBAMV.ITREG_FAT itf
            LEFT JOIN DBAMV.PRO_FAT pf ON itf.CD_PRO_FAT = pf.CD_PRO_FAT
            LEFT JOIN DBAMV.REG_FAT rf ON itf.CD_REG_FAT = rf.CD_REG_FAT
            LEFT JOIN DBAMV.PRESTADOR p    ON itf.CD_PRESTADOR = p.CD_PRESTADOR
),
JN_PRESTADOR
    AS (
        SELECT
            CD_PRESTADOR,
            NM_PRESTADOR
        FROM DBAMV.PRESTADOR
),
fhir_encounters
    AS (
        SELECT DISTINCT
            A.CD_PACIENTE                                                                           AS "filter_medical_record_id",
            LOWER(P.NM_PACIENTE)                                                                    AS "filter_patient_name",
            TO_DATE(TO_CHAR(NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO),'YYYY-MM-DD'),'YYYY-MM-DD') AS "filter_encounter_date",
            TO_DATE(TO_CHAR(NVL(A.DT_ALTA, A.DT_ATENDIMENTO),'YYYY-MM-DD'),'YYYY-MM-DD')            AS "filter_updated_date",


            A.CD_ATENDIMENTO                                                                        AS "id",

            CASE
                WHEN A.DT_ATENDIMENTO >= CURRENT_TIMESTAMP THEN 'planned'
                WHEN A.DT_ATENDIMENTO IS NULL THEN 'cancelled'
                WHEN A.DH_ALTA_LANCADA IS NOT NULL THEN 'completed'
                WHEN A.DH_ALTA_LANCADA IS NULL THEN
                    CASE
                        WHEN A.TP_ATENDIMENTO IN ('E','A') THEN 'completed'
                        WHEN A.TP_ATENDIMENTO IN ('I','U') THEN 'in-progress'
                        ELSE 'completed'
                    END
                ELSE 'on-hold'
            END                                                             AS "status",

            REPLACE(
                NVL(
                    CASE
                        WHEN AC.CD_ATENDIMENTO  IS NOT NULL THEN C.DS_CIRURGIA
                        WHEN AC.CD_ATENDIMENTO IS NULL THEN COALESCE( ra.DS_PRO_FAT, rh.DS_PRO_FAT)
                        ELSE COALESCE( PF.DS_PRO_FAT, PS.DS_PROCEDIMENTO)
                    END,
                    CASE
                        WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
                        WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
                        WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
                        WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
                        WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
                        WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
                        WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
                        WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
                        ELSE 'Indefinido'
                    END
                ),
            '"','\"')                                                       AS "type",

            '{' ||
                '"reference":"' || TO_CHAR(A.CD_PACIENTE) || '",' ||
                '"display":"'   || REPLACE(NVL(P.NM_PACIENTE,''),'"','\"') || '"' ||
            '}'                                                             AS "subject",

            CASE
                WHEN (
                    CASE
                        WHEN AC.CD_ATENDIMENTO IS NOT NULL THEN pa.CD_PRESTADOR
                        ELSE PP.CD_PRESTADOR
                    END
                ) IS NULL THEN NULL
                ELSE
                '[' ||
                    '{' ||
                    '"type":"PROFESSIONAL",' ||
                    '"actor":{' ||
                        '"reference":"' || TO_CHAR(
                            CASE
                                WHEN AC.CD_ATENDIMENTO IS NOT NULL THEN pa.CD_PRESTADOR
                                ELSE PP.CD_PRESTADOR
                            END
                        ) || '",' ||
                        '"display":"'   || REPLACE(
                                                NVL(
                                                    CASE
                                                        WHEN AC.CD_ATENDIMENTO IS NOT NULL THEN pp2.NM_PRESTADOR
                                                        ELSE PP.NM_PRESTADOR
                                                    END,
                                                    ''
                                                ),
                                                '"','\"'
                                            ) || '"' ||
                    '}' ||
                    '}' ||
                ']'
            END                                                             AS "participants",

            CASE
                WHEN NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO) IS NULL THEN NULL
                ELSE TO_CHAR(NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO),'YYYY-MM-DD"T"HH24:MI:SS')
            END                                                             AS "start",

            CASE
                WHEN A.DT_ALTA IS NULL THEN NULL
                ELSE TO_CHAR(A.DT_ALTA,'YYYY-MM-DD"T"HH24:MI:SS')
            END                                                             AS "end",

            '{' ||
                '"code":"",' ||
                '"display":"' ||
                REPLACE(
                    NVL(
                        CASE
                            WHEN AC.CD_ATENDIMENTO  IS NOT NULL THEN C.DS_CIRURGIA
                            WHEN AC.CD_ATENDIMENTO IS NULL THEN COALESCE( ra.DS_PRO_FAT, rh.DS_PRO_FAT)
                            ELSE COALESCE( PF.DS_PRO_FAT, PS.DS_PROCEDIMENTO)
                        END,
                        CASE
                            WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
                            WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
                            WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
                            WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
                            WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
                            WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
                            WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
                            WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
                            ELSE 'Indefinido'
                        END
                    ),
                '"','\"'
                )
                || '"' ||
            '}'                                                             AS "encounterClass",

            NULL                                                            AS "serviceProvider",

            CASE
                WHEN M.CD_MULTI_EMPRESA IS NULL THEN '[]'
                ELSE
                '[' ||
                    '{"reference":"' || TO_CHAR(M.CD_MULTI_EMPRESA) || '","display":"' ||
                    CASE
                        WHEN M.CD_MULTI_EMPRESA = 1 THEN 'HOSPITAL PRONTOCARDIO'

                        ELSE 'Nao Cadastrado'
                    END
                    || '"}]'
            END                                                             AS "locations",

            (
                SELECT
                CASE
                    WHEN COUNT(*) = 0 THEN '[]'
                    ELSE
                    '[' || LISTAGG(
                            '{"reference":"' || TO_CHAR(AC2.CD_AVISO_CIRURGIA) ||
                            '","display":"Aviso Cirurgia ' || TO_CHAR(AC2.CD_AVISO_CIRURGIA) || '"}'
                            , ','
                            ) WITHIN GROUP (ORDER BY AC2.CD_AVISO_CIRURGIA)
                    || ']'
                END
                FROM dbamv.AVISO_CIRURGIA AC2
                WHERE AC2.CD_ATENDIMENTO = A.CD_ATENDIMENTO
            )                                                              AS "appointments"

        FROM DBAMV.ATENDIME A
        LEFT JOIN DBAMV.PACIENTE P           ON P.CD_PACIENTE         = A.CD_PACIENTE
        LEFT JOIN JN_PRESTADOR PP            ON PP.CD_PRESTADOR       = A.CD_PRESTADOR

        LEFT JOIN DBAMV.AVISO_CIRURGIA AC   ON A.CD_ATENDIMENTO       =  AC.CD_ATENDIMENTO
        LEFT JOIN DBAMV.CIRURGIA_AVISO CA   ON AC.CD_AVISO_CIRURGIA   = CA.CD_AVISO_CIRURGIA AND CA.SN_PRINCIPAL = 'S'
        LEFT JOIN DBAMV.PRESTADOR_AVISO pa   ON AC.CD_AVISO_CIRURGIA  = pa.CD_AVISO_CIRURGIA AND pa.SN_PRINCIPAL = 'S'
        LEFT JOIN DBAMV.CIRURGIA C          ON pa.CD_CIRURGIA         = C.CD_CIRURGIA
        LEFT JOIN JN_PRESTADOR pp2           ON PP2.CD_PRESTADOR      = pa.CD_PRESTADOR

        LEFT JOIN  DBAMV.PROCEDIMENTO_SUS PS ON PS.CD_PROCEDIMENTO    = A.CD_PROCEDIMENTO
        LEFT JOIN  DBAMV.PRO_FAT PF          ON A.CD_PRO_INT          = PF.CD_PRO_FAT

        LEFT JOIN JN_REGRA_AMBULATORIO   ra  ON a.CD_ATENDIMENTO      = ra.CD_ATENDIMENTO
        LEFT JOIN JN_REGRA_HOSPITALAR    rh  ON a.CD_ATENDIMENTO      = rh.CD_ATENDIMENTO
        LEFT JOIN  DBAMV.MULTI_EMPRESAS M    ON M.CD_MULTI_EMPRESA    = A.CD_MULTI_EMPRESA
        WHERE
            NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO) >= TO_DATE('2025-01-01','YYYY-MM-DD')
)

SELECT
    fe."id",
    fe."status",
    fe."type",
    fe."subject",
    fe."participants",
    fe."start",
    fe."end",
    fe."encounterClass",
    fe."serviceProvider",
    fe."locations",
    fe."appointments"
FROM fhir_encounters fe
WHERE
    fe."id" IN(180817, 180793, 275757, 275765, 275765, 276930, 276925, 276920, 276553, 194776)
ORDER BY fe."id"
;


--NULL's:
-- 180817, 180793

-- ################################################ README ################################################




SELECT
  *
FROM DBAMV.AVISO_CIRURGIA
WHERE CD_ATENDIMENTO = 275765--276553--194776--276920 --276925 --276930
;


SELECT
  *
FROM DBAMV.ATENDIME
WHERE CD_ATENDIMENTO IN( 275757, 275765) --194776

ORDER BY CD_ATENDIMENTO DESC

;



SELECT
    pa.*
FROM DBAMV.PRESTADOR_AVISO pa
INNER JOIN DBAMV.PRESTADOR p     ON pa.CD_PRESTADOR = p.CD_PRESTADOR
WHERE pa.CD_AVISO_CIRURGIA IN(14527, 14504)
;