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
main: .comet/fb5bd0bc5bbbcfb8d75d.phony
.PHONY: main/linux_x64
main/linux_x64: .comet/fb5bd0bc5bbbcfb8d75d.phony
.PHONY: .comet
.comet:
	if [ ! -d "$@" ] || [ ! -d "`readlink .comet`" ]; then $(COMET_LN) -sf `mktemp -d` $@; fi
.PHONY: .comet/fb5bd0bc5bbbcfb8d75d.phony
.comet/fb5bd0bc5bbbcfb8d75d.phony: .comet/6a16a16dcf71bbd81420.elf
	$(COMET_CP) .comet/6a16a16dcf71bbd81420.elf main
.comet/6a16a16dcf71bbd81420.elf: .comet/6da374969db200830aba.s  | .comet
	$(COMET_LD) --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake   -Wl,-Map=.comet/6a16a16dcf71bbd81420.map -o $@ $^ 
.comet/6da374969db200830aba.s: .comet/d00df735d73ec90af321.ll | .comet
	$(COMET_OPT) -S -O1 --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -o $@ $<
.comet/d00df735d73ec90af321.ll: .comet/15a47430b29cc4417a92.ll | .comet
	$(COMET_LINK) -S -o $@ $^
.comet/15a47430b29cc4417a92.ll: main.c ./stuff.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -I.  -o $@ -c $<
.PHONY: clean
clean:
	$(COMET_RM) -rf .comet