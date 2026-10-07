"""Query SQL sul clean layer (via registry Lab)."""

from __future__ import annotations

from lab_connectors.duckdb.sql_page import render_sql_query

from sources import PREFIX, TOOLKIT_YEAR, get_registry

render_sql_query(
    registry=get_registry(),
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
