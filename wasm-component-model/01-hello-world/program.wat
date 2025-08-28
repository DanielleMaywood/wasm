(module
  (import "wasi:cli/stdout@0.2.7" "get-stdout"
      (func $get_stdout (result i32)))

  (import "wasi:io/streams@0.2.7" "[method]output-stream.blocking-write-and-flush"
      (func $blocking_write_and_flush (param i32) (param i32) (param i32) (param i32)))

  (memory 1)

  (export "memory" (memory 0))

  (data (i32.const 0) "Hello World!")

  (func $greet
    call $get_stdout
    (i32.const 0)
    (i32.const 12)
    (i32.const 12)
    call $blocking_write_and_flush
  )

  (export "tutorial:program/greeter@0.1.0#hello" (func $greet))
)
