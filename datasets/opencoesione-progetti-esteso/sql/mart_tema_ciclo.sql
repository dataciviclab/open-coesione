-- mart_tema_ciclo.sql — aggregazione per tema × ciclo × macroarea
SELECT
  OC_DESCR_CICLO as ciclo,
  OC_TEMA_SINTETICO as tema,
  OC_MACROAREA as macroarea,
  COUNT(*) as n_progetti,
  COUNT(DISTINCT COD_GRANDE_PROGETTO) FILTER (WHERE COD_GRANDE_PROGETTO IS NOT NULL AND COD_GRANDE_PROGETTO <> '') as n_grandi_progetti,
  SUM(FINANZ_UE) as finanz_ue_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) as finanz_tot_pub,
  SUM(OC_COSTO_COESIONE) as costo_coesione,
  SUM(COSTO_REALIZZATO) as costo_realizzato,
  SUM(IMPEGNI) as impegni_tot,
  SUM(TOT_PAGAMENTI) as pagamenti_tot,
  SUM(OC_TOT_PAGAMENTI_BENEFICIARI) as pagamenti_beneficiari_tot,
  CASE WHEN SUM(OC_COSTO_COESIONE) > 0 THEN SUM(TOT_PAGAMENTI) / SUM(OC_COSTO_COESIONE) END as ratio_pagamenti_costo,
  CASE WHEN SUM(FINANZ_TOTALE_PUBBLICO) > 0 THEN SUM(OC_COSTO_COESIONE) / SUM(FINANZ_TOTALE_PUBBLICO) END as ratio_costo_lordo
FROM clean_input
GROUP BY 1, 2, 3
ORDER BY ciclo, tema, macroarea
