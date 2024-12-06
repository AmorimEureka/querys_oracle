
WITH TESIO AS (
    SELECT CD_ESPECIE,
        DS_ESPECIE,
        CD_PRODUTO,
        DS_PRODUTO,
        DS_UNIDADE,
        Nvl( QT_ESTOQUE_ATUAL, 0 ) QT_ESTOQUE_ATUAL,
        Nvl( qt_ordem_de_compra, 0 ) qt_ordem_de_compra,
        Nvl( qt_solicitacao_compra, 0 ) qt_solicitacao_compra,
        Nvl( QT_MVTO, 0 ) QT_MVTO_90,
        Nvl( QT_MVTO / 3, 0 )  QT_MENSAL,
        Nvl( QT_MVTO / 90, 0 ) QT_DIARIO,
        ROUND( QT_ESTOQUE_aTUAL / ( QT_MVTO / 90 ), 0 ) QTD_DIAS_ESTOQUE
    FROM ( 
            SELECT 
                especie.cd_especie
                , especie.ds_especie 
                , Produto.cd_Produto
                , Produto.Ds_produto
                , verif_ds_unid_prod( produto.cd_produto , 'G' ) ds_unidade
                , Sum( est_pro.qt_ordem_de_compra / verif_vl_Fator_prod( produto.cd_produto, 'G' ) )  qt_ordem_de_compra
                , Sum( est_pro.qt_solicitacao_de_compra / verif_vl_Fator_prod( produto.cd_produto, 'G' ) ) qt_solicitacao_compra
                , Sum( est_pro.qt_estoque_atual / verif_vl_Fator_prod( produto.cd_produto, 'G' ) ) qt_estoque_atual
                , ( 
                        SELECT 
                            Sum( ITMVTO_ESTOQUE.QT_MOVIMENTACAO * UNI_PRO.VL_FATOR * Decode( MVTO_ESTOQUE.TP_MVTO_ESTOQUE, 'D', -1, 'C', -1, 1 ) )
                        FROM 
                            DBAMV.MVTO_ESTOQUE
                            , DBAMV.ITMVTO_eSTOQUE 
                            , DBAMV.UNI_PRO 
                        WHERE 
                            MVTO_eSTOQUE.CD_MVTO_eSTOQUE = ITMVTO_ESTOQUE.CD_MVTO_ESTOQUE
                            AND ITMVTO_eSTOQUE.CD_PRODUTO = PRODUTO.CD_PRODUTO
                            AND ITMVTO_eSTOQUE.CD_UNI_PRO = UNI_PRO.CD_UNI_PRO 
                            AND MVTO_ESTOQUE.CD_eSTOQUE IN ( 1, 2 )
                            AND MVTO_ESTOQUE.TP_MVTO_ESTOQUE IN ( 'S', 'P', 'D', 'C' )
                            AND MVTO_ESTOQUE.DT_MVTO_ESTOQUE BETWEEN NVL( To_Date( :DT_FIM, 'DD/MM/YYYY' ), TRUNC(SYSDATE - 90) ) AND NVL( To_Date( :DT_FIM, 'DD/MM/YYYY' ) , TRUNC(SYSDATE) + 0.99999 ) -- LINHA DE TESTE
                            -- AND MVTO_ESTOQUE.DT_MVTO_ESTOQUE BETWEEN NVL( $pgmvDataIni$, TRUNC(SYSDATE - 90) ) AND NVL( $pgmvDataFim$ , TRUNC(SYSDATE - 90) + 0.99999 ) --LINHA RELATORIO PARA COLOCAR NO RELATORIO DE INDICADORES
                            -- AND MVTO_ESTOQUE.DT_MVTO_ESTOQUE BETWEEN To_Date( '01/08/2024', 'DD/MM/YYYY' ) AND To_Date( '01/10/2024', 'DD/MM/YYYY' ) -- LINHA DA TASCOM
                        ) / verif_vl_Fator_prod( produto.cd_produto, 'G' ) QT_MVTO
            FROM 
                Dbamv.Produto 
                , Dbamv.Est_Pro
                , Dbamv.especie
            WHERE
                Produto.cd_Produto = Est_pro.cd_produto 
                AND est_pro.cd_estoque IN ( 1, 2 )
                AND especie.cd_especie = produto.cd_especie  
                AND PRODUTO.cd_especie = 2
            GROUP BY 
                Especie.cd_especie
                , Especie.ds_especie
                , Produto.cd_Produto
                , Produto.Ds_produto
    )
)
SELECT COUNT(*) FROM TESIO
;




SELECT CD_ESPECIE,
       DS_ESPECIE,
       CD_PRODUTO,
       DS_PRODUTO,
       DS_UNIDADE,
       NVL(QT_ESTOQUE_ATUAL, 0) QT_ESTOQUE_ATUAL,
       NVL(QT_ORDEM_DE_COMPRA, 0) QT_ORDEM_DE_COMPRA,
       NVL(QT_SOLICITACAO_COMPRA, 0) QT_SOLICITACAO_COMPRA,
       NVL(QT_MVTO, 0) QT_MVTO_90,
       ROUND(NVL(QT_MVTO / 3, 0),2) QT_MENSAL,
       ROUND(NVL(QT_MVTO / 90, 0),2) AS QT_DIARIO,
CASE
    WHEN QT_MVTO <= 0 THEN 99
    ELSE ROUND(QT_ESTOQUE_ATUAL / (QT_MVTO / 90), 0)
END AS QTD_DIAS_ESTOQUE
      -- ROUND(QT_ESTOQUE_ATUAL / (QT_MVTO / 90), 0) QTD_DIAS_ESTOQUE
FROM (
    SELECT especie.cd_especie,
           especie.ds_especie,
           produto.cd_produto,
           produto.ds_produto,
           verif_ds_unid_prod(produto.cd_produto, 'G') ds_unidade,
           SUM(est_pro.qt_ordem_de_compra / verif_vl_fator_prod(produto.cd_produto, 'G')) qt_ordem_de_compra,
           SUM(est_pro.qt_solicitacao_de_compra / verif_vl_fator_prod(produto.cd_produto, 'G')) qt_solicitacao_compra,
           SUM(est_pro.qt_estoque_atual / verif_vl_fator_prod(produto.cd_produto, 'G')) qt_estoque_atual,
           (
               SELECT SUM(
                          itmvto_estoque.qt_movimentacao * uni_pro.vl_fator *
                          DECODE(mvto_estoque.tp_mvto_estoque, 'D', -1, 'C', -1, 1)
                      )
               FROM dbamv.mvto_estoque,
                    dbamv.itmvto_estoque,
                    dbamv.uni_pro
               WHERE mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
                 AND itmvto_estoque.cd_produto = produto.cd_produto
                 AND itmvto_estoque.cd_uni_pro = uni_pro.cd_uni_pro
                 AND mvto_estoque.tp_mvto_estoque IN ('S', 'P', 'D', 'C')
                 AND MVTO_ESTOQUE.DT_MVTO_ESTOQUE BETWEEN NVL( TO_DATE(:pgmvDataFim, 'DD/MM/YYYY') , TRUNC(SYSDATE - 90) ) AND NVL( TO_DATE(:pgmvDataFim, 'DD/MM/YYYY') , TRUNC(SYSDATE) + 0.99999 )
           ) / verif_vl_fator_prod(produto.cd_produto, 'G') qt_mvto
    FROM dbamv.produto,
         dbamv.est_pro,
         dbamv.especie
    WHERE produto.cd_produto = est_pro.cd_produto
      AND especie.cd_especie = produto.cd_especie
      AND produto.cd_especie = 2
    GROUP BY especie.cd_especie,
             especie.ds_especie,
             produto.cd_produto,
             produto.ds_produto
)
ORDER BY QTD_DIAS_ESTOQUE ASC ;