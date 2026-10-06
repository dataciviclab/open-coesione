#!/usr/bin/env python3
"""Smoke verify output pipeline — mart attesi presenti e non vuoti."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

try:
    import duckdb
except ImportError:
    print("duckdb required: pip install -e '.[dev]'", file=sys.stderr)
    sys.exit(2)

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "out" / "data" / "mart"

# slug -> mart minimi attesi dopo un run completo
EXPECTED: dict[str, list[str]] = {
    "opencoesione_progetti": [
        "mart_tema_ciclo",
        "mart_stato_ciclo",
        "mart_sll",
        "mart_ciclo",
        "mart_macroarea_ciclo",
    ],
    "opencoesione_progetti_esteso": [
        "mart_tema_ciclo",
        "mart_geolocalizzazione",
        "mart_programmi",
        "mart_comune",
        "mart_stato_tema",
    ],
    "opencoesione_soggetti": [
        "mart_beneficiari",
        "mart_soggetti_ruolo",
        "mart_beneficiari_finanziamenti",
    ],
    "opencoesione_localizzazioni": [
        "mart_territorio",
        "mart_aree_interne",
        "mart_regione_provincia",
        "mart_comune_finanziamenti",
    ],
    "opencoesione_pagamenti": [
        "mart_flusso_cassa",
        "mart_pagamenti_programma",
        "mart_pagamenti_avanzamento",
    ],
    "opencoesione_indicatori": [
        "mart_valutazione",
        "mart_indicatori_tipo",
    ],
    "opencoesione_fasi": [
        "mart_ritardo_fase",
        "mart_ritardo_ciclo",
    ],
    "opencoesione_impegni": [
        "mart_impegni_anno",
        "mart_impegni_ciclo",
    ],
}

# Se batch parziale (PR selettivo), verifica solo gli slug presenti in out/
def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--year", default="2026")
    args = parser.parse_args()
    year = args.year
    con = duckdb.connect()
    errors: list[str] = []
    checked = 0

    for slug, tables in EXPECTED.items():
        base = OUT / slug / year
        if not base.exists():
            # skip se il dataset non è stato runnato in questo job
            continue
        for table in tables:
            path = base / f"{table}.parquet"
            checked += 1
            if not path.exists():
                errors.append(f"MISSING {slug}/{year}/{table}.parquet")
                continue
            try:
                n = con.execute(
                    f"SELECT count(*) FROM read_parquet('{path}')"
                ).fetchone()[0]
            except Exception as exc:  # noqa: BLE001
                errors.append(f"UNREADABLE {path}: {exc}")
                continue
            if n <= 0:
                errors.append(f"EMPTY {slug}/{year}/{table} (0 rows)")

    print(f"verify: {checked} mart check, {len(errors)} errori")
    for err in errors:
        print(f"  ✗ {err}")
    if checked == 0:
        print("  ⚠ nessun mart in out/ — skip (batch parziale o run mancante)")
        return 0
    if errors:
        return 1
    print("✅ verify ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
