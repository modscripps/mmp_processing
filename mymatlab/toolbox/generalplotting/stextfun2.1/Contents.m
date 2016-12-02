% Styled Text Toolbox.
% Version 2.1, 8 September 1995
% Copyright 1995 by Douglas M. Schwarz.  All rights reserved.
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
%
% Demo.
%   stodemo      - Demonstrates some of the capabilities of stext.
%
% Utility functions (used internally).
%   cmdmatch     - String matching for commands.
%   move1sto     - Move one styled text object.
%   getcargs     - Get command arguments.
%
% Font Metric data.
%   stfmmac.mat  - Font metric information for MacEncoding.
%   stfmlat1.mat - Font metric information for ISOLatin1Encoding.
