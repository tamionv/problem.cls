%% problem.cls
%% Copyright 2025-2026 Tamio-Vesa Nakajima
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   https://www.latex-project.org/lppl.txt
% and version 1.3c or later is part of all distributions of LaTeX
% version 2008 or later.
%
% This work has the LPPL maintenance status `maintained'.
% 
% The Current Maintainer of this work is Tamio-Vesa Nakajima
%
% This work consists of the file problem.cls

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{problem}[2026/01/19 LaTeX class for informatics olympiads problems]

\DeclareOption{en}{\def\@langen{}}
\ProcessOptions\relax

\LoadClass[11pt,a4paper,oneside]{article}
\RequirePackage{geometry}
\RequirePackage{xfp}
\RequirePackage{etoolbox}
\RequirePackage{luacode}
\RequirePackage{keyval}
\RequirePackage{pifont}
\RequirePackage{nicematrix}
\RequirePackage{xstring}
\RequirePackage{booktabs}
\RequirePackage{fontspec}
\RequirePackage{makecell}
\RequirePackage{numprint}
\RequirePackage[sb]{libertinus}
\RequirePackage{calc}
\RequirePackage{nicefrac}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{colortbl}
\RequirePackage{lastpage}
\RequirePackage[bottomtitles,calcwidth,pagestyles]{titlesec}
\RequirePackage[letterspace=112]{letterspace}
\RequirePackage[inline]{enumitem}
\RequirePackage{babel}
\RequirePackage{listings}

\newcommand\tlpoints[1]{
    \def\@tlpoints{#1}
}
\newcommand\tlconstraints[1]{
    \def\@tlconstraints{#1}
}
\newcommand\tlproblem[1]{
    \def\@tlproblem{#1}
}

\newcommand\tlinputdata[1]{
    \def\@tlinputdata{#1}
    \directlua{
        tlInputData="\luaescapestring{#1}"
    }
}
\newcommand\tloutputdata[1]{
    \def\@tloutputdata{#1}
    \directlua{
        tlOutputData="\luaescapestring{#1}"
    }
}
\newcommand\tlexplanation[1]{
    \def\@tlexplanation{#1}
    \directlua{
        tlExplanation="\luaescapestring{#1}"
    }
}

\ifdef\@langen{
    \PassOptionsToPackage{english}{babel}
    \tlpoints{Points}
    \tlconstraints{Constraints}
    \tlinputdata{Input data}
    \tloutputdata{Output data}
    \tlexplanation{Explanation}
    \tlproblem{Problem}
}{
    \PassOptionsToPackage{romanian}{babel}
    \tlpoints{Punctaj}
    \tlconstraints{Restricții}
    \tlinputdata{Date de intrare}
    \tloutputdata{Date de ieșire}
    \tlexplanation{Explicații}
    \tlproblem{Problema}
}

\geometry{a4paper,
    width=147mm,
    height=252mm, 
    top=80pt,
    headheight=45pt,
    headsep=20pt,
    footskip=30pt}


\setlength\parskip{8pt}
\setlength\parindent{0pt}

\setmonofont{IBM Plex Mono}[Scale=MatchLowercase]

\definecolor{maincolor}{Hsb}{200, 0.9, 0.40}

\titleformat{\section}[wrap]
    {\normalfont\fontseries{b}\fontshape{sc}\selectfont\large\filcenter}
    {\normalfont\mdseries\upshape}
    {0pt}
    {\hspace{-1cm}\lsstyle{{\textcolor{maincolor}{\rule{.3cm}{.3cm}}\hspace{.7cm}}}}

\titlespacing*{\section}{90pt}{11.4pt}{20pt}

\def\@lefthead{}
\def\@centerhead{}
\def\@righthead{}

\newpagestyle{main}{
    \setfoot{}{$\nicefrac{\thepage}{\pageref{LastPage}}$}{}
    \headrule
    \sethead{\@lefthead}{\@centerhead}{\@righthead}
}

\newcounter{@fullscore}
\setcounter{@fullscore}{100}

\newcounter{@restid}
\setcounter{@restid}{1}

\newcounter{@currscore}
\setcounter{@currscore}{0}

\define@key{subtasks}{translate points}{\tlpoints{#1}}
\define@key{subtasks}{translate constraints}{\tlconstraints{#1}}
\define@key{subtasks}{full score}{\setcounter{@fullscore}{#1}}

\newenvironment{subtasks}[1][]{
    \setkeys{subtasks}{#1}

    \begin{NiceTabular}{ccl}
        \CodeBefore\rowcolor{maincolor!20}{1}\rowcolors{2}{maincolor!5}{}\Body
        \toprule[0pt]
        \textbf{\#} & \textbf{\@tlpoints} & \textbf{\@tlconstraints}
}{
    \\ \bottomrule[0pt]
    \end{NiceTabular}
    \ifnum\the\value{@currscore}=\the\value{@fullscore}\relax{}\else
        {\color{red}Suma punctajelor nu e \the@fullscore{}, ci \the@currscore!}
    \fi
}

\newcommand{\task}[2]{
    \\ \midrule[0pt] \the@restid & {#1} & \makecell[l]{#2}
    \stepcounter{@restid}
    \IfInteger{#1}{\addtocounter{@currscore}{#1}}{}
}

\begin{luacode*}
function tern(t, a, b)
    if t then
        return a
    else
        return b
    end
end

function trim(s)
    return s:gsub("^%s*", ""):gsub("%s*$", "")
end

function escapeLine(line)
    return line
        :gsub("\\", "\\textbackslash")
        :gsub("{", "\\{")
        :gsub("}", "\\}")
        :gsub("%$", "\\$")
        :gsub("%%", "\\%%")
        :gsub("&", "\\&")
        :gsub("#", "\\#")
        :gsub("%^", "\\^")
        :gsub("_", "\\_")
end

function resetState()
    inputParity = {0}
    outputParity = {0}
    inputWidth = nil
    outputWidth = nil
    lineTable = {}
    hasDesc = false
    explWidth = "6cm"
end

function getColor(currParity)
    currParity[1] = currParity[1] + 1

    return tern(
        math.fmod(currParity[1], 2) == 0,
        "\\cellcolor{maincolor!5}",
        "")
end

function formatRow(hline, col1, col2, col3)
    return "\\\\"
        .. tern(hline, "\\hline{}", "")
        .. "\\obeyspaces\\ttfamily{}"
        .. tern(col1 ~= nil, col1, getColor(inputParity))
        .. " & \\obeyspaces\\ttfamily{}"
        .. tern(col2 ~= nil, col2, getColor(inputParity))
        .. tern(hasDesc, " & " .. col3, "")
end

function splitLinesToArray(linesIt, width, currParity)
    local arr = {}
    for line in linesIt do
        local i = 1
        local theColor = getColor(currParity)
        while i <= #line
        do
            local delta = width - tern(i > 1, 3, 0)
            table.insert(arr,
                theColor
                .. tern(i > 1, "\\textcolor{gray}{\\ding{213}} ", "")
                .. escapeLine(
                    trim(string.sub(line, i, math.min(#line, i + delta - 1)))))
            i = i + delta
        end
    end
    return arr
end

function processBuffers(inIt, outIt, minH, descriere)
    local input = splitLinesToArray(inIt, inputWidth, inputParity)
    local output = splitLinesToArray(outIt, outputWidth, outputParity)

    for i = 1, math.max(math.max(#input, #output), minH) do
        tex.print(formatRow(i == 1, input[i], output[i],
            tern(i == 1,
                "\\Block{"
                    .. tostring(math.max(math.max(#input, #output), minH))
                    .. "-1}<\\footnotesize>{\\parbox{"
                    .. explWidth
                    .. "}{"
                    .. descriere
                    .. "}}",
                "")))
    end
end

function processFile(file, minH, descriere)
    file = (status.output_directory or ".") .. "/" .. file
    if trim(descriere) ~= "" then
        hasDesc = true
    end

    table.insert(lineTable, {
        io.lines(file .. ".in"),
        io.lines(file .. ".out"),
        minH,
        descriere})
end

function splitIntoLines(s)
    return s:gsub("\\obeyedline%s*", "\r"):gmatch("[^\r]+")
end

function processValue(input, output, minH, descriere)
    if trim(descriere) ~= "" then
        hasDesc = true
    end

    table.insert(lineTable, {
        splitIntoLines(input),
        splitIntoLines(output),
        minH,
        descriere})
end

function printTable()
    if hasDesc then
        if inputWidth == nil then
            inputWidth = 20
        end
        if outputWidth == nil then
            outputWidth = 20
        end
        tex.print("\\begin{NiceTabular}[t]{l|l|w{l}{" .. explWidth .. "}}")
        tex.print("\\CodeBefore\\rowcolor{maincolor!20}{1}\\Body")
        tex.print("\\textbf{"
            .. tlInputData ..
            "} & \\textbf{"
            .. tlOutputData ..
            "} & \\textbf{"
            .. tlExplanation ..
            "}")
    else
        if inputWidth == nil then
            inputWidth = 35
        end
        if outputWidth == nil then
            outputWidth = 35
        end
        tex.print("\\begin{NiceTabular}{l|l}")
        tex.print("\\CodeBefore\\rowcolor{maincolor!20}{1}\\Body")
        tex.print("\\textbf{"
            .. tlInputData ..
            "} & \\textbf{"
            .. tlOutputData ..
            "}")
    end

    for i = 1, #lineTable do
        processBuffers(
            lineTable[i][1],
            lineTable[i][2],
            lineTable[i][3],
            lineTable[i][4])
    end

    tex.print(tableText)
    tex.print("\\\\")
    tex.print("\\end{NiceTabular}")
end
\end{luacode*}

\define@key{examples}{translate input data}{\tlinputdata{#1}}
\define@key{examples}{translate output data}{\tloutputdata{#1}}
\define@key{examples}{translate explanation}{\tlexplanation{#1}}

\define@key{examples}{input width}{
    \directlua{inputWidth=#1}
}
\define@key{examples}{output width}{
    \directlua{outputWidth=#1}
}
\define@key{examples}{explanation width}{
    \def\@explwidth{#1}
    \directlua{explWidth="\luaescapestring{#1}"}
}

\newlength{\@rowheight}
\newlength{\@textheight}

\newenvironment{examples}[1][]{
    \def\@explwidth{5cm}

    \directlua{resetState()}

    \setkeys{examples}{#1}

    \DeclareDocumentCommand\@calcHeight{m}{
        \settoheight\@rowheight{
            \begin{tabular}{l}\texttt{a}\end{tabular}
        }
        \settoheight\@textheight{
            \begin{tabular}{p{\@explwidth}}
                {\footnotesize{}##1}
            \end{tabular}
        }
        \def\@minh{\fpeval{round(\@textheight/\@rowheight+0.5)}}
    }
    
    \DeclareDocumentCommand\fromfile{mO{}}{
        \@calcHeight{##2}

        \directlua{
            processFile(
                "\luaescapestring{##1}",
                \@minh,
                "\luaescapestring{##2}")
        }
    }

    \DeclareDocumentCommand\fromtext{+v+vO{}}{
        \@calcHeight{##3}

        \directlua{
            processValue(
                "\luaescapestring{##1}",
                "\luaescapestring{##2}",
                \@minh,
                "\luaescapestring{##3}")
        }
    }
}{
    \begin{trivlist}
    \item
    \directlua{printTable()}
    \end{trivlist}
}

\newenvironment{interaction}{
\begin{NiceTabular}[t]{l|l|l}
\CodeBefore
  \rowcolors{2}{maincolor!5}{white}
\Body
  \rowcolor{maincolor!20}
    \textbf{Action} & \textbf{Response} & \textbf{Explanation} \\
}{
\end{NiceTabular}
}

\newcommand\action[2]{
\hline {#1} & & {#2} \\
}

\newcommand\response[2]{
\hline & {#1} & {#2} \\
}

\DeclareDocumentCommand\maketitle{o}{
    \IfNoValueF{#1}{\tlproblem{#1}}
    \centerline{\huge\textbf{\textsc{\textls{\@tlproblem{} \@title}}}}
        \vspace{7pt}
}

\newcommand\lefthead[1]{\def\@lefthead{#1}}
\newcommand\centerhead[1]{\def\@centerhead{#1}}
\newcommand\righthead[1]{\def\@righthead{#1}}

\newcommand\leftlogo[1]{\def\@lefthead{\includegraphics[height=40pt]{#1}}}
\newcommand\centerlogo[1]{\def\@centerhead{\includegraphics[height=40pt]{#1}}}
\newcommand\rightlogo[1]{\def\@righthead{\includegraphics[height=40pt]{#1}}}

\npthousandsep{\,}
\newcommand\np{\numprint}
\newcommand{\filename}[1]{\texttt{#1}}
\newcommand\alert[1]{{\color{maincolor}#1}}

\newlist{@constraints}{itemize*}{1}
\setlist[@constraints]{
    label={\textcolor{maincolor}{\ding{117}}}\phantom{a},
    itemjoin={\\}
}

\newenvironment{constraints}{
\begin{@constraints}
}{
\end{@constraints}
}
\pagestyle{main}
\lstset{
    basicstyle=\footnotesize\tt,
    frame=single,
    language=c++,
    keywordstyle={\color{maincolor}}
}
