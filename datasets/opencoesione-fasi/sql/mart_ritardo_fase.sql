-- mart_ritardo_fase.sql — ritardo per fase procedurale
-- clean_input = fasi; ciclo/stato da {support.progetti.clean}.

WITH fasi AS (
  SELECT *
  FROM clean_input
),
progetti AS (
  SELECT
    COD_LOCALE_PROGETTO,
    OC_DESCR_CICLO,
    OC_STATO_PROGETTO,
    OC_TEMA_SINTETICO,
    OC_MACROAREA_PROGETTO,
    FINANZ_UE,
    OC_COSTO_COESIONE,
    TOT_PAGAMENTI
  FROM read_parquet('{support.progetti.clean}')
  WHERE COD_LOCALE_PROGETTO IS NOT NULL
)

SELECT
  f.OC_DESCR_FASE AS fase,
  f.OC_COD_FASE AS cod_fase,
  p.OC_DESCR_CICLO AS ciclo,
  count(*) AS n_fasi,
  count(DISTINCT f.COD_LOCALE_PROGETTO) AS n_progetti,
  count(*) FILTER (
    WHERE f.ritardo_giorni_fine IS NOT NULL
  ) AS n_con_ritardo_fine,
  avg(f.ritardo_giorni_fine) AS ritardo_medio_giorni,
  median(f.ritardo_giorni_fine) AS ritardo_mediano_giorni,
  quantile_cont(f.ritardo_giorni_fine, 0.9) AS ritardo_p90_giorni,
  count(*) FILTER (WHERE f.ritardo_giorni_fine > 0) AS n_in_ritardo,
  count(*) FILTER (WHERE f.ritardo_giorni_fine <= 0) AS n_in_orario_o_anticipo,
  sum(p.FINANZ_UE) FILTER (
    WHERE f.ritardo_giorni_fine IS NOT NULL AND f.ritardo_giorni_fine > 0
  ) AS finanz_ue_progetti_in_ritardo
FROM fasi f
JOIN progetti p USING (COD_LOCALE_PROGETTO)
GROUP BY 1, 2, 3
ORDER BY ciclo, n_fasi DESC
