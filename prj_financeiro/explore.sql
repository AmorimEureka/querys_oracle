

SELECT
    *
FROM user_tab_columns
WHERE COLUMN_NAME = 'CD_LCTO_MOVIMENTO'
;


SELECT
    *
FROM user_tab_columns
WHERE  TABLE_NAME LIKE '%RECCON_REC%' AND COLUMN_NAME LIKE '%CAIXA%';



SELECT
    cols.owner AS schema_name,          -- Nome do SCHEMA
    -- sa.COLUMN_ID,
    cols.table_name,                    -- Nome da Tabela
    cols.column_name,                   -- Nome da Coluna
    -- cols.data_type,                     -- Tipo da Coluna
    -- cols.data_length,                   -- Tamanho da Coluna (para tipos como VARCHAR2)
    --cols.nullable,                      -- Se a Coluna Permite NULL
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
    cols.owner = 'DBAMV'
    AND (cols.table_name = 'MOV_CAIXA'
    OR cols.table_name = 'DOC_CAIXA')
    AND cons.constraint_type IN('P', 'R')
ORDER BY
    cols.table_name, cols.column_name;

-- #################################################################################
-- CD_MOV_CAIXA = 53602
-- CD_CON_REC = 22691

-- #################################################################################


SELECT
    *
FROM DBAMV.MOV_CONCOR
WHERE CD_MOV_CAIXA IN(53682, 53683, 53680, 53709,  53684, 53685, 53681, 53710)
-- NR_DOCUMENTO_IDENTIFICACAO = '081121'
;


-- TABELA CON_REC - REGISTRO DO CADASTRO DAS PREVISÕES
SELECT
    *
FROM DBAMV.CON_REC
WHERE CD_CON_REC = 22691
;


-- TABELA ITCON_REC - REGISTRO DOS ITENS DO RECEBIMENTO
SELECT
    *
FROM DBAMV.ITCON_REC
WHERE CD_ITCON_REC = 25026
;


-- TABELA RECCON_REC - REGISTRO DE RECEBIMENTOS NO CONTAS A RECEBER
SELECT
    *
FROM DBAMV.RECCON_REC
WHERE
CD_DOC_CAIXA IN('11807','11808')
AND NR_DOCUMENTO = '081121'
;


-- TABELA MOV_CAIXA - REGISTRO MOVIMENTAÇÃO DE ENTRADAS/SAIDAS NO CAIXA
SELECT
    *
FROM DBAMV.MOV_CAIXA
WHERE CD_MOTIVO_CANC IS NULL
AND CD_DOC_CAIXA IN('11807','11808')
;


-- TABELA DOC_CAIXA - REGISTRO DOS DOCUMENTOS DAS TRANSACOES FINANCEIRAS NO MV
SELECT
    *
FROM DBAMV.DOC_CAIXA
WHERE CD_DOC_CAIXA IN('11807','11808')
-- AND NR_DOCUMENTO = '081121'
-- AND TP_STATUS_DOC = 'E'
;


-- TABELA MOV_CAIXA - REGISTRO MOVIMENTAÇÃO DE ENTRADAS/SAIDAS NO CAIXA
  -- CD_LOTE_CAIXA          - NÓ COMUM ENTRADAS e SAIDAS

  -- CD_MOV_CAIXA_TRANSF    - TRANSACOES ENTRE CAIXAS e TESOURARIA
  --                        - NÃO NULLO SEMPRE QUANDO TP_ORIGEM_MOV = 'TR'

  -- CD_CON_COR             - RECEBIMENTO PIX, RECEBIMENTO DEPOSITO DE DINHEIRO [E/S],
  --                        - NÃO NULLO SEMPRE QUANDO TP_ORIGEM_MOV = 'DE'

  -- CD_LAN_CONCOR          - RECEBIMENTOS e DESPESAS
  --                        - NÃO NULLO SEMPRE QUANDO TP_ORIGEM_MOV = 'RD' ou 'DD'

  -- TP_ORIGEM_MOV          -
  --                        - TR [SAO SAIDAS   (TRANSF. P/ CAIXA ...       )                - COM CD_DOC_CAIXA | TP_MOVIMENTACAO = 'S' | CD_MOV_CAIXA_TRANSF | CD_PROCESSO = 276, 324, 343]
  --                        - TR [SAO SAIDAS   (TRANSF. P/ CAIXA TESOURARIA)                - SEM CD_DOC_CAIXA | TP_MOVIMENTACAO = 'S' | CD_MOV_CAIXA_TRANSF | CD_PROCESSO = 276, 287, 324, 343 | CD_MOTIVO_CANC]
  --                        - TR [SAO ENTRADAS (SANGRIA CAIXA              )                - COM CD_DOC_CAIXA | TP_MOVIMENTACAO = 'E' | CD_MOV_CAIXA_TRANSF | CD_PROCESSO = 275, 323, 342]
  --                        - TR [SAO ENTRADAS (TRANSF. DO CAIXA/CARTAO CAIXA <NOME_SETOR>) - SEM CD_DOC_CAIXA | TP_MOVIMENTACAO = 'E' | CD_MOV_CAIXA_TRANSF | CD_PROCESSO = 275, 286, 323, 342 | CD_MOTIVO_CANC]

  --                        - DE [SAO SAIDAS DEPOSITO                                       - COM DS_MOV_CAIXA = DEPÓSITO PARA C/C :211433-X          | CD_DOC_CAIXA | CD_CON_COR | CD_PROCESSO = 325 ]
  --                        - DE [SAO SAIDAS DEPOSITO                                       - COM DS_MOV_CAIXA = DEPÓSITO PARA C/C :999-0             | CD_DOC_CAIXA | CD_CON_COR | CD_PROCESSO = 277 ]
  --                        - DE [SAO SAIDAS DEPOSITO                                       - COM DS_MOV_CAIXA = DEPÓSITO PARA C/C : 211433           | CD_DOC_CAIXA | CD_CON_COR | CD_PROCESSO = 288 ]
  --                        - DE [SAO SAIDAS DEPOSITO                                       - COM DS_MOV_CAIXA = DEPÓSITO PARA C/C : 211433 ou 999-0  | CD_DOC_CAIXA | CD_CON_COR | CD_PROCESSO = 344 ]

  --                        - RD [SAO ENTRADAS COPIAS DOC, REFEICAO                         - COM CD_DOC_CAIXA   | CD_REDUZIDO | CD_LAN_CONCOR | CD_SETOR | CD_PROCESSO = 280, 289 ou 322]
  --                        - RD [SAO ENTRADAS COPIAS DOC, REFEICAO (VALIDAR SE DINHEIRO)   - SEM CD_DOC_CAIXA   | CD_REDUZIDO | CD_LAN_CONCOR | CD_SETOR | CD_PROCESSO = 280, 289 ou 322]
  --                        - RD [SAO ENTRADAS COPIAS DOC, REFEICAO                         - SEM CD_DOC_CAIXA   | CD_REDUZIDO | CD_LAN_CONCOR | CD_SETOR | CD_PROCESSO = 280, 289 ou 322 | COM CD_MOTIVO_CANC]


  --                        - DD [SAO SAIDAS DESPESAS                                       - COM CD_REDUZIDO | CD_LAN_CONCOR | CD_SETOR (PODE SER NULL QUANDO DS_MOV_CAIXA = 'ALUGUEL') | CD_PROCESSO = 291]

  --                        - RE [SAO ENTRADAS PIX, CARTAO                                  - COM CD_DOC_CAIXA | CD_PROCESSO = 274]
  --                        - RE [SAO ENTRADAS DINHEIRO (PACIENTE)                          - SEM CD_DOC_CAIXA | CD_PROCESSO = 285]

  --                        - PA [SAO SAIDAS EM DINHEIRO (PAGAMENTOS)                       - COM CD_PAGCON_PAG | CD_PROCESSO = 292]

  --                        - ER [SAO SAIDAS (ESTORNO RECEBIMENTO) - CANCELADOS             - COM CD_RECCON_REC | CD_DOC_CAIXA | CD_PROCESSO = 283]

  --                        - CA [SAO ENTRADAS (DEPOSITO ANTECIPADO)                        - COM CD_DOC_CAIXA  | CD_CAUCAO | CD_PROCESSO = 341]

-- ANALITICO
SELECT
    *
FROM DBAMV.MOV_CAIXA
WHERE DT_MOVIMENTACAO  >= ADD_MONTHS(SYSDATE, -25)
    AND TP_ORIGEM_MOV IN('TR')
    AND CD_DOC_CAIXA IS NOT NULL
    AND TP_MOVIMENTACAO = 'S'
    AND CD_MOTIVO_CANC IS NULL
    AND CD_PROCESSO IN(276, 324, 343) -- *
    ORDER BY CD_PROCESSO DESC
;

-- SINTETICO
SELECT
    TP_ORIGEM_MOV,
    COUNT(*)
FROM DBAMV.MOV_CAIXA
WHERE DT_MOVIMENTACAO  >= ADD_MONTHS(SYSDATE, -30)
    AND TP_ORIGEM_MOV IN('TR')
    AND TP_MOVIMENTACAO = 'S'
    AND CD_DOC_CAIXA IS NULL
    GROUP BY TP_ORIGEM_MOV ORDER BY COUNT(*);
