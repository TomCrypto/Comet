COMET_LN ?= ln
COMET_CP ?= cp
COMET_LD ?= clang
COMET_OPT ?= clang
COMET_LINK ?= llvm-link
COMET_CC ?= clang
COMET_OBJCOPY ?= objcopy
COMET_RM ?= rm
.PHONY: all
all: test
.PHONY: test
test: .comet/8ef077f0cd5aaff49b65.phony .comet/b318cee1620386b56865.phony
.PHONY: test/linux_x64
test/linux_x64: .comet/b318cee1620386b56865.phony
.PHONY: test/linux_x86
test/linux_x86: .comet/8ef077f0cd5aaff49b65.phony
.PHONY: .comet
.comet:
	if [ ! -d "$@" ] || [ ! -d "`readlink .comet`" ]; then $(COMET_LN) -sf `mktemp -d` $@; fi
.PHONY: .comet/8ef077f0cd5aaff49b65.phony
.comet/8ef077f0cd5aaff49b65.phony: .comet/6e9e95f81d33c9c56999.elf .comet/6801b5b5df17e4f2ddd2.bin
	$(COMET_CP) .comet/6e9e95f81d33c9c56999.elf bin/test_linux_x86.elf
	$(COMET_CP) .comet/6801b5b5df17e4f2ddd2.bin bin/test_linux_x64.bin
	$(COMET_CP) .comet/6e9e95f81d33c9c56999.map bin/test_linux_x86.map
.comet/6e9e95f81d33c9c56999.elf: .comet/72011646c080021a2ca1.s  | .comet
	$(COMET_LD) --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake   -Wl,-Map=.comet/6e9e95f81d33c9c56999.map -o $@ $^ 
.comet/72011646c080021a2ca1.s: .comet/39a50271e7c848a47a93.ll | .comet
	$(COMET_OPT) -S -Ofast --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -o $@ $<
.comet/39a50271e7c848a47a93.ll: .comet/4d2501c8d4d8a11d7131.ll .comet/4ea3c3da23201dcbd4a2.ll .comet/00757f6e0a0b4ff24514.ll | .comet
	$(COMET_LINK) -S -o $@ $^
.comet/4d2501c8d4d8a11d7131.ll: src/module_a/impl.c src/module_a/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc-Iinclude -DFOO=BAR -std=c89 -o $@ -c $<
.comet/4ea3c3da23201dcbd4a2.ll: src/module_b/impl.c src/module_b/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc-Iinclude -DFOO=BAZ -std=c89 -o $@ -c $<
.comet/00757f6e0a0b4ff24514.ll: src/main.c src/common.h src/library.h src/module_a/impl.h src/module_b/impl.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc-Iinclude -std=c89 -o $@ -c $<
.comet/6801b5b5df17e4f2ddd2.bin: .comet/6e9e95f81d33c9c56999.elf | .comet
	(command -v x86-unknown-linux-gnu-$(COMET_OBJCOPY) > /dev/null) && x86-unknown-linux-gnu-$(COMET_OBJCOPY) -O binary $< $@ || $(COMET_OBJCOPY) -O binary $< $@
.PHONY: .comet/b318cee1620386b56865.phony
.comet/b318cee1620386b56865.phony: .comet/719f853cbed7abc8fd85.elf
	$(COMET_CP) .comet/719f853cbed7abc8fd85.elf bin/test_linux_x64.elf
	$(COMET_CP) .comet/719f853cbed7abc8fd85.map bin/test_linux_x64.map
.comet/719f853cbed7abc8fd85.elf: .comet/3b044e603b145f4fbc04.s  | .comet
	$(COMET_LD) --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake   -Wl,-Map=.comet/719f853cbed7abc8fd85.map -o $@ $^ 
.comet/3b044e603b145f4fbc04.s: .comet/e10c49538753263f5465.ll | .comet
	$(COMET_OPT) -S -O3 --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -o $@ $<
.comet/e10c49538753263f5465.ll: .comet/8a80b3d251d0ac59da27.ll .comet/416611e4ce7c48c0779d.ll .comet/7f0db3e959b1e7eb61e9.ll | .comet
	$(COMET_LINK) -S -o $@ $^
.comet/8a80b3d251d0ac59da27.ll: src/module_a/impl.c src/module_a/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc-Iinclude -DFOO=BAR -std=c89 -o $@ -c $<
.comet/416611e4ce7c48c0779d.ll: src/module_b/impl.c src/module_b/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc-Iinclude -DFOO=BAZ -std=c89 -o $@ -c $<
.comet/7f0db3e959b1e7eb61e9.ll: src/main.c src/common.h src/library.h src/module_a/impl.h src/module_b/impl.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc-Iinclude -std=c89 -o $@ -c $<
.PHONY: clean
clean:
	$(COMET_RM) -rf .comet