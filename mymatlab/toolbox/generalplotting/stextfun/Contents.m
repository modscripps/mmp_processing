% Styled Text Toolbox.
% Version 3.1, 10 June 1996
% Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
% schwarz@kodak.com
%
% General.
%   stext        - Add styled text to the current plot.
%   setstext     - Set styled text object properties.
%   getstext     - Get styled text object properties.
%   delstext     - Delete a styled text object.
%   fixstext     - Fix position of styled text objects.
%   printsto     - Print or save graph containing styled text objects.
%   stitle       - Styled text plot titles.
%   sxlabel      - X-axis styled text labels.
%   sylabel      - Y-axis styled text labels.
%   szlabel      - Z-axis styled text labels for 3-D plots.
%   slegend      - Styled text legends.
%   stextbox     - Styled text multi-line box.
%   stfixps      - Modifies PS files to simulate Symbol-Oblique font.
%   addlatin     - UNIX script to add ISOLatin1Encoding to PostScript files.
%
% Demo.
%   stodemo      - Demonstrates some of the capabilities of stext.
%   spreview     - GUI application to help build styled text objects.
%
% Utility functions (used internally).
%   cmdmatch     - String matching for commands.
%   move1sto     - Move one styled text object.
%   getcargs     - Get command arguments.
%   readstfm     - Read styled text font metrics data file.
%
% Font Metric data.
%   stfm.txt     - Font metric and encoding information.
