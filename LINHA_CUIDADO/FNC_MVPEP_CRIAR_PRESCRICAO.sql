CREATE OR REPLACE FUNCTION DBAMV.FNC_MVPEP_CRIAR_PRESCRICAO (
   pcd_atendimento     IN   NUMBER,
   ptp_acao_tela       IN   VARCHAR2,
   pdt_prescricao      IN   DATE DEFAULT NULL,
   pcd_setor           IN   NUMBER DEFAULT NULL,
   ptp_objeto          IN   VARCHAR2 DEFAULT NULL,
   pcd_setor_maquina   IN   NUMBER DEFAULT NULL,
   pcd_objeto          IN   NUMBER DEFAULT NULL,
   pcd_unid_int        IN   NUMBER DEFAULT NULL,
   pdh_pre_med         IN   DATE DEFAULT NULL,
   pDh_Validade        In   Date Default Null -- OP 39982
)
   RETURN NUMBER
IS
-- PRAGMA AUTONOMOUS_TRANSACTION;

   CURSOR c_cirurgia
   IS
      SELECT COUNT (mov_cc_rpa.cd_atendimento)
        FROM dbamv.mov_cc_rpa
       WHERE mov_cc_rpa.cd_atendimento = pcd_atendimento
         AND mov_cc_rpa.dt_saida_rpa IS NULL;

   CURSOR c_premed (psysdate IN DATE, ptp_tip_prest VARCHAR2)
   IS
      SELECT   pre_med.cd_pre_med cd_pre_med, pre_med.ds_evolucao ds_evolucao,
               pre_med.cd_atendimento cd_atendimento,
               pre_med.dt_referencia dt_referencia,
               pre_med.cd_prestador cd_prestador,
               pre_med.cd_unid_int cd_unid_int, pre_med.cd_setor cd_setor,
               TO_DATE (   TO_CHAR (pre_med.dt_pre_med, 'dd/mm/yyyy')
                        || TO_CHAR (pre_med.hr_pre_med, ' hh24:mi:ss'),
                        'dd/mm/yyyy hh24:mi:ss'
                       ) dh_pre_med,
               pre_med.dt_validade dh_validade, pre_med.tp_pre_med tp_pre_med,
               pre_med.fl_principal fl_principal,
               pre_med.nm_usuario nm_usuario,
               pre_med.sn_transcricao sn_transcricao,
               pre_med.fl_impresso fl_impresso, pre_med.cd_pre_pad cd_pre_pad,
               pre_med.cd_objeto cd_objeto
          FROM dbamv.pre_med,
               dbamv.pagu_objeto,
               dbasgu.usuarios,
               dbamv.prestador,
               dbamv.premed_tip_presta
         WHERE usuarios.cd_usuario = pre_med.nm_usuario
           AND usuarios.cd_prestador = prestador.cd_prestador
           AND premed_tip_presta.cd_tip_presta = prestador.cd_tip_presta
           AND pre_med.cd_atendimento = pcd_atendimento
           AND NVL (pre_med.fl_impresso, 'N') = 'N'
           AND premed_tip_presta.tp_funcao = ptp_tip_prest
           AND pre_med.cd_objeto = pagu_objeto.cd_objeto
           AND ptp_objeto != 'TRATMT'
           AND ((       ptp_acao_tela IN
                               ('MVPEP_PRESCRICAO', 'MVPEP_PRESC_TRATAMENTO')
                    AND pagu_objeto.cd_objeto = pcd_objeto
                    AND pagu_objeto.tp_objeto NOT IN ('EVOMED', 'EVOENF')
                 OR (    (   ptp_objeto != 'RECEIT'
                          OR pagu_objeto.tp_objeto = ptp_objeto
                         )
                     AND (   (    pagu_objeto.tp_objeto = 'MEDICA'
                              AND ptp_acao_tela IN
                                                 ('PME', 'PFU', 'PMI', 'TRA')
                              AND pre_med.ds_evolucao IS NULL
                             )
                          OR (    pagu_objeto.tp_objeto = 'MEDICA'
                              AND ptp_acao_tela = 'EVO'
                              AND pre_med.ds_evolucao IS NOT NULL
                             )
                          OR (    pagu_objeto.tp_objeto = 'INTERN'
                              AND ptp_acao_tela = 'PIN'
                             )
                          OR (    pagu_objeto.tp_objeto = 'SOLLAB'
                              AND ptp_acao_tela = 'SEL'
                             )
                          OR (    pagu_objeto.tp_objeto = 'SOLIMA'
                              AND ptp_acao_tela = 'SEI'
                             )
                          OR (    pagu_objeto.tp_objeto = 'ENFERM'
                              AND ptp_acao_tela = 'PEN'
                             )
                          OR (    pagu_objeto.tp_objeto = 'AVAFAR'
                              AND ptp_acao_tela = 'AVA'
                              AND usuarios.cd_usuario = Nvl(Pkg_Mv_Variaveis.fnc_get_usuario(), usuarios.cd_usuario)
                             )

                         --Or (Pagu_Objeto.Tp_Objeto        = 'RECEIT' And pTp_Acao_Tela = 'PME')
                         )
                    )
                )
               )
      ORDER BY pre_med.dt_referencia;

   --
   CURSOR c_pagu_objeto (pvtp_objeto IN VARCHAR2)
   IS
      SELECT pagu_objeto.cd_objeto
        FROM dbamv.pagu_objeto
       WHERE pagu_objeto.tp_objeto = pvtp_objeto;

   CURSOR c_sysdate
   IS
      SELECT SYSDATE
        FROM DUAL;

   CURSOR c_pagu_objeto_param (pcd_objeto IN NUMBER, pnm_parametro IN VARCHAR2)
   IS
      SELECT pagu_objeto_parametro.vl_parametro
        FROM dbamv.pw_parametro_pagu_objeto
           , dbamv.pagu_objeto_parametro
       WHERE pw_parametro_pagu_objeto.cd_parametro_pagu_objeto = pagu_objeto_parametro.cd_parametro_pagu_objeto
         AND pw_parametro_pagu_objeto.nm_parametro = pnm_parametro
         AND pagu_objeto_parametro.cd_objeto = pcd_objeto;

   CURSOR c_unidade_internacao (pcd_leito IN NUMBER)
   IS
      SELECT leito.cd_unid_int
        FROM dbamv.leito
       WHERE leito.cd_leito = pcd_leito;

   -- Código do prestador da sessão
   CURSOR c_prestador
   IS
      SELECT cd_prestador
        FROM dbasgu.usuarios
       WHERE cd_usuario = pkg_mv_variaveis.fnc_get_usuario ();

   --

   -- Função do prestador - WI 8640 - Gilberto C. Lupatini
   CURSOR c_funcao_prestador (vcd_prestador IN NUMBER)
   IS
      SELECT premed_tip_presta.tp_funcao
        FROM dbamv.prestador prestador,
             dbamv.tip_presta tip_presta,
             dbamv.premed_tip_presta premed_tip_presta
       WHERE prestador.cd_prestador = vcd_prestador
         AND tip_presta.cd_tip_presta = prestador.cd_tip_presta
         AND premed_tip_presta.cd_tip_presta = tip_presta.cd_tip_presta;

   --

   -- Função para recuperar a configuração do PAGU
   CURSOR c_config_pagu_tpobjeto (
      ptp_objeto          IN   VARCHAR2,
      pcd_setor_maquina   IN   NUMBER
   )
   IS
      SELECT   cd_configuracao_pagu_presc, sn_presc_futura, cd_objeto,
               tp_centro_custo, cd_setor, cd_setor_config, cd_unid_int
          FROM dbamv.config_pagu_prescricao
         WHERE (cd_setor_config = pcd_setor_maquina OR cd_setor_config IS NULL
               )
           AND (   cd_objeto = pcd_objeto
                OR (    pcd_objeto IS NULL
                    AND cd_objeto IN (SELECT cd_objeto
                                        FROM dbamv.pagu_objeto
                                       WHERE tp_objeto = ptp_objeto)
                   )
               )
      ORDER BY NVL (cd_setor, 0);

   	Cursor C_Atendimento IS
      Select a.Tp_Atendimento Tp_Atendimento
		   , Dbamv.Fnc_Mv_Recupera_Data_Hora(a.Dt_Atendimento, a.Hr_Atendimento) Dh_atendimento
		   , Dbamv.Fnc_Mv_Recupera_Data_Hora(a.Dt_Alta, a.Hr_Alta) Dh_Alta
	    From Dbamv.Atendime a
	   Where a.Cd_Atendimento = pcd_atendimento;
   ---
   vpresc_aberta            NUMBER                                   := 0;
   --vOldCd_Unid_Int Number;

   --
   vtip_prestador           dbamv.premed_tip_presta.tp_funcao%TYPE;
   vcd_objeto               dbamv.pre_med.cd_objeto%TYPE;
   vcd_pre_med              dbamv.pre_med.cd_pre_med%TYPE;
   vcd_prestador            dbamv.pre_med.cd_prestador%TYPE;
   vdt_referencia           dbamv.pre_med.dt_referencia%TYPE;
   vhr_pre_med              dbamv.pre_med.hr_pre_med%TYPE;
   vdt_validade             dbamv.pre_med.dt_validade%TYPE;
   vhr_validade             dbamv.pre_med.dt_validade%TYPE;
   vdh_validade             dbamv.pre_med.dt_validade%TYPE;
   vdh_pre_med              dbamv.pre_med.dt_pre_med%TYPE;
   vdt_pre_med              dbamv.pre_med.dt_pre_med%TYPE;
   vcd_id_usuario           dbamv.pre_med.cd_id_usuario%TYPE;
   vsysdate                 DATE;
   vtp_pre_med              dbamv.pre_med.tp_pre_med%TYPE;
   vfl_principal            dbamv.pre_med.fl_principal%TYPE;
   vnm_usuario              dbamv.pre_med.nm_usuario%TYPE;
   vsn_transcricao          dbamv.pre_med.sn_transcricao%TYPE;
   vfl_impresso             dbamv.pre_med.fl_impresso%TYPE;
   vcd_pre_pad              dbamv.pre_med.cd_pre_pad%TYPE;
   vconfig_pagu_tpobj       c_config_pagu_tpobjeto%ROWTYPE;
   rAtendimento            C_Atendimento%ROWTYPE;
   vVl_parametro            dbamv.pagu_objeto_parametro.vl_parametro%TYPE;
   --
   vdh_premed               DATE;
   --
   vhr_presc_med            DATE;
   vhr_presc_limite_med     DATE;
   vqt_min_adicionais_med   NUMBER;
   --
   vhr_presc_limite_enf     DATE;
   --
   vhr_presc_limite         DATE;
   vdh_atendimento          DATE;
   --
   vrec_pre_med             pkg_pagu_itpremed.typrec_premed;
   --
   vsn_prescricao_futura    VARCHAR2 (1);
   vsn_is_transcricao       VARCHAR2 (1);
   --
   vcd_erro_validacao       NUMBER;
   vds_mensagem_validacao   VARCHAR2 (4000);
   --
   ncddiagnostico           NUMBER;
   vcdcid                   VARCHAR2 (06);
   --
   vds_evolucao             VARCHAR2 (4000);
   --
   i                        INTEGER;
   --
   vqtcirurgia              NUMBER;

   --
   PROCEDURE popular_prescricao
   IS
   BEGIN
      --
      vrec_pre_med.cd_pre_med := vcd_pre_med;
      vrec_pre_med.cd_atendimento := pcd_atendimento;
      vrec_pre_med.dt_referencia := vdt_referencia;
      vrec_pre_med.cd_prestador := vcd_prestador;
      vrec_pre_med.cd_unid_int := pcd_unid_int;
      vrec_pre_med.cd_setor := pcd_setor;
      vrec_pre_med.dh_pre_med := vdh_pre_med;
      vrec_pre_med.dh_validade := vdh_validade;
      vrec_pre_med.tp_pre_med := vtp_pre_med;
      vrec_pre_med.fl_principal := vfl_principal;
      vrec_pre_med.nm_usuario := vnm_usuario;
      vrec_pre_med.sn_transcricao := vsn_transcricao;
      vrec_pre_med.fl_impresso := vfl_impresso;
      vrec_pre_med.cd_pre_pad := vcd_pre_pad;
      vrec_pre_med.cd_objeto := vcd_objeto;
      --
      pkg_pagu_itpremed.pr_premed (vrec_pre_med);
   END;

   --
   PROCEDURE limpa_prescricao
   IS
   BEGIN
      --
      vrec_pre_med.cd_pre_med := NULL;
      vrec_pre_med.cd_atendimento := NULL;
      vrec_pre_med.dt_referencia := NULL;
      vrec_pre_med.cd_prestador := NULL;
      vrec_pre_med.cd_unid_int := NULL;
      vrec_pre_med.cd_setor := NULL;
      vrec_pre_med.dh_pre_med := NULL;
      vrec_pre_med.dh_validade := NULL;
      vrec_pre_med.tp_pre_med := NULL;
      vrec_pre_med.fl_principal := NULL;
      vrec_pre_med.nm_usuario := NULL;
      vrec_pre_med.sn_transcricao := NULL;
      vrec_pre_med.fl_impresso := NULL;
      vrec_pre_med.cd_pre_pad := NULL;
      vrec_pre_med.cd_objeto := NULL;
      --
      pkg_pagu_itpremed.pr_premed (NULL);
   END;
--
BEGIN
   i := 0;
   --
   pkg_pagu.inicializa (TRUE);
   pkg_pagu.pr_atendimento (pcd_atendimento);
   --

   -- Busca configuração do PAGU
   OPEN c_config_pagu_tpobjeto (ptp_objeto, pcd_setor);

   FETCH c_config_pagu_tpobjeto
    INTO vconfig_pagu_tpobj;
   CLOSE c_config_pagu_tpobjeto;

   -- Busca o código do prestador
   OPEN c_prestador;

   FETCH c_prestador
    INTO vcd_prestador;
   CLOSE c_prestador;
   --
   Open C_Atendimento;
	Fetch C_Atendimento Into rAtendimento;
   Close C_Atendimento;

   -- Se não encontra na variável pega no Pkg_Pagu.Fn_Prestador()
   IF vcd_prestador IS NULL
   THEN
      vcd_prestador := dbamv.pkg_pagu.fn_prestador ().cd_prestador;
   END IF;

   --

   -- Função do prestador - WI 8640 - Gilberto C. Lupatini
   OPEN c_funcao_prestador (vcd_prestador);

   FETCH c_funcao_prestador
    INTO vtip_prestador;

   CLOSE c_funcao_prestador;

   --

   -- Recuperar data e hora atual do sistema
   IF pdt_prescricao IS NOT NULL
   THEN
      vsysdate := pdt_prescricao;
   ELSE
      OPEN c_sysdate;

      FETCH c_sysdate
       INTO vsysdate;

      CLOSE c_sysdate;
   END IF;

   vcd_erro_validacao := 0;
   vds_mensagem_validacao := NULL;
   --
   vcd_pre_med := NULL;
   vsn_prescricao_futura := 'N';
   --
   limpa_prescricao;

   --
   OPEN c_premed (vsysdate, vtip_prestador);

   --Fetch C_PreMed Into vCd_Pre_Med, vNm_Usuario, vDs_Evolucao;
   FETCH c_premed
    INTO vrec_pre_med.cd_pre_med, vds_evolucao, vrec_pre_med.cd_atendimento,
         vrec_pre_med.dt_referencia, vrec_pre_med.cd_prestador,
         vrec_pre_med.cd_unid_int, vrec_pre_med.cd_setor,
         vrec_pre_med.dh_pre_med, vrec_pre_med.dh_validade,
         vrec_pre_med.tp_pre_med, vrec_pre_med.fl_principal,
         vrec_pre_med.nm_usuario, vrec_pre_med.sn_transcricao,
         vrec_pre_med.fl_impresso, vrec_pre_med.cd_pre_pad,
         vrec_pre_med.cd_objeto;

   CLOSE c_premed;

   vcd_pre_med := vrec_pre_med.cd_pre_med;

   -- Se não achar a prescricao ou se a prescricao achada for evolucao, então cria uma prescricao nova!
   IF vrec_pre_med.cd_pre_med IS NULL OR vrec_pre_med.cd_objeto <> pcd_objeto
   THEN
      --
      IF pcd_objeto IS NOT NULL
      THEN
         limpa_prescricao;
         vcd_objeto := pcd_objeto;
      ELSE
         -- Prepara array
         popular_prescricao;

         OPEN c_pagu_objeto (ptp_objeto);

         FETCH c_pagu_objeto
          INTO vcd_objeto;

         CLOSE c_pagu_objeto;
      END IF;

      -- Calcular as datas, horarios e validades da prescricao
      vdh_atendimento :=
                dbamv.pkg_pagu.fn_atendimento (pcd_atendimento).dh_atendimento;
      vhr_presc_limite_med :=
         dbamv.pkg_pagu.fn_setor
                            (pkg_pagu.fn_atendimento (pcd_atendimento).cd_setor
                            ).hr_presc_limite_med;
      vhr_presc_limite_enf :=
         dbamv.pkg_pagu.fn_setor
                            (pkg_pagu.fn_atendimento (pcd_atendimento).cd_setor
                            ).hr_presc_limite_enf;
      --
      vsn_is_transcricao := 'N';

      -- Novo modelo de Prescrição
      IF ptp_acao_tela IN ('MVPEP_PRESCRICAO', 'MVPEP_PRESC_TRATAMENTO')
      THEN
         IF ptp_objeto IN ('ADMISS')
         THEN
            vtp_pre_med := 'I';
         ELSIF ptp_objeto IN ('ENFERM')
         THEN
            vtp_pre_med := 'E';
         ELSIF ptp_objeto IN ('INTERN')
         THEN
            vtp_pre_med := 'A';
         ELSIF ptp_objeto IN ('INTERN')
         THEN
            vtp_pre_med := 'A';
         ELSIF ptp_objeto IN ('TRANSC')
         THEN
            vtp_pre_med := 'M';
            vsn_is_transcricao := 'S';
         ELSIF ptp_objeto IN
                           ('RECEIT', 'SOLIMA', 'SOLLAB', 'MEDICA', 'TRATMT')
         THEN
            vtp_pre_med := 'M';

            IF ptp_objeto = 'TRATMT' THEN

				 OPEN c_pagu_objeto_param (pcd_objeto, 'SN_TRANSCRICAO');
				FETCH c_pagu_objeto_param INTO vVl_parametro;
				CLOSE c_pagu_objeto_param;

				IF Nvl(vVl_parametro, 'N') = 'S' THEN
					vsn_is_transcricao := 'S';
				END IF;

            END IF;
         ELSE
-->> caso não seja identificado o tipo de prescrição, o default será de prescrição médica
            vtp_pre_med := 'M';
         END IF;
      -- Prescrição Médica
      ELSIF ptp_acao_tela IN ('PME')
      THEN
         vtp_pre_med := 'M';
      -- Transcricao
      ELSIF ptp_acao_tela IN ('TRA')
      THEN
         vtp_pre_med := 'M';
         vsn_is_transcricao := 'S';
      -- Evolução Médica - WI 3588 (Tiago Verdi Jung)
      ELSIF ptp_acao_tela = 'EVO' AND vtip_prestador = 'M'
      THEN
         vtp_pre_med := 'M';
      -- Evolução de Enfermagem - WI 3588 (Tiago Verdi Jung)
      ELSIF ptp_acao_tela = 'EVO' AND vtip_prestador IN ('E','T','A')
      THEN
         vtp_pre_med := 'E';
      -- Evolução Fisioterapeuta - WI 6263 (Tiago Verdi Jung)
      ELSIF ptp_acao_tela = 'EVO' AND vtip_prestador = 'F'
      THEN
         vtp_pre_med := 'S';
      -- Evolução Nutricionista - WI 4762 (João Paulo Cordenunzi)
      ELSIF ptp_acao_tela = 'EVO' AND vtip_prestador = 'N'
      THEN
         vtp_pre_med := 'N';
      -- Evolução Outros Prestadores - WI 4762 (João Paulo Cordenunzi)
      ELSIF ptp_acao_tela = 'EVO' AND vtip_prestador = 'O'
      THEN
         vtp_pre_med := 'O';
      -- Prescrição de Internado
      ELSIF ptp_acao_tela = 'PIN'
      THEN
         vtp_pre_med := 'A';
      -- Prescrição Futura
      ELSIF ptp_acao_tela = 'PFU'
      THEN
         --- ALTERADO POR MAICON SILVA -- 29/11/2010
         vtp_pre_med := 'M';
         vsn_prescricao_futura := 'S';

		 IF ptp_objeto = 'TRATMT' THEN

			 OPEN c_pagu_objeto_param (pcd_objeto, 'SN_TRANSCRICAO');
			FETCH c_pagu_objeto_param INTO vVl_parametro;
			CLOSE c_pagu_objeto_param;

			IF Nvl(vVl_parametro, 'N') = 'S' THEN
				vsn_is_transcricao := 'S';
			END IF;

		 END IF;
      -- Solicitacao de Exames Laboratoriais
      ELSIF ptp_acao_tela IN ('SEL', 'SEI')
      THEN
         vtp_pre_med := 'M';
      ELSIF ptp_acao_tela = 'PEN'
      THEN
         vtp_pre_med := 'E';                                    -- PDA 309505
      ELSIF ptp_acao_tela = 'AVA'
      THEN
         vtp_pre_med := 'V';
      END IF;

      -- Alteração Inter-Corrência (Inicio)
      IF pdt_prescricao IS NOT NULL
      THEN
         vdt_referencia := pdt_prescricao;
      ELSE
         vdt_referencia :=
            dbamv.fnc_pagu_retorna_data_refer (vtp_pre_med,
                                               vdh_atendimento,
                                               vhr_presc_limite_med,
                                               vhr_presc_limite_enf,
                                               vsysdate
                                              );
      END IF;

      -- Alteração Inter-Corrência (Fim)

      --

      -- Valida se pode criar uma prescricao
      dbamv.prc_mvpep_valida_nova_prescric
         (pcd_atendimento                             -- Codigo do atendimento
                         ,
          vdt_referencia                                 -- Data de referencia
                        ,
          vtp_pre_med                                    -- Tipo de prescricao
                     ,
          vsn_prescricao_futura                           -- Prescricao Futura
                               ,
          'N'                                             -- Não é transcrição
             ,
          FALSE                              -- Não mostrar tela de nova presc
               ,
          vcd_erro_validacao
         -- Variavel que aguarda o retorno da validacao, se = 0 pode continuar
                            ,
          vds_mensagem_validacao,
          ptp_acao_tela
                   -- Variavel que aguarda a mensagem retornada pela validacao
                       ,
          ptp_objeto,
          vcd_objeto
         );                                                      -- PDA 491180

      IF NVL (vcd_erro_validacao, 0) > 0
      THEN
         raise_application_error (-20001, vds_mensagem_validacao);
      END IF;
      --
      -- Calcular as datas, horarios e validades da prescricao
      vhr_presc_med :=
         pkg_pagu.fn_setor (pkg_pagu.fn_atendimento (pcd_atendimento).cd_setor).hr_presc_med;
      vqt_min_adicionais_med :=
         pkg_pagu.fn_setor (pkg_pagu.fn_atendimento (pcd_atendimento).cd_setor).qt_min_adicionais_med;
      vhr_presc_limite_med :=
         pkg_pagu.fn_setor (pkg_pagu.fn_atendimento (pcd_atendimento).cd_setor).hr_presc_limite_med;

      --JAPR - 22/08/2012 - WI 12652
      IF (ptp_objeto = 'ENFERM')
      THEN  -- Recebe os valores configurados para a Presc Enfermagem do Setor
         vhr_presc_med :=
            pkg_pagu.fn_setor
                           (pkg_pagu.fn_atendimento (pcd_atendimento).cd_setor
                           ).hr_presc_enf;
         vqt_min_adicionais_med :=
            pkg_pagu.fn_setor
                            (pkg_pagu.fn_atendimento (pcd_atendimento).cd_setor
                            ).qt_min_adicionais_enf;
         vhr_presc_limite_med :=
            pkg_pagu.fn_setor
                            (pkg_pagu.fn_atendimento (pcd_atendimento).cd_setor
                            ).hr_presc_limite_enf;
      END IF;

      --JAPR - 22/08/2012 - WI 12652

      --
      IF pdh_pre_med IS NOT NULL
      THEN
         vdh_premed := pdh_pre_med;
      ELSIF pdt_prescricao IS NOT NULL
      THEN
         vdh_premed := pdt_prescricao;
      ELSE
         vdh_premed :=
            dbamv.fnc_pagu_presc_ret_dh_premed (pcd_atendimento,
                                                vdt_referencia,
                                                vtp_pre_med,
                                                vhr_presc_med,
                                                vhr_presc_limite_med,
                                                vqt_min_adicionais_med
                                               );
      END IF;

      --
      If pDh_Validade Is Not Null Then -- OP 39982 (inicio)
         vdh_validade := pDh_Validade;
      Else
         vdh_validade := dbamv.fnc_mv_recupera_data_hora (vdt_referencia + 1, Nvl(vhr_presc_med, vsysdate));
      End If; -- OP 39982 (fim)
      --
      vdt_pre_med := TRUNC (vdh_premed);
      vhr_pre_med := vdh_premed;
      vdt_validade := TRUNC (vdh_validade);
      vhr_validade := vdh_validade;

      -- *** Se o horário do sistema for superior ao horário padrão do setor então deverá ser usado o horário do sistema ***
      IF vsysdate BETWEEN vhr_pre_med AND vhr_validade
      THEN
         vhr_pre_med := vsysdate;
      END IF;

      IF ptp_objeto != 'TRATMT'
      THEN
         IF     dbamv.fnc_mv_recupera_data_hora (vdt_pre_med, vhr_pre_med) > rAtendimento.dh_alta
            AND rAtendimento.dh_alta IS NOT NULL
         THEN
            vdt_pre_med := rAtendimento.dh_alta;
            vhr_pre_med := rAtendimento.dh_alta;
         END IF;

         IF     dbamv.fnc_mv_recupera_data_hora (vdt_validade, vhr_validade) > rAtendimento.dh_alta
            AND rAtendimento.dh_alta IS NOT NULL
         THEN
            vdt_validade := rAtendimento.dh_alta;
            vhr_validade := rAtendimento.dh_alta;
         END IF;
      END IF;

      vhr_pre_med := fnc_mv_recupera_data_hora (vdt_pre_med, vhr_pre_med);

      IF vsysdate BETWEEN vhr_pre_med AND vhr_validade
      THEN
         vhr_pre_med := vsysdate;
      END IF;

      --
      ncddiagnostico := Dbamv.pkg_pagu_diagnostico_atendime.fn_diagnostico (pcd_atendimento).cd_diagnostico;
      vcdcid         := pkg_pagu.fn_atendimento (pcd_atendimento).cd_cid;
      vrec_pre_med   := dbamv.fnc_pagu_presc_nova (pcd_atendimento,
                                                   Trunc (vdt_referencia),
                                                   vtp_pre_med,
                                                   vcd_objeto,
                                                   vcd_prestador,
                                                   vdt_pre_med,
                                                   vhr_pre_med,
                                                   vdt_validade,
                                                   vhr_validade,
                                                   vcdcid,
                                                   ncddiagnostico,
                                                   pcd_setor,
                                                   pcd_unid_int,
                                                   vsn_prescricao_futura,
                                                   vsn_is_transcricao,
                                                   Null,
                                                   ptp_acao_tela );                        --- [OP1517] AJVC
      --
      vcd_pre_med := vrec_pre_med.cd_pre_med;
      --
   END IF;
   --
   RETURN vcd_pre_med;
END;