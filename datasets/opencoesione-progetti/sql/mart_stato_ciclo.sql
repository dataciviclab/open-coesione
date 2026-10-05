-- mart_stato_ciclo.sql — avanzamento per ciclo × stato progetto
-- Fonte: clean progetti (4 cicli). KPI dashboard "quanto è fermo/in corso".
SELECT
  OC_DESCR_CICLO AS ciclo,
  COALESCE(NULLIF(trim(OC_STATO_PROGETTO), ''), 'Non determinabile') AS stato,
  COUNT(*) AS n_progetti,
  COUNT(DISTINCT COD_GRANDE_PROGETTO) FILTER (
    WHERE COD_GRANDE_PROGETTO IS NOT NULL AND COD_GRANDE_PROGETTO <> ''
  ) AS n_grandi_progetti,
  SUM(FINANZ_UE) AS finanz_ue_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) AS finanz_tot_pub,
  SUM(OC_COSTO_COESIONE) AS costo_coesione,
  SUM(COSTO_REALIZZATO) AS costo_realizzato,
  SUM(IMPEGNI) AS impegni_tot,
  SUM(TOT_PAGAMENTI) AS pagamenti_tot,
  CASE
    WHEN SUM(OC_COSTO_COESIONE) > 0
    THEN SUM(TOT_PAGAMENTI) / SUM(OC_COSTO_COESIONE)
    ELSE NULL
  END AS ratio_pagamenti_costo
FROM clean_input
GROUP BY 1, 2
ORDER BY ciclo, finanz_ue_tot DESC
