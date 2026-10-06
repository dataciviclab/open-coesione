# open-coesione — 346 miliardi di politiche di coesione, aperti e interrogabili

**Dove finiscono i fondi europei in Italia? Chi li riceve? E con quali risultati?**

OpenCoesione raccoglie i dati di monitoraggio dei progetti finanziati dalle
politiche di coesione in Italia (cicli 2000-2027 a seconda del dataset):
progetti (hub storico), progetti estesi 2021-2027, soggetti, localizzazioni,
pagamenti e indicatori di realizzazione. Ogni riga è un euro pubblico tracciabile.

## Cosa contiene

| Dataset | Cosa | Righe | Anni |
|---|---|---|---|
| `opencoesione_progetti` | Base dati progetti 4 cicli (hub di join) + mart tema/ciclo/stato/SLL | 2,3M | 2000-2027 |
| `opencoesione_progetti_esteso` | Progetti 2021-2027 con programmi, geografia fine, ruoli CF | 130K | 2021-2027 |
| `opencoesione_soggetti` | Beneficiari/attuatori + mart denaro per CF (allocazione) | 7.2M | 2007-2027 |
| `opencoesione_localizzazioni` | Geolocalizzazione + mart comune con denaro attribuito | 2.4M | 2007-2027 |
| `opencoesione_pagamenti` | Storico pagamenti + avanzamento per stato/ciclo | 5.6M | 2007-2027 |
| `opencoesione_indicatori` | Valori programmati vs realizzati per tipo×unità | 3.7M | 2007-2027 |
| `opencoesione_fasi` | Fasi procedurali e ritardo previsto vs effettivo | 4.9M | 2000-2027 |
| `opencoesione_impegni` | Serie storica impegni per anno e ciclo | 2.7M | 1990-2027 |

## Esempi di domande

Con questi dati puoi scoprire:

- **Quali regioni ricevono più fondi di coesione?** E per quali temi?
- **Quali imprese hanno ricevuto più finanziamenti?** E in quali settori?
- **I progetti nella tua città sono in ritardo?** Quanto costano?
- **Come si distribuiscono i fondi tra aree interne e aree urbane?**
- **Quali programmi hanno il miglior rapporto spesa/risultato?**

## Come accedere ai dati

### 1. Via MCP (toolkit)

I dataset sono interrogabili con gli strumenti del Lab:

```
toolkit_dataset overview opencoesione_progetti_esteso
toolkit_query run "SELECT * FROM opencoesione_soggetti LIMIT 10"
```

### 2. Dashboard Streamlit

```bash
pip install -e ".[dashboard]"   # include lab-connectors[duckdb]
make dashboard                  # oppure: cd dashboard && streamlit run app.py
```

### 3. Localmente (pipeline)

```bash
git clone https://github.com/dataciviclab/open-coesione.git
cd open-coesione
pip install -e ".[pipeline]"

# Preflight su tutte le config
make check

# Iterazione locale (senza fasi/impegni multi-M)
make run-light

# Singolo dataset
make run-dataset DATASET=opencoesione-progetti-esteso

# Completo (pesante — schedule/dispatch)
make run-all
```

### 4. GCS

I parquet clean e mart sono su `gs://dataciviclab-clean/open-coesione/` e `gs://dataciviclab-mart/open-coesione/`.

## Pipeline

```
RAW (parquet OpenCoesione) → CLEAN → MART
```

| Mart | Dataset | Cosa aggrega |
|---|---|---|
| `mart_tema_ciclo` | progetti | Finanziamenti per tema × ciclo × macroarea (4 cicli) |
| `mart_stato_ciclo` | progetti | Avanzamento per ciclo × stato progetto |
| `mart_sll` | progetti | Finanziamenti per SLL (geografia storica) |
| `mart_ciclo` | progetti | KPI sintetici per ciclo (panoramica) |
| `mart_macroarea_ciclo` | progetti | Denaro per macroarea × ciclo |
| `mart_tema_ciclo` | progetti_esteso | Idem sul ciclo 2021-2027 (universo esteso) |
| `mart_geolocalizzazione` | progetti_esteso | Progetti per regione × provincia (2021-27) |
| `mart_programmi` | progetti_esteso | Progetti per programma operativo |
| `mart_comune` | progetti_esteso | Denaro per comune (2021-27, comune anagrafico) |
| `mart_stato_tema` | progetti_esteso | Avanzamento 2021-27 per tema × stato |
| `mart_beneficiari` | soggetti | Beneficiari unici per CF con conteggi |
| `mart_beneficiari_finanziamenti` | soggetti | Denaro per CF (allocazione tra co-beneficiari) |
| `mart_soggetti_ruolo` | soggetti | Struttura soggetti per ruolo × forma giuridica |
| `mart_territorio` | localizzazioni | Localizzazioni per comune (n progetti distinti) |
| `mart_aree_interne` | localizzazioni | Aree interne per COD_AREA_INTERNA |
| `mart_regione_provincia` | localizzazioni | Carico per regione/provincia |
| `mart_comune_finanziamenti` | localizzazioni | Denaro per comune storico (attribuzione multi-sede) |
| `mart_flusso_cassa` | pagamenti | Pagamenti per anno |
| `mart_pagamenti_programma` | pagamenti | Pagamenti per programma |
| `mart_pagamenti_avanzamento` | pagamenti | Cassa per ciclo × stato × anno |
| `mart_valutazione` | indicatori | Rapporto realizzato/programmato per tipo × unità |
| `mart_indicatori_tipo` | indicatori | Indicatori per tipo/unità misura |
| `mart_ritardo_fase` | fasi | Ritardo per fase procedurale × ciclo |
| `mart_ritardo_ciclo` | fasi | Sintesi ritardo per ciclo |
| `mart_impegni_anno` | impegni | Serie storica impegni per anno |
| `mart_impegni_ciclo` | impegni | Impegni per ciclo × anno |

## Fonte

[OpenCoesione](https://opencoesione.gov.it) — PCM Dipartimento Politiche di Coesione.
Parquet di riferimento: dump al 30/06/2026. Licenza CC BY 4.0.

## License

MIT
