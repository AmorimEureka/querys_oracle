



-- ************************************************************************************************************************************************************* --
-- ****************************************************** QUERY ORIGINAL - LUCAS/JULIO ************************************************************************* --
SELECT DISTINCT 
	   io.cd_ord_com, 
       io.cd_produto,
       INITCAP(p.ds_produto) AS ds_produto,
       p.cd_especie,
       INITCAP(es.ds_especie) AS ds_especie,
       sc.cd_sol_com,
       sc.dt_sol_com,
       ip.dt_gravacao as dt_entrada,
       ic.dt_cancel,
       ic.qt_solic,
       ic.qt_comprada,
       ip.qt_entrada,
       ic.qt_atendida,
       io.vl_unitario,
       sc.vl_total,
       sc.cd_estoque,
       INITCAP(e.ds_estoque) AS ds_estoque,
       ep.cd_fornecedor,
       INITCAP(f.nm_fornecedor) AS nm_fornecedor,
       sc.cd_setor,
       INITCAP(s.nm_setor) AS nm_setor,
       DECODE(sc.tp_situacao, 'A', 'Aberta', 'F', 'Fechada', 'P', 'Parcialmente Atendida', 'S', 'Solicitada', 'C', 'Cancelada') AS tp_situacao,
       DECODE(oc.tp_situacao, 'A', 'Aberta', 'U', 'Autorizada', 'N', 'Não Autorizada', 'P', 'Pendente', 'L', 'Parcialmente Atendida', 'T', 'Atendida', 'C', 'Cancelada', 'D', 'Adjudicação', 'O', 'Aguard. Próximo Nível') AS tp_situacao_ordem_comp, 
       INITCAP(sc.nm_solicitante) as nm_solicitante
FROM ITORD_PRO io
LEFT JOIN produto p ON p.cd_produto = io.cd_produto
left JOIN especie es ON es.cd_especie = p.cd_especie
left JOIN ord_com oc ON oc.cd_ord_com = io.cd_ord_com 
left JOIN sol_com sc ON sc.cd_sol_com = oc.cd_sol_com
left JOIN itsol_com ic ON ic.cd_sol_com = sc.cd_sol_com AND ic.cd_produto = io.cd_produto
left JOIN ent_pro ep ON ep.cd_ord_com = oc.cd_ord_com
left JOIN itent_pro ip ON ip.cd_ent_pro = ep.cd_ent_pro AND p.cd_produto = ip.cd_produto
left JOIN fornecedor f ON f.cd_fornecedor = ep.cd_fornecedor
LEFT JOIN setor s ON s.cd_setor = sc.cd_setor
left JOIN estoque e ON e.cd_estoque = sc.cd_estoque
WHERE sc.cd_sol_com = 2518 AND ip.dt_gravacao IS NOT NULL
ORDER BY io.cd_produto ;



-- ************************************************************************************************************************************************************* --
-- ************************************************************ QUERY FINAL - AJUSTADA ************************************************************************* --

-- QUERY AJUSTADA - PHELIPE REPORTOU PROBLEMAS NOS CAMPOS 'qt_solic' , 'qt_compra' , 'qt_atendida'

/*
 * - Os campos "ip.qt_atendida" e "io.qt_comprada" estavam referenciando, respectivamente, as tabelas "itent_pro AS ip" e "itord_pro AS io" e
 *   as referencias foram substituídas pela tabela "itsol_com AS ic". Após a substituíção e os ajustes abaixo, os valores foram corrijidos ; 
 * - "ip.dt_gravacao IS NOT NULL" -> Filtro para remover HISTORICO das linhas retornadas na consulta ;
 * - "ic.qt_solic IS NOT NULL"    -> Filtro para remover linhas NULL da qt_solic, pois traziam itens retornados pela incorreção dos joins da query ;
 * - Inclusão sub-querys para totalizar o acumulado dos campos 'qt_entrada' e 'qt_atendida' ;
 * - Inclusão do campo 'SALDO', anteriormente esse campo era calculado no PowerBI ;
 * - Inclusão dos campos 'qt_entrada_parcial' e 'qt_atendida_parcial' para sinalizar o atendimento da Ordem_Compra atendida por mais de um fornecedor ;
 * 
 * OBS.: Os JOIN's do MER de compras possuí 2 tabelas com relacionamentos *:*, as tabelas "ITSOL_COM" e "ITORD_PRO";
 *       a query original, bem como a ajustada foi escrita sem a desnormalização desse modelo, por tanto foi 
 *       necessário ajustar algumas ocorrências para atender a área de negócio.
 * */


SELECT DISTINCT 
    ep.NR_DOCUMENTO
    , io.cd_ord_com
    , io.cd_produto
    , INITCAP(p.ds_produto) AS ds_produto
    , p.cd_especie
    , INITCAP(es.ds_especie) AS ds_especie
    , sc.cd_sol_com
    , sc.dt_sol_com
    , sc.DT_SOL_COM
    , oc.DT_ORD_COM
    , ip.dt_gravacao AS dt_entrada
    , ic.dt_cancel
    , ic.qt_solic
    , ic.qt_comprada
--    , ip.qt_entrada
--    , ip.qt_atendida
    , CASE 
     	WHEN COUNT(*) OVER(PARTITION BY io.cd_produto, sc.cd_sol_com) > 1 THEN
      		ip.qt_entrada
      	ELSE 0
      END AS qt_entrada_parcial
    , SUM(ip.qt_entrada) OVER(PARTITION BY io.cd_produto, sc.cd_sol_com) AS qt_entrada_total
    , CASE 
    	WHEN COUNT(*) OVER(PARTITION BY io.cd_produto, sc.cd_sol_com) > 1 THEN
    		ip.qt_atendida
    	ELSE 0
      END AS qt_atendida_parcial
    , SUM(ip.qt_atendida) OVER(PARTITION BY io.cd_produto, sc.cd_sol_com) AS qt_atendida_total
    , (SUM(ip.qt_entrada) OVER(PARTITION BY io.cd_produto, sc.cd_sol_com)- ic.qt_solic) AS saldo
    , io.vl_unitario
    , SUM(io.vl_unitario) OVER(PARTITION BY io.cd_produto, sc.cd_sol_com) AS vl_total_teste
    , sc.vl_total
    , sc.cd_estoque
    , INITCAP(e.ds_estoque) AS ds_estoque
    , ep.cd_fornecedor
    , INITCAP(f.nm_fornecedor) AS nm_fornecedor
    , sc.cd_setor
    , INITCAP(s.nm_setor) AS nm_setor
    , DECODE(sc.tp_situacao, 'A', 'Aberta', 'F', 'Fechada', 'P', 'Parcialmente Atendida', 'S', 'Solicitada', 'C', 'Cancelada') AS tp_situacao
    , DECODE(oc.tp_situacao, 'A', 'Aberta', 'U', 'Autorizada', 'N', 'Não Autorizada', 'P', 'Pendente', 'L', 'Parcialmente Atendida', 'T', 'Atendida', 'C', 'Cancelada', 
                             'D', 'Adjudicação', 'O', 'Aguard. Próximo Nível') AS tp_situacao_ordem_comp
    , INITCAP(sc.nm_solicitante) AS nm_solicitante
FROM 
    itord_pro io
LEFT JOIN 
    produto p ON p.cd_produto = io.cd_produto
LEFT JOIN 
    especie es ON es.cd_especie = p.cd_especie
LEFT JOIN 
    ord_com oc ON oc.cd_ord_com = io.cd_ord_com 
LEFT JOIN 
    sol_com sc ON sc.cd_sol_com = oc.cd_sol_com
LEFT JOIN 
    itsol_com ic ON ic.cd_sol_com = sc.cd_sol_com AND ic.cd_produto = io.cd_produto
LEFT JOIN 
    ent_pro ep ON ep.cd_ord_com = oc.cd_ord_com
LEFT JOIN 
    itent_pro ip ON ip.cd_ent_pro = ep.cd_ent_pro AND p.cd_produto = ip.cd_produto
LEFT JOIN 
    fornecedor f ON f.cd_fornecedor = ep.cd_fornecedor
LEFT JOIN 
    setor s ON s.cd_setor = sc.cd_setor
LEFT JOIN 
    estoque e ON e.cd_estoque = sc.cd_estoque
WHERE
    -- ic.qt_solic IS NOT NULL AND
    -- ip.dt_gravacao IS NOT NULL AND
    sc.CD_SOL_COM = 3454
    -- AND p.CD_PRODUTO  = 2088
ORDER BY 
    io.cd_produto;


-- ************************************************************************************************************************************************************* --
-- **************************************************************** ANALISE EXPLORATÓRIO *********************************************************************** --


SELECT DISTINCT -- PRIMEIRO FLUXO
	oc.CD_ORD_COM ,
	oc.CD_FORNECEDOR ,
	sc.CD_SOL_COM ,
	p.CD_PRODUTO ,
	p.DS_PRODUTO ,
    ic.dt_cancel,
    ic.qt_solic, 
	sc.cd_sol_com,
    sc.dt_sol_com,
    sc.vl_total,
    sc.cd_estoque,
    sc.cd_setor,
    DECODE(sc.tp_situacao, 'A', 'Aberta', 'F', 'Fechada', 'P', 'Parcialmente Atendida', 'S', 'Solicitada', 'C', 'Cancelada') AS tp_situacao,
	DECODE(oc.tp_situacao, 'A', 'Aberta', 'U', 'Autorizada', 'N', 'Não Autorizada', 'P', 'Pendente', 'L', 'Parcialmente Atendida', 'T', 'Atendida', 'C', 'Cancelada', 'D', 'Adjudicação', 'O', 'Aguard. Próximo Nível') AS tp_situacao_ordem_comp,
	INITCAP(sc.nm_solicitante) as nm_solicitante
FROM DBAMV.ORD_COM oc 
LEFT JOIN DBAMV.SOL_COM sc 
	ON oc.CD_SOL_COM = sc.CD_SOL_COM
LEFT JOIN DBAMV.ITSOL_COM ic 
	ON sc.CD_SOL_COM = ic.CD_SOL_COM
LEFT JOIN DBAMV.PRODUTO p 
	ON ic.CD_PRODUTO = p.CD_PRODUTO
WHERE oc.CD_ORD_COM = 4026 ;
ORDER BY p.CD_PRODUTO ;



SELECT -- SEGUNDO FLUXO
    oc. CD_ORD_COM ,
    ip.CD_PRODUTO ,
    ip.qt_comprada ,
    ip.vl_unitario
FROM DBAMV.ORD_COM oc  
LEFT JOIN DBAMV.ITORD_PRO ip
	ON oc.CD_ORD_COM = ip.CD_ORD_COM
WHERE ip.CD_ORD_COM = 4026 ;

		
		
SELECT -- TERCEIRO FLUXO
	oc.CD_ORD_COM ,
	p.CD_PRODUTO ,
	p.DS_PRODUTO ,
	ep.CD_FORNECEDOR ,
	ip.dt_gravacao ,
	ip.qt_entrada ,
	ip.qt_atendida
FROM DBAMV.ORD_COM oc 
LEFT JOIN DBAMV.ENT_PRO ep 
	ON oc.CD_ORD_COM = ep.CD_ORD_COM 
LEFT JOIN DBAMV.ITENT_PRO ip 
	ON ep.CD_ENT_PRO = ip.CD_ENT_PRO
LEFT JOIN DBAMV.PRODUTO p 
	ON ip.CD_PRODUTO = p.CD_PRODUTO 
WHERE oc.CD_ORD_COM = 4026 ;


-- ************************************************************************************************************************************************************* --
-- ************************************************************************************************************************************************************* --

WITH teste AS (
    SELECT 
        oc.CD_ORD_COM
        , itpr.CD_ORD_COM AS itpr_qtd
    FROM
        DBAMV.ITORD_PRO itpr
    LEFT JOIN DBAMV.ORD_COM oc ON itpr.CD_ORD_COM = itpr.CD_ORD_COM
    WHERE itpr.CD_ORD_COM = 5682 --AND oc.DT_ORD_COM BETWEEN SYSDATE-30 AND SYSDATE
 )
 SELECT COUNT(*) FROM teste -- WHERE ROWNUM <= 1000
 ;

/* ----------------------------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------------------------- */

    --FUNCTIONS:
        -- VL_CUSTO_UNIT
            -- Valor do custo Fixo. (F)
            -- Valor do custo Medio no periodo. (M)
            -- Valor do Ultimo custo do periodo. (U)

        -- VERIF_ESTOQUE

        -- VERIF_VL_CUSTO_MEDIO

        -- VERIF_VL_FATOR_PROD



/* ----------------------------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------------------------- */






-- sol_com:
    -- cd_sol_com
    -- cd_mot_ped
    -- cd_setor
    -- cd_estoque
    -- cd_mot_cancel
    -- cd_atendime
    -- vl_total
    -- dt_sol_com
    -- dt_cancelamento
    -- nm_solicitante
    -- tp_situacao
    -- tp_sol_com
    -- sn_urgente
    -- sn_aprovado
    -- sn_opme

-- ord_com:
    -- cd_ord_com
    -- cd_estoque
    -- cd_fornecedor
    -- cd_sol_com
    -- cd_mot_cancel
    -- cd_usuario_criador_oc
    -- cd_ultimo_usu_alt_oc
    -- dt_ord_com
    -- dt_cancelamento
    -- dt_autorizacao
    -- dt_ultima_alteracao_oc
    -- tp_ord_com
    -- sn_autorizado

-- ent_pro:
    -- cd_ent_pro
    -- cd_tip_ent
    -- cd_estoque
    -- cd_fornecedor
    -- cd_ord_com
    -- cd_usuario_recebimento
    -- cd_atendimento
    -- dt_emissao
    -- dt_entrada
    -- dt_recebimento
    -- hr_entrada
    -- vl_total
    -- nr_documento
    -- nr_chave_acesso
    -- sn_autorizado

-- itsol_com:
    -- cd_sol_com
    -- cd_produto
    -- cd_uni_pro
    -- cd_mot_cancel
    -- dt_cancelamento
    -- qt_solic
    -- qt_comprada
    -- qt_atendida
    -- sn_comprado

-- itord_pro:
    -- cd_ord_com
    -- cd_produto
    -- cd_uni_pro
    -- cd_mot_cancel
    -- dt_cancelamento
    -- qt_comprada
    -- qt_atendida
    -- qt_recebida
    -- qt_cancelada
    -- vl_unitario
    -- vl_total
    -- vl_custo_real
    -- vl_total_custo_real

-- itent_pro:
    -- cd_itent_pro
    -- cd_ent_pro
    -- cd_produto
    -- cd_uni_pro
    -- cd_atendimento
    -- cd_custo_medio
    -- cd_produto_fornecedor
    -- dt_gravacao
    -- qt_entrada
    -- qt_devolucao
    -- qt_atendida
    -- vl_unitario
    -- vl_custo_real
    -- vl_total_custo_real
    -- vl_total

-- produto:
    -- cd_produto
    -- cd_especie
    -- dt_cadastro
    -- dt_ultima_entrada
    -- hr_ultima_entrada
    -- qt_estoque_atual --nao confiar nisso pegar da "est_pro"
    -- qt_ultima_entrada
    -- vl_ultima_entrada
    -- vl_custo_medio
    -- vl_ultima_custo_real
    -- ds_produto
    -- ds_produto_resumido

-- uni_pro:
    -- cd_uni_pro
    -- cd_unidade
    -- cd_produto
    -- vl_fator
    -- tp_relatorios
    -- sn_ativo

-- fornecedor:
    -- cd_fornecedor
    -- nm_fornecedor
    -- nm_fantasia
    -- tp_fornecedor
    -- nr_cgc_cpf
    -- dt_inclusao

-- mot_cancel:
    -- cd_mot_cancel
    -- ds_mot_cancel
    -- tp_mot_calcel

-- est_pro:
    -- cd_estoque
    -- cd_produto
    -- ds_localizacao_prateleira
    -- qt_estoque_atual
    -- qt_estoque_maximo
    -- qt_estoque_minimo
    -- qt_estoque_virtual
    -- qt_ponto_de_pedido
    -- qt_consumo_mes
    -- qt_solicitacao_de_compra
    -- qt_ordem_de_compra
    -- dt_ultima_movimentacao
    -- tp_classificacao_abc
    -- qt_estoque_doado
    -- qt_estoque_reservado
    -- cd_localizacao
    -- qt_consumo_atual

-- estoque:
    -- cd_estoque
    -- cd_setor
    -- ds_estoque
    -- tp_estoque

-- lot_pro:
    -- cd_lot_pro
    -- cd_estoque
    -- cd_produto
    -- cd_lote
    -- dt_validade
    -- qt_estoque_atual

-- setor:
    -- CD_SETOR
    -- CD_FATOR
    -- CD_GRUPO_CUSTO
    -- CD_SETOR_CUSTO
    -- NM_SETOR
    -- SN_ATIVO

-- especie:
    -- CD_ESPECIE
    -- CD_ITEM_RES
    -- DS_ESPECIE

-- mvto_estoque:
    -- CD_MVTO_ESTOQUE
    -- CD_ESTOQUE
    -- CD_UNI_PRO
    -- CD_UNID_INT
    -- CD_SETOR
    -- CD_ESTOQUE_DESTINO
    -- CD_CUSTO_MEDIO
    -- CD_AVISO_CIRURGIA
    -- CD_ENT_PRO
    -- CD_USUARIO
    -- CD_FORNECEDOR
    -- CD_PRESTADOR
    -- CD_PRE_MED
    -- CD_ATENDIMENTO
    -- CD_MOT_DEV
    -- DT_MVTO_ESTOQUE
    -- HR_MVTO_ESTOQUE
    -- VL_TOTAL
    -- TP_MVTO_ESTOQUE
    -- NR_DOCUMENTO
    -- CHAVE_NFE


-- itmvto_estoque:
    -- CD_ITMVTO_ESTOQUE
    -- CD_MVTO_ESTOQUE
    -- CD_PRODUTO
    -- CD_UNI_PRO
    -- CD_LOTE
    -- CD_ITENT_PRO
    -- CD_FORNECEDOR
    -- CD_ITPRE_MED
    -- DT_VALIDADE
    -- DH_MVTO_ESTOQUE
    -- QT_MOVIMENTACAO
    -- VL_UNITARIO
    -- TP_ESTOQUE









    -- TESTE_1:
        -- 1 SOL_COM - TEM 13 ORD_COM
            -- 1 DESSAS 13 ORD_COM - TEM 9 ITORD_PRO
                -- 9 ITORD_PRO - 9 PRODUTOS
        
        -- 1 SOL_COM - TEM 25 ITSOL_COM
            -- 25 ITSOL_COM - 25 PRODUTOS

        -- # TESTAR SE A QUANTIDADE PRODUTOS DAS 13 ORD_COM É IGUAL 25 [ 25 ITSOL_COM ]
    
    -- TESTE_2:
        -- 1 ORD_COM - TEM 4 ENT_PRO
            -- 1 DESSAS 4 ENT_PRO - TEM 3 ITENT_PRO
                -- 3 ITENT_PRO - 3 PRODUTO
        
        -- 1 ORD_COM [ NO GERAL ] - TEM 15 ITENT_PRO/PRODUTO

        -- # TESTAR SE A QUANTIDADE [ 25 ITENS ] DE ITENT_PRO/PRODUTO PERTENCE AS 13 ORD_COM DA SOL_COM EXPLORADA



-- VDIC_ESTOQUE_PRODUTO
SELECT 
    EST_PRO.CD_ESTOQUE                 COD_ESTOQUE,
    EST_PRO.CD_PRODUTO                 COD_PRODUTO,
    EST_PRO.DS_LOCALIZACAO_PRATELEIRA  DESC_LOCALIZACAO,
    EST_PRO.QT_ESTOQUE_ATUAL           QUANT_ESTOQUE_ATUAL,
    EST_PRO.QT_ESTOQUE_MAXIMO          QUANT_ESTOQUE_MAXIMO,
    EST_PRO.QT_ESTOQUE_MINIMO          QUANT_ESTOQUE_MINIMO,
    EST_PRO.QT_ESTOQUE_VIRTUAL         QUANT_ESTOQUE_VIRTUAL,
    EST_PRO.QT_PONTO_DE_PEDIDO         QUANT_PONTO_DE_PEDIDO,
    EST_PRO.QT_CONSUMO_MES             QUANT_CONSUMO_MES,
    EST_PRO.QT_SOLICITACAO_DE_COMPRA   QUANT_SOLICITACAO_DE_COMPRA,
    EST_PRO.QT_ORDEM_DE_COMPRA         QUANT_ORDEM_DE_COMPRA,
    EST_PRO.DT_ULTIMA_MOVIMENTACAO     DATA_ULTIMA_MOVIMENTACAO,
    EST_PRO.TP_CLASSIFICACAO_ABC       TIPO_CLASSIFICACAO_ABC,
    EST_PRO.QT_ESTOQUE_DOADO           QUANT_ESTOQUE_DOADO,
    EST_PRO.QT_ESTOQUE_RESERVADO       QUANT_ESTOQUE_RESERVADO,
    EST_PRO.CD_LOCALIZACAO             COD_LOCALIZACAO,
    EST_PRO.QT_CONSUMO_ATUAL           QUANT_CONSUMO_ATUAL
FROM 
    DBAMV.EST_PRO , DBAMV.ESTOQUE
WHERE 
    EST_PRO.CD_ESTOQUE = ESTOQUE.CD_ESTOQUE 
    AND EST_PRO.CD_PRODUTO = 14142
;



SELECT
    CD_PRODUTO
    , CD_ESPECIE
    , DT_CADASTRO
    , DT_ULTIMA_ENTRADA
    , HR_ULTIMA_ENTRADA
    , QT_ESTOQUE_ATUAL -- N CONFIAR NESSE CAMPO ELE N APRESENTOU RESULTADOS CONSISTENTES COM AS TELAS DO SISTEMA, PEGAR DA "EST_PRO"
    , QT_ULTIMA_ENTRADA
    , VL_ULTIMA_ENTRADA
    , VL_CUSTO_MEDIO
    , VL_ULTIMA_CUSTO_REAL
    , DS_PRODUTO
    , DS_PRODUTO_RESUMIDO
FROM DBAMV.PRODUTO 
WHERE CD_PRODUTO = 14045
;






-- 19802 [ N ESTAVA NA SOLICITAÇÃO ORIGINAL - PORÉM FOI INCLUÍDO EM OUTUBRO ] 
-- 19838, 19872 e 13383 [ OS 3 FORAM INCLUÍDOS EM NOVEMBRO ] - [ 13383 REPETIDO - 1 FOI CANCELADO ]
WITH 
    itrod AS (
    SELECT -- 29 -> 
        oc.CD_SOL_COM
        , ip.CD_PRODUTO AS prod
    FROM DBAMV.ITORD_PRO ip
    LEFT JOIN DBAMV.ORD_COM oc ON ip.CD_ORD_COM = oc.CD_ORD_COM
    WHERE oc.CD_SOL_COM = 3337
),
itsol AS (
    SELECT -- 25
        sc.CD_SOL_COM
        , ic.CD_PRODUTO AS prod
    FROM DBAMV.ITSOL_COM ic
    LEFT JOIN DBAMV.SOL_COM sc ON ic.CD_SOL_COM = sc.CD_SOL_COM
    WHERE sc.CD_SOL_COM = 3337
)
SELECT prod FROM itrod
MINUS
SELECT prod FROM itsol
;


SELECT -- 29 -> 19802 , 19838, 19872 e 13383 REPETIDO
    oc.CD_SOL_COM
    , oc.CD_ORD_COM
    , oc.DT_ORD_COM
    , ip.CD_PRODUTO AS prod
FROM DBAMV.ITORD_PRO ip
LEFT JOIN DBAMV.ORD_COM oc ON ip.CD_ORD_COM = oc.CD_ORD_COM
WHERE oc.CD_SOL_COM = 3337 AND ip.CD_PRODUTO IN(19802 , 19838, 19872)
;

SELECT -- 29 -> 19802 , 19838, 19872 e 13383 REPETIDO
    oc.CD_SOL_COM
    , oc.CD_ORD_COM
    , oc.DT_ORD_COM
    , oc.DT_CANCELAMENTO
    , ip.CD_PRODUTO AS prod
FROM DBAMV.ITORD_PRO ip
LEFT JOIN DBAMV.ORD_COM oc ON ip.CD_ORD_COM = oc.CD_ORD_COM
WHERE oc.CD_SOL_COM = 3337 --AND oc.CD_ORD_COM IN(5507, 5696, 5695)
;



    -- ITSOL_COM:
        -- qt_solic
        -- qt_comprada
        -- qt_atendida

    -- ITORD_PRO:
        -- qt_comprada
        -- qt_atendida
        -- qt_recebida
        -- qt_cancelada
WITH 
    itrod AS (
    SELECT -- 29 -> 
        oc.CD_SOL_COM
        , ip.CD_PRODUTO AS prod
        , ip.qt_comprada
        , ip.qt_atendida
        , ip.qt_recebida
        , ip.qt_cancelada
    FROM DBAMV.ITORD_PRO ip
    LEFT JOIN DBAMV.ORD_COM oc ON ip.CD_ORD_COM = oc.CD_ORD_COM
    WHERE oc.CD_SOL_COM = 3337
),
itsol AS (
    SELECT -- 25
        sc.CD_SOL_COM
        , ic.CD_PRODUTO AS prod
        , ic.qt_solic
        , ic.qt_comprada
        , ic.qt_atendida
    FROM DBAMV.ITSOL_COM ic
    LEFT JOIN DBAMV.SOL_COM sc ON ic.CD_SOL_COM = sc.CD_SOL_COM
    WHERE sc.CD_SOL_COM = 3337
)
SELECT prod FROM itrod
MINUS
SELECT prod FROM itsol
;




/* ----------------------------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------------------------- */



/* ----------------------------------------------------------- */
/* ---------------- SOL_COM 1:* ORD_COM ---------------------- */
-- 1 SOLICITACAO_COMPRA 
SELECT 
    COUNT(*)
FROM DBAMV.SOL_COM sc
WHERE sc.CD_SOL_COM = 3337
;


-- A SOLICITACAO_COMRPA "3337" TEM 13 ORDEM_COMPRA
SELECT 
    COUNT(*)
FROM DBAMV.ORD_COM oc
WHERE oc.CD_SOL_COM = 3337
;


/* ----------------------------------------------------------- */
/* -------------- ORD_COM 1:* ITORD_PRO ---------------------- */
-- 1 REGISTRO
SELECT 
    COUNT(*)
FROM DBAMV.ORD_COM oc
WHERE oc.CD_ORD_COM = 5542
;

-- 9 REGISTROS
SELECT 
    COUNT(*)
FROM DBAMV.ITORD_PRO itpr
WHERE itpr.CD_ORD_COM = 5542
;

    /* -------------- ORD_COM 1:* ITORD_PRO ---------------------- */

    -- A SOLICITACAO_COMRPA "3337" TEM 13 ORDEM_COMPRA
    -- UMA DESSAS ORDENS_COMPRA TEM 9 itpr
        -- A CD_ORD_COM=5542 TEM 9 ITPR
    SELECT 
        oc.CD_ORD_COM
        , COUNT(itpr.CD_ORD_COM) AS qtd_itpr
    FROM DBAMV.ITORD_PRO itpr
    LEFT JOIN DBAMV.ORD_COM oc ON itpr.CD_ORD_COM = oc.CD_ORD_COM
    WHERE oc.CD_SOL_COM = 3337
    GROUP BY oc.CD_ORD_COM
    ;


    /* -------------- ITORD_PRO 1:1 PRODUTO  ---------------------- */

    -- AS TABELAS TEM A SEGUINTE RELACAO ITORD_PRO 1:1 PRODUTO
        -- LEITURAS DA RELACAO:
            -- A ORDEM_COMPRA 5542 TEM 9 ITORD_PRO
            -- A ORDEM_COMPRA 5542 TEM 9 PRODUTOS

    -- A ORDEM_COMPRA 5542 TEM 9 ITORD_PRO
    SELECT
        itpr.CD_ORD_COM
        , p.CD_PRODUTO
    FROM DBAMV.ITORD_PRO itpr
    LEFT JOIN DBAMV.PRODUTO p ON itpr.CD_PRODUTO = p.CD_PRODUTO
    WHERE itpr.CD_ORD_COM = 5542
    ;

    -- A ORDEM_COMPRA 5542 TEM 9 PRODUTOS
    SELECT 
        itpr.CD_ORD_COM
        , COUNT(p.CD_PRODUTO) AS qtd_produto
    FROM DBAMV.ITORD_PRO itpr
    LEFT JOIN DBAMV.ORD_COM oc ON itpr.CD_ORD_COM = oc.CD_ORD_COM
    LEFT JOIN DBAMV.PRODUTO p ON itpr.CD_PRODUTO = p.CD_PRODUTO
    WHERE oc.CD_SOL_COM = 3337
    GROUP BY itpr.CD_ORD_COM 
    ;


/* ----------------------------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------------------------- */

/* ----------------------------------------------------------- */
/* -------------- SOL_COM 1:* ITSOL_COM ---------------------- */
-- 1 REGISTRO
SELECT 
    COUNT(*)
FROM DBAMV.SOL_COM sc
WHERE sc.CD_SOL_COM = 3337
;

-- 25 ITSOL_COM RELACIONADOS A CD_SOL_COM = 3337
SELECT 
    COUNT(*)
FROM DBAMV.ITSOL_COM ic
WHERE ic.CD_SOL_COM = 3337
;

-- RELACAO DOS 25 ITENS RELACIONADOS À CD_SOL_COM = 3337 NA ITSOL_COM
SELECT 
    ic.CD_SOL_COM
    , ic.CD_PRODUTO
FROM DBAMV.ITSOL_COM ic
WHERE ic.CD_SOL_COM = 3337
;


    /* -------------- ITSOL_COM 1:1 PRODUTO ---------------------- */

    -- AS TABELAS TEM A SEGUINTE RELACAO ITSOL_COM 1:1 PRODUTO
        -- LEITURAS DA RELACAO:
            -- A SOLICITACAO_COMPRA 3337 TEM 25 ITSOL_COM
            -- A SOLICITACAO_COMPRA 3337 TEM 25 PRODUTOS

    -- 25 ITSOL_COM RELACIONADOS A CD_SOL_COM = 3337
    SELECT 
        COUNT(p.CD_PRODUTO)
    FROM DBAMV.ITSOL_COM ic
    LEFT JOIN DBAMV.PRODUTO p ON ic.CD_PRODUTO = p.CD_PRODUTO
    WHERE ic.CD_SOL_COM = 3337
    ;

    -- RELACAO DOS 25 ITENS RELACIONADOS À CD_SOL_COM = 3337 NA PRODUTO
    SELECT 
        ic.CD_SOL_COM
        , p.CD_PRODUTO
    FROM DBAMV.ITSOL_COM ic
    LEFT JOIN DBAMV.PRODUTO p ON ic.CD_PRODUTO = p.CD_PRODUTO
    WHERE ic.CD_SOL_COM = 3337
    ;


/* ----------------------------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------------------------- */

/* ----------------------------------------------------------- */
/* --------------- ORD_COM 1:* ENT_PRO ----------------------- */

 -- 4 CD_ENT_PRO/NR_DOCUMENTO RELACIONADOS A ORDEM_COMPRA = 5542
    -- 1 DOCUMENTO E CONSIDERADA UMA ENTRADA NA TABELA "ENT_PRO"
SELECT 
    oc.CD_ORD_COM
    , COUNT(ep.CD_ENT_PRO) AS qtd_ent_pro
FROM DBAMV.ORD_COM oc
LEFT JOIN DBAMV.ENT_PRO ep ON oc.CD_ORD_COM = ep.CD_ORD_COM
WHERE oc.CD_ORD_COM = 5542
GROUP BY oc.CD_ORD_COM
;


    -- A RELACAO DAS 4 ENTRADAS RELACIONADAS A ORDEM_COMPRA "5542"
    SELECT 
        oc.CD_ORD_COM
        , ep.CD_ENT_PRO
    FROM DBAMV.ORD_COM oc
    LEFT JOIN DBAMV.ENT_PRO ep ON oc.CD_ORD_COM = ep.CD_ORD_COM
    WHERE oc.CD_ORD_COM = 5542
    ;

    -- UM DESSAS ENTRADAS, A ENTRADA "25041" TEM 3 ITENS DE ENTRADAS NA ITENT_PRO
    SELECT 
        ep.CD_ORD_COM
        , ip.CD_ITENT_PRO
    FROM ITENT_PRO ip
    LEFT JOIN DBAMV.ENT_PRO ep ON ip.CD_ENT_PRO = ep.CD_ENT_PRO
    WHERE ep.CD_ENT_PRO = 25041
    ;

    -- UM DESSAS ENTRADAS, A ENTRADA "25041" TEM 3 PRODUTOS
    SELECT
        ip.CD_ITENT_PRO
        , p.CD_PRODUTO
    FROM DBAMV.ITENT_PRO ip
    LEFT JOIN DBAMV.PRODUTO p ON ip.CD_PRODUTO = p.CD_PRODUTO
    WHERE ip.CD_ENT_PRO = 25041
    ;

/* ----------------------------------------------------------- */
/* ----------------------------------------------------------- */

-- 15 ITENS DE ENTRADA RELACIONADO A CD_ORD_COM = 5542
SELECT
    ep.CD_ORD_COM
    , COUNT(ip.CD_ITENT_PRO)
FROM DBAMV.ITENT_PRO ip
LEFT JOIN DBAMV.ENT_PRO ep ON ip.CD_ENT_PRO = ep.CD_ENT_PRO
LEFT JOIN DBAMV.PRODUTO p ON ip.CD_PRODUTO = p.CD_PRODUTO
WHERE ep.CD_ORD_COM = 5542 --AND ip.CD_ENT_PRO = 25041
GROUP BY ep.CD_ORD_COM
;

-- RELACAO DOS 15 ITENS DE ENTRADA RELACIONADO A CD_ORD_COM = 5542
SELECT
    ep.CD_ORD_COM
    , EP.NR_DOCUMENTO
    , ip.CD_ITENT_PRO
    , p.CD_PRODUTO
FROM DBAMV.ITENT_PRO ip
LEFT JOIN DBAMV.ENT_PRO ep ON ip.CD_ENT_PRO = ep.CD_ENT_PRO
LEFT JOIN DBAMV.PRODUTO p ON ip.CD_PRODUTO = p.CD_PRODUTO
WHERE ep.CD_ORD_COM = 5542 --AND ip.CD_ENT_PRO = 25041
;











-- ************************************************************************************************************************************************************* --
-- ************************************************************ DESNORMALIZAÇÃO - ESBOLÇO ********************************************************************** --

-- REORGANIZACAO das junções
SELECT DISTINCT 
	   io.cd_ord_com, 
       p.cd_produto,
       INITCAP(p.ds_produto) AS ds_produto,
       p.cd_especie,
       INITCAP(es.ds_especie) AS ds_especie,
       sc.cd_sol_com,
       sc.dt_sol_com,
       ip.dt_gravacao as dt_entrada,
       ic.dt_cancel,
       ic.qt_solic,    -- ic.
       io.qt_comprada, -- ic.
       ip.qt_entrada,
       ip.qt_atendida, -- ic.
       io.vl_unitario,
       sc.vl_total,
       sc.cd_estoque,
       INITCAP(e.ds_estoque) AS ds_estoque,
       ep.cd_fornecedor,
       INITCAP(f.nm_fornecedor) AS nm_fornecedor,
       sc.cd_setor,
       INITCAP(s.nm_setor) AS nm_setor,
       DECODE(sc.tp_situacao, 'A', 'Aberta', 'F', 'Fechada', 'P', 'Parcialmente Atendida', 'S', 'Solicitada', 'C', 'Cancelada') AS tp_situacao,
       DECODE(oc.tp_situacao, 'A', 'Aberta', 'U', 'Autorizada', 'N', 'Não Autorizada', 'P', 'Pendente', 'L', 'Parcialmente Atendida', 'T', 'Atendida', 'C', 'Cancelada', 'D', 'Adjudicação', 'O', 'Aguard. Próximo Nível') AS tp_situacao_ordem_comp, 
       INITCAP(sc.nm_solicitante) as nm_solicitante
FROM sol_com sc 
LEFT JOIN ord_com oc ON sc.cd_sol_com = oc.cd_sol_com 
LEFT JOIN ITORD_PRO io ON oc.cd_ord_com = io.cd_ord_com
LEFT JOIN produto p ON p.cd_produto = io.cd_produto
LEFT JOIN itsol_com ic ON ic.cd_sol_com = sc.cd_sol_com AND ic.cd_produto = p.cd_produto
LEFT JOIN especie es ON es.cd_especie = p.cd_especie
LEFT JOIN ent_pro ep ON ep.cd_ord_com = oc.cd_ord_com
LEFT JOIN itent_pro ip ON ip.cd_ent_pro = ep.cd_ent_pro AND p.cd_produto = ip.cd_produto
LEFT JOIN fornecedor f ON f.cd_fornecedor = ep.cd_fornecedor
LEFT JOIN setor s ON s.cd_setor = sc.cd_setor
LEFT JOIN estoque e ON e.cd_estoque = sc.cd_estoque
WHERE ic.qt_solic IS NOT NULL AND ip.dt_gravacao IS NOT NULL AND sc.CD_SOL_COM = '2518' ;








	