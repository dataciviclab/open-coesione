-- clean.sql — OpenCoesione Pagamenti: storico flussi di cassa
-- Input: raw_input (pagamenti.parquet)
-- Output: pagamenti puliti con data, importo, programma, tipo

SELECT
  COD_LOCALE_PROGETTO,
  OC_DATA_PAGAMENTI,
  TOT_PAGAMENTI,
  OC_TOT_PAGAMENTI_RENDICONTAB_UE,
  OC_TOT_PAGAMENTI_FSC,
  OC_TOT_PAGAMENTI_PAC,
  CODICE_PROGRAMMA,
  OC_CODICE_PROGRAMMA,
  OC_TIPO_PAGAMENTI
FROM raw_input
WHERE COD_LOCALE_PROGETTO IS NOT NULL
  AND trim(COD_LOCALE_PROGETTO) <> ''
