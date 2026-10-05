# opencoesione-progetti

Progetti finanziati dalle politiche di coesione in Italia — **base dati completa, 4 cicli** (2000-2027).

## Ruolo nel repo

Dataset **hub storico**: anello di join tra progetti e gli altri dataset del repo
(pagamenti, localizzazioni, soggetti, indicatori) e delle tabelle supporto di fonte
(fasi, impegni — non ancora onboardate).

Differenza con `opencoesione-progetti-esteso`:

| | **progetti (questo)** | **progetti-esteso** |
|---|---|---|
| Cicli | 2000-2006, 2007-2013, 2014-2020, 2021-2027 | solo 2021-2027 |
| Righe (dump 2026-06-30) | ~2,33M | ~130K |
| Colonne raw | 97 | 201 |
| Geografia | macroarea + SLL | + regione, provincia, comune |
| Programmi | no | sì (codice, fonte, articolazioni) |
| Ruoli CF | no | beneficiario/programmatore/attuatore |
| Uso | storico, join, mart tema×ciclo | analisi 2021-27 |

Gli 130K COD di esteso sono un sottoinsieme di questo flat (ciclo 2021-2027).

## Fonte

- **Ente**: PCM — Dipartimento Politiche di Coesione / OpenCoesione
- **Portale**: [opencoesione.gov.it/opendata](https://opencoesione.gov.it/it/opendata/)
- **File**: `progetti_20260630.parquet` (2.331.215 righe, 97 colonne)
- **URL**: `https://opencoesione.gov.it/media/open_data/progetti_20260630.parquet`
- **Licenza**: CC BY 4.0
- **Aggiornamento fonte**: bimestrale (questo config punta al dump 30/06/2026)
- **Issue intake storica**: dataset-incubator #440 (candidato migrato qui)

## Cosa contiene

- **Identificativi**: COD_LOCALE_PROGETTO, CUP, OC_LINK
- **Ciclo**: 2000-2006, 2007-2013, 2014-2020, 2021-2027
- **Tema sintetico** (11 categorie OC_)
- **Geografia**: `OC_MACROAREA_PROGETTO`, `OC_MACROAREA_PROGRAMMA`, SLL
- **Finanziamenti** lordi/netti per fonte (UE FESR/FSE/altro, FSC, PAC, regione, provincia, comune, privato)
- **Costo coesione**, economie, impegni, pagamenti snapshot
- **Stati** progetto / procedurale / finanziario, fase corrente
- **Date** inizio, fine prevista, fine effettiva (INTEGER YYYYMMDD)
- **Flag** aggregato / progetto aggregato

## Output pipeline

- **clean**: ~60 colonne selezionate (vedi `sql/clean.sql`)
- **mart_tema_ciclo**: ciclo × tema × macroarea con finanziamenti, costo, impegni, pagamenti e ratio

### Limiti noti

- Granularità geografica solo **macroarea + SLL** (non comune) — per il dettaglio usare esteso o localizzazioni
- Date INTEGER, non normalizzate in DATE
- Campi nested (programmi, fasi, indicatori storici) non nel parquet flat — disponibili via dataset separati / API
- I progetti 2021-2027 presenti qui ma non in esteso sono ~43k e valgono <1% del finanziamento UE del ciclo

## Uso

```bash
# Pipeline completa
toolkit run --config datasets/opencoesione-progetti/dataset.yml

# Solo clean
toolkit run clean -c datasets/opencoesione-progetti/dataset.yml --year 2026

# Solo mart
toolkit run mart -c datasets/opencoesione-progetti/dataset.yml --year 2026
```

GCS (dopo post-merge): `gs://dataciviclab-clean/open-coesione/opencoesione_progetti/2026/`
e `gs://dataciviclab-mart/open-coesione/opencoesione_progetti/2026/`.
