# opencoesione-progetti

Progetti finanziati dalle politiche di coesione in Italia (2007-2027).

## Fonte

OpenCoesione / PCM — Dipartimento Politiche di Coesione. Dati harvestati su dati.gov.it.
File Parquet scaricabile da opencoesione.gov.it. Licenza CC BY 4.0.

## Cosa contiene

2.3 milioni di progetti con 95 colonne: dati anagrafici, finanziari (finanziamenti, impegni, pagamenti), tematici e di avanzamento.

## Struttura dati

### Campi principali
- **Identificativi**: COD_LOCALE_PROGETTO, CUP, OC_LINK
- **Titolo/descrizione**: OC_TITOLO_PROGETTO, OC_SINTESI_PROGETTO
- **Ciclo**: 2000-2006, 2007-2013, 2014-2020, 2021-2027
- **Tema**: 11 categorie (Ambiente, Energia, Trasporti, Occupazione, ecc.)
- **Geografia**: macroarea (Centro-Nord, Mezzogiorno, Estero, ecc.)
- **Finanziamenti**: UE (FESR, FSE), FSC, regione, provincia, comune, privato
- **Stati**: progetto, procedurale, finanziario, fase corrente
- **Date**: inizio, fine prevista, fine effettiva

### Campi CUP dettagliati
- Natura (acquisto, infrastruttura, contributo, ecc.)
- Settore (istruzione, ricerca, trasporti, ecc.)
- Categoria (dettaglio finestra CUP)

## Output

- **clean** (50 colonne): selezione delle colonne più utili da 95 raw
- **mart_tema_ciclo**: 149 righe, aggregazione per ciclo × tema × macroarea con:
  - Conteggi progetti e grandi progetti
  - Finanziamenti lordi e netti per fonte
  - Costo, realizzazione, economie
  - Impegni e pagamenti
  - Ratio utili (pagamenti/costo, impegni/costo, netto/lordo)

## Uso

```bash
# Pipeline completa
toolkit run --config datasets/opencoesione-progetti/dataset.yml

# Solo clean
toolkit run clean -c datasets/opencoesione-progetti/dataset.yml --year 2026

# Solo mart
toolkit run mart -c datasets/opencoesione-progetti/dataset.yml --year 2026
```

## Campi non disponibili nel parquet flat

I seguenti campi sono disponibili solo via API REST (nested nei progetti):
- Programmi operativi (FESR, FSE, PON, POR)
- Fasi procedurali (timeline)
- Indicatori di realizzazione
- Storico impegni e pagamenti
