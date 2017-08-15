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
test: .comet/8030c3912f57888f83ad.phony .comet/70ed28144e43c7deae81.phony
.PHONY: test/linux_x64
test/linux_x64: .comet/70ed28144e43c7deae81.phony
.PHONY: test/linux_x86
test/linux_x86: .comet/8030c3912f57888f83ad.phony
.PHONY: .comet
.comet:
	if [ ! -d "$@" ] || [ ! -d "`readlink .comet`" ]; then $(COMET_LN) -sf `mktemp -d` $@; fi
.PHONY: .comet/8030c3912f57888f83ad.phony
.comet/8030c3912f57888f83ad.phony: .comet/e542f5d8ea9b413c1db8.elf .comet/e7b25529bcd9f873ade7.bin
	$(COMET_CP) .comet/e542f5d8ea9b413c1db8.elf bin/test_linux_x86.elf
	$(COMET_CP) .comet/e7b25529bcd9f873ade7.bin bin/test_linux_x64.bin
	$(COMET_CP) .comet/e542f5d8ea9b413c1db8.map bin/test_linux_x86.map
.comet/e542f5d8ea9b413c1db8.elf: .comet/ae8d70c4ad166e5f05e6.s   | .comet
	$(COMET_LD) --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake   -Wl,-Map=.comet/e542f5d8ea9b413c1db8.map -o $@ .comet/ae8d70c4ad166e5f05e6.s  
.comet/ae8d70c4ad166e5f05e6.s: .comet/1a6fa701e7f59b5130cf.ll | .comet
	$(COMET_OPT) -S -Ofast --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -o $@ $<
.comet/1a6fa701e7f59b5130cf.ll: .comet/848a630ef53895b3e139.ll .comet/44b0462bd14ef6c5f324.ll .comet/3e98d572194d9f0797c2.ll | .comet
	$(COMET_LINK) -S -o $@ $^
.comet/848a630ef53895b3e139.ll: src/module_a/impl.c src/module_a/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -DFOO=BAR -std=c89 -o $@ -c $<
.comet/44b0462bd14ef6c5f324.ll: src/module_b/impl.c src/module_b/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -DFOO=BAZ -std=c89 -o $@ -c $<
.comet/3e98d572194d9f0797c2.ll: src/main.c src/common.h src/library.h src/module_a/impl.h src/module_b/impl.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -std=c89 -o $@ -c $<
.comet/e7b25529bcd9f873ade7.bin: .comet/e542f5d8ea9b413c1db8.elf | .comet
	(command -v x86-unknown-linux-gnu-$(COMET_OBJCOPY) > /dev/null) && x86-unknown-linux-gnu-$(COMET_OBJCOPY) -O binary $< $@ || $(COMET_OBJCOPY) -O binary $< $@
.PHONY: .comet/70ed28144e43c7deae81.phony
.comet/70ed28144e43c7deae81.phony: .comet/9dc94950d9e3e85125d8.elf
	$(COMET_CP) .comet/9dc94950d9e3e85125d8.elf bin/test_linux_x64.elf
	$(COMET_CP) .comet/9dc94950d9e3e85125d8.map bin/test_linux_x64.map
.comet/9dc94950d9e3e85125d8.elf: .comet/c8008c83512b753cc0f5.s   | .comet
	$(COMET_LD) --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake   -Wl,-Map=.comet/9dc94950d9e3e85125d8.map -o $@ .comet/c8008c83512b753cc0f5.s  
.comet/c8008c83512b753cc0f5.s: .comet/5b532eac405115700e15.ll | .comet
	$(COMET_OPT) -S -O3 --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -o $@ $<
.comet/5b532eac405115700e15.ll: .comet/4b993a43966c8f84b121.ll .comet/29c2bb990093d697ea4f.ll .comet/1872519e0f2a83f8c783.ll | .comet
	$(COMET_LINK) -S -o $@ $^
.comet/4b993a43966c8f84b121.ll: src/module_a/impl.c src/module_a/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -DFOO=BAR -std=c89 -o $@ -c $<
.comet/29c2bb990093d697ea4f.ll: src/module_b/impl.c src/module_b/impl.h src/common.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -DFOO=BAZ -std=c89 -o $@ -c $<
.comet/1872519e0f2a83f8c783.ll: src/main.c src/common.h src/library.h src/module_a/impl.h src/module_b/impl.h include/public_api.h | .comet
	$(COMET_CC) -x c --target=x86_64-unknown-linux-gnu -march=skylake -mcpu=skylake -S -flto -Isrc -Iinclude -std=c89 -o $@ -c $<
.PHONY: clean
clean:
	$(COMET_RM) -rf .comet