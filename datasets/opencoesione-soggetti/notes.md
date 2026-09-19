# opencoesione-soggetti — note

## Fonte

- **Ente**: PCM — Dipartimento Politiche di Coesione / OpenCoesione
- **Portale di riferimento**: dati.gov.it (organization: pcm-opencoesione)
- **File**: `soggetti_20260430.parquet` (7.2M righe, 25 colonne)
- **Licenza**: CC BY 4.0
- **Aggiornamento**: 2026-04-30 (data dump)

## Struttura dati

### Raw layer (25 colonne)
- **Identificativi**: COD_LOCALE_PROGETTO (FK a progetti), SOGG_COD_RUOLO, SOGG_PROGR_RUOLO
- **Soggetto**: OC_CODICE_FISCALE_SOGG, OC_DENOMINAZIONE_SOGG
- **Forma giuridica**: COD_FORMA_GIURIDICA_SOGG, DESCR_FORMA_GIURIDICA_SOGG
- **Sede**: COD_COMUNE_SEDE_SOGG, INDIRIZZO_SOGG, CAP_SOGG
- **Settore**: COD_ATECO_SOGG, DESCRIZIONE_ATECO_SOGG
- **Dimensione**: COD_ADDETTI_SOGG, DESCR_ADDETTI_SOGG, COD_DIMENSIONE_SOGG, DESCR_DIMENSIONE_SOGG
- **Soggetto master**: CODICE_FISCALE_SOGGETTO, DENOMINAZIONE_SOGGETTO
- **Codici enti**: OC_COD_ENTE_BDAP, OC_COD_ENTE_IPA (per JOIN con dataset esterni)

### Clean layer (21 colonne)
Tutte le colonne tranne MIUR, SIOPE, ISTAT_S13, SSN (meno utili per analisi finanziarie).

### Mart layer
- **mart_beneficiari**: una riga per CF con:
  - Dati anagrafici (denominazione, forma giuridica, comune, attivita, dimensione)
  - Fascia addetti
  - Codici enti BDAP e IPA (per JOIN)
  - Conteggi per ruolo (totale, beneficiario, programmatore, attuatore)

## Collegamento con progetti

Ogni soggetto è collegato a un progetto tramite `COD_LOCALE_PROGETTO`. Per trovare i beneficiari di un progetto, joinare con `opencoesione_progetti` sul campo `COD_LOCALE_PROGETTO`.

## Uso nel terzo settore

Il dataset è usato da `terzo-settore-intelligence` per identificare quali ETS hanno partecipato a progetti di fondi coesione, tramite join su `OC_CODICE_FISCALE_SOGG`.

## Codici enti (BDAP/IPA)

- **BDAP** (Banca Dati Amministrazioni Pubbliche): identificativo unico dell'amministrazione
- **IPA** (Indice delle Pubbliche Amministrazioni): codice IPA dell'ente
- Utili per JOIN con dataset esterni su amministrazioni pubbliche

## Output v1

Tabella `mart_beneficiari`:
- `codice_fiscale`, `denominazione`, `forma_giuridica`, `comune_sede`
- `attivita_ateco`, `dimensione`, `fascia_addetti`
- `cod_ente_bdap`, `cod_ente_ipa`
- `n_progetti` (totale)
- `n_progetti_beneficiario`, `n_progetti_programmatore`, `n_progetti_attuatore` (per ruolo)

## Prossimi passi

- [x] Espandere clean con codici enti BDAP/IPA (v1)
- [x] Aggiornare mart con conteggi per ruolo (v1)
- [ ] Creare notebook v1 con analisi beneficiari
- [ ] Valutare JOIN con dataset esterni (BDAP, IPA)
- [ ] Valutare aggiunta campi aggregati (costo pubblico per soggetto)
