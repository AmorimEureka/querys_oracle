
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- select dbamv.SEQ_REGISTRO_AUDITORIA.nextval
--     from dual
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") INDEX( "THIS_" "IND_PW_DOCUM_CLINIC_LIST_5") */ COUNT(*)
--         AS C1, 4294967295
--         AS C2, COUNT(*)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_"
--             WHERE ("THIS_"."TP_STATUS"=:B1
--                 OR "THIS_"."TP_STATUS"=:B2
--                 OR "THIS_"."TP_STATUS"=:B3)
--                 AND ("THIS_"."CD_PACIENTE"=:B4)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 1
--         AS C1
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(38.1441, 8) SEED(5) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)
--                 AND ("THIS_"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_"."TP_STATUS"=:B3
--                 OR "THIS_"."TP_STATUS"=:B4
--                 OR "THIS_"."TP_STATUS"=:B5)) innerQuery

-- SELECT
--     *
-- FROM DBAMV.PW_DOCUMENTO_CLINICO
-- WHERE
--     CD_DOCUMENTO_CLINICO IN( 2658610 , 2656985)
--     -- CD_ATENDIMENTO = 290854
-- ;







-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_#3", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SKIP_SCAN, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=1) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "ATENDIMENT3_#1") */ 1
--         AS C1
--         FROM "DBAMV"."ATENDIME" "ATENDIMENT3_#1", "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_#3"
--             WHERE ("THIS_#3"."CD_PACIENTE"=:B1)
--                 AND ("THIS_#3"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_#3"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_#3"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_#3"."TP_STATUS"=:B3
--                 OR "THIS_#3"."TP_STATUS"=:B4
--                 OR "THIS_#3"."TP_STATUS"=:B5)
--                 AND ("THIS_#3"."CD_ATENDIMENTO"="ATENDIMENT3_#1"."CD_ATENDIMENTO"(+))) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") INDEX( "THIS_" "IND_PW_DOCUM_CLINC_PACIEN_FK") */ COUNT(*)
--         AS C1, 4294967295
--         AS C2, COUNT(*)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 4294967295
--         AS C1, COUNT(*)
--         AS C2, SUM(CASE WHEN ("THIS_"."TP_STATUS"=:B1
--         OR "THIS_"."TP_STATUS"=:B2
--         OR "THIS_"."TP_STATUS"=:B3)
--         AND ("THIS_"."CD_PACIENTE"=:B4)
--         THEN 1
--         ELSE 0 END)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 4294967295
--         AS C1, COUNT(*)
--         AS C2, SUM(CASE WHEN ("THIS_"."TP_STATUS"=:B1
--         OR "THIS_"."TP_STATUS"=:B2
--         OR "THIS_"."TP_STATUS"=:B3)
--         AND ("THIS_"."CD_PACIENTE"=:B4)
--         THEN 1
--         ELSE 0 END)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(76.2881, 8) SEED(6) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- select count(empresaext0_.CD_EMPRESA_EXTERNA)
--     as col_0_0_
--     from dbamv.PW_EMPRESA_EXTERNA empresaext0_
--         where empresaext0_.CD_MULTI_EMPRESA=1
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_#3", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SKIP_SCAN, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=1) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "ATENDIMENT3_#1") */ 1
--         AS C1
--         FROM "DBAMV"."ATENDIME" SAMPLE BLOCK(26.3657, 8) SEED(3) "ATENDIMENT3_#1", "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_#3"
--             WHERE ("THIS_#3"."CD_PACIENTE"=:B1)
--                 AND ("THIS_#3"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_#3"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_#3"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_#3"."TP_STATUS"=:B3
--                 OR "THIS_#3"."TP_STATUS"=:B4
--                 OR "THIS_#3"."TP_STATUS"=:B5)
--                 AND ("THIS_#3"."CD_ATENDIMENTO"="ATENDIMENT3_#1"."CD_ATENDIMENTO"(+))) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_#3", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SKIP_SCAN, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=1) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "ATENDIMENT3_#1") */ 1
--         AS C1
--         FROM "DBAMV"."ATENDIME" SAMPLE BLOCK(13.1828, 8) SEED(2) "ATENDIMENT3_#1", "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_#3"
--             WHERE ("THIS_#3"."CD_PACIENTE"=:B1)
--                 AND ("THIS_#3"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_#3"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_#3"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_#3"."TP_STATUS"=:B3
--                 OR "THIS_#3"."TP_STATUS"=:B4
--                 OR "THIS_#3"."TP_STATUS"=:B5)
--                 AND ("THIS_#3"."CD_ATENDIMENTO"="ATENDIMENT3_#1"."CD_ATENDIMENTO"(+))) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 4294967295
--         AS C1, COUNT(*)
--         AS C2, SUM(CASE WHEN ("THIS_"."TP_STATUS"=:B1
--         OR "THIS_"."TP_STATUS"=:B2
--         OR "THIS_"."TP_STATUS"=:B3)
--         AND ("THIS_"."CD_PACIENTE"=:B4)
--         THEN 1
--         ELSE 0 END)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(2.384, 8) SEED(1) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00
-- insert into dbamv.REGISTRO_AUDITORIA (TP_REGISTRO_AUDITORIA, NM_MAQUINA_REGISTRO_AUDITORIA, CD_USUARIO_REGISTRO_AUDITORIA, DS_MODULO_AUDITORIA, VL_REGISTRO_AUDITORIA, NM_PERFIL_USUARIO, CD_DOCUMENTO_CLINICO, CD_ATENDIMENTO, CD_PRODUTO, NM_SERVIDOR, CD_REGISTRO_AUDITORIA) values (:1 , :2 , :3 , :4 , :5 , :6 , :7 , :8 , :9 , :10 , :11 )
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00
-- insert into dbamv.REGISTRO_AUDITORIA (TP_REGISTRO_AUDITORIA, NM_MAQUINA_REGISTRO_AUDITORIA, CD_USUARIO_REGISTRO_AUDITORIA, DS_MODULO_AUDITORIA, VL_REGISTRO_AUDITORIA, NM_PERFIL_USUARIO, CD_DOCUMENTO_CLINICO, CD_ATENDIMENTO, CD_PRODUTO, NM_SERVIDOR, CD_REGISTRO_AUDITORIA) values (:1 , :2 , :3 , :4 , :5 , :6 , :7 , :8 , :9 , :10 , :11 )
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00







-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 4294967295
--         AS C1, COUNT(*)
--         AS C2, SUM(CASE WHEN ("THIS_"."TP_STATUS"=:B1
--         OR "THIS_"."TP_STATUS"=:B2
--         OR "THIS_"."TP_STATUS"=:B3)
--         AND ("THIS_"."CD_PACIENTE"=:B4)
--         THEN 1
--         ELSE 0 END)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(9.53601, 8) SEED(3) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") INDEX( "THIS_" "IND_PW_DOCUM_CLINC_PACIEN_FK") */ COUNT(*)
--         AS C1, 4294967295
--         AS C2, COUNT(*)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- BEGIN dbms_application_info.SET_CLIENT_INFO(:1 ) ; END;
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") INDEX( "THIS_" "IND_PW_DOCUM_CLINIC_LIST_5") */ COUNT(*)
--         AS C1, 4294967295
--         AS C2, COUNT(*)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_"
--             WHERE ("THIS_"."TP_STATUS"=:B1
--                 OR "THIS_"."TP_STATUS"=:B2
--                 OR "THIS_"."TP_STATUS"=:B3)
--                 AND ("THIS_"."CD_PACIENTE"=:B4)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 1
--         AS C1
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(2.384, 8) SEED(1) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)
--                 AND ("THIS_"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_"."TP_STATUS"=:B3
--                 OR "THIS_"."TP_STATUS"=:B4
--                 OR "THIS_"."TP_STATUS"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- BEGIN DBAMV.PKG_MV_VARIAVEIS.PRC_SET_USUARIO(:1 ) ; END;
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 4294967295
--         AS C1, COUNT(*)
--         AS C2, SUM(CASE WHEN ("THIS_"."TP_STATUS"=:B1
--         OR "THIS_"."TP_STATUS"=:B2
--         OR "THIS_"."TP_STATUS"=:B3)
--         AND ("THIS_"."CD_PACIENTE"=:B4)
--         THEN 1
--         ELSE 0 END)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(4.76801, 8) SEED(2) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_#3", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SKIP_SCAN, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=1) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "ATENDIMENT3_#1") */ 1
--         AS C1
--         FROM "DBAMV"."ATENDIME" SAMPLE BLOCK(6.59141, 8) SEED(1) "ATENDIMENT3_#1", "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_#3"
--             WHERE ("THIS_#3"."CD_PACIENTE"=:B1)
--                 AND ("THIS_#3"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_#3"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_#3"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_#3"."TP_STATUS"=:B3
--                 OR "THIS_#3"."TP_STATUS"=:B4
--                 OR "THIS_#3"."TP_STATUS"=:B5)
--                 AND ("THIS_#3"."CD_ATENDIMENTO"="ATENDIMENT3_#1"."CD_ATENDIMENTO"(+))) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 4294967295
--         AS C1, COUNT(*)
--         AS C2, SUM(CASE WHEN ("THIS_"."TP_STATUS"=:B1
--         OR "THIS_"."TP_STATUS"=:B2
--         OR "THIS_"."TP_STATUS"=:B3)
--         AND ("THIS_"."CD_PACIENTE"=:B4)
--         THEN 1
--         ELSE 0 END)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(38.1441, 8) SEED(5) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- select trunc(DH_CRIACAO)
--     as fechado, count(*)
--     as y1_
--     from dbamv.PW_DOCUMENTO_CLINICO this_ inner join dbamv.PW_TIPO_DOCUMENTO tipodocume2_
--         on this_.CD_TIPO_DOCUMENTO=tipodocume2_.CD_TIPO_DOCUMENTO left outer join dbamv.ATENDIME atendiment3_
--         on this_.CD_ATENDIMENTO=atendiment3_.CD_ATENDIMENTO left outer join dbamv.PAGU_OBJETO objeto1_
--         on this_.CD_OBJETO=objeto1_.CD_OBJETO
--         where (objeto1_.TP_OBJETO is null
--             or objeto1_.TP_OBJETO<>:1
--             or (objeto1_.TP_OBJETO=:2
--             and this_.CD_USUARIO_AUTORIZADOR is null))
--             and (atendiment3_.CD_MULTI_EMPRESA is null
--             or atendiment3_.CD_MULTI_EMPRESA not
--             in (select multiempre1_.CD_MULTI_EMPRESA
--             as y0_
--             from dbamv.PW_EMPRESA_EXTERNA this_ inner join dbamv.MULTI_EMPRESAS multiempre1_
--                 on this_.CD_MULTI_EMPRESA=multiempre1_.CD_MULTI_EMPRESA))
--                 and this_.tp_status
--                 in (:3 , :4 , :5 )
--                 and ((tipodocume2_.SN_PRONTUARIO=:6
--                 and not exists (select paguObjetoParametro_.CD_PARAMETRO_PAGU_OBJETO
--                 as y0_, paguObjetoParametro_.CD_OBJETO
--                 as y1_
--                 from dbamv.PAGU_OBJETO_PARAMETRO paguObjetoParametro_ inner join dbamv.PW_PARAMETRO_PAGU_OBJETO parametrop1_
--                     on paguObjetoParametro_.CD_PARAMETRO_PAGU_OBJETO=parametrop1_.CD_PARAMETRO_PAGU_OBJETO
--                     and ( parametrop1_.NM_PARAMETRO=:7 )
--                     where objeto1_.CD_OBJETO=paguObjetoParametro_.CD_OBJETO))
--                         or exists (select paguObjetoParametro_.CD_PARAMETRO_PAGU_OBJETO
--                         as y0_, paguObjetoParametro_.CD_OBJETO
--                         as y1_
--                         from dbamv.PAGU_OBJETO_PARAMETRO paguObjetoParametro_ inner join dbamv.PW_PARAMETRO_PAGU_OBJETO parametrop1_
--                             on paguObjetoParametro_.CD_PARAMETRO_PAGU_OBJETO=parametrop1_.CD_PARAMETRO_PAGU_OBJETO
--                             and ( parametrop1_.NM_PARAMETRO=:8 )
--                             where objeto1_.CD_OBJETO=paguObjetoParametro_.CD_OBJETO
--                                 and paguObjetoParametro_.VL_PARAMETRO=:9 ))
--                                 and this_.CD_PACIENTE=:10
--                                 and (this_.SN_CONFIDENCIAL=:11
--                                 or this_.SN_CONFIDENCIAL is null)
--                                 and this_.DH_FECHAMENTO is not null group by trunc(DH_CRIACAO) order by fechado desc
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 1
--         AS C1
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(4.76801, 8) SEED(2) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)
--                 AND ("THIS_"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_"."TP_STATUS"=:B3
--                 OR "THIS_"."TP_STATUS"=:B4
--                 OR "THIS_"."TP_STATUS"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 1
--         AS C1
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)
--                 AND ("THIS_"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_"."TP_STATUS"=:B3
--                 OR "THIS_"."TP_STATUS"=:B4
--                 OR "THIS_"."TP_STATUS"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_#3", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SKIP_SCAN, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=1) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "ATENDIMENT3_#1") */ 1
--         AS C1
--         FROM "DBAMV"."ATENDIME" SAMPLE BLOCK(52.7313, 8) SEED(4) "ATENDIMENT3_#1", "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_#3"
--             WHERE ("THIS_#3"."CD_PACIENTE"=:B1)
--                 AND ("THIS_#3"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_#3"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_#3"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_#3"."TP_STATUS"=:B3
--                 OR "THIS_#3"."TP_STATUS"=:B4
--                 OR "THIS_#3"."TP_STATUS"=:B5)
--                 AND ("THIS_#3"."CD_ATENDIMENTO"="ATENDIMENT3_#1"."CD_ATENDIMENTO"(+))) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- select To_Char(SYSDATE, 'dd/mm/yyyy')||' '||To_Char(SYSDATE, 'hh24:mi:ss')
--     from dual
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- BEGIN DBAMV.pkg_pagu.Pr_Setor(:1 ) ; END;
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_#3", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_#3", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_#3", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_SKIP_SCAN, "THIS_#3", "IND_PW_DOC_PER_IX", ROWS=1) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "TIPODOCUME2_#2") */ 1
--         AS C1
--         FROM "DBAMV"."PW_TIPO_DOCUMENTO" "TIPODOCUME2_#2", "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_#3"
--             WHERE ("THIS_#3"."CD_PACIENTE"=:B1)
--                 AND ("THIS_#3"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_#3"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_#3"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_#3"."TP_STATUS"=:B3
--                 OR "THIS_#3"."TP_STATUS"=:B4
--                 OR "THIS_#3"."TP_STATUS"=:B5)
--                 AND ("TIPODOCUME2_#2"."SN_PRONTUARIO"=:B6)
--                 AND ("THIS_#3"."CD_TIPO_DOCUMENTO"="TIPODOCUME2_#2"."CD_TIPO_DOCUMENTO")) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") INDEX( "THIS_" "IND_PW_DOCUM_CLINIC_LIST_13") */ COUNT(*)
--         AS C1, 4294967295
--         AS C2, COUNT(*)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- BEGIN DBAMV.PKG_MV2000.ATRIBUI_EMPRESA(:1 ) ; END;
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 1
--         AS C1
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(9.53601, 8) SEED(3) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)
--                 AND ("THIS_"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_"."TP_STATUS"=:B3
--                 OR "THIS_"."TP_STATUS"=:B4
--                 OR "THIS_"."TP_STATUS"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 1
--         AS C1
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(76.2881, 8) SEED(6) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)
--                 AND ("THIS_"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_"."TP_STATUS"=:B3
--                 OR "THIS_"."TP_STATUS"=:B4
--                 OR "THIS_"."TP_STATUS"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) */ SUM(C1)
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 1
--         AS C1
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(19.072, 8) SEED(4) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)
--                 AND ("THIS_"."DH_FECHAMENTO" IS NOT NULL)
--                 AND ("THIS_"."SN_CONFIDENCIAL" IS NULL
--                 OR "THIS_"."SN_CONFIDENCIAL"=:B2)
--                 AND ("THIS_"."TP_STATUS"=:B3
--                 OR "THIS_"."TP_STATUS"=:B4
--                 OR "THIS_"."TP_STATUS"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_5", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") NO_INDEX_FFS( "THIS_") */ 4294967295
--         AS C1, COUNT(*)
--         AS C2, SUM(CASE WHEN ("THIS_"."TP_STATUS"=:B1
--         OR "THIS_"."TP_STATUS"=:B2
--         OR "THIS_"."TP_STATUS"=:B3)
--         AND ("THIS_"."CD_PACIENTE"=:B4)
--         THEN 1
--         ELSE 0 END)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" SAMPLE BLOCK(19.072, 8) SEED(4) "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B5)) innerQuery
-- ---- Nova Linha ---- -- 11/02/2026 10:39:00

-- SELECT /* DS_SVC */ /*+ dynamic_sampling(0) no_sql_tune no_monitoring optimizer_features_enable(default) no_parallel result_cache(snapshot=3600) OPT_ESTIMATE(@"innerQuery", TABLE, "THIS_", ROWS=0) OPT_ESTIMATE(@"innerQuery", INDEX_SCAN, "THIS_", "IND_PW_DOCUM_CLINIC_LIST_13", ROWS=1) OPT_ESTIMATE(@"innerQuery", INDEX_FILTER, "THIS_", "IND_PW_DOCUM_CLINC_PACIEN_FK", ROWS=1) */ C1, C2, C3
--     FROM (SELECT /*+ qb_name("innerQuery") INDEX( "THIS_" "IND_PW_DOCUM_CLINIC_LIST_13") */ COUNT(*)
--         AS C1, 4294967295
--         AS C2, COUNT(*)
--         AS C3
--         FROM "DBAMV"."PW_DOCUMENTO_CLINICO" "THIS_"
--             WHERE ("THIS_"."CD_PACIENTE"=:B1)) innerQuery






SELECT
    *
FROM DBAMV.PW_DOCUMENTO_CLINICO
WHERE
    CD_DOCUMENTO_CLINICO IN( 2658610 , 2656985)
    -- CD_ATENDIMENTO = 290854
;


SELECT
    *
FROM DBAMV.REGISTRO_AUDITORIA
WHERE CD_DOCUMENTO_CLINICO IN( 2658610 , 2656985)
;


SELECT
    *
FROM DBAMV.PAGU_OBJETO_PARAMETRO pop
INNER JOIN DBAMV.PW_PARAMETRO_PAGU_OBJETO pppo
    on pop.CD_PARAMETRO_PAGU_OBJETO=pppo.CD_PARAMETRO_PAGU_OBJETO
    -- and ( pppo.NM_PARAMETRO=:7 )
;



SELECT
CD_ATENDIMENTO_1,
DT_ATENDIMENTO,
HR_ATENDIMENTO,
TP_ATENDIMENTO,

CD_PACIENTE_1,
CD_CONVENIO,
CD_PRO_INT,
CD_LEITO,


CD_MOT_ALT,

DS_OBS_ALTA,
HR_ALTA,
DT_ALTA_MEDICA,
NM_USUARIO_ALTA_MEDICA,
HR_ALTA_MEDICA,

NM_OBJETO,

CD_DOCUMENTO_CLINICO,
CD_TIPO_DOCUMENTO,
CD_PACIENTE,
CD_ATENDIMENTO,
CD_USUARIO,
CD_PRESTADOR,
TP_STATUS,
DH_REFERENCIA,
DH_CRIACAO,
DH_FECHAMENTO,
DH_CRIACAO,
DH_FECHAMENTO,
CD_OBJETO,
NM_DOCUMENTO,
DH_DOCUMENTO,
SN_CONFIDENCIAL,
QT_VIAS_IMPRESSAS,
DS_TIPO_DOCUMENTO,
NM_TABELA


from dbamv.PW_DOCUMENTO_CLINICO this_
inner join dbamv.PW_TIPO_DOCUMENTO tipodocume2_
    on this_.CD_TIPO_DOCUMENTO=tipodocume2_.CD_TIPO_DOCUMENTO left outer join dbamv.ATENDIME atendiment3_
    on this_.CD_ATENDIMENTO=atendiment3_.CD_ATENDIMENTO left outer join dbamv.PAGU_OBJETO objeto1_
    on this_.CD_OBJETO=objeto1_.CD_OBJETO
WHERE CD_DOCUMENTO_CLINICO IN( 2658610 , 2656985)
;





SELECT

    eca.DS_CAMPO,
    pdc.DH_CRIACAO,
    pdc.DH_FECHAMENTO,
    erc.*,
    -- erc.CD_REGISTRO,
    -- erc.CD_CAMPO,
    -- erc.DS_VALOR,
    -- erc.NM_IMAGEM,
    -- erc.LO_VALOR,
    doc.CD_DOCUMENTO
    -- doc.DS_DOCUMENTO,
    -- ptd.CD_TIPO_DOCUMENTO,
    -- pdc.CD_DOCUMENTO_CLINICO,
    -- pdc.CD_ATENDIMENTO,
    -- pdc.CD_USUARIO,
    -- pdc.TP_STATUS,
    -- pdc.NM_DOCUMENTO


FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
INNER JOIN DBAMV.PW_EDITOR_CLINICO pec      ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
INNER JOIN DBAMV.PW_TIPO_DOCUMENTO ptd      ON pdc.CD_TIPO_DOCUMENTO = ptd.CD_TIPO_DOCUMENTO
LEFT JOIN  DBAMV.EDITOR_REGISTRO_CAMPO erc  ON erc.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
LEFT JOIN  DBAMV.EDITOR_DOCUMENTO doc       ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
LEFT JOIN  DBAMV.EDITOR_CAMPO eca           ON eca.CD_CAMPO = erc.CD_CAMPO
INNER JOIN DBAMV.ATENDIME a                 ON pdc.CD_ATENDIMENTO = a.CD_ATENDIMENTO
WHERE
    -- pec.CD_DOCUMENTO_CLINICO IN( 2658610, 2656985)
      pdc.CD_ATENDIMENTO = 288689
    --   ptd.CD_TIPO_DOCUMENTO NOT IN (36, 44) AND
	--   doc.CD_DOCUMENTO IN ('935')
;

WITH DOC_DISPOSITIVO_VASCULAR
    AS (
        SELECT
            pdc.CD_ATENDIMENTO,
            pdc.CD_DOCUMENTO_CLINICO,
            erc.CD_REGISTRO,

            pdc.CD_USUARIO,

            pdc.NM_DOCUMENTO,
            pdc.DH_CRIACAO,
            pdc.DH_FECHAMENTO,

            CASE
                WHEN a.DT_ATENDIMENTO IS NOT NULL AND a.HR_ATENDIMENTO IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ATENDIMENTO, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ATENDIMENTO, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ATENDIMENTO,

            CASE
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ALTA,

            -- ==============================================

            -- 1. Enfermeiro (Avaliar 1x por turno)

            MAX(
                CASE WHEN eca.DS_CAMPO='Turno_Enf_SN' THEN
                    DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
                END ) AS Turno_Enf_SN,
            MAX(
            CASE WHEN eca.DS_CAMPO='Turno_Enf_MT' THEN
                DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            END ) AS Turno_Enf_MT,

            -- ==============================================

            -- 2. Dispositivo
            MAX(
                CASE WHEN eca.DS_CAMPO='Disp_CVP' THEN
                    DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            END ) AS Disp_CVP,
            MAX(
                CASE WHEN eca.DS_CAMPO='Disp_CVC' THEN
                    DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            END ) AS Disp_CVC,
            MAX(
                CASE WHEN eca.DS_CAMPO='Disp_CHD' THEN
                    DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            END ) AS Disp_CHD,
            MAX(
                CASE WHEN eca.DS_CAMPO='Disp_PAI' THEN
                    DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            END ) AS Disp_PAI,

            -- ==============================================

            -- 3. Sítio de inserção:
            MAX(
                CASE WHEN eca.DS_CAMPO='Sitio_Insercao' THEN
                    DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            END ) AS Sitio_Insercao,
            -- MAX(
            --     CASE WHEN eca.DS_CAMPO='Dt_Insercao' THEN
            --         DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            -- END ) AS Dt_Insercao,

            -- MAX(
            --     CASE WHEN eca.DS_CAMPO='permanencia' THEN
            --         DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            -- END ) AS permanencia,


            -- ==============================================

            -- 6. Motivo da permanência:
            -- MAX(
            --     CASE WHEN eca.DS_CAMPO='Motiv_Perm_Medic' THEN
            --         DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            -- END ) AS Motiv_Perm_Medic,
            -- MAX(
            --     CASE WHEN eca.DS_CAMPO='Motiv_Perm_DVA' THEN
            --         DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            -- END ) AS Motiv_Perm_DVA,
            -- MAX(
            --     CASE WHEN eca.DS_CAMPO='Motiv_Perm_Falencia' THEN
            --         DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            -- END ) AS Motiv_Perm_Falencia,
            -- MAX(
            --     CASE WHEN eca.DS_CAMPO='Motiv_Perm_Hemodialise' THEN
            --         DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            -- END ) AS Motiv_Perm_Hemodialise,
            -- MAX(
            --     CASE WHEN eca.DS_CAMPO='Motiv_Perm_Monitorizacao' THEN
            --         DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            -- END ) AS Motiv_Perm_Monitorizacao,


            -- -- ==============================================

            -- 12. Ações
            MAX(
                CASE WHEN eca.DS_CAMPO='Acoes_Acesso_Mantido' THEN
                    DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            END ) AS Acoes_Acesso_Mantido,
            MAX(
                CASE WHEN eca.DS_CAMPO='Acoes_Solicitar_Retirada' THEN
                    DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            END ) AS Acoes_Solicitar_Retirada,
            MAX(
                CASE WHEN eca.DS_CAMPO='Acoes_Realizado_Notificacao' THEN
                    DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1)
            END ) AS Acoes_Realizado_Notificacao

FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
INNER JOIN DBAMV.PW_EDITOR_CLINICO pec      ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
LEFT JOIN  DBAMV.EDITOR_REGISTRO_CAMPO erc  ON erc.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
LEFT JOIN  DBAMV.EDITOR_DOCUMENTO doc       ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
LEFT JOIN  DBAMV.EDITOR_CAMPO eca           ON eca.CD_CAMPO = erc.CD_CAMPO
INNER JOIN DBAMV.ATENDIME a                 ON pdc.CD_ATENDIMENTO = a.CD_ATENDIMENTO
WHERE
    doc.CD_DOCUMENTO = '1024' AND
    -- pec.CD_DOCUMENTO_CLINICO IN( 2640367 ) --2658610 , 2656985)
    -- erc.CD_REGISTRO IN (179510, 179264)
    a.CD_ATENDIMENTO = 288689
GROUP BY
    pdc.CD_ATENDIMENTO,
    pdc.CD_DOCUMENTO_CLINICO,
    erc.CD_REGISTRO,
    pdc.NM_DOCUMENTO,
    pdc.CD_USUARIO,
    pdc.DH_CRIACAO,
    pdc.DH_FECHAMENTO,
            CASE
                WHEN a.DT_ATENDIMENTO IS NOT NULL AND a.HR_ATENDIMENTO IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ATENDIMENTO, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ATENDIMENTO, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END,
            CASE
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END
ORDER BY pdc.CD_DOCUMENTO_CLINICO, pdc.DH_CRIACAO, erc.CD_REGISTRO
)
SELECT
    *
FROM DOC_DISPOSITIVO_VASCULAR

;

MIN(DT_INSERCAO)
DT_ALTA IS NOT NULL
DISP_CVP  true
ACOES_SOLICITAR_RETIRADA = false

-- Para realização do calculo, considerando esse documento, é necessáro que, pelo menos as questões 1, 2, 6 e 12 estejam preenchidas



WITH PROTOCOLO_EXTUBACAO
    AS (
        SELECT

            pdc.CD_ATENDIMENTO,
            pec.CD_DOCUMENTO_CLINICO,
            er.CD_CAMPO,
            REGEXP_SUBSTR(DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1), '[0-9]+') AS REGX,
            DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1) AS SEM_REGX,
            MAX(pdc.DH_DOCUMENTO) AS HR_DOC_EXTUBACAO

        FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
        INNER JOIN DBAMV.PW_EDITOR_CLINICO pec    ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
        LEFT JOIN DBAMV.EDITOR_REGISTRO_CAMPO er  ON er.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
        LEFT JOIN DBAMV.EDITOR_DOCUMENTO doc      ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
        WHERE
            EXTRACT(YEAR FROM pdc.DH_DOCUMENTO) = EXTRACT(YEAR FROM SYSDATE) --AND
            -- doc.CD_DOCUMENTO IN ('935') AND
            -- er.CD_CAMPO IN(442178, 452571)
        GROUP BY
            pdc.CD_ATENDIMENTO,
            pec.CD_DOCUMENTO_CLINICO,
            er.CD_CAMPO,
            REGEXP_SUBSTR(DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1), '[0-9]+'),
            DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1)
)
SELECT
    *
FROM PROTOCOLO_EXTUBACAO
-- WHERE CD_DOCUMENTO_CLINICO IN( 2658610 , 2656985)
;