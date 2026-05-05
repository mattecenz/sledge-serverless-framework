SHELL:=/bin/bash

.PHONY: all awsm libsledge runtime apps clean

# The master target that compiles everything in the correct dependency order
all: awsm libsledge runtime apps
	@echo "========================================="
	@echo "   Sledge Full Build Completed!"
	@echo "========================================="

awsm:
	@echo ">>> Building aWsm Compiler..."
	cd /sledge/awsm && ./install_deb.sh

libsledge:
	@echo ">>> Building libsledge dynamic/static library..."
	cd /sledge/libsledge && $(MAKE) all

runtime: libsledge
	@echo ">>> Building Sledge Runtime..."
	cd /sledge/runtime && $(MAKE) clean all

wasm_apps:
	ln -sr awsm/applications/wasm_apps/ applications/

apps: runtime
	@echo ">>> Building Applications (Wasm Apps & Fibonacci)..."
	$(MAKE) wasm_apps
	cd /sledge/applications && $(MAKE) clean fibonacci.install

clean:
	cd /sledge/libsledge && make clean || true
	cd /sledge/runtime && make clean || true
	cd /sledge/applications && make clean || true

# Tests
.PHONY: test
test:
	make -f test.mk all
