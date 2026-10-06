"""Query SQL sul clean layer (via registry Lab)."""

from __future__ import annotations

from pathlib import Path

from lab_connectors.duckdb.sql_page import render_sql_query

from sources import PREFIX, TOOLKIT_YEAR, get_registry

ROOT = Path(__file__).resolve().parent.parent.parent
registry = get_registry() if get_registry() is not None else None
if registry is None:
    from lab_connectors.registry import load_registry

    registry = load_registry(ROOT / "registry" / "registry.json")

render_sql_query(
    registry=registry,
    prefix=PREFIX,
    years=[TOOLKIT_YEAR],
    default_slug="opencoesione_progetti",
    title="🧪 Query SQL",
    description=(
        "Interroga i **clean layer** di OpenCoesione. "
        "Usa ``clean_input`` come tabella virtuale. "
        "I mart aggregati sono nelle pagine di analisi."
    ),
)
