-- mart_impegni_anno.sql — serie storica impegni per anno

SELECT
  anno,
  count(*) AS n_impegni,
  count(DISTINCT COD_LOCALE_PROGETTO) AS n_progetti,
  sum(IMPEGNI) AS totale_impegni,
  sum(IMPEGNI) FILTER (WHERE IMPEGNI < 0) AS totale_storni,
  sum(IMPEGNI) FILTER (WHERE OC_TIPO_IMPEGNI = 'I') AS totale_impegni_tipo_i,
  avg(IMPEGNI) AS media_impegno
FROM clean_input
WHERE anno >= 2000
GROUP BY 1
ORDER BY anno
