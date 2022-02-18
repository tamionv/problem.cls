# Documentation

This file attempts to provide basic documentation of the facilities offered in this .cls file.

# Document class options

(Note: a "document class option" is provided to the `\documentclass` command e.g. `\documentclass[option]{problem}`.)

## Language options

These options provide localisations for various languages. Support is *very* incomplete, but we will try to continuously upgrade it as time passes. The options are the 2-letter codes for the respective languages. The languages currently supported are English, Romanian, Bulgarian, Italian, Hungarian and Ukrainian, with codes `en`, `ro`, `bg`, `it`, `hu`, `uk`.

## File structure options

These options provide control on how certain aspects of the problem file are formatted:

* `files`: if set, the problem will read/write from files of form `problemname.in` and `problemname.out`, rather than from `stdin` and `stdout`.
* `header`: if set, the problem will indicate that the user must include a header called `problemname.h`.
* `listRestrictions`: if set, the restrictions are formatted as a list, rather than as a table.

# Commands and environments

## Translation commands

Various commands exist that allow one to translate keywords in the problem file. For any keyword `kw`, the command `\tlkw{xyz}` tells LaTeX that `kw` is translated as `xyz`. The keywords currently supported are

* `problem`
* `inputfile`
* `outputfile`
* `headerc`
* `headercpp`
* `examples`
* `explanations`
* `points`
* `restrictions`
* `subtask`

## Problem information commands

These commands allow one to specify various details about the contest and problem. These are:

* `\contest{name}`, which sets the name of the contest to `name`.
* `\location{place}`, which sets the location of the contest to `place`.
* `\date{day}{month}{year}`, which sets the date of the contest to `day/month/year`.
* `\logo{pic}`, which sets the logo of the contest to `pic`.
* `\title{name}`, which sets the name of the problem to `name`.
* `\filename{name}`, which sets the name of the input/output/header file to `name`. This command should only be used if the title of the problem contains spaces, otherwise it is superfluous.

## Structural commands

These commands give structure to the problem.

* `\maketitle`: makes the title of the problem.
* `\section`, `\subsection`: creates section or subsection headings.
* `\begin{examples} ... \end{examples}`: Begins the example table.
* `\begin{examplesexplained} ... \end{examplesexplained}`: Begins a 3-column examples table, with one column for explanations.
* `\exmp{input}{output}%`: Creates a row of an examples table.
* `\exmpexplained{input}{output}{explanation}%`: Creates a row of an examples table with explanations.
* `\begin{restrictions}[general] ... \end{restrictions}`: Introduces the restrictions for the problem. `general` should either be ommited, or should be a sequence of restrictions that are always valid for the problem, each preceded by a `\item`.
* `\restr{points}{contents}: within a `restrictions` environment, introduces a subtask worth `points` points, with restriction `contents`.

## Miscellanneous commands

* `\np{number}`: prints `number` in a consistent format.
