COMET_LN ?= ln
COMET_RM ?= rm
.PHONY: all
all:
.PHONY: .comet
.comet:
	if [ ! -d "$@" ] || [ ! -d "`readlink .comet`" ]; then $(COMET_LN) -sf `mktemp -d` $@; fi
.PHONY: clean
clean:
	$(COMET_RM) -rf .comet
