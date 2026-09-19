-- clean.sql — OpenCoesione Localizzazioni: geolocalizzazione progetti
-- Input: raw_input (localizzazioni.parquet)
-- Output: localizzazioni pulite con regione, provincia, comune, SLL, aree interne

SELECT
  COD_LOCALE_PROGETTO,
  COD_REGIONE,
  DEN_REGIONE,
  COD_PROVINCIA,
  DEN_PROVINCIA,
  COD_COMUNE,
  DEN_COMUNE,
  COD_SLL,
  DEN_SLL,
  COD_AREA_INTERNA,
  DEN_AREA_INTERNA,
  CLASSIF_AREA_INTERNA,
  INDIRIZZO_PROG,
  CAP_PROG,
  OC_TERRITORIO_PROG
FROM raw_input
WHERE COD_LOCALE_PROGETTO IS NOT NULL
  AND trim(COD_LOCALE_PROGETTO) <> ''
