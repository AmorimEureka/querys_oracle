





SELECT * FROM USER_TABLES ;



/*
 * OWNER  |  TABLE_NAME  |  CONSTRAINT_NAME
 */
SELECT	* FROM	user_constraints WHERE	table_name = 'PRESTADOR' ;

/*
 * TABLE_NAME  |  COLUMN_NAME  |  DATA_TYPE
 */
SELECT * FROM user_tab_columns WHERE TABLE_NAME = 'COLUNAS';

SELECT * FROM user_tab_columns WHERE COLUMN_NAME = 'PAR';


/*
 * NUM_ROWS      -> TOTAL DE LINHAS
 * LAST_ANALYZED -> DATA DA ÚLTIMA EXTRAÇÃO DA ÚLTIMA ATUALIZAÇÃO
 * MELHOR USAR COUNT(*) NA TABLE
 *
 */
SELECT * FROM ALL_TABLES atp WHERE atp.TABLE_NAME = 'ATENDIME' ;


SELECT
    cols.owner AS schema_name,          -- Nome do SCHEMA
    sa.COLUMN_ID,
    cols.table_name,                    -- Nome da Tabela
    cols.column_name,                   -- Nome da Coluna
    cols.data_type,                     -- Tipo da Coluna
    cols.data_length,                   -- Tamanho da Coluna (para tipos como VARCHAR2)
    cols.nullable,                      -- Se a Coluna Permite NULL
    cons.constraint_type,               -- Tipo da Constraint (PRIMARY KEY, FOREIGN KEY, UNIQUE, etc.)
    cons.constraint_name                -- Nome da Constraint
FROM
    all_tab_columns cols                -- Metadados de Colunas
LEFT JOIN
    all_cons_columns cons_cols          -- Metadados das Colunas que têm Constraints
    ON cols.owner = cons_cols.owner
    AND cols.table_name = cons_cols.table_name
    AND cols.column_name = cons_cols.column_name
LEFT JOIN
    all_constraints cons                -- Metadados das Constraints
    ON cons.owner = cons_cols.owner
    AND cons.constraint_name = cons_cols.constraint_name
LEFT JOIN user_tab_columns sa
	ON  sa.table_name =  cols.table_name
	AND sa.column_name = cols.column_name
WHERE
    cols.column_name LIKE '%OPERACAO_SALDO%'       -- Filtra por Schema (opcional)
ORDER BY
    sa.COLUMN_ID, cols.owner, cols.table_name, cols.column_name;



Select * from v$version ;