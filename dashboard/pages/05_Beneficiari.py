"""Beneficiari — denaro attribuito e struttura soggetti."""

from __future__ import annotations

import plotly.express as px
import streamlit as st

from sources import fmt_eur, fmt_num, load_beneficiari_fin, load_soggetti_ruolo

st.title("👥 Beneficiari")
st.caption(
    "**€ attribuiti** = finanziamento del progetto ÷ n beneficiari distinti validi. "
    "Non è il bilancio del CF. Placeholder e denominazioni nulle esclusi."
)

ben = load_beneficiari_fin()
ruolo = load_soggetti_ruolo()

if ben.empty:
    st.warning("Mart beneficiari_finanziamenti non disponibile.")
    st.stop()

c1, c2, c3 = st.columns(3)
c1.metric("CF con denaro attribuito", fmt_num(len(ben)))
c2.metric(
    "UE attribuito (totale)",
    fmt_eur(float(ben["finanz_ue_attribuito"].sum()), compact=True),
)
c3.metric(
    "Pagamenti attribuiti",
    fmt_eur(float(ben["pagamenti_attribuiti"].sum()), compact=True)
    if "pagamenti_attribuiti" in ben.columns
    else "—",
)

min_proj = st.slider("Minimo progetti come beneficiario", 1, 100, 5, key="ben_min")
formes = st.multiselect(
    "Forma giuridica",
    sorted(ben["forma_giuridica"].dropna().unique())[:30],
    default=None,
)

df = ben[ben["n_progetti_beneficiario"] >= min_proj].copy()
if formes:
    df = df[df["forma_giuridica"].isin(formes)]

# filtra rumore anagrafico residuo
df = df[
    df["denominazione"].notna()
    & ~df["denominazione"].astype(str).str.startswith("*")
    & ~df["denominazione"].astype(str).str.startswith("Soggetto")
]

st.subheader("Top per UE attribuito")
top = df.nlargest(50, "finanz_ue_attribuito")
cols = [
    c
    for c in [
        "denominazione",
        "forma_giuridica",
        "n_progetti_beneficiario",
        "n_cicli",
        "finanz_ue_attribuito",
        "pagamenti_attribuiti",
        "attivita_ateco",
        "cod_comune_sede",
    ]
    if c in top.columns
]
st.dataframe(top[cols], width="stretch", hide_index=True)

st.subheader("Distribuzione forma giuridica (top CF)")
if "forma_giuridica" in df.columns:
    top_cf = df.nlargest(500, "finanz_ue_attribuito")
    dist = (
        top_cf.groupby("forma_giuridica", as_index=False)
        .agg(n=("codice_fiscale", "count"), ue=("finanz_ue_attribuito", "sum"))
        .nlargest(12, "ue")
    )
    fig = px.bar(dist, x="ue", y="forma_giuridica", orientation="h")
    fig.update_layout(height=400, yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig, width="stretch")

if not ruolo.empty:
    st.subheader("Struttura ruoli (contatti soggetto×progetto)")
    r = ruolo.nlargest(15, "n_relazioni")
    fig2 = px.bar(
        r,
        x="n_relazioni",
        y="ruolo",
        orientation="h",
        color="forma_giuridica" if "forma_giuridica" in r.columns else None,
    )
    fig2.update_layout(height=420, yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig2, width="stretch")
