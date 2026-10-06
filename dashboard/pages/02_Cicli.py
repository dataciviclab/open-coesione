"""Cicli di programmazione — confronto e geografia storica."""

from __future__ import annotations

import plotly.express as px
import streamlit as st

from sources import (
    add_ciclo_short,
    fmt_eur,
    fmt_num,
    fmt_pct,
    load_cicli,
    load_macroarea_ciclo,
    load_sll,
    load_stato_ciclo,
)

st.title("🗓️ Cicli di programmazione")
st.caption("Storico 2000-2027 · mart progetti · non sommare con l'universo esteso 2021-27")

cicli = add_ciclo_short(load_cicli())
macro = add_ciclo_short(load_macroarea_ciclo())
stato = add_ciclo_short(load_stato_ciclo())
sll = load_sll()

if cicli.empty:
    st.warning("Mart non disponibile.")
    st.stop()

st.subheader("KPI per ciclo")
show = cicli[
    [
        "ciclo_short",
        "n_progetti",
        "finanz_ue_tot",
        "finanz_fesr_tot",
        "finanz_fse_tot",
        "finanz_fsc_tot",
        "costo_coesione",
        "pagamenti_tot",
        "ratio_pagamenti_costo",
        "ratio_impegni_costo",
    ]
].copy()
show.columns = [
    "Ciclo",
    "Progetti",
    "UE",
    "FESR",
    "FSE",
    "FSC",
    "Costo coesione",
    "Pagamenti",
    "Ratio pag/costo",
    "Ratio impegni/costo",
]
st.dataframe(show, width="stretch", hide_index=True)

st.subheader("UE per macroarea × ciclo")
if not macro.empty:
    fig = px.bar(
        macro,
        x="ciclo_short",
        y="finanz_ue_tot",
        color="macroarea",
        barmode="group",
        labels={"finanz_ue_tot": "Finanziato UE", "ciclo_short": "Ciclo"},
    )
    fig.update_layout(height=400, legend_title_text="Macroarea")
    st.plotly_chart(fig, width="stretch")

st.subheader("Stato × ciclo (n progetti)")
if not stato.empty:
    fig2 = px.bar(
        stato,
        x="ciclo_short",
        y="n_progetti",
        color="stato",
        barmode="stack",
        labels={"n_progetti": "Progetti", "ciclo_short": "Ciclo"},
    )
    fig2.update_layout(height=380, legend_title_text="Stato")
    st.plotly_chart(fig2, width="stretch")

st.subheader("SLL per finanziamento UE (storico)")
if not sll.empty:
    ok = sll[sll.get("flag_sll", "ok") == "ok"] if "flag_sll" in sll.columns else sll
    if "flag_sll" in sll.columns:
        st.caption("Escluse le sentinelle SLL NON ATTRIBUIBILE (0) e SLL MULTIPLO (9999).")
    top = ok.nlargest(20, "finanz_ue_tot")
    fig3 = px.bar(
        top,
        x="finanz_ue_tot",
        y="sll",
        orientation="h",
        color="macroarea" if "macroarea" in top.columns else None,
        labels={"finanz_ue_tot": "Finanziato UE", "sll": "SLL"},
    )
    fig3.update_layout(height=520, yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig3, width="stretch")
