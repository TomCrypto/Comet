COMET_LN ?= ln
$(error No build file 'comet.rb' found)
.PHONY: .comet
.comet:
	if [ ! -d "$@" ] || [ ! -d "`readlink .comet`" ]; then $(COMET_LN) -sf `mktemp -d` $@; fi
