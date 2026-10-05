# opencoesione-impegni

Serie storica degli **impegni** dei progetti coesione.

## Cosa contiene

Una riga per impegno (data, importo, tipo) collegato al progetto.

- **Fonte**: `impegni_20260630.parquet` (~2,7M righe)
- **Join**: `COD_LOCALE_PROGETTO` → `opencoesione-progetti` (support)
- **Anno**: `CAST(OC_DATA_IMPEGNI/10000 AS INTEGER)`

## Mart

| Mart | Cosa |
|---|---|
| `mart_impegni_anno` | serie storica impegni per anno (con storni) |
| `mart_impegni_ciclo` | impegni per ciclo × anno + join progetti |

## Note

- Lo snapshot `IMPEGNI` sul layer progetti non combacia 1:1 con la somma dello storico (copertura parziale / registrazioni diverse)
- Per il ciclo 2021-2027 gli impegni nel parquet di fonte sono ancora pochi

## Uso

```bash
toolkit run --config datasets/opencoesione-impegni/dataset.yml
```
