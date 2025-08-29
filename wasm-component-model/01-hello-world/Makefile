.PHONY: build run clean

build: program.component.wasm

run: build
	wasmtime run program.component.wasm

program.component.wasm: program.wasm
	wasm-tools component new $< -o $@

program.wasm: program.wit program.wat
	wasm-tools component embed program.wit program.wat -o $@ --features all

clean:
	rm -f program.wasm program.component.wasm
