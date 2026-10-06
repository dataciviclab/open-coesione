"""Smoke test — dashboard compila."""

from __future__ import annotations

import py_compile
from pathlib import Path

import pytest

pytestmark = pytest.mark.smoke

DASH = Path(__file__).resolve().parent.parent
PAGES = DASH / "pages"


def test_app_compiles() -> None:
    py_compile.compile(str(DASH / "app.py"), doraise=True)


def test_sources_compiles() -> None:
    py_compile.compile(str(DASH / "sources.py"), doraise=True)


@pytest.mark.parametrize("page", sorted(PAGES.glob("*.py")), ids=lambda p: p.stem)
def test_page_compiles(page: Path) -> None:
    py_compile.compile(str(page), doraise=True)


def test_pages_exist() -> None:
    expected = {
        "01_Panoramica.py",
        "02_Cicli.py",
        "03_Temi_Programmi.py",
        "04_Territorio.py",
        "05_Beneficiari.py",
        "06_Cassa_Impegni.py",
        "07_Ritardo.py",
        "08_Indicatori.py",
        "09_SQL.py",
    }
    found = {p.name for p in PAGES.glob("*.py")}
    assert expected <= found, f"mancano pagine: {expected - found}"
