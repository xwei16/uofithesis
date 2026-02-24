# U of I Thesis Template

A LaTeX document class for University of Illinois Urbana-Champaign dissertations and theses, with special emphasis on accessibility and PDF/UA-2 compliance.

> [!IMPORTANT]
> This document class **is not compatible with the older `uiucthesis2021`** package,
> so it cannot be used as a direct replacement in an existing document.

> [!IMPORTANT]
> LaTeX PDF accessibility is constantly evolving, so this template is a work in progress.
> If you want to update the template, the [changelog](./CHANGELOG.md) will list all
> necessary changes to your document.

## Using This Template

We recommend cloning the repository to get started:

```bash
git clone https://github.com/graduatecollege/uofithesis.git
```

Or you can download the code as a ZIP file from the GitHub page.

> [!NOTE]
> Because accessible PDF generation is so new to the LaTeX ecosystem,
> downloading the template for your use is the most effective way
> to ensure you can customize and build your document without issues. We
> don't have plans to publish this class on CTAN until the tagging system 
> is more mature and stable.

## Requirements

This template requires **TeX Live 2025** or later and must be compiled with **LuaLaTeX**.

### Installing TeX Live 2025

For complete instructions refer to the [TeX Live website](https://www.tug.org/texlive/).
Here are the basic steps for each platform:

#### Windows

Download and run the installer from https://www.tug.org/texlive/windows.html

#### macOS

```bash
# Install MacTeX (includes TeX Live 2025)
# Download from https://www.tug.org/mactex/
# Or use Homebrew:
brew install --cask mactex
```

#### Linux

```bash
# Download the installer
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz
cd install-tl-*

# Run the installer. Can take a long time.
sudo perl install-tl

# Add to PATH (add to ~/.bashrc or ~/.zshrc for persistence)
export PATH=/usr/local/texlive/2025/bin/x86_64-linux:$PATH
export MANPATH=/usr/local/texlive/2025/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2025/texmf-dist/doc/info:$INFOPATH
```

## Building Your Document

### Using latexmk (Recommended)

This repository includes a [`.latexmkrc`](./.latexmkrc) that's set up to use
the correct tools. You can build with:

```bash
latexmk thesis.tex
```

Clean build artifacts:

```bash
latexmk -c thesis.tex
```

### Without latexmk

Multiple tool runs are necessary to create all intermediate files and the bibliography:

```bash
lualatex thesis.tex
biber thesis
lualatex thesis.tex
lualatex thesis.tex
```

## Document Structure

[`thesis.tex`](./thesis.tex) is a sample for how to use the `uofithesis` class,
and includes comments and examples for all major features.

Not all elements are required, so remove any sections that don't apply to your document.
Optional parts include:

- Copyright Page
- Acknowledgements
- Appendix or Appendices

### Thesis vs Dissertation

By default, the class produces a dissertation. For a master's thesis:

```latex
\documentclass[thesis]{uofithesis}
```

## Package Groups and Accessibility

> [!WARNING]
> Always consult the [Tagging Status of LaTeX Packages](https://latex3.github.io/tagging-project/tagging-status/)
> before including a package in your document. If possible, choose a fully compatible package.

### Core Document Setup

The template uses packages that are, at time of writing, the best available for an accessible PDF output.

The [LaTeX Tagging Project](https://latex3.github.io/tagging-project/) is the foundation for an accessible PDF structure. It uses a `\DocumentMetadata` command to configure PDF/UA-2 tagging and accessibility features.

The Tagging Project is still under active development, and some features may be added or changed in future releases of TeX Live. The template is designed to be compatible with the latest stable release, but may require updates as the tagging system evolves.

### Mathematics (`unicode-math`)

**Required for accessible mathematics.** This package enables:
- MathML generation for screen reader compatibility
- Unicode math symbols for proper character encoding
- Modern OpenType math fonts

All equations should be wrapped in appropriate tags:

```latex
\tagstructbegin{tag=Part}
\begin{equation}\label{eq:example}
    E = mc^2
\end{equation}
\tagstructend
```

At this time, all [float environments must be wrapped in `Part`](#wrap-floats-in-part-tags) tags to ensure they are read in the correct order by screen readers.

### Graphics and Visualization

#### Core Graphics Packages

- **graphicx**: Standard image inclusion with alt-text support
- **tikz**: Programmatic diagrams with alt-text capability
- **pgfplots**: Data visualization with accessible color schemes

Note that `pgfplots` is not properly tagged and relies on alt text for accessibility.

Read [Alternative Text for Images](https://digitalaccessibility.illinois.edu/getting-started/accessibility-fundamentals/alternative-text-images) for best practices on writing alt text.

#### Accessible Color Schemes

The template defines WCAG AA compliant colors for charts:

```latex
\definecolor{aa-teal}{HTML}{168362}
\definecolor{aa-orange}{HTML}{C05402}
\definecolor{aa-blue}{HTML}{716CB2}
\definecolor{aa-pink}{HTML}{e7298a}
```

Use with pgfplots:

```
cycle list name=StrictAA,
```

#### Providing Alt Text

**All graphics must include alt text for accessibility:**

```latex
% For images
\tagstructbegin{tag=Part}
\begin{figure}[H]
    \centering
    \includegraphics[width=0.6\textwidth,alt={Alt text}]{image.png}
    \caption{Image caption}
    \label{fig:image_label}
\end{figure}
\tagstructend

% For TikZ diagrams and pgfplots
\tagstructbegin{tag=Part}
    \begin{figure}[H]
        \begin{tikzpicture}[alt={Description of diagram}]
```

At this time, all [float environments must be wrapped in `Part`](#wrap-floats-in-part-tags) tags to ensure they are read in the correct order by screen readers.

Read [Alternative Text for Images](https://digitalaccessibility.illinois.edu/getting-started/accessibility-fundamentals/alternative-text-images) for best practices on writing alt text.

### Tables

Tables require proper header configuration for accessibility:

```latex
\tagstructbegin{tag=Part}
\begin{table}[H]
    \caption{Table Caption}
    \tagpdfsetup{table/header-rows={1}}  % First row is header
    \begin{tabular}{|l|l|}
        \hline
        \textbf{Header 1} & \textbf{Header 2} \\
        \hline
        Data 1 & Data 2 \\
        \hline
    \end{tabular}
\end{table}
\tagstructend
```

At this time, all [float environments must be wrapped in `Part`](#wrap-floats-in-part-tags) tags to ensure they are read in the correct order by screen readers.

For tables with header columns:

```latex
\tagpdfsetup{table/header-columns={1},table/header-rows={1}}
```

### Bibliography (`biblatex` + `biber`)

**Biber backend is required**.:

```latex
\usepackage[backend=biber,style=ieee]{biblatex}
\addbibresource{./references.bib}

% In document:
\printbibliography[heading=bibintoc,title={References}]
```

The `style` can be changed to match your field's requirements (apa, ieee, nature, etc.).

### Chemistry Packages

**Important limitation**: `mhchem` and `chemfig` are not fully compatible with accessibility tagging, but currently have no alternatives.

```latex
\usepackage[version=4]{mhchem}  % Chemical formulas: \ce{H2O}
\usepackage{chemfig}            % Molecular structures
```

Here's a sample for how to include a chemical structure with `chemfig`:

```latex
\tagstructbegin{tag=Part}
\begin{figure}[H]
    \chemfig{...}
    \caption{Molecular structure}
\end{figure}
\tagstructend
```

At this time, all [float environments must be wrapped in `Part`](#wrap-floats-in-part-tags) tags to ensure they are read in the correct order by screen readers.

### Other Utilities

- **csquotes**: Proper quotation handling (recommended with babel)
- **hyperref**: PDF hyperlinks (use `hidelinks` option to avoid colored boxes)
- **footmisc**: Footnote positioning control

## Accessibility Best Practices

### Always Use Sectioning

Use LaTeX's sectioning commands rather than manual formatting:

```latex
% Good
\section{Chapter Title}
\subsection{Section Title}

% Bad - will not be tagged properly
{\large\bfseries Manual Heading}
```

> [!NOTE]
> The `uofithesis` class uses the `report` document class as its base,
> which uses `\section` rather than `\chapter` for top-level sections. This is
> intentional to meet the Graduate College formatting standards, as the
> `\chapter` command adds extra vertical space and page breaks that are not allowed.

### Wrap Floats in Part Tags

Wrap figures and tables in Part tags:

```latex
\tagstructbegin{tag=Part}
\begin{figure}[H]
    % content
\end{figure}
\tagstructend
```

Without this, all of the figures and tables will be read after the main text, which is confusing for assistive technology.

### Provide Meaningful Alt Text

Read [Alternative Text for Images](https://digitalaccessibility.illinois.edu/getting-started/accessibility-fundamentals/alternative-text-images) for best practices on writing alt text.

### Use Raggedright

The template sets `\raggedright` by default, which is recommended for accessibility as it:
- Improves readability for dyslexic readers
- Prevents awkward spacing in justified text
- Maintains consistent word spacing

## Document Metadata

The template automatically configures document metadata for accessibility:

```latex
\DocumentMetadata{
    lang=en,
    pdfstandard=ua-2,
    tagging=on,
    tagging-setup={
        math/setup={mathml-AF,mathml-SE},
        extra-modules={verbatim-mo},
    }
}
```

PDF title and author is set via hyperref:

```latex
\AtBeginDocument{
    \hypersetup{
        pdftitle={\@title},
        pdfauthor={\@author}
    }
}
```

## Customization

### Changing Fonts

The template uses `fontsetup` which configures sensible defaults. To use specific fonts:

```latex
\setmainfont{Stix Two Text}
```

### Section Formatting

All sections are automatically formatted per Graduate College requirements:

- 12pt bold font
- Centered
- Numbered as "Chapter N"
- Each chapter starts on a new page
- Sections within chapters do not start on new pages

## File Organization

You can split the document into multiple files for better organization. The main `thesis.tex` file should include the preamble and the overall structure, while individual chapters can be placed in separate `.tex` files.

Use `\input{chapters/chapter1.tex}` or similar to include chapter files.

## Troubleshooting

### Build Errors

**Error: "Undefined control sequence \DocumentMetadata"**
- Update to TeX Live 2025 or later
- Older versions don't support PDF/UA-2 tagging

**Strange build errors after adding a package**
- Check the [Tagging Status of LaTeX Packages](https://latex3.github.io/tagging-project/tagging-status/) to ensure compatibility
- Incompatible packages can fail for reasons not immediately obvious when used with tagging

### Known Adobe Acrobat Accessibility Issues

- Adobe Acrobat repeats the "link" word multiple times with NVDA, e.g. "link link link link Chapter 1".
- Alt text for graphics is only read up to 90 characters at a time, after which it repeats the word "graphic" and then reads the next bit.
- NVDA requires MathCAT to read math in Adobe Acrobat, and supports navigating equations.
- JAWS does not allow navigating equations in Acrobat, and reads the entire equation as one block of text.
- Complex tables with merged cells almost always have problems being read correctly in Acrobat, even with proper header configuration.

## Dissertation/Thesis Support

For general requirements and other support, refer to the
[Graduate College Thesis & Dissertation](https://grad.illinois.edu/academics/thesis-dissertation)
website.

## License

MIT licensed. Copyright (c) 2026 University of Illinois Board of Trustees.
