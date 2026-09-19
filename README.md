# open-coesione — 346 miliardi di politiche di coesione, aperti e interrogabili

**Dove finiscono i fondi europei in Italia? Chi li riceve? E con quali risultati?**

OpenCoesione raccoglie i dati di monitoraggio di tutti i progetti finanziati dalle
politiche di coesione in Italia dal 2007 al 2027: progetti, soggetti, localizzazioni,
pagamenti e indicatori di realizzazione. Ogni riga è un euro pubblico tracciabile.

## Cosa contiene

| Dataset | Cosa | Righe | Anni |
|---|---|---|---|
| `opencoesione_progetti_esteso` | Progetti con 77 colonne: finanziamenti, programmi, indicatori | 128K | 2021-2027 |
| `opencoesione_soggetti` | Beneficiari, programmatori, attuatori con CF e forma giuridica | 7.2M | 2007-2027 |
| `opencoesione_localizzazioni` | Geolocalizzazione: regione, provincia, comune, SLL, aree interne | 2.4M | 2007-2027 |
| `opencoesione_pagamenti` | Storico pagamenti per data e programma | 5.6M | 2007-2027 |
| `opencoesione_indicatori` | Valori programmati vs realizzati per progetto | 3.7M | 2007-2027 |

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

### 2. Localmente

```bash
git clone https://github.com/dataciviclab/open-coesione.git
cd open-coesione
pip install -r requirements.txt
make run
```

### 3. GCS

I parquet clean e mart sono su `gs://dataciviclab-clean/opencoesione*/`.

## Pipeline

```
RAW (parquet OpenCoesione) → CLEAN (77/21/15/9/9 colonne) → MART (10 tabelle)
```

| Mart | Cosa aggrega |
|---|---|
| `mart_tema_ciclo` | Finanziamenti per tema × ciclo × macroarea |
| `mart_geolocalizzazione` | Progetti per regione × provincia |
| `mart_programmi` | Progetti per programma operativo |
| `mart_beneficiari` | Beneficiari unici per CF con ruoli |
| `mart_territorio` | Progetti per comune |
| `mart_aree_interne` | Progetti in aree interne |
| `mart_flusso_cassa` | Pagamenti per anno |
| `mart_pagamenti_programma` | Pagamenti per programma |
| `mart_valutazione` | Rapporto programmato/realizzato |
| `mart_indicatori_tipo` | Indicatori per tipo/unità misura |

## Fonte

[OpenCoesione](https://opencoesione.gov.it) — PCM Dipartimento Politiche di Coesione.
Parquet aggiornati al 30/04/2026. Licenza CC BY 4.0.

## License

MIT
