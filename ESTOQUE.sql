

/* *************************** QUERY ORIGINAL 'ESTOQUE' - PAINEL HPC-COMPRAS-Estoque e Movimentação ***************************
 * 
 * 
 * 
 * 
 * 
 * 
 * */

WITH TESTE1 AS (
	SELECT 
	    ITCONTAGEM.CD_PRODUTO                                                       CD_PRODUTO,
	    INITCAP(PRODUTO.DS_PRODUTO)                                                 DS_PRODUTO,
	    NVL(
	        NVL(
	            NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
	            VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
	            ),
	        0
	        )                                                                       VL_CUSTO_MEDIO,
	    INITCAP(UNI_PRO.DS_UNIDADE)                                                 DS_UNIDADE,
	    sum( NVL(ITCONTAGEM.QT_ESTOQUE,0) + NVL( ITCONTAGEM.QT_ESTOQUE_DOADO,0))    QUANTIDADE,
	    TRUNC(CONTAGEM.DT_GERACAO)                                                  DT_GERACAO,
	    to_char(CONTAGEM.HR_GERACAO,'hh24:mi:ss')                                   HORA,
	    CONTAGEM.CD_CONTAGEM                                                        DOCUMENTO,
	    'Contagem - ' || INITCAP(ESTOQUE.DS_ESTOQUE)                                DS_DESTINO,
	    'Contagem'                                                                  OPERACAO,
	    0                                                                           VALOR,
	    ESTOQUE.CD_ESTOQUE                                                          CD_ESTOQUE,
	    INITCAP(ESTOQUE.DS_ESTOQUE)                                                 DS_ESTOQUE,
	    UNI_PRO.VL_FATOR                                                            VL_FATOR,
	    '1'                                                                         TP_ORDEM,
	    'N'                                                                         SN_CONSIGNADO,
	    0                                                                           cd_itmvto_estoque
	FROM    
	    dbamv.ITCONTAGEM            ITCONTAGEM,
	    dbamv.CONTAGEM              CONTAGEM,
	    dbamv.PRODUTO               PRODUTO,
	    dbamv.UNI_PRO               UNI_PRO,
	    dbamv.ESTOQUE               ESTOQUE,
	    dbamv.ITENT_PRO             ITENT_PRO,
	    dbamv.VALOR_INICIAL_PRODUTO VALOR_INICIAL_PRODUTO
	WHERE 
	    ITCONTAGEM.CD_PRODUTO       = PRODUTO.CD_PRODUTO
	    AND PRODUTO.CD_PRODUTO       = ITENT_PRO.CD_PRODUTO
	    AND PRODUTO.CD_PRODUTO       = valor_inicial_produto.CD_PRODUTO
	    AND  ITCONTAGEM.CD_CONTAGEM = CONTAGEM.CD_CONTAGEM
	    AND  ITCONTAGEM.CD_UNI_PRO  = UNI_PRO.CD_UNI_PRO
	    AND CONTAGEM.CD_ESTOQUE     = ESTOQUE.CD_ESTOQUE
	    --AND  Estoque.Cd_Multi_Empresa = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
	GROUP BY
	    ITCONTAGEM.CD_PRODUTO,
	    PRODUTO.DS_PRODUTO,
	    PRODUTO.VL_CUSTO_MEDIO,
	    ITENT_PRO.VL_UNITARIO,
	    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
	    UNI_PRO.DS_UNIDADE,
	    CONTAGEM.DT_GERACAO,
	    CONTAGEM.HR_GERACAO,
	    CONTAGEM.CD_CONTAGEM,
	    ESTOQUE.CD_ESTOQUE,
	    ESTOQUE.DS_ESTOQUE,
	    UNI_PRO.VL_FATOR
),
TESTE2 AS (
	SELECT  -- FINAL
	    ITMVTO_ESTOQUE.CD_PRODUTO                           CD_PRODUTO,
	    INITCAP(PRODUTO.DS_PRODUTO)                         DS_PRODUTO,
	    NVL(
	        NVL(
	            NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
	            VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
	            ),
	        0
	        )                                               VL_CUSTO_MEDIO,
	    INITCAP(UNI_PRO.DS_UNIDADE)                         DS_UNIDADE,
	    DECODE(
	        MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
	        'D', ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
	        'C' , ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
	        ITMVTO_ESTOQUE.QT_MOVIMENTACAO * -1)            QUANTIDADE,
	    TRUNC(MVTO_ESTOQUE.DT_MVTO_ESTOQUE)                 DT_GERACAO,
	    TO_CHAR(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss') HORA,
	    MVTO_ESTOQUE.CD_MVTO_ESTOQUE                        DOCUMENTO,
	    INITCAP(INITCAP(
	        NVL( 
	            PACIENTE.NM_PACIENTE,
	            DECODE( 
	                MVTO_ESTOQUE.TP_MVTO_ESTOQUE, 
	                'T', ESTOQUE_DESTINO.DS_ESTOQUE,
	                'E',FORNECEDOR.NM_FORNECEDOR, 
	                SETOR.NM_SETOR
	                )
	            )
	        ))                                              DS_DESTINO,
	    INITCAP( 
	        DECODE(
	            MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
	            'X', 'BAIXA DE PRODUTOS',
	            'S', 'SAIDA SETOR',
	            'P', 'SAIDA PACIENTE',
	            'D', 'DEVOL. DE SETOR',
	            'C', 'DEVOL. DE PACIENTE',
	            'T', 'TRANSF. DE ESTOQUE',
	            'M', 'MANIPUL.  PRODUTOS',
	            'O', 'DOAÇÃO  PRODUTOS',
	            'E', 'SAIDA DE EMPRESTIMO',
	            'V', 'VENDA DE PRODUTOS' ,
	            'N','DEVOLUCAO DE VENDAS'
	            )
	        )                                               OPERACAO,
	    0                                                   VALOR,
	    ESTOQUE.CD_ESTOQUE                                  CD_ESTOQUE,
	    INITCAP(ESTOQUE.DS_ESTOQUE)                         DS_ESTOQUE,
	    UNI_PRO.VL_FATOR                                    VL_FATOR,
	    '3'                                                 TP_ORDEM,
	    'N'                                                 SN_CONSIGNADO,
	    0                                                   cd_itmvto_estoque
	FROM 
	    dbamv.MVTO_ESTOQUE                                  MVTO_ESTOQUE,
	    dbamv.ITMVTO_ESTOQUE                                ITMVTO_ESTOQUE,
	    dbamv.PRODUTO                                       PRODUTO,
	    dbamv.UNI_PRO                                       UNI_PRO,
	    dbamv.ATENDIME                                      ATENDIMENTO,
	    dbamv.PACIENTE                                      PACIENTE,
	    dbamv.SETOR                                         SETOR,
	    dbamv.ESTOQUE                                       ESTOQUE,
	    dbamv.ESTOQUE                                       ESTOQUE_DESTINO,
	    dbamv.FORNECEDOR                                    FORNECEDOR,
	    dbamv.ITENT_PRO                                     ITENT_PRO,
	    dbamv.VALOR_INICIAL_PRODUTO                         VALOR_INICIAL_PRODUTO
	WHERE   
	    ITMVTO_ESTOQUE.CD_PRODUTO               = PRODUTO.CD_PRODUTO
	    AND PRODUTO.CD_PRODUTO                  = ITENT_PRO.CD_PRODUTO
	    AND PRODUTO.CD_PRODUTO                  = valor_inicial_produto.CD_PRODUTO
	    AND ITMVTO_ESTOQUE.CD_MVTO_ESTOQUE      = MVTO_ESTOQUE.CD_MVTO_ESTOQUE
	    AND ITMVTO_ESTOQUE.CD_UNI_PRO           = UNI_PRO.CD_UNI_PRO
	    AND MVTO_ESTOQUE.CD_ATENDIMENTO         = ATENDIMENTO.CD_ATENDIMENTO (+)
	    AND ATENDIMENTO.CD_PACIENTE             = PACIENTE.CD_PACIENTE (+)
	    AND MVTO_ESTOQUE.CD_SETOR               = SETOR.CD_SETOR(+)
	    AND MVTO_ESTOQUE.CD_ESTOQUE_DESTINO     =  ESTOQUE_DESTINO.CD_ESTOQUE(+)
	    AND ITMVTO_ESTOQUE.CD_UNI_PRO           =  UNI_PRO.CD_UNI_PRO
	    AND MVTO_ESTOQUE.CD_ESTOQUE             = ESTOQUE.CD_ESTOQUE
	    AND MVTO_ESTOQUE.CD_FORNECEDOR          = FORNECEDOR.CD_FORNECEDOR(+)
	            --AND Estoque.Cd_Multi_Empresa         = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
	            --and atendimento.cd_multi_empresa        = dbamv.Pkg_Mv2000.Le_Empresa
	GROUP BY 
	    ITMVTO_ESTOQUE.CD_PRODUTO,
	    PRODUTO.DS_PRODUTO,
	    PRODUTO.VL_CUSTO_MEDIO,
	    ITENT_PRO.VL_UNITARIO,
	    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
	    UNI_PRO.DS_UNIDADE,
	    MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
	    ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
	    MVTO_ESTOQUE.DT_MVTO_ESTOQUE,
	    MVTO_ESTOQUE.HR_MVTO_ESTOQUE,
	    MVTO_ESTOQUE.CD_MVTO_ESTOQUE,
	    PACIENTE.NM_PACIENTE,
	    ESTOQUE_DESTINO.DS_ESTOQUE,
	    FORNECEDOR.NM_FORNECEDOR,
	    SETOR.NM_SETOR,
	    ESTOQUE.CD_ESTOQUE,
	    ESTOQUE.DS_ESTOQUE,
	    UNI_PRO.VL_FATOR
),
TESTE3 AS (
	SELECT  ITENT_PRO.CD_PRODUTO                                     CD_PRODUTO,
	        INITCAP(PRODUTO.DS_PRODUTO)                              DS_PRODUTO,
	        NVL(
	            NVL(
	                NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
	                VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
	                ),
	            0
	            )                                                    VL_CUSTO_MEDIO,
	        INITCAP(UNI_PRO.DS_UNIDADE)                              DS_UNIDADE,
	        ITENT_PRO.QT_ENTRADA                                     QUANTIDADE,
	        TRUNC(ENT_PRO.DT_ENTRADA)                                DT_GERACAO,
	        to_char(ENT_PRO.HR_ENTRADA,'hh24:mi:ss')                 HORA,
	        ENT_PRO.CD_ENT_PRO                                       DOCUMENTO,
	        INITCAP( FORNEC.NM_FORNECEDOR )                          DS_DESTINO,
	        INITCAP(TIP_DOC.DS_TIP_DOC)                              OPERACAO,
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
	    dbamv.VALOR_INICIAL_PRODUTO       VALOR_INICIAL_PRODUTO
	WHERE 
	    ITENT_PRO.CD_PRODUTO      =   PRODUTO.CD_PRODUTO
	    AND PRODUTO.CD_PRODUTO    = valor_inicial_produto.CD_PRODUTO
	    AND ITENT_PRO.CD_ENT_PRO  =   ENT_PRO.CD_ENT_PRO
	    AND ENT_PRO.CD_TIP_DOC    =   TIP_DOC.CD_TIP_DOC
	    AND ITENT_PRO.CD_UNI_PRO  =   UNI_PRO.CD_UNI_PRO
	    AND ENT_PRO.CD_FORNECEDOR =   FORNEC.CD_FORNECEDOR(+)
	    AND ITENT_PRO.CD_UNI_PRO  =   UNI_PRO.CD_UNI_PRO
	    AND ENT_PRO.CD_ESTOQUE    =  ESTOQUE.CD_ESTOQUE
	   -- AND Estoque.Cd_Multi_Empresa = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
	GROUP BY 
		ITENT_PRO.CD_PRODUTO,
		PRODUTO.DS_PRODUTO,
		PRODUTO.VL_CUSTO_MEDIO,
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
		ENT_PRO.SN_CONSIGNADO
),
TESTE4 AS (
	SELECT 
	    ITMVTO_ESTOQUE.CD_PRODUTO                                      CD_PRODUTO,
	    INITCAP(PRODUTO.DS_PRODUTO)                                    DS_PRODUTO,
	    NVL(
	        NVL(
	            NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
	            VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
	            ),
	        0
	        )                                                          VL_CUSTO_MEDIO,
	    INITCAP(UNI_PRO.DS_UNIDADE)                                    DS_UNIDADE,
	    ITMVTO_ESTOQUE.QT_MOVIMENTACAO                                 QUANTIDADE,
	    TRUNC( MVTO_ESTOQUE.DT_MVTO_ESTOQUE)                           DT_GERACAO,
	    to_char(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss')            HORA,
	    MVTO_ESTOQUE.CD_MVTO_ESTOQUE                                   DOCUMENTO,
	    INITCAP( NVL( PACIENTE.NM_PACIENTE,
	    DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE, 'T', ESTOQUE_DESTINO.DS_ESTOQUE, SETOR.NM_SETOR ) ) ) DS_DESTINO,
	    INITCAP( DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE,'T', 'CRED. TRANSF. EST.' )  ) OPERACAO,
	    0                                                              VALOR,
	    ESTOQUE.CD_ESTOQUE                                             CD_ESTOQUE,
	    INITCAP(ESTOQUE.DS_ESTOQUE)                                    DS_ESTOQUE,
	    UNI_PRO.VL_FATOR                                               VL_FATOR,
	    '3'                                                            TP_ORDEM,
	    'N'	                                                          SN_CONSIGNADO,
	    itmvto_estoque.cd_itmvto_estoque                               cd_itmvto_estoque
	FROM    
	    dbamv.MVTO_ESTOQUE                            MVTO_ESTOQUE,
	    dbamv.ITMVTO_ESTOQUE                          ITMVTO_ESTOQUE,
	    dbamv.PRODUTO                                 PRODUTO,
	    dbamv.UNI_PRO                                 UNI_PRO,
	    dbamv.ATENDIME                                ATENDIMENTO,
	    dbamv.PACIENTE                                PACIENTE,
	    dbamv.SETOR                                   SETOR,
	    dbamv.ESTOQUE                                 ESTOQUE,
	    dbamv.ESTOQUE                                 ESTOQUE_DESTINO,
	    dbamv.ITENT_PRO                               ITENT_PRO,
	    dbamv.VALOR_INICIAL_PRODUTO                   VALOR_INICIAL_PRODUTO
	WHERE 
	    MVTO_ESTOQUE.TP_MVTO_ESTOQUE       = 'T'
	    AND ITMVTO_ESTOQUE.CD_PRODUTO      = PRODUTO.CD_PRODUTO
	    AND PRODUTO.CD_PRODUTO             = ITENT_PRO.CD_PRODUTO
	    AND PRODUTO.CD_PRODUTO             = valor_inicial_produto.CD_PRODUTO
	    AND ITMVTO_ESTOQUE.CD_MVTO_ESTOQUE = MVTO_ESTOQUE.CD_MVTO_ESTOQUE
	    AND ITMVTO_ESTOQUE.CD_UNI_PRO      = UNI_PRO.CD_UNI_PRO
	    AND MVTO_ESTOQUE.CD_ATENDIMENTO    = ATENDIMENTO.CD_ATENDIMENTO (+)
	    AND ATENDIMENTO.CD_PACIENTE        = PACIENTE.CD_PACIENTE (+)
	    AND MVTO_ESTOQUE.CD_SETOR          = SETOR.CD_SETOR(+)
	    AND MVTO_ESTOQUE.CD_ESTOQUE        = ESTOQUE_DESTINO.CD_ESTOQUE
	    AND ITMVTO_ESTOQUE.CD_UNI_PRO      = UNI_PRO.CD_UNI_PRO
	    AND ESTOQUE.CD_ESTOQUE             = MVTO_ESTOQUE.CD_ESTOQUE_DESTINO
	    -- AND Estoque.Cd_Multi_Empresa       = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
	    --and atendimento.cd_multi_empresa      = dbamv.Pkg_Mv2000.Le_Empresa
	GROUP BY
		ITMVTO_ESTOQUE.CD_PRODUTO,
		PRODUTO.DS_PRODUTO,
		PRODUTO.VL_CUSTO_MEDIO,
		ITENT_PRO.VL_UNITARIO,
		VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
		UNI_PRO.DS_UNIDADE,
		ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
		MVTO_ESTOQUE.DT_MVTO_ESTOQUE,
		MVTO_ESTOQUE.HR_MVTO_ESTOQUE,
		MVTO_ESTOQUE.CD_MVTO_ESTOQUE,
		PACIENTE.NM_PACIENTE,
		MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
		ESTOQUE_DESTINO.DS_ESTOQUE,
		SETOR.NM_SETOR,
		ESTOQUE.CD_ESTOQUE,
		ESTOQUE.DS_ESTOQUE,
		UNI_PRO.VL_FATOR,
		ITMVTO_ESTOQUE.CD_ITMVTO_ESTOQUE
),
TESTE5 AS (
		SELECT 
		    ITDEV_FOR.CD_PRODUTO,
		    INITCAP(PRODUTO.DS_PRODUTO)                 DS_PRODUTO,
		    NVL(
		        NVL(
		            NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
		            VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
		            ),
		        0
		        )                                        VL_CUSTO_MEDIO,
		    UNI_PRO.DS_UNIDADE,
		    ITDEV_FOR.QT_DEVOLVIDA * -1                  QUANTIDADE,
		    TRUNC(DEV_FOR.DT_DEVOLUCAO)                  DT_GERACAO,
		    TO_CHAR(DEV_FOR.HR_DEVOLUCAO, 'hh24:mi:ss' ) HORA,
		    DEV_FOR.CD_DEVOLUCAO                         DOCUMENTO,
		    INITCAP( FORNECEDOR.NM_FORNECEDOR )          DS_DESTINO,
		    'Dev. P/  Fornecedor'                        OPERACAO,
		    (itent_pro.vl_custo_real / uni_pro.vl_fator) VALOR,
		    ESTOQUE.CD_ESTOQUE                           CD_ESTOQUE,
		    INITCAP(ESTOQUE.DS_ESTOQUE)                  DS_ESTOQUE,
		    UNI_PRO.VL_FATOR                             VL_FATOR,
		    '4'                                          TP_ORDEM,
		    'N'							                 SN_CONSIGNADO,   -- PDA 51945
		    0                                            cd_itmvto_estoque
		FROM   
		    DBAMV.ESTOQUE               ESTOQUE,
		    DBAMV.DEV_FOR               DEV_FOR,
		    DBAMV.ITDEV_FOR             ITDEV_FOR,
		    DBAMV.UNI_PRO               UNI_PRO,
		    DBAMV.FORNECEDOR            FORNECEDOR,
		    DBAMV.PRODUTO               PRODUTO,
		    DBAMV.ENT_PRO               ENT_PRO,
		    dbamv.ITENT_PRO             ITENT_PRO,
		    dbamv.VALOR_INICIAL_PRODUTO VALOR_INICIAL_PRODUTO
		WHERE 
		    ITDEV_FOR.CD_DEVOLUCAO      = DEV_FOR.CD_DEVOLUCAO
		    AND ITDEV_FOR.CD_PRODUTO    = PRODUTO.CD_PRODUTO
		    AND PRODUTO.CD_PRODUTO      = ITENT_PRO.CD_PRODUTO
		    AND PRODUTO.CD_PRODUTO      = valor_inicial_produto.CD_PRODUTO
		    AND ITDEV_FOR.CD_UNI_PRO    = UNI_PRO.CD_UNI_PRO
		    AND DEV_FOR.CD_ENT_PRO      = ENT_PRO.CD_ENT_PRO
		    AND ENT_PRO.CD_FORNECEDOR   = FORNECEDOR.CD_FORNECEDOR
		    AND ENT_PRO.CD_ESTOQUE      = ESTOQUE.CD_ESTOQUE
		    and itdev_for.cd_itent_pro  = itent_pro.cd_itent_pro
		 -- and Estoque.Cd_Multi_Empresa = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
		GROUP BY
			ITDEV_FOR.CD_PRODUTO,
			PRODUTO.DS_PRODUTO,
			PRODUTO.VL_CUSTO_MEDIO,
			ITENT_PRO.VL_UNITARIO,
			VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
			UNI_PRO.DS_UNIDADE,
			ITDEV_FOR.QT_DEVOLVIDA,
			DEV_FOR.DT_DEVOLUCAO,
			DEV_FOR.HR_DEVOLUCAO,
			DEV_FOR.CD_DEVOLUCAO,
			FORNECEDOR.NM_FORNECEDOR,
			ITENT_PRO.VL_CUSTO_REAL,
			UNI_PRO.VL_FATOR,
			ESTOQUE.CD_ESTOQUE,
			ESTOQUE.DS_ESTOQUE  
		ORDER BY 
		    DT_GERACAO,  
		    HORA, 
		    DS_PRODUTO, 
		    5, 
		    6, 
		    TP_ORDEM, 
		    OPERACAO
)
SELECT DISTINCT DOCUMENTO FROM TESTE4 WHERE EXTRACT(MONTH FROM DT_GERACAO) IN(1,2,3,4,5,6,7,8,9) AND EXTRACT(YEAR FROM DT_GERACAO)= 2024 ;




SELECT 
    ITCONTAGEM.CD_PRODUTO                                                       CD_PRODUTO,
    INITCAP(PRODUTO.DS_PRODUTO)                                                 DS_PRODUTO,
    NVL(
        NVL(
            NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
            VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
            ),
        0
        )                                                                       VL_CUSTO_MEDIO,
    INITCAP(UNI_PRO.DS_UNIDADE)                                                 DS_UNIDADE,
    sum( NVL(ITCONTAGEM.QT_ESTOQUE,0) + NVL( ITCONTAGEM.QT_ESTOQUE_DOADO,0))    QUANTIDADE,
    TRUNC(CONTAGEM.DT_GERACAO)                                                  DT_GERACAO,
    to_char(CONTAGEM.HR_GERACAO,'hh24:mi:ss')                                   HORA,
    CONTAGEM.CD_CONTAGEM                                                        DOCUMENTO,
    'Contagem - ' || INITCAP(ESTOQUE.DS_ESTOQUE)                                DS_DESTINO,
    'Contagem'                                                                  OPERACAO,
    0                                                                           VALOR,
    ESTOQUE.CD_ESTOQUE                                                          CD_ESTOQUE,
    INITCAP(ESTOQUE.DS_ESTOQUE)                                                 DS_ESTOQUE,
    UNI_PRO.VL_FATOR                                                            VL_FATOR,
    '1'                                                                         TP_ORDEM,
    'N'                                                                         SN_CONSIGNADO,
    0                                                                           cd_itmvto_estoque
FROM    
    dbamv.ITCONTAGEM            ITCONTAGEM,
    dbamv.CONTAGEM              CONTAGEM,
    dbamv.PRODUTO               PRODUTO,
    dbamv.UNI_PRO               UNI_PRO,
    dbamv.ESTOQUE               ESTOQUE,
    dbamv.ITENT_PRO             ITENT_PRO,
    dbamv.VALOR_INICIAL_PRODUTO VALOR_INICIAL_PRODUTO
WHERE 
    ITCONTAGEM.CD_PRODUTO       = PRODUTO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO       = ITENT_PRO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO       = valor_inicial_produto.CD_PRODUTO
    AND  ITCONTAGEM.CD_CONTAGEM = CONTAGEM.CD_CONTAGEM
    AND  ITCONTAGEM.CD_UNI_PRO  = UNI_PRO.CD_UNI_PRO
    AND CONTAGEM.CD_ESTOQUE     = ESTOQUE.CD_ESTOQUE
    --AND  Estoque.Cd_Multi_Empresa = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
GROUP BY
    ITCONTAGEM.CD_PRODUTO,
    PRODUTO.DS_PRODUTO,
    PRODUTO.VL_CUSTO_MEDIO,
    ITENT_PRO.VL_UNITARIO,
    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
    UNI_PRO.DS_UNIDADE,
    CONTAGEM.DT_GERACAO,
    CONTAGEM.HR_GERACAO,
    CONTAGEM.CD_CONTAGEM,
    ESTOQUE.CD_ESTOQUE,
    ESTOQUE.DS_ESTOQUE,
    UNI_PRO.VL_FATOR
UNION ALL
SELECT  
    ITMVTO_ESTOQUE.CD_PRODUTO                           CD_PRODUTO,
    INITCAP(PRODUTO.DS_PRODUTO)                         DS_PRODUTO,
    NVL(
        NVL(
            NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
            VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
            ),
        0
        )                                               VL_CUSTO_MEDIO,
    INITCAP(UNI_PRO.DS_UNIDADE)                         DS_UNIDADE,
    DECODE(
        MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
        'D', ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
        'C' , ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
        ITMVTO_ESTOQUE.QT_MOVIMENTACAO * -1)            QUANTIDADE,
    TRUNC(MVTO_ESTOQUE.DT_MVTO_ESTOQUE)                 DT_GERACAO,
    TO_CHAR(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss') HORA,
    MVTO_ESTOQUE.CD_MVTO_ESTOQUE                        DOCUMENTO,
    INITCAP(INITCAP(
        NVL( 
            PACIENTE.NM_PACIENTE,
            DECODE( 
                MVTO_ESTOQUE.TP_MVTO_ESTOQUE, 
                'T', ESTOQUE_DESTINO.DS_ESTOQUE,
                'E',FORNECEDOR.NM_FORNECEDOR, 
                SETOR.NM_SETOR
                )
            )
        ))                                              DS_DESTINO,
    INITCAP( 
        DECODE(
            MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
            'X', 'BAIXA DE PRODUTOS',
            'S', 'SAIDA SETOR',
            'P', 'SAIDA PACIENTE',
            'D', 'DEVOL. DE SETOR',
            'C', 'DEVOL. DE PACIENTE',
            'T', 'TRANSF. DE ESTOQUE',
            'M', 'MANIPUL.  PRODUTOS',
            'O', 'DOAÇÃO  PRODUTOS',
            'E', 'SAIDA DE EMPRESTIMO',
            'V', 'VENDA DE PRODUTOS' ,
            'N','DEVOLUCAO DE VENDAS'
            )
        )                                               OPERACAO,
    0                                                   VALOR,
    ESTOQUE.CD_ESTOQUE                                  CD_ESTOQUE,
    INITCAP(ESTOQUE.DS_ESTOQUE)                         DS_ESTOQUE,
    UNI_PRO.VL_FATOR                                    VL_FATOR,
    '3'                                                 TP_ORDEM,
    'N'                                                 SN_CONSIGNADO,
    0                                                   cd_itmvto_estoque
FROM 
    dbamv.MVTO_ESTOQUE                                  MVTO_ESTOQUE,
    dbamv.ITMVTO_ESTOQUE                                ITMVTO_ESTOQUE,
    dbamv.PRODUTO                                       PRODUTO,
    dbamv.UNI_PRO                                       UNI_PRO,
    dbamv.ATENDIME                                      ATENDIMENTO,
    dbamv.PACIENTE                                      PACIENTE,
    dbamv.SETOR                                         SETOR,
    dbamv.ESTOQUE                                       ESTOQUE,
    dbamv.ESTOQUE                                       ESTOQUE_DESTINO,
    dbamv.FORNECEDOR                                    FORNECEDOR,
    dbamv.ITENT_PRO                                     ITENT_PRO,
    dbamv.VALOR_INICIAL_PRODUTO                         VALOR_INICIAL_PRODUTO
WHERE   
    ITMVTO_ESTOQUE.CD_PRODUTO               = PRODUTO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO                  = ITENT_PRO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO                  = valor_inicial_produto.CD_PRODUTO
    AND ITMVTO_ESTOQUE.CD_MVTO_ESTOQUE      = MVTO_ESTOQUE.CD_MVTO_ESTOQUE
    AND ITMVTO_ESTOQUE.CD_UNI_PRO           = UNI_PRO.CD_UNI_PRO
    AND MVTO_ESTOQUE.CD_ATENDIMENTO         = ATENDIMENTO.CD_ATENDIMENTO (+)
    AND ATENDIMENTO.CD_PACIENTE             = PACIENTE.CD_PACIENTE (+)
    AND MVTO_ESTOQUE.CD_SETOR               = SETOR.CD_SETOR(+)
    AND MVTO_ESTOQUE.CD_ESTOQUE_DESTINO     =  ESTOQUE_DESTINO.CD_ESTOQUE(+)
    AND ITMVTO_ESTOQUE.CD_UNI_PRO           =  UNI_PRO.CD_UNI_PRO
    AND MVTO_ESTOQUE.CD_ESTOQUE             = ESTOQUE.CD_ESTOQUE
    AND MVTO_ESTOQUE.CD_FORNECEDOR          = FORNECEDOR.CD_FORNECEDOR(+)
            --AND Estoque.Cd_Multi_Empresa         = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
            --and atendimento.cd_multi_empresa        = dbamv.Pkg_Mv2000.Le_Empresa
GROUP BY 
    ITMVTO_ESTOQUE.CD_PRODUTO,
    PRODUTO.DS_PRODUTO,
    PRODUTO.VL_CUSTO_MEDIO,
    ITENT_PRO.VL_UNITARIO,
    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
    UNI_PRO.DS_UNIDADE,
    MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
    ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
    MVTO_ESTOQUE.DT_MVTO_ESTOQUE,
    MVTO_ESTOQUE.HR_MVTO_ESTOQUE,
    MVTO_ESTOQUE.CD_MVTO_ESTOQUE,
    PACIENTE.NM_PACIENTE,
    ESTOQUE_DESTINO.DS_ESTOQUE,
    FORNECEDOR.NM_FORNECEDOR,
    SETOR.NM_SETOR,
    ESTOQUE.CD_ESTOQUE,
    ESTOQUE.DS_ESTOQUE,
    UNI_PRO.VL_FATOR
UNION ALL
SELECT  ITENT_PRO.CD_PRODUTO                                     CD_PRODUTO,
        INITCAP(PRODUTO.DS_PRODUTO)                              DS_PRODUTO,
        NVL(
            NVL(
                NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                ),
            0
            )                                                    VL_CUSTO_MEDIO,
        INITCAP(UNI_PRO.DS_UNIDADE)                              DS_UNIDADE,
        ITENT_PRO.QT_ENTRADA                                     QUANTIDADE,
        TRUNC(ENT_PRO.DT_ENTRADA)                                DT_GERACAO,
        to_char(ENT_PRO.HR_ENTRADA,'hh24:mi:ss')                 HORA,
        ENT_PRO.CD_ENT_PRO                                       DOCUMENTO,
        INITCAP( FORNEC.NM_FORNECEDOR )                          DS_DESTINO,
        INITCAP(TIP_DOC.DS_TIP_DOC)                              OPERACAO,
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
    dbamv.VALOR_INICIAL_PRODUTO       VALOR_INICIAL_PRODUTO
WHERE 
    ITENT_PRO.CD_PRODUTO      =   PRODUTO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO    = valor_inicial_produto.CD_PRODUTO
    AND ITENT_PRO.CD_ENT_PRO  =   ENT_PRO.CD_ENT_PRO
    AND ENT_PRO.CD_TIP_DOC    =   TIP_DOC.CD_TIP_DOC
    AND ITENT_PRO.CD_UNI_PRO  =   UNI_PRO.CD_UNI_PRO
    AND ENT_PRO.CD_FORNECEDOR =   FORNEC.CD_FORNECEDOR(+)
    AND ITENT_PRO.CD_UNI_PRO  =   UNI_PRO.CD_UNI_PRO
    AND ENT_PRO.CD_ESTOQUE    =  ESTOQUE.CD_ESTOQUE
   -- AND Estoque.Cd_Multi_Empresa = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
GROUP BY 
	ITENT_PRO.CD_PRODUTO,
	PRODUTO.DS_PRODUTO,
	PRODUTO.VL_CUSTO_MEDIO,
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
	ENT_PRO.SN_CONSIGNADO
UNION ALL
SELECT 
    ITMVTO_ESTOQUE.CD_PRODUTO                                      CD_PRODUTO,
    INITCAP(PRODUTO.DS_PRODUTO)                                    DS_PRODUTO,
    NVL(
        NVL(
            NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
            VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
            ),
        0
        )                                                          VL_CUSTO_MEDIO,
    INITCAP(UNI_PRO.DS_UNIDADE)                                    DS_UNIDADE,
    ITMVTO_ESTOQUE.QT_MOVIMENTACAO                                 QUANTIDADE,
    TRUNC( MVTO_ESTOQUE.DT_MVTO_ESTOQUE)                           DT_GERACAO,
    to_char(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss')            HORA,
    MVTO_ESTOQUE.CD_MVTO_ESTOQUE                                   DOCUMENTO,
    INITCAP( NVL( PACIENTE.NM_PACIENTE,
    DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE, 'T', ESTOQUE_DESTINO.DS_ESTOQUE, SETOR.NM_SETOR ) ) ) DS_DESTINO,
    INITCAP( DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE,'T', 'CRED. TRANSF. EST.' )  ) OPERACAO,
    0                                                              VALOR,
    ESTOQUE.CD_ESTOQUE                                             CD_ESTOQUE,
    INITCAP(ESTOQUE.DS_ESTOQUE)                                    DS_ESTOQUE,
    UNI_PRO.VL_FATOR                                               VL_FATOR,
    '3'                                                            TP_ORDEM,
    'N'	                                                          SN_CONSIGNADO,
    itmvto_estoque.cd_itmvto_estoque                               cd_itmvto_estoque
FROM    
    dbamv.MVTO_ESTOQUE                            MVTO_ESTOQUE,
    dbamv.ITMVTO_ESTOQUE                          ITMVTO_ESTOQUE,
    dbamv.PRODUTO                                 PRODUTO,
    dbamv.UNI_PRO                                 UNI_PRO,
    dbamv.ATENDIME                                ATENDIMENTO,
    dbamv.PACIENTE                                PACIENTE,
    dbamv.SETOR                                   SETOR,
    dbamv.ESTOQUE                                 ESTOQUE,
    dbamv.ESTOQUE                                 ESTOQUE_DESTINO,
    dbamv.ITENT_PRO                               ITENT_PRO,
    dbamv.VALOR_INICIAL_PRODUTO                   VALOR_INICIAL_PRODUTO
WHERE 
    MVTO_ESTOQUE.TP_MVTO_ESTOQUE       = 'T'
    AND ITMVTO_ESTOQUE.CD_PRODUTO      = PRODUTO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO             = ITENT_PRO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO             = valor_inicial_produto.CD_PRODUTO
    AND ITMVTO_ESTOQUE.CD_MVTO_ESTOQUE = MVTO_ESTOQUE.CD_MVTO_ESTOQUE
    AND ITMVTO_ESTOQUE.CD_UNI_PRO      = UNI_PRO.CD_UNI_PRO
    AND MVTO_ESTOQUE.CD_ATENDIMENTO    = ATENDIMENTO.CD_ATENDIMENTO (+)
    AND ATENDIMENTO.CD_PACIENTE        = PACIENTE.CD_PACIENTE (+)
    AND MVTO_ESTOQUE.CD_SETOR          = SETOR.CD_SETOR(+)
    AND MVTO_ESTOQUE.CD_ESTOQUE        = ESTOQUE_DESTINO.CD_ESTOQUE
    AND ITMVTO_ESTOQUE.CD_UNI_PRO      = UNI_PRO.CD_UNI_PRO
    AND ESTOQUE.CD_ESTOQUE             = MVTO_ESTOQUE.CD_ESTOQUE_DESTINO
    -- AND Estoque.Cd_Multi_Empresa       = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
    --and atendimento.cd_multi_empresa      = dbamv.Pkg_Mv2000.Le_Empresa
GROUP BY
	ITMVTO_ESTOQUE.CD_PRODUTO,
	PRODUTO.DS_PRODUTO,
	PRODUTO.VL_CUSTO_MEDIO,
	ITENT_PRO.VL_UNITARIO,
	VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
	UNI_PRO.DS_UNIDADE,
	ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
	MVTO_ESTOQUE.DT_MVTO_ESTOQUE,
	MVTO_ESTOQUE.HR_MVTO_ESTOQUE,
	MVTO_ESTOQUE.CD_MVTO_ESTOQUE,
	PACIENTE.NM_PACIENTE,
	MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
	ESTOQUE_DESTINO.DS_ESTOQUE,
	SETOR.NM_SETOR,
	ESTOQUE.CD_ESTOQUE,
	ESTOQUE.DS_ESTOQUE,
	UNI_PRO.VL_FATOR,
	ITMVTO_ESTOQUE.CD_ITMVTO_ESTOQUE
union all
SELECT 
    ITDEV_FOR.CD_PRODUTO,
    INITCAP(PRODUTO.DS_PRODUTO)                 DS_PRODUTO,
    NVL(
        NVL(
            NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
            VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
            ),
        0
        )                                        VL_CUSTO_MEDIO,
    UNI_PRO.DS_UNIDADE,
    ITDEV_FOR.QT_DEVOLVIDA * -1                  QUANTIDADE,
    TRUNC(DEV_FOR.DT_DEVOLUCAO)                  DT_GERACAO,
    TO_CHAR(DEV_FOR.HR_DEVOLUCAO, 'hh24:mi:ss' ) HORA,
    DEV_FOR.CD_DEVOLUCAO                         DOCUMENTO,
    INITCAP( FORNECEDOR.NM_FORNECEDOR )          DS_DESTINO,
    'Dev. P/  Fornecedor'                        OPERACAO,
    (itent_pro.vl_custo_real / uni_pro.vl_fator) VALOR,
    ESTOQUE.CD_ESTOQUE                           CD_ESTOQUE,
    INITCAP(ESTOQUE.DS_ESTOQUE)                  DS_ESTOQUE,
    UNI_PRO.VL_FATOR                             VL_FATOR,
    '4'                                          TP_ORDEM,
    'N'							                 SN_CONSIGNADO,   -- PDA 51945
    0                                            cd_itmvto_estoque
FROM   
    DBAMV.ESTOQUE               ESTOQUE,
    DBAMV.DEV_FOR               DEV_FOR,
    DBAMV.ITDEV_FOR             ITDEV_FOR,
    DBAMV.UNI_PRO               UNI_PRO,
    DBAMV.FORNECEDOR            FORNECEDOR,
    DBAMV.PRODUTO               PRODUTO,
    DBAMV.ENT_PRO               ENT_PRO,
    dbamv.ITENT_PRO             ITENT_PRO,
    dbamv.VALOR_INICIAL_PRODUTO VALOR_INICIAL_PRODUTO
WHERE 
    ITDEV_FOR.CD_DEVOLUCAO      = DEV_FOR.CD_DEVOLUCAO
    AND ITDEV_FOR.CD_PRODUTO    = PRODUTO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO      = ITENT_PRO.CD_PRODUTO
    AND PRODUTO.CD_PRODUTO      = valor_inicial_produto.CD_PRODUTO
    AND ITDEV_FOR.CD_UNI_PRO    = UNI_PRO.CD_UNI_PRO
    AND DEV_FOR.CD_ENT_PRO      = ENT_PRO.CD_ENT_PRO
    AND ENT_PRO.CD_FORNECEDOR   = FORNECEDOR.CD_FORNECEDOR
    AND ENT_PRO.CD_ESTOQUE      = ESTOQUE.CD_ESTOQUE
    and itdev_for.cd_itent_pro  = itent_pro.cd_itent_pro
 -- and Estoque.Cd_Multi_Empresa = Pkg_Mv2000.Le_Empresa   -- Pda 118607 (acgm)
GROUP BY
	ITDEV_FOR.CD_PRODUTO,
	PRODUTO.DS_PRODUTO,
	PRODUTO.VL_CUSTO_MEDIO,
	ITENT_PRO.VL_UNITARIO,
	VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO,
	UNI_PRO.DS_UNIDADE,
	ITDEV_FOR.QT_DEVOLVIDA,
	DEV_FOR.DT_DEVOLUCAO,
	DEV_FOR.HR_DEVOLUCAO,
	DEV_FOR.CD_DEVOLUCAO,
	FORNECEDOR.NM_FORNECEDOR,
	ITENT_PRO.VL_CUSTO_REAL,
	UNI_PRO.VL_FATOR,
	ESTOQUE.CD_ESTOQUE,
	ESTOQUE.DS_ESTOQUE  
ORDER BY 
    DT_GERACAO,  
    HORA, 
    DS_PRODUTO, 
    5, 
    6, 
    TP_ORDEM, 
    OPERACAO ;











