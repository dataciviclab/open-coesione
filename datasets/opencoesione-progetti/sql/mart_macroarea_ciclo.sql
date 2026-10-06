-- mart_macroarea_ciclo.sql — denaro per macroarea × ciclo (4 cicli)
-- Vive su progetti: legge solo clean_input (nessun join a localizzazioni).
-- (In precedenza era su localizzazioni come mart_territorio_finanziamenti
--  ma non usava il clean di localizzazioni — spostato qui.)

SELECT
  COALESCE(NULLIF(trim(OC_MACROAREA_PROGETTO), ''), 'Non classificata') AS macroarea,
  OC_DESCR_CICLO AS ciclo,
  count(*) AS n_progetti,
  count(DISTINCT OC_TEMA_SINTETICO) AS n_temi,
  sum(FINANZ_UE) AS finanz_ue_tot,
  sum(FINANZ_TOTALE_PUBBLICO) AS finanz_tot_pub,
  sum(OC_COSTO_COESIONE) AS costo_coesione,
  sum(TOT_PAGAMENTI) AS pagamenti_tot,
  sum(IMPEGNI) AS impegni_tot,
  CASE
    WHEN sum(OC_COSTO_COESIONE) > 0
    THEN sum(TOT_PAGAMENTI) / sum(OC_COSTO_COESIONE)
    ELSE NULL
  END AS ratio_pagamenti_costo
FROM clean_input
GROUP BY 1, 2
ORDER BY macroarea, ciclo
