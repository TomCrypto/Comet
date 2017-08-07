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
test: .comet/41f8b3e8804fea68ec6b.phony .comet/b5c19fd070359b597edd.phony
.PHONY: test/linux_x64
test/linux_x64: .comet/b5c19fd070359b597edd.phony
.PHONY: test/linux_x86
test/linux_x86: .comet/41f8b3e8804fea68ec6b.phony
.PHONY: .comet
.comet:
	if [ ! -d "$@" ] || [ ! -d "`readlink .comet`" ]; then $(COMET_LN) -sf `mktemp -d` $@; fi
.PHONY: .comet/41f8b3e8804fea68ec6b.phony
.comet/41f8b3e8804fea68ec6b.phony: .comet/58e4769019097316a2f4.elf .comet/3bc14a6c241d158c30cd.bin
	$(COMET_CP) .comet/58e4769019097316a2f4.elf bin/test_linux_x86.elf
	$(COMET_CP) .comet/3bc14a6c241d158c30cd.bin bin/test_linux_x64.bin
	$(COMET_CP) .comet/58e4769019097316a2f4.map bin/test_linux_x86.map
.comet/58e4769019097316a2f4.elf: .comet/55978226b396c7da38ec.s  | .comet
	$(COMET_LD) --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake   -Wl,-Map=.comet/58e4769019097316a2f4.map -o $@ $^ 
.comet/55978226b396c7da38ec.s: .comet/45b8ac54c1523683a185.ll | .comet
	$(COMET_OPT) -S -Ofast --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -o $@ $<
.comet/45b8ac54c1523683a185.ll: .comet/066c9d603b1250716309.ll .comet/1eddb1ee8e3f2bd08fa2.ll .comet/e49cdc7c30bb85a26a1e.ll | .comet
	$(COMET_LINK) -S -o $@ $^
.comet/066c9d603b1250716309.ll: src/module_a/impl.c src/module_a/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -DFOO=BAR -std=c89 -o $@ -c $<
.comet/1eddb1ee8e3f2bd08fa2.ll: src/module_b/impl.c src/module_b/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -DFOO=BAZ -std=c89 -o $@ -c $<
.comet/e49cdc7c30bb85a26a1e.ll: src/main.c src/common.h src/library.h src/module_a/impl.h src/module_b/impl.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -std=c89 -o $@ -c $<
.comet/3bc14a6c241d158c30cd.bin: .comet/58e4769019097316a2f4.elf | .comet
	(command -v x86-unknown-linux-gnu-$(COMET_OBJCOPY) > /dev/null) && x86-unknown-linux-gnu-$(COMET_OBJCOPY) -O binary $< $@ || $(COMET_OBJCOPY) -O binary $< $@
.PHONY: .comet/b5c19fd070359b597edd.phony
.comet/b5c19fd070359b597edd.phony: .comet/239aef468b7c74e8eb07.elf
	$(COMET_CP) .comet/239aef468b7c74e8eb07.elf bin/test_linux_x64.elf
	$(COMET_CP) .comet/239aef468b7c74e8eb07.map bin/test_linux_x64.map
.comet/239aef468b7c74e8eb07.elf: .comet/9eb2d2641e6518828e34.s  | .comet
	$(COMET_LD) --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake   -Wl,-Map=.comet/239aef468b7c74e8eb07.map -o $@ $^ 
.comet/9eb2d2641e6518828e34.s: .comet/c743dd82509170cb5828.ll | .comet
	$(COMET_OPT) -S -O3 --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -o $@ $<
.comet/c743dd82509170cb5828.ll: .comet/9e5dea7cf944c74e7a6c.ll .comet/e054566ad272c0a69ba6.ll .comet/b299d49b84f938ace557.ll | .comet
	$(COMET_LINK) -S -o $@ $^
.comet/9e5dea7cf944c74e7a6c.ll: src/module_a/impl.c src/module_a/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -DFOO=BAR -std=c89 -o $@ -c $<
.comet/e054566ad272c0a69ba6.ll: src/module_b/impl.c src/module_b/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -DFOO=BAZ -std=c89 -o $@ -c $<
.comet/b299d49b84f938ace557.ll: src/main.c src/common.h src/library.h src/module_a/impl.h src/module_b/impl.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -std=c89 -o $@ -c $<
.PHONY: clean
clean:
	$(COMET_RM) -rf .comet