-- clean.sql — OpenCoesione Indicatori: valutazione risultati
-- Input: raw_input (indicatori.parquet)
-- Output: indicatori puliti con valori programmati e realizzati

SELECT
  COD_LOCALE_PROGETTO,
  TIPO_INDICATORE,
  COD_INDICATORE,
  DESCR_INDICATORE,
  UNITA_MISURA,
  DESCR_UNITA_MISURA,
  VALORE_PROGRAMMATO,
  VALORE_REALIZZATO,
  OC_FLAG_VISUAL_INDICATORE
FROM raw_input
WHERE COD_LOCALE_PROGETTO IS NOT NULL
  AND trim(COD_LOCALE_PROGETTO) <> ''
