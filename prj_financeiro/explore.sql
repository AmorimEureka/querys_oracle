

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


-- TABELA CON_REC - REGISTRO DO CADASTRO DAS PREVISOES CONTAS A RECEBER
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


-- TABELA MOV_CAIXA - REGISTRO MOVIMENTACAO DE ENTRADAS/SAIDAS NO CAIXA
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


-- ###################################################################################################################################################

/*
 * ************************************* ASSOCIAR GRUPO e SUBGRUPO AS CONTAS ANALITICAS *************************************
 *
 *
 * **************************************************************************************************************************
*/


-- ESTRUTURA PLANO DE CONTAS

-- O CAMPO 'CD_REDUZIDO' NAO-OBRIGATÓRIO:
--      - CON_PAG
--      - PAGCON_PAG
--      - ITCON_PAG   - CAMPO NAO EXISTE
--      - CON_REC
--      - RECCON_REC
--      - ITCON_REC   - CAMPO NAO EXISTE
SELECT
  CD_REDUZIDO,
  -- CD_REDUZIDO_PAI,
  CD_ITEM_RES,
  -- CD_GRAU_DA_CONTA,
  CD_GRUPO_CONTA,     -- 1, 2, 3 e 4
  DS_CONTA,
  DS_FINANC,
  TP_CONTA,           -- SINTETICA | ANALITICA
  TP_NATUREZA,        -- CREDORA   | DEVEDORA
  TP_CONTA_FINANC,    -- R-RECEITA   | D-DESPESA   | G-GERAL
                          -- RELACAO C/ CAMPO CD_GRUPO_CONTA
                            --  1 - MAIORIA CD_GRUPO_CONTA = 'G'
                            --  2 - MAIORIA CD_GRUPO_CONTA = 'G'
                            --  3 - MAIORIA CD_GRUPO_CONTA = 'R'
                            --  4 - MAIORIA CD_GRUPO_CONTA = 'D'

  TP_CONTA_CONTABIL,  -- DADO COMUM C/ CAMPO 'CD_GRUPO_CONTA'
                          -- * 'CD_GRUPO_CONTA' DEVE SER PRIORIZADO
  SN_RECEIT_N_OPERC
FROM DBAMV.PLANO_CONTAS
ORDER BY CD_REDUZIDO, CD_GRUPO_CONTA
;



-- ESTRUTURA DOS PROCESSOS FINANCEIROS

-- COM HIERARQUIA DETERMNADA POR
--      - CD_PROCESSO
--      - CD_PROCESSO_PAI
-- O CAMPO 'CD_PROCESSO' É OBRIGATÓRIO:
--      - CON_PAG
--      - PAGCON_PAG
--      - ITCON_PAG
--      - CON_REC
--      - RECCON_REC
--      - ITCON_REC   - CAMPO NAO EXISTE
SELECT
  CD_PROCESSO,
  CD_MULTI_EMPRESA,
  CD_ESTRUTURAL,
  CD_PROCESSO_PAI,
  DS_PROCESSO,
  TP_PROCESSO   -- S-SINTETICO | A-ANALITICO | F-OUTRA FINALIDADE
FROM DBAMV.PROCESSO
ORDER BY CD_PROCESSO
;



SELECT
  *
FROM DBAMV.CON_PAG
WHERE CD_REDUZIDO IS NULL AND EXTRACT(YEAR FROM DT_PAGAMENTO) = 2025
ORDER BY DT_LANCAMENTO DESC

;

SELECT
  *
FROM DBAMV.PAGCON_PAG
WHERE CD_REDUZIDO IS NULL AND EXTRACT(YEAR FROM DT_PAGAMENTO) = 2025
ORDER BY DT_PAGAMENTO DESC
;



SELECT
  *
FROM DBAMV.CON_REC
WHERE CD_REDUZIDO IS NULL AND EXTRACT(YEAR FROM DT_EMISSAO) = 2025
ORDER BY DT_EMISSAO DESC

;

SELECT
  *
FROM DBAMV.RECCON_REC
WHERE CD_REDUZIDO IS NULL AND EXTRACT(YEAR FROM DT_RECEBIMENTO) = 2025
ORDER BY DT_RECEBIMENTO DESC
;



-- ###################################################################################################################################################

SELECT
  1 id,
  case when not e.cd_especie is null then e.cd_especie||'-'||e.ds_especie
  end ESPECIE,
  s.cd_setor,
  s.nm_setor AS nm_setor,
  i.cd_item_res,
  i.ds_item_res AS ds_item_res,
  r.cd_reduzido AS cd_reduzido,
  p.ds_conta AS ds_conta,
  r.vl_rateio vl_rateio,
  to_char(r.dt_competencia, 'MM/YYYY') dt_competencia,
  r.cd_multi_empresa,
  c.cd_con_pag cd_identificador,
  c.ds_fornecedor,
  Decode(pr.cd_estrutural, NULL, ' ', pr.cd_estrutural || ' - ' || pr.ds_processo) processo,
  to_char(c.dt_lancamento,'DD/MM/YYYY') dt_emissao,
  c.nr_documento documento,
  c.ds_con_pag descricao
FROM dbamv.con_pag c,
  dbamv.ratcon_pag r,
  dbamv.plano_contas p,
  dbamv.processo pr,
  dbamv.item_res i,
  dbamv.setor s,
  dbamv.especie e
WHERE c.cd_con_pag = r.cd_con_pag
  AND i.cd_item_res = r.cd_item_res
  AND s.cd_setor = r.cd_setor
  AND c.cd_processo = pr.cd_processo (+)
  AND r.cd_reduzido = p.cd_reduzido(+)
  AND i.cd_item_res =e.cd_item_res(+)
  AND to_char(r.dt_competencia, 'MM/YYYY') in '04/2025'
;



SELECT
  setor.nm_setor,
  Sum(itcon_pag.vl_duplicata - NVL (itcon_pag.vl_soma_baixada, 0)) vl_a_pagar,
  Sum(ratcon_pag.vl_rateio) vl_rateio,
  Sum(NVL (con_pag.vl_bruto_conta, 0)  + (NVL (con_pag.vl_desconto, 0) - NVL (con_pag.vl_acrescimo, 0))) vl_bruto
FROM dbamv.itcon_pag itcon_pag,
  dbamv.con_pag con_pag,
  dbamv.ratcon_pag ratcon_pag,
  dbamv.item_res item_res,
  dbamv.gru_res gru_res,
  dbamv.fornecedor fornecedor,
  dbamv.historico_padrao hist_p,
  dbamv.setor setor,
  dbamv.tip_doc tip_doc
WHERE ratcon_pag.cd_item_res = item_res.cd_item_res(+)
  AND item_res.cd_gru_res = gru_res.cd_gru_res(+)
  AND con_pag.cd_con_pag = ratcon_pag.cd_con_pag(+)
  AND con_pag.cd_con_pag = itcon_pag.cd_con_pag
  AND     itcon_pag.tp_quitacao not in ('Q', 'N', 'T', 'L')
  AND con_pag.cd_fornecedor = fornecedor.cd_fornecedor(+)
  AND con_pag.cd_historico_padrao = hist_p.cd_historico_padrao(+)
  AND con_pag.cd_tip_doc = tip_doc.cd_tip_doc
--  AND con_pag.cd_multi_empresa IN ($pgmvCdEmpresa$)
  AND NOT EXISTS (
                  SELECT it.cd_con_pag
                  FROM dbamv.itcon_pag it
                  WHERE it.cd_con_pag_agrup = itcon_pag.cd_con_pag
                )
  AND con_pag.cd_previsao IS NULL
  AND itcon_pag.dt_vencimento >=  trunc(sysdate)
  AND itcon_pag.dt_vencimento <= trunc(sysdate) + 30
  AND ratcon_pag.cd_setor = setor.cd_setor(+)
  AND itcon_pag.vl_duplicata - NVL (itcon_pag.vl_soma_baixada, 0) > 0
GROUP BY setor.nm_setor
ORDER BY vl_a_pagar DESC
;


SELECT
  plano_contas.cd_reduzido,
  plano_contas.ds_conta ds_con_pag,
  Sum(ratcon_pag.vl_rateio) vl_rateio
  /*Sum(itcon_pag.vl_duplicata - NVL (itcon_pag.vl_soma_baixada, 0)) vl_a_pagar,
  Sum(NVL (con_pag.vl_bruto_conta, 0) + (NVL (con_pag.vl_desconto, 0) - NVL (con_pag.vl_acrescimo, 0))) vl_bruto */
FROM dbamv.itcon_pag itcon_pag,
  dbamv.con_pag con_pag,
  dbamv.ratcon_pag ratcon_pag,
  dbamv.item_res item_res,
  dbamv.gru_res gru_res,
  dbamv.fornecedor fornecedor,
  dbamv.historico_padrao hist_p,
  dbamv.setor setor,
  dbamv.tip_doc tip_doc,
  dbamv.plano_contas plano_contas
WHERE ratcon_pag.cd_item_res = item_res.cd_item_res(+)
  AND item_res.cd_gru_res = gru_res.cd_gru_res(+)
  AND con_pag.cd_con_pag = ratcon_pag.cd_con_pag(+)
  AND con_pag.cd_con_pag = itcon_pag.cd_con_pag
  AND itcon_pag.tp_quitacao not in ('Q', 'N', 'T', 'L')
  AND con_pag.cd_fornecedor = fornecedor.cd_fornecedor(+)
  AND con_pag.cd_historico_padrao = hist_p.cd_historico_padrao(+)
  AND con_pag.cd_tip_doc = tip_doc.cd_tip_doc
--  AND con_pag.cd_multi_empresa IN ($pgmvCdEmpresa$)
  AND NOT EXISTS (
                  SELECT it.cd_con_pag
                  FROM dbamv.itcon_pag it
                  WHERE it.cd_con_pag_agrup = itcon_pag.cd_con_pag
                )
  AND con_pag.cd_previsao IS NULL
  AND itcon_pag.dt_vencimento >= trunc(sysdate)
  AND itcon_pag.dt_vencimento <= trunc(sysdate) + 30
  AND ratcon_pag.cd_setor = setor.cd_setor(+)
  AND itcon_pag.vl_duplicata - NVL (itcon_pag.vl_soma_baixada, 0) > 0
  AND plano_contas.cd_reduzido = ratcon_pag.cd_reduzido
GROUP BY plano_contas.cd_reduzido, plano_contas.ds_conta
ORDER BY vl_rateio DESC
;


SELECT
  mesano,
  tipo,
  valor
--  , Round(valor/ 1 ) Valor
FROM (
      SELECT
        To_Char(itcon_rec.DT_PREVISTA_RECEBIMENTO,'mm/yyyy') mesano,
        'Previsto' TIpo,
        Sum(itcon_rec.vl_duplicata) Valor
        FROM dbamv.con_rec,
          dbamv.itcon_rec
      WHERE con_rec.cd_con_rec = itcon_rec.cd_con_rec
        AND con_rec.DT_CANCELAMENTO IS NULL
        AND itcon_rec.DT_PREVISTA_RECEBIMENTO BETWEEN Add_Months(Trunc(SYSDATE,'mm'), - 6) AND Last_Day(Trunc(SYSDATE))
        AND ITCON_REC.CD_CON_REC_AGRUP IS NULL
      --   AND CD_MULTI_EMPRESA  IN ($pgmvCdEmpresa$)
      GROUP BY To_Char(itcon_rec.DT_PREVISTA_RECEBIMENTO,'mm/yyyy')
      UNION ALL
      SELECT
        To_Char(DT_RECEBIMENTO,'mm/yyyy') mesano,
        'Recebido' Tipo,
        Sum(VL_RECEBIDO) Valor
      FROM dbamv.reccon_rec,
        dbamv.itcon_rec
      WHERE reccon_rec.cd_itcon_rec = itcon_rec.cd_itcon_rec
        AND ITCON_REC.CD_CON_REC_AGRUP IS NULL
        AND DT_RECEBIMENTO BETWEEN Add_Months(Trunc(SYSDATE,'mm'), - 6) AND Last_Day(Trunc(SYSDATE))
      --  AND CD_MULTI_EMPRESA  IN ($pgmvCdEmpresa$)
      GROUP BY To_Char(DT_RECEBIMENTO,'mm/yyyy')
      )
ORDER BY To_Date(mesano,'mm/yyyy'), 2
 ;



SELECT
  nm_fantasia,
  Tipo,
  Round(valor/ 1 ) Valor
FROM (
      SELECT
        nm_fantasia,
        'Previsto' Tipo,
        Sum(itcon_rec.VL_DUPLICATA) valor
      FROM dbamv.con_rec,
        dbamv.itcon_rec,
        dbamv.fornecedor
      WHERE con_rec.cd_con_rec    = itcon_rec.cd_con_rec
        AND con_rec.cd_fornecedor = fornecedor.cd_fornecedor
        AND ITCON_REC.CD_CON_REC_AGRUP IS NULL
        AND DT_PREVISTA_RECEBIMENTO BETWEEN trunc(sysdate)-30 AND  trunc(sysdate)
        --   AND con_rec.cd_multi_empresa   IN ($pgmvCdEmpresa$)
        AND itcon_rec.DT_CANCELAMENTO IS NULL
      GROUP BY nm_fantasia
      ORDER BY Valor DESC
  )
WHERE ROWNUM <= 1

UNION ALL

SELECT
  nm_fantasia,
  Tipo,
  Valor
FROM (
      SELECT
        nm_fantasia,
        'Recebido' Tipo,
        Sum(reccon_rec.VL_RECEBIDO) valor
      FROM dbamv.con_rec,
        dbamv.itcon_rec,
        dbamv.fornecedor,
        dbamv.reccon_rec
      WHERE con_rec.cd_con_rec    = itcon_rec.cd_con_rec
        AND con_rec.cd_fornecedor = fornecedor.cd_fornecedor
        AND reccon_rec.cd_itcon_rec = itcon_rec.cd_itcon_rec
        AND ITCON_REC.CD_CON_REC_AGRUP IS NULL
        AND DT_RECEBIMENTO BETWEEN trunc(sysdate)-30 AND  trunc(sysdate)
      --   AND con_rec.cd_multi_empresa   IN ($pgmvCdEmpresa$)
        AND itcon_rec.DT_CANCELAMENTO IS NULL
      GROUP BY nm_fantasia
      ORDER BY valor desc
      )
 WHERE ROWNUM <= 1
 ORDER BY 1, 2
 ;


 SELECT
  to_number(dia) dia,
  Tipo,
  Round(valor/ 1 ) Valor
FROM (
      SELECT
        To_Char(DT_PREVISTA_RECEBIMENTO,'dd') Dia,
        'A Receber' Tipo,
        Sum(itcon_rec.VL_DUPLICATA) valor
      FROM dbamv.con_rec,
        dbamv.itcon_rec,
        dbamv.fornecedor
      WHERE con_rec.cd_con_rec    = itcon_rec.cd_con_rec
        AND con_rec.cd_fornecedor = fornecedor.cd_fornecedor
      --   AND con_rec.cd_multi_empresa  IN ($pgmvCdEmpresa$)
        AND ITCON_REC.CD_CON_REC_AGRUP IS NULL
        AND DT_PREVISTA_RECEBIMENTO BETWEEN Trunc(SYSDATE) AND Trunc(SYSDATE) + 30
        AND itcon_rec.DT_CANCELAMENTO IS NULL
      GROUP BY To_Char(DT_PREVISTA_RECEBIMENTO,'dd')

      UNION ALL

      SELECT
        To_Char(itcon_pag.dt_vencimento, 'dd') dia,
        'A Pagar' Tipo,
        Sum(itcon_pag.vl_duplicata - NVL (itcon_pag.vl_soma_baixada, 0)) vl_a_pagar
      FROM dbamv.itcon_pag,
        dbamv.con_pag
      WHERE con_pag.cd_con_pag = itcon_pag.cd_con_pag
        AND itcon_pag.tp_quitacao not in ('Q', 'N', 'T', 'L')
      --   AND con_pag.cd_multi_empresa  IN ($pgmvCdEmpresa$)
        AND itcon_pag.cd_con_pag_agrup IS NULL
        AND con_pag.cd_previsao IS NULL
        AND itcon_pag.dt_vencimento BETWEEN trunc(sysdate)-30 AND  trunc(sysdate)
        AND itcon_pag.vl_duplicata - NVL (itcon_pag.vl_soma_baixada, 0) > 0
      GROUP BY To_Char(itcon_pag.dt_vencimento, 'dd')
       )
 ORDER BY to_number(dia), tipo
;


SELECT
  To_Char(ent_pro.dt_entrada, 'mm/rrrr') ms,
  Trunc(Sum(vl_total_custo_real),2) vl_total_custo_real,
  'Entradas' situacao
FROM dbamv.ent_pro,
  dbamv.itent_pro,
  dbamv.produto,
  dbamv.estoque
WHERE itent_pro.cd_produto = produto.cd_produto
  AND ent_pro.cd_ent_pro = itent_pro.cd_ent_pro
  AND estoque.cd_estoque = ent_pro.cd_estoque
--    AND produto.cd_especie  IN ($pgmvEspecie$)
--    AND estoque.cd_multi_empresa in ($pgmvCdEmpresa$)
  AND ent_pro.dt_entrada BETWEEN trunc(sysdate)-30 AND  trunc(sysdate)
GROUP BY To_Char(ent_pro.dt_entrada, 'mm/rrrr')

UNION ALL

SELECT
  To_Char(mvto_estoque.dt_mvto_estoque, 'mm/rrrr') ms,
  sum(decode(mvto_Estoque.tp_mvto_estoque,'D', -1, 'C', -1, 'N', -1, 1) *
            (itmvto_estoque.qt_movimentacao * uni_pro.vl_fator) *
            dbamv.verif_vl_custo_medio(
                                        itmvto_estoque.cd_produto,
                                        mvto_estoque.dt_mvto_estoque,
                                        'H',
                                        produto.vl_custo_medio,
                                        mvto_estoque.hr_mvto_estoque,
                                        estoque.cd_multi_empresa
                                  )
        ) VL_TOTAL_CUSTO_REAL,
       'Saídas' situacao
FROM dbamv.mvto_estoque,
  dbamv.itmvto_estoque,
  dbamv.produto,
  dbamv.uni_pro,
  dbamv.estoque
WHERE mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
  AND itmvto_estoque.cd_produto = produto.cd_produto
  AND itmvto_estoque.CD_UNI_PRO = uni_pro.CD_UNI_PRO
  AND mvto_estoque.cd_estoque =estoque.cd_estoque
  --    AND produto.cd_especie  IN ($pgmvEspecie$)
  AND mvto_estoque.tp_mvto_estoque IN ('S', 'P', 'D', 'C', 'N', 'V', 'E')
  --    AND estoque.cd_multi_empresa in ($pgmvCdEmpresa$)
  AND mvto_estoque.dt_mvto_estoque BETWEEN trunc(sysdate)-30 AND  trunc(sysdate)
  GROUP BY To_Char(mvto_estoque.dt_mvto_estoque, 'mm/rrrr')
ORDER BY ms, situacao
;