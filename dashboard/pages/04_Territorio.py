"""Territorio — province, comuni, aree interne."""

from __future__ import annotations

import plotly.express as px
import streamlit as st

from sources import (
    load_aree_interne,
    load_comune_esteso,
    load_comune_finanziamenti,
    load_geolocalizzazione,
    load_territorio,
)

st.title("🗺️ Territorio")
st.caption(
    "Comuni 2021-27 = tracciato esteso (€ per progetto con comune anagrafico). "
    "Comuni storici = attribuzione multi-sede (€/n_localizzazioni)."
)

tab_geo, tab_com21, tab_com_hist, tab_loc, tab_ai = st.tabs(
    ["Province 2021-27", "Comuni 2021-27", "Comuni storici", "Localizzazioni", "Aree interne"]
)

with tab_geo:
    geo = load_geolocalizzazione()
    if geo.empty:
        st.warning("Mart geolocalizzazione non disponibile.")
    else:
        if "regione" in geo.columns:
            reg = st.multiselect("Regione", sorted(geo["regione"].dropna().unique()))
            if reg:
                geo = geo[geo["regione"].isin(reg)]
        top = geo.nlargest(25, "finanz_ue_tot")
        fig = px.bar(
            top,
            x="finanz_ue_tot",
            y="provincia",
            orientation="h",
            color="regione" if "regione" in top.columns else None,
            hover_data=["n_progetti", "ratio_pagamenti_costo"],
            labels={"finanz_ue_tot": "Finanziato UE", "provincia": "Provincia"},
        )
        fig.update_layout(height=640, yaxis={"categoryorder": "total ascending"})
        st.plotly_chart(fig, width="stretch")

with tab_com21:
    com = load_comune_esteso()
    if com.empty:
        st.warning("Mart comuni esteso non disponibile.")
    else:
        if "regione" in com.columns:
            reg = st.multiselect("Regione", sorted(com["regione"].dropna().unique()), key="c21")
            if reg:
                com = com[com["regione"].isin(reg)]
        top = com.nlargest(25, "finanz_ue_tot")
        fig = px.bar(
            top,
            x="finanz_ue_tot",
            y="comune",
            orientation="h",
            color="regione" if "regione" in top.columns else None,
            hover_data=["n_progetti", "ratio_pagamenti_costo"],
            labels={"finanz_ue_tot": "Finanziato UE", "comune": "Comune"},
        )
        fig.update_layout(height=640, yaxis={"categoryorder": "total ascending"})
        st.plotly_chart(fig, width="stretch")
        st.caption("Un solo comune anagrafico per progetto (tracciato esteso).")

with tab_com_hist:
    st.markdown(
        "**€ attribuiti** = denaro del progetto diviso per n localizzazioni. "
        "Non è il bilancio del comune."
    )
    hist = load_comune_finanziamenti()
    if hist.empty:
        st.warning("Mart comune_finanziamenti non disponibile.")
    else:
        if "regione" in hist.columns:
            reg = st.multiselect("Regione", sorted(hist["regione"].dropna().unique()), key="ch")
            if reg:
                hist = hist[hist["regione"].isin(reg)]
        top = hist.nlargest(25, "finanz_ue_attribuito")
        fig = px.bar(
            top,
            x="finanz_ue_attribuito",
            y="comune",
            orientation="h",
            color="regione" if "regione" in top.columns else None,
            hover_data=["n_progetti", "n_localizzazioni", "pagamenti_attribuiti"],
            labels={"finanz_ue_attribuito": "UE attribuito", "comune": "Comune"},
        )
        fig.update_layout(height=640, yaxis={"categoryorder": "total ascending"})
        st.plotly_chart(fig, width="stretch")

with tab_loc:
    st.markdown("`n_progetti` = progetti distinti; `n_localizzazioni` = righe sedi.")
    terr = load_territorio()
    if terr.empty:
        st.warning("Mart territorio non disponibile.")
    else:
        if "regione" in terr.columns:
            reg = st.multiselect("Regione", sorted(terr["regione"].dropna().unique()), key="tl")
            if reg:
                terr = terr[terr["regione"].isin(reg)]
        top = terr.nlargest(20, "n_progetti")
        st.dataframe(
            top[
                [c for c in ["regione", "provincia", "comune", "n_progetti", "n_localizzazioni", "n_sll"] if c in top.columns]
            ],
            width="stretch",
            hide_index=True,
        )

with tab_ai:
    ai = load_aree_interne()
    if ai.empty:
        st.warning("Mart aree interne non disponibile.")
    else:
        if "classificazione" in ai.columns:
            st.subheader("Per classificazione")
            clas = (
                ai.groupby("classificazione", as_index=False)["n_progetti"]
                .sum()
                .sort_values("n_progetti", ascending=False)
            )
            fig = px.bar(clas, x="n_progetti", y="classificazione", orientation="h")
            fig.update_layout(height=320, yaxis={"categoryorder": "total ascending"})
            st.plotly_chart(fig, width="stretch")
        st.subheader("Top aree interne")
        top = ai.nlargest(20, "n_progetti")
        cols = [c for c in ["area_interna", "classificazione", "regione", "n_progetti", "n_comuni"] if c in top.columns]
        st.dataframe(top[cols], width="stretch", hide_index=True)
