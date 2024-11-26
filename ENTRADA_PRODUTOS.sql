



SELECT  ITENT_PRO.CD_PRODUTO                                     CD_PRODUTO,
        INITCAP(PRODUTO.DS_PRODUTO)                              DS_PRODUTO,
        CUSTO_MEDIO.VL_CUSTO_MEDIO                               VL_CUSTO_MEDIO,
        /*NVL(
            NVL(
                NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                ),
            0
            )                                                    VL_CUSTO_MEDIO,*/
        INITCAP(UNI_PRO.DS_UNIDADE)                              DS_UNIDADE,
        ITENT_PRO.QT_ENTRADA                                     QUANTIDADE,
        TRUNC(ENT_PRO.DT_ENTRADA)                                DT_GERACAO,
        to_char(ENT_PRO.HR_ENTRADA,'hh24:mi:ss')                 HORA,
        ENT_PRO.CD_ENT_PRO                                       DOCUMENTO,
        INITCAP( FORNEC.NM_FORNECEDOR )                          DS_DESTINO,
        INITCAP(TIP_DOC.DS_TIP_DOC)                              OPERACAO,
        ENT_PRO.NR_DOCUMENTO                                     NR_NOTA_FISCAL,
        itent_pro.vl_custo_real   / uni_pro.vl_fator             VALOR,
        ESTOQUE.CD_ESTOQUE                                       CD_ESTOQUE,
        INITCAP(ESTOQUE.DS_ESTOQUE)                              DS_ESTOQUE,
        UNI_PRO.VL_FATOR                                         VL_FATOR,
        '2'                                                      TP_ORDEM,
	    ENT_PRO.SN_CONSIGNADO			                         SN_CONSIGNADO,
        0                                                        cd_itmvto_estoque
FROM    
    dbamv.ITENT_PRO                   ITENT_PRO,
    dbamv.ENT_PRO                     ENT_PRO,
    dbamv.PRODUTO                     PRODUTO,
    dbamv.TIP_DOC                     TIP_DOC,
    dbamv.UNI_PRO                     UNI_PRO,
    dbamv.FORNECEDOR                  FORNEC,
    dbamv.ESTOQUE                     ESTOQUE,
    dbamv.VALOR_INICIAL_PRODUTO       VALOR_INICIAL_PRODUTO,
    dbamv.CUSTO_MEDIO                 CUSTO_MEDIO
WHERE 
    ITENT_PRO.CD_PRODUTO      =   PRODUTO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO    = valor_inicial_produto.CD_PRODUTO
    AND ITENT_PRO.CD_ENT_PRO  =   ENT_PRO.CD_ENT_PRO
    AND ENT_PRO.CD_TIP_DOC    =   TIP_DOC.CD_TIP_DOC
    AND ITENT_PRO.CD_UNI_PRO  =   UNI_PRO.CD_UNI_PRO
    AND ENT_PRO.CD_FORNECEDOR =   FORNEC.CD_FORNECEDOR(+)
    AND ITENT_PRO.CD_UNI_PRO  =   UNI_PRO.CD_UNI_PRO
    AND ENT_PRO.CD_ESTOQUE    =  ESTOQUE.CD_ESTOQUE
    AND CUSTO_MEDIO.CD_CUSTO_MEDIO = ITENT_PRO.CD_CUSTO_MEDIO
   -- AND Estoque.Cd_Multi_Empresa = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
GROUP BY 
	ITENT_PRO.CD_PRODUTO,
	PRODUTO.DS_PRODUTO,
	CUSTO_MEDIO.VL_CUSTO_MEDIO,
	ITENT_PRO.VL_UNITARIO,
	VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
	UNI_PRO.DS_UNIDADE,
	ITENT_PRO.QT_ENTRADA,
	ENT_PRO.DT_ENTRADA,
	ENT_PRO.HR_ENTRADA,
	ENT_PRO.CD_ENT_PRO,
	FORNEC.NM_FORNECEDOR,
	TIP_DOC.DS_TIP_DOC,
	ITENT_PRO.VL_CUSTO_REAL,
	UNI_PRO.VL_FATOR,
	ESTOQUE.CD_ESTOQUE,
	ESTOQUE.DS_ESTOQUE,
	ENT_PRO.SN_CONSIGNADO,
    ENT_PRO.NR_DOCUMENTO