ifndef LIGO 
	LIGO = docker run --rm -v "${PWD}":"${PWD}" -w "${PWD}" ligolang/ligo:0.57.0
endif

compile = $(LIGO) compile contract ./src/contracts/$(1) -o ./src/compiled/$(2)
# test-ligo = $(LIGO) run test ./contracts/test/$(1)

default: help

help: 
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  clean   - Cleans the compiled contracts"
	@echo "  compile - Compiles contracts to Michelson"
	@echo "  help    - Shows this help message"
	@echo "  recompile - Cleans and compiles contracts"

clean:
	@echo "Cleaning..."
	@rm -rf ./src/compiled/*
	@echo "Cleaned successfully"

compile: 
	@echo "Compiling Main contract..."
	@$(call compile,main.mligo,main.tz)
	@echo "Compiled successfully"

recompile: clean compile