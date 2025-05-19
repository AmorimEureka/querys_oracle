-- PROCEDIMENTO ALTERAÇÃO DE ENTRADA

DECLARE
  vNR_DOCUMENTO_NOVO    VARCHAR2(20);
  vNR_DOCUMENTO_ANTIGO  VARCHAR2(20);
  vCD_FORNECEDOR        NUMBER;
  vDT_VENCIMENTO        VARCHAR2(10);
BEGIN
  vNR_DOCUMENTO_NOVO    := '148020';
  vNR_DOCUMENTO_ANTIGO  := '18020'  ;
  vCD_FORNECEDOR        := 830      ;
  vDT_VENCIMENTO        := '02/06/2025';

  -- Desabilitar a trigger
  EXECUTE IMMEDIATE 'ALTER TRIGGER DBAMV.TRG_DUPLICATA_COTA DISABLE';

  -- Alteração na Tabela de ENTRADA pro estoque
  UPDATE dbamv.ent_pro
  SET nr_documento = vNR_DOCUMENTO_NOVO
  WHERE cd_fornecedor =  vCD_FORNECEDOR AND nr_documento = vNR_DOCUMENTO_ANTIGO;

  -- Alteração na Tabela de ENTRADAS pro Contas A Pagar
  UPDATE dbamv.documento_entrada
  SET nr_documento = vNR_DOCUMENTO_NOVO
  WHERE  cd_fornecedor = vCD_FORNECEDOR AND nr_documento = vNR_DOCUMENTO_ANTIGO;

  -- Alteração na Tabela de DUPLICATAS
  UPDATE dbamv.duplicata
  SET nr_documento = vNR_DOCUMENTO_NOVO
  WHERE cd_fornecedor = vCD_FORNECEDOR
    AND nr_documento = vNR_DOCUMENTO_ANTIGO
    AND TRUNC(dt_vencimento) = TO_DATE(vDT_VENCIMENTO, 'dd/mm/yyyy');

  COMMIT;  -- confirma a alteração

  -- Reabilitar a trigger
  EXECUTE IMMEDIATE 'ALTER TRIGGER DBAMV.TRG_DUPLICATA_COTA ENABLE';

EXCEPTION
  WHEN OTHERS THEN
    -- Se ocorrer erro, reabilitar a trigger para não ficar desabilitada
    EXECUTE IMMEDIATE 'ALTER TRIGGER DBAMV.TRG_DUPLICATA_COTA ENABLE';
    RAISE;
END;