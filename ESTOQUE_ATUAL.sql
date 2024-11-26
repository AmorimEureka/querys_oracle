

WITH TESTE AS (
	SELECT
		p.cd_produto
		, INITCAP(p.ds_produto) ds_produto
		, INITCAP(es.ds_estoque) ds_estoque
		, up.vl_fator
		, (NVL(ep.qt_estoque_atual, 0))/(MAX(up.vl_fator)) qt_estoque_atual
		, (NVL(ep.qt_solicitacao_de_compra, 0))/(MAX(up.vl_fator)) qt_solicitacao_de_compra
		, (NVL(ep.qt_ordem_de_compra, 0))/(MAX(up.vl_fator)) qt_ordem_de_compra
		, ep.dt_ultima_movimentacao
		, (NVL(ep.qt_consumo_atual, 0))/(MAX(up.vl_fator)) qt_consumo_atual
	FROM
		EST_PRO ep
	LEFT JOIN estoque es ON
		es.cd_estoque = ep.cd_estoque
	LEFT JOIN produto p ON
		p.cd_produto = ep.cd_produto
	LEFT JOIN uni_pro up ON
		p.cd_produto = up.cd_produto
	GROUP BY
		p.cd_produto
		, p.ds_produto
		, es.ds_estoque
		, up.vl_fator
		, ep.qt_estoque_atual
		, ep.qt_solicitacao_de_compra
		, ep.qt_ordem_de_compra
		, ep.dt_ultima_movimentacao
		, ep.qt_consumo_atual
)
SELECT * FROM TESTE WHERE ds_estoque = 'Farmacia' ;




SELECT * FROM DBAMV.SOL_COM_RELATORIO_SCCOM;