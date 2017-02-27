function print(arg1,arg2,arg3,arg4,arg5)
%PRINT  Print graph or save graph to file.
%       PRINT <filename> saves the current Figure window as PostScript
%       or a printer specific format, as specified by PRINTOPT. If
%       a filename is specified, the output is written to the designated file,
%       overwriting it if it already exists. If the specified filename does not
%       include an extension, an appropriate one is appended.
%       If the filename is omitted, the Figure is sent directly to the
%       printer as specified in PRINTOPT.
%
%       PRINT <filename> -f<figure handle> prints the specified figure.
%       PRINT <filename> -s<system name> prints the specified SIMULINK
%               system.
%
%       Syntax: PRINT [ -ddevice] [ -options ] <filename>
%
%       Available PostScript devices are:
%          -dps    - PostScript for black and white printers
%          -dpsc   - PostScript for color printers
%          -dps2   - Level 2 PostScript for black and white printers
%          -dpsc2  - Level 2 PostScript for color printers
%
%          -deps   - Encapsulated PostScript (EPSF)
%          -depsc  - Encapsulated Color PostScript (EPSF)
%          -deps2  - Encapsulated Level 2 PostScript (EPSF)
%          -depsc2 - Encapsulated Level 2 Color PostScript (EPSF)
%
%       Additional built-in devices are:
%          -dhpgl  - HPGL compatible with Hewlett-Packard 7475A plotter
%          -dill   - Adobe Illustrator 88 compatible illustration file
%          -dmfile - M-file that will mostly re-create Figure and its children
%                    Not fully functional, and is offered as-is without support
%
%       Additional GhostScript devices are (these devices are not supported
%       on the Macintosh):
%          -dlaserjet - HP LaserJet
%          -dljetplus - HP LaserJet+
%          -dljet2p   - HP LaserJet IIP
%          -dljet3    - HP LaserJet III
%          -dcdeskjet - HP DeskJet 500C with 1 bit/pixel color
%          -dcdjcolor - HP DeskJet 500C with 24 bit/pixel color and
%                           high-quality color (Floyd-Steinberg) dithering
%          -dcdjmono  - HP DeskJet 500C printing black only
%          -ddeskjet  - HP DeskJet and DeskJet Plus
%          -dpaintjet - HP PaintJet color printer
%          -dpjetxl   - HP PaintJet XL color printer
%          -dbj10e    - Canon BubbleJet BJ10e
%          -dln03     - DEC LN03 printer
%          -depson    - Epson-compatible dot matrix printers (9- or 24-pin)
%          -deps9high - Epson-compatible 9-pin, interleaved lines 
%                          (triple resolution)
%          -dgif8     - 8-bit color GIF file format
%          -dpcx16    - Older color PCX file format (EGA/VGA, 16-color)
%          -dpcx256   - Newer color PCX file format (256-color)
%
%       Other options are:
%          -append    - Append, not overwrite, the graph to PostScript file
%          -epsi      - Add 1-bit deep bitmap preview (EPSI format)
%          -ocmyk     - Use CMYK colors in PostScript instead of RGB
%          -Pprinter  - Specify the printer to use
%          -fhandle   - Handle Graphics handle of figure to print
%          -sname     - Name of SIMULINK system window to print
%          -psdefcset - Use PostScript default character set encoding always
%
%       Available Windows device options are:
%          -dwin    - Send figure to currently installed printer in monochrome
%          -dwinc   - Send figure to currently installed printer in color
%          -dmeta   - Send figure to clipboard in Metafile format
%          -dbitmap - Send figure to clipboard in bitmap format
%          -dcdj550 - HP Deskjet 550c
%          -dsetup  - Bring up Print Setup dialog box, but do not print
%
%       Other Windows options are:
%          -v       - Verbose mode, bring up the Print dialog box
%                     which is normally suppressed.
%
%       See also PRINTOPT, ORIENT.

%       Modified 23-Nov-93
%       Copyright (c) 1984-94 by The MathWorks, Inc.

%
% ---------------------------------------------- User modifiable values.

%maximum for width or height of preview window, in Points (72/inch).
maxPrevSize = 200; 

% ---------------------------------------------- End user modifiable values.
%

%
% List of all supported devices used for input validation.
%
% The first column contains the device name, the second column contains the
% default filename extension, the third column indicates what type of output
% device is employed, and the fourth indicates Monochrome or Color device.
%
device_table = [
%Postscript device options
        'ps      '      'ps '   'PS'    'M' 
        'psc     '      'ps '   'PS'    'C'
        'ps2     '      'ps '   'PS'    'M'
        'ps2c    '      'ps '   'PS'    'C'
        'psc2    '      'ps '   'PS'    'C'
        'eps     '      'eps'   'EP'    'M'
        'epsc    '      'eps'   'EP'    'C'
        'eps2    '      'eps'   'EP'    'M'
        'eps2c   '      'eps'   'EP'    'C'
        'epsc2   '      'eps'   'EP'    'C'
%Other built-in device options
        'hpgl    '      'hgl'   'BI'    'C'
    'ill     '      'ai '   'BI'    'C'
    'mfile   '      '   '   'BI'    'C'
%GhostScript device options
        'laserjet'      'jet'   'GS'    'M'
        'ljetplus'      'jet'   'GS'    'M'
        'ljet2p  '      'jet'   'GS'    'M'
        'ljet3   '      'jet'   'GS'    'M'
        'cdeskjet'      'jet'   'GS'    'C'
        'cdjcolor'      'jet'   'GS'    'C'
        'cdjmono '      'jet'   'GS'    'M'
        'deskjet '      'jet'   'GS'    'M'
        'cdj550  '      'jet'   'GS'    'C'
        'paintjet'      'jet'   'GS'    'C'
        'pjetxl  '      'jet'   'GS'    'C'
        'bj10e   '      'jet'   'GS'    'M'
        'ln03    '      'ln3'   'GS'    'M'
        'epson   '      'ep '   'GS'    'M'
        'eps9high'      'ep '   'GS'    'M'
        'epsonc  '      'ep '   'GS'    'C'
        'gif8    '      'gif'   'GS'    'C'
        'pcx16   '      'pcx'   'GS'    'C'
        'pcx256  '      'pcx'   'GS'    'C'
% Microsoft Windows-specific options
        'win     '      '   '   'MW'    'M'
        'winc    '      '   '   'MW'    'C'
        'meta    '      'wmf'   'MW'    'C'
        'bitmap  '      'bmp'   'MW'    'C'
        'setup   '      '   '   'MW'    'M'
];

options = [
        'v        '
        'epsi     '
        'append   '
        'psdefcset'
];

devices = device_table(:, 1:8);
extensions = device_table(:, 9:11);
classes = device_table(:, 12:13);
colorDevs = device_table(:, 14 );

comp = computer;
ghostScriptDevice = [];
printplot = 0;
num_opt_args = 0;
filename = [];
printer = [];
hasPreview = 0;
prtSim = 0;
verbose = 0;
dev = [];

% Get current figure, but don't create one, like gcf would, if none yet.
window = get( 0, 'Children' );
if ~isempty( window )
        window = window(1);
end

for i=1:nargin
        cur_arg = eval(['arg', num2str(i)]);

        % Filename
        if (cur_arg(1) ~= '-')
                if ~isstr( cur_arg )
                        error( 'Filename argument is not a string.' )
                end
                if isempty(filename)
                        filename = cur_arg;
                else
                        error( [ 'Multiple inputs that look like filenames: ''' ...
                                        filename ''' and ''' cur_arg '''' ] );
                end

        % Device name
        elseif (cur_arg(2) == 'd')
                %
                % verify device given is supported, and only one given
                % device proper starts after '-d', if only '-d'
                % we echo out possible choices
                %
                if ~isempty( dev )
                        error( [ 'Multiple inputs that look like device names: ''' ...
                                        dev ''' and ''' cur_arg ''''] );
                end

                wasError = 0;
                if ( size(cur_arg, 2) > 2 )
                        wasError = 1;
                        % Find index of device in table, used a lot later on.
                        for devIndex = 1:size(devices,1)
                                if strcmp( cur_arg(3:size(cur_arg,2)), ...
                                                        deblank(devices(devIndex,:)) )
                                        dev = deblank( cur_arg );
                                        break;
                                end
                        end
                        if isempty(dev)
                                disp('Illegal device specified.');
                        end
                end
                if isempty(dev)
                        disp('Supported devices are:')
                        if (comp(1:2) =='PC')
                                disp(devices);
                        else
                                % Find first non PC specific device
                                for i = size( classes, 1 ) : -1 : 1
                                        if ~strcmp( classes(i,:), 'MW' )
                                                break;
                                        end
                                end
                                disp( devices( 1 : i, : ) )
                        end
                        if wasError
                                error(' ');
                        else
                                return;
                        end
                end

        % Printer name
        elseif (cur_arg(2) == 'P')
                if strcmp(comp,'SGI') | strcmp(comp,'HP700') | strcmp(comp,'SOL2'),
                        cmdOption='-d';
                else,
                        cmdOption='-P';
                end
                printer = [ ' ' cmdOption cur_arg(3:length(cur_arg)) ];
        
        % SIMULINK system name
        elseif (cur_arg(2) == 's')
                if ( exist('open_system') ~= 5 )
                        error('SIMULINK is not available in this version of MATLAB.');
                end
                window = cur_arg( 3:length(cur_arg) );
                if isempty( window )
                        % Print current system by default, if one is open.
                        % Put inside eval so Windows and MAC MATLAB only can use this too.
                        window = eval('get_param');
                        slashIndices = find( '/' == window );
                        if ~isempty( slashIndices )
                                % Need just the window name, not the lineage of the composite block.
                                window = window( slashIndices( length(slashIndices) )+1 : length( window ) );
                        end
                        
                        if isempty( window )
                                error('No SIMULINK system to print with -s option.');
                        end
                end
                prtSim = 1;

        % Handle Graphics figure handle
        elseif (cur_arg(2) == 'f')
                window = cur_arg( 3:length(cur_arg) );
                if isempty( window )
                        % Get current figure, but don't create one, like gcf would, if none yet.
                        window = get( 0, 'Children' );
                        if ~isempty( window )
                                window = window(1);
                        end
                else
                        %Must be, or at least should be, a figure handle integer.
                        window = eval( window );
                end

    % Driver specific options, just pass through.
        elseif (cur_arg(2) == 'o')
                num_opt_args = num_opt_args + 1;
                eval(['opt_arg', num2str(num_opt_args), ' = cur_arg;']);

        % Other options
        else
                %
                % verify any given options are supported
                %
                match = 0;
                if size(cur_arg,2) > 1
                        op = cur_arg(2:size(cur_arg,2));
                        for r = 1:size(options,1)
                                c = min(size(op,2), size(options(r,:),2));
                                if strcmp(op(1:c), options(r,1:c))
                                        match = 1;
                                        if ( strcmp( op, 'epsi' ) )
                                                hasPreview = 1;
                                                %
                                                % HARDCOPY code actually wants to see 'preview'.
                                                %
                                                cur_arg = '-preview';

                                                if ~( strcmp( comp, 'PCWIN' )  ... 
                                                        | strcmp( comp, 'MAC2' )   ...
                                                        | strcmp( comp, 'MACFPU' ) ...
                                                        | strcmp( comp, 'MAC' ) )
                                                        %
                                                        % Can't have EPSI preview if using a terminal
                                                        % because we can't do screen capture.
                                                        %
                                                        if ~strcmp( get(0,'TerminalProtocol'), 'x' )
                                                                disp('WARNING: Can not capture screen preview in terminal mode; epsi option ignored.')
                                                                match = 2;
                                                                hasPreview = 0;
                                                        end
                                                end
                                        elseif (strcmp(op, 'v'))
                                                verbose = 1;
                                        end
                                        break;
                                end
                        end
                end
                if match == 0
                        error(['Illegal option ''' op ''' given.'])
                elseif match == 1
                        num_opt_args = num_opt_args + 1;
                        eval(['opt_arg', num2str(num_opt_args), ' = cur_arg;']);
                end
        end
end

% If no window requested, and none to act as default, error out.
if isempty( window )
        error('No Figure to print.');
end

% If no device given, use default from PRINTOPT
if isempty( dev )

        % Find device name in list of devices to set the
        % appropriate filename extension.
        [lprcmd, defaultDevice] = printopt2;
        % skip '-d'
        d = defaultDevice( 3 : size(defaultDevice,2) );
        for devIndex = 1 : size(devices,1)
                if strcmp( devices(devIndex, 1 : size(d,2)), d )
                        dev = defaultDevice;
                        break;
                end

        end
        if isempty( dev )
                error(['PRINTOPT specifies an unknown device type '''...
                        defaultDevice ''''])
        end
end

devClass = classes(devIndex, :);
if ( devClass == 'GS' )
        if (comp(1:3) =='MAC')
                error('GhostScript devices are not supported on the Macintosh.')
        end
        %
        % Remember actual device, get MATLAB to produce PostScript for later
        % conversion by GhostScript
        %
        ghostScriptDevice = deblank(devices(devIndex,:));
        if ( colorDevs(devIndex ) == 'C' )
                dev = '-dpsc';
        else
                dev = '-dps';
        end
elseif strcmp(devClass, 'MW' )
        if ~strcmp( comp, 'PCWIN' )
                error( ['Can only use Windows device ''' dev ''' on a Windows machine.'])
        end
end

extension = deblank(extensions( devIndex, : ));

if ~prtSim
        % Create Handle Graphics objects on screen if not already there;
        % but, if going to change colors and bring it to front
        % for EPSI preview, do not drawnow now, but after color changes.
        if ~( hasPreview & ...
                (strcmp( 'on', get(window,'InvertHardcopy') ) ...
                | colorDevs( devIndex ) == 'M' ) )
                drawnow
        end
end

tellUserFilename = 0;
if isempty(filename)
        %EPS files shouldn't go to printer, generate file on disk
        if ( devClass == 'EP' )
                if prtSim
                        filename = window;
                else
                        filename = [ 'figure' int2str( window ) ];
                end
                tellUserFilename = 1;
        else
                % Generate a unique name for temporary file
                if (devClass ~= 'MW')
                        filename = tempname;
                        printplot = 1;
                end
        end
else
        % Hack, if user specifies a filename while device is -dwin
        % or -dwinc, either because the user gave that device or, more
        % likely, it's the default, and since the filename is useless
        % with Windows driver anyway, we'll assume the user really wants
        % a PostScript file. This is because 'print foo' is easier
        % to type then 'print -dps foo' and probably more commonly
        % meant if a filename is given.
        if (devClass == 'MW') & (strcmp( dev, '-dwin' ) | strcmp( dev, '-dwinc' ))
                if ( colorDevs(devIndex ) == 'C' )
                        dev = '-dpsc';
                else
                        dev = '-dps';
                end
                extension = 'ps';
        end
end

% Append appropriate extension to filename if it doesn't have
% one, and we've determined a good one.
if ~any(filename == '.') & ~isempty( extension ) & ~isempty( filename )
        filename = [ filename '.' extension ];
end

if tellUserFilename
        disp( 'Encapsulated PostScript files can not be sent to printer.' );
        disp( [ 'File saved to disk under name ''' filename '''.' ] );
end

if (strcmp('setup', dev(3:size(dev,2))))
        if isempty( filename )
                filename = 'Untitled';
        end
    hardcopy( window , filename, dev)
    return
end

if (comp(1:3) =='MAC')
        if (printplot & verbose)
                printplot = macprint(window, filename, prtSim, 0);
                if ~printplot
                        return;
                end
        end

        if ((devClass == 'EP' | devClass == 'PS') & ~printplot & ~hasPreview)
                cur_arg = '-previewmac';
                num_opt_args = num_opt_args + 1;
                eval(['opt_arg', num2str(num_opt_args), ' = cur_arg;']);
        end
end

if ~( prtSim | strcmp( '-dmfile', dev ) )
        % Invert B&W color properties of Figure and child objects
        if strcmp( 'on', get(window,'InvertHardcopy') )
                invertedColor = 1;
                cinvert( window );
        else
                invertedColor = 0;
        end

        % if not color, set lines and text to a color contrasting background
    if ( colorDevs(devIndex ) == 'M' )
                lineTextColors = blt( window, get(window,'color') );
        else
                lineTextColors = [];
        end

        % If including preview, and changed any of the colors, update figure
        % raise it to top of stacking order for screen capture.
        % Resize the figure if its larger then the biggest preview allowed
        % in the aspect ratio of the PaperPosition the graph is rendered into.
        if hasPreview
                %
                % Get current size info in points.
                %
                origUnits = get( window, 'units' );
                set( window, 'units', 'Points' );
                frect = get( window, 'position');

                origPaperUnits = get( window, 'paperunits' );
                set( window, 'paperunits', 'Points' );
                prect = get( window, 'paperposition');
                pW = prect(3);
                pH = prect(4);

                if max(pH, pW) > maxPrevSize 
                        %
                        % One dimension may need to shrink more then the other.
                        %
                        prevResized = 1;
                        scale = min( maxPrevSize ./ [pW pH] );
                        newWH = fix( [pW pH] .* scale );
                        %
                        % Shrink window for screen capture, keep top left position.
                        %
                        set( window, 'Position', [ frect(1) frect(2)+(frect(4)-newWH(2)) newWH ] )
                else
                        prevResized = 0;
                end

                % Bring figure to front
                figure( window );

                % Render Handle Graphics objects in new state for EPSI preview.
                drawnow

        end % hasPreview
end     % ~prtSim

if ( devClass == 'GS' )
        orig_filename1 = filename;
        filename = [tempname '.ps'];
end

if isempty(filename)
        filename = '';
end

if (num_opt_args == 0)
        hardcopy( window, filename, dev)
elseif (num_opt_args == 1)
        hardcopy( window, filename, dev, opt_arg1)
elseif (num_opt_args == 2)
        hardcopy( window, filename, dev, opt_arg1, opt_arg2)
elseif (num_opt_args == 3)
        hardcopy( window, filename, dev, opt_arg1, opt_arg2, opt_arg3)
elseif (num_opt_args == 4)
        hardcopy( window, filename, dev, opt_arg1, opt_arg2, opt_arg3, opt_arg4)
elseif (num_opt_args == 5)
        hardcopy( window, filename, dev, opt_arg1, opt_arg2, opt_arg3, opt_arg4, opt_arg5)
end


if ~prtSim
        % set color of lines and text back to what they were
        if ~isempty( lineTextColors )
                blt( window, get(window,'color'), lineTextColors);
        end

        % Invert back the W&B color properties of Figure and child objects
        if invertedColor
                cinvert( window );
        end

        % Reconstruct figure the way it was.
        if hasPreview 

                % Reconstruct figure the way it was.
                if prevResized
                        set( window, 'Position', frect )
                end
                set( window, 'units', origUnits );
                set( window, 'paperunits', origPaperUnits );

                if prevResized | invertedColor | ~isempty(lineTextColors)
                        drawnow;
                end

        elseif ((invertedColor | ~isempty( lineTextColors )) & ~strcmp(dev, '-dbitmap'))
                %
                % Discard all the object invalidations that occured as a result of
                % changing colors. All objects are back to their previous state,
                % but they don't know that.
                %
                drawnow('discard')
        end % hasPreview

end % ~prtSim

if ( devClass == 'GS' )

        rsp_file = [tempname '.rsp'];
        rsp_fid = fopen (rsp_file, 'w');
        if (rsp_fid < 0)
                error('Unable to create response file')
        end

        
        if (comp(1:2) =='PC')
                ghostDir = 'ghostscr';  
        else
                ghostDir = 'ghostscript';
        end

        fprintf(rsp_fid, '-dNOPAUSE -q \n');
        fprintf(rsp_fid, ['-I%s/' ghostDir '/ps_files\n'], matlabroot);
        fprintf(rsp_fid, ['-I%s/' ghostDir '/fonts\n'], matlabroot);
        fprintf(rsp_fid, '-sDEVICE=%s\n', ghostScriptDevice);

        if ~prtSim
                if ~strcmp( get(window,'papertype'), 'usletter' )
                        % Bug in Bubble Jet driver only allows the PAPERSIZE
                        % option for some paper types.
                        if (comp(1:2) == 'PC') ...
                                | ( strcmp( ghostScriptDevice, 'bj10e' ) & ...
                                        (       strcmp( get(window,'papertype'), 'a4letter' ) ...
                                        |       strcmp( get(window,'papertype'), 'a3' ) ...
                                        |       strcmp( get(window,'papertype'), 'a5' ) ...
                                        |       strcmp( get(window,'papertype'), 'b4' ) ))
                                if strcmp( get(window,'papertype'), 'uslegal' )
                                        fprintf(rsp_fid, '-sPAPERSIZE=legal\n');
                                elseif strcmp( get(window,'papertype'), 'a4letter' )
                                        fprintf(rsp_fid, '-sPAPERSIZE=a4\n' );
                                elseif strcmp( get(window,'papertype'), 'tabloid' )
                                        fprintf(rsp_fid, '-sPAPERSIZE=11x17\n' );
                                else
                                        % PaperType is same as names ghostscript uses
                                        fprintf(rsp_fid, '-sPAPERSIZE=%s\n', get(window,'papertype') );
                                end
                        end
                end
        end

        if (comp(1:2) =='PC')
                orig_dir = pwd;
                if (orig_filename1(2) == ':') | (orig_filename1(1)=='\')
                        fprintf(rsp_fid, '-sOutputFile=%s\n', orig_filename1 );
                else
                        fprintf(rsp_fid, '-sOutputFile=%s\n', [orig_dir '\' orig_filename1] );
                end
                fclose(rsp_fid);
                cd( [ matlabroot '\' ghostDir '\bin' ]);
                dos( [ 'gs386 @' rsp_file ' ' filename ' < NUL |' ] );
                cd (orig_dir);
        else    
                fprintf(rsp_fid, '-sOutputFile=%s\n', orig_filename1 );
                fclose(rsp_fid);
                status = unix( [ matlabroot '/' ghostDir '/bin/' getenv('ARCH') '/gs @' rsp_file ' '...
                         filename ' < /dev/null > /dev/null' ] );
                if (status)
                        error('GhostScript returned nonzero error status')
                end
        end

        delete(rsp_file)
        delete(filename)
        filename = orig_filename1;
end

if (printplot)
        lprcmd = printopt2;

        %If user specified a printer, add it to the printing command
        if ~isempty( printer )
                lprcmd = [ lprcmd printer ];
        end

        if (comp(1:2) == 'PC')
                cmd = sprintf(lprcmd, filename);
                dos(cmd);
                delete(filename);
        elseif (comp(1:3) =='MAC')
                macprint(window, filename, prtSim,1);
        elseif (strcmp(comp,'SGI') | strcmp(comp,'HP700') | strcmp(comp,'SOL2')),
                unix([lprcmd ' ' filename ';rm ' filename]);
        else
		unix([lprcmd ' ' filename]);
        end
end


