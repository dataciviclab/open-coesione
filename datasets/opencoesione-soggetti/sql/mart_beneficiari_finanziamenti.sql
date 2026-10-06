-- mart_beneficiari_finanziamenti.sql — denaro per beneficiario (CF)
-- clean_input = soggetti; progetti da {support.progetti.clean}.
-- Allocazione onesta: denaro di progetto diviso per n beneficiari distinti
-- validi (evita di gonfiare i totali con progetti multi-beneficiario).
-- Placeholder '*CODICE FISCALE*' esclusi.

WITH progetti AS (
  SELECT
    COD_LOCALE_PROGETTO,
    OC_DESCR_CICLO,
    FINANZ_UE,
    FINANZ_TOTALE_PUBBLICO,
    OC_COSTO_COESIONE,
    TOT_PAGAMENTI,
    IMPEGNI
  FROM read_parquet('{support.progetti.clean}')
  WHERE COD_LOCALE_PROGETTO IS NOT NULL
    AND trim(COD_LOCALE_PROGETTO) <> ''
),
soggetti_benef AS (
  SELECT *
  FROM clean_input
  WHERE lower(SOGG_DESCR_RUOLO) LIKE '%beneficiario%'
    AND OC_CODICE_FISCALE_SOGG IS NOT NULL
    AND trim(OC_CODICE_FISCALE_SOGG) <> ''
    AND OC_CODICE_FISCALE_SOGG <> '*CODICE FISCALE*'
),
n_beneficiari AS (
  SELECT
    COD_LOCALE_PROGETTO,
    count(DISTINCT OC_CODICE_FISCALE_SOGG) AS n_beneficiari
  FROM soggetti_benef
  GROUP BY 1
)

SELECT
  s.OC_CODICE_FISCALE_SOGG AS codice_fiscale,
  max(s.OC_DENOMINAZIONE_SOGG) AS denominazione,
  max(s.DESCR_FORMA_GIURIDICA_SOGG) AS forma_giuridica,
  max(s.COD_COMUNE_SEDE_SOGG) AS cod_comune_sede,
  max(s.DESCRIZIONE_ATECO_SOGG) AS attivita_ateco,
  max(s.DESCR_DIMENSIONE_SOGG) AS dimensione,
  count(DISTINCT s.COD_LOCALE_PROGETTO) AS n_progetti_beneficiario,
  count(DISTINCT p.OC_DESCR_CICLO) AS n_cicli,
  sum(p.FINANZ_UE / nullif(n.n_beneficiari, 0)) AS finanz_ue_attribuito,
  sum(p.FINANZ_TOTALE_PUBBLICO / nullif(n.n_beneficiari, 0)) AS finanz_tot_pub_attribuito,
  sum(p.OC_COSTO_COESIONE / nullif(n.n_beneficiari, 0)) AS costo_coesione_attribuito,
  sum(p.TOT_PAGAMENTI / nullif(n.n_beneficiari, 0)) AS pagamenti_attribuiti,
  sum(p.IMPEGNI / nullif(n.n_beneficiari, 0)) AS impegni_attribuiti,
  avg(p.FINANZ_UE) AS media_finanz_ue_progetto
FROM soggetti_benef s
JOIN progetti p USING (COD_LOCALE_PROGETTO)
JOIN n_beneficiari n USING (COD_LOCALE_PROGETTO)
GROUP BY 1
ORDER BY finanz_ue_attribuito DESC NULLS LAST
