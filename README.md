# Problem class for Informatics Olympiads

This is a latex class for Informatics Olympiad problems, in particular in
Romania.

## Documentation

All of this requires `lualatex`.

In general, we will give optional arguments in *key-value* syntax. In other
words, we will have optional arguments in the form

```
\command[key1=value1, key2=value2]{...}
```

Some things worth remembering: (i) you don't need to specify *all* the key-value
pairs, only the ones you want to set, (ii) if one of the values contains `[` or
`]`, or `,` then you can enclose the value in `{` and `}` without changing the
meaning of the command.

### Language

Most of the translation aspects will be easily handled as we go along. For
convenience, we offer settings for Romanian (by default) and English. For
English, simply pass the `en` option to the class, i.e.

```
\documentclass[en]{problem}
```

### Convenience commands

We give convenient shorthands for three basic functions: printing numbers
nicely, printing filenames nicely, and emphasizing text, as follows:

```
\np{1000000}
\filename{problema.in}
\alert{Atentie!}
```

### Headers

The class is thought out to have images in the head, one in the left, one in the
middle, one in the right. These can be set using the following commands:

```
\leftlogo{a.png}
\centerlogo{b.jpg}
\rightlogo{c.png}
```

Of course, the headers can be changed manually using

```
\lhead{. . .}
\chead{. . .}
\rhead{. . .}
```

### Title

Set the title using `\title{Name of problem}`, then use `\maketitle` to tyepset
it. In order to translate the word `Problem` in the title, simply write
`\maketitle[Replacement for problem]`.

### Constraints

The typical block for problem constraints will look like this (in Romanian):

```
\section{Restrictii}

\begin{constraints}
    \item ...
    \item ...
    \item ...
\end{constraints}

\begin{subtasks}
    \task{20}{Subtask 1 constraints}
    \task{20}{Subtask 2 constraints}
    \task{20}{Subtask 3 constraints}
    \task{20}{Subtask 4 constraints}
    \task{20}{Subtask 5 constraints}
\end{subtasks}
```

We provide the `constraints` list, the `subtasks` environment and the `\task`
command for this. Only the `subtasks` command has optional arguments. It takes
these arguments using key-value syntax. The possible keys are:

```
\begin{subtasks}[
    translate points=A,
    translate constraints=B,
    full score=100]
```

The options `translate points` and `translate constraints` are there to allow
the user to change the headings of the table. The option `full score` is for a
sanity-checking mechanism. The package checks if the total number of points in
all restrictions is equal to `full score`, and complains if it is not (by
printing a message in the document). Default is `full score=100`.

If multiple tables are used then the subtask ids will be numbered consecutively.

### Tables of examples.

There is only one example table command, but it has several powerful options,
allowing the user to add inline explanations in a new column. The syntax is
basically the same. Without inline explanations the syntax is typically:

```
\section{Exemple}

\begin{examples}
\fromfile{ex1}
\fromtext{
    input
}{
    output
}
\end{examples}
```

This loads `ex1.in` and `ex1.out` in the first row of the table, and as the
second row of the table puts input `input` and output `output`. Unfortunately
the tables cannot break automatically, but one can simply create a second table
if the first is too long.

With inline explanations, the typical syntax is:

```
\section{Exemple}

\begin{examples}
\fromfile{ex1}[An explanation]
\fromfile{ex2}
\fromtext{
    input
}{
    output
}[Another explanation]
\fromtext{
    input
}{
    output
}
\end{examples}
```

Whenever the optional argument to `\fromtext` or `\fromfile` is provided, it will
print that as the explanation for that example, and will automatically add an
`explanations` column to the table.

Let us now explain the options that `examples` takes.

```
\begin{examples}[
    input width=20,
    output width=30,
    explanation width={4cm},
    translate explanation={Explanation},
    translate input data={Input Data},
    translate output data={Output Data}]
```

The `input width` and `output width` argument let us control the width of the
input data and output data columns in the table; this is done in terms of the
number of characters in a line. (Lines longer than that will be broken.) The
`explanation width` argument allows us control the width of the explanation
column in the table, this time in terms of centimeters (or any other latex
unit). The next 3 arguments are all for translating the text in the table.

### Example

The following is a Romanian language usage example for the class. 

```
\documentclass{problem}

% Change the title appropriately
\title{Numere}

% Replace these file names by the desired logos.
\leftlogo{logo1.jpg}
\centerlogo{logo2.jpg}
\rightlogo{logo3.jpg}

\begin{document}

\maketitle

Se dau $n$ numere naturale.

\section{Cerință}

Să se găsească sum lor.

\section{Date de intrare}
În fișierul de intrare \filename{numere.in} se vor găsi numerele.

\section{Date de ieșire}
În fișierul de ieșire \filename{numere.out} se va afiș suma.

\section{Restricții}

\begin{constraints}
    \item Sunt cel mult $\np{1000}$ de numere.
    \item Numerele sunt nenule.
\end{constraints}

\begin{subtasks}
    \task{50}{Va exista un singur număr}
    \task{50}{Fără restricții suplimentare}
\end{subtasks}

\section{Exemple}

\begin{examples}
    % This assumes that files numere.in and numere.out exist.
    \fromfile{numere}
    \fromtext{
        3
        1 2
    }{
        3
    }
\end{examples}

\end{document}
```
