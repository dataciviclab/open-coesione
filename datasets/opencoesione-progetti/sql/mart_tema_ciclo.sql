-- mart_tema_ciclo.sql — aggregazione per tema × ciclo × macroarea (4 cicli)
-- Input: clean_input (progetti puliti)
-- Output: mart_tema_ciclo

SELECT
  OC_DESCR_CICLO AS ciclo,
  COALESCE(NULLIF(trim(OC_TEMA_SINTETICO), ''), 'Non classificato') AS tema,
  COALESCE(NULLIF(trim(OC_MACROAREA_PROGETTO), ''), 'Non classificata') AS macroarea,

  -- Conteggi
  COUNT(*) AS n_progetti,
  COUNT(DISTINCT COD_GRANDE_PROGETTO) FILTER (
    WHERE COD_GRANDE_PROGETTO IS NOT NULL AND COD_GRANDE_PROGETTO <> ''
  ) AS n_grandi_progetti,

  -- Finanziamenti lordi
  SUM(FINANZ_UE) AS finanz_ue_tot,
  SUM(FINANZ_UE_FESR) AS finanz_fesr_tot,
  SUM(FINANZ_UE_FSE) AS finanz_fse_tot,
  SUM(FINANZ_UE_ALTRO) AS finanz_ue_altro_tot,
  SUM(FINANZ_STATO_FSC) AS finanz_fsc_tot,
  SUM(FINANZ_STATO_PAC) AS finanz_pac_tot,
  SUM(FINANZ_REGIONE) AS finanz_regione_tot,
  SUM(FINANZ_PROVINCIA) AS finanz_provincia_tot,
  SUM(FINANZ_COMUNE) AS finanz_comune_tot,
  SUM(FINANZ_PRIVATO) AS finanz_privato_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) AS finanz_tot_pub,

  -- Finanziamenti netti
  SUM(OC_FINANZ_UE_NETTO) AS finanz_ue_netto_tot,
  SUM(OC_FINANZ_TOT_PUB_NETTO) AS finanz_tot_pub_netto,

  -- Costo e realizzazione
  SUM(OC_COSTO_COESIONE) AS costo_coesione,
  SUM(COSTO_REALIZZATO) AS costo_realizzato,

  -- Economie
  SUM(ECONOMIE_TOTALI) AS economie_tot,
  SUM(ECONOMIE_TOTALI_PUBBLICHE) AS economie_pubbliche_tot,

  -- Impegni e pagamenti
  SUM(IMPEGNI) AS impegni_tot,
  SUM(OC_IMPEGNI_COESIONE) AS impegni_coesione_tot,
  SUM(TOT_PAGAMENTI) AS pagamenti_tot,
  SUM(OC_PAGAMENTI_COESIONE) AS pagamenti_coesione_tot,
  SUM(OC_TOT_PAGAMENTI_BENEFICIARI) AS pagamenti_beneficiari_tot,

  -- Ratio utili
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
  CASE
    WHEN SUM(FINANZ_TOTALE_PUBBLICO) > 0
    THEN SUM(OC_FINANZ_TOT_PUB_NETTO) / SUM(FINANZ_TOTALE_PUBBLICO)
    ELSE NULL
  END AS ratio_netto_lordo

FROM clean_input
GROUP BY 1, 2, 3
ORDER BY ciclo, tema, macroarea
