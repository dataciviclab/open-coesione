-- mart_regione_provincia.sql — carico localizzazioni per regione e provincia
SELECT
  DEN_REGIONE AS regione,
  COD_REGIONE AS cod_regione,
  DEN_PROVINCIA AS provincia,
  COD_PROVINCIA AS cod_provincia,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) AS n_progetti,
  COUNT(*) AS n_localizzazioni,
  COUNT(DISTINCT COD_COMUNE) AS n_comuni,
  COUNT(DISTINCT COD_AREA_INTERNA) FILTER (
    WHERE COD_AREA_INTERNA IS NOT NULL AND trim(COD_AREA_INTERNA) <> ''
  ) AS n_aree_interne
FROM clean_input
WHERE DEN_REGIONE IS NOT NULL
  AND trim(DEN_REGIONE) <> ''
  AND DEN_REGIONE NOT LIKE '%:::%'
  AND DEN_PROVINCIA IS NOT NULL
  AND trim(DEN_PROVINCIA) <> ''
  AND DEN_PROVINCIA NOT LIKE '%:::%'
GROUP BY 1, 2, 3, 4
ORDER BY n_progetti DESC
