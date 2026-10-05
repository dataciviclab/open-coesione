-- mart_territorio_finanziamenti.sql — denaro per macroarea × ciclo
-- clean_input = localizzazioni; progetti da support (macroarea/ciclo sul progetto).

WITH progetti AS (
  SELECT
    COD_LOCALE_PROGETTO,
    OC_DESCR_CICLO,
    OC_STATO_PROGETTO,
    COALESCE(NULLIF(trim(OC_MACROAREA_PROGETTO), ''), 'Non classificata') AS macroarea,
    COALESCE(NULLIF(trim(OC_TEMA_SINTETICO), ''), 'Non classificato') AS tema,
    FINANZ_UE,
    FINANZ_TOTALE_PUBBLICO,
    OC_COSTO_COESIONE,
    TOT_PAGAMENTI,
    IMPEGNI
  FROM read_parquet('{support.progetti.clean}')
  WHERE COD_LOCALE_PROGETTO IS NOT NULL
)

SELECT
  macroarea,
  OC_DESCR_CICLO AS ciclo,
  count(*) AS n_progetti,
  count(DISTINCT tema) AS n_temi,
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
FROM progetti
GROUP BY 1, 2
ORDER BY macroarea, ciclo
