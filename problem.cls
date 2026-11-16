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

\ProvidesClass{problem}[2026/11/18 LaTeX class for informatics olympiads problems]

%%% Options

\newif\if@en
\DeclareOption{en}{\@entrue}
\DeclareOption{ro}{\@enfalse}

\newif\if@olympiad
\DeclareOption{olympiadstyle}{\@olympiadtrue}
\ProcessOptions

\if@en
    \PassOptionsToPackage{english}{babel}
\else
    \PassOptionsToPackage{romanian}{babel}
\fi

%%% Packages

\LoadClass[11pt,a4paper,oneside]{article}
\RequirePackage{geometry}
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
\RequirePackage{nicefrac}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{lastpage}
\RequirePackage[bottomtitles,calcwidth,pagestyles]{titlesec}
\RequirePackage[letterspace=112]{letterspace}
\RequirePackage[inline]{enumitem}
\RequirePackage{babel}
\RequirePackage{listings}
\RequirePackage{fvextra}
\RequirePackage{tikz}
\usetikzlibrary{arrows.meta}

%%% Geometry and basic setup

\geometry{a4paper, width=147mm, height=252mm, top=80pt, headheight=45pt, headsep=20pt, footskip=30pt}

\setlength\parskip{8pt}
\setlength\parindent{0pt}
\setmonofont{IBM Plex Mono}[Scale=MatchLowercase]
\definecolor{maincolor}{Hsb}{200, 0.9, 0.40}

%%% Translation

\newcommand\@newtl[3]{%
    \expandafter\newcommand\csname tl#1\endcsname[1]{\expandafter\def\csname @tl#1\endcsname{##1}}
    \expandafter\def\csname @tl#1\endcsname{\if@en #2\else #3\fi}
}

\@newtl{points}     {Points}     {Punctaj}
\@newtl{constraints}{Constraints}{Restricții}
\@newtl{inputdata}  {Input data} {Date de intrare}
\@newtl{outputdata} {Output data}{Date de ieșire}
\@newtl{explanation}{Explanation}{Explicații}
\@newtl{problem}    {Problem}    {Problema}
\@newtl{action}     {Action}     {Acțiune}
\@newtl{response}   {Response}   {Răspuns}


%%% Sectioning

\renewcommand\maketitle{
    { \centering \huge\textbf{\textsc{\textls{\@tlproblem{} \@title}}} \par} \vspace{7pt}
}

\titleformat{\section}[wrap]
    {\normalfont\fontseries{b}\fontshape{sc}\selectfont\large\filcenter}
    {\normalfont\mdseries\upshape}
    {0pt}
    {\hspace{-1cm}\lsstyle{{\textcolor{maincolor}{\rule{.3cm}{.3cm}}\hspace{.7cm}}}}
\titlespacing*{\section}{90pt}{11.4pt}{20pt}

%%% Page style

\def\@lefthead{}
\def\@centerhead{}
\def\@righthead{}

\newcommand\lefthead[1]{\def\@lefthead{#1}}
\newcommand\centerhead[1]{\def\@centerhead{#1}}
\newcommand\righthead[1]{\def\@righthead{#1}}

\newcommand\leftlogo[1]{\def\@lefthead{\includegraphics[height=40pt]{#1}}}
\newcommand\centerlogo[1]{\def\@centerhead{\includegraphics[height=40pt]{#1}}}
\newcommand\rightlogo[1]{\def\@righthead{\includegraphics[height=40pt]{#1}}}

\newpagestyle{main}{
    \setfoot{}{$\nicefrac{\thepage}{\pageref{LastPage}}$}{}
    \headrule
    \sethead{\@lefthead}{\@centerhead}{\@righthead}
}
\pagestyle{main}

%%% Constraints and subtasks

\newcommand\@constraintslabel{\textcolor{maincolor}{\ding{117}}}

\newlist{constraints}{itemize*}{1}
\setlist[constraints]{
    label={\@constraintslabel}\phantom{a},
    itemjoin={\\}
}

\newcounter{@fullscore}
\setcounter{@fullscore}{100}
\newcounter{@currscore}

\define@key{subtasks}{translate points}{\tlpoints{#1}}
\define@key{subtasks}{translate constraints}{\tlconstraints{#1}}
\define@key{subtasks}{full score}{\setcounter{@fullscore}{#1}}

\newenvironment{subtasks}[1][]{
    \setkeys{subtasks}{#1}

    \begin{NiceTabular}{ccl}
        \CodeBefore\rowcolor{maincolor!20}{1}\rowcolors{2}{maincolor!5}{}\Body
        \toprule[0pt]
        \textbf{\#} & \textbf{\@tlpoints} & \textbf{\@tlconstraints} \\\midrule[0pt]
}{
    \bottomrule[0pt]
    \end{NiceTabular}
    \ifnum\value{@currscore}=\value{@fullscore}\relax\else
        {\color{red}Point score is not \the@fullscore{}, but \the@currscore!}
    \fi
}

\newcounter{@taskid}

\newcommand{\task}[2]{
    \stepcounter{@taskid}
    \IfInteger{#1}{\addtocounter{@currscore}{#1}}{}
    \the@taskid & {#1} & \makecell[l]{#2} \\
}

%%% Example table
% Design here is a little bit complicated, but not that bad. We have "plumbing" commands first,
% which literally typeset the table. We have a lua intermediate layer that takes the input, saves
% into temporary files, does some preprocessing. Then we have a porcelain layer hiding the
% complexity from the user.

\newlength{\@padlen}
\settowidth{\@padlen}{\texttt{x}}
\newcommand{\@header}[1]{\hspace{\@padlen}\textbf{#1}\hspace{\@padlen}}

\newlength{\@inwidth}
\newlength{\@outwidth}
\newlength{\@explwidth}
\newlength{\@inputheadwidth}
\newlength{\@outputheadwidth}

\newcommand{\@contmarker}{%
    \tikz[baseline=-0.6ex, gray, line width=0.45pt]{%
        \draw[-{Computer Modern Rightarrow[length=1.2pt]}] (0,0) -- (0.45em,0);%
    }%
}

\fvset{formatcom=\ttfamily,
    breaklines,
    breakanywhere,
    breakanywheresymbolpre={},
    breaksymbolleft=\@contmarker,
    breaksymbolindentleftnchars=2,
    breaksymbolsepleft=\@padlen,
    breakautoindent=false,
    breaksymbolright=\hspace{0pt},
    breaksymbolindentrightnchars=1,
    breaksymbolsepright=0pt,
    highlightlines={2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,
        32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,
        68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100},
    highlightcolor=maincolor!5}

\newif\if@hasDesc

\newenvironment{@examples}{%
    \setlength{\tabcolsep}{0pt}%
    \if@hasDesc%
        \begin{NiceTabular}[t]{@{}l|l|p{@explwidth}@{}}%
        \CodeBefore\rowcolor{maincolor!20}{1}\Body%
        \@header{\@tlinputdata} & \@header{\@tloutputdata} & \@header{\@tlexplanation} \\%
    \else%
        \begin{NiceTabular}{@{}l|l@{}}%
        \CodeBefore\rowcolor{maincolor!20}{1}\Body%
        \@header{\@tlinputdata} & \@header{\@tloutputdata} \\%
    \fi%
}{
    \end{NiceTabular}
}

\newcommand\@exmprow[5]{%
    \hline%
    \if@hasDesc
        \begin{minipage}[t]{#1}\VerbatimInput{#2}\end{minipage} & \begin{minipage}[t]{#3}\VerbatimInput{#4}\end{minipage}
        & \parbox[t]{\@explwidth}{\footnotesize\leftskip\@padlen\rightskip\@padlen{}#5\par\vskip\@padlen} \\
    \else
        \begin{minipage}[t]{#1}\VerbatimInput{#2}\end{minipage} & \begin{minipage}[t]{#3}\VerbatimInput{#4}\end{minipage} \\
    \fi
}

\begin{luacode*}
local examples = {}
local columnChars = {0, 0}

local function examplePath(n, j)
    return (status.output_directory or ".") .. "/" .. tex.jobname .. "-" .. j .. "-" .. n .. ".tmp"
end

function addExample(data, desc)
    local paths = {}
    for j = 1, 2 do
        paths[j] = examplePath(#examples, j)
        local f = assert(io.open(paths[j], "w"))
        --- Forall lines, after removing leading/trailing whitespace
        for line in (data[j]:gsub("^%s+", ""):gsub("%s+$", "") .. "\n"):gmatch("(.-)\r?\n") do
            if #line > columnChars[j] then columnChars[j] = #line end
            f:write(" ", line, "\n")
        end
        f:close()
    end

    if desc ~= nil and desc ~= "" then tex.print("\\@hasDesctrue") end

    table.insert(examples, { paths = paths, desc = desc })
end

function deleteExampleFiles()
    for i = 0, #examples do
        for j = 1, 2 do
            os.remove(examplePath(i, j))
        end
    end
end

function printExampleTable()
    local function sp(name) return tex.skip[name].width end

    local capNames = {"@inwidth", "@outwidth"}
    local headerNames = {"@inputheadwidth", "@outputheadwidth"}

    local function columnWidth(j)
        local padLen = sp("@padlen")
        return math.max(sp(headerNames[j]), math.min(sp(capNames[j]), (columnChars[j] + 2) * padLen))
    end

    tex.print("\\begin{@examples}")

    for i = 1, #examples do
        tex.print("\\@exmprow{"
            .. columnWidth(1) .. "sp}{" .. examples[i].paths[1] .. "}{" 
            .. columnWidth(2) .. "sp}{" .. examples[i].paths[2] .. "}{" 
            .. examples[i].desc .. "}")
    end

    tex.print("\\end{@examples}")
    tex.print("\\directlua{deleteExampleFiles()}")
    tex.print("\\@hasDescfalse")

    examples = {}
    columnChars = {0, 0}
end
\end{luacode*}

\DeclareDocumentCommand\fromfile{O{}m}{
    \directlua{
        local base = (status.output_directory or ".") .. "/" .. "\luaescapestring{#2}"
        addExample({
            assert(io.loaddata(base .. ".in")),
            assert(io.loaddata(base .. ".out"))
        }, "\luaescapestring{\unexpanded{#1}}")
    }
}

\DeclareDocumentCommand\fromtext{O{}+v+v}{
    % Marker and newline are for getting around catcode troubles.
    \directlua{
        local marker = string.char(92) .. "obeyedline" .. string.char(37) .. "s*"
        local newline = string.char(10)
        addExample({
            (("\luaescapestring{#2}"):gsub(marker, newline)),
            (("\luaescapestring{#3}"):gsub(marker, newline))
        }, "\luaescapestring{\unexpanded{#1}}")
    }
}

\define@key{examples}{translate input data}{\tlinputdata{#1}}
\define@key{examples}{translate output data}{\tloutputdata{#1}}
\define@key{examples}{translate explanation}{\tlexplanation{#1}}
\define@key{examples}{input width}{\setlength{\@inwidth}{#1}}
\define@key{examples}{output width}{\setlength{\@outwidth}{#1}}
\define@key{examples}{explanation width}{\setlength{\@explwidth}{#1}}

\newenvironment{examples}[1][]{
    \makeatletter
    \setlength{\@inwidth}{7cm}%
    \setlength{\@outwidth}{5cm}%
    \setlength{\@explwidth}{5cm}%

    \setkeys{examples}{#1}

    \settowidth{\@inputheadwidth}{\@header{\@tlinputdata}}%
    \settowidth{\@outputheadwidth}{\@header{\@tloutputdata}}%
}{
    \begin{trivlist}
    \item
    \directlua{printExampleTable()}
    \end{trivlist}
    \makeatother
}

%%% Interaction tables (much simpler than example tables)

\newenvironment{interaction}{
\begin{NiceTabular}[t]{l|l|l}
\CodeBefore
    \rowcolors{2}{maincolor!5}{}
\Body
    \rowcolor{maincolor!20}
    \textbf{\@tlaction} & \textbf{\@tlresponse} & \textbf{\@tlexplanation} \\
}{
\end{NiceTabular}
}

\newcommand\action[2]{\hline {#1} & & {#2} \\}

\newcommand\response[2]{\hline & {#1} & {#2} \\}

%%% Listings

\lstset{
    basicstyle=\footnotesize\tt,
    frame=single,
    language=c++,
    keywordstyle={\color{maincolor}}
}

%%% Convenience commands

\npthousandsep{\,}
\newcommand\np{\numprint}
\newcommand{\filename}[1]{\texttt{#1}}
\newcommand\alert[1]{{\color{maincolor}#1}}

%%% Unified settings for olympiad style

\if@olympiad
    \geometry{width=159.6mm, height=261mm, top=64pt}
    \titleformat{\section}[block]
        {\normalfont\fontseries{b}\fontshape{sc}\selectfont\large}
        {\normalfont\mdseries\upshape}
        {0pt}
        {\lsstyle}
    \titlespacing*{\section}{0pt}{0.3\baselineskip}{0pt}
    \def\@constraintslabel{\textbullet}
    \fvset{highlightlines={}}
\fi
