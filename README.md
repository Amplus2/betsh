# BETter SHell

Better Shell - or betsh for short - is a new kind of scripting language, which
aims to be a replacement for sh/bash scripting. While using it as a REPL makes
sense, using it as your login shell is probably not the best idea.

## The basic syntax

### Variables

    a = b

Sets the variable `a` to the value `b`. If `a` doesn't exist, it is created in
the current scope.

    c = $a

Sets the variable `c` to the value of the variable `a`.

When variables go out of scope, they are automatically deleted.

### Functions

    fn f a b c {
        # ...
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
pseudovariable `!`, like in sh.

Function calls search for the function in the current file, imported libraries,
betsh standard library and PATH, in that order.

    (f 1 2 3)

Reads the stdout of `f` when called with the parameters `1`, `2` and `3`.

    f = [x y]{ + $x $y }

Defines the variable `f` using a lambda.

## If

    a = (if 0 1
         else 2)

Sets the variable `a` to `1`, because `0` evaluates to `true`, just like in sh.

    if false print lol
    elif 1 print lel
    else print kek

Prints "kek", because `false` and `1` evaluate to `false`.

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

Can also be shortened to:

    for 1 2 3 print

because print is a function that takes one argument.

## While

    while true {
        print lulw
    }

Prints "lulw" in an infinite loop.

## Other stdlib functions

| function | description                                                       |
|----------|-------------------------------------------------------------------|
| =        | probes if all parameters are equal (sets ec)                      |
| !=       | probes if any of the parameters are not equal (sets ec)           |
| \|       | probes if any of the parameters evaluate to true (sets ec)        |
| &        | probes if all of the parameters evaluate to true (sets ec)        |
| !        | inverts the parameter (sets ec)                                   |
<!--TODO: more-->
