-- mart_territorio.sql — aggregazione per regione × provincia × comune
SELECT
  DEN_REGIONE as regione,
  DEN_PROVINCIA as provincia,
  DEN_COMUNE as comune,
  COUNT(*) as n_progetti,
  COUNT(DISTINCT COD_SLL) as n_sll,
  COUNT(DISTINCT COD_AREA_INTERNA) FILTER (WHERE COD_AREA_INTERNA IS NOT NULL AND COD_AREA_INTERNA <> '') as n_aree_interne,
  MAX(OC_TERRITORIO_PROG) as territorio_tipico
FROM clean_input
WHERE DEN_REGIONE IS NOT NULL AND trim(DEN_REGIONE) <> ''
GROUP BY 1, 2, 3
ORDER BY regione, provincia, comune
