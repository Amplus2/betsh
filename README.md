# BETter SHell

Better Shell - or betsh for short - is a new kind of scripting language, which
aims to be a replacement for sh/bash scripting. While using it as a REPL makes
sense, using it as your login shell is probably not the best idea.

## The basic syntax

### Variables

    a = b

Sets the variable `a` to the value `b`. If `a` doesn't exist, it is created in
the current scope.
When variables go out of scope, they are automatically deleted.

### Functions

    fn f a b c =
        # ...

Defines the function `f` with the parameters `a`, `b` and `c`.

    f 1 2 3

Calls the function `f` with the parameters `1`, `2` and `3`.

Function calls are run through either microprocesses or processes,
microprocesses being low-overhead, non-forking emulations of processes, which
means that they each have their own stdin, stdout, stderr and exit code.

Pipes work exactly like in sh.

The exit code of the last (micro)process that was ran is stored in the
pseudovariable `!`.

Function calls search for the function in the current file, imported libraries,
betsh standard library and PATH, in that order.

    (f 1 2 3)

Reads the stdout of `f` when called with the parameters `1`, `2` and `3`.
