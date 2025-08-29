(module
  (import "wasi:cli/stdout@0.2.7" "get-stdout"
    (func $get_stdout (result (; ref output-stream ;) i32)))

  (import "wasi:io/streams@0.2.7" "[method]output-stream.blocking-write-and-flush"
      (func $blocking_write_and_flush
        (param (; ref output-stream ;) i32)
        (param (; ptr to list ;) i32)
        (param (; len of list ;) i32)
        (param (; ptr of result ;) i32)))

  (memory 1)

  (export "memory" (memory 0))

  ;; Store a hello world string into memory at offset 0
  (data (i32.const 0) "Hello World!")

  (func $greet
    call $get_stdout ;; we want to write to stdout
    i32.const 0      ;; the address of our string in memory
    i32.const 12     ;; and how long the string is
    i32.const 12     ;; the address to store the result at
    call $blocking_write_and_flush
  )

  (export "tutorial:program/greeter@0.1.0#hello" (func $greet))
)
