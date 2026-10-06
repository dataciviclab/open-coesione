"""Smoke test — config dataset e SQL presenti e coerenti."""

from __future__ import annotations

from pathlib import Path

import pytest
import yaml

pytestmark = pytest.mark.smoke

ROOT = Path(__file__).resolve().parent.parent
DATASETS = ROOT / "datasets"

REQUIRED_TOP = ["root", "schema_version", "dataset", "raw", "clean", "mart"]


def _dataset_ymls() -> list[Path]:
    return sorted(DATASETS.glob("*/dataset.yml"))


def test_dataset_ymls_exist() -> None:
    assert len(_dataset_ymls()) >= 6, "almeno i dataset del Lab attesi"


@pytest.mark.parametrize("yml", _dataset_ymls(), ids=lambda p: p.parent.name)
def test_dataset_yml_structure(yml: Path) -> None:
    cfg = yaml.safe_load(yml.read_text())
    assert isinstance(cfg, dict)
    for key in REQUIRED_TOP:
        assert key in cfg, f"{yml}: manca '{key}'"
    assert cfg["dataset"]["name"], f"{yml}: dataset.name vuoto"
    assert cfg["dataset"]["source_id"] == "opencoesione"
    assert cfg["raw"]["sources"] is not None
    assert cfg["clean"]["sql"]
    tables = cfg["mart"]["tables"]
    assert tables, f"{yml}: nessuna tabella mart"
    for t in tables:
        assert t["name"] and t["sql"]
        sql_path = yml.parent / t["sql"]
        assert sql_path.is_file(), f"{yml}: SQL mancante {t['sql']}"


@pytest.mark.parametrize("yml", _dataset_ymls(), ids=lambda p: p.parent.name)
def test_sql_uses_canonical_views(yml: Path) -> None:
    cfg = yaml.safe_load(yml.read_text())
    for layer in ("clean", "mart"):
        if layer == "clean":
            paths = [yml.parent / cfg["clean"]["sql"]]
        else:
            paths = [yml.parent / t["sql"] for t in cfg["mart"]["tables"]]
        for sql_path in paths:
            text = sql_path.read_text()
            if layer == "clean":
                assert "FROM raw_input" in text or "read_parquet" in text, (
                    f"{sql_path}: clean deve leggere raw_input o support"
                )
            else:
                assert "clean_input" in text or "read_parquet" in text, (
                    f"{sql_path}: mart deve leggere clean_input o support"
                )


def test_support_configs_resolve() -> None:
    for yml in _dataset_ymls():
        cfg = yaml.safe_load(yml.read_text())
        for item in cfg.get("support") or []:
            rel = item.get("config")
            assert rel, f"{yml}: support senza config"
            target = (yml.parent / rel).resolve()
            assert target.is_file(), f"{yml}: support config mancante {rel}"


def test_no_legacy_oc_macroarea_in_sql() -> None:
    """Il dump 20260630 usa OC_MACROAREA_PROGETTO, non la colonna legacy OC_MACROAREA."""
    import re

    pattern = re.compile(r"\bOC_MACROAREA\b(?!_)")
    for sql in DATASETS.rglob("*.sql"):
        lines = [line.split("--", 1)[0] for line in sql.read_text().splitlines()]
        code = "\n".join(lines).replace("OC_MACROAREA_PROGETTO", "")
        assert not pattern.search(code), f"{sql}: usa ancora OC_MACROAREA legacy"
