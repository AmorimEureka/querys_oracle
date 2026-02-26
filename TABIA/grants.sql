

-- DROP USER TABIA;

CREATE USER TABIA
-- IDENTIFIED BY <password>
;
/* ############################################################################################ */


-- CONSULTAR PRIVILEGIOS NO NIVEL DE TABELA
SELECT grantor, grantee, owner, table_name, privilege, grantable, type
FROM dba_tab_privs
WHERE grantee = 'TABIA'
  -- AND owner = 'DBAMV'
  -- AND table_name = 'TIP_PRESC'
ORDER BY privilege
;

-- CONSULTAR PRIVILEGIOS POR TABELA
SELECT grantor, grantee, owner, table_name, column_name, privilege, grantable
FROM dba_col_privs
WHERE grantee = 'TABIA'
  AND owner = 'DBAMV'
  AND table_name IN('IT_AGENDA_CENTRAL', 'MOVIMENTO_AGENDA_CENTRAL')
ORDER BY table_name, column_name, privilege;
/* ############################################################################################ */


-- GERAR CODIGO POR OBJETO TABELA - GRANT
WITH alvo_tabelas AS (
    SELECT 'DBAMV' owner, 'IT_AGENDA_CENTRAL' table_name FROM dual
    UNION ALL
    SELECT 'DBAMV', 'MOVIMENTO_AGENDA_CENTRAL' FROM dual
)
SELECT 'GRANT UPDATE ON ' || owner || '.' || table_name || ' TO TABIA;' AS grant_cmd
FROM alvo_tabelas
ORDER BY owner, table_name
;

-- GERAR CODIGO POR OBJETO TABELA - REVOKE
WITH alvo_tabelas AS (
    SELECT 'DBAMV' owner, 'TIP_PRESC' table_name FROM dual
    -- UNION ALL
    -- SELECT 'DBAMV', 'MOVIMENTO_AGENDA_CENTRAL' FROM dual
)
SELECT 'REVOKE UPDATE ON ' || owner || '.' || table_name || ' FROM TABIA;' AS grant_cmd
FROM alvo_tabelas
ORDER BY owner, table_name
;

-- CODIGO GERADO
REVOKE UPDATE ON DBAMV.IT_AGENDA_CENTRAL FROM TABIA;

/* ############################################################################################ */


-- GERAR CODIGO POR OBJETO/COLUNA - GRANT
WITH alvo
  AS (
      SELECT 'DBAMV' owner, 'IT_AGENDA_CENTRAL' table_name, 'DS_OBSERVACAO_GERAL' column_name FROM dual
      UNION ALL
      SELECT 'DBAMV', 'IT_AGENDA_CENTRAL', 'DT_INTEGRA' FROM dual
      UNION ALL
      SELECT 'DBAMV', 'MOVIMENTO_AGENDA_CENTRAL', 'DS_OBSERVACAO_GERAL' FROM dual
      UNION ALL
      SELECT 'DBAMV', 'MOVIMENTO_AGENDA_CENTRAL', 'DT_CADASTRO_JUST_AGDM' FROM dual
)
SELECT
  'GRANT UPDATE (' ||
  LISTAGG(column_name, ', ') WITHIN GROUP (ORDER BY column_name) ||
  ') ON ' || owner || '.' || table_name || ' TO TABIA;' AS grant_cmd
FROM alvo
GROUP BY owner, table_name
ORDER BY owner, table_name
;

-- CODIGO GERADO
GRANT UPDATE (DS_OBSERVACAO_GERAL, DT_INTEGRA) ON DBAMV.IT_AGENDA_CENTRAL TO TABIA;
GRANT UPDATE (DS_OBSERVACAO_GERAL, DT_CADASTRO_JUST_AGDM) ON DBAMV.MOVIMENTO_AGENDA_CENTRAL TO TABIA;
/* ############################################################################################ */


-- GERAR CODIGO POR OBJETO/COLUNA - REVOKE
WITH alvo
  AS (
      SELECT 'DBAMV' owner, 'IT_AGENDA_CENTRAL' table_name, 'DS_OBSERVACAO_GERAL' column_name FROM dual
      UNION ALL
      SELECT 'DBAMV', 'IT_AGENDA_CENTRAL', 'DT_INTEGRA' FROM dual
      UNION ALL
      SELECT 'DBAMV', 'MOVIMENTO_AGENDA_CENTRAL', 'DS_OBSERVACAO_GERAL' FROM dual
      UNION ALL
      SELECT 'DBAMV', 'MOVIMENTO_AGENDA_CENTRAL', 'DT_CADASTRO_JUST_AGDM' FROM dual
)
SELECT
'REVOKE UPDATE (' || LISTAGG(column_name, ', ') WITHIN GROUP (ORDER BY column_name) ||
       ') ON ' || owner || '.' || table_name || ' FROM TABIA;' AS revoke_cmd
FROM alvo
GROUP BY owner, table_name
ORDER BY owner, table_name
;

-- SCRIPT GERADO
REVOKE UPDATE (DS_OBSERVACAO_GERAL, DT_INTEGRA) ON DBAMV.IT_AGENDA_CENTRAL FROM TABIA;
REVOKE UPDATE (DS_OBSERVACAO_GERAL, DT_CADASTRO_JUST_AGDM) ON DBAMV.MOVIMENTO_AGENDA_CENTRAL FROM TABIA;
/* ############################################################################################ */