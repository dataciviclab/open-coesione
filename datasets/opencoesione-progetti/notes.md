# opencoesione-progetti — note

## Fonte

- **Ente**: PCM — Dipartimento Politiche di Coesione / OpenCoesione
- **Portale di riferimento**: dati.gov.it (organization: pcm-opencoesione)
- **File**: `progetti_20260430.parquet` (2.3M righe, 95 colonne)
- **Licenza**: CC BY 4.0
- **Aggiornamento**: 2026-04-30 (data dump)
- **Issue intake**: #440

## Struttura dati

### Raw layer (95 colonne)
- **Identificativi**: COD_LOCALE_PROGETTO, CUP, OC_LINK
- **Titolo/descrizione**: OC_TITOLO_PROGETTO, OC_SINTESI_PROGETTO
- **Ciclo**: OC_COD_CICLO, OC_DESCR_CICLO
- **Tema**: OC_COD_TEMA_SINTETICO, OC_TEMA_SINTETICO
- **Grande progetto**: COD_GRANDE_PROGETTO, DESCRIZIONE_GRANDE_PROGETTO
- **Dettagli CUP**: natura, settore, categoria (cod + descr)
- **Tipo aiuto**: OC_COD_TIPO_AIUTO, OC_DESCR_TIPO_AIUTO
- **Geografia**: OC_MACROAREA, OC_COD_SLL, OC_DENOMINAZIONE_SLL
- **Settore**: COD_ATECO, DESCRIZIONE_ATECO
- **Stati**: OC_STATO_PROGETTO, OC_STATO_PROCEDURALE, OC_STATO_FINANZIARIO, fase corrente
- **Date**: inizio, fine prevista, fine effettiva
- **Finanziamenti lordi**: UE (totale + FESR + FSE), FSC, regione, provincia, comune, privato, totale pubblico
- **Finanziamenti netti**: versione netta di tutti i precedenti
- **Costo/coesione**: OC_COSTO_COESIONE, COSTO_REALIZZATO
- **Economie**: totali e pubbliche
- **Impegni**: totali, giuridici vincolanti, coesione
- **Pagamenti**: totali, beneficiari, coesione
- **Meta**: DATA_AGGIORNAMENTO

### Clean layer (50 colonne)
Selezione delle colonne più utili per analisi. Escluse:
- Versioni NETTO dei finanziamenti (tranne UE e totale)
- Dettagli CUP meno importanti (tipologia, sottosettore)
- Flag di visualizzazione

### Mart layer
- **mart_tema_ciclo**: aggregazione per ciclo × tema × macroarea con:
  - Conteggi (progetti, grandi progetti)
  - Finanziamenti lordi e netti per fonte
  - Costo, realizzazione, economie
  - Impegni e pagamenti
  - Ratio utili (pagamenti/costo, impegni/costo, netto/lordo)

## Decisioni di framing

- v0 usa il parquet perché più veloce e pulito
- La granularità geografica è macroarea (non regione) — per analisi regionali servirebbe il CSV esteso o join con `soggetti`
- I campi nested (programmi, fasi, indicatori, storico) non sono nel parquet flat — disponibili solo via API REST
- Le versioni NETTO dei finanziamenti sono state limitate a UE e totale per ridurre la dimensionalità

## Limiti noti

- `OC_MACROAREA` ha solo 6 valori — nessun dettaglio regionale
- Le date sono INTEGER (formato YYYYMMDD) — non ancora normalizzate in DATE
- I progetti multi-regione potrebbero essere classificati come "Ambito Nazionale" o "Trasversale"
- Campi nested (programmi, fasi, indicatori) non disponibili nel parquet flat

## Output v1

Tabella `mart_tema_ciclo`:
- `ciclo`, `tema`, `macroarea`
- `n_progetti`, `n_grandi_progetti`
- `finanz_ue_tot`, `finanz_fesr_tot`, `finanz_fse_tot`, `finanz_fsc_tot`, `finanz_regione_tot`, `finanz_privato_tot`, `finanz_tot_pub`
- `finanz_ue_netto_tot`, `finanz_tot_pub_netto`
- `costo_coesione`, `costo_realizzato`
- `economie_tot`, `economie_pubbliche_tot`
- `impegni_tot`, `impegni_coesione_tot`
- `pagamenti_tot`, `pagamenti_coesione_tot`, `pagamenti_beneficiari_tot`
- `ratio_pagamenti_costo`, `ratio_impegni_costo`, `ratio_netto_lordo`

## Prossimi passi

- [x] Espandere clean con colonne utili (v1)
- [x] Aggiornare mart con più metriche (v1)
- [ ] Creare notebook v1 con visualizzazioni
- [ ] Valutare aggiunta mart per grandi progetti
- [ ] Valutare switch a CSV esteso per granularità regionale in v2
