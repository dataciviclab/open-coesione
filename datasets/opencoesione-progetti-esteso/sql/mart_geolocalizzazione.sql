-- mart_geolocalizzazione.sql — aggregazione per regione × provincia
-- Esclude regioni multi-valore (formato "A:::B:::C") che inquinano la mappa.
SELECT
  DEN_REGIONE AS regione,
  DEN_PROVINCIA AS provincia,
  OC_MACROAREA_PROGETTO AS macroarea,
  COUNT(*) AS n_progetti,
  SUM(FINANZ_UE) AS finanz_ue_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) AS finanz_tot_pub,
  SUM(OC_COSTO_COESIONE) AS costo_coesione,
  SUM(TOT_PAGAMENTI) AS pagamenti_tot,
  CASE WHEN SUM(OC_COSTO_COESIONE) > 0 THEN SUM(TOT_PAGAMENTI) / SUM(OC_COSTO_COESIONE) END AS ratio_pagamenti_costo,
  COUNT(DISTINCT OC_TEMA_SINTETICO) AS n_temi_diversi
FROM clean_input
WHERE DEN_REGIONE IS NOT NULL
  AND trim(DEN_REGIONE) <> ''
  AND DEN_REGIONE NOT LIKE '%:::%'
  AND DEN_PROVINCIA IS NOT NULL
  AND trim(DEN_PROVINCIA) <> ''
GROUP BY 1, 2, 3
ORDER BY regione, provincia
