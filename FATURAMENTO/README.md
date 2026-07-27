# Estudo do faturamento Oracle

Validação somente leitura realizada no schema `DBAMV` em 22/06/2026.

## Fontes reais do painel

As consultas fornecidas mostram que o gráfico não é calculado apenas com `ITREG_AMB`, `REG_AMB`, `ITREG_FAT` e `REG_FAT`:

- **Município e Estado:** `DBAMV.V_FFIS_VALOR_PRESTADOR_AIH`, usando `DT_COMPETENCIA` e `VL_LINHA` — equivalente a `VL_SH + VL_SP` nos dados verificados.
- **Convênio e Particular:** cabeçalhos `REG_FAT` e `REG_AMB`, associados por `CD_REMESSA` a `REMESSA_FATURA` e `FATURA`, usando `FATURA.DT_COMPETENCIA` e `VL_TOTAL_CONTA`.
- **Classificação:** `ATENDIME`, `ORI_ATE`, `CONVENIO` e `SUB_PLANO`.

As consultas originais do painel não possuem cláusula `SN_FECHADA = 'S'`. Elas apenas expõem o status para eventual filtro ou medida no Power BI. Portanto, não é correto aplicar fechamento no SQL sem confirmar o DAX/filtro do visual.

## Correspondência com o print

`V_FFIS_VALOR_PRESTADOR_AIH.VL_LINHA` reproduziu exatamente Município e Estado de janeiro a maio. A consulta de contas reproduziu exatamente Convênio e Particular no mesmo período.

| Competência | Série | Print | Oracle atual | Situação |
|---|---|---:|---:|---|
| 01/2026 | Convênio | 4.165.424,07 | 4.165.424,07 | Exato |
| 01/2026 | Município | 1.144.660,98 | 1.144.660,98 | Exato |
| 01/2026 | Estado | 179.900,22 | 179.900,22 | Exato |
| 01/2026 | Particular | 768.641,76 | 768.641,76 | Exato |
| 02/2026 | Convênio | 4.439.215,89 | 4.439.215,89 | Exato |
| 02/2026 | Município | 1.144.529,79 | 1.144.529,79 | Exato |
| 02/2026 | Estado | 149.900,49 | 149.900,49 | Exato |
| 02/2026 | Particular | 475.054,84 | 475.054,84 | Exato |
| 03/2026 | Convênio | 5.455.517,70 | 5.455.517,70 | Exato |
| 03/2026 | Município | 1.144.303,60 | 1.144.303,60 | Exato |
| 03/2026 | Estado | 1.053.139,80 | 1.053.139,80 | Exato |
| 03/2026 | Particular | 437.055,52 | 437.055,52 | Exato |
| 04/2026 | Convênio | 5.569.295,63 | 5.569.295,63 | Exato |
| 04/2026 | Município | 1.144.532,05 | 1.144.532,05 | Exato |
| 04/2026 | Estado | 510.962,82 | 510.962,82 | Exato |
| 04/2026 | Particular | 453.223,51 | 453.223,51 | Exato |
| 05/2026 | Convênio | 5.272.042,16 | 5.272.042,16 | Exato |
| 05/2026 | Município | 1.144.553,39 | 1.144.553,39 | Exato |
| 05/2026 | Estado | 591.387,12 | 591.387,12 | Exato |
| 05/2026 | Particular | 316.679,67 | 316.679,67 | Exato |

Em 22/06/2026, o Oracle já possui valores superiores aos do print em algumas séries recentes:

- Estado 06/2026: print `664.594,54`; Oracle atual `673.555,85`.
- Município 07/2026: print `149.591,23`; Oracle atual `163.490,91`.

Isso indica que o print foi capturado antes dos últimos lançamentos/atualizações da produção.

## Fechamento e remessa

- A competência do gráfico vem de `FATURA.DT_COMPETENCIA` e `V_FFIS_VALOR_PRESTADOR_AIH.DT_COMPETENCIA`, não da data do lançamento.
- A presença de competência nas contas já depende do caminho `conta → remessa → fatura`.
- A consulta do painel usa `REG_FAT.SN_FECHADA` e `REG_AMB.SN_FECHADA` apenas como colunas informativas.
- `ITREG_AMB.SN_FECHADA` não está presente na consulta original do painel.
- `ITREG_FAT` não possui `SN_FECHADA`.

O teste alternativo com `ITREG_AMB.SN_FECHADA = 'S'` permanece documentado em `fechamento_remessa_faturamento.txt`, mas não representa fielmente as fontes fornecidas do painel.

## Problemas técnicos encontrados nas consultas do painel

1. O `JOIN` com `SUB_PLANO` precisa usar `CD_CONVENIO`, `CD_CON_PLA` e `CD_SUB_PLANO`. Sem `CD_CON_PLA`, foram encontradas 271 combinações repetidas entre planos, com risco de multiplicação de valores.
2. A condição `CD_SUB_PLANO <> '200' OR CD_SUB_PLANO <> '300'` é sempre verdadeira para qualquer subplano não nulo. Se a intenção era excluir ambos, o correto é `NOT IN ('200', '300')` ou usar `AND`.
3. No bloco ambulatorial, o código do convênio vem de `REG_AMB`, mas o nome vem do convênio do atendimento. Foram encontrados casos em que código e nome não correspondem.
4. O uso de `DISTINCT` mascara parte das duplicidades, mas não substitui uma chave/grão bem definido.

Esses pontos não devem ser corrigidos silenciosamente no painel atual, pois podem alterar números históricos. Recomenda-se criar uma versão reconciliada e homologá-la em paralelo.

## Artefatos

- `apresentacao_custo_beneficio_zero_glosa.md`: apresentação Marp sobre faturamento, cobertura, custo-benefício e efetividade dos fornecedores 3261/3308.
- `analise_script_implantacao.md`: avaliação da integração e da possibilidade de medir recursos representados/recuperados.
- `recursos_zero_glosa.txt`: resultado das views e estruturas de recurso criadas na implantação.
- `assets/`: gráficos SVG utilizados pela apresentação.
- `dados_custo_efetividade.txt`: pagamentos, custos e faturamento por escopo da contratação.
- `coletar_faturamento_desde_contrato.py`: consulta de faturamento desde fevereiro/2025.
- `coletar_contas_remessas.py`: consulta otimizada de contas em remessa por mês e convênio.
- `script.sql`: reprodução consolidada das fontes reais do painel.
- `fontes_reais_painel.txt`: resultados agregados das fontes fornecidas.
- `reproduzir_fontes_painel.py`: coletor reproduzível em transação `READ ONLY`.
- `MER.md`: modelo entidade-relacionamento.
- `metadados_faturamento.txt`: colunas, PK, FK, índices e comentários.
- `fechamento_remessa_faturamento.txt`: testes anteriores de fechamento/remessa.

## Cuidados de grão

`REG_AMB` e `REG_FAT` são cabeçalhos; `ITREG_AMB` e `ITREG_FAT` são itens. Somar um valor de cabeçalho depois de um `JOIN` 1:N com os itens pode multiplicar a conta. A fonte do painel usa `DISTINCT`, mas o ideal é definir explicitamente uma linha por conta/atendimento antes da agregação.
