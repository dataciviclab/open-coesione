-- mart_indicatori_tipo.sql — aggregazione per tipo e unità di misura
SELECT
  TIPO_INDICATORE as tipo,
  DESCR_UNITA_MISURA as unita_misura,
  COUNT(*) as n_indicatori,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) as n_progetti,
  AVG(VALORE_PROGRAMMATO) as media_programmato,
  AVG(VALORE_REALIZZATO) as media_realizzato,
  CASE WHEN AVG(VALORE_PROGRAMMATO) > 0
    THEN AVG(VALORE_REALIZZATO) / AVG(VALORE_PROGRAMMATO)
    ELSE NULL
  END as rapporto_medio
FROM clean_input
WHERE VALORE_PROGRAMMATO IS NOT NULL
  AND VALORE_REALIZZATO IS NOT NULL
  AND VALORE_PROGRAMMATO > 0
GROUP BY 1, 2
HAVING COUNT(*) >= 10
ORDER BY n_indicatori DESC
