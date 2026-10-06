"""Ritardo — fasi procedurali previsto vs effettivo."""

from __future__ import annotations

import plotly.express as px
import streamlit as st

from sources import add_ciclo_short, fmt_eur, fmt_num, load_ritardo_ciclo, load_ritardo_fase

st.title("⏱️ Ritardo")
st.caption(
    "Ritardo = giorni tra data **prevista** ed **effettiva** di fine fase. "
    "Solo progetti con entrambe le date. Il ciclo 2021-27 ha ancora poche fasi con date (SNM parziale)."
)

rit = add_ciclo_short(load_ritardo_ciclo())
fasi = add_ciclo_short(load_ritardo_fase())

if rit.empty:
    st.warning("Mart fasi non disponibile — esegui `make run-dataset DATASET=opencoesione-fasi`.")
    st.stop()

st.subheader("Sintesi per ciclo")
show = rit[
    [
        c
        for c in [
            "ciclo_short",
            "n_progetti",
            "ritardo_medio_giorni",
            "ritardo_mediano_giorni",
            "ritardo_p90_giorni",
            "n_progetti_in_ritardo",
            "n_progetti_in_orario",
            "finanz_ue_in_ritardo",
        ]
        if c in rit.columns
    ]
].copy()
if "finanz_ue_in_ritardo" in show.columns:
    show["finanz_ue_in_ritardo"] = show["finanz_ue_in_ritardo"].map(
        lambda x: fmt_eur(x, compact=True)
    )
st.dataframe(show, width="stretch", hide_index=True)

if "ritardo_medio_giorni" in rit.columns:
    fig = px.bar(
        rit,
        x="ciclo_short",
        y="ritardo_medio_giorni",
        color_discrete_sequence=["#d97706"],
        labels={"ritardo_medio_giorni": "Ritardo medio (giorni)", "ciclo_short": "Ciclo"},
    )
    fig.update_layout(height=320, showlegend=False)
    st.plotly_chart(fig, width="stretch")

st.subheader("Dettaglio per fase")
if not fasi.empty:
    cicli_u = sorted(fasi["ciclo_short"].dropna().unique())
    sel = st.multiselect(
        "Ciclo",
        cicli_u,
        default=[c for c in cicli_u if "2014" in c or "2007" in c] or cicli_u[:2],
        key="rit_ciclo",
    )
    df = fasi[fasi["ciclo_short"].isin(sel)] if sel else fasi
    top = df.nlargest(20, "n_in_ritardo" if "n_in_ritardo" in df.columns else "n_progetti")
    fig2 = px.bar(
        top,
        x="n_in_ritardo" if "n_in_ritardo" in top.columns else "n_progetti",
        y="fase",
        orientation="h",
        color="ciclo_short" if sel and len(sel) > 1 else None,
        hover_data=[c for c in ["ritardo_medio_giorni", "n_progetti"] if c in top.columns],
        labels={"fase": "Fase", "n_in_ritardo": "Progetti in ritardo"},
    )
    fig2.update_layout(height=520, yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig2, width="stretch")
