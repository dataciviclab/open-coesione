"""Data access layer — OpenCoesione dashboard.

Multi-dataset: GCS default, out/data/ locale come fallback.
Anno toolkit (path contract) = 2026; gli anni dati sono colonne nei mart.
"""

from __future__ import annotations

from pathlib import Path

import pandas as pd
import streamlit as st

from lab_connectors.duckdb.queries import (
    detect_local_root,
    load_mart_table as _load_mart_table,
    query_clean as _query_clean,
)
from lab_connectors.formatters import fmt_eur, fmt_num, fmt_pct
from lab_connectors.registry import load_registry

ROOT = Path(__file__).parent.parent
PREFIX = "open-coesione/"
TOOLKIT_YEAR = 2026
LOCAL_ROOT = detect_local_root(repo_root=ROOT)

_registry = load_registry(ROOT / "registry" / "registry.json")

SLUGS = {
    "progetti": "opencoesione_progetti",
    "esteso": "opencoesione_progetti_esteso",
    "soggetti": "opencoesione_soggetti",
    "localizzazioni": "opencoesione_localizzazioni",
    "pagamenti": "opencoesione_pagamenti",
    "indicatori": "opencoesione_indicatori",
    "fasi": "opencoesione_fasi",
    "impegni": "opencoesione_impegni",
}

STATUS_COLORS = {
    "Concluso": "#059669",
    "In corso": "#2563eb",
    "Liquidato": "#6b7280",
    "Non avviato": "#d97706",
    "Non determinabile": "#9ca3af",
}


@st.cache_data(ttl=3600, show_spinner=False)
def load_mart(slug: str, table: str, year: int = TOOLKIT_YEAR) -> pd.DataFrame:
    return _load_mart_table(slug, table, year, prefix=PREFIX, local_root=LOCAL_ROOT)


@st.cache_data(ttl=3600, show_spinner=False)
def query(slug: str, sql: str, years: tuple[int, ...] = (TOOLKIT_YEAR,)) -> pd.DataFrame:
    return _query_clean(slug, sql, list(years), prefix=PREFIX, local_root=LOCAL_ROOT)


@st.cache_data(ttl=3600, show_spinner=False)
def load_cicli() -> pd.DataFrame:
    return load_mart(SLUGS["progetti"], "mart_ciclo")


@st.cache_data(ttl=3600, show_spinner=False)
def load_stato_ciclo() -> pd.DataFrame:
    return load_mart(SLUGS["progetti"], "mart_stato_ciclo")


@st.cache_data(ttl=3600, show_spinner=False)
def load_tema_ciclo() -> pd.DataFrame:
    return load_mart(SLUGS["progetti"], "mart_tema_ciclo")


@st.cache_data(ttl=3600, show_spinner=False)
def load_macroarea_ciclo() -> pd.DataFrame:
    return load_mart(SLUGS["progetti"], "mart_macroarea_ciclo")


@st.cache_data(ttl=3600, show_spinner=False)
def load_sll() -> pd.DataFrame:
    return load_mart(SLUGS["progetti"], "mart_sll")


@st.cache_data(ttl=3600, show_spinner=False)
def load_esteso_tema() -> pd.DataFrame:
    return load_mart(SLUGS["esteso"], "mart_tema_ciclo")


@st.cache_data(ttl=3600, show_spinner=False)
def load_esteso_stato_tema() -> pd.DataFrame:
    return load_mart(SLUGS["esteso"], "mart_stato_tema")


@st.cache_data(ttl=3600, show_spinner=False)
def load_programmi() -> pd.DataFrame:
    return load_mart(SLUGS["esteso"], "mart_programmi")


@st.cache_data(ttl=3600, show_spinner=False)
def load_geolocalizzazione() -> pd.DataFrame:
    return load_mart(SLUGS["esteso"], "mart_geolocalizzazione")


@st.cache_data(ttl=3600, show_spinner=False)
def load_comune_esteso() -> pd.DataFrame:
    return load_mart(SLUGS["esteso"], "mart_comune")


@st.cache_data(ttl=3600, show_spinner=False)
def load_territorio() -> pd.DataFrame:
    return load_mart(SLUGS["localizzazioni"], "mart_territorio")


@st.cache_data(ttl=3600, show_spinner=False)
def load_comune_finanziamenti() -> pd.DataFrame:
    return load_mart(SLUGS["localizzazioni"], "mart_comune_finanziamenti")


@st.cache_data(ttl=3600, show_spinner=False)
def load_aree_interne() -> pd.DataFrame:
    return load_mart(SLUGS["localizzazioni"], "mart_aree_interne")


@st.cache_data(ttl=3600, show_spinner=False)
def load_beneficiari_fin() -> pd.DataFrame:
    return load_mart(SLUGS["soggetti"], "mart_beneficiari_finanziamenti")


@st.cache_data(ttl=3600, show_spinner=False)
def load_soggetti_ruolo() -> pd.DataFrame:
    return load_mart(SLUGS["soggetti"], "mart_soggetti_ruolo")


@st.cache_data(ttl=3600, show_spinner=False)
def load_flusso_cassa() -> pd.DataFrame:
    return load_mart(SLUGS["pagamenti"], "mart_flusso_cassa")


@st.cache_data(ttl=3600, show_spinner=False)
def load_pagamenti_avanzamento() -> pd.DataFrame:
    return load_mart(SLUGS["pagamenti"], "mart_pagamenti_avanzamento")


@st.cache_data(ttl=3600, show_spinner=False)
def load_pagamenti_programma() -> pd.DataFrame:
    return load_mart(SLUGS["pagamenti"], "mart_pagamenti_programma")


@st.cache_data(ttl=3600, show_spinner=False)
def load_ritardo_ciclo() -> pd.DataFrame:
    return load_mart(SLUGS["fasi"], "mart_ritardo_ciclo")


@st.cache_data(ttl=3600, show_spinner=False)
def load_ritardo_fase() -> pd.DataFrame:
    return load_mart(SLUGS["fasi"], "mart_ritardo_fase")


@st.cache_data(ttl=3600, show_spinner=False)
def load_impegni_anno() -> pd.DataFrame:
    return load_mart(SLUGS["impegni"], "mart_impegni_anno")


@st.cache_data(ttl=3600, show_spinner=False)
def load_impegni_ciclo() -> pd.DataFrame:
    return load_mart(SLUGS["impegni"], "mart_impegni_ciclo")


@st.cache_data(ttl=3600, show_spinner=False)
def load_valutazione() -> pd.DataFrame:
    return load_mart(SLUGS["indicatori"], "mart_valutazione")


def get_registry():
    return _registry


def short_ciclo(name: str) -> str:
    """'Ciclo di programmazione 2014-2020' -> '2014-2020'."""
    if not isinstance(name, str):
        return str(name)
    if "2000" in name:
        return "2000-2006"
    if "2007" in name:
        return "2007-2013"
    if "2014" in name:
        return "2014-2020"
    if "2021" in name:
        return "2021-2027"
    return name


def add_ciclo_short(df: pd.DataFrame, col: str = "ciclo") -> pd.DataFrame:
    out = df.copy()
    if col in out.columns:
        out["ciclo_short"] = out[col].map(short_ciclo)
    return out


__all__ = [
    "PREFIX",
    "TOOLKIT_YEAR",
    "SLUGS",
    "STATUS_COLORS",
    "load_mart",
    "query",
    "load_cicli",
    "load_stato_ciclo",
    "load_tema_ciclo",
    "load_macroarea_ciclo",
    "load_sll",
    "load_esteso_tema",
    "load_esteso_stato_tema",
    "load_programmi",
    "load_geolocalizzazione",
    "load_comune_esteso",
    "load_territorio",
    "load_comune_finanziamenti",
    "load_aree_interne",
    "load_beneficiari_fin",
    "load_soggetti_ruolo",
    "load_flusso_cassa",
    "load_pagamenti_avanzamento",
    "load_pagamenti_programma",
    "load_ritardo_ciclo",
    "load_ritardo_fase",
    "load_impegni_anno",
    "load_impegni_ciclo",
    "load_valutazione",
    "get_registry",
    "short_ciclo",
    "add_ciclo_short",
    "fmt_eur",
    "fmt_num",
    "fmt_pct",
]
