-- mart_aree_interne.sql — localizzazioni in Aree Interne (grain: COD_AREA_INTERNA)
-- I nomi DEN_AREA_INTERNA possono ripetersi con/without prefisso: usare il codice.
SELECT
  COD_AREA_INTERNA AS cod_area_interna,
  max(DEN_AREA_INTERNA) AS area_interna,
  CLASSIF_AREA_INTERNA AS classificazione,
  DEN_REGIONE AS regione,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) AS n_progetti,
  COUNT(*) AS n_localizzazioni,
  COUNT(DISTINCT COD_COMUNE) AS n_comuni,
  COUNT(DISTINCT COD_SLL) AS n_sll
FROM clean_input
WHERE COD_AREA_INTERNA IS NOT NULL
  AND trim(COD_AREA_INTERNA) <> ''
  AND DEN_COMUNE IS NOT NULL
  AND trim(DEN_COMUNE) <> ''
  AND DEN_COMUNE NOT LIKE '%:::%'
  AND DEN_REGIONE IS NOT NULL
  AND trim(DEN_REGIONE) <> ''
  AND DEN_REGIONE NOT LIKE '%:::%'
GROUP BY 1, 3, 4
ORDER BY n_progetti DESC
