-- mart_soggetti_ruolo.sql — struttura dei soggetti per ruolo e forma giuridica
SELECT
  SOGG_DESCR_RUOLO AS ruolo,
  SOGG_COD_RUOLO AS cod_ruolo,
  COALESCE(NULLIF(trim(DESCR_FORMA_GIURIDICA_SOGG), ''), 'Non classificata') AS forma_giuridica,
  COUNT(*) AS n_relazioni,
  COUNT(DISTINCT OC_CODICE_FISCALE_SOGG) AS n_soggetti,
  COUNT(DISTINCT COD_LOCALE_PROGETTO) AS n_progetti,
  COUNT(DISTINCT COD_COMUNE_SEDE_SOGG) FILTER (
    WHERE COD_COMUNE_SEDE_SOGG IS NOT NULL AND trim(COD_COMUNE_SEDE_SOGG) <> ''
  ) AS n_comuni_sede,
  COUNT(DISTINCT OC_COD_ENTE_BDAP) FILTER (
    WHERE OC_COD_ENTE_BDAP IS NOT NULL AND trim(OC_COD_ENTE_BDAP) <> ''
  ) AS n_enti_bdap,
  COUNT(DISTINCT OC_COD_ENTE_IPA) FILTER (
    WHERE OC_COD_ENTE_IPA IS NOT NULL AND trim(OC_COD_ENTE_IPA) <> ''
  ) AS n_enti_ipa
FROM clean_input
GROUP BY 1, 2, 3
ORDER BY n_relazioni DESC
