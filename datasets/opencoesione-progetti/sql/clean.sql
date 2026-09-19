-- clean.sql — OpenCoesione Progetti: espansione con tutte le colonne utili
-- Input: raw_input (progetti_20260430.parquet)
-- Output: progetti puliti con titolo, sintesi, dettagli CUP, finanziamenti completi

SELECT
  -- Identificativi
  COD_LOCALE_PROGETTO,
  CUP,
  OC_LINK,
  
  -- Titolo e descrizione
  OC_TITOLO_PROGETTO,
  OC_SINTESI_PROGETTO,
  
  -- Ciclo di programmazione
  OC_COD_CICLO,
  OC_DESCR_CICLO,
  
  -- Tema
  OC_COD_TEMA_SINTETICO,
  OC_TEMA_SINTETICO,
  
  -- Grande progetto
  COD_GRANDE_PROGETTO,
  DESCRIZIONE_GRANDE_PROGETTO,
  
  -- Dettagli CUP (natura, settore, categoria)
  CUP_COD_NATURA,
  CUP_DESCR_NATURA,
  CUP_COD_SETTORE,
  CUP_DESCR_SETTORE,
  CUP_COD_CATEGORIA,
  CUP_DESCR_CATEGORIA,
  
  -- Tipo aiuto
  OC_COD_TIPO_AIUTO,
  OC_DESCR_TIPO_AIUTO,
  
  -- Geografia
  OC_MACROAREA,
  OC_COD_SLL,
  OC_DENOMINAZIONE_SLL,
  
  -- Settore economico
  COD_ATECO,
  DESCRIZIONE_ATECO,
  
  -- Stati
  OC_STATO_PROGETTO,
  OC_STATO_PROCEDURALE,
  OC_STATO_FINANZIARIO,
  OC_COD_FASE_CORRENTE,
  OC_DESCR_FASE_CORRENTE,
  
  -- Date
  OC_DATA_INIZIO_PROGETTO,
  OC_DATA_FINE_PROGETTO_PREVISTA,
  OC_DATA_FINE_PROGETTO_EFFETTIVA,
  
  -- Finanziamenti lordi (per fonte)
  FINANZ_UE,
  FINANZ_UE_FESR,
  FINANZ_UE_FSE,
  FINANZ_STATO_FSC,
  FINANZ_REGIONE,
  FINANZ_PROVINCIA,
  FINANZ_COMUNE,
  FINANZ_PRIVATO,
  FINANZ_TOTALE_PUBBLICO,
  
  -- Finanziamenti netti (al netto economie)
  OC_FINANZ_UE_NETTO,
  OC_FINANZ_TOT_PUB_NETTO,
  
  -- Costo e coesione
  OC_COSTO_COESIONE,
  COSTO_REALIZZATO,
  
  -- Economie
  ECONOMIE_TOTALI,
  ECONOMIE_TOTALI_PUBBLICHE,
  
  -- Impegni
  IMPEGNI,
  OC_IMPEGNI_GIURID_VINCOLANTI,
  OC_IMPEGNI_COESIONE,
  
  -- Pagamenti
  TOT_PAGAMENTI,
  OC_TOT_PAGAMENTI_BENEFICIARI,
  OC_PAGAMENTI_COESIONE,
  
  -- Data aggiornamento
  DATA_AGGIORNAMENTO

FROM raw_input
WHERE OC_MACROAREA IS NOT NULL
  AND trim(OC_MACROAREA) <> ''
  AND OC_TEMA_SINTETICO IS NOT NULL
  AND trim(OC_TEMA_SINTETICO) <> ''
