-- mart_geolocalizzazione.sql — aggregazione per regione × provincia
SELECT
  DEN_REGIONE as regione,
  DEN_PROVINCIA as provincia,
  OC_MACROAREA_PROGETTO as macroarea,
  COUNT(*) as n_progetti,
  SUM(FINANZ_UE) as finanz_ue_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) as finanz_tot_pub,
  SUM(OC_COSTO_COESIONE) as costo_coesione,
  SUM(TOT_PAGAMENTI) as pagamenti_tot,
  CASE WHEN SUM(OC_COSTO_COESIONE) > 0 THEN SUM(TOT_PAGAMENTI) / SUM(OC_COSTO_COESIONE) END as ratio_pagamenti_costo,
  COUNT(DISTINCT OC_TEMA_SINTETICO) as n_temi_diversi
FROM clean_input
WHERE DEN_REGIONE IS NOT NULL AND trim(DEN_REGIONE) <> ''
GROUP BY 1, 2, 3
ORDER BY regione, provincia
