

-- - RELATORIO: R_INTERNACOES_UNIDADE_SINT
-- - VIEW:      V_PARI_UNIDADE_INTERNACAO

SELECT 
  	   ATIVO,
  	   TOTAL_ATIVO,
       ATIVO * 100 / TOTAL_ATIVO AS PERC,
       TO_CHAR((ATIVO * 100 / TOTAL_ATIVO),'990.90')||' %' AS SUB,
       CD_UNID_INT,
       DS_UNID_INT
FROM( 
	 SELECT 
	 	   COUNT(*) AS ATIVO ,
            TOTAL_ATIVO ,
           LEITO.CD_UNID_INT AS CD_UNID_INT ,
           DS_UNID_INT
     FROM  DBAMV.LEITO , 
           DBAMV.UNID_INT ,  
         ( SELECT 
         		 COUNT(*) AS TOTAL_ATIVO
           FROM  DBAMV.LEITO , 
                 DBAMV.UNID_INT
           WHERE LEITO.TP_SITUACAO = 'A'
                 AND UNID_INT.CD_UNID_INT = LEITO.CD_UNID_INT
                 AND ( LEITO.SN_EXTRA = 'N' OR (LEITO.SN_EXTRA = 'S' AND LEITO.TP_OCUPACAO = 'O')) ) TOTAL
     WHERE LEITO.TP_SITUACAO = 'A'
          AND UNID_INT.CD_UNID_INT = LEITO.CD_UNID_INT
          AND ( LEITO.SN_EXTRA = 'N' OR (LEITO.SN_EXTRA = 'S' AND LEITO.TP_OCUPACAO = 'O') )
	 GROUP BY LEITO.CD_UNID_INT, DS_UNID_INT, TOTAL_ATIVO
       		)
WHERE ATIVO > 1
UNION ALL
SELECT 
	   SUM(ATIVO) AS ATIVO ,
	   TOTAL_ATIVO ,
       SUM(ATIVO) * 100 / TOTAL_ATIVO AS PERC ,
       TO_CHAR((SUM(ATIVO) * 100 / TOTAL_ATIVO),'990.90')||' %' AS SUB ,
       0 CD_UNID_INT ,
       'Outros' DS_UNID_INT
FROM( 
	 SELECT 
		   COUNT(*) AS ATIVO ,
           TOTAL_ATIVO ,
           LEITO.CD_UNID_INT AS CD_UNID_INT ,
           DS_UNID_INT
   	 FROM  DBAMV.LEITO ,
           DBAMV.UNID_INT ,
         ( SELECT
         		 COUNT(*) AS TOTAL_ATIVO
           FROM  DBAMV.LEITO ,
                 DBAMV.UNID_INT
           WHERE LEITO.TP_SITUACAO = 'A'
             	 AND UNID_INT.CD_UNID_INT   = LEITO.CD_UNID_INT
             	 AND (LEITO.SN_EXTRA = 'N' OR (LEITO.SN_EXTRA = 'S' AND LEITO.TP_OCUPACAO = 'O')) ) Total
	 WHERE LEITO.TP_SITUACAO = 'A'
	      AND UNID_INT.CD_UNID_INT = LEITO.CD_UNID_INT
	      AND ( LEITO.SN_EXTRA = 'N' OR  (LEITO.SN_EXTRA = 'S' AND LEITO.TP_OCUPACAO = 'O') )
	 GROUP BY LEITO.CD_UNID_INT, DS_UNID_INT, TOTAL_ATIVO 
			)
WHERE ATIVO <= 1
GROUP BY TOTAL_ATIVO  ;


/*
 * *************************************************************************************************************************************************
 * */

WITH SOURCES AS (
	SELECT 
	      l.CD_UNID_INT ,
	      ui.DS_UNID_INT 
	FROM  DBAMV.LEITO l , 
	      DBAMV.UNID_INT ui
	WHERE l.TP_SITUACAO = 'A' AND 
	      ui.CD_UNID_INT = l.CD_UNID_INT AND 
	      ( l.SN_EXTRA = 'N' OR (l.SN_EXTRA = 'S' AND l.TP_OCUPACAO = 'O') )
) ,
a  AS (	SELECT COUNT(*) AS ATIVO , SOURCES.CD_UNID_INT, SOURCES.DS_UNID_INT FROM SOURCES GROUP BY SOURCES.CD_UNID_INT, SOURCES.DS_UNID_INT ) ,
ta AS (	SELECT COUNT(*) AS TOTAL_ATIVO FROM SOURCES )
SELECT 
	a.ATIVO ,
	ta.TOTAL_ATIVO ,
	a.ATIVO * 100 / ta.TOTAL_ATIVO AS PERC ,
  	TO_CHAR((a.ATIVO * 100 / ta.TOTAL_ATIVO),'990.90')||' %' AS SUB ,
	a.CD_UNID_INT ,
	a.DS_UNID_INT
FROM
	a, ta
GROUP BY a.CD_UNID_INT, a.DS_UNID_INT, ta.TOTAL_ATIVO, a.ATIVO
;

/* ************************************************************************************************************************************************* */


SELECT DISTINCT 
	pdc.CD_ATENDIMENTO
	, NVL(NVL(pmd.CD_PRE_MED, cvt.CD_COLETA_SINAL_VITAL), pec.CD_DOCUMENTO) AS CD_DOCUMENTO
	, NVL(doc.DS_DOCUMENTO, obj.NM_OBJETO) AS DS_DOCUMENTO
	, pdc.TP_STATUS
	, pdc.DH_DOCUMENTO
	, pdc.DH_CRIACAO
	, DECODE(pec.CD_DOCUMENTO, NULL, pdc.DH_DOCUMENTO, pdc.DH_FECHAMENTO) AS DH_FECHAMENTO
	, DECODE(pec.CD_DOCUMENTO, NULL, pdc.DH_DOCUMENTO, pdc.DH_IMPRESSO) AS DH_IMPRESSAO
	, pdc.CD_USUARIO AS CD_USUARIO
	, pdc.CD_PRESTADOR AS CD_PRESTADOR
FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
LEFT JOIN DBAMV.PW_EDITOR_CLINICO pec 
	ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
INNER JOIN DBAMV.PW_TIPO_DOCUMENTO ptd 
	ON pdc.CD_TIPO_DOCUMENTO = ptd.CD_TIPO_DOCUMENTO
LEFT JOIN DBAMV.PRE_MED pmd 
	ON pdc.CD_DOCUMENTO_CLINICO = pmd.CD_DOCUMENTO_CLINICO
LEFT JOIN DBAMV.COLETA_SINAL_VITAL cvt 
	ON pdc.CD_DOCUMENTO_CLINICO = cvt.CD_DOCUMENTO_CLINICO
LEFT JOIN DBAMV.PAGU_OBJETO obj 
	ON pdc.CD_OBJETO = obj.CD_OBJETO
LEFT JOIN DBAMV.EDITOR_REGISTRO_CAMPO erc 
	ON erc.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
LEFT JOIN DBAMV.EDITOR_REGISTRO erg 
	ON erg.CD_REGISTRO = erc.CD_REGISTRO
LEFT JOIN DBAMV.EDITOR_DOCUMENTO doc 
	ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
LEFT JOIN DBAMV.EDITOR_VERSAO_DOCUMENTO evs 
	ON doc.CD_DOCUMENTO = evs.CD_DOCUMENTO AND evs.CD_TIPO_VERSAO = 3 -- Versão Atual (Não remova este filtro)
LEFT JOIN DBAMV.EDITOR_TIPO_VERSAO tver 
	ON evs.CD_TIPO_VERSAO = tver.CD_TIPO_VERSAO
LEFT JOIN DBAMV.EDITOR_CAMPO eca 
	ON eca.CD_CAMPO = erc.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_TIPO_VISUALIZACAO etv 
	ON eca.CD_TIPO_VISUALIZACAO = etv.CD_TIPO_VISUALIZACAO
LEFT JOIN DBAMV.EDITOR_CAMPO ecb 
	ON eca.CD_METADADO = ecb.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_GRUPO_CAMPO egc 
	ON egc.CD_CAMPO = ecb.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_GRUPO egr 
	ON egc.CD_GRUPO = egr.CD_GRUPO
WHERE ptd.CD_TIPO_DOCUMENTO NOT IN (36, 44)
	  AND doc.CD_DOCUMENTO IN ('873')
	  AND DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1) IS NOT NULL 
	  AND pdc.CD_ATENDIMENTO = 110841 ;
	--   AND doc.DS_DOCUMENTO LIKE '%NUTRI%' ;




/* ************************************************************* QUERY PAINEL NUTRICAO ************************************************************* */

WITH doc_pep AS (
	SELECT DISTINCT 
		   Ate.Cd_Atendimento,
	       Ate.Dt_Atendimento,
	       EXTRACT(YEAR FROM Ate.Dt_Atendimento) ANO, 
	       EXTRACT(MONTH FROM Ate.Dt_Atendimento) MES,
	       Ate.Hr_Atendimento,
	       Pac.Cd_Paciente,
	       Pac.Nm_Paciente,
	       NVL(NVL(Pmd.Cd_Pre_Med, Cvt.Cd_Coleta_Sinal_Vital), Pec.Cd_Documento) Cd_Documento,
	       NVL(Doc.Ds_Documento, Obj.Nm_Objeto) Ds_Documento,
	       Pdc.Tp_Status,
	       Pdc.Dh_Documento,
	       Pdc.Dh_Criacao,
	       DECODE(Pec.Cd_Documento, NULL, Pdc.Dh_Documento, Pdc.Dh_Fechamento) Dh_Fechamento,
	       DECODE(Pec.Cd_Documento, NULL, Pdc.Dh_Documento, Pdc.Dh_Impresso) Dh_Impresso,
	       (SELECT Und.Ds_Unid_Int
	          FROM Dbamv.Unid_Int Und,
	               Dbamv.Leito Lei
	         WHERE Und.Cd_Unid_Int = Lei.Cd_Unid_Int
	           AND Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(Ate.Cd_Atendimento, NVL(Pdc.Dh_Referencia, Pdc.Dh_Criacao))) Ds_Unidade_Internacao,
	       (SELECT Str.Nm_Setor
	          FROM Dbamv.Unid_Int Und,
	               Dbamv.Leito Lei,
	               Dbamv.Setor Str
	         WHERE Und.Cd_Unid_Int = Lei.Cd_Unid_Int
	           AND Und.Cd_Setor = Str.Cd_Setor
	           AND Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(Ate.Cd_Atendimento, NVL(Pdc.Dh_Referencia, Pdc.Dh_Criacao))) Ds_Setor_Documento,
	       (SELECT Lei.Ds_Leito
	          FROM Dbamv.Leito Lei
	         WHERE Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(Ate.Cd_Atendimento, NVL(Pdc.Dh_Referencia, Pdc.Dh_Criacao))) ds_leito,
	       (SELECT Lei.Ds_Resumo
	          FROM Dbamv.Leito Lei
	         WHERE Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(Ate.Cd_Atendimento, NVL(Pdc.Dh_Referencia, Pdc.Dh_Criacao))) ds_resumo_leito,
	       Pdc.Cd_Usuario Cd_Usuario_Criou,
	       Pdc.Cd_Prestador Cd_Prestador_Criou,
		   Pres.Cd_prestador,
		   Pres.Nm_prestador
	  FROM Dbamv.Pw_Documento_Clinico Pdc,
	       Dbamv.Pw_Editor_Clinico Pec,
	       Dbamv.Pw_Tipo_Documento Ptd,
	       Dbamv.Pre_Med Pmd,
	       Dbamv.Coleta_Sinal_Vital Cvt,
	       Dbamv.Pagu_Objeto Obj,
	       Dbamv.Editor_Registro_Campo Erc,
	       Dbamv.Editor_Registro Erg,
	       Dbamv.Editor_Documento Doc,
	       Dbamv.Editor_Versao_Documento Evs,
	       Dbamv.Editor_Tipo_Versao Etv,
	       Dbamv.Editor_Campo EcA,
	       Dbamv.Editor_Tipo_Visualizacao Etv,
	       Dbamv.Editor_Campo EcB,
	       Dbamv.Editor_Grupo_Campo Egc,
	       Dbamv.Editor_Grupo Egr,
	       Dbamv.Atendime Ate,
	       Dbamv.Paciente Pac,
	       Dbamv.Prestador Pres
	 WHERE Pec.Cd_Documento_Clinico(+) = Pdc.Cd_Documento_Clinico
	   AND Pdc.Cd_Tipo_Documento = Ptd.Cd_Tipo_Documento
	   AND Pdc.Cd_Documento_Clinico = Pmd.Cd_Documento_Clinico(+)
	   AND Pdc.Cd_Documento_Clinico = Cvt.Cd_Documento_Clinico(+)
	   AND Pdc.Cd_Objeto(+) = Obj.Cd_Objeto
	   AND Erc.Cd_Registro(+) = Pec.Cd_Editor_Registro
	   AND Erg.Cd_Registro(+) = Erc.Cd_Registro
	   AND Pec.Cd_Documento = Doc.Cd_Documento(+)
	   AND Doc.Cd_Documento = Evs.Cd_Documento(+)
	   AND Evs.Cd_Tipo_Versao(+) = 3 --Versão Atual (Não remova este filtro)
	   AND Evs.Cd_Tipo_Versao = Etv.Cd_Tipo_Versao(+)
	   AND EcA.Cd_Campo(+) = Erc.Cd_campo
	   AND EcA.Cd_Tipo_Visualizacao = Etv.Cd_Tipo_Visualizacao(+)
	   AND EcA.Cd_Metadado = EcB.Cd_Campo(+)
	   AND Egc.Cd_Campo(+) = EcB.cd_Campo
	   AND Egc.Cd_Grupo = Egr.Cd_Grupo(+)
	   AND Pdc.Cd_Atendimento = Ate.Cd_Atendimento
	   AND Ate.Cd_Paciente = Pac.Cd_Paciente
	   AND Pres.cd_prestador = Pdc.cd_prestador
	   AND Ptd.Cd_Tipo_Documento NOT IN (36, 44)
	   AND Doc.cd_documento IN('983','873')
	   AND DBMS_LOB.SUBSTR(Erc.Lo_Valor, 4000, 1) IS NOT NULL
) ,
atendime_i AS ( 
SELECT
	a.cd_atendimento ,
	p.cd_paciente,
	p.nm_paciente,
	TO_DATE( TO_CHAR(a.dt_atendimento, 'YYYY-MM-DD') || ' ' || TO_CHAR(a.hr_atendimento, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS' ) AS DT_ATENDIMENTO ,
	EXTRACT(YEAR FROM a.Dt_Atendimento) ANO ,
	EXTRACT(MONTH FROM a.Dt_Atendimento) MES ,
	a.tp_atendimento ,
	a.CD_MOT_ALT ,
	a.DT_ALTA,
	a.HR_ALTA,
	mt.DS_MOT_ALT ,
	a.HR_ATENDIMENTO
FROM
	DBAMV.atendime a
LEFT JOIN DBAMV.paciente p
	ON a.cd_paciente = p.cd_paciente
LEFT JOIN DBAMV.MOT_ALT mt
	ON a.CD_MOT_ALT = mt.CD_MOT_ALT
WHERE
	a.tp_atendimento = 'I' )
SELECT
	a.CD_ATENDIMENTO ,
	a.DT_ATENDIMENTO , 
	a.DS_MOT_ALT ,
	a.DT_ALTA ,
	NVL(d.Cd_Paciente, a.cd_paciente) AS cd_paciente ,
	NVL(d.Nm_Paciente, a.nm_paciente) AS nm_paciente ,
	d.Cd_Usuario_Criou,
	d.Cd_Prestador_Criou,
	d.Nm_prestador,
	d.Cd_Documento,
	d.Ds_Documento,
	d.Dh_Documento AS Dt_Abertura,
	d.Dh_Criacao,
	d.Dh_Fechamento AS Dt_Fechamento,
	d.Tp_Status,
	NVL(d.ds_leito,
	   (SELECT Lei.Ds_Leito
	      FROM Dbamv.Leito Lei
	     WHERE Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(a.Cd_Atendimento, a.DT_ATENDIMENTO))) ds_leito,
	NVL(d.ds_resumo_leito,
	   (SELECT Lei.Ds_Resumo
	      FROM Dbamv.Leito Lei
	     WHERE Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(a.Cd_Atendimento, a.DT_ATENDIMENTO))) ds_resumo_leito,
	NVL(d.Ds_Unidade_Internacao,
	   (SELECT Und.Ds_Unid_Int
	      FROM Dbamv.Unid_Int Und,
	           Dbamv.Leito Lei
	     WHERE Und.Cd_Unid_Int = Lei.Cd_Unid_Int
	       AND Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(a.Cd_Atendimento, a.DT_ATENDIMENTO))) Ds_Unidade_Internacao
FROM atendime_i a
LEFT JOIN doc_pep d
	ON a.CD_ATENDIMENTO = d.CD_ATENDIMENTO ;




/* ********************************************************************************************************************************* */

/* ******************************************* PROVA DA FUNCTION PELA QUERY [ SUBSTITUIR ] ***************************************** */


-- FUNCTION()

SELECT 
	Und.Ds_Unid_Int , 
	Lei.Ds_Leito,
	Lei.Ds_Resumo
FROM Dbamv.Unid_Int Und,
     Dbamv.Leito Lei
WHERE Und.Cd_Unid_Int = Lei.Cd_Unid_Int
      AND Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(164829, TO_DATE('2024-10-26 15:11:00', 'YYYY-MM-DD HH24:MI:SS')) ;
     
-- CARTESIANO
SELECT
	ui.CD_UNID_INT 
	, ui.DS_UNID_INT 
	, L.CD_LEITO 
	, l.DS_LEITO 
	, l.DS_RESUMO 
	, l.TP_SITUACAO 
FROM -- CARTESIANO DAS TABELAS - RETORNO "OUTER JOIN" DAS TABELAS ENVOLVIDAS
	DBAMV.UNID_INT ui,
	DBAMV.LEITO l
WHERE ui.CD_UNID_INT = 4 AND l.TP_SITUACAO = 'A' 
ORDER BY 2; 

-- RELACIONAMENTO - MESMO RETORNO DA FUNCTION()
SELECT
	ui.CD_UNID_INT 
	, ui.DS_UNID_INT 
	, l.CD_LEITO 
	, l.DS_LEITO 
	, l.DS_RESUMO 
	, l.TP_SITUACAO 
	, SYSDATE AS DT_EXTRACAO
FROM -- RELACIONAMENTO DAS TABELAS - RETORNA AS "UNIDADES" e SEUS "LEITOS" NA RELAÇÃO 1:* 
	DBAMV.LEITO l
LEFT JOIN DBAMV.UNID_INT ui 
	ON l.CD_UNID_INT = ui.CD_UNID_INT 
WHERE ui.CD_UNID_INT = 4 AND l.TP_SITUACAO = 'A'
ORDER BY 2 ;



/* ************************************************** DATA MART - NUTRICAO ********************************************************* */



/* FATO "DOC_PEP"  */
SELECT DISTINCT 
	pdc.CD_ATENDIMENTO
	, NVL(NVL(pmd.CD_PRE_MED, cvt.CD_COLETA_SINAL_VITAL), pec.CD_DOCUMENTO) AS CD_DOCUMENTO
	, NVL(doc.DS_DOCUMENTO, obj.NM_OBJETO) AS DS_DOCUMENTO
	, pdc.TP_STATUS
	, pdc.DH_DOCUMENTO
	, pdc.DH_CRIACAO
	, DECODE(pec.CD_DOCUMENTO, NULL, pdc.DH_DOCUMENTO, pdc.DH_FECHAMENTO) AS DH_FECHAMENTO
	, DECODE(pec.CD_DOCUMENTO, NULL, pdc.DH_DOCUMENTO, pdc.DH_IMPRESSO) AS DH_IMPRESSAO
	, pdc.CD_USUARIO AS CD_USUARIO
	, pdc.CD_PRESTADOR AS CD_PRESTADOR
FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
LEFT JOIN DBAMV.PW_EDITOR_CLINICO pec 
	ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
INNER JOIN DBAMV.PW_TIPO_DOCUMENTO ptd 
	ON pdc.CD_TIPO_DOCUMENTO = ptd.CD_TIPO_DOCUMENTO
LEFT JOIN DBAMV.PRE_MED pmd 
	ON pdc.CD_DOCUMENTO_CLINICO = pmd.CD_DOCUMENTO_CLINICO
LEFT JOIN DBAMV.COLETA_SINAL_VITAL cvt 
	ON pdc.CD_DOCUMENTO_CLINICO = cvt.CD_DOCUMENTO_CLINICO
LEFT JOIN DBAMV.PAGU_OBJETO obj 
	ON pdc.CD_OBJETO = obj.CD_OBJETO
LEFT JOIN DBAMV.EDITOR_REGISTRO_CAMPO erc 
	ON erc.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
LEFT JOIN DBAMV.EDITOR_REGISTRO erg 
	ON erg.CD_REGISTRO = erc.CD_REGISTRO
LEFT JOIN DBAMV.EDITOR_DOCUMENTO doc 
	ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
LEFT JOIN DBAMV.EDITOR_VERSAO_DOCUMENTO evs 
	ON doc.CD_DOCUMENTO = evs.CD_DOCUMENTO AND evs.CD_TIPO_VERSAO = 3 -- Versão Atual (Não remova este filtro)
LEFT JOIN DBAMV.EDITOR_TIPO_VERSAO tver 
	ON evs.CD_TIPO_VERSAO = tver.CD_TIPO_VERSAO
LEFT JOIN DBAMV.EDITOR_CAMPO eca 
	ON eca.CD_CAMPO = erc.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_TIPO_VISUALIZACAO etv 
	ON eca.CD_TIPO_VISUALIZACAO = etv.CD_TIPO_VISUALIZACAO
LEFT JOIN DBAMV.EDITOR_CAMPO ecb 
	ON eca.CD_METADADO = ecb.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_GRUPO_CAMPO egc 
	ON egc.CD_CAMPO = ecb.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_GRUPO egr 
	ON egc.CD_GRUPO = egr.CD_GRUPO
WHERE ptd.CD_TIPO_DOCUMENTO NOT IN (36, 44)
	  AND doc.CD_DOCUMENTO IN ('983','873')
	  AND DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1) IS NOT NULL ;


/* FATO "ATENDIME" */
SELECT
	a.CD_ATENDIMENTO
	, a.DT_ATENDIMENTO
	, a.HR_ATENDIMENTO
	, a.TP_ATENDIMENTO
	, a.CD_LEITO
	, a.DT_ALTA
	, a.HR_ALTA
	, a.CD_MOT_ALT
FROM DBAMV.ATENDIME a
WHERE a.tp_atendimento = 'I'  ; 



/*
 * DIMENSÃO "UNID_INT" 
 * INCLUIR O CAMPO 'CD_UNID_INT' NA 'FATO' ATRAVÉS DA TB "LEITO"
 */
SELECT 
	ui.CD_UNID_INT 
	, ui.DS_UNID_INT 
	, ui.SN_ATIVO
	-- , ui.CD_SETOR 
FROM DBAMV.UNID_INT ui
WHERE ui.SN_ATIVO = 'S'
ORDER BY 1;


/* 
 * 	DIMENSÃO "SETOR" 
 *  INCLUIR O CAMPO 'CD_SETOR' NA 'FATO' ATRAVÉS DA TB "UNID_INT"/"LEITO"
 */
SELECT 
	s.CD_SETOR 
	, s.NM_SETOR 
	, s.SN_ATIVO 
FROM DBAMV.SETOR s
WHERE s.SN_ATIVO = 'S' AND EXISTS ( SELECT 1 FROM DBAMV.UNID_INT ui WHERE s.CD_SETOR = ui.CD_SETOR )
ORDER BY 1;


-- DIMENSÃO "LEITO" [ PRESENTE NA 'ATENDIME' ]
SELECT
	l.CD_LEITO 
	, l.DS_LEITO 
--	, l.DS_RESUMO 
	, l.TP_SITUACAO 
FROM DBAMV.LEITO l 
WHERE l.TP_SITUACAO = 'A'
ORDER BY 1;


-- DIMENSÃO "MOT_ALT" [ PRESENTE NA 'ATENDIME' ]
SELECT 
	mt.CD_MOT_ALT 
	, mt.DS_MOT_ALT 
	, mt.SN_ATIVO 
    , mt.TP_MOT_ALTA
FROM  DBAMV.MOT_ALT mt
WHERE mt.SN_ATIVO = 'S' 
ORDER BY 1;


-- DIMENSÃO "PACIENTE" [ PRESENTE NA 'ATENDIME' ] 

-- dbamv.fn_idade(PACIENTE.DT_NASCIMENTO,'a')
SELECT 
	p.CD_PACIENTE 
	, p.NM_PACIENTE 
    , p.DT_NASCIMENTO
FROM DBAMV.PACIENTE p
WHERE p.SN_ATIVO = 'S'
ORDER BY 1 ;


/* ********************************************************************************************************************************* */

-- FATO "DOC_PEP"
SELECT DISTINCT 
	pdc.CD_ATENDIMENTO
	, NVL(NVL(pmd.CD_PRE_MED, cvt.CD_COLETA_SINAL_VITAL), pec.CD_DOCUMENTO) AS CD_DOCUMENTO
	, NVL(doc.DS_DOCUMENTO, obj.NM_OBJETO) AS DS_DOCUMENTO
	, pdc.TP_STATUS
	, pdc.DH_DOCUMENTO
	, pdc.DH_CRIACAO
	, DECODE(pec.CD_DOCUMENTO, NULL, pdc.DH_DOCUMENTO, pdc.DH_FECHAMENTO) AS DH_FECHAMENTO
	, DECODE(pec.CD_DOCUMENTO, NULL, pdc.DH_DOCUMENTO, pdc.DH_IMPRESSO) AS DH_IMPRESSAO
	, pdc.CD_USUARIO AS CD_USUARIO
	, pdc.CD_PRESTADOR AS CD_PRESTADOR
FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
LEFT JOIN DBAMV.PW_EDITOR_CLINICO pec 
	ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
INNER JOIN DBAMV.PW_TIPO_DOCUMENTO ptd 
	ON pdc.CD_TIPO_DOCUMENTO = ptd.CD_TIPO_DOCUMENTO
LEFT JOIN DBAMV.PRE_MED pmd 
	ON pdc.CD_DOCUMENTO_CLINICO = pmd.CD_DOCUMENTO_CLINICO
LEFT JOIN DBAMV.COLETA_SINAL_VITAL cvt 
	ON pdc.CD_DOCUMENTO_CLINICO = cvt.CD_DOCUMENTO_CLINICO
LEFT JOIN DBAMV.PAGU_OBJETO obj 
	ON pdc.CD_OBJETO = obj.CD_OBJETO
LEFT JOIN DBAMV.EDITOR_REGISTRO_CAMPO erc 
	ON erc.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
LEFT JOIN DBAMV.EDITOR_REGISTRO erg 
	ON erg.CD_REGISTRO = erc.CD_REGISTRO
LEFT JOIN DBAMV.EDITOR_DOCUMENTO doc 
	ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
LEFT JOIN DBAMV.EDITOR_VERSAO_DOCUMENTO evs 
	ON doc.CD_DOCUMENTO = evs.CD_DOCUMENTO AND evs.CD_TIPO_VERSAO = 3 -- Versão Atual (Não remova este filtro)
LEFT JOIN DBAMV.EDITOR_TIPO_VERSAO tver 
	ON evs.CD_TIPO_VERSAO = tver.CD_TIPO_VERSAO
LEFT JOIN DBAMV.EDITOR_CAMPO eca 
	ON eca.CD_CAMPO = erc.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_TIPO_VISUALIZACAO etv 
	ON eca.CD_TIPO_VISUALIZACAO = etv.CD_TIPO_VISUALIZACAO
LEFT JOIN DBAMV.EDITOR_CAMPO ecb 
	ON eca.CD_METADADO = ecb.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_GRUPO_CAMPO egc 
	ON egc.CD_CAMPO = ecb.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_GRUPO egr 
	ON egc.CD_GRUPO = egr.CD_GRUPO
WHERE ptd.CD_TIPO_DOCUMENTO NOT IN (36, 44)
	  AND doc.CD_DOCUMENTO IN ('983')
	  AND DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1) IS NOT NULL ;


-- FATO "ATENDIME"
SELECT
	a.CD_ATENDIMENTO
	, a.DT_ATENDIMENTO
	, a.HR_ATENDIMENTO
	, a.TP_ATENDIMENTO
	, a.CD_LEITO
	, a.DT_ALTA
	, a.HR_ALTA
	, a.CD_MOT_ALT
FROM DBAMV.ATENDIME a
WHERE a.tp_atendimento = 'I'  ; 




-- DIMENSÃO "UNID_INT" 
SELECT 
	ui.CD_UNID_INT 
	, ui.DS_UNID_INT 
	, ui.SN_ATIVO
	-- , ui.CD_SETOR 
FROM DBAMV.UNID_INT ui
WHERE ui.SN_ATIVO = 'S'
ORDER BY 1;


-- DIMENSÃO "SETOR" 
SELECT 
	s.CD_SETOR 
	, s.NM_SETOR 
	, s.SN_ATIVO 
FROM DBAMV.SETOR s
WHERE s.SN_ATIVO = 'S' AND EXISTS ( SELECT 1 FROM DBAMV.UNID_INT ui WHERE s.CD_SETOR = ui.CD_SETOR )
ORDER BY 1;


-- DIMENSÃO "LEITO" 
SELECT
	l.CD_LEITO 
	, l.DS_LEITO 
--	, l.DS_RESUMO 
	, l.TP_SITUACAO 
FROM DBAMV.LEITO l 
WHERE l.TP_SITUACAO = 'A'
ORDER BY 1;


-- DIMENSÃO "MOT_ALT" 
SELECT 
	mt.CD_MOT_ALT 
	, mt.DS_MOT_ALT 
	, mt.SN_ATIVO 
    , mt.TP_MOT_ALTA
FROM  DBAMV.MOT_ALT mt
WHERE mt.SN_ATIVO = 'S' 
ORDER BY 1;


-- DIMENSÃO "PACIENTE" 
SELECT 
	p.CD_PACIENTE 
	, p.NM_PACIENTE 
    , p.DT_NASCIMENTO
FROM DBAMV.PACIENTE p
WHERE p.SN_ATIVO = 'S'
ORDER BY 1;

-- DIMENSÃO "PRESTADOR"
SELECT 
	p.CD_PRESTADOR 
	, p.NM_PRESTADOR 
    , p.TP_SITUACAO
FROM DBAMV.PRESTADOR p
WHERE p.TP_SITUACAO = 'A'
	  AND p.CD_PRESTADOR > {MAIOR_ID}
ORDER BY 1 ;


/* ********************************************************************************************************************************* */
SELECT DISTINCT 
	pdc.CD_ATENDIMENTO
	, NVL(NVL(pmd.CD_PRE_MED, cvt.CD_COLETA_SINAL_VITAL), pec.CD_DOCUMENTO) AS CD_DOCUMENTO
	, NVL(doc.DS_DOCUMENTO, obj.NM_OBJETO) AS DS_DOCUMENTO
	, pdc.TP_STATUS
	, pdc.DH_DOCUMENTO
	, pdc.DH_CRIACAO
	, DECODE(pec.CD_DOCUMENTO, NULL, pdc.DH_DOCUMENTO, pdc.DH_FECHAMENTO) AS DH_FECHAMENTO
	, DECODE(pec.CD_DOCUMENTO, NULL, pdc.DH_DOCUMENTO, pdc.DH_IMPRESSO) AS DH_IMPRESSAO
	, pdc.CD_USUARIO AS CD_USUARIO
	, pdc.CD_PRESTADOR AS CD_PRESTADOR
FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
LEFT JOIN DBAMV.PW_EDITOR_CLINICO pec 
	ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
INNER JOIN DBAMV.PW_TIPO_DOCUMENTO ptd 
	ON pdc.CD_TIPO_DOCUMENTO = ptd.CD_TIPO_DOCUMENTO
LEFT JOIN DBAMV.PRE_MED pmd 
	ON pdc.CD_DOCUMENTO_CLINICO = pmd.CD_DOCUMENTO_CLINICO
LEFT JOIN DBAMV.COLETA_SINAL_VITAL cvt 
	ON pdc.CD_DOCUMENTO_CLINICO = cvt.CD_DOCUMENTO_CLINICO
LEFT JOIN DBAMV.PAGU_OBJETO obj 
	ON pdc.CD_OBJETO = obj.CD_OBJETO
LEFT JOIN DBAMV.EDITOR_REGISTRO_CAMPO erc 
	ON erc.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
LEFT JOIN DBAMV.EDITOR_REGISTRO erg 
	ON erg.CD_REGISTRO = erc.CD_REGISTRO
LEFT JOIN DBAMV.EDITOR_DOCUMENTO doc 
	ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
LEFT JOIN DBAMV.EDITOR_VERSAO_DOCUMENTO evs 
	ON doc.CD_DOCUMENTO = evs.CD_DOCUMENTO AND evs.CD_TIPO_VERSAO = 3 -- Versão Atual (Não remova este filtro)
LEFT JOIN DBAMV.EDITOR_TIPO_VERSAO tver 
	ON evs.CD_TIPO_VERSAO = tver.CD_TIPO_VERSAO
LEFT JOIN DBAMV.EDITOR_CAMPO eca 
	ON eca.CD_CAMPO = erc.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_TIPO_VISUALIZACAO etv 
	ON eca.CD_TIPO_VISUALIZACAO = etv.CD_TIPO_VISUALIZACAO
LEFT JOIN DBAMV.EDITOR_CAMPO ecb 
	ON eca.CD_METADADO = ecb.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_GRUPO_CAMPO egc 
	ON egc.CD_CAMPO = ecb.CD_CAMPO
LEFT JOIN DBAMV.EDITOR_GRUPO egr 
	ON egc.CD_GRUPO = egr.CD_GRUPO
WHERE ptd.CD_TIPO_DOCUMENTO NOT IN (36, 44)
	  AND doc.CD_DOCUMENTO IN ('983','873')
	  AND DBMS_LOB.SUBSTR(erc.LO_VALOR, 4000, 1) IS NOT NULL 
      AND pdc.CD_ATENDIMENTO > :MAIOR_ID ;


/* ********************************************************************************************************************************* */


	

	
	
	
	
	
	







  
  
  
  
  
  
  
  
-- - RELATORIO: R_INTERNACOES_UNIDADE_SINT
-- - VIEW:      VDIC_INTERNAR_PACIENTE
  SELECT ATENDIME.CD_ATENDIMENTO                                    COGIDO_ATENDIMENTO
     , ATENDIME.CD_PACIENTE                                       CODIGO_PACIENTE
     , PACIENTE.NM_PACIENTE                                       NOME_PACIENTE
     , PACIENTE.DT_NASCIMENTO                                     DATA_NASCIMENTO
     , ATENDIME.DT_ATENDIMENTO                                    DATA_ATENDIMENTO
     , ATENDIME.HR_ATENDIMENTO                                    HORA_ATENDIMENTO
     , ATENDIME.TP_ATENDIMENTO                                    TP_ATENDIMENTO
     , 'INTERNAÇÃO'                                               DESCRICAO_TIPO_ATENDIMENTO
     , ATENDIME.DT_PREVISTA_ALTA                                  DATA_PREVISAO_ALTA
     , ATENDIME.DT_ALTA_MEDICA                                    DATA_ALTA_MEDICA
     , ATENDIME.HR_ALTA_MEDICA                                    HORA_ALTA_MEDICA
     , ATENDIME.DT_ALTA                                           DATA_ALTA
     , ATENDIME.HR_ALTA                                           HORA_ALTA
     , ATENDIME.CD_MOT_ALT                                        CODIGO_MOTIVO_ALTA
     , MOT_ALT.DS_MOT_ALT                                         DESCRICAO_MOTIVO_ALTA
     , LEITO.DS_RESUMO                                            DESCRICAO_LEITO
     , LEITO.DS_ENFERMARIA                                        DESCRICAO_ENFERMARIA
     , UNID_INT.CD_UNID_INT                                       CODIGO_UNID_INTERNACAO
     , UNID_INT.DS_UNID_INT                                       DESCRICAO_UNID_INTERNACAO
     , ATENDIME.CD_PRESTADOR                                      CODIGO_PRESTADOR
     , PRESTADOR.NM_PRESTADOR                                     NOME_PRESTADOR
     , PRESTADOR.NR_CPF_CGC                                       CPF_CGC_PRESTADOR
     , PRESTADOR.DS_CODIGO_CONSELHO                               NUMERO_CRM_PRESTADOR
     , ATENDIME.CD_CONVENIO                                       CODIGO_CONVENIO
     , CONVENIO.NM_CONVENIO                                       DESCRICAO_CONVENIO
     , ATENDIME.CD_CON_PLA                                        CODIGO_PLANO_CONVENIO
     , CON_PLA.DS_CON_PLA                                         DESCRICAO_PLANO_CONVENIO
     , ATENDIME.CD_ORI_ATE                                        CODIGO_ORIGEM
     , ORI_ATE.DS_ORI_ATE                                         DESCRICAO_ORIGEM
     , ATENDIME.CD_CID                                            CODIGO_CID
     , CID.DS_CID                                                 DESCRICAO_CID
     , ATENDIME.CD_SERVICO                                        CODIGO_SERVICO
     , SERVICO.DS_SERVICO                                         DESCRICAO_SERVICO
     , ATENDIME.CD_ESPECIALID                                     CODIGO_ESPECIALIDADE
     , ESPECIALID.DS_ESPECIALID                                   DESCRICAO_ESPECIALIDADE
     , ATENDIME.CD_TIPO_INTERNACAO                                CODIGO_TIPO_INTERNACAO
     , TIPO_INTERNACAO.DS_TIPO_INTERNACAO                         DESCRICAO_TIPO_INTERNACAO
     , USUARIOS.NM_USUARIO                                        NOME_USUARIO_ATENDIMENTO
     , ATENDIME.SN_ACOMPANHANTE                                   IDENTIFICA_ACOMPANHANTE
     , ATENDIME.SN_OBITO                                          IDENTIFICA_OBITO
     , ATENDIME.NR_DECLARACAO_OBITO                               NUMERO_DECLARACAO_OBITO
     , ATENDIME.SN_RECEBE_VISITA                                  RECEBE_VISITA
     , ATENDIME.NR_CARTEIRA                                       NUMERO_CARTEIRA_CONVENIO
     , ATENDIME.DT_VALIDADE                                       DATA_VALIDADE_CARTEIRA
     , ATENDIME.NM_EMPRESA                                        DESCRICAO_EMPRESA_CARTEIRA
     , ATENDIME.CD_MULTI_EMPRESA                                  CD_MULTI_EMPRESA
     , RESPONSA.NM_RESPONSAVEL                                    NOME_RESPONSAVEL
     , atendime.cd_loc_trans_saida                                codigo_loc_trans_saida
     , loc_trans.ds_loc_trans                                     descricao_loc_trans_saida
  FROM DBAMV.ATENDIME
     , DBAMV.PACIENTE
     , DBAMV.ORI_ATE
     , DBAMV.CONVENIO
     , DBAMV.CON_PLA
     , DBAMV.LEITO
     , DBAMV.UNID_INT
     , DBAMV.TIP_ACOM
     , DBAMV.PRESTADOR
     , DBAMV.PRO_FAT
     , DBAMV.CID
     , DBAMV.SERVICO
     , DBAMV.ESPECIALID
     , DBAMV.TIPO_INTERNACAO
     , DBAMV.MOT_ALT
     , DBASGU.USUARIOS
     , DBAMV.RESPONSA
     , DBAMV.LOC_TRANS
 WHERE ATENDIME.CD_PACIENTE        = PACIENTE.CD_PACIENTE
   AND ATENDIME.CD_ORI_ATE         = ORI_ATE.CD_ORI_ATE
   AND ATENDIME.CD_CONVENIO        = CONVENIO.CD_CONVENIO
   AND ATENDIME.CD_CONVENIO        = CON_PLA.CD_CONVENIO
   AND ATENDIME.CD_CON_PLA         = CON_PLA.CD_CON_PLA
   AND ATENDIME.CD_LEITO           = LEITO.CD_LEITO
   AND LEITO.CD_UNID_INT           = UNID_INT.CD_UNID_INT
   AND ATENDIME.CD_TIP_ACOM        = TIP_ACOM.CD_TIP_ACOM
   AND ATENDIME.CD_PRESTADOR       = PRESTADOR.CD_PRESTADOR
   AND ATENDIME.CD_PRO_INT         = PRO_FAT.CD_PRO_FAT(+)
   AND ATENDIME.CD_CID             = CID.CD_CID(+)
   AND ATENDIME.CD_SERVICO         = SERVICO.CD_SERVICO(+)
   AND ATENDIME.CD_ESPECIALID      = ESPECIALID.CD_ESPECIALID(+)
   AND ATENDIME.CD_MOT_ALT         = MOT_ALT.CD_MOT_ALT(+)
   AND ATENDIME.CD_TIPO_INTERNACAO = TIPO_INTERNACAO.CD_TIPO_INTERNACAO(+)
   AND ATENDIME.CD_ATENDIMENTO     = RESPONSA.CD_ATENDIMENTO(+)
   AND ATENDIME.NM_USUARIO         = USUARIOS.CD_USUARIO
   AND ATENDIME.TP_ATENDIMENTO     = 'I'
   AND ATENDIME.CD_LOC_TRANS_SAIDA = LOC_TRANS.CD_LOC_TRANS(+) ;











