-- mart_comune_finanziamenti.sql — denaro per comune (storico 4 cicli)
-- clean_input = localizzazioni; progetti da {support.progetti.clean}.
-- Per progetto multi-sede il denaro è diviso per n localizzazioni.

WITH loc AS (
  SELECT *
  FROM clean_input
  WHERE COD_LOCALE_PROGETTO IS NOT NULL
    AND DEN_COMUNE IS NOT NULL
    AND trim(DEN_COMUNE) <> ''
    AND DEN_COMUNE NOT LIKE '%:::%'
    AND DEN_COMUNE <> 'Tutti i comuni'
    AND DEN_REGIONE IS NOT NULL
    AND trim(DEN_REGIONE) <> ''
    AND DEN_REGIONE NOT LIKE '%:::%'
    AND DEN_PROVINCIA IS NOT NULL
    AND trim(DEN_PROVINCIA) <> ''
    AND DEN_PROVINCIA NOT LIKE '%:::%'
),
progetti AS (
  SELECT
    COD_LOCALE_PROGETTO,
    OC_DESCR_CICLO,
    OC_STATO_PROGETTO,
    OC_TEMA_SINTETICO,
    OC_MACROAREA_PROGETTO,
    FINANZ_UE,
    FINANZ_TOTALE_PUBBLICO,
    OC_COSTO_COESIONE,
    TOT_PAGAMENTI,
    IMPEGNI
  FROM read_parquet('{support.progetti.clean}')
  WHERE COD_LOCALE_PROGETTO IS NOT NULL
),
n_loc AS (
  SELECT COD_LOCALE_PROGETTO, count(*) AS n_localizzazioni
  FROM loc
  GROUP BY 1
),
joined AS (
  SELECT
    l.DEN_REGIONE AS regione,
    l.DEN_PROVINCIA AS provincia,
    l.DEN_COMUNE AS comune,
    l.COD_COMUNE AS cod_comune,
    l.OC_TERRITORIO_PROG AS territorio_tipico,
    p.COD_LOCALE_PROGETTO AS cod_progetto,
    p.OC_DESCR_CICLO AS ciclo,
    p.OC_STATO_PROGETTO AS stato,
    p.OC_TEMA_SINTETICO AS tema,
    p.OC_MACROAREA_PROGETTO AS macroarea,
    p.FINANZ_UE / nullif(n.n_localizzazioni, 0) AS finanz_ue_loc,
    p.FINANZ_TOTALE_PUBBLICO / nullif(n.n_localizzazioni, 0) AS finanz_pub_loc,
    p.OC_COSTO_COESIONE / nullif(n.n_localizzazioni, 0) AS costo_loc,
    p.TOT_PAGAMENTI / nullif(n.n_localizzazioni, 0) AS pagamenti_loc,
    p.IMPEGNI / nullif(n.n_localizzazioni, 0) AS impegni_loc
  FROM loc l
  JOIN progetti p USING (COD_LOCALE_PROGETTO)
  JOIN n_loc n USING (COD_LOCALE_PROGETTO)
)

SELECT
  regione,
  provincia,
  comune,
  cod_comune,
  territorio_tipico,
  count(DISTINCT cod_progetto) AS n_progetti,
  count(*) AS n_localizzazioni,
  sum(finanz_ue_loc) AS finanz_ue_attribuito,
  sum(finanz_pub_loc) AS finanz_tot_pub_attribuito,
  sum(costo_loc) AS costo_coesione_attribuito,
  sum(pagamenti_loc) AS pagamenti_attribuiti,
  sum(impegni_loc) AS impegni_attribuiti,
  count(DISTINCT ciclo) AS n_cicli,
  count(DISTINCT tema) AS n_temi
FROM joined
GROUP BY 1, 2, 3, 4, 5
ORDER BY finanz_ue_attribuito DESC NULLS LAST
