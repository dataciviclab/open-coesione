-- mart_valutazione.sql — aggregazione valutazione risultati
SELECT
  TIPO_INDICATORE as tipo,
  COUNT(*) as n_indicatori,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) as n_progetti,
  SUM(VALORE_PROGRAMMATO) as totale_programmato,
  SUM(VALORE_REALIZZATO) as totale_realizzato,
  CASE WHEN SUM(VALORE_PROGRAMMATO) > 0
    THEN SUM(VALORE_REALIZZATO) / SUM(VALORE_PROGRAMMATO)
    ELSE NULL
  END as rapporto_realizzazione
FROM clean_input
WHERE VALORE_PROGRAMMATO IS NOT NULL
  AND VALORE_REALIZZATO IS NOT NULL
GROUP BY 1
ORDER BY n_indicatori DESC
