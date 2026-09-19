-- mart.sql — OpenCoesione: aggregazioni per tema, ciclo, macroarea
-- Input: clean_input (progetti puliti)
-- Output: aggregazioni per analisi finanziaria e operativa

-- Mart principale: aggregazione per tema × ciclo × macroarea
SELECT
  OC_DESCR_CICLO as ciclo,
  OC_TEMA_SINTETICO as tema,
  OC_MACROAREA as macroarea,
  
  -- Conteggi
  COUNT(*) as n_progetti,
  COUNT(DISTINCT COD_GRANDE_PROGETTO) FILTER (WHERE COD_GRANDE_PROGETTO IS NOT NULL AND COD_GRANDE_PROGETTO <> '') as n_grandi_progetti,
  
  -- Finanziamenti lordi
  SUM(FINANZ_UE) as finanz_ue_tot,
  SUM(FINANZ_UE_FESR) as finanz_fesr_tot,
  SUM(FINANZ_UE_FSE) as finanz_fse_tot,
  SUM(FINANZ_STATO_FSC) as finanz_fsc_tot,
  SUM(FINANZ_REGIONE) as finanz_regione_tot,
  SUM(FINANZ_PRIVATO) as finanz_privato_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) as finanz_tot_pub,
  
  -- Finanziamenti netti
  SUM(OC_FINANZ_UE_NETTO) as finanz_ue_netto_tot,
  SUM(OC_FINANZ_TOT_PUB_NETTO) as finanz_tot_pub_netto,
  
  -- Costo e realizzazione
  SUM(OC_COSTO_COESIONE) as costo_coesione,
  SUM(COSTO_REALIZZATO) as costo_realizzato,
  
  -- Economie
  SUM(ECONOMIE_TOTALI) as economie_tot,
  SUM(ECONOMIE_TOTALI_PUBBLICHE) as economie_pubbliche_tot,
  
  -- Impegni e pagamenti
  SUM(IMPEGNI) as impegni_tot,
  SUM(OC_IMPEGNI_COESIONE) as impegni_coesione_tot,
  SUM(TOT_PAGAMENTI) as pagamenti_tot,
  SUM(OC_PAGAMENTI_COESIONE) as pagamenti_coesione_tot,
  SUM(OC_TOT_PAGAMENTI_BENEFICIARI) as pagamenti_beneficiari_tot,
  
  -- Ratio utili
  CASE
    WHEN SUM(OC_COSTO_COESIONE) > 0
    THEN SUM(TOT_PAGAMENTI) / SUM(OC_COSTO_COESIONE)
    ELSE NULL
  END as ratio_pagamenti_costo,
  CASE
    WHEN SUM(OC_COSTO_COESIONE) > 0
    THEN SUM(IMPEGNI) / SUM(OC_COSTO_COESIONE)
    ELSE NULL
  END as ratio_impegni_costo,
  CASE
    WHEN SUM(FINANZ_TOTALE_PUBBLICO) > 0
    THEN SUM(OC_FINANZ_TOT_PUB_NETTO) / SUM(FINANZ_TOTALE_PUBBLICO)
    ELSE NULL
  END as ratio_netto_lordo

FROM clean_input
GROUP BY 1, 2, 3
ORDER BY ciclo, tema, macroarea
