# WebAssembly Components from WAT

## Requirements

- `wasm-tools`
- `wasmtime`

## Running

```bash
make build
```

```bash
wasmtime run --invoke 'add(1, 2)' program.component.wasm
```

## How it works?

First we need to define a few terms.

### WAT (WebAssembly Text Format)

This is just a text version of the WebAssembly bytecode. It is higher level
than the bytecode, but mostly the same.

### WIT (WebAssembly Interface Types)

This is the IDL (Interface Definition Language) used when formally defining
what a WebAssembly component provides.

### Component Interface

Put simply, an interface is a collection of type and function definitions.
Often an interface will encapsulate a specific bit of functionality.

### Component World

A world is a collection of interfaces. These interfaces can either be
exports (as a consumer you can call these), or they can be imports
(as a consumer you are expected to provide these).

### Component Packages

A package is a collection of WIT files.

### A step-by-step

When creating a WebAssembly component, we want to first define what the
external contract of this component will look like.

```wit
package tutorial:program@0.1.0;

interface adder {
    add: func(x: u32, y: u32) -> u32;
}

world program {
    export adder;
}
```

Here we define a package named `tutorial:program`. We say this package
has one world `program`. This world exports the functionality provided
by the `adder` interface. The `adder` interface provides an `add` function
that takes two `u32` types and returns a `u32`.

If we wanted to create an implementation of this package it would look like:

```wat
(module
  (func $add (param $lhs i32) (param $rhs i32) (result i32)
		local.get $lhs
		local.get $rhs
		i32.add)

  (export "tutorial:program/adder@0.1.0#add" (func $add))
)
```

As this is a fairly simple example, the WAT ends up being quite simple. We
have a function `$add` that takes two `i32` parameters, and returns an `i32`.
It is implemented by adding the parameters and returning them.

This `$add` function is then exported as `tutorial:program/adder@0.1.0#add`.
The `tutorial:program` matches our `package` name. We then specify that this
export is part of the `adder` interface. Next we specify this export is for
version `0.1.0` of the package. Finally we specify that this export is for
the `add` function.

We can then create a Wasm binary with component metadata embedded with

```bash
wasm-tools component embed program.wit program.wat -o program.wasm
```

To then create a Wasm component from this we can run

```bash
wasm-tools component new program.wasm -o program.component.wasm
```

## References used

- https://component-model.bytecodealliance.org/language-support/wat.html
