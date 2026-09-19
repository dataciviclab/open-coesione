-- mart_programmi.sql — aggregazione per programma operativo
SELECT
  OC_CODICE_PROGRAMMA as codice_programma,
  OC_DESCRIZIONE_PROGRAMMA as descrizione_programma,
  FONDO_COMUNITARIO as fondo,
  OC_DESCR_FONTE as fonte,
  COUNT(*) as n_progetti,
  SUM(FINANZ_UE) as finanz_ue_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) as finanz_tot_pub,
  SUM(OC_COSTO_COESIONE) as costo_coesione,
  SUM(TOT_PAGAMENTI) as pagamenti_tot,
  COUNT(DISTINCT COD_REGIONE) as n_regioni,
  COUNT(DISTINCT OC_TEMA_SINTETICO) as n_temi
FROM clean_input
WHERE OC_CODICE_PROGRAMMA IS NOT NULL AND trim(OC_CODICE_PROGRAMMA) <> ''
GROUP BY 1, 2, 3, 4
ORDER BY finanz_ue_tot DESC
