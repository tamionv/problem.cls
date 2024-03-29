% BSD 3-Clause License
% 
% Copyright (c) 2021-2023, Tamio-Vesa Nakajima
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% 3. Neither the name of the copyright holder nor the names of its
%    contributors may be used to endorse or promote products derived from
%    this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% Originally derived from https://github.com/GassaFM/olymp.sty; the relevant license follows:

%Copyright (c) 2005-2013 Olymp.sty Developers Group. See https://github.com/GassaFM/olymp.sty/blob/master/AUTHORS for the complete list of authors.

% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{problem}[2023/12/09 Problem statement for Romanian olympiads]
\LoadClass[11pt,a4paper,oneside]{article}

% Declaring options

\DeclareOption{comicsans}{\def\opt@comicsans{}}

\DeclareOption{otherlogo}{\def\opt@otherlogo{}}

\DeclareOption{en}{
    \def\opt@en{}
    \PassOptionsToPackage{english}{babel}
}

\DeclareOption{ro}{
    \def\opt@ro{}
    \PassOptionsToPackage{english, romanian}{babel}
}

\DeclareOption{bg}{
    \def\opt@bg{}
    \PassOptionsToPackage{T2A}{fontenc}
    \PassOptionsToPackage{english, bulgarian}{babel}
}

\DeclareOption{it}{
    \def\opt@it{}
    \PassOptionsToPackage{english, italian}{babel}
}

\DeclareOption{hu}{
    \def\opt@hu{}
    \PassOptionsToPackage{T1}{fontenc}
    \PassOptionsToPackage{english, hungarian}{babel}
}

\DeclareOption{uk}{
    \def\opt@uk{}
    \PassOptionsToPackage{T2A}{fontenc}
    \PassOptionsToPackage{english, ukrainian}{babel}
}

\DeclareOption{files}{\def\opt@files{}}

\DeclareOption{header}{\def\opt@header{}}

\DeclareOption{listRestrictions}{\def\opt@listRestrictions{}}

\ProcessOptions*

% Packages

\RequirePackage{fancyhdr}
\RequirePackage{xcolor}
\RequirePackage{etoolbox}
\RequirePackage{fontenc}
\RequirePackage{babel}
\RequirePackage{microtype}
\RequirePackage{titlesec}
\RequirePackage{graphicx}
\RequirePackage{makecell}
\RequirePackage{datatool-base}
\RequirePackage{mfirstuc}
\RequirePackage{amsmath}
\RequirePackage[ebgaramond]{newtx}
\RequirePackage{fontspec}
\RequirePackage{listings}
\RequirePackage{color}
\RequirePackage{tabularx}
\RequirePackage{booktabs}
\RequirePackage{enumitem}
\RequirePackage{bm}
\RequirePackage{datetime}
\RequirePackage{numprint}
\RequirePackage{enumitem}
\RequirePackage{yfonts}
\RequirePackage{lastpage}
\RequirePackage{calc}

% Keywords

\ifdefined\opt@comicsans\setmainfont{Comic Sans MS}\fi

\newcommand\@problem{}
\newcommand\@inputfile{}
\newcommand\@outputfile{}
\newcommand\@headerc{}
\newcommand\@headercpp{}
\newcommand\@examples{}
\newcommand\@explanations{}
\newcommand\@points{}
\newcommand\@restrictions{}
\newcommand\@subtask{}

\newcommand\tlproblem[1]{\renewcommand\@problem{#1}}
\newcommand\tlinputfile[1]{\renewcommand\@inputfile{#1}}
\newcommand\tloutputfile[1]{\renewcommand\@outputfile{#1}}
\newcommand\tlheaderc[1]{\renewcommand\@headerc{#1}}
\newcommand\tlheadercpp[1]{\renewcommand\@headercpp{#1}}
\newcommand\tlexamples[1]{\renewcommand\@examples{#1}}
\newcommand\tlexplanations[1]{\renewcommand\@explanations{#1}}
\newcommand\tlpoints[1]{\renewcommand\@points{#1}}
\newcommand\tlrestrictions[1]{\renewcommand\@restrictions{#1}}
\newcommand\tlsubtask[1]{\renewcommand\@subtask{#1}}

% Translation 

\ifdefined\opt@en
    \tlproblem{Problem}
    \tlinputfile{Input file}
    \tloutputfile{Output file}
    \tlheaderc{C header}
    \tlheadercpp{C++ header}
    \tlexamples{Examples}
    \tlexplanations{Explanations}
    \tlpoints{Points}
    \tlrestrictions{Restrictions}
    \tlsubtask{Subtask}
\fi

\ifdefined\opt@ro
    \tlproblem{Problema}
    \tlinputfile{Fișier de intrare}
    \tloutputfile{Fișier de ieșire}
    \tlheaderc{Header C}
    \tlheadercpp{Header C++}
    \tlexamples{Exemple}
    \tlexplanations{Explicații}
    \tlpoints{Punctaj}
    \tlrestrictions{Restricții}
    \tlsubtask{Subtask}
\fi

\ifdefined\opt@bg
    \tlproblem{Задача}
    \tlinputfile{Вход}
    \tloutputfile{Изход}
    \tlheaderc{Header C}
    \tlheadercpp{Header C++}
    \tlexamples{Пример}
    \tlexplanations{Обяснение}
    \tlpoints{Точки}
    \tlrestrictions{Ограничения}
    \tlsubtask{Subtask}
\fi

\ifdefined\opt@it
    \tlproblem{Problema}
    \tlinputfile{File di input}
    \tloutputfile{File di output}
    \tlheaderc{Header C}
    \tlheadercpp{Header C++}
    \tlexamples{Esempi}
    \tlexplanations{Spiegazione}
    \tlpoints{Punti}
    \tlrestrictions{Assunzioni}
    \tlsubtask{Subtask}
\fi

\ifdefined\opt@hu
    \tlproblem{Feladat}
    \tlinputfile{Bemenet}
    \tloutputfile{Kimenet}
    \tlheaderc{Header C}
    \tlheadercpp{Header C++}
    \tlexamples{Példák}
    \tlexplanations{Magyarázat}
    \tlpoints{Pontszám}
    \tlrestrictions{Korlátok}
    \tlsubtask{Subtask}
\fi

\ifdefined\opt@uk
    \tlproblem{Problem}
    \tlinputfile{Input file}
    \tloutputfile{Output file}
    \tlheaderc{C header}
    \tlheadercpp{C++ header}
    \tlexamples{Examples}
    \tlexplanations{Explanations}
    \tlpoints{Points}
    \tlrestrictions{Restrictions}
    \tlsubtask{Subtask}
\fi

% Problem information

\newcommand\@contest{Olimpiada Locala de Informatica}
\newcommand\@round{Locală}
\newcommand\@class{IX}
\newcommand\@location{Beius}
\newcommand\@theday{13}
\newcommand\@themonth{10}
\newcommand\@theyear{1900}
\newcommand\@problemfile{aplusb}
\newcommand\@problemname{Aplusb}

\newcommand\round[1]{\def\@round{#1}}
\newcommand\class[1]{\def\@class{#1}}
\newcommand\contest[1]{\def\@contest{#1}}
\newcommand\location[1]{\def\@location{#1}}
\renewcommand\date[3]{
    \def\@theday{#1}%
    \def\@themonth{#2}%
    \def\@theyear{#3}%
}
\newcommand\logo[1]{\newcommand\@logo{#1}}
\newcommand\otherlogo[1]{\newcommand\@otherlogo{#1}}
\renewcommand\title[1]{
    \def\@problemname{#1}%
    \def\@problemfile{#1}%
}
\newcommand\filename[1]{\def\@problemfile{#1}}

% Convenience commands

\npthousandsep{\,}
\newcommand\np[1]{\numprint{#1}}

% Page setup

\setlength{\textwidth}{140mm}

\hoffset=-1in
\voffset=-1in
\headheight=17mm
\headsep=3mm

\setlength{\oddsidemargin}{(210mm-\textwidth)/2}
\setlength{\textheight}{1.618\textwidth}
\setlength{\topmargin}{(297mm-\textheight-\headsep-\headheight)/3}
\setlength{\footskip}{\topmargin}

\parskip=0.5em
\parindent=0mm
\setitemize{itemsep=0.1em-\parsep,topsep=0.2em-\parskip}
\setenumerate{itemsep=0.1em-\parsep,topsep=0.2em-\parskip}

\pagestyle{fancy}

\ifdefined\opt@otherlogo
\lhead{\ifdefined\@otherlogo\includegraphics[height=30pt]{\@otherlogo}\\\fi\@contest, \@location}
\rhead{\ifdefined\@logo\includegraphics[height=30pt]{\@logo}\\\fi\formatdate{\@theday}{\@themonth}{\@theyear}}
\else
\lhead{\@contest\\\@location\\\formatdate{\@theday}{\@themonth}{\@theyear}}
\rhead{\ifdefined\@logo\includegraphics[height=42pt]{\@logo}\fi}
\fi

\cfoot{\thepage/\pageref{LastPage}}
    
\lstset{
    basicstyle=\footnotesize\tt,
    escapeinside={\%*}{*)},
    extendedchars=true,
    frame=single,
    keepspaces=true,
    keywordstyle=\color{blue},
    language=c++,
    morekeywords={*,...},
    numbersep=5pt,
    numberstyle=\tiny\color{mygray},
    rulecolor=\color{black},
    showspaces=false,
    showstringspaces=false,
    showtabs=false,
    stepnumber=2,
    stringstyle=\color{red},
    tabsize=2,
    title=\lstname,
    aboveskip=-10pt
}

% Structural commands

\titleformat{\section}{\bfseries\large}{}{0pt}{}{}
\titlespacing{\section}{0pt}{3pt}{3pt}

\titleformat{\subsection}{\bfseries\large}{}{0pt}{}{}
\titlespacing{\subsection}{0pt}{2pt}{2pt}

\newenvironment{examples}{%
    \section{\@examples}%
    \ttfamily\obeylines\obeyspaces\frenchspacing%
    \begin{tabular}{|l|l|}%
    \hline%
    \multicolumn{1}{|c|}{ \bf\texttt{\xmakefirstuc{\@inputfile}}}&%
    \multicolumn{1}{|c|}{ \bf\texttt{\xmakefirstuc{\@outputfile}}}%
    \\%
    \hline%
}
{
    \end{tabular}%
}

\newenvironment{examplesexplained}{%
    \section{\@examples}%
    \ttfamily\obeylines\obeyspaces\frenchspacing%
    \begin{tabular}{|l|l|l|}%
    \hline%
    \multicolumn{1}{|c|}{\bf\texttt{\xmakefirstuc{\@inputfile}}}&%
    \multicolumn{1}{|c|}{\bf\texttt{\xmakefirstuc{\@outputfile}}}&%
    \multicolumn{1}{|c|}{\bf\texttt{\xmakefirstuc{\@explanations}}}%
    \\%
    \hline%
}
{
\end{tabular}%
}

\newcommand\exmp[2]{%
    \begin{minipage}[t]{0.46\textwidth}\rightskip=0pt plus 1fill\relax  #1 \medskip\end{minipage}&%%
    \begin{minipage}[t]{0.46\textwidth}\rightskip=0pt plus 1fill\relax #2 \medskip\end{minipage}%
    \\%%
    \hline%%
}

\newcommand\exmpexplained[3]{%
    \begin{minipage}[t]{0.25\textwidth}\rightskip=0pt plus 1fill\relax  #1 \medskip\end{minipage}&%
    \begin{minipage}[t]{0.25\textwidth}\rightskip=0pt plus 1fill\relax  #2 \medskip\end{minipage}&%
    \begin{minipage}[t]{0.43\textwidth}\rightskip=0pt plus 1fill\relax  #3 \medskip\end{minipage}\\%
    \hline%
}

\newcounter{@restrictionid}
\newenvironment{restrictions}[1][]{%
    \setcounter{@restrictionid}{0}%
    \section{\@restrictions}%
    \ifx#1\empty\else%
    \begin{itemize}[leftmargin=*,topsep=0pt]%
    #1%
    \end{itemize}%
    \fi%
    \begin{tabular}{c c l}%
    \toprule%
    \textbf{\#} & \textbf{\xmakefirstuc{\@points}} & \textbf{\xmakefirstuc{\@restrictions}}%
}
{%
    \\ \bottomrule%
    \end{tabular}%
}

\newcommand\restr[2]{%
    \stepcounter{@restrictionid}%
    \\ \midrule{}%
    \the@restrictionid{} & {#1} & {\makecell[l]{#2}}%
}

\ifdefined\opt@listRestrictions
    \renewenvironment{restrictions}{\setcounter{@restrictionid}{0}\section{\@restrictions}}{}

    \renewcommand\restr[2]{%
        \stepcounter{@restrictionid}%
        \subsection{\@subtask{} \the@restrictionid{} (#1)}%
        \begin{itemize}[leftmargin=*]%
        #2%
        \end{itemize}%
    }
\fi

\renewcommand\maketitle{%
    \textbf{\LARGE{\@problem{} \LARGE \xmakefirstuc{\@problemname}}}%
    \par{\vspace{3mm}}%
    \normalsize\parindent=6.5mm%
    \vbox{%
        \begin{tabular}{l@{\extracolsep{1cm}}l}%
         \@inputfile & \texttt{stdin} \\%
         \@outputfile & \texttt{stdout} \\%
        \end{tabular}%
    }%
    \par\vspace{2mm}%
    \normalsize\parindent=0mm%
}

\ifdefined\opt@files
    \renewcommand\maketitle{%
        \textbf{\LARGE{\@problem{} \LARGE \xmakefirstuc{\@problemname}}}%
        \par{\vspace{3mm}}%
        \normalsize\parindent=6.5mm%
        \vbox{%
            \begin{tabular}{l@{\extracolsep{1cm}}l}%
             \@inputfile & \texttt{\lowercase{\@problemfile{}}.in} \\%
             \@outputfile & \texttt{\lowercase{\@problemfile{}}.out} \\%
            \end{tabular}%
        }%
        \par\vspace{2mm}%
        \normalsize\parindent=0mm%
    }

    \renewenvironment{examples}{%
        \section{\@examples}%
        \ttfamily\obeylines\obeyspaces\frenchspacing%
        \begin{tabular}{|l|l|}%
        \hline%
        \multicolumn{1}{|c|}{\bf\texttt{\lowercase{\@problemfile{}}.in}}&%
        \multicolumn{1}{|c|}{\bf\texttt{\lowercase{\@problemfile{}}.out}}%
        \\%
        \hline%
    }
    {
        \end{tabular}%
    }

    \renewenvironment{examplesexplained}{%
        \section{\@examples}%
        \ttfamily\obeylines\obeyspaces\frenchspacing%
        \begin{tabular}{|l|l|l|}%
        \hline%
        \multicolumn{1}{|c|}{\bf\texttt{\lowercase{\@problemfile{}}.in}}&%
        \multicolumn{1}{|c|}{\bf\texttt{\lowercase{\@problemfile{}}.out}}&%
        \multicolumn{1}{|c|}{\bf\texttt{\xmakefirstuc{\@explanations}}}%
        \\%
        \hline%
    }
    {
    \end{tabular}%
    }
\fi

\ifdefined\opt@header
    \renewcommand\maketitle{%
        \textbf{\LARGE{\@problem{} \LARGE \xmakefirstuc{\@problemname}}}%
        \par{\vspace{3mm}}%
        \normalsize\parindent=6.5mm%
        \vbox{%
            \begin{tabular}{l@{\extracolsep{1cm}}l}%
             \@headercpp & \texttt{\lowercase{\@problemfile{}}.h} \\%
            \end{tabular}%
        }%
        \par\vspace{2mm}%
        \normalsize\parindent=0mm%
    }
\fi
