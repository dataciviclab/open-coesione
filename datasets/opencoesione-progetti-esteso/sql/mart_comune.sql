-- mart_comune.sql — finanziamenti per comune (ciclo 2021-2027, tracciato esteso)
-- Esclude comuni multi-valore (A:::B) e vuoti; il denaro è per progetto con
-- comune anagrafico principale del tracciato esteso.
SELECT
  DEN_REGIONE AS regione,
  DEN_PROVINCIA AS provincia,
  DEN_COMUNE AS comune,
  COD_COMUNE AS cod_comune,
  OC_MACROAREA_PROGETTO AS macroarea,
  COUNT(*) AS n_progetti,
  SUM(FINANZ_UE) AS finanz_ue_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) AS finanz_tot_pub,
  SUM(OC_COSTO_COESIONE) AS costo_coesione,
  SUM(TOT_PAGAMENTI) AS pagamenti_tot,
  SUM(IMPEGNI) AS impegni_tot,
  CASE
    WHEN SUM(OC_COSTO_COESIONE) > 0
    THEN SUM(TOT_PAGAMENTI) / SUM(OC_COSTO_COESIONE)
    ELSE NULL
  END AS ratio_pagamenti_costo,
  COUNT(DISTINCT OC_TEMA_SINTETICO) AS n_temi
FROM clean_input
WHERE DEN_COMUNE IS NOT NULL
  AND trim(DEN_COMUNE) <> ''
  AND DEN_COMUNE NOT LIKE '%:::%'
  AND DEN_REGIONE IS NOT NULL
  AND trim(DEN_REGIONE) <> ''
  AND DEN_REGIONE NOT LIKE '%:::%'
  AND DEN_PROVINCIA IS NOT NULL
  AND trim(DEN_PROVINCIA) <> ''
  AND DEN_PROVINCIA NOT LIKE '%:::%'
GROUP BY 1, 2, 3, 4, 5
ORDER BY finanz_ue_tot DESC
