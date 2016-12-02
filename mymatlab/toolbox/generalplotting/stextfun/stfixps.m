function stfixps(filename)
%STFIXPS Modifies MATLAB PostScript files to produce Symbol-Oblique.
%	STFIXPS(PSFILE) takes a MATLAB PostScript file containing Styled
%	Text Objects with italic or oblique Symbol characters and modifies
%	it so that the Symbol characters are slanted.
%
%	See also STEXT, PRINTSTO.

%	Version 3.1.1, 21 June 1996
%	Part of the Styled Text Toolbox
%	Copyright 1995-1996 by Douglas M. Schwarz.  All rights reserved.
%	schwarz@kodak.com

% Define slant angle.  12 degrees matches slant of Times-Italic.
slantAngle = 12*pi/180;
mtx = sprintf('[1 0 %.6f -1 0 0]',tan(slantAngle));
wtfmt = ['/Symbol findfont %d scalefont ',mtx,' makefont setfont\n'];
comp = computer;
if cmdmatch(comp,'MA')
	rdfmt = '/Symbol /MacEncoding %d';
else
	rdfmt = '/Symbol /ISOLatin1Encoding %d';
end


if cmdmatch(comp,'PC') or cmdmatch(comp,'VAX')
	fid = fopen(filename,'rt+');
else
	fid = fopen(filename,'r+');
end

while 1
	fpos = ftell(fid);
	line = fgetl(fid);
	if ~isstr(line), break, end
	fstemp = sscanf(line,rdfmt);
	if ~isempty(fstemp)
		fs = fstemp;
		startpos = fpos;
	end
	
	if strcmp(line,'(\11) s')
		fgetl(fid); fgetl(fid); fgetl(fid);
		aLine = fgets(fid);
		endpos = ftell(fid);
		neol = sum(aLine == 10 | aLine == 13);
		len = endpos - startpos - neol;
		
		fseek(fid,startpos,'bof');
		fprintf(fid,'%s',' '*ones(1,len));
		fseek(fid,startpos,'bof');
		fprintf(fid,wtfmt,fs);
		
		fseek(fid,endpos,'bof');
	end
end

fclose(fid);
