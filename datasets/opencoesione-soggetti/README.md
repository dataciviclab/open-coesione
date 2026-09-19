# opencoesione-soggetti

Soggetti coinvolti nei progetti di politiche di coesione in Italia (2007-2027).

## Fonte

OpenCoesione / PCM — Dipartimento Politiche di Coesione. Dati harvestati su dati.gov.it.
File Parquet scaricabile da opencoesione.gov.it. Licenza CC BY 4.0.

## Cosa contiene

7.2 milioni di righe con 25 colonne. Soggetti (enti, imprese, amministrazioni) coinvolti nei progetti di coesione come beneficiari, partner, coordinatori. Ogni riga collega un soggetto (CF) a un progetto (COD_LOCALE_PROGETTO) con ruolo, forma giuridica e sede.

## Struttura dati

### Campi principali
- **Collegamento**: COD_LOCALE_PROGETTO (FK a progetti)
- **Ruolo**: SOGG_COD_RUOLO, SOGG_DESCR_RUOLO (Beneficiario, Programmatore, Attuatore, Realizzatore)
- **Soggetto**: OC_CODICE_FISCALE_SOGG, OC_DENOMINAZIONE_SOGG
- **Forma giuridica**: COD_FORMA_GIURIDICA_SOGG, DESCR_FORMA_GIURIDICA_SOGG
- **Sede**: COD_COMUNE_SEDE_SOGG, INDIRIZZO_SOGG, CAP_SOGG
- **Settore**: COD_ATECO_SOGG, DESCRIZIONE_ATECO_SOGG
- **Dimensione**: COD_ADDETTI_SOGG, DESCR_ADDETTI_SOGG, COD_DIMENSIONE_SOGG, DESCR_DIMENSIONE_SOGG
- **Codici enti**: OC_COD_ENTE_BDAP, OC_COD_ENTE_IPA (per JOIN con dataset esterni)

## Output

- **clean** (21 colonne): tutte le colonne utili da 25 raw
- **mart_beneficiari**: 534K righe, una riga per CF con:
  - Dati anagrafici (denominazione, forma giuridica, comune, attivita, dimensione)
  - Fascia addetti
  - Codici enti BDAP e IPA (per JOIN)
  - Conteggi per ruolo (totale, beneficiario, programmatore, attuatore)

## Uso

```bash
# Pipeline completa
toolkit run --config datasets/opencoesione-soggetti/dataset.yml

# Solo clean
toolkit run clean -c datasets/opencoesione-soggetti/dataset.yml --year 2026

# Solo mart
toolkit run mart -c datasets/opencoesione-soggetti/dataset.yml --year 2026
```

## Collegamento con progetti

Ogni soggetto è collegato a un progetto tramite `COD_LOCALE_PROGETTO`. Per trovare i beneficiari di un progetto, joinare con `opencoesione_progetti` sul campo `COD_LOCALE_PROGETTO`.

## Uso nel terzo settore

Il dataset è usato da `terzo-settore-intelligence` per identificare quali ETS hanno partecipato a progetti di fondi coesione, tramite join su `OC_CODICE_FISCALE_SOGG`.
