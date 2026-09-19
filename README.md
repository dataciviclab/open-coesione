# open-coesione

Dataset OpenCoesione per il DataCivicLab — politiche di coesione in Italia.

## Fonte

[OpenCoesione](https://opencoesione.gov.it) — PCM Dipartimento Politiche di Coesione.
Licenza CC BY 4.0.

## Dati

| Dataset | Righe | Descrizione |
|---------|-------|-------------|
| `opencoesione-progetti-esteso` | 128K | Progetti 2021-2027 con 77 colonne |
| `opencoesione-soggetti` | 7.2M | Soggetti coinvolti nei progetti |
| `opencoesione-localizzazioni` | 2.4M | Geolocalizzazione progetti |
| `opencoesione-pagamenti` | 5.6M | Storico pagamenti |
| `opencoesione-indicatori` | 3.7M | Indicatori di realizzazione |

## Uso

```bash
# Setup
pip install -r requirements.txt

# Esegui tutti i dataset
make run

# Verifica config
make check
```

## Pipeline

```
RAW (parquet) -> CLEAN (selezione/tipizzazione) -> MART (aggregazioni)
```

## License

MIT
