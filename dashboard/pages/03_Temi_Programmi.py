"""Temi e programmi — storico e ciclo corrente 2021-2027."""

from __future__ import annotations

import plotly.express as px
import streamlit as st

from sources import (
    STATUS_COLORS,
    add_ciclo_short,
    fmt_eur,
    load_esteso_stato_tema,
    load_esteso_tema,
    load_programmi,
    load_tema_ciclo,
)

st.title("🎯 Temi e programmi")

hist = add_ciclo_short(load_tema_ciclo())
est = add_ciclo_short(load_esteso_tema())
stato_tema = add_ciclo_short(load_esteso_stato_tema())
prog = load_programmi()

st.subheader("Top temi — storico (tutti i cicli)")
if not hist.empty:
    tema = (
        hist.groupby("tema", as_index=False)
        .agg(n_progetti=("n_progetti", "sum"), finanz_ue_tot=("finanz_ue_tot", "sum"))
        .nlargest(12, "finanz_ue_tot")
    )
    fig = px.bar(
        tema,
        x="finanz_ue_tot",
        y="tema",
        orientation="h",
        labels={"finanz_ue_tot": "Finanziato UE", "tema": "Tema"},
    )
    fig.update_layout(height=420, yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig, width="stretch")

st.subheader("Ciclo corrente 2021-2027 — universo esteso")
st.caption(
    "€110 mld (storico) e €21 mld (esteso) sono **universi diversi**: "
    "non sommare. L'esteso ha programmi, geografia fine e ruoli CF."
)
if not est.empty:
    k1, k2, k3 = st.columns(3)
    k1.metric("Progetti esteso", f"{int(est['n_progetti'].sum()):,}".replace(",", "."))
    k2.metric("UE esteso", f"€ {est['finanz_ue_tot'].sum()/1e9:.1f} mld")
    k3.metric("Costo coesione", f"€ {est['costo_coesione'].sum()/1e9:.1f} mld")

    tema_e = (
        est.groupby("tema", as_index=False)
        .agg(n_progetti=("n_progetti", "sum"), finanz_ue_tot=("finanz_ue_tot", "sum"))
        .nlargest(12, "finanz_ue_tot")
    )
    fig2 = px.bar(
        tema_e,
        x="finanz_ue_tot",
        y="tema",
        orientation="h",
        color_discrete_sequence=["#059669"],
        labels={"finanz_ue_tot": "Finanziato UE", "tema": "Tema"},
    )
    fig2.update_layout(height=400, yaxis={"categoryorder": "total ascending"}, showlegend=False)
    st.plotly_chart(fig2, width="stretch")

st.subheader("Tema × stato (2021-2027)")
if not stato_tema.empty:
    filtro_macro = st.multiselect(
        "Macroarea",
        sorted([m for m in stato_tema["macroarea"].dropna().unique() if m]),
        default=None,
    )
    df = stato_tema.copy()
    if filtro_macro:
        df = df[df["macroarea"].isin(filtro_macro)]
    piv = (
        df.groupby(["tema", "stato"], as_index=False)["finanz_ue_tot"]
        .sum()
        .sort_values("finanz_ue_tot", ascending=False)
        .head(20)
    )
    fig3 = px.bar(
        piv,
        x="finanz_ue_tot",
        y="tema",
        color="stato",
        orientation="h",
        color_discrete_map=STATUS_COLORS,
        labels={"finanz_ue_tot": "Finanziato UE", "tema": "Tema"},
    )
    fig3.update_layout(height=480, yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig3, width="stretch")

st.subheader("Programmi operativi 2021-2027")
if not prog.empty:
    fonti = sorted(prog["fonte"].dropna().unique()) if "fonte" in prog.columns else []
    if fonti:
        sel = st.multiselect("Fonte", fonti, default=fonti)
        prog_f = prog[prog["fonte"].isin(sel)] if sel else prog
    else:
        prog_f = prog
    top = prog_f.nlargest(15, "finanz_ue_tot")
    fig4 = px.bar(
        top,
        x="finanz_ue_tot",
        y="descrizione_programma",
        orientation="h",
        hover_data=["n_progetti", "n_regioni"] if "n_regioni" in top.columns else ["n_progetti"],
        labels={"finanz_ue_tot": "Finanziato UE", "descrizione_programma": "Programma"},
    )
    fig4.update_layout(height=520, yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig4, width="stretch")
    st.caption("Filtra su **fonte** (FS vs FSC): il campo `fondo` è spesso null.")
