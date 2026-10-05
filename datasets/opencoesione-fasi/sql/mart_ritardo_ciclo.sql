-- mart_ritardo_ciclo.sql — sintesi ritardo per ciclo (dashboard KPI)

WITH fasi AS (
  SELECT *
  FROM clean_input
),
progetti AS (
  SELECT
    COD_LOCALE_PROGETTO,
    OC_DESCR_CICLO,
    OC_STATO_PROGETTO,
    FINANZ_UE,
    OC_COSTO_COESIONE,
    TOT_PAGAMENTI
  FROM read_parquet('{support.progetti.clean}')
  WHERE COD_LOCALE_PROGETTO IS NOT NULL
),
per_progetto AS (
  SELECT
    p.OC_DESCR_CICLO AS ciclo,
    f.COD_LOCALE_PROGETTO AS cod_progetto,
    max(p.FINANZ_UE) AS finanz_ue,
    max(p.OC_COSTO_COESIONE) AS costo_coesione,
    max(p.TOT_PAGAMENTI) AS pagamenti,
    avg(f.ritardo_giorni_fine) AS ritardo_medio_progetto,
    max(f.ritardo_giorni_fine) AS ritardo_max_progetto
  FROM fasi f
  JOIN progetti p USING (COD_LOCALE_PROGETTO)
  WHERE f.ritardo_giorni_fine IS NOT NULL
  GROUP BY 1, 2
)

SELECT
  ciclo,
  count(*) AS n_progetti,
  avg(ritardo_medio_progetto) AS ritardo_medio_giorni,
  median(ritardo_medio_progetto) AS ritardo_mediano_giorni,
  quantile_cont(ritardo_medio_progetto, 0.9) AS ritardo_p90_giorni,
  count(*) FILTER (WHERE ritardo_medio_progetto > 0) AS n_progetti_in_ritardo,
  count(*) FILTER (WHERE ritardo_medio_progetto <= 0) AS n_progetti_in_orario,
  sum(finanz_ue) FILTER (WHERE ritardo_medio_progetto > 0) AS finanz_ue_in_ritardo,
  sum(finanz_ue) AS finanz_ue_con_date,
  sum(costo_coesione) AS costo_coesione_con_date,
  sum(pagamenti) AS pagamenti_con_date,
  CASE
    WHEN sum(costo_coesione) > 0
    THEN sum(pagamenti) / sum(costo_coesione)
    ELSE NULL
  END AS ratio_pagamenti_costo
FROM per_progetto
GROUP BY 1
ORDER BY ciclo
