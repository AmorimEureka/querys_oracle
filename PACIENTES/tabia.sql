/*
   Duplicidade de Pacientes
   Objetivo: Identificar potenciais cadastros duplicados para geração de relatorio com:
    - PRONTUARIO
    - NOME
    - DT_NASCIMENTO
    - NM_MAE
    - USUARIO

   Condicao duplicados:
      - Mesma data de nascimento
      - Mesmo nome da mae
      - Nome do paciente equivalente após normalizacao (remove espaços e upper)
*/

WITH JN_BASE
    AS (
        SELECT
            p.CD_PACIENTE AS PRONTUARIO,
            p.NM_PACIENTE AS NOME,
            p.DT_NASCIMENTO,
            p.NM_MAE,
            UPPER(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(
                    REGEXP_REPLACE(
                        REGEXP_REPLACE(
                            REGEXP_REPLACE(
                                TRIM(p.NM_PACIENTE),
                                '\bDE\b', ' '
                            ),
                            '\bDA\b', ' '
                        ),
                        '\bDO\b', ' '
                    ),
                    '\bDAS\b', ' '
                    ),
                    '\bDOS\b', ' '
                )
            ) AS NOME_NORM
        FROM DBAMV.PACIENTE p
        WHERE p.DT_NASCIMENTO IS NOT NULL AND
              p.NM_PACIENTE IS NOT NULL AND
              p.CD_PACIENTE IS NOT NULL
),
JN_GRUPO
    AS (
        SELECT
            NOME_NORM,
            DT_NASCIMENTO,
            NM_MAE,
            COUNT(*) AS QTD,
            MAX(PRONTUARIO) AS PRONTUARIO_MAIS_RESCENTE
        FROM JN_BASE
        GROUP BY NOME_NORM, DT_NASCIMENTO, NM_MAE
        HAVING COUNT(*) > 1
)
SELECT
   b.PRONTUARIO,
   b.NOME,
   b.DT_NASCIMENTO,
   b.NM_MAE,
   CASE WHEN b.PRONTUARIO = g.PRONTUARIO_MAIS_RESCENTE THEN 1 END AS SN_RESCENTE
FROM JN_BASE b
JOIN JN_GRUPO g ON g.NOME_NORM = b.NOME_NORM AND
                   g.DT_NASCIMENTO = b.DT_NASCIMENTO AND
                   NVL(g.NM_MAE, '#') = NVL(b.NM_MAE, '#')
ORDER BY
    b.NOME,
    b.DT_NASCIMENTO,
    b.nm_mae,
    b.PRONTUARIO
;
