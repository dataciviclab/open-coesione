# opencoesione-fasi

Fasi procedurali dei progetti coesione — **ritardo e avanzamento**.

## Cosa contiene

Una riga per progetto × fase (attribuzione, progettazione, esecuzione, collaudo, …) con date previste ed effettive.

- **Fonte**: `fasi_20260630.parquet` (~4,9M righe)
- **Join**: `COD_LOCALE_PROGETTO` → `opencoesione-progetti` (support)
- **Ritardo**: `DATE_DIFF` tra fine prevista ed effettiva (giorni)

## Mart

| Mart | Cosa |
|---|---|
| `mart_ritardo_fase` | ritardo medio/mediano/p90 per fase × ciclo |
| `mart_ritardo_ciclo` | sintesi per ciclo: progetti in ritardo, UE collegata |

## Limiti

- Non tutti i progetti hanno date complete (solo quelli con entrambe le date entrano nel ritardo)
- Il ciclo 2021-2027 ha poche fasi con date (SNM ancora parziale)
- Il ritardo è *procedurale* (date di fase), non "ritardo sul budget"

## Uso

```bash
toolkit run --config datasets/opencoesione-fasi/dataset.yml
```
