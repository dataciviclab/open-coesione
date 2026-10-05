-- mart_flusso_cassa.sql — aggregazione pagamenti per anno
-- NOTA: OC_DATA_PAGAMENTI è INTEGER YYYYMMDD. Usare CAST intero:
-- la divisione float (DATA/10000) produce anno "2024.0101" e rompe le serie.
SELECT
  CAST(OC_DATA_PAGAMENTI / 10000 AS INTEGER) AS anno,
  COUNT(*) AS n_pagamenti,
  SUM(TOT_PAGAMENTI) AS totale_pagamenti,
  SUM(OC_TOT_PAGAMENTI_RENDICONTAB_UE) AS totale_rendicontabile_ue,
  SUM(OC_TOT_PAGAMENTI_FSC) AS totale_fsc,
  SUM(OC_TOT_PAGAMENTI_PAC) AS totale_pac,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) AS n_progetti
FROM clean_input
WHERE OC_DATA_PAGAMENTI IS NOT NULL
  AND OC_DATA_PAGAMENTI >= 20000101
GROUP BY 1
ORDER BY anno
