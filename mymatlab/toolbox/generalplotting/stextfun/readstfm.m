function [fm,kds,encs,accents,encsel] = readstfm(filename)
%READSTFM Read Styled Text Toolbox font metrics file.
%	[FM,KD,ENCODING,ACCENTS,ENCSEL] = READSTFM(FILENAME) reads the
%	file specified by FILENAME which must be the text version of the
%	font metrics.  The character widths, kerning data, encoding vectors,
%	accent characters and encoding selector are returned.
%
%	If FILENAME is omitted then the file "stfm.txt" in the Styled
%	Text Toolbox directory is assumed.

%	Requires function CMDMATCH and file STFM.TXT.
%	Requires MATLAB Version 4.2 or greater.

%	Version 3.1, 10 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

if nargin == 0
	stextfun = which('stext');
	stextfun((length(stextfun) - 6):length(stextfun)) = [];
	filename = [stextfun,'stfm.txt'];
end

fid = fopen(filename);

% Read the character widths of the Roman fonts.
while 1
	line = fgetl(fid);
	if cmdmatch(line,'BeginRomanCharWidths'), break, end
end
dims = sscanf(line,'%*s %d %d');
numChars = dims(1);
nrmFnts = dims(2);
widths = fscanf(fid,'%d',[nrmFnts,numChars])';

% Read the character widths of the Symbol font.
while 1
	line = fgetl(fid);
	if cmdmatch(line,'BeginSymbolCharWidths'), break, end
end
nsymch = sscanf(line,'%*s %d');
symwidths = fscanf(fid,'%d',nsymch);

% Read the character widths of the ZapfDingbats font.
while 1
	line = fgetl(fid);
	if cmdmatch(line,'BeginZapfDingbatsCharWidths'), break, end
end
nzdch = sscanf(line,'%*s %d');
zdwidths = fscanf(fid,'%d',nzdch);

% Read the kerning data information.
while 1
	line = fgetl(fid);
	if cmdmatch(line,'BeginKernData'), break, end
end
nkd = sscanf(line,'%*s %d')';
kernData = fscanf(fid,'%d',[4,nkd])';

% Read the encoding vectors.
while 1
	line = fgetl(fid);
	if cmdmatch(line,'BeginEncodings'), break, end
end
data = sscanf(line,'%*s %d %d');
encsel = data(1);
nenc = data(2);
encs = fscanf(fid,'%d',[nenc,256])';

fclose(fid);

% Put all the character widths in one matrix.
n = max([nsymch,nzdch,numChars]);
fm = zeros(n,nrmFnts+2);
fm(1:nsymch,1) = symwidths;
fm(1:nzdch,2) = zdwidths;
fm(1:numChars,3:nrmFnts+2) = widths;

% Store the kerning data as a sparse matrix.
i = 1000*kernData(:,1) + kernData(:,2);
j = kernData(:,3);
s = kernData(:,4);
kds = sparse(i,j,s,34000,260);

% These are the accent characters (PostScript name in parentheses if
% different): grave, acute, ddot (dieresis), hat (circumflex), tilde,
% bar (macron), breve, dot (dotaccent), check (caron), AA (Aring),
% and ii (dotlessi).
accents = [124 125 131 126 127 128 129 130 136 205 145];
