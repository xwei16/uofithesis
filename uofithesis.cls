\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uofithesis}[2026/02/23 v1.0 University of Illinois Graduate College Dissertation/Thesis Class]

\LoadClass[letterpaper,12pt,oneside]{article}

\RequirePackage[english]{babel}
\RequirePackage{geometry}
\RequirePackage{setspace}
% sectsty is partially compatible with tagging, don't use \sectionrule
\RequirePackage{sectsty}
\RequirePackage{float}
\RequirePackage{fontsetup}

% pgfplots configuration for accessible color schemes
\RequirePackage{etoolbox}
\AtEndPreamble{
    \@ifpackageloaded{pgfplots}{
        \usepgfplotslibrary{colorbrewer}
        % Qualitative color scheme from https://colorbrewer2.org/
        % Color-blind friendly, adjusted for WCAG AA contrast
        \definecolor{aa-teal}{HTML}{168362}
        \definecolor{aa-orange}{HTML}{C05402}
        \definecolor{aa-blue}{HTML}{716CB2}
        \definecolor{aa-pink}{HTML}{e7298a}

        \pgfplotscreateplotcyclelist{StrictAA}{
            {aa-teal, fill=aa-teal, draw=black},
            {aa-orange, fill=aa-orange, draw=black},
            {aa-blue, fill=aa-blue, draw=black},
            {aa-pink, fill=aa-pink, draw=black}
        }
    }{}
}

% Styles

\newgeometry{margin=1in}
\allsectionsfont{\normalfont\bfseries\fontsize{12pt}{14.4pt}\selectfont\centering}
\AddToHook{cmd/section/before}{\clearpage}

% Options for the title page
\newcommand{\department}[1]{\def\@department{#1}}
\newcommand{\concentration}[1]{\def\@concentration{#1}}
\newcommand{\minor}[1]{\def\@minor{#1}}
\newcommand{\degreeyear}[1]{\def\@degreeyear{#1}}
\newcommand{\committee}[1]{\def\@committee{#1}}
\newcommand{\earneddegree}[1]{\def\@earneddegree{#1}}
\newcommand{\committeetitle}[1]{\def\@committeetitle{#1}}

% Copyright page option
\newif\if@copyrightpage
\@copyrightpagefalse % Default to no copyright page
\newcommand{\copyrightpage}{\@copyrightpagetrue}

\newif\ifdissertation
\dissertationtrue % Default to dissertation
\DeclareOption{thesis}{\dissertationfalse}
\ProcessOptions\relax

\def\@degreetext{Submitted in partial fulfillment of the requirements\\for the degree of}
\def\@degreelevel{}

% Make the title according to Graduate College formatting requirements
\renewcommand{\maketitle}{%
    \if@copyrightpage
    \begin{titlepage}
        \vspace*{\fill}
        \begin{center}
            \textcopyright\ \@degreeyear\ \@author
        \end{center}
        \vspace*{\fill}
    \end{titlepage}
    \fi
    \begin{titlepage}
        \newgeometry{margin=1in,vmargin={1.3in,1in}}
        \linespread{1.2}
        \begin{center}%
            \vbox to 3.5in{%
                \tagstructbegin{tag=Title}
                \tagmcbegin{tag=Title}
                % Disable automatic tagging, otherwise a P gets inserted inside the Title
                \tagpdfsetup{para/tagging=false}

                {\fontsize{12pt}{14.4pt}\selectfont \bfseries \@title}

                \tagpdfsetup{para/tagging=true}
                \tagmcend
                \tagstructend

                \vskip 12pt

                by \par

                \vskip 12pt

                {\@author \par}
                \vfill
            }

            % Set defaults based on dissertation vs thesis
            \ifdissertation
            \ifdefined\@department
            \gdef\@degreelevel{ Doctor of Philosophy in \@department}
            \fi
            \gdef\@thesislabel{Dissertation}
            \gdef\@defaultcommitteetitle{Doctoral Committee:}
            \else
            \ifdefined\@department
            \gdef\@degreelevel{ Master of Science in \@department}
            \fi
            \gdef\@thesislabel{Thesis}
            \gdef\@defaultcommitteetitle{Master's Committee:}
            \fi

            % Use custom earned degree if set, otherwise use default
            \ifdefined\@earneddegree
            \gdef\@degreelevel{ \@earneddegree}
            \fi

            % Use custom committee title if set, otherwise use default
            \ifdefined\@committeetitle\else
            \gdef\@committeetitle{\@defaultcommitteetitle}
            \fi

            {\@thesislabel\par}
            \vspace{12pt}
            \@degreetext
            \@degreelevel\\
            \ifdefined\@concentration
            with a concentration in \@concentration\\
            \fi
            \ifdefined\@minor
            with a minor in \@minor\\
            \fi
            in the Graduate College of the\\
            University of Illinois Urbana-Champaign, \@degreeyear\par
            \vspace{12pt}
            \vbox to 0.4in{%
                {Urbana, Illinois\par}
                \vfill
            }%
        \end{center}%
        \begin{flushleft}
            {\@committeetitle\par}

            \begin{itemize}[label={}, left-margin=0.5in]
                    \setlength{\itemsep}{0pt}
                    \setlength{\parskip}{0pt}
                    \setlength{\parsep}{0pt}
                    \@committee
            \end{itemize}
        \end{flushleft}
        \par
        \restoregeometry
    \end{titlepage}
}

% Abstract environment
\renewenvironment{abstract}{%
    \thispagestyle{plain}
    \section*{Abstract}
    \vspace{12pt}
    \doublespacing
}{%
}

% Acknowledgements environment
\newenvironment{acknowledgements}{%
    \thispagestyle{plain}
    \section*{Acknowledgements}
    \vspace{12pt}
    \doublespacing
}{%
}

% Adjust ToC line height
% tableofcontents adds its own spacing on top of line height, hence the 12pt line height
\let\thesis@tableofcontents=\tableofcontents
\def\tableofcontents{{\fontsize{12pt}{12pt}\selectfont\thesis@tableofcontents}}

\renewcommand{\thesection}{Chapter \arabic{section}}
\renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}}
\renewcommand*{\l@section}{\@dottedtocline{1}{1.5em}{5em}}
\renewcommand*{\l@subsection}{\@dottedtocline{2}{3em}{2.5em}}
