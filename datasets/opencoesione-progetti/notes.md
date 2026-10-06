# opencoesione-progetti — note

## Stato

- **Onboardato** in questo repo con `dataset.yml` (PR feat: ripristina opencoesione-progetti).
- Prima era orfano: README/notes/SQL presenti dal commit iniziale, **mai** `dataset.yml` → fuori Makefile, CI e registry.
- Candidato storico in `dataset-incubator` rimosso da PR DI #853 («moved to open-coesione») ma senza config qui.
- Path GCS legacy (senza prefisso `open-coesione/`): ancora consumato da data-explorer e downstream — follow-up separato.

## Fonte

- **Ente**: PCM — Dipartimento Politiche di Coesione / OpenCoesione
- **File attuale**: `progetti_20260630.parquet` (2.331.215 righe, 97 colonne)
- **URL**: `https://opencoesione.gov.it/media/open_data/progetti_20260630.parquet`
- **Dump precedente** (obsoleto, 404): `progetti_20260430.parquet` (2.320.817 righe, 95 colonne)
- **Issue intake**: dataset-incubator #440

## Break di schema 20260430 → 20260630

| Cambio | Impatto |
|---|---|
| `OC_MACROAREA` → `OC_MACROAREA_PROGETTO` | clean/mart aggiornati |
| + `OC_MACROAREA_PROGRAMMA` | aggiunto al clean |
| + `FINANZ_UE_ALTRO`, `OC_FINANZ_UE_ALTRO_NETTO` | aggiunti al clean |
| + `FINANZ_STATO_PAC` | aggiunto al clean |
| + `OC_FLAG_AGGREGATO`, `OC_PROGETTO_AGGREGATO` | aggiunti al clean |

## Confronto con esteso (dump 20260630)

- esteso 2021-2027 = **sottoinsieme** di flat 2021-2027 (130.462 / 174.142 COD)
- UE flat 2021-27 ≈ €20,78 mld; esteso ≈ €20,70 mld; i 43k extra valgono ~€81 mln
- Esteso ha programmi, geografia fine, ruoli CF, indicatori sparsi (~2%), 32 date di fasi
- Flat ha 4 cicli ed è hub di join per pagamenti/fasi/impegni/localizzazioni

## Filtro clean

Prima: `WHERE OC_MACROAREA IS NOT NULL AND OC_TEMA_SINTETICO IS NOT NULL` → buttava ~6-13k progetti (fino a ~€2 mld UE) e non era più allineato al nome colonna.

Oggi: solo `COD_LOCALE_PROGETTO` non null. Macroarea/tema null restano nel clean; il mart li etichetta `Non classificata` / `Non classificato`.

## Prossimi passi

- [x] `dataset.yml` + clean/mart allineati a 20260630
- [x] `mart_tema_ciclo` rinominato da `mart.sql` (convenzione repo)
- [ ] Dopo merge: verificare registry post-merge e path GCS `open-coesione/opencoesione_progetti/`
- [ ] Follow-up: migrare data-explorer e downstream dal path DI legacy
- [ ] Follow-up: dataset `fasi` / `impegni` (ritardo e serie impegni)
- [ ] Follow-up: fix `mart_flusso_cassa` già in questa PR (CAST anno)
