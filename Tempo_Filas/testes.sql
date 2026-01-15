



-- PROCESSOS SEM TRIAGEM
--      - CD_TRIAGEM_ATENDIMENTO MINUS CD_ATENDIMENTO
WITH PROCESSO_SEM_TRIAGEM
    AS (
        SELECT DISTINCT
            tcam.CD_ATENDIMENTO
        FROM SACR_TEMPO_PROCESSO tcam
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TRIAGEM_ATENDIMENTO tri
                WHERE tri.CD_TRIAGEM_ATENDIMENTO = tcam.CD_TRIAGEM_ATENDIMENTO --3461
        )

        MINUS -- 43

        SELECT DISTINCT
            tcam.CD_ATENDIMENTO
        FROM SACR_TEMPO_PROCESSO tcam
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TRIAGEM_ATENDIMENTO tri
                WHERE tcam.CD_ATENDIMENTO = tri.CD_ATENDIMENTO -- 3418
        )
)
SELECT COUNT(*) FROM PROCESSO_SEM_TRIAGEM  ;



-- PROCESSOS SEM TRIAGEM
--      - CD_ATENDIMENTO MINUS CD_TRIAGEM_ATENDIMENTO
WITH PROCESSO_SEM_TRIAGEM
    AS (
        SELECT DISTINCT
            tcam.CD_ATENDIMENTO
        FROM SACR_TEMPO_PROCESSO tcam
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TRIAGEM_ATENDIMENTO tri
                WHERE tcam.CD_ATENDIMENTO = tri.CD_ATENDIMENTO -- 3418
        )

        MINUS -- 0

        SELECT DISTINCT
            tcam.CD_ATENDIMENTO
        FROM SACR_TEMPO_PROCESSO tcam
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TRIAGEM_ATENDIMENTO tri
                WHERE tri.CD_TRIAGEM_ATENDIMENTO = tcam.CD_TRIAGEM_ATENDIMENTO --3461
        )
)
SELECT COUNT(*) FROM PROCESSO_SEM_TRIAGEM  ;




-- INTERSECAO ENTRE AS TABELAS
WITH PROCESSO_SEM_TRIAGEM
    AS (
        SELECT DISTINCT
            tcam.CD_ATENDIMENTO
        FROM SACR_TEMPO_PROCESSO tcam
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TRIAGEM_ATENDIMENTO tri
                WHERE tcam.CD_ATENDIMENTO = tri.CD_ATENDIMENTO -- 3418
        )

        INTERSECT -- 3418

        SELECT DISTINCT
            tcam.CD_ATENDIMENTO
        FROM SACR_TEMPO_PROCESSO tcam
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TRIAGEM_ATENDIMENTO tri
                WHERE tri.CD_TRIAGEM_ATENDIMENTO = tcam.CD_TRIAGEM_ATENDIMENTO --3461
        )
)
SELECT COUNT(*) FROM PROCESSO_SEM_TRIAGEM
;


-- ###########################################################################################


WITH TRIAGEM_SEM_PROCESSO
    AS (
        SELECT DISTINCT
            tri.CD_ATENDIMENTO
        FROM TRIAGEM_ATENDIMENTO tri
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM SACR_TEMPO_PROCESSO tcam
                WHERE tcam.CD_ATENDIMENTO = tri.CD_ATENDIMENTO -- 34
        )

        MINUS

        SELECT DISTINCT
            tri.CD_ATENDIMENTO
        FROM TRIAGEM_ATENDIMENTO tri
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM SACR_TEMPO_PROCESSO tcam
                WHERE tcam.CD_TRIAGEM_ATENDIMENTO = tri.CD_TRIAGEM_ATENDIMENTO -- NULL
        )
)
SELECT * FROM TRIAGEM_SEM_PROCESSO  ;




WITH TRIAGEM_SEM_PROCESSO
    AS (
        SELECT DISTINCT
            tri.CD_ATENDIMENTO
        FROM TRIAGEM_ATENDIMENTO tri
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM SACR_TEMPO_PROCESSO tcam
                WHERE tcam.CD_TRIAGEM_ATENDIMENTO = tri.CD_TRIAGEM_ATENDIMENTO -- NULL
        )

        MINUS

        SELECT DISTINCT
            tri.CD_ATENDIMENTO
        FROM TRIAGEM_ATENDIMENTO tri
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM SACR_TEMPO_PROCESSO tcam
                WHERE tcam.CD_ATENDIMENTO = tri.CD_ATENDIMENTO -- 34
        )
)
SELECT * FROM TRIAGEM_SEM_PROCESSO  ;




WITH TRIAGEM_SEM_PROCESSO
    AS (
        SELECT DISTINCT
            tri.CD_ATENDIMENTO
        FROM TRIAGEM_ATENDIMENTO tri
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM SACR_TEMPO_PROCESSO tcam
                WHERE tcam.CD_TRIAGEM_ATENDIMENTO = tri.CD_TRIAGEM_ATENDIMENTO -- NULL
        )

        INTERSECT

        SELECT DISTINCT
            tri.CD_ATENDIMENTO
        FROM TRIAGEM_ATENDIMENTO tri
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM SACR_TEMPO_PROCESSO tcam
                WHERE tcam.CD_ATENDIMENTO = tri.CD_ATENDIMENTO --34
        )
)
SELECT * FROM TRIAGEM_SEM_PROCESSO  ;