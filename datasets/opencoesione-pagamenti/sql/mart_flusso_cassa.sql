-- mart_flusso_cassa.sql — aggregazione pagamenti per anno
SELECT
  (OC_DATA_PAGAMENTI / 10000) as anno,
  COUNT(*) as n_pagamenti,
  SUM(TOT_PAGAMENTI) as totale_pagamenti,
  SUM(OC_TOT_PAGAMENTI_RENDICONTAB_UE) as totale_rendicontabile_ue,
  SUM(OC_TOT_PAGAMENTI_FSC) as totale_fsc,
  SUM(OC_TOT_PAGAMENTI_PAC) as totale_pac,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) as n_progetti
FROM clean_input
WHERE OC_DATA_PAGAMENTI IS NOT NULL
GROUP BY 1
ORDER BY anno
