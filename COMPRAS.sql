



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








	