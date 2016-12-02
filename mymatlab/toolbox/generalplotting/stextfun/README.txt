Styled Text Toolbox
Version 3.1, 10 June 1996
Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
schwarz@kodak.com

___________________________________________________________________________

The most recent version of the Styled Text Toolbox should be available from

    ftp://ftp.mathworks.com/pub/contrib/graphics/stextfun

___________________________________________________________________________

Introduction.

The Styled Text Toolbox is a collection of tools which enables the user to
mix fonts, text styles and mathematical constructs (superscripts,
subscripts, integrals, special math characters, etc.) in a single styled
text object.

Features:

* Internal "command language" similar to LaTeX
* Text properties applicable on a per character basis:  FontName, FontSize,
      FontWeight, FontAngle, Color
* Text properties applicable to entire styled text object:  EraseMode,
      HorizontalAlignment, Position, Rotation, Units, VerticalAlignment,
      ButtonDownFcn, Clipping, Interruptible, Visible
* Superscripts and subscripts
* Greek letters using LaTeX names
* Simulated italic (slanted) Greek letters possible
* Many other characters from Symbol font available using LaTeX names
* Some non-LaTeX characters available
* Diacritics above any character
* Fractions, roots, integrals, summations and products
* Kerned output using kern pairs from Adobe Font Metric files
* All 35 standard fonts supported (the ones built-in to most PostScript
      printers)
* Styled text xlabels, ylabels, zlabels and titles
* Styled text legends and text boxes
* Positions specifiable in 2-D or 3-D coordinates
* Does not require WYSIWYG mode for correct printing
* Fine adjustment of character positions possible
* Syntax nearly the same as that of the built-in text function
* No hard-coded defaults or assumptions
* Platform independent


The Styled Text Toolbox consists of several m-files which are analogous to
the MATLAB commands text, set, get, delete, print, title, xlabel, ylabel
and zlabel.

    stext        - Add styled text to the current plot
    setstext     - Set styled text object properties
    getstext     - Get styled text object properties
    delstext     - Delete a styled text object
    printsto     - Print or save graph containing styled text objects
    stitle       - Styled text plot titles
    sxlabel      - X-axis styled text labels
    sylabel      - Y-axis styled text labels
    szlabel      - Z-axis styled text labels for 3-D plots

They are designed to have, as nearly as possible, the same features and
syntax as their counterparts.  Also included are functions to create
legends and text boxes, a function to modify PostScript files to slant
Greek letters, a function to correct the position of styled text objects
after axes modifications, a demo, a styled text previewer, four utility
functions (used internally), a UNIX shell script, and a file containing
font metric information.

    slegend      - Styled text legends
    stextbox     - Styled text multi-line box
    stfixps      - Modifies PS files to simulate Symbol-Oblique font
    fixstext     - Fix position of styled text objects
    stodemo      - Demonstrates some of the capabilities of stext
    spreview     - GUI application to help build styled text objects

    cmdmatch     - String matching for commands
    move1sto     - Move one styled text object
    getcargs     - Get command arguments
    readstfm     - Read styled text font metrics data file

    addlatin     - UNIX script to add ISOLatin1Encoding to PostScript files

    stfm.txt     - Font metric information

The Styled Text Toolbox requires at least version 4.2 of MATLAB.
The Styled Text Toolbox is free, but please read the Important Information
section at the end of this document.

___________________________________________________________________________

Installation instructions.

The Styled Text Toolbox may be installed anywhere on your search path.  I
suggest using a directory name of "stextfun".  The font metric information
file must be located in the same directory as "stext.m".  The first time
stext is run, a platform-specific MAT-file version of the font metrics is
created.  If you move the toolbox to a different platform, do not copy this
file.  By default, the file will be created in the stextfun directory.  If
you are using a multi-user operating system and you don't have write
permission in that directory, it will be created in the current directory
and a message will be displayed suggesting that you should get your system
administrator to move the file to the stextfun directory.

___________________________________________________________________________

How to use the Styled Text Toolbox.

The basic idea is that commands are embedded in the string you wish to
display (somewhat like LaTeX).  For example, to create a text object at
(x,y) with the text "MATLAB is great!" displayed in 18-point Times, you
could use the command

    text(x,y,'MATLAB is great!','FontName','times','FontSize',18).

Using stext, this becomes

    stext(x,y,'\18\times MATLAB is great!').

However, with stext, you could also put "great" in bold:

    stext(x,y,'\18\times MATLAB is {\bold great}!').

It is possible to change the font size "on-the-fly" and make slightly
smaller uppercase letters:

    stext(x,y,'\18\times M\16ATLAB\18 is {\bold great}!')

or, better yet,

    stext(x,y,'\18\times M{\16ATLAB} is {\bold great}!').

The curly braces signify a temporary style change (and may be nested).

We can also display a simple mathematical equation with a Greek letter and
a superscript:

    stext(x,y,'\12\times The equation for alpha is \alpha = r^2'),

where the alpha is produced with the Symbol font.  Note that the font size
of the superscript is automatically reduced by a factor of sqrt(2).
Subscripts are created similarly with '_'.  Normally, subscripts and
superscripts must be enclosed in braces:

    stext(x,y,'\12\times y = x_{index}^{exponent}'),

but if the subscript or superscript is a single character the braces may be
omitted:

    stext(x,y,'\12\times y = x_1^2').

It is also possible to use the normal text positioning properties
HorizontalAlignment and VerticalAlignment.  For example,

    stext(x,y,'\12\times Hello','HorizontalAlignment','center',...
            'VerticalAlignment','middle'),

will center the text at (x,y).  These properties and values can be
abbreviated and mixed-case, pretty much the same as with the text command.
So, we can also use

    stext(x,y,'\12\times Hello','horiz','center','vert','mid').

Experiment and see what works.

Please note that it is also possible to use styled text in labels and
titles using sxlabel, sylabel, szlabel and stitle.

Because of the way that styled text objects are created, it is necessary to
print them using printsto.  This m-file temporarily repositions the
individual text objects so that when the figure dimensions are adjusted for
printing the objects appear in the correct place.  The syntax of printsto
is exactly the same as print (in fact, all the arguments are passed to
print) so it is still possible to create PostScript files or set printing
options.

If the figure size is changed (or view in 3-D), the styled text objects
will not be in the correct locations.  Use fixstext to reposition them.

Please refer to the Command Reference below, read the help information in
the various m-files and study the demo (stodemo.m) for further explanation.

___________________________________________________________________________

Command Reference.


Parsing of Commands.

It is important to understand how commands are parsed so you will know how
spaces are treated.  There are three categories of commands: those with all
letters (e.g., \alpha), those with all numbers (e.g., \12) and those
consisting of a single special character (e.g., \+).  Commands are
terminated by the first character that can be determined not to be part of
the command itself.  For instance, if the command is all letters then the
first non-letter will mark the end of the command.  If the next character
is in the same category as the command characters then a single space
should be inserted as the termination character.  This space will not
appear in the output.  A few examples should make this clear:

'\alpha a' will produce no space between the alpha and the a.  The space is
necessary to terminate the \alpha command, but it gets swallowed.  Another
way to achieve the same result is with '\alpha{}a'.

'\alpha  a' will produce a single space between the alpha and the a.  The
first space gets swallowed as above, but the second one will appear.
Another way to get the same result is with '\alpha\ a', where the '\ ' is a
standard space command.

'\alpha1' will be parsed without error and there will be no space between
the alpha and the 1.  Of course, this can also be done with '\alpha{}1',

'\alpha 1' will have a single space between the alpha and the 1.

'\+=' will be parsed without error and there will be no space between the
'+' (which will be made with the Symbol font) and the '=' (in the current
font).



Grouping.

Use curly braces, {}, to group characters and to effect temporary style
changes.  For example,

    stext(x,y,'\times Normal, {\i italic, {\b bold-italic}}, normal')

will produce the indicated styles.  Braces can be nested as deeply as
necessary.  See also the section on subscripts and superscripts below.



Subscripts and Superscripts.

Subscripts and superscripts can be produced with '_' and '^'.  The actual
script must be enclosed in braces unless it is a single character in which
case the braces may be omitted.  The scripts may be typed in either order.
Some examples:

    stext(x,y,'y = x^2')

    stext(x,y,'y = x_1^2') which is equivalent to stext(x,y,'y = x^2_1')

    stext(x,y,'y = e^{x^{\pi}}')

    stext(x,y,'y = e^{t_{max}^2}')

The font size of scripts is automatically reduced by a factor of sqrt(2).
This process continues indefinitely so that in

    stext(x,y,'\24x^{y^2}')

the 'y' will be 17-point and the '2' will be 12-point type.



Font size.

The font size is set with \<n>, where <n> is the desired font size in
points.  For example, \18 will set the font size to 18 points.  When
different font sizes are used, the characters are aligned at their
baselines.  The VerticalAlignment is set by the first displayed character.
For example,

    stext(x,y,'\12A\96A','VerticalAlignment','middle'),

will produce a small A followed by a huge A with the middle of the small
A at y and the baseline of the huge A aligned with the baseline of the
small A.

The font size can also be changed by:

    \bigger     Increases font size by a factor of sqrt(2).
    \larger     Increases font size by a factor of sqrt(2).
    \smaller    Decreases font size by a factor of sqrt(2).



Font angle and weight commands.

    \light      Sets font weight to 'light'.
    \demi       Sets font weight to 'demi'.
    \bold       Sets font weight to 'bold'.

    \italic     Sets font angle to 'italic'.
    \oblique    Sets font angle to 'oblique'.

    \normal     Sets both font angle and font weight to 'normal'.



Fonts.

To set or change the font used, use \<font name>.  The following are the
fonts which can be used:

Command               Font
\times                Times
\helvetica            Helvetica
\courier              Courier
\symbol               Symbol
\avantgarde           Avant Garde
\bookman              Bookman
\newcenturyschlbk     New Century Schoolbook
\palatino             Palatino
\zapfdingbats         Zapf Dingbats
\zapfchancery         Zapf Chancery
\narrow               New Helvetica Narrow



Special Characters.

The characters '\{}^_' have special meanings in command strings.  To get
them to display and print use '\\', '\{', '\}', '\^' and '\_' instead.

Arbitrary ASCII characters can be inserted with the \#{<a>} command, where
<a> is the ASCII code of the character.  For example, since the ASCII code
in most encodings for the copyright symbol is 169, it can be inserted with
'\#{169}'.



Colors.

\black, \white, \red, \green, \blue, \cyan, \magenta, \yellow or \gray will
set the text color appropriately.

\color{<R>,<G>,<B>} sets text color to the specified RGB values.  For
example, \color{.5,.5,.5} sets the text color to a medium gray (the same as
\gray).



Positioning, units = points.

\left{<p>}, \right{<p>}, \up{<p>} and \down{<p>} move the subsequent print
position left, right, up and down respectively (relative to the text) by
<p> points.  Negative values for p are allowed.



Positioning, units = current font size.

\rleft{<r>}, \rright{<r>}, \rup{<r>} and \rdown{<r>} move the subsequent
print position left, right, up and down respectively (relative to the text)
by r*(current font size) points.  Negative values for r are allowed.



Integrals, summations and products.

\int{<a>}{<b>}, \sum{<a>}{<b>} and \prod{<a>}{<b>} produce a definite
integral, summation and product, respectively, with lower limit <a> and
upper limit <b> where <a> and <b> are valid stext constructs.  One or both
of the limits may be blank, e.g.,

    stext(x,y,'\int{x}{} f(x) dx')

will produce the notation meaning "integrate over all x".  On the Macintosh
(and perhaps on other platforms) the integral, summation and product
symbols look too low on the screen, but print correctly.



Fractions.

\frac{<a>}{<b>} will produce a fraction of <a> over <b>, where <a> and <b>
are valid stext constructs.



Roots.

\sqrt{<a>} will produce the square root of <a> and \root{<n>}{<x>} will
produce the <n>th root of <x>.  The appearance on the screen may not match
the print exactly.



Lowercase Greek letters.

These are produced using the same names as used by LaTeX. The following
table lists the lowercase Greek letters:

\alpha             \iota              \sigma
\beta              \kappa             \varsigma
\gamma             \lambda            \tau
\delta             \mu                \upsilon
\epsilon           \nu                \phi
\varepsilon        \xi                \varphi
\zeta              \pi                \chi
\eta               \varpi             \psi
\theta             \rho               \omega
\vartheta          \varrho

Two of these characters don't exist in the Symbol font but are included for
completeness.  In particular, \varrho produces a TeX \rho and \epsilon
produces a TeX \varepsilon (yes, that's right, it's the \epsilon character
which is missing).



Uppercase Greek letters.

These are produced exactly like the lowercase ones.

\Gamma             \Xi                \varUpsilon
\Delta             \Pi                \Phi
\Theta             \Sigma             \Psi
\Lambda            \Upsilon           \Omega

I made up the \varUpsilon name since the character is in the Symbol font,
but it looks almost exactly like a Y in Times; I wouldn't recommend using
it.  The other uppercase Greek letters look just like characters in the
Roman alphabet and so are not included.



Other LaTeX characters.

Many other characters are available in the Symbol font:

\forall            \approx            \angle
\exists            \dots              \nabla
\cong              \vert              \surd
\perp              \Vert              \cdot
\bot               \aleph             \neg
\leq               \Im                \lnot
\infty             \Re                \land
\leftrightarrow    \wp                \lor
\leftarrow         \otimes            \Leftrightarrow
\uparrow           \oplus             \Leftarrow
\rightarrow        \emptyset          \Uparrow
\downarrow         \cap               \Rightarrow
\degrees           \cup               \Downarrow
\pm                \supset            \diamond
\geq               \supseteq          \langle
\propto            \notsubset         \lceil
\partial           \subset            \lfloor
\bullet            \subseteq          \rangle
\div               \in                \rceil
\neq               \notin             \rfloor
\equiv             \AA

If you don't know what some of these look like just try them out.



Non-LaTeX characters.

\+, \-, \=, \>, \< and \| use the appropriate characters from the Symbol
font instead of whatever font you are using at the time.  The results may
be somewhat better, especially \- since it produces a minus sign which is
the same width as \+.  A hyphen is too narrow.

\therefore produces the three-dot symbol.

\prime produces a prime symbol.

\dprime produces a double prime symbol.

\slash produces a sharply angled slash from the Symbol font.

\mult produces the x-shaped multiplication symbol.  In LaTeX this is called
\times, but I had to change it since \times refers to the Times font.

\horiz produces a fairly long horizontal line which matches up with
\leftarrow and \rightarrow.

\ii produces a dotless "i" for use under accents.  (Not available with the
Windows encoding.)



Diacritics.

(See important note below.)
It is possible to produce accented characters, however, the syntax is not
the same as LaTeX.  Consider

    stext(x,y,'y\hat \= x\tilde').

The accent will be centered over the most recently produced character.  The
accents which are available are:

\grave     \Grave    (slanted line down to right)
\acute     \Acute    (slanted line up to right)
\ddot      \Ddot     (double dots)
\hat       \Hat      ('^')
\tilde     \Tilde    (squiggly line)
\bar       \Bar      (short horizontal line or macron)
\breve     \Breve    (semicircle open at top)           (N/A with Windows)
\dot       \Dot      (single dot)                       (N/A with Windows)
\check     \Check    (upside down '^')                  (N/A with Windows)

The capitalized versions are a little higher and suitable for use over tall
characters like 'b' or capitals.

Note:  The accent characters are encoded in the upper half of the ASCII
code range and in different places depending on the character encoding.
There are three encoding schemes in use (that I know of): MacEncoding
(used only on the Macintosh), WindowsLatin1Encoding (used only on Windows)
and ISOLatin1Encoding (used by everything else).  The correct ASCII codes
for your platform are computed from the encoding information contained in
the font metric file, stfm.mat via stfm.txt, so you don't have to worry
about this.

There is, however, another problem which some people may encounter.
Apparently, some PostScript printers (and software rasterizers) do not
recognize the ISOLatin1Encoding keyword and use a default encoding which
does not include some of the accent characters.  In this case, the accent
characters will simply not print, but everything else will be ok.  There is
a workaround.  It is possible to insert the ISOLatin1Encoding definition
into the PostScript file before sending it to the printer.  I have included
a UNIX script, addlatin, to perform the insertion.  So, instead of typing

  >>printsto

you must now type something like

  >>printsto -dps myfig.ps  (or use -deps, -dpsc, etc.)
  >>!addlatin myfig.ps
  >>!lpr myfig.ps           (substitute 'lp' for 'lpr' if necessary)

to print figures which contain accented characters.  Please note that if
you are using a Macintosh (which uses MacEncoding), Windows (which uses
WindowsLatin1Encoding) or your PostScript printer already recognizes the
ISOLatin1Encoding keyword you don't have to worry about any of this.  Also
note that the accents may not appear on the screen, but they should print
correctly.



Slanted Symbol Characters.

As mentioned below, scalar variables should be in italics.  This poses a
problem when the variable is represented by a Greek letter because there is
no Symbol-Italic or Symbol-Oblique font.  Whenever you have seen a slanted
version of one of the Symbol characters it has been produced by appropriate
PostScript code which slants the character.  Unfortunately, MATLAB does not
do this and italic or oblique Symbol characters are rendered unslanted.
There is now a way around this problem.  The function stfixps will modify a
PostScript file by inserting the character-slanting code.  The PostScript
file must have been made from a figure containing styled text objects which
include italic or oblique Symbol characters.  So, as above, printing becomes
a little more complicated.  You must type something like

  >>printsto -dps myfig.ps  (or use -deps, -dpsc, etc.)
  >>stfixps myfig.ps
  >>!lpr myfig.ps           (substitute 'lp' for 'lpr' if necessary)

to print figures containing slanted Greek letters.  This creates a problem
for Mac users since there is no built-in equivalent to lpr.  I recommend
obtaining Drop¥PS from Bare Bones Software which is a drag-and-drop
application to send PostScript files to a printer.  You can either drop
myfig.ps on Drop¥PS or type

  >>!Drop¥PS myfig.ps

at the MATLAB prompt.  Drop¥PS is free and is available from

  http://www.barebones.com/freeware/DropPS-113.hqx

I don't have access to a Windows machine so I don't know how to do this
there, but I assume some kind of utility exists to send PostScript files
to a printer.


___________________________________________________________________________

Tips and Style Comments

1)  Abbreviation of Commands.

There are two kinds of commands:  those that produce a character and those
that merely change the appearance of subsequent characters.  It is
permissible to abbreviate the latter but not the former.  The rules for
determining a valid abbreviation are somewhat complicated.  It has to do
with the order of the tests to determine the command.  Basically, just make
sure the abbreviation is unambiguous.  For example, \i is a valid
abbreviation for \italic since no other commands begin with 'i' except for
\int, \iota, \infty and \in and those are all character producing commands.
Other valid abbreviations for \italic are \itali, \ital, \ita and \it.

Minimal abbreviations:
\n     = \normal                       \sm   = \smaller
\i     = \italic                       \bl   = \black
\o     = \oblique                      \w    = \white
\l     = \light                        \r    = \red
\d     = \demi                         \g    = \green
\b     = \bold                         \blu  = \blue
\t     = \times                        \cy   = \cyan
\h     = \helvetica                    \m    = \magenta
\c     = \courier                      \y    = \yellow
\s     = \symbol                       \gra  = \gray
\a     = \avantgarde                   \co   = \color
\boo   = \bookman                      \le   = \left
\ne    = \newcenturyschlbk             \ri   = \right
\p     = \palatino                     \u    = \up
\z     = \zapfdingbats                 \do   = \down
\zapfc = \zapfchancery                 \rl   = \rleft
\na    = \narrow                       \rr   = \rright
\bi    = \bigger                       \ru   = \rup
\la    = \larger                       \rd   = \rdown



2)  Braces.

Use braces liberally.  They can be nested as deeply as necessary and they
make the expressions easier to read.  For example,

    stext(x,y,'\12\times The word {\i italic} is in italics.')

is clearer than

    stext(x,y,'\12\times The word \i italic \norm is in italics.').



3)  Mathematical Formulas.

For a professional look, use italics for scalar variables.  It can make the
command string look pretty messy, but is worth it.  Compare

    stext(x,y,'\18\times r^2 \= x^2 \+ y^2')

with

    stext(x,y,'\18\times{\i r}^2 \= {\i x}^2 \+ {\i y}^2').

When using accents over italicized characters, make the accents in italics
also.  For example,

    stext(x,y,'{\i y\hat}')

looks better than

    stext(x,y,'{\i y}\hat').



4)  Tweaking.

If you are fussy, you can tweak the appearance of your styled text objects
using the positioning commands (\left, \right, etc.).  It is usually better
to use the ones which are in units of current font size (\rleft, \rright,
etc.) since you can design and preview the object on-screen at a large size
and then scale it down just by changing the font size.  The individual
elements will maintain their relationships to each other.

The positioning commands can be used to produce some very complicated
mathematical formulas, but it will require some trial-and-error (try using
spreview).

An example of this is to move the axis labels away from the axes:

    sxlabel('\down{5}This label will be 5 points lower than normal.')
    sylabel('\up{5}This label will be 5 points to the left of normal.)

A number of spacing commands are available.  In order, they are:

'\/'    italic correction
'\,'    thin space
'\:'    medium space
'\;'    thick space
'\ '    word space

The italic correction can be used to add just a little bit of space when
there is a transition from italic to normal letters.  The other spaces can
be useful in various situations.

___________________________________________________________________________

Other features.

Ordinary text strings are kerned using the kern pairs defined in the Adobe
Font Metric files for the supported fonts.

Printing does *not* require that the figure 'Position' be set to the same
dimensions as the 'PaperPosition' (WYSIWYG mode).  This means that printing
works correctly even if you have a small monitor (where it is not possible
to use WYSIWYG mode since the monitor is not as tall as a piece of paper).
If you do use WYSIWYG mode it is not necessary to print using printsto;
print will work just fine.

The Styled Text Toolbox was designed to be platform-independent.  I have
taken into account the different character encodings in use.  Also, to
accommodate the PC users, the file names have no more than eight
characters.

The Styled Text Toolbox was designed to be user-preference-independent.
There are no built-in defaults or assumptions such as text color or font
choice.

___________________________________________________________________________

What are its limitations?

Even though version 3.1 has more capability than version 2.1, the
mathematical formulas which can be created easily with the Styled Text
Toolbox are still somewhat limited.  You can make Greek letters, italics,
superscripts, subscripts, integrals, etc., but other more complicated
constructs are possible only with some difficulty and creativity.  It was
never my intention to make this thing an equation typesetting tool (though
it seems to be moving in that direction), but just a way of including Greek
letters and simple formulas in MATLAB figures.

___________________________________________________________________________

Important Information.

The Styled Text Toolbox was written by me, Douglas M. Schwarz.  Although I
am an employee of the Eastman Kodak Company, this tool was written entirely
on my own time and is not supported in any way by Kodak.  If you have a
problem with it please bring it to my attention, but there may be a day or
two delay before I can get around to looking at it.  The Styled Text
Toolbox is free, but not in the public domain and I retain all rights.  You
are free to modify your own copy, of course, but please do not distribute a
modified version.  I am open to any suggestions of ways to improve this
tool.


Styled Text Toolbox
Version 3.1, 10 June 1996
Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
schwarz@kodak.com
