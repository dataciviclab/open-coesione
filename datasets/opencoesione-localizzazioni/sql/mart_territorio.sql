-- mart_territorio.sql — localizzazioni per regione/provincia/comune
-- Grain corretto: n_progetti = COUNT(DISTINCT COD_LOCALE_PROGETTO), non COUNT(*).
-- n_localizzazioni resta disponibile (progetti multi-sede).
SELECT
  DEN_REGIONE AS regione,
  DEN_PROVINCIA AS provincia,
  DEN_COMUNE AS comune,
  COD_COMUNE AS cod_comune,
  COD_REGIONE AS cod_regione,
  COD_PROVINCIA AS cod_provincia,
  OC_TERRITORIO_PROG AS territorio_tipico,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) AS n_progetti,
  COUNT(*) AS n_localizzazioni,
  COUNT(DISTINCT COD_SLL) AS n_sll
FROM clean_input
WHERE DEN_COMUNE IS NOT NULL
  AND trim(DEN_COMUNE) <> ''
  AND DEN_COMUNE NOT LIKE '%:::%'
  AND DEN_COMUNE <> 'Tutti i comuni'
  AND DEN_REGIONE IS NOT NULL
  AND trim(DEN_REGIONE) <> ''
  AND DEN_REGIONE NOT LIKE '%:::%'
GROUP BY 1, 2, 3, 4, 5, 6, 7
ORDER BY n_progetti DESC
