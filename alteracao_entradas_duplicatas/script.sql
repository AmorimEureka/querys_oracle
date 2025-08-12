-- PROCEDIMENTO ALTERAÇÃO DE ENTRADA

DECLARE
    v_total_novo   NUMBER;
    v_total_antigo NUMBER;
    v_cd_forn      NUMBER;
    v_nr_doc       VARCHAR2(50);
    v_dt_venc      DATE;
BEGIN

    v_total_novo   := :VL_TOTAL_NOVO;
    v_total_antigo := :VL_TOTAL_ANTIGO;
    v_cd_forn      := :CD_FORNECEDOR;
    v_nr_doc       := :NR_DOCUMENTO_ANTIGO;
    v_dt_venc      := TO_DATE( :DT_VENCIMENTO , 'DD/MM/YYYY');

  -- Desabilitar a trigger
  EXECUTE IMMEDIATE 'ALTER TRIGGER DBAMV.TRG_DUPLICATA_COTA DISABLE';

  -- Entrada no estoque
  UPDATE dbamv.ent_pro
     SET VL_TOTAL = v_total_novo
   WHERE cd_fornecedor = v_cd_forn
     AND nr_documento  = v_nr_doc
     AND VL_TOTAL      = v_total_antigo;

  -- Entrada no contas a pagar
  UPDATE dbamv.documento_entrada
     SET VL_TOTAL = v_total_novo
   WHERE cd_fornecedor = v_cd_forn
     AND nr_documento  = v_nr_doc
     AND VL_TOTAL      = v_total_antigo;

  -- Duplicata
  UPDATE dbamv.duplicata
     SET VL_PARCELA = v_total_novo
   WHERE cd_fornecedor       = v_cd_forn
     AND nr_documento        = v_nr_doc
     AND TRUNC(dt_vencimento) = TRUNC(v_dt_venc);

  COMMIT;

  -- Reabilitar a trigger
  EXECUTE IMMEDIATE 'ALTER TRIGGER DBAMV.TRG_DUPLICATA_COTA ENABLE';
EXCEPTION
  WHEN OTHERS THEN
    -- Se ocorrer erro, reabilitar a trigger para não ficar desabilitada
    EXECUTE IMMEDIATE 'ALTER TRIGGER DBAMV.TRG_DUPLICATA_COTA ENABLE';
    RAISE;
END;