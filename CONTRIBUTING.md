# Contributing a open-coesione

Guida alla contribuzione per il dataset OpenCoesione.

## Setup locale

```bash
git clone https://github.com/dataciviclab/open-coesione.git
cd open-coesione

# Installa il repo in editable con toolkit (extra pipeline)
pip install -e ".[pipeline]"

# Preflight su tutte le config
make check
```

## Pipeline

Ogni dataset segue il flusso: `RAW -> CLEAN -> MART`

| Comando | Quando | Costo |
|---|---|---|
| `make check` | sempre, prima di ogni PR | leggero (preflight) |
| `make run-dataset DATASET=<slug>` | sviluppo su un dataset | dipende |
| `make run-light` | iterazione locale | medio (niente fasi/impegni) |
| `make run-batch` | CI su PR merged (batch.txt) | solo dataset cambiati |
| `make run-all` | schedule/dispatch mensile | **pesante** (multi-M righe) |
| `make verify` | post-run, smoke mart | leggero |
| `pytest tests/` | CI check + locale | leggero |

> `make run` senza argomenti è ambiguo (toolkit default): preferisci
> `run-dataset`, `run-light` o `run-all` in base al caso.

## Struttura

```
datasets/
├── <slug>/
│   ├── dataset.yml      # Configurazione pipeline
│   ├── sql/
│   │   ├── clean.sql    # Pulizia raw -> clean
│   │   └── mart*.sql    # Aggregazioni clean -> mart
│   ├── README.md        # Documentazione dataset
│   └── notes.md         # Note tecniche
scripts/
└── verify_output.py     # Smoke output mart
tests/
└── test_dataset_configs.py
```

## Regole

1. **RAW**: dati originali, nessuna trasformazione
2. **CLEAN**: pulizia, normalizzazione, tipizzazione
3. **MART**: aggregazioni analitiche per dashboard/notebook
4. **Cross-dataset**: solo via `support:` + `{support.*}` nei SQL (mai path hardcoded)
5. **Test**: `make check` + `pytest tests/` + `make verify` se tocchi mart
6. I dataset multi-M (`fasi`, `impegni`, `progetti`, `soggetti`, `pagamenti`) non farli girare in locale a ogni commit

## Formato commit

```
<tipo>(<scope>): <descrizione>

- feat: nuovo dataset o mart
- fix: correzione pipeline
- docs: aggiornamento documentazione
```

## Help

- [Lab Ops](https://github.com/dataciviclab/lab-ops)
- [Toolkit Docs](https://github.com/dataciviclab/toolkit)
