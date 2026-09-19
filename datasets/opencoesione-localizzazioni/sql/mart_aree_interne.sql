-- mart_aree_interne.sql — aggregazione per area interna
SELECT
  DEN_AREA_INTERNA as area_interna,
  CLASSIF_AREA_INTERNA as classificazione,
  DEN_REGIONE as regione,
  COUNT(*) as n_progetti,
  COUNT(DISTINCT COD_COMUNE) as n_comuni,
  COUNT(DISTINCT COD_SLL) as n_sll
FROM clean_input
WHERE COD_AREA_INTERNA IS NOT NULL
  AND trim(COD_AREA_INTERNA) <> ''
  AND DEN_AREA_INTERNA IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY n_progetti DESC
