"""Cassa e impegni — serie storiche e avanzamento."""

from __future__ import annotations

import plotly.express as px
import plotly.graph_objects as go
import streamlit as st

from sources import (
    STATUS_COLORS,
    add_ciclo_short,
    load_flusso_cassa,
    load_impegni_anno,
    load_impegni_ciclo,
    load_pagamenti_avanzamento,
    load_pagamenti_programma,
)

st.title("💶 Cassa e impegni")

cassa = load_flusso_cassa()
imp = load_impegni_anno()
imp_ciclo = add_ciclo_short(load_impegni_ciclo())
avanz = add_ciclo_short(load_pagamenti_avanzamento())
prog = load_pagamenti_programma()

st.subheader("Pagamenti per anno")
if cassa.empty:
    st.warning("Mart flusso cassa non disponibile.")
else:
    df = cassa[cassa["anno"] >= 2007].copy()
    anno_max = int(df["anno"].max())
    df["parziale"] = df["anno"] >= 2024
    fig = px.bar(
        df,
        x="anno",
        y="totale_pagamenti",
        color="parziale",
        color_discrete_map={False: "#2563eb", True: "#d97706"},
        hover_data=["n_progetti", "totale_fsc", "totale_rendicontabile_ue"],
        labels={"totale_pagamenti": "Pagamenti", "anno": "Anno"},
    )
    fig.update_layout(height=400)
    st.plotly_chart(fig, width="stretch")
    st.caption(f"Dump 30/06/2026 — anni ≥2024 parziali (max anno dati: {anno_max}).")

st.subheader("Impegni vs pagamenti per anno")
if not imp.empty and not cassa.empty:
    i = imp[imp["anno"] >= 2007][["anno", "totale_impegni"]]
    p = cassa[cassa["anno"] >= 2007][["anno", "totale_pagamenti"]]
    m = i.merge(p, on="anno", how="outer").sort_values("anno")
    fig2 = go.Figure()
    fig2.add_trace(go.Bar(x=m["anno"], y=m["totale_impegni"], name="Impegni"))
    fig2.add_trace(go.Bar(x=m["anno"], y=m["totale_pagamenti"], name="Pagamenti"))
    fig2.update_layout(barmode="group", height=400, legend_title_text="")
    st.plotly_chart(fig2, width="stretch")
    st.caption("Le due serie non coincidono 1:1 con gli snapshot sul progetto.")

st.subheader("Impegni per ciclo × anno")
if not imp_ciclo.empty:
    cicli_i = sorted(imp_ciclo["ciclo_short"].dropna().unique())
    sel_i = st.multiselect(
        "Ciclo (impegni)",
        cicli_i,
        default=[c for c in cicli_i if "2014" in c or "2007" in c] or cicli_i[:2],
        key="imp_ciclo",
    )
    df_i = imp_ciclo[imp_ciclo["ciclo_short"].isin(sel_i)] if sel_i else imp_ciclo
    fig_i = px.bar(
        df_i,
        x="anno",
        y="totale_impegni",
        color="ciclo_short",
        barmode="group",
        labels={"totale_impegni": "Impegni", "anno": "Anno"},
    )
    fig_i.update_layout(height=400)
    st.plotly_chart(fig_i, width="stretch")

st.subheader("Pagamenti per stato di avanzamento")
if not avanz.empty:
    cicli_u = sorted(avanz["ciclo_short"].dropna().unique())
    sel = st.multiselect("Ciclo", cicli_u, default=[c for c in cicli_u if "2021" in c or "2014" in c] or cicli_u[:2])
    df = avanz[avanz["ciclo_short"].isin(sel)] if sel else avanz
    agg = (
        df.groupby(["anno", "stato"], as_index=False)["totale_pagamenti"]
        .sum()
        .sort_values("anno")
    )
    fig3 = px.bar(
        agg,
        x="anno",
        y="totale_pagamenti",
        color="stato",
        color_discrete_map=STATUS_COLORS,
        labels={"totale_pagamenti": "Pagamenti", "anno": "Anno"},
    )
    fig3.update_layout(height=420)
    st.plotly_chart(fig3, width="stretch")

st.subheader("Pagamenti per programma (top)")
if not prog.empty:
    top = prog.nlargest(20, "totale_pagamenti")
    fig4 = px.bar(
        top,
        x="totale_pagamenti",
        y="codice_programma",
        orientation="h",
        hover_data=["n_pagamenti", "n_progetti"],
        labels={"totale_pagamenti": "Pagamenti", "codice_programma": "Programma"},
    )
    fig4.update_layout(height=560, yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig4, width="stretch")
