"""Panoramica — KPI storici e avanzamento."""

from __future__ import annotations

import plotly.express as px
import streamlit as st

from sources import (
    STATUS_COLORS,
    add_ciclo_short,
    fmt_eur,
    fmt_num,
    fmt_pct,
    load_cicli,
    load_flusso_cassa,
    load_stato_ciclo,
)

st.title("📊 Panoramica")
st.caption(
    "Universo: progetti OpenCoesione 2000-2027 (base dati completa). "
    "Dump al 30/06/2026 — 2024-2026 parziali."
)

cicli = add_ciclo_short(load_cicli())
stato = add_ciclo_short(load_stato_ciclo())
cassa = load_flusso_cassa()

if cicli.empty:
    st.warning("Mart cicli non disponibile — esegui la pipeline o avvia da out/ locale.")
    st.stop()

ue_tot = float(cicli["finanz_ue_tot"].sum())
n_proj = int(cicli["n_progetti"].sum())
costo = float(cicli["costo_coesione"].sum())
pag = float(cicli["pagamenti_tot"].sum())
ratio = pag / costo if costo else None

c1, c2, c3, c4 = st.columns(4)
c1.metric("Finanziato UE (storico)", fmt_eur(ue_tot, compact=True))
c2.metric("Progetti", fmt_num(n_proj))
c3.metric("Costo coesione", fmt_eur(costo, compact=True))
c4.metric("Ratio pagamenti/costo", fmt_pct(ratio) if ratio is not None else "—")

st.info(
    "Questi KPI sono sul **ciclo completo**. Per il solo 2021-2027 usa la pagina "
    "Temi e programmi (universo esteso, ~€21 mld UE)."
)

st.subheader("UE per ciclo di programmazione")
fig = px.bar(
    cicli,
    x="ciclo_short",
    y="finanz_ue_tot",
    text_auto=".2s",
    color_discrete_sequence=["#2563eb"],
    labels={"finanz_ue_tot": "Finanziato UE", "ciclo_short": "Ciclo"},
)
fig.update_layout(height=380, showlegend=False, yaxis_tickformat="~s")
st.plotly_chart(fig, width="stretch")

st.subheader("Avanzamento per ciclo (UE)")
if not stato.empty:
    stacked = (
        stato.groupby(["ciclo_short", "stato"], as_index=False)["finanz_ue_tot"]
        .sum()
        .sort_values(["ciclo_short", "finanz_ue_tot"], ascending=[True, False])
    )
    fig2 = px.bar(
        stacked,
        x="ciclo_short",
        y="finanz_ue_tot",
        color="stato",
        color_discrete_map=STATUS_COLORS,
        labels={"finanz_ue_tot": "Finanziato UE", "ciclo_short": "Ciclo"},
    )
    fig2.update_layout(height=420, legend_title_text="Stato")
    st.plotly_chart(fig2, width="stretch")

    with st.expander("Tabella stato × ciclo"):
        st.dataframe(
            stato[
                [
                    "ciclo_short",
                    "stato",
                    "n_progetti",
                    "finanz_ue_tot",
                    "costo_coesione",
                    "pagamenti_tot",
                    "ratio_pagamenti_costo",
                ]
            ],
            width="stretch",
            hide_index=True,
        )

st.subheader("Cassa per anno (pagamenti registrati)")
if not cassa.empty:
    cassa_plot = cassa[cassa["anno"] >= 2007].copy()
    cassa_plot["parziale"] = cassa_plot["anno"] >= 2024
    fig3 = px.bar(
        cassa_plot,
        x="anno",
        y="totale_pagamenti",
        color="parziale",
        color_discrete_map={False: "#2563eb", True: "#d97706"},
        labels={"totale_pagamenti": "Pagamenti", "anno": "Anno", "parziale": "Anno parziale"},
    )
    fig3.update_layout(height=360, showlegend=True)
    st.plotly_chart(fig3, width="stretch")
    st.caption("Arancione = 2024-2026 con dati parziali al dump 30/06/2026.")
