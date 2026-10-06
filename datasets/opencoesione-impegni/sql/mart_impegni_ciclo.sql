-- mart_impegni_ciclo.sql — impegni per ciclo × anno (join progetti)

WITH imp AS (
  SELECT * FROM clean_input
),
progetti AS (
  SELECT
    COD_LOCALE_PROGETTO,
    OC_DESCR_CICLO,
    OC_STATO_PROGETTO,
    FINANZ_UE,
    OC_COSTO_COESIONE,
    TOT_PAGAMENTI,
    IMPEGNI AS snapshot_impegni
  FROM read_parquet('{support.progetti.clean}')
  WHERE COD_LOCALE_PROGETTO IS NOT NULL
),
joined AS (
  SELECT
    p.OC_DESCR_CICLO AS ciclo,
    i.anno,
    i.COD_LOCALE_PROGETTO AS cod_progetto,
    i.IMPEGNI,
    p.FINANZ_UE,
    p.OC_COSTO_COESIONE,
    p.TOT_PAGAMENTI
  FROM imp i
  JOIN progetti p USING (COD_LOCALE_PROGETTO)
)

SELECT
  ciclo,
  anno,
  count(*) AS n_impegni,
  count(DISTINCT cod_progetto) AS n_progetti,
  sum(IMPEGNI) AS totale_impegni,
  sum(IMPEGNI) FILTER (WHERE IMPEGNI < 0) AS totale_storni,
  sum(FINANZ_UE) AS finanz_ue_progetti_joined,
  sum(OC_COSTO_COESIONE) AS costo_coesione_progetti_joined,
  sum(TOT_PAGAMENTI) AS pagamenti_snapshot_progetti_joined
FROM joined
GROUP BY 1, 2
ORDER BY ciclo, anno
