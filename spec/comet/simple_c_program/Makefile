COMET_LN ?= ln
COMET_CP ?= cp
COMET_LD ?= clang
COMET_OPT ?= clang
COMET_LINK ?= llvm-link
COMET_CC ?= clang
COMET_RM ?= rm
.PHONY: all
all: main
.PHONY: main
main: .comet/116dd1901deffe3fa447.phony
.PHONY: main/linux_x64
main/linux_x64: .comet/116dd1901deffe3fa447.phony
.PHONY: .comet
.comet:
	if [ ! -d "$@" ] || [ ! -d "`readlink .comet`" ]; then $(COMET_LN) -sf `mktemp -d` $@; fi
.PHONY: .comet/116dd1901deffe3fa447.phony
.comet/116dd1901deffe3fa447.phony: .comet/457234dc02f9dfb5542f.elf
	$(COMET_CP) .comet/457234dc02f9dfb5542f.elf main
.comet/457234dc02f9dfb5542f.elf: .comet/ccb40296b80a66398214.s   | .comet
	$(COMET_LD) --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake   -Wl,-Map=.comet/457234dc02f9dfb5542f.map -o $@ .comet/ccb40296b80a66398214.s
.comet/ccb40296b80a66398214.s: .comet/93cf4b5489860f6a6154.ll | .comet
	$(COMET_OPT) -S -O1 --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -o $@ $<
.comet/93cf4b5489860f6a6154.ll: .comet/02c92d481320c450e153.ll | .comet
	$(COMET_LINK) -S -o $@ $^
.comet/02c92d481320c450e153.ll: main.c ./stuff.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -I.  -o $@ -c $<
.PHONY: clean
clean:
	$(COMET_RM) -rf .comet
