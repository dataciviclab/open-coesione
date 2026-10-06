"""Indicatori — programmato vs realizzato per tipo e unità."""

from __future__ import annotations

import plotly.express as px
import streamlit as st

from sources import load_valutazione

st.title("📈 Indicatori")
st.caption(
    "Rapporto = realizzato / programmato **dentro la stessa unità di misura**. "
    "Non sommare totali tra unità diverse (persone + € + mq non hanno senso insieme)."
)

val = load_valutazione()
if val.empty:
    st.warning("Mart valutazione non disponibile.")
    st.stop()

tipi = sorted(val["tipo"].dropna().unique()) if "tipo" in val.columns else []
if tipi:
    sel_tipo = st.multiselect("Tipo indicatore", tipi, default=tipi)
    df = val[val["tipo"].isin(sel_tipo)] if sel_tipo else val
else:
    df = val

min_n = st.slider("Minimo indicatori", 100, 500_000, 1000, step=100, key="ind_min")
df = df[df["n_indicatori"] >= min_n]

show = df[
    [
        c
        for c in [
            "tipo",
            "unita_misura",
            "n_indicatori",
            "n_progetti",
            "rapporto_medio",
            "n_con_rapporto",
        ]
        if c in df.columns
    ]
].sort_values("n_indicatori", ascending=False)
st.dataframe(show, width="stretch", hide_index=True)

st.subheader("Rapporto medio per unità (top per volume)")
top = df.nlargest(20, "n_indicatori")
if "rapporto_medio" in top.columns:
    fig = px.bar(
        top,
        x="rapporto_medio",
        y="unita_misura",
        orientation="h",
        color="tipo" if "tipo" in top.columns else None,
        hover_data=["n_indicatori"],
        labels={"rapporto_medio": "Realizzato / Programmato", "unita_misura": "Unità"},
    )
    fig.add_vline(x=1.0, line_dash="dash", line_color="#6b7280")
    fig.update_layout(height=520, yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig, width="stretch")
    st.caption("Linea tratteggiata = 1,0 (obiettivo raggiunto in media).")
