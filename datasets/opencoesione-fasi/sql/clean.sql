-- clean.sql — OpenCoesione fasi procedurali
-- Input: raw_input (fasi_20260630.parquet)
-- Date INTEGER YYYYMMDD → DATE via strptime (CAST diretto fallisce in DuckDB).

SELECT
  COD_LOCALE_PROGETTO,
  OC_COD_FASE,
  OC_DESCR_FASE,
  TRY_CAST(strptime(CAST(DATA_INIZIO_PREVISTA AS VARCHAR), '%Y%m%d') AS DATE) AS data_inizio_prevista,
  TRY_CAST(strptime(CAST(DATA_INIZIO_EFFETTIVA AS VARCHAR), '%Y%m%d') AS DATE) AS data_inizio_effettiva,
  TRY_CAST(strptime(CAST(DATA_FINE_PREVISTA AS VARCHAR), '%Y%m%d') AS DATE) AS data_fine_prevista,
  TRY_CAST(strptime(CAST(DATA_FINE_EFFETTIVA AS VARCHAR), '%Y%m%d') AS DATE) AS data_fine_effettiva,
  CASE
    WHEN DATA_FINE_EFFETTIVA IS NOT NULL AND DATA_FINE_PREVISTA IS NOT NULL
    THEN DATE_DIFF(
      'day',
      TRY_CAST(strptime(CAST(DATA_FINE_PREVISTA AS VARCHAR), '%Y%m%d') AS DATE),
      TRY_CAST(strptime(CAST(DATA_FINE_EFFETTIVA AS VARCHAR), '%Y%m%d') AS DATE)
    )
    ELSE NULL
  END AS ritardo_giorni_fine,
  CASE
    WHEN DATA_INIZIO_EFFETTIVA IS NOT NULL AND DATA_INIZIO_PREVISTA IS NOT NULL
    THEN DATE_DIFF(
      'day',
      TRY_CAST(strptime(CAST(DATA_INIZIO_PREVISTA AS VARCHAR), '%Y%m%d') AS DATE),
      TRY_CAST(strptime(CAST(DATA_INIZIO_EFFETTIVA AS VARCHAR), '%Y%m%d') AS DATE)
    )
    ELSE NULL
  END AS ritardo_giorni_inizio
FROM raw_input
WHERE COD_LOCALE_PROGETTO IS NOT NULL
  AND trim(COD_LOCALE_PROGETTO) <> ''
  AND OC_COD_FASE IS NOT NULL
  AND trim(OC_COD_FASE) <> ''
