
/* ******************************************************* ORIGINAL ******************************************************** */
/* ************************************************************************************************************************* */

cursor cPrescricaoMedica is
---Prescricao Médica---
SELECT
    Case When 
        To_Char(SYSDATE,'hh24:mi') > (SELECT 
                                        VALOR
                                      FROM DBAMV.CONFIGURACAO
                                      WHERE 
                                            CHAVE = 'HORA_LIMITE_PRESCRICAO_MEDICA'
                                            AND CD_SISTEMA = 'PAINEL'
                                            AND VALOR IS NOT NULL
                                            AND ROWNUM = 1
                                            AND CD_MULTI_EMPRESA = P_EMPRESA
                                                    )
    Then 1
    Else 2
    END Sn_Prescrito
FROM Dbamv.Atendime
WHERE NOT EXISTS (
                    SELECT
                        'X'
                    FROM 
                        Dbamv.Pre_Med
                        , Dbamv.Atendime Atend
                    WHERE 
                        Pre_Med.Dt_Pre_Med BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE)+.99999
                        AND Pre_Med.Cd_Atendimento  = Atendime.Cd_Atendimento
                        AND Pre_Med.Cd_Atendimento  = Atend.Cd_Atendimento
                        AND atend.dt_alta IS NULL
                        AND Atend.tp_atendimento = 'I'
                        AND Pre_Med.Tp_Pre_Med = 'M'
                        AND Pre_Med.Fl_Impresso = 'S'
                        AND ROWNUM = 1)
   AND ROWNUM = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento
   ;


/* ************************************************************************************************************************* */

cursor cPrescricaoMedica is
---Prescricao Médica---
SELECT
    Case When 
        To_Char(SYSDATE,'hh24:mi') > (SELECT 
                                        VALOR
                                      FROM DBAMV.CONFIGURACAO
                                      WHERE 
                                            CHAVE = 'HORA_LIMITE_PRESCRICAO_MEDICA'
                                            AND CD_SISTEMA = 'PAINEL'
                                            AND VALOR IS NOT NULL
                                            AND ROWNUM = 1
                                            AND CD_MULTI_EMPRESA = P_EMPRESA
                                                    )
    Then 1
    Else 2
    END Sn_Prescrito
FROM Dbamv.Atendime
WHERE NOT EXISTS (
                    SELECT
                        'X'
                    FROM 
                        Dbamv.Pre_Med
                        , Dbamv.Atendime Atend
                    WHERE 
                        Pre_Med.Dt_Pre_Med BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE)+.99999
                        AND Pre_Med.Cd_Atendimento  = Atendime.Cd_Atendimento
                        AND Pre_Med.Cd_Atendimento  = Atend.Cd_Atendimento
                        AND atend.dt_alta IS NULL
                        AND Atend.tp_atendimento = 'I'
                        AND Pre_Med.Tp_Pre_Med = 'M'
                        AND Pre_Med.Fl_Impresso = 'S'
                        AND ROWNUM = 1)
   AND ROWNUM = 1
   AND Atendime.Cd_Multi_Empresa = P_Empresa
   AND atendime.cd_atendimento = P_Atendimento
   ;

/* ************************************************************************************************************************* */
/* ************************************************************************************************************************* */
/* ************************************************************************************************************************* */
/* ************************************************************************************************************************* */
/* ************************************************************************************************************************* */
/* ************************************************************************************************************************* */


/* -------------------------------------------------------------------------------------------------------------------------- */