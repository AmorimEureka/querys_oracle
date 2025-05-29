WITH ORIGINAL
	AS (
        SELECT
            ITCONTAGEM.CD_PRODUTO                          AS                             CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)                    AS                             DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                          AS                           VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)                    AS                             DS_UNIDADE,
            sum( NVL(ITCONTAGEM.QT_ESTOQUE,0) + NVL( ITCONTAGEM.QT_ESTOQUE_DOADO,0)) AS   QUANTIDADE,
            TRUNC(CONTAGEM.DT_GERACAO)                                               AS   DT_GERACAO,
            to_char(CONTAGEM.HR_GERACAO,'hh24:mi:ss')                                AS   HORA,
            CONTAGEM.CD_CONTAGEM                                                     AS   DOCUMENTO,
            'Contagem - ' || INITCAP(ESTOQUE.DS_ESTOQUE)                             AS   DS_DESTINO,
            'Contagem'                                                               AS   OPERACAO,
            0                                                                        AS   VALOR,
            ESTOQUE.CD_ESTOQUE                                                       AS   CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)                                              AS   DS_ESTOQUE,
            UNI_PRO.VL_FATOR                                                         AS   VL_FATOR,
            '1'                                                                      AS   TP_ORDEM,
            'N'                                                                      AS   SN_CONSIGNADO,
            0                                                                        AS   cd_itmvto_estoque
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
            AND CONTAGEM.DT_GERACAO >= ADD_MONTHS(SYSDATE, -:meses)
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
            ITMVTO_ESTOQUE.CD_PRODUTO                  AS         CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)                AS         DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                      AS         VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)                AS         DS_UNIDADE,
            DECODE(
                MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
                'D', ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
                'C' , ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
                ITMVTO_ESTOQUE.QT_MOVIMENTACAO * -1)   AS         QUANTIDADE,
            TRUNC(MVTO_ESTOQUE.DT_MVTO_ESTOQUE)        AS         DT_GERACAO,
            TO_CHAR(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss') AS HORA,
            MVTO_ESTOQUE.CD_MVTO_ESTOQUE                       AS DOCUMENTO,
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
                ))        AS                                      DS_DESTINO,
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
                )                                     AS          OPERACAO,
            0                                         AS          VALOR,
            ESTOQUE.CD_ESTOQUE                        AS          CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)               AS          DS_ESTOQUE,
            UNI_PRO.VL_FATOR                          AS          VL_FATOR,
            '3'                                       AS          TP_ORDEM,
            'N'                                       AS          SN_CONSIGNADO,
            0                                         AS          cd_itmvto_estoque
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
            AND MVTO_ESTOQUE.DT_MVTO_ESTOQUE >= ADD_MONTHS(SYSDATE, -:meses)
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
        SELECT  ITENT_PRO.CD_PRODUTO                         AS            CD_PRODUTO,
                INITCAP(PRODUTO.DS_PRODUTO)                  AS            DS_PRODUTO,
                NVL(
                    NVL(
                        NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                        VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                        ),
                    0
                    )                                        AS            VL_CUSTO_MEDIO,
                INITCAP(UNI_PRO.DS_UNIDADE)                  AS            DS_UNIDADE,
                ITENT_PRO.QT_ENTRADA                         AS            QUANTIDADE,
                TRUNC(ENT_PRO.DT_ENTRADA)                    AS            DT_GERACAO,
                to_char(ENT_PRO.HR_ENTRADA,'hh24:mi:ss')     AS            HORA,
                ENT_PRO.CD_ENT_PRO                           AS            DOCUMENTO,
                INITCAP( FORNEC.NM_FORNECEDOR )              AS            DS_DESTINO,
                INITCAP(TIP_DOC.DS_TIP_DOC)                  AS            OPERACAO,
                itent_pro.vl_custo_real   / uni_pro.vl_fator AS            VALOR,
                ESTOQUE.CD_ESTOQUE                           AS            CD_ESTOQUE,
                INITCAP(ESTOQUE.DS_ESTOQUE)                  AS            DS_ESTOQUE,
                UNI_PRO.VL_FATOR                             AS            VL_FATOR,
                '2'                                          AS            TP_ORDEM,
                ENT_PRO.SN_CONSIGNADO			             AS            SN_CONSIGNADO,
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
            AND ENT_PRO.HR_ENTRADA >= ADD_MONTHS(SYSDATE, -:meses)
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
            ITMVTO_ESTOQUE.CD_PRODUTO               AS                       CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)             AS                       DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                   AS                       VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)             AS                       DS_UNIDADE,
            ITMVTO_ESTOQUE.QT_MOVIMENTACAO          AS                       QUANTIDADE,
            TRUNC( MVTO_ESTOQUE.DT_MVTO_ESTOQUE)    AS                       DT_GERACAO,
            to_char(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss') AS           HORA,
            MVTO_ESTOQUE.CD_MVTO_ESTOQUE                        AS           DOCUMENTO,
            INITCAP( NVL( PACIENTE.NM_PACIENTE,
            DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE, 'T', ESTOQUE_DESTINO.DS_ESTOQUE, SETOR.NM_SETOR ) ) ) AS DS_DESTINO,
            INITCAP( DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE,'T', 'CRED. TRANSF. EST.' )  ) AS OPERACAO,
            0                                                   AS           VALOR,
            ESTOQUE.CD_ESTOQUE                                  AS           CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)                         AS           DS_ESTOQUE,
            UNI_PRO.VL_FATOR                                    AS           VL_FATOR,
            '3'                                                 AS           TP_ORDEM,
            'N'	                                                AS          SN_CONSIGNADO,
            itmvto_estoque.cd_itmvto_estoque                    AS           cd_itmvto_estoque
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
            AND MVTO_ESTOQUE.DT_MVTO_ESTOQUE >= ADD_MONTHS(SYSDATE, -:meses)
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
            INITCAP(PRODUTO.DS_PRODUTO)         AS        DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                 AS       VL_CUSTO_MEDIO,
            UNI_PRO.DS_UNIDADE,
            ITDEV_FOR.QT_DEVOLVIDA * -1             AS     QUANTIDADE,
            TRUNC(DEV_FOR.DT_DEVOLUCAO)             AS     DT_GERACAO,
            TO_CHAR(DEV_FOR.HR_DEVOLUCAO, 'hh24:mi:ss' ) AS HORA,
            DEV_FOR.CD_DEVOLUCAO                   AS      DOCUMENTO,
            INITCAP( FORNECEDOR.NM_FORNECEDOR )    AS      DS_DESTINO,
            'Dev. P/  Fornecedor'                  AS      OPERACAO,
            (itent_pro.vl_custo_real / uni_pro.vl_fator) AS VALOR,
            ESTOQUE.CD_ESTOQUE                     AS      CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)            AS      DS_ESTOQUE,
            UNI_PRO.VL_FATOR                       AS      VL_FATOR,
            '4'                                    AS      TP_ORDEM,
            'N'							           AS      SN_CONSIGNADO,
            0                                      AS      cd_itmvto_estoque
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
            AND DEV_FOR.DT_DEVOLUCAO >= ADD_MONTHS(SYSDATE, -:meses)
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
SELECT * FROM ORIGINAL







/*****************************************************************************
 * Consulta 'Estoque' no Painel HPC-COMPRAS-Estoque e Movimentação_PARAMETRO *
******************************************************************************/
let
    // Converte os parâmetros para texto no formato esperado pela query
    RangeStartText = Date.ToText(RangeStart, "yyyy-MM-dd"),
    RangeEndText = Date.ToText(RangeEnd, "yyyy-MM-dd"),

    // Sua query SQL com os parâmetros inseridos dinamicamente
    Query = "
WITH ORIGINAL
	AS (
        SELECT
            ITCONTAGEM.CD_PRODUTO                          AS                             CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)                    AS                             DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                          AS                           VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)                    AS                             DS_UNIDADE,
            sum( NVL(ITCONTAGEM.QT_ESTOQUE,0) + NVL( ITCONTAGEM.QT_ESTOQUE_DOADO,0)) AS   QUANTIDADE,
            TRUNC(CONTAGEM.DT_GERACAO)                                               AS   DT_GERACAO,
            to_char(CONTAGEM.HR_GERACAO,'hh24:mi:ss')                                AS   HORA,
            CONTAGEM.CD_CONTAGEM                                                     AS   DOCUMENTO,
            'Contagem - ' || INITCAP(ESTOQUE.DS_ESTOQUE)                             AS   DS_DESTINO,
            'Contagem'                                                               AS   OPERACAO,
            0                                                                        AS   VALOR,
            ESTOQUE.CD_ESTOQUE                                                       AS   CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)                                              AS   DS_ESTOQUE,
            UNI_PRO.VL_FATOR                                                         AS   VL_FATOR,
            '1'                                                                      AS   TP_ORDEM,
            'N'                                                                      AS   SN_CONSIGNADO,
            0                                                                        AS   cd_itmvto_estoque
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
            AND TRUNC(CONTAGEM.DT_GERACAO, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
            ITMVTO_ESTOQUE.CD_PRODUTO                  AS         CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)                AS         DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                      AS         VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)                AS         DS_UNIDADE,
            DECODE(
                MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
                'D', ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
                'C' , ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
                ITMVTO_ESTOQUE.QT_MOVIMENTACAO * -1)   AS         QUANTIDADE,
            TRUNC(MVTO_ESTOQUE.DT_MVTO_ESTOQUE)        AS         DT_GERACAO,
            TO_CHAR(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss') AS HORA,
            MVTO_ESTOQUE.CD_MVTO_ESTOQUE                       AS DOCUMENTO,
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
                ))        AS                                      DS_DESTINO,
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
                )                                     AS          OPERACAO,
            0                                         AS          VALOR,
            ESTOQUE.CD_ESTOQUE                        AS          CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)               AS          DS_ESTOQUE,
            UNI_PRO.VL_FATOR                          AS          VL_FATOR,
            '3'                                       AS          TP_ORDEM,
            'N'                                       AS          SN_CONSIGNADO,
            0                                         AS          cd_itmvto_estoque
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
            AND TRUNC(MVTO_ESTOQUE.DT_MVTO_ESTOQUE, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
        SELECT  ITENT_PRO.CD_PRODUTO                         AS            CD_PRODUTO,
                INITCAP(PRODUTO.DS_PRODUTO)                  AS            DS_PRODUTO,
                NVL(
                    NVL(
                        NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                        VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                        ),
                    0
                    )                                        AS            VL_CUSTO_MEDIO,
                INITCAP(UNI_PRO.DS_UNIDADE)                  AS            DS_UNIDADE,
                ITENT_PRO.QT_ENTRADA                         AS            QUANTIDADE,
                TRUNC(ENT_PRO.DT_ENTRADA)                    AS            DT_GERACAO,
                to_char(ENT_PRO.HR_ENTRADA,'hh24:mi:ss')     AS            HORA,
                ENT_PRO.CD_ENT_PRO                           AS            DOCUMENTO,
                INITCAP( FORNEC.NM_FORNECEDOR )              AS            DS_DESTINO,
                INITCAP(TIP_DOC.DS_TIP_DOC)                  AS            OPERACAO,
                itent_pro.vl_custo_real   / uni_pro.vl_fator AS            VALOR,
                ESTOQUE.CD_ESTOQUE                           AS            CD_ESTOQUE,
                INITCAP(ESTOQUE.DS_ESTOQUE)                  AS            DS_ESTOQUE,
                UNI_PRO.VL_FATOR                             AS            VL_FATOR,
                '2'                                          AS            TP_ORDEM,
                ENT_PRO.SN_CONSIGNADO			             AS            SN_CONSIGNADO,
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
            AND TRUNC(ENT_PRO.HR_ENTRADA, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
            ITMVTO_ESTOQUE.CD_PRODUTO               AS                       CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)             AS                       DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                   AS                       VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)             AS                       DS_UNIDADE,
            ITMVTO_ESTOQUE.QT_MOVIMENTACAO          AS                       QUANTIDADE,
            TRUNC( MVTO_ESTOQUE.DT_MVTO_ESTOQUE)    AS                       DT_GERACAO,
            to_char(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss') AS           HORA,
            MVTO_ESTOQUE.CD_MVTO_ESTOQUE                        AS           DOCUMENTO,
            INITCAP( NVL( PACIENTE.NM_PACIENTE,
            DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE, 'T', ESTOQUE_DESTINO.DS_ESTOQUE, SETOR.NM_SETOR ) ) ) AS DS_DESTINO,
            INITCAP( DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE,'T', 'CRED. TRANSF. EST.' )  ) AS OPERACAO,
            0                                                   AS           VALOR,
            ESTOQUE.CD_ESTOQUE                                  AS           CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)                         AS           DS_ESTOQUE,
            UNI_PRO.VL_FATOR                                    AS           VL_FATOR,
            '3'                                                 AS           TP_ORDEM,
            'N'	                                                AS          SN_CONSIGNADO,
            itmvto_estoque.cd_itmvto_estoque                    AS           cd_itmvto_estoque
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
            AND TRUNC(MVTO_ESTOQUE.DT_MVTO_ESTOQUE, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
            INITCAP(PRODUTO.DS_PRODUTO)         AS        DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                 AS       VL_CUSTO_MEDIO,
            UNI_PRO.DS_UNIDADE,
            ITDEV_FOR.QT_DEVOLVIDA * -1             AS     QUANTIDADE,
            TRUNC(DEV_FOR.DT_DEVOLUCAO)             AS     DT_GERACAO,
            TO_CHAR(DEV_FOR.HR_DEVOLUCAO, 'hh24:mi:ss' ) AS HORA,
            DEV_FOR.CD_DEVOLUCAO                   AS      DOCUMENTO,
            INITCAP( FORNECEDOR.NM_FORNECEDOR )    AS      DS_DESTINO,
            'Dev. P/  Fornecedor'                  AS      OPERACAO,
            (itent_pro.vl_custo_real / uni_pro.vl_fator) AS VALOR,
            ESTOQUE.CD_ESTOQUE                     AS      CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)            AS      DS_ESTOQUE,
            UNI_PRO.VL_FATOR                       AS      VL_FATOR,
            '4'                                    AS      TP_ORDEM,
            'N'							           AS      SN_CONSIGNADO,
            0                                      AS      cd_itmvto_estoque
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
            AND ITDEV_FOR.CD_UNI_PRO    = UNI_PRO.CD_UNI_PRO'
            AND DEV_FOR.CD_ENT_PRO      = ENT_PRO.CD_ENT_PRO
            AND ENT_PRO.CD_FORNECEDOR   = FORNECEDOR.CD_FORNECEDOR
            AND ENT_PRO.CD_ESTOQUE      = ESTOQUE.CD_ESTOQUE
            and itdev_for.cd_itent_pro  = itent_pro.cd_itent_pro
            AND TRUNC(DEV_FOR.DT_DEVOLUCAO, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
SELECT * FROM ORIGINAL
    ",

    // Chamada Oracle com a query final montada
    Fonte = Oracle.Database(
        "//10.97.170.174:1521/PRD2361.db2361.mv2361vcn.oraclevcn.com",
        [Query = Query]
    )
in
    Fonte




/*****************************************************************************
 * Query ajusta para o Painel HPC-COMPRAS-Estoque e Movimentação_PARAMETRO   *
******************************************************************************/
WITH ORIGINAL
	AS (
        SELECT
            ITCONTAGEM.CD_PRODUTO                          AS                             CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)                    AS                             DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                          AS                           VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)                    AS                             DS_UNIDADE,
            sum( NVL(ITCONTAGEM.QT_ESTOQUE,0) + NVL( ITCONTAGEM.QT_ESTOQUE_DOADO,0)) AS   QUANTIDADE,
            TRUNC(CONTAGEM.DT_GERACAO)                                               AS   DT_GERACAO,
            to_char(CONTAGEM.HR_GERACAO,'hh24:mi:ss')                                AS   HORA,
            CONTAGEM.CD_CONTAGEM                                                     AS   DOCUMENTO,
            'Contagem - ' || INITCAP(ESTOQUE.DS_ESTOQUE)                             AS   DS_DESTINO,
            'Contagem'                                                               AS   OPERACAO,
            0                                                                        AS   VALOR,
            ESTOQUE.CD_ESTOQUE                                                       AS   CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)                                              AS   DS_ESTOQUE,
            UNI_PRO.VL_FATOR                                                         AS   VL_FATOR,
            '1'                                                                      AS   TP_ORDEM,
            'N'                                                                      AS   SN_CONSIGNADO,
            0                                                                        AS   cd_itmvto_estoque
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
            AND TRUNC(CONTAGEM.DT_GERACAO, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
            ITMVTO_ESTOQUE.CD_PRODUTO                  AS         CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)                AS         DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                      AS         VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)                AS         DS_UNIDADE,
            DECODE(
                MVTO_ESTOQUE.TP_MVTO_ESTOQUE,
                'D', ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
                'C' , ITMVTO_ESTOQUE.QT_MOVIMENTACAO,
                ITMVTO_ESTOQUE.QT_MOVIMENTACAO * -1)   AS         QUANTIDADE,
            TRUNC(MVTO_ESTOQUE.DT_MVTO_ESTOQUE)        AS         DT_GERACAO,
            TO_CHAR(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss') AS HORA,
            MVTO_ESTOQUE.CD_MVTO_ESTOQUE                       AS DOCUMENTO,
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
                ))        AS                                      DS_DESTINO,
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
                )                                     AS          OPERACAO,
            0                                         AS          VALOR,
            ESTOQUE.CD_ESTOQUE                        AS          CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)               AS          DS_ESTOQUE,
            UNI_PRO.VL_FATOR                          AS          VL_FATOR,
            '3'                                       AS          TP_ORDEM,
            'N'                                       AS          SN_CONSIGNADO,
            0                                         AS          cd_itmvto_estoque
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
            AND TRUNC(MVTO_ESTOQUE.DT_MVTO_ESTOQUE, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
        SELECT  ITENT_PRO.CD_PRODUTO                         AS            CD_PRODUTO,
                INITCAP(PRODUTO.DS_PRODUTO)                  AS            DS_PRODUTO,
                NVL(
                    NVL(
                        NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                        VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                        ),
                    0
                    )                                        AS            VL_CUSTO_MEDIO,
                INITCAP(UNI_PRO.DS_UNIDADE)                  AS            DS_UNIDADE,
                ITENT_PRO.QT_ENTRADA                         AS            QUANTIDADE,
                TRUNC(ENT_PRO.DT_ENTRADA)                    AS            DT_GERACAO,
                to_char(ENT_PRO.HR_ENTRADA,'hh24:mi:ss')     AS            HORA,
                ENT_PRO.CD_ENT_PRO                           AS            DOCUMENTO,
                INITCAP( FORNEC.NM_FORNECEDOR )              AS            DS_DESTINO,
                INITCAP(TIP_DOC.DS_TIP_DOC)                  AS            OPERACAO,
                itent_pro.vl_custo_real   / uni_pro.vl_fator AS            VALOR,
                ESTOQUE.CD_ESTOQUE                           AS            CD_ESTOQUE,
                INITCAP(ESTOQUE.DS_ESTOQUE)                  AS            DS_ESTOQUE,
                UNI_PRO.VL_FATOR                             AS            VL_FATOR,
                '2'                                          AS            TP_ORDEM,
                ENT_PRO.SN_CONSIGNADO			             AS            SN_CONSIGNADO,
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
            AND TRUNC(ENT_PRO.HR_ENTRADA, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
            ITMVTO_ESTOQUE.CD_PRODUTO               AS                       CD_PRODUTO,
            INITCAP(PRODUTO.DS_PRODUTO)             AS                       DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                   AS                       VL_CUSTO_MEDIO,
            INITCAP(UNI_PRO.DS_UNIDADE)             AS                       DS_UNIDADE,
            ITMVTO_ESTOQUE.QT_MOVIMENTACAO          AS                       QUANTIDADE,
            TRUNC( MVTO_ESTOQUE.DT_MVTO_ESTOQUE)    AS                       DT_GERACAO,
            to_char(MVTO_ESTOQUE.HR_MVTO_ESTOQUE, 'hh24:mi:ss') AS           HORA,
            MVTO_ESTOQUE.CD_MVTO_ESTOQUE                        AS           DOCUMENTO,
            INITCAP( NVL( PACIENTE.NM_PACIENTE,
            DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE, 'T', ESTOQUE_DESTINO.DS_ESTOQUE, SETOR.NM_SETOR ) ) ) AS DS_DESTINO,
            INITCAP( DECODE( MVTO_ESTOQUE.TP_MVTO_ESTOQUE,'T', 'CRED. TRANSF. EST.' )  ) AS OPERACAO,
            0                                                   AS           VALOR,
            ESTOQUE.CD_ESTOQUE                                  AS           CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)                         AS           DS_ESTOQUE,
            UNI_PRO.VL_FATOR                                    AS           VL_FATOR,
            '3'                                                 AS           TP_ORDEM,
            'N'	                                                AS          SN_CONSIGNADO,
            itmvto_estoque.cd_itmvto_estoque                    AS           cd_itmvto_estoque
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
            AND TRUNC(MVTO_ESTOQUE.DT_MVTO_ESTOQUE, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
            INITCAP(PRODUTO.DS_PRODUTO)         AS        DS_PRODUTO,
            NVL(
                NVL(
                    NVL(Produto.Vl_Custo_Medio,AVG(ITENT_PRO.VL_UNITARIO)),
                    VALOR_INICIAL_PRODUTO.VL_CUSTO_MEDIO
                    ),
                0
                )                                 AS       VL_CUSTO_MEDIO,
            UNI_PRO.DS_UNIDADE,
            ITDEV_FOR.QT_DEVOLVIDA * -1             AS     QUANTIDADE,
            TRUNC(DEV_FOR.DT_DEVOLUCAO)             AS     DT_GERACAO,
            TO_CHAR(DEV_FOR.HR_DEVOLUCAO, 'hh24:mi:ss' ) AS HORA,
            DEV_FOR.CD_DEVOLUCAO                   AS      DOCUMENTO,
            INITCAP( FORNECEDOR.NM_FORNECEDOR )    AS      DS_DESTINO,
            'Dev. P/  Fornecedor'                  AS      OPERACAO,
            (itent_pro.vl_custo_real / uni_pro.vl_fator) AS VALOR,
            ESTOQUE.CD_ESTOQUE                     AS      CD_ESTOQUE,
            INITCAP(ESTOQUE.DS_ESTOQUE)            AS      DS_ESTOQUE,
            UNI_PRO.VL_FATOR                       AS      VL_FATOR,
            '4'                                    AS      TP_ORDEM,
            'N'							           AS      SN_CONSIGNADO,
            0                                      AS      cd_itmvto_estoque
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
            AND TRUNC(DEV_FOR.DT_DEVOLUCAO, 'YYYY-MM-DD') BETWEEN TO_DATE('" & RangeStartText & "', 'YYYY-MM-DD') AND TO_DATE('" & RangeEndText & "', 'YYYY-MM-DD')
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
SELECT * FROM ORIGINAL