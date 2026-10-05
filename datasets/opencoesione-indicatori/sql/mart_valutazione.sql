-- mart_valutazione.sql — indicatori per tipo × unità di misura
-- Non sommare totali tra unità diverse: il confronto è il rapporto medio
-- realizzato/programmato all'interno della stessa unità.
SELECT
  TIPO_INDICATORE AS tipo,
  DESCR_UNITA_MISURA AS unita_misura,
  UNITA_MISURA AS cod_unita_misura,
  COUNT(*) AS n_indicatori,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) AS n_progetti,
  COUNT(DISTINCT COD_INDICATORE) AS n_indicatori_distinti,
  SUM(VALORE_PROGRAMMATO) AS totale_programmato,
  SUM(VALORE_REALIZZATO) AS totale_realizzato,
  AVG(
    CASE
      WHEN VALORE_PROGRAMMATO IS NOT NULL AND VALORE_PROGRAMMATO <> 0
      THEN VALORE_REALIZZATO / VALORE_PROGRAMMATO
      ELSE NULL
    END
  ) AS rapporto_medio,
  COUNT(*) FILTER (
    WHERE VALORE_PROGRAMMATO IS NOT NULL
      AND VALORE_PROGRAMMATO <> 0
      AND VALORE_REALIZZATO IS NOT NULL
  ) AS n_con_rapporto
FROM clean_input
WHERE VALORE_PROGRAMMATO IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY n_indicatori DESC
