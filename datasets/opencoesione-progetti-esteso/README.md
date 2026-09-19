# opencoesione-progetti-esteso

Progetti finanziati dalle politiche di coesione 2021-2027 — tracciato esteso (202 colonne).

## Fonte

OpenCoesione / PCM — Dipartimento Politiche di Coesione. Dati harvestati su dati.gov.it.
File CSV estratto da zip. Licenza CC BY 4.0.

## Differenze dal tracciato base

| | Tracciato base (parquet) | Tracciato esteso (CSV) |
|---|---|---|
| Colonne | 95 | 202 |
| Cicli | Tutti (2000-2027) | Solo 2021-2027 |
| Geolocalizzazione | Solo macroarea | Regione, provincia, comune |
| Programmi | Non disponibili | Codice, descrizione, asse, obiettivo |
| Indicatori | Non disponibili | Fino a 4 per progetto |
| Fasi procedurali | Non disponibili | 32 date (previste/effettive) |
| Formato | Parquet | CSV (separatorio `;`) |

## Output

- **clean** (~60 colonne): selezione delle colonne più utili da 202
- **mart_tema_ciclo**: aggregazione per ciclo × tema × macroarea
- **mart_geolocalizzazione**: aggregazione per regione × provincia
- **mart_programmi**: aggregazione per programma operativo

## Uso

```bash
toolkit run -c datasets/opencoesione-progetti-esteso/dataset.yml
```
