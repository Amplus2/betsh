# BETter SHell

Better Shell - or betsh for short - is a new kind of scripting language, which
aims to be a replacement for sh/bash scripting. While using it as a REPL makes
sense, using it as your login shell is probably not the best idea.

## The basic syntax

### Variables

    a=b

Sets the variable `a` to the value `b`. If `a` doesn't exist, it is created in
the current scope.

    c=$a

Sets the variable `c` to the value of the variable `a`.

When variables go out of scope, they are automatically deleted.

### Functions

    f=[a b c] {
        + a b c
    }

Defines the function `f` with the parameters `a`, `b` and `c`.

    f 1 2 3

Calls the function `f` with the parameters `1`, `2` and `3`.

Function calls are run through either microprocesses or processes,
microprocesses being low-overhead, non-forking emulations of processes, which
means that they each have their own stdin, stdout, stderr and exit code.

Pipes work exactly like in sh, with the addition that they can also be used with
microprocesses.

<!--TODO: std* redirections-->

The exit code of the last (micro)process that was ran is stored in the
pseudovariable `?`, like in sh.

Function calls search for the function in the current file, imported libraries,
`betsh` standard library and `PATH`, in that order.

    (f 1 2 3)

Reads the stdout of `f` when called with the parameters `1`, `2` and `3`.

There is also a special case for a variable number of arguments:

    g=[@]{ print $@ }

Defines the variable `g` as a function that takes any number of arguments and
prints all of them.

## If

    a=(if 0 1 ; else 2)

Sets the variable `a` to `1`, because `0` evaluates to `true`, just like in sh.

    if false print lol
    elif 1 print lel
    else print kek

Prints "kek", because `false` and non-zero numbers evaluate to `false`.

    make
    else print compilation failed

Shows how to use `else` with other (micro)processes, by calling `print` when
`make` fails.

    if make print compiled successfully

## For

    for 1 2 3 [i]{
        print $i
    }

Prints:

    1
    2
    3

Can also be η-reduced (shortened) to:

    for 1 2 3 print

because print is a unary (one argument) function.

## While

    while true {
        print lulw
    }

Prints "lulw" in an infinite loop.

## Streams

Like in `sh`, there are streams. But `betsh` streams are massively improved. The
standard C streams are pre-defined, just like in `sh`:

| id | name     |
| -- | -------- |
| 0  | `stdin`  |
| 1  | `stdout` |
| 2  | `stderr` |

### `sh` redirections

Like in `sh`, you can redirect to and from streams, as well as files:

    print hello >&2
    print omg it works > /tmp/file
    echo second line >> /tmp/file
    echo < /tmp/file
    echo lel <&1

<!--TODO: isn't the last example senseless?!-->

### `betsh` streams

    s=(mkstream)

Assigns `s` to the id of a new stream, like `3`. It can now be written to and
read from, like a normal `sh` stream:

    print hi >&$s

Now `s` is closed. But to allow for IPC through streams, we don't want this, so
you can also use the append operators here:

    s=(mkstream)
    print <&$s &
    print 1 >>&$s
    print 2 >>&$s
    print 3 >&$s
    # output:
    # 1
    # 2
    # 3

## Libraries

Using shell functions defined somewhere else is a mess in every `sh`
implementation around, `betsh` tries to fix this:

    import mylibrary
    mylibrary.some-function arg1 arg2 arg3

Imports a library and calls a function defined in it.

    import mylibrary/*
    some-function arg1 arg2 arg3

Imports everything defined in a library and calls a function from there.

    import mylibrary/some-function
    some-function arg1 arg2 arg3

Imports only a specific function from a library and calls it.

    import mylibrary/????-function

Imports everything defined in a library that matches a wildcard.

### Restrictions on naming

You can use basically any non-whitespace Unicode character for your names, but
you may not ever define or use anything with two leading underbars (`__`), as
that is reserved for internals of the implementation and standard library.

### stdlib functions

| function            | arguments      | description                                                             | ec                                  |
| ------------------- | -------------- | ----------------------------------------------------------------------- | ----------------------------------- |
| `if`                | `cond` `block` | runs `block` if `cond`'s ec is 0                                        |                                     |
| `elif`              | `cond` `block` | runs `block` if the previous command's ec is not 0 and `cond`'s ec is 0 |                                     |
| `else`              | `block`        | runs `block` if the previous command's ec is not 0                      | `block`                             |
| `while`             | `cond` `block` | runs `block` while `cond` returns 0                                     | `block`                             |
| `for`               | `@` `f`        | calls `f` with every argument before it                                 | `f`                                 |
| `mkstream`          |                | creates a new stream and prints the id (fd)                             | 0 if everything worked              |
| `=`                 | `@`            | probes if all parameters are equal (sets ec)                            | $1 == ... == $n                     |
| `!=`                | `@`            | probes if any of the parameters are not equal (sets ec)                 | ! "= $@"                            |
| `&`                 | `@`            | probes if all of the parameters evaluate to true (sets ec)              | $1 && ... && $n                     |
| <code>&vert;</code> | `@`            | probes if any of the parameters evaluate to true (sets ec)              | $1 &vert;&vert; ... &vert;&vert; $n |
| `!`                 | `b`            | inverts `b`                                                             | `b` ? false : true                  |

<!--TODO: more-->
