# Contributing a open-coesione

Guida alla contribuzione per il dataset OpenCoesione.

## Setup locale

```bash
# Clona il repo
git clone https://github.com/dataciviclab/open-coesione.git
cd open-coesione

# Installa toolkit (se non presente)
pip install dataciviclab-toolkit

# Esegui tutti i dataset
make run
```

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
```

## Pipeline

Ogni dataset segue il flusso: `RAW -> CLEAN -> MART`

```bash
# Verifica config
make check

# Esegui tutto
make run

# Esegui un singolo dataset
toolkit run -c datasets/<slug>/dataset.yml
```

## Regole

1. **RAW**: dati originali, nessuna trasformazione
2. **CLEAN**: pulizia, normalizzazione, tipizzazione
3. **MART**: aggregazioni analitiche per dashboard/notebook
4. **Test**: ogni modifica deve passare `make check`

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
