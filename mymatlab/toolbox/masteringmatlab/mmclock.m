function T=mmclock(X,Y)
%MMCLOCK Place a digital clock on the screen.
%  MMCLOCK places a digital clock at the upper right corner 
%  of the display screen.
%  MMCLOCK(X,Y) places a digital clock at position X pixels
%  to the right and Y pixels above the bottom of the screen.
%  T=MMCLOCK returns the current date and time as a string
%  when 'Close' is pressed.

% B.R. Littlefield, University of Maine, Orono ME 04469
% 5/30/95
% Copyright (c) 1996 Prentice Hall, Inc.

fsize = [200 150]; sec = 1; mil = 0;
mstr = ['Jan';'Feb';'Mar';'Apr';'May';'Jun'
        'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
scr = get(0,'ScreenSize');

if nargin == 0
    figpos = [scr(3)-fsize(1)-20 scr(4)-fsize(2)-5 fsize(1:2)];
elseif nargin == 2
    figpos = [X Y fsize(1:2)];
else
    error('Invalid Arguments');
end

% Create the figure and set control defaults for this figure.

Hf_clock = figure('Position',figpos',...
        'Color',[.7 .7 .7],...
        'NumberTitle','off',...
        'Name','Digital Clock');

set(Hf_clock,'DefaultUicontrolUnits','normalized',...
        'DefaultUicontrolBackgroundColor',get(Hf_clock,'Color'));

% Create the pushbutton and radio buttons.

Hc_close = uicontrol('Style','push',...
        'Position',[.65 .05 .30 .30],...
        'BackgroundColor',[.8 .8 .9],...
        'String','Close',...
        'CallBack','close(gcf)');

Hc_sec = uicontrol('Style','radiobutton',...
        'Position',[.05 .05 .50 .13],...
        'Value',sec,...
        'String','Seconds');

Hc_mil = uicontrol('Style','checkbox',...
        'Position',[.05 .22 .50 .13],...
        'Value',mil,...
        'String','24-Hour');

% Create the text frames and text strings.

Hc_dframe = uicontrol('Style','frame','Position',[.04 .71 .92 .24]);
Hc_date   = uicontrol('Style','text', 'Position',[.05 .72 .90 .22]);

Hc_tframe = uicontrol('Style','frame','Position',[.04 .41 .92 .24]);
Hc_time   = uicontrol('Style','text', 'Position',[.05 .42 .90 .22]);

% Loop until the close button is pressed and the figure disappears.

while find(get(0,'Children') == Hf_clock)
    sec = get(Hc_sec,'Value');
    mil = get(Hc_mil,'Value');
    now = fix(clock);
    datestr = sprintf('%s %2d, %4d',mstr(now(2),:),now(3),now(1));
    timestr = [num2str(now(4)) ':' sprintf('%02d',now(5))];
    if sec
        timestr = [timestr ':' sprintf('%02d',now(6))];
    end
    if mil
        suffix = '';
    else
        if now(4) > 12
            suffix = ' PM';
            now(4) = rem(now(4),12);
        else
            suffix = ' AM';
        end
    end
    timestr = [timestr suffix];
    set(Hc_date,'String',datestr);
    set(Hc_time,'String',timestr);
    pause(1)
end

% If output was desired, return a Date-Time string.

if nargout
    T = [datestr ' - ' timestr];
end
     
