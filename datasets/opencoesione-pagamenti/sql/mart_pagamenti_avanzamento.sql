-- mart_pagamenti_avanzamento.sql — pagamenti per ciclo × stato × anno
-- clean_input = pagamenti; progetti da {support.progetti.clean}.
-- Sblocca la lettura "quando esce la cassa" per stato di avanzamento.

WITH pag AS (
  SELECT
    COD_LOCALE_PROGETTO,
    CAST(OC_DATA_PAGAMENTI / 10000 AS INTEGER) AS anno,
    OC_DATA_PAGAMENTI,
    TOT_PAGAMENTI,
    OC_TOT_PAGAMENTI_RENDICONTAB_UE,
    OC_TOT_PAGAMENTI_FSC,
    OC_TOT_PAGAMENTI_PAC,
    OC_CODICE_PROGRAMMA
  FROM clean_input
  WHERE OC_DATA_PAGAMENTI IS NOT NULL
    AND OC_DATA_PAGAMENTI >= 20000101
),
progetti AS (
  SELECT
    COD_LOCALE_PROGETTO,
    OC_DESCR_CICLO,
    OC_STATO_PROGETTO,
    OC_TEMA_SINTETICO,
    OC_MACROAREA_PROGETTO
  FROM read_parquet('{support.progetti.clean}')
  WHERE COD_LOCALE_PROGETTO IS NOT NULL
)

SELECT
  p.OC_DESCR_CICLO AS ciclo,
  COALESCE(NULLIF(trim(p.OC_STATO_PROGETTO), ''), 'Non determinabile') AS stato,
  g.anno,
  count(*) AS n_pagamenti,
  count(DISTINCT g.COD_LOCALE_PROGETTO) AS n_progetti,
  sum(g.TOT_PAGAMENTI) AS totale_pagamenti,
  sum(g.OC_TOT_PAGAMENTI_RENDICONTAB_UE) AS totale_rendicontabile_ue,
  sum(g.OC_TOT_PAGAMENTI_FSC) AS totale_fsc,
  sum(g.OC_TOT_PAGAMENTI_PAC) AS totale_pac,
  count(DISTINCT g.OC_CODICE_PROGRAMMA) AS n_programmi
FROM pag g
JOIN progetti p USING (COD_LOCALE_PROGETTO)
GROUP BY 1, 2, 3
ORDER BY ciclo, stato, anno
