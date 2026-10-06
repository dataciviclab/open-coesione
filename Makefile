# CLI toolkit del Lab.
# Attenzione: run-all è pesante (fasi 4.9M, impegni 2.7M, progetti 2.3M righe).
# In sviluppo usa run-dataset / run-batch; in CI la selettività è in pipeline.yml.
TOOLKIT = toolkit

DATASETS := $(shell find datasets -name dataset.yml 2>/dev/null | sort)

# Dataset "leggeri" per iterazione locale (esclude i multi-M row)
LIGHT_DATASETS := \
	datasets/opencoesione-progetti-esteso/dataset.yml \
	datasets/opencoesione-indicatori/dataset.yml

.PHONY: check run run-all run-dataset run-batch run-light verify clean registry-write dashboard test-dashboard help

check:
	@for f in $(DATASETS); do \
		echo "→ $$f"; \
		$(TOOLKIT) run preflight --config "$$f" > /dev/null 2>&1 || exit 1; \
	done
	@echo "✅ All configs valid"

# Singolo dataset: make run-dataset DATASET=opencoesione-fasi
# (accetta slug o path dataset.yml)
run-dataset:
	@test -n "$(DATASET)" || (echo "Usage: make run-dataset DATASET=<slug|path>"; exit 1)
	@if [ -f "$(DATASET)" ]; then \
		$(TOOLKIT) run --config "$(DATASET)"; \
	else \
		$(TOOLKIT) run --config "datasets/$(DATASET)/dataset.yml"; \
	fi

# Batch selettivo (usato da pipeline.yml su PR merged)
run-batch:
	@test -s batch.txt || (echo "batch.txt vuoto — generate con detect o make batch-all"; exit 1)
	$(TOOLKIT) run --batch batch.txt

batch-all:
	@find datasets -name dataset.yml 2>/dev/null | sort > batch.txt
	@echo "📦 $(wc -l < batch.txt | tr -d ' ') dataset in batch.txt"

# Iterazione locale senza fasi/impegni (multi-M)
run-light:
	@for f in $(LIGHT_DATASETS); do \
		echo "→ $$f"; \
		$(TOOLKIT) run --config "$$f" || exit 1; \
	done

# Completo (schedule/dispatch). Pesante.
run-all:
	@for f in $(DATASETS); do \
		echo "→ Running $$f"; \
		$(TOOLKIT) run --config "$$f" || exit 1; \
	done

# Compat: make run = run-all documentato altrove; toolkit run senza config
# usa la config di default del toolkit (non consigliato in CI).
run:
	$(TOOLKIT) run

# Smoke output: mart attesi presenti e non vuoti
verify:
	python3 scripts/verify_output.py --year 2026

# Dashboard Streamlit (locale)
dashboard:
	cd dashboard && streamlit run app.py

test-dashboard:
	pytest dashboard/tests/ -q

clean:
	rm -rf out/data/_runs out/data/probe out/data/raw out/data/clean out/data/mart out/data/cross .tmp/ batch.txt

registry-write:
	$(TOOLKIT) registry build --prefix open-coesione --write

help:
	@grep -E '^[a-zA-Z_-]+:' Makefile | sort
