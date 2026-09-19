-- mart_pagamenti_programma.sql — aggregazione pagamenti per programma
SELECT
  OC_CODICE_PROGRAMMA as codice_programma,
  CODICE_PROGRAMMA as codice_programma_fonte,
  COUNT(*) as n_pagamenti,
  SUM(TOT_PAGAMENTI) as totale_pagamenti,
  SUM(OC_TOT_PAGAMENTI_RENDICONTAB_UE) as totale_rendicontabile_ue,
  MIN(OC_DATA_PAGAMENTI) as primo_pagamento,
  MAX(OC_DATA_PAGAMENTI) as ultimo_pagamento,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) as n_progetti
FROM clean_input
WHERE OC_CODICE_PROGRAMMA IS NOT NULL
  AND trim(OC_CODICE_PROGRAMMA) <> ''
GROUP BY 1, 2
ORDER BY totale_pagamenti DESC
