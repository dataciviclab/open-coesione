TOOLKIT = toolkit

DATASETS := $(shell find datasets -name dataset.yml 2>/dev/null | sort)

.PHONY: check run run-all clean registry help

check:
	@for f in $(DATASETS); do \
		echo "→ $$f"; \
		$(TOOLKIT) run preflight --config "$$f" > /dev/null 2>&1 || exit 1; \
	done
	@echo "✅ All configs valid"

run:
	$(TOOLKIT) run

run-all:
	@for f in $(DATASETS); do \
		echo "→ Running $$f"; \
		$(TOOLKIT) run --config "$$f" || exit 1; \
	done

clean:
	rm -rf out/data/_runs out/data/probe out/data/raw out/data/clean out/data/mart out/data/cross .tmp/

registry-write:
	$(TOOLKIT) registry build --prefix open-coesione --write

help:
	@grep -E '^[a-zA-Z_-]+:' Makefile | sort
