

SELECT p.cd_pro_fat,
    p.ds_pro_fat,
    g.ds_gru_pro
FROM pro_fat p
LEFT JOIN gru_pro g ON g.cd_gru_pro = p.cd_gru_pro
WHERE sn_ativo = 'S';



WITH 
    FAT_ITENS_AUX AS
    (
    SELECT
        ib.cd_reg_amb AS COD_REG
        , a.CD_PACIENTE AS COD_PAC
        , ib.cd_atendimento AS COD_ATEND
        , ib.cd_lancamento AS COD_LAC
        , ib.hr_lancamento AS DT_ATEND
        , ib.qt_lancamento AS QNT
        , ib.cd_pro_fat AS COD_PROCEDIMENTO
        , ib.vl_total_conta AS VL_CONTA
        , ib.tp_mvto AS TIPO_MOV
        , ib.cd_prestador AS COD_PREST
        , ib.cd_setor_produziu AS COD_SETOR_PROD
        , rb.DT_REMESSA AS DT_REMESSA
        , ib.SN_PERTENCE_PACOTE AS SN_PACOTE
    FROM
        itreg_amb ib
    LEFT JOIN reg_amb rb ON rb.CD_REG_AMB = ib.CD_REG_AMB
    LEFT JOIN pro_fat pf ON pf.cd_pro_fat = ib.cd_pro_fat
    LEFT JOIN ATENDIME a ON a.CD_ATENDIMENTO = ib.CD_ATENDIMENTO
    UNION ALL
    SELECT 
        if.cd_reg_fat AS COD_REG
        , a.CD_PACIENTE AS COD_PAC
        , rf.cd_atendimento AS COD_ATEND
        , if.cd_lancamento AS COD_LAC
        , if.hr_lancamento AS DT_ATEND
        , if.qt_lancamento AS QNT
        , if.cd_pro_fat AS COD_PROCEDIMENTO
        , if.vl_total_conta AS VL_CONTA
        , if.tp_mvto AS TIPO_MOV
        , if.cd_prestador AS COD_PREST
        , if.cd_setor_produziu AS COD_SETOR_PROD
        , rf.DT_REMESSA AS DT_REMESSA
        , if.SN_PERTENCE_PACOTE AS SN_PACOTE
    FROM 
        itreg_fat if
    LEFT JOIN reg_fat rf ON rf.CD_REG_FAT = if.CD_REG_FAT
    LEFT JOIN pro_fat pf ON pf.cd_pro_fat = if.cd_pro_fat
    LEFT JOIN ATENDIME a ON a.CD_ATENDIMENTO = rf.CD_ATENDIMENTO
)
SELECT * FROM FAT_ITENS_AUX ;







WITH 
    FAT_ITENS AS
    (
    SELECT
        ib.cd_reg_amb COD_REG
        , a.CD_PACIENTE COD_PAC
        , ib.cd_atendimento COD_ATEND
        , ib.cd_lancamento COD_LAC
        , ib.hr_lancamento DT_ATEND
        , TO_CHAR(ib.hr_lancamento, 'MM/YYYY') AS COMPET
        , ib.qt_lancamento QNT
        , ib.cd_pro_fat COD_PROCEDIMENTO
        , ib.vl_total_conta VL_CONTA
        , ib.tp_mvto TIPO_MOV
        , ib.cd_prestador COD_PREST
        , ib.cd_setor_produziu COD_SETOR_PROD
        , rb.DT_REMESSA DT_REMESSA
        , ib.SN_PERTENCE_PACOTE SN_PACOTE
        , DECODE(rb.CD_REMESSA, NULL, 'N/ Faturado', 'Faturado') SITUACAO
        , pf.VL_CUSTO 
        , pf.cd_pro_fat
        , p.CD_PRODUTO
        , p.DS_PRODUTO
        , p.VL_CUSTO_MEDIO
        -- , vcm.prVL_CUSTO_MEDIO
        -- , cm.CMVL_CUSTO_MEDIO_MENSAL
        -- , (ib.qt_lancamento * cm.CMVL_CUSTO_MEDIO_MENSAL) AS MULT
        -- , DBAMV.VL_CUSTO_UNIT(p.cd_produto, 'F', ib.hr_lancamento, ib.hr_lancamento) AS CUSTO_FIXO
        -- , DBAMV.VL_CUSTO_UNIT(p.cd_produto, 'M', ib.hr_lancamento, ib.hr_lancamento) AS CUSTO_MEDIO_PERIODO
        -- , DBAMV.VL_CUSTO_UNIT(p.cd_produto, 'U', ib.hr_lancamento, ib.hr_lancamento) AS ULT_CUSTO_PERIODO
    FROM itreg_amb ib
        LEFT JOIN reg_amb rb ON rb.CD_REG_AMB = ib.CD_REG_AMB
        LEFT JOIN pro_fat pf ON pf.cd_pro_fat = ib.cd_pro_fat
        LEFT JOIN ATENDIME a ON a.CD_ATENDIMENTO = ib.CD_ATENDIMENTO
        LEFT JOIN produto p ON p.cd_pro_fat = pf.cd_pro_fat
    UNION ALL
    SELECT 
        if.cd_reg_fat COD_REG
        , a.CD_PACIENTE COD_PAC
        , rf.cd_atendimento COD_ATEND
        , if.cd_lancamento COD_LAC
        , if.hr_lancamento DT_ATEND
        , TO_CHAR(if.hr_lancamento, 'MM/YYYY') AS COMPET
        , if.qt_lancamento QNT
        , if.cd_pro_fat COD_PROCEDIMENTO
        , if.vl_total_conta VL_CONTA
        , if.tp_mvto TIPO_MOV
        , if.cd_prestador COD_PREST
        , if.cd_setor_produziu COD_SETOR_PROD
        , rf.DT_REMESSA DT_REMESSA
        , if.SN_PERTENCE_PACOTE SN_PACOTE
        , DECODE(rf.CD_REMESSA, NULL, 'N/ Faturado', 'Faturado') SITUACAO
        , pf.VL_CUSTO 
        , if.cd_pro_fat
        , p.CD_PRODUTO
        , p.DS_PRODUTO
        , p.VL_CUSTO_MEDIO
        -- , vcm.prVL_CUSTO_MEDIO
        -- , cm.CMVL_CUSTO_MEDIO_MENSAL
        -- , (if.qt_lancamento * cm.CMVL_CUSTO_MEDIO_MENSAL) AS MULT
        -- , DBAMV.VL_CUSTO_UNIT(p.cd_produto, 'F', if.hr_lancamento, if.hr_lancamento) AS CUSTO_FIXO
        -- , DBAMV.VL_CUSTO_UNIT(p.cd_produto, 'M', if.hr_lancamento, if.hr_lancamento) AS CUSTO_MEDIO_PERIODO
        -- , DBAMV.VL_CUSTO_UNIT(p.cd_produto, 'U', if.hr_lancamento, if.hr_lancamento) AS ULT_CUSTO_PERIODO
    FROM itreg_fat if
        LEFT JOIN reg_fat rf ON rf.CD_REG_FAT = if.CD_REG_FAT
        LEFT JOIN pro_fat pf ON pf.cd_pro_fat = if.cd_pro_fat
        LEFT JOIN ATENDIME a ON a.CD_ATENDIMENTO = rf.CD_ATENDIMENTO
        LEFT JOIN produto p ON p.cd_pro_fat = pf.cd_pro_fat
),
ULTIMO_CUSTO AS
    (
        SELECT 
            cm.CD_CUSTO_MEDIO_MENSAL
            , cm.CD_PRODUTO
            -- , cm.DH_CUSTO_MEDIO
            , TO_CHAR(cm.DH_CUSTO_MEDIO, 'MM/YYYY') AS DH_CUSTO_MEDIO
            , cm.VL_CUSTO_MEDIO AS VL_CUSTO_MEDIO_ULT 
            , AVG(cm.VL_CUSTO_MEDIO) AS VL_CUSTO_MEDIA_MENSAL_ULT
        FROM DBAMV.CUSTO_MEDIO_MENSAL cm 
        GROUP BY cm.CD_CUSTO_MEDIO_MENSAL, cm.CD_PRODUTO, TO_CHAR(cm.DH_CUSTO_MEDIO, 'MM/YYYY'), cm.VL_CUSTO_MEDIO 
),
MEDIA AS
    (
        SELECT 
            cm.CD_CUSTO_MEDIO
            , cm.CD_PRODUTO
            -- , cm.DT_CUSTO
            , TO_CHAR(cm.DT_CUSTO, 'MM/YYYY') AS COMPET
            , SUM(cm.VL_CUSTO_MEDIO) AS SOMADO
            , AVG(cm.VL_CUSTO_MEDIO) AS VL_CUSTO_MEDIO_MEDIA
        FROM DBAMV.CUSTO_MEDIO cm
        GROUP BY cm.CD_CUSTO_MEDIO, cm.CD_PRODUTO, TO_CHAR(cm.DT_CUSTO, 'MM/YYYY'), cm.VL_CUSTO_MEDIO 
)
SELECT DISTINCT
    fi.*
    , uc.VL_CUSTO_MEDIO_ULT
    , uc.VL_CUSTO_MEDIA_MENSAL_ULT
    , m.VL_CUSTO_MEDIO_MEDIA
    , m.SOMADO
FROM FAT_ITENS fi
LEFT JOIN ULTIMO_CUSTO uc
    ON fi.CD_PRODUTO = uc.CD_PRODUTO AND fi.COMPET = uc.DH_CUSTO_MEDIO
LEFT JOIN MEDIA m
    ON fi.CD_PRODUTO = m.CD_PRODUTO AND fi.COMPET = m.COMPET
WHERE fi.COD_ATEND= 119862 AND fi.TIPO_MOV = 'Produto'
;


--COD_ATEND= 119862;




SELECT cm.CD_CUSTO_MEDIO, cm.CD_PRODUTO, cm.DT_CUSTO, cm.VL_CUSTO_MEDIO 
FROM DBAMV.CUSTO_MEDIO cm 
WHERE cm.CD_PRODUTO = 9037003 AND  cm.DT_CUSTO = ( SELECT MAX(cm2.DT_CUSTO) FROM DBAMV.CUSTO_MEDIO cm2 WHERE cm2.CD_PRODUTO = 9037003 ) ; 


SELECT cm.CD_CUSTO_MEDIO_MENSAL, cm.CD_PRODUTO, cm.DH_CUSTO_MEDIO, cm.VL_CUSTO_MEDIO 
FROM DBAMV.CUSTO_MEDIO_MENSAL cm 
WHERE cm.CD_PRODUTO = 9037003 ; 

 AND EXTRACT(MONTH FROM cm.DH_CUSTO_MEDIO)=5 AND EXTRACT(YEAR FROM cm.DH_CUSTO_MEDIO)=2024 AND
      cm.DH_CUSTO_MEDIO IN ( SELECT cm2.DH_CUSTO_MEDIO FROM DBAMV.CUSTO_MEDIO_MENSAL cm2 WHERE cm2.CD_PRODUTO = 9037003 ) ; 



-- QUERY "PRODUTOS" - PAINEL HPC-FATURAMENTO-Produção Geral
WITH PRODUTU AS (
    SELECT
        P.CD_PRO_FAT
        , p.cd_produto
        , p.ds_produto
        , p.tp_ativo
        , vip.vl_unitario
    FROM produto p
    LEFT JOIN ITENT_PRO ip ON IP.CD_PRODUTO = P.CD_PRODUTO
    LEFT JOIN especie e ON E.CD_ESPECIE = P.CD_ESPECIE
    LEFT JOIN 
        (
            SELECT 
                ip.cd_produto
                , ip.vl_unitario
                , ip.dt_gravacao
            FROM 
                itent_pro ip
            JOIN (
                    SELECT 
                        cd_produto
                        , MAX(dt_gravacao) AS max_dt_gravacao
                    FROM 
                        itent_pro
                    GROUP BY cd_produto
                    ) latest ON ip.cd_produto = latest.cd_produto AND ip.dt_gravacao = latest.max_dt_gravacao
        ) vip ON VIP.CD_PRODUTO = P.CD_PRODUTO
    LEFT JOIN custo_medio cm ON cm.CD_CUSTO_MEDIO = ip.CD_CUSTO_MEDIO
    WHERE cd_pro_fat IS NOT NULL
    AND tp_ativo = 'S'
    GROUP BY
        p.cd_pro_fat, 
        p.cd_produto,
        p.ds_produto,
        p.tp_ativo,
        vip.vl_unitario

    UNION ALL
    
    SELECT 
        el.cd_pro_fat,
        NULL cd_produto,
        el.nm_exa_lab ds_produto,
        NULL tp_ativo,
        el.vl_custo
    FROM EXA_LAB el
)
SELECT * FROM PRODUTU WHERE ds_produto LIKE '%OXIGE%';


-- EXECUTANDO FUNCTION ORACLE
DBAMV.VL_CUSTO_UNIT(p.cd_produto, 'F', rf.DT_REMESSA, rf.DT_REMESSA)
TO_DATE('2024-10-26 15:11:00', 'YYYY-MM-DD HH24:MI:SS'));

-- METADADOS
SELECT * FROM user_tab_columns WHERE TABLE_NAME LIKE '%LOTE_REMESSA%' ;



WITH V_CUSTO_REPASSE 
    AS (
        SELECT * FROM DBAMV.PRO_FAT
    )
SELECT * FROM V_CUSTO_REPASSE
;



-- VL_CUSTO_REPASSE
-- VL_CUSTO_MATREEMB
-- VL_CUSTO_MEDICAMENTO
-- VL_CUSTO_GASES
-- VL_CUSTO_DIARIATAXA
-- VL_CUSTO_VARIAVEL
-- VL_CUSTO_FIXO
-- VL_CTV
-- VL_DIARIA_FIXO
-- VL_DIARIA_VARIAVEL
-- VL_PROCEDIMENTO_FIXO
-- VL_PROCEDIMENTO_VAR
-- VL_TERCEIRO_FIXO
-- VL_TERCEIRO_VAR
-- VL_CUSTO_MATMED_OPME
-- VL_CUSTO_MATMED_SEM_OPME
