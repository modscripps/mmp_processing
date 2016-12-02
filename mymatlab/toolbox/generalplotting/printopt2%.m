function [pcmd,dev] = printopt2
%PRINTOPT2 Configure local printer defaults.
%       PRINTOPT2 is an M-file that you or your system manager can
%       edit to indicate your default printer type and destination.
%
%       [PCMD,DEV] = PRINTOPT returns two strings, PCMD and DEV.
%       PCMD is a string containing the print command that
%       PRINT uses to spool a file to the printer. Its default is:
%
%          Unix:      lpr -r
%          Windows:   COPY /B LPT1:
%          Macintosh: macprint
%          VMS:       PRINT/DELETE
%          SGI:       lp
%
%       DEV is a string containing the default device option for 
%       the PRINT command. Its default is:
%
%          Unix & VMS: -dps
%          Windows:    -dwin
%          Macintosh:  -dps
%
%       See also PRINT.

% Intialize options to empty matrices
pcmd = []; dev = [];

% This file automatically defaults to the dev and pcmd shown above
% in the online help text. If you would like to set the dev or pcmd
% default to be different from those shown above, enter it after this
% paragraph.  For example, pcmd = 'lpr -r -Pfred' would change the 
% default for Unix systems to send output to a printer named fred.
% See PRINT.M for a complete list of available devices.

%---> Put your own changes to the defaults here (if needed)

% ----------- Do not modify anything below this line ---------------
% The code below this line automatically computes the defaults 
% promised in the table above unless they have been overridden.
% Modified 4/9/95 by Darren Hallman, Herrick Labs/Purdue University
% to execute the print command properly for Solaris and HPUX-9
% systems

cname = computer;

if isempty(pcmd)

        % For Unix
        pcmd = 'lpr -r';

        % For Windows
        if strcmp(cname(1:2),'PC'),  pcmd = 'COPY /B %s LPT1:'; end

        % For Macintosh
        if strcmp(cname(1:3),'MAC'), pcmd = 'macprint'; end

        % For SGI, Solaris, or HP
        if (strcmp(cname(1:3),'SGI') | strcmp(cname,'SOL2') | strcmp(cname,'HP700')),
              pcmd = 'lp -c';
        end

        % For VAX/VMS
        if length (cname) >= 7 
           if strcmp(cname(1:7),'VAX_VMS'), pcmd = 'PRINT/DELETE'; end
        end
end

if isempty(dev)

        % For Unix, VAX/VMS, and Macintosh
        dev = '-dps';

        % For Windows
        if strcmp(cname(1:2),'PC'), dev = '-dwin'; end
end

