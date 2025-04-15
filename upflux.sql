

-- 1. Criar o usuário
CREATE USER upflux IDENTIFIED BY "dbamvupflux"
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp;

-- 2. Conceder permissão para conexão
GRANT CREATE SESSION TO upflux;

-- 3. Conceder permissão de SELECT nas tabelas especificadas
GRANT SELECT ON dbamv.atendime                  TO upflux;
GRANT SELECT ON dbamv.carteira                  TO upflux;
GRANT SELECT ON dbamv.cid                       TO upflux;
GRANT SELECT ON dbamv.cidade                    TO upflux;
GRANT SELECT ON dbamv.classe                    TO upflux;
GRANT SELECT ON dbamv.con_pla                   TO upflux;
GRANT SELECT ON dbamv.conselho                  TO upflux;
GRANT SELECT ON dbamv.convenio                  TO upflux;
GRANT SELECT ON dbamv.empresa_convenio          TO upflux;
GRANT SELECT ON dbamv.esp_med                   TO upflux;
GRANT SELECT ON dbamv.especialid                TO upflux;
GRANT SELECT ON dbamv.especie                   TO upflux;
GRANT SELECT ON dbamv.exa_lab                   TO upflux;
GRANT SELECT ON dbamv.exa_rx                    TO upflux;
GRANT SELECT ON dbamv.gru_cid                   TO upflux;
GRANT SELECT ON dbamv.gru_fat                   TO upflux;
GRANT SELECT ON dbamv.gru_pro                   TO upflux;
GRANT SELECT ON dbamv.hritpre_cons              TO upflux;
GRANT SELECT ON dbamv.hritpre_med               TO upflux;
GRANT SELECT ON dbamv.itmvto_estoque            TO upflux;
GRANT SELECT ON dbamv.itped_lab                 TO upflux;
GRANT SELECT ON dbamv.itped_rx                  TO upflux;
GRANT SELECT ON dbamv.itpre_med                 TO upflux;
GRANT SELECT ON dbamv.itreg_amb                 TO upflux;
GRANT SELECT ON dbamv.itsolsai_pro              TO upflux;
GRANT SELECT ON dbamv.itsolsai_pro_atendido     TO upflux;
GRANT SELECT ON dbamv.laudo_rx                  TO upflux;
GRANT SELECT ON dbamv.leito                     TO upflux;
GRANT SELECT ON dbamv.log_excl_atendime         TO upflux;
GRANT SELECT ON dbamv.mot_alt                   TO upflux;
GRANT SELECT ON dbamv.multi_empresas            TO upflux;
GRANT SELECT ON dbamv.mvto_estoque              TO upflux;
GRANT SELECT ON dbamv.ori_ate                   TO upflux;
GRANT SELECT ON dbamv.paciente                  TO upflux;
GRANT SELECT ON dbamv.par_med                   TO upflux;
GRANT SELECT ON dbamv.ped_lab                   TO upflux;
GRANT SELECT ON dbamv.ped_rx                    TO upflux;
GRANT SELECT ON dbamv.pre_med                   TO upflux;
GRANT SELECT ON dbamv.prestador                 TO upflux;
GRANT SELECT ON dbamv.pro_fat                   TO upflux;
GRANT SELECT ON dbamv.produto                   TO upflux;
GRANT SELECT ON dbamv.sacr_classificacao        TO upflux;
GRANT SELECT ON dbamv.sacr_classificacao_risco  TO upflux;
GRANT SELECT ON dbamv.sacr_protocolo            TO upflux;
GRANT SELECT ON dbamv.sacr_sintoma_avaliacao    TO upflux;
GRANT SELECT ON dbamv.sacr_tempo_processo       TO upflux;
GRANT SELECT ON dbamv.servico                   TO upflux;
GRANT SELECT ON dbamv.setor                     TO upflux;
GRANT SELECT ON dbamv.sgru_cid                  TO upflux;
GRANT SELECT ON dbamv.tip_acom                  TO upflux;
GRANT SELECT ON dbamv.tip_esq                   TO upflux;
GRANT SELECT ON dbamv.tip_presc                 TO upflux;
GRANT SELECT ON dbamv.triagem_atendimento       TO upflux;
GRANT SELECT ON dbamv.tuss                      TO upflux;
GRANT SELECT ON dbamv.uni_pro                   TO upflux;
GRANT SELECT ON dbamv.unid_int                  TO upflux;
GRANT SELECT ON dbamv.unidade                   TO upflux;
GRANT SELECT ON dbasgu.usuarios                 TO upflux;

-- 4. Conceder permissão de EXECUTE apenas nas funções especificadas
GRANT EXECUTE ON dbamv.fnc_mv_recupera_data_hora TO upflux;
GRANT EXECUTE ON dbamv.verif_vl_custo_medio     TO upflux;




grant execute on dbamv.fnc_ffcv_sn_opme 		 to upflux;
grant execute on dbamv.fnc_sacr_abrevia_nome_pac to upflux;
grant execute on dbamv.pkg_mv2000 				 to upflux;
grant execute on dbamv.verif_ds_unid_prod 		 to upflux;
grant execute on dbamv.verif_vl_custo_medio 	 to upflux;
grant execute on dbamv.verif_vl_fator_prod  	 to upflux;

grant select on dbamv.age_cir				to upflux;
grant select on dbamv.atendime              to upflux;
grant select on dbamv.aviso_cirurgia        to upflux;
grant select on dbamv.cen_cir               to upflux;
grant select on dbamv.cid                   to upflux;
grant select on dbamv.cirurgia              to upflux;
grant select on dbamv.cirurgia_aviso        to upflux;
grant select on dbamv.classe                to upflux;
grant select on dbamv.classifica_asa        to upflux;
grant select on dbamv.convenio              to upflux;
grant select on dbamv.ent_pro               to upflux;
grant select on dbamv.especie               to upflux;
grant select on dbamv.estoque               to upflux;
grant select on dbamv.gru_cid               to upflux;
grant select on dbamv.gru_fat               to upflux;
grant select on dbamv.gru_pro               to upflux;
grant select on dbamv.grupo_cirurgia        to upflux;
grant select on dbamv.guia                  to upflux;
grant select on dbamv.hr_sal_cir 			to upflux;
grant select on dbamv.it_guia               to upflux;
grant select on dbamv.itent_pro             to upflux;
grant select on dbamv.itmvto_estoque        to upflux;
grant select on dbamv.itreg_fat             to upflux;
grant select on dbamv.log_guia              to upflux;
grant select on dbamv.log_mvto_consignado   to upflux;
grant select on dbamv.mot_canc              to upflux;
grant select on dbamv.mov_cc_rpa            to upflux;
grant select on dbamv.multi_empresas        to upflux;
grant select on dbamv.mvto_estoque          to upflux;
grant select on dbamv.ori_ate               to upflux;
grant select on dbamv.paciente              to upflux;
grant select on dbamv.prestador             to upflux;
grant select on dbamv.prestador_aviso       to upflux;
grant select on dbamv.pro_fat               to upflux;
grant select on dbamv.produto               to upflux;
grant select on dbamv.reg_fat               to upflux;
grant select on dbamv.sal_cir               to upflux;
grant select on dbamv.servico               to upflux;
grant select on dbamv.setor                 to upflux;
grant select on dbamv.sgru_cid              to upflux;
grant select on dbamv.sub_grupo_cirurgia    to upflux;
grant select on dbamv.tip_anest             to upflux;
grant select on dbamv.tuss                  to upflux;
grant select on dbamv.uni_pro               to upflux;
grant select on dbasgu.usuarios 			to upflux;


GRANT SELECT ON DBAMV.TIP_RES                 TO upflux;
GRANT SELECT ON DBAMV.SACR_TEMPO_PROCESSO                 TO upflux; -- TABELA NÃO EXISTE
GRANT SELECT ON DBAMV.TRIAGEM_ATENDIMENTO                 TO upflux;
GRANT SELECT ON DBAMV.sacr_tipo_tempo_processo            TO upflux;
GRANT SELECT ON DBAMV.FILA_SENHA            TO upflux;