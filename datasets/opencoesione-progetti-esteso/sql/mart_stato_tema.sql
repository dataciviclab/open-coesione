-- mart_stato_tema.sql — avanzamento 2021-2027 per tema × stato
SELECT
  COALESCE(NULLIF(trim(OC_TEMA_SINTETICO), ''), 'Non classificato') AS tema,
  COALESCE(NULLIF(trim(OC_STATO_PROGETTO), ''), 'Non determinabile') AS stato,
  OC_MACROAREA_PROGETTO AS macroarea,
  COUNT(*) AS n_progetti,
  SUM(FINANZ_UE) AS finanz_ue_tot,
  SUM(OC_COSTO_COESIONE) AS costo_coesione,
  SUM(TOT_PAGAMENTI) AS pagamenti_tot,
  SUM(IMPEGNI) AS impegni_tot,
  CASE
    WHEN SUM(OC_COSTO_COESIONE) > 0
    THEN SUM(TOT_PAGAMENTI) / SUM(OC_COSTO_COESIONE)
    ELSE NULL
  END AS ratio_pagamenti_costo
FROM clean_input
GROUP BY 1, 2, 3
ORDER BY tema, finanz_ue_tot DESC
