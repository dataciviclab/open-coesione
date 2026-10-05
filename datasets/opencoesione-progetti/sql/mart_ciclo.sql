-- mart_ciclo.sql — KPI sintetici per ciclo di programmazione (panoramica dashboard)
SELECT
  OC_DESCR_CICLO AS ciclo,
  MIN(OC_COD_CICLO) AS cod_ciclo,
  COUNT(*) AS n_progetti,
  COUNT(DISTINCT COD_GRANDE_PROGETTO) FILTER (
    WHERE COD_GRANDE_PROGETTO IS NOT NULL AND COD_GRANDE_PROGETTO <> ''
  ) AS n_grandi_progetti,
  COUNT(DISTINCT OC_TEMA_SINTETICO) AS n_temi,
  COUNT(DISTINCT OC_MACROAREA_PROGETTO) FILTER (
    WHERE OC_MACROAREA_PROGETTO IS NOT NULL AND trim(OC_MACROAREA_PROGETTO) <> ''
  ) AS n_macroaree,
  SUM(FINANZ_UE) AS finanz_ue_tot,
  SUM(FINANZ_UE_FESR) AS finanz_fesr_tot,
  SUM(FINANZ_UE_FSE) AS finanz_fse_tot,
  SUM(FINANZ_STATO_FSC) AS finanz_fsc_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) AS finanz_tot_pub,
  SUM(OC_COSTO_COESIONE) AS costo_coesione,
  SUM(COSTO_REALIZZATO) AS costo_realizzato,
  SUM(IMPEGNI) AS impegni_tot,
  SUM(TOT_PAGAMENTI) AS pagamenti_tot,
  CASE
    WHEN SUM(OC_COSTO_COESIONE) > 0
    THEN SUM(TOT_PAGAMENTI) / SUM(OC_COSTO_COESIONE)
    ELSE NULL
  END AS ratio_pagamenti_costo,
  CASE
    WHEN SUM(OC_COSTO_COESIONE) > 0
    THEN SUM(IMPEGNI) / SUM(OC_COSTO_COESIONE)
    ELSE NULL
  END AS ratio_impegni_costo,
  MIN(DATA_AGGIORNAMENTO) AS data_agg_min,
  MAX(DATA_AGGIORNAMENTO) AS data_agg_max
FROM clean_input
GROUP BY 1
ORDER BY ciclo
