---- Nova Linha ---- -- 24/07/2026 17:06:40

BEGIN PKG_MV_FILTRO.PRC_MV_APAGA_VALOR(); END;
---- Nova Linha ---- -- 24/07/2026 17:06:40

BEGIN PKG_MV_FILTRO.PRC_MV_ADD_VALOR(:1 , :2 ); END;
---- Nova Linha ---- -- 24/07/2026 17:06:40

BEGIN :1 := FNC_MV_PARAMETRO_DEFAULT(:2 , :3 ); END;
---- Nova Linha ---- -- 24/07/2026 17:06:40

SELECT NVL(HOSPITAL.TP_DEFAULT_SAIDA_REPORTS, 'I'),NVL(HOSPITAL.TP_DEFAULT_IMPRESSAO_REPORTS , 'C')
    FROM HOSPITAL
        Where Cd_Multi_Empresa = Pkg_Mv2000.Le_Empresa
---- Nova Linha ---- -- 24/07/2026 17:06:40

select *
    from (select convenio.cd_convenio codigo,nm_convenio descricao
        from convenio, empresa_convenio
            WHERE Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
                AND Empresa_Convenio.Cd_Multi_Empresa = 1 order by nm_convenio)
                where rownum < 1
---- Nova Linha ---- -- 24/07/2026 17:06:45

select *
    from (Select CODIGO Codigo, DESCRICAO Descricao, 'A' Aux1, 'A' Aux2
        From (select convenio.cd_convenio codigo,nm_convenio descricao
            from convenio, empresa_convenio
                WHERE CONVENIO.CD_CONVENIO = '10'
                    and Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
                    AND Empresa_Convenio.Cd_Multi_Empresa = 1 order by nm_convenio))
                    where rownum < 1
---- Nova Linha ---- -- 24/07/2026 17:06:45

SELECT *
    FROM (SELECT ROWNUM
        AS RECNUM, f2n_table.*
        from (Select CODIGO Codigo, DESCRICAO Descricao, 'A' Aux1, 'A' Aux2
            From (select convenio.cd_convenio codigo,nm_convenio descricao
                from convenio, empresa_convenio
                    WHERE CONVENIO.CD_CONVENIO = '10'
                        and Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
                        AND Empresa_Convenio.Cd_Multi_Empresa = 1 order by nm_convenio)) f2n_table
                        WHERE ROWNUM <= :1 )
                            WHERE RECNUM >= :2
---- Nova Linha ---- -- 24/07/2026 17:06:52

DECLARE PROCEDURE wrapper(RETURN_VALUE OUT Number, P_CD_MULTI_EMPRESA
IN Number, P_CD_MOEDA_PADRAO
IN VarChar2, P_CD_MOEDA_CONVERSAO
IN VarChar2, P_DT_LANCAMENTO
IN Date, P_VL_MOEDA
IN Number, P_VL_MOEDA_CONVERTIDA OUT Number, P_DT_INDICE_MOEDA OUT Date, P_CD_INDICE_MOEDA OUT Number, P_VL_INDICE_MOEDA_USUARIO
IN Number, P_INVERTE
IN INTEGER)
as VAL_P_INVERTE BOOLEAN;
begin PKG_XML_HTML.Init; VAL_P_INVERTE := PKG_XML_HTML.IntToBool(P_INVERTE); RETURN_VALUE := CONVERTE_MOEDA(P_CD_MULTI_EMPRESA, P_CD_MOEDA_PADRAO, P_CD_MOEDA_CONVERSAO, P_DT_LANCAMENTO, P_VL_MOEDA, P_VL_MOEDA_CONVERTIDA, P_DT_INDICE_MOEDA, P_CD_INDICE_MOEDA, VAL_P_INVERTE, P_VL_INDICE_MOEDA_USUARIO); end;
BEGIN wrapper(:RETURN_VALUE, :P_CD_MULTI_EMPRESA, :P_CD_MOEDA_PADRAO, :P_CD_MOEDA_CONVERSAO, :P_DT_LANCAMENTO, :P_VL_MOEDA, :P_VL_MOEDA_CONVERTIDA, :P_DT_INDICE_MOEDA, :P_CD_INDICE_MOEDA, :P_VL_INDICE_MOEDA_USUARIO, :P_INVERTE); END;
---- Nova Linha ---- -- 24/07/2026 17:06:52

SELECT 'e:\mv2000' nm_path_sistema, 'svrmvreports' nm_reports_server, 8890 nr_porta_reports_server
    FROM dbamv.hospital
---- Nova Linha ---- -- 24/07/2026 17:06:52

SELECT sn_ativo_rel_especifico, cd_sistema_dono pasta_sistema
    FROM dbasgu.modulos
        WHERE cd_modulo = upper(:1 )
---- Nova Linha ---- -- 24/07/2026 17:06:52

SELECT cd_parametro
    FROM dbasgu.param_modulo
        WHERE cd_modulo = Upper(:1 )
            AND (cd_parametro) NOT
            IN ('DESTYPE', 'COPIES', 'DESNAME', 'MODE', 'PARAMFORM', 'DESFORMAT')
---- Nova Linha ---- -- 24/07/2026 17:06:52

SELECT Sn_Armazena_Parametro
    FROM Dbasgu.Modulos
        WHERE Cd_Modulo = upper(:1 )
            AND Tp_Modulo = 'R'
---- Nova Linha ---- -- 24/07/2026 17:06:52

SELECT MM.CD_MOEDA
    FROM DBAMV.MOEDA_MULTI_EMPRESA MM, DBAMV.MOEDA M
        WHERE MM.CD_MOEDA = M.CD_MOEDA
            AND MM.CD_MULTI_EMPRESA = :1
            AND M.CD_MOEDA = :2
---- Nova Linha ---- -- 24/07/2026 17:07:02

SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "FATURA#0", ROWS=72) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "FATURA#0", "IND_FATURA_2_IX", ROWS=72) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "FATURA#0", "IND_FATURA_2_IX", ROWS=3359) */ SUM(C1)
    FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "REMESSA_FATURA#1") */ 1
        AS C1
        FROM "DBAMV"."REMESSA_FATURA" "REMESSA_FATURA#1", "DBAMV"."FATURA" "FATURA#0"
            WHERE (TO_CHAR("FATURA#0"."DT_COMPETENCIA",'MM/YYYY')='03/2026')
                AND ("FATURA#0"."CD_MULTI_EMPRESA"=:B1)
                AND ("REMESSA_FATURA#1"."CD_FATURA"="FATURA#0"."CD_FATURA")) innerQuery
---- Nova Linha ---- -- 24/07/2026 17:07:02

SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "FATURA#1", ROWS=72) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "FATURA#1", "IND_FATURA_2_IX", ROWS=3359) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "FATURA#1", "IND_FATURA_2_IX", ROWS=72) */ SUM(C1)
    FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "REMESSA_FATURA#2") */ 1
        AS C1
        FROM "DBAMV"."REMESSA_FATURA" "REMESSA_FATURA#2", "DBAMV"."FATURA" "FATURA#1"
            WHERE (TO_CHAR("FATURA#1"."DT_COMPETENCIA",'MM/YYYY')='03/2026')
                AND ("FATURA#1"."CD_MULTI_EMPRESA"=:B1)
                AND ("REMESSA_FATURA#2"."CD_FATURA"="FATURA#1"."CD_FATURA")) innerQuery
---- Nova Linha ---- -- 24/07/2026 17:07:02

SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
    FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "REMESSA_FATURA#1") */ 1
        AS C1
        FROM "DBAMV"."REMESSA_FATURA" "REMESSA_FATURA#1", "DBAMV"."FATURA" "FATURA#0"
            WHERE (TO_CHAR("FATURA#0"."DT_COMPETENCIA",'MM/YYYY')='03/2026')
                AND ("REMESSA_FATURA#1"."CD_FATURA"="FATURA#0"."CD_FATURA")) innerQuery
---- Nova Linha ---- -- 24/07/2026 17:07:02

SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
    FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "REMESSA_FATURA#0") */ 1
        AS C1
        FROM "DBAMV"."REMESSA_FATURA" "REMESSA_FATURA#0", "DBAMV"."FATURA" "FATURA#1"
            WHERE (TO_CHAR("FATURA#1"."DT_COMPETENCIA",'MM/YYYY')='03/2026')
                AND ("REMESSA_FATURA#0"."CD_FATURA"="FATURA#1"."CD_FATURA")) innerQuery
---- Nova Linha ---- -- 24/07/2026 17:07:02

BEGIN :1 := MOEDA_PADRAO(:2 ); END;
---- Nova Linha ---- -- 24/07/2026 17:07:03

SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "FATURA#2", "IND_FATURA_2_IX", ROWS=3359) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "FATURA#2", "IND_FATURA_2_IX", ROWS=72) OPT_ESTIMATE(@"innerQuery", TABLE, "FATURA#2", ROWS=72) */ SUM(C1)
    FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "REMESSA_FATURA#3") */ 1
        AS C1
        FROM "DBAMV"."REMESSA_FATURA" "REMESSA_FATURA#3", "DBAMV"."FATURA" "FATURA#2"
            WHERE (TO_CHAR("FATURA#2"."DT_COMPETENCIA",'MM/YYYY')='03/2026')
                AND ("FATURA#2"."CD_MULTI_EMPRESA"=:B1)
                AND ("REMESSA_FATURA#3"."CD_FATURA"="FATURA#2"."CD_FATURA")) innerQuery
---- Nova Linha ---- -- 24/07/2026 17:07:03

SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "FATURA", ROWS=72) */ C1, C2, C3
    FROM (SELECT /*+ qb_name("innerQuery") INDEX( "FATURA" "IND_FATURA_2_IX") */ COUNT(*)
        AS C1, 4294967295
        AS C2, SUM(CASE WHEN (TO_CHAR("FATURA"."DT_COMPETENCIA",'MM/YYYY')='03/2026')
        THEN 1
        ELSE 0 END)
        AS C3
        FROM "DBAMV"."FATURA" "FATURA"
            WHERE ("FATURA"."CD_MULTI_EMPRESA"=:B1)) innerQuery
---- Nova Linha ---- -- 24/07/2026 17:07:03

SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
    FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "FATURA") */ 1
        AS C1
        FROM "DBAMV"."FATURA" "FATURA"
            WHERE (TO_CHAR("FATURA"."DT_COMPETENCIA",'MM/YYYY')='03/2026')
                AND ("FATURA"."CD_MULTI_EMPRESA"=:B1)) innerQuery
---- Nova Linha ---- -- 24/07/2026 17:07:04

SELECT NR_CASA_DECIMAL
    FROM DBAMV.MULTI_EMPRESAS , DBAMV.MOEDA
        WHERE NVL(MULTI_EMPRESAS.SN_UTILIZA_MOEDA,'N') = 'S'
            AND MULTI_EMPRESAS.CD_MOEDA = MOEDA.CD_MOEDA
            AND MULTI_EMPRESAS.CD_MULTI_EMPRESA = NVL(:1 , DBAMV.PKG_MV2000.LE_EMPRESA)
---- Nova Linha ---- -- 24/07/2026 17:07:04

SELECT hospital.ds_rodape_reports
    FROM hospital hospital
        WHERE Hospital.Cd_Multi_Empresa = :1
---- Nova Linha ---- -- 24/07/2026 17:07:04

SELECT ds_multi_empresa
    FROM multi_empresas
        WHERE cd_multi_empresa = :1
---- Nova Linha ---- -- 24/07/2026 17:07:04

SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ C1, C2, C3
    FROM (SELECT /*+ qb_name("innerQuery") INDEX( "MULTI_EMPRESAS" "ME_PK") */ COUNT(*)
        AS C1, 4294967295
        AS C2, COUNT(*)
        AS C3
        FROM "DBAMV"."MULTI_EMPRESAS" "MULTI_EMPRESAS"
            WHERE ("MULTI_EMPRESAS"."CD_MULTI_EMPRESA"=NVL(:B1,"DBAMV"."PKG_MV2000"."LE_EMPRESA"()))) innerQuery
---- Nova Linha ---- -- 24/07/2026 17:07:05

SELECT CONVENIO.cd_CONVENIO,CONVENIO.nm_CONVENIO
    from DBAMV.CONVENIO CONVENIO ,Dbamv.Empresa_Convenio
        Where Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
            And Empresa_Convenio.Cd_Multi_Empresa = :1
            AND CONVENIO.CD_CONVENIO = '10' order by CONVENIO.nm_CONVENIO
---- Nova Linha ---- -- 24/07/2026 17:07:05

DECLARE PROCEDURE wrapper(RETURN_VALUE OUT Number, P_CD_MULTI_EMPRESA
IN Number, P_CD_MOEDA_PADRAO
IN VarChar2, P_CD_MOEDA_CONVERSAO
IN VarChar2, P_DT_LANCAMENTO
IN Date, P_VL_MOEDA
IN Number, P_VL_MOEDA_CONVERTIDA OUT Number, P_DT_INDICE_MOEDA OUT Date, P_CD_INDICE_MOEDA OUT Number, P_INVERTE
IN INTEGER)
as VAL_P_INVERTE BOOLEAN;
begin PKG_XML_HTML.Init; VAL_P_INVERTE := PKG_XML_HTML.IntToBool(P_INVERTE); RETURN_VALUE := CONVERTE_MOEDA(P_CD_MULTI_EMPRESA, P_CD_MOEDA_PADRAO, P_CD_MOEDA_CONVERSAO, P_DT_LANCAMENTO, P_VL_MOEDA, P_VL_MOEDA_CONVERTIDA, P_DT_INDICE_MOEDA, P_CD_INDICE_MOEDA, VAL_P_INVERTE); end;
BEGIN wrapper(:RETURN_VALUE, :P_CD_MULTI_EMPRESA, :P_CD_MOEDA_PADRAO, :P_CD_MOEDA_CONVERSAO, :P_DT_LANCAMENTO, :P_VL_MOEDA, :P_VL_MOEDA_CONVERTIDA, :P_DT_INDICE_MOEDA, :P_CD_INDICE_MOEDA, :P_INVERTE); END;
---- Nova Linha ---- -- 24/07/2026 17:07:05

SELECT hospital.ds_rodape_reports
    FROM dbamv.hospital hospital
        WHERE Hospital.Cd_Multi_Empresa = :1
---- Nova Linha ---- -- 24/07/2026 17:07:05

SELECT
    CD_REMESSA,
    DT_ABERTURA,
    DT_FECHAMENTO,
    DT_ENTREGA_DA_FATURA,
    DT_PREVISTA_PARA_PGTO,
    NVL(DS_PROTOCOLO_RECEB_TISS,DS_PROTOCOLO_ENVIO_TISS) DS_PROTOCOLO_TISS,
    CD_CONVENIO,
    NM_CONVENIO,
    Sum(QTD) QTD,
    Sum(VL_FATURADO) VL_REMESSA_FATURADO,
    Sum(VL_AUDITADO) VL_REMESSA_AUDITADO,
    Sum(VL_LIBERADO)VL_REMESSA_LIBERADO
    FROM (SELECT REMESSA_FATURA.CD_REMESSA, REMESSA_FATURA.DT_ABERTURA, REMESSA_FATURA.DT_FECHAMENTO, REMESSA_FATURA.DT_ENTREGA_DA_FATURA, REMESSA_FATURA.DT_PREVISTA_PARA_PGTO, REMESSA_FATURA.DS_PROTOCOLO_ENVIO_TISS, REMESSA_FATURA.DS_PROTOCOLO_RECEB_TISS, REG_FAT.CD_CONVENIO, CONVENIO.NM_CONVENIO, COUNT(DISTINCT REG_FAT.CD_REG_FAT) QTD, Sum(DBAMV.FNC_FFCV_VL_ORIGINAL_CONTA(REG_FAT.CD_REG_FAT, 'H')) VL_FATURADO, Sum(REG_FAT.VL_TOTAL_CONTA) VL_LIBERADO, Sum((DBAMV.FNC_FFCV_VL_ORIGINAL_CONTA(REG_FAT.CD_REG_FAT, 'H') - REG_FAT.VL_TOTAL_CONTA)) VL_AUDITADO
        FROM DBAMV.REMESSA_FATURA, DBAMV.FATURA, DBAMV.REG_FAT, DBAMV.CONVENIO, DBAMV.AGRUPAMENTO
            WHERE REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA
                AND REMESSA_FATURA.CD_REMESSA = REG_FAT.CD_REMESSA
                AND REG_FAT.CD_CONVENIO = CONVENIO.CD_CONVENIO
                AND CONVENIO.TP_CONVENIO NOT
                IN ('H','A')
                AND FATURA.CD_MULTI_EMPRESA = REG_FAT.CD_MULTI_EMPRESA
                AND REG_FAT.CD_MULTI_EMPRESA = :1
                AND AGRUPAMENTO.CD_AGRUPAMENTO(+) = REMESSA_FATURA.CD_AGRUPAMENTO
                and to_char(fatura.dt_competencia, 'MM/YYYY') = '03/2026'
                AND CONVENIO.CD_CONVENIO = '10' GROUP BY REMESSA_FATURA.CD_REMESSA, REMESSA_FATURA.DT_ABERTURA, REMESSA_FATURA.DT_FECHAMENTO, REMESSA_FATURA.DT_ENTREGA_DA_FATURA, REMESSA_FATURA.DT_PREVISTA_PARA_PGTO, REMESSA_FATURA.DS_PROTOCOLO_ENVIO_TISS, REMESSA_FATURA.DS_PROTOCOLO_RECEB_TISS, REG_FAT.CD_CONVENIO, CONVENIO.NM_CONVENIO, REG_FAT.CD_REG_FAT UNION ALL
                SELECT REMESSA_FATURA.CD_REMESSA, REMESSA_FATURA.DT_ABERTURA, REMESSA_FATURA.DT_FECHAMENTO, REMESSA_FATURA.DT_ENTREGA_DA_FATURA, REMESSA_FATURA.DT_PREVISTA_PARA_PGTO, REMESSA_FATURA.DS_PROTOCOLO_ENVIO_TISS, REMESSA_FATURA.DS_PROTOCOLO_RECEB_TISS, REG_AMB.CD_CONVENIO, CONVENIO.NM_CONVENIO, COUNT(DISTINCT REG_AMB.CD_REG_AMB) QTD, DBAMV.FNC_FFCV_VL_ORIGINAL_CONTA(REG_AMB.CD_REG_AMB, 'A') VL_FATURADO, sum(decode(nvl(itreg_amb.tp_pagamento, 'X'),'C',0,decode( nvl(itreg_amb.sn_pertence_pacote,'N'),'S',0,itreg_amb.vl_total_conta))) VL_LIBERADO, (DBAMV.FNC_FFCV_VL_ORIGINAL_CONTA(REG_AMB.CD_REG_AMB, 'A') - sum(decode(nvl(itreg_amb.tp_pagamento, 'X'),'C',0, decode( nvl(itreg_amb.sn_pertence_pacote,'N'),'S',0,itreg_amb.vl_total_conta)))) VL_AUDITADO
                    FROM DBAMV.REMESSA_FATURA, DBAMV.FATURA, DBAMV.REG_AMB, DBAMV.ITREG_AMB, DBAMV.CONVENIO, DBAMV.AGRUPAMENTO
                        WHERE REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA
                            AND REMESSA_FATURA.CD_REMESSA = REG_AMB.CD_REMESSA
                            AND REG_AMB.CD_REG_AMB = ITREG_AMB.CD_REG_AMB
                            AND REG_AMB.CD_CONVENIO = CONVENIO.CD_CONVENIO
                            AND CONVENIO.TP_CONVENIO NOT
                            IN ('H','A')
                            AND FATURA.CD_MULTI_EMPRESA = REG_AMB.CD_MULTI_EMPRESA
                            AND REG_AMB.CD_MULTI_EMPRESA = :2
                            AND AGRUPAMENTO.CD_AGRUPAMENTO(+) = REMESSA_FATURA.CD_AGRUPAMENTO
                            and to_char(fatura.dt_competencia, 'MM/YYYY') = '03/2026'
                            AND CONVENIO.CD_CONVENIO = '10' GROUP BY REMESSA_FATURA.CD_REMESSA, REMESSA_FATURA.DT_ABERTURA, REMESSA_FATURA.DT_FECHAMENTO, REMESSA_FATURA.DT_ENTREGA_DA_FATURA, REMESSA_FATURA.DT_PREVISTA_PARA_PGTO, REMESSA_FATURA.DS_PROTOCOLO_ENVIO_TISS, REMESSA_FATURA.DS_PROTOCOLO_RECEB_TISS, REG_AMB.CD_CONVENIO, CONVENIO.NM_CONVENIO, REG_AMB.CD_REG_AMB ) GROUP BY CD_REMESSA, DT_ABERTURA, DT_FECHAMENTO, DT_ENTREGA_DA_FATURA, DT_PREVISTA_PARA_PGTO, NVL(DS_PROTOCOLO_RECEB_TISS,DS_PROTOCOLO_ENVIO_TISS), CD_CONVENIO, NM_CONVENIO ORDER BY NM_CONVENIO, CD_REMESSA
---- Nova Linha ---- -- 24/07/2026 17:07:06

BEGIN PRC_RELATORIOS_EXECUTADOS(:1 , :2 , :3 ); END;
