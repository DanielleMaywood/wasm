.PHONY: build clean

build: program.component.wasm

program.component.wasm: program.wasm
	wasm-tools component new $< -o $@

program.wasm: program.wit program.wat
	wasm-tools component embed program.wit program.wat -o $@

clean:
	rm -f program.wasm program.component.wasm
