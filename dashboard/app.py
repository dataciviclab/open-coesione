#!/usr/bin/env python3
"""OpenCoesione · Dashboard Streamlit

Dove finiscono i fondi europei in Italia? Chi li riceve? E con quali risultati?
"""

import streamlit as st
from lab_connectors.branding import apply_branding

st.set_page_config(
    page_title="OpenCoesione · Dashboard",
    page_icon="🇪🇺",
    layout="wide",
    initial_sidebar_state="expanded",
)

apply_branding(
    repo_name="open-coesione",
    repo_url="https://github.com/dataciviclab/open-coesione",
)

pages = {
    "": [
        st.Page("pages/01_Panoramica.py", title="Panoramica", icon="📊", default=True),
    ],
    "Analisi": [
        st.Page("pages/02_Cicli.py", title="Cicli", icon="🗓️"),
        st.Page("pages/03_Temi_Programmi.py", title="Temi e programmi", icon="🎯"),
        st.Page("pages/04_Territorio.py", title="Territorio", icon="🗺️"),
        st.Page("pages/05_Beneficiari.py", title="Beneficiari", icon="👥"),
        st.Page("pages/06_Cassa_Impegni.py", title="Cassa e impegni", icon="💶"),
        st.Page("pages/07_Ritardo.py", title="Ritardo", icon="⏱️"),
        st.Page("pages/08_Indicatori.py", title="Indicatori", icon="📈"),
    ],
    "Strumenti": [
        st.Page("pages/09_SQL.py", title="Query SQL", icon="🧪"),
    ],
}

pg = st.navigation(pages, position="sidebar")

st.sidebar.markdown("---")
st.sidebar.caption(
    "Fonte: OpenCoesione / PCM Dip. Politiche di Coesione — dump al 30/06/2026"
)
st.sidebar.caption(
    "Codice: [dataciviclab/open-coesione](https://github.com/dataciviclab/open-coesione)"
)
st.sidebar.caption("[DataCivicLab](https://dataciviclab.org/) · dati CC BY 4.0")

pg.run()
