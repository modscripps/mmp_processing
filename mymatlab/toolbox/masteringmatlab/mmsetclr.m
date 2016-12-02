%MMSETCLR Obtain an RGB triple interactively from a color sample.
% MMSETCLR displays a dialog box for the user to select
% a color interactively and displays the RGB triple value of
% the new color.
%
% Example:
%     mmsetclr
%

% B.R. Littlefield, University of Maine, Orono ME 04469
% 3/30/95
% Copyright (c) 1996 Prentice Hall, Inc.

%======================================================================
% Set initial RGB and HSV values, get a new figure window, and set
% some figure properties (position, color, and title).
%======================================================================

initrgb = [0 0 0];
inithsv = rgb2hsv(initrgb);

scr = get(0,'screensize');
Hf_fig=figure;

set(Hf_fig,'pos',[(scr(3)/2)-220 (scr(4)/2)-165 440 330],...
  'color',[.75 .75 .75],...
  'numbertitle','off',...
  'name','Color Selector');

%======================================================================
% Set some default properties for uicontrols in this figure.
%======================================================================

set(Hf_fig,'DefaultUicontrolUnits','normalized',...
  'DefaultUicontrolBackgroundColor',get(Hf_fig,'color'));

%======================================================================
% Define the 'initial' and 'new' color frames, and label them.
%======================================================================

Hc_ifr = uicontrol(Hf_fig,'style','frame',...
  'pos',[.25 .70 .25 .20],...
  'backgroundcolor',initrgb);
 
Hc_nfr = uicontrol(Hf_fig,'style','frame',...
  'pos',[.50 .70 .25 .20],...
  'backgroundcolor',initrgb); 

Hc_ilabel = uicontrol(Hf_fig,'style','text',...
  'pos',[.25 .91 .25 .05],...
  'string','Initial Color');

Hc_nlabel = uicontrol(Hf_fig,'style','text',...
  'pos',[.50 .91 .25 .05],...
  'string','New Color');

%======================================================================
% Get the color values, and display them under the frames.
%======================================================================
 
Hc_icur = uicontrol(Hf_fig,'style','text',...
  'pos',[.25 .64 .25 .05],...
  'string',sprintf('[%.2f %.2f %.2f]',get(Hc_ifr,'backgroundcolor')));

Hc_ncur = uicontrol(Hf_fig,'style','text',...
  'pos',[.50 .64 .25 .05],...
  'string',sprintf('[%.2f %.2f %.2f]',get(Hc_nfr,'backgroundcolor')));

%======================================================================
% Define the sliders with labels and current value displays.
% The slider callbacks set the new color from the appropriate
% RGB or HSV slider set, and update the other slider values.
%======================================================================

Hc_rsli = uicontrol(Hf_fig,'style','slider',...
  'pos',[.10 .55 .35 .05],...
  'min',0,'max',1,'val',initrgb(1),...
  'callback',[...
    'set(Hc_nfr,''backgroundcolor'',',...
      '[get(Hc_rsli,''val''),get(Hc_gsli,''val''),get(Hc_bsli,''val'')]),',...
    'set(Hc_ncur,''string'',',...
      'sprintf(''[%.2f %.2f %.2f]'',get(Hc_nfr,''backgroundcolor''))),',...
    'hv=rgb2hsv(get(Hc_nfr,''backgroundcolor''));',...
    'set(Hc_hsli,''val'',hv(1)),',...
    'set(Hc_hcur,''string'',sprintf(''%.2f'',hv(1))),',...
    'set(Hc_ssli,''val'',hv(2)),',...
    'set(Hc_scur,''string'',sprintf(''%.2f'',hv(2))),',...
    'set(Hc_vsli,''val'',hv(3)),',...
    'set(Hc_vcur,''string'',sprintf(''%.2f'',hv(3))),',...
    'set(Hc_rcur,''string'',sprintf(''%.2f'',get(Hc_rsli,''val'')))']);
  
Hc_rcur = uicontrol(Hf_fig,'style','text',...
  'pos',[.01 .55 .08 .05],...
  'string',sprintf('%.2f',get(Hc_rsli,'val')));

Hc_rlabel = uicontrol(Hf_fig,'style','text',...
  'pos',[.10 .49 .35 .05],...
  'string','Red');

Hc_gsli = uicontrol(Hf_fig,'style','slider',...
  'pos',[.10 .43 .35 .05],...
  'min',0,'max',1,'val',initrgb(2),...
  'callback',[...
    'set(Hc_nfr,''backgroundcolor'',',...
       '[get(Hc_rsli,''val''),get(Hc_gsli,''val''),get(Hc_bsli,''val'')]),',...
    'set(Hc_ncur,''string'',',...
      'sprintf(''[%.2f %.2f %.2f]'',get(Hc_nfr,''backgroundcolor''))),',...
    'hv=rgb2hsv(get(Hc_nfr,''backgroundcolor''));',...
    'set(Hc_hsli,''val'',hv(1)),',...
    'set(Hc_hcur,''string'',sprintf(''%.2f'',hv(1))),',...
    'set(Hc_ssli,''val'',hv(2)),',...
    'set(Hc_scur,''string'',sprintf(''%.2f'',hv(2))),',...
    'set(Hc_vsli,''val'',hv(3)),',...
    'set(Hc_vcur,''string'',sprintf(''%.2f'',hv(3))),',...
    'set(Hc_gcur,''string'',sprintf(''%.2f'',get(Hc_gsli,''val'')))']);
  
Hc_gcur = uicontrol(Hf_fig,'style','text',...
  'pos',[.01 .43 .08 .05],...
  'string',sprintf('%.2f',get(Hc_gsli,'val')));

Hc_glabel = uicontrol(Hf_fig,'style','text',...
  'pos',[.10 .37 .35 .05],...
  'string','Green');

Hc_bsli = uicontrol(Hf_fig,'style','slider',...
  'pos',[.10 .30 .35 .05],...
  'min',0,'max',1,'val',initrgb(3),...
  'callback',[...
    'set(Hc_nfr,''backgroundcolor'',',...
       '[get(Hc_rsli,''val''),get(Hc_gsli,''val''),get(Hc_bsli,''val'')]),',...
    'set(Hc_ncur,''string'',',...
      'sprintf(''[%.2f %.2f %.2f]'',get(Hc_nfr,''backgroundcolor''))),',...
    'hv=rgb2hsv(get(Hc_nfr,''backgroundcolor''));',...
    'set(Hc_hsli,''val'',hv(1)),',...
    'set(Hc_hcur,''string'',sprintf(''%.2f'',hv(1))),',...
    'set(Hc_ssli,''val'',hv(2)),',...
    'set(Hc_scur,''string'',sprintf(''%.2f'',hv(2))),',...
    'set(Hc_vsli,''val'',hv(3)),',...
    'set(Hc_vcur,''string'',sprintf(''%.2f'',hv(3))),',...
    'set(Hc_bcur,''string'',sprintf(''%.2f'',get(Hc_bsli,''val'')))']);
  
Hc_bcur = uicontrol(Hf_fig,'style','text',...
  'pos',[.01 .30 .08 .05],...
  'string',sprintf('%.2f',get(Hc_bsli,'val')));

Hc_blabel = uicontrol(Hf_fig,'style','text',...
  'pos',[.10 .24 .35 .05],...
  'string','Blue');

Hc_hsli = uicontrol(Hf_fig,'style','slider',...
  'pos',[.55 .55 .35 .05],...
  'min',0,'max',1,...
  'val',inithsv(1),...
  'callback',['rb=hsv2rgb(',...
       '[get(Hc_hsli,''val''),get(Hc_ssli,''val''),get(Hc_vsli,''val'')]);',...
    'set(Hc_nfr,''backgroundcolor'',rb),',...
    'set(Hc_ncur,''string'',sprintf(''[%.2f %.2f %.2f]'',rb)),',...
    'set(Hc_rsli,''val'',rb(1)),',...
    'set(Hc_rcur,''string'',sprintf(''%.2f'',rb(1))),',...
    'set(Hc_gsli,''val'',rb(2)),',...
    'set(Hc_gcur,''string'',sprintf(''%.2f'',rb(2))),',...
    'set(Hc_bsli,''val'',rb(3)),',...
    'set(Hc_bcur,''string'',sprintf(''%.2f'',rb(3))),',...
    'set(Hc_hcur,''string'',sprintf(''%.2f'',get(Hc_hsli,''val'')))']);
  
Hc_hcur = uicontrol(Hf_fig,'style','text',...
  'pos',[.91 .55 .08 .05],...
  'string',sprintf('%.2f',get(Hc_hsli,'val')));

Hc_hlabel = uicontrol(Hf_fig,'style','text',...
  'pos',[.55 .49 .35 .05],...
  'string','Hue');

Hc_ssli = uicontrol(Hf_fig,'style','slider',...
  'pos',[.55 .43 .35 .05],...
  'min',0,'max',1,...
  'val',inithsv(2),...
  'callback',['rb=hsv2rgb(',...
      '[get(Hc_hsli,''val''),get(Hc_ssli,''val''),get(Hc_vsli,''val'')]);',...
    'set(Hc_nfr,''backgroundcolor'',rb),',...
    'set(Hc_ncur,''string'',sprintf(''[%.2f %.2f %.2f]'',rb)),',...
    'set(Hc_rsli,''val'',rb(1)),',...
    'set(Hc_rcur,''string'',sprintf(''%.2f'',rb(1))),',...
    'set(Hc_gsli,''val'',rb(2)),',...
    'set(Hc_gcur,''string'',sprintf(''%.2f'',rb(2))),',...
    'set(Hc_bsli,''val'',rb(3)),',...
    'set(Hc_bcur,''string'',sprintf(''%.2f'',rb(3))),',...
    'set(Hc_scur,''string'',sprintf(''%.2f'',get(Hc_ssli,''val'')))']);
  
Hc_scur = uicontrol(Hf_fig,'style','text',...
  'pos',[.91 .43 .08 .05],...
  'string',sprintf('%.2f',get(Hc_ssli,'val')));

Hc_slabel = uicontrol(Hf_fig,'style','text',...
  'pos',[.55 .37 .35 .05],...
  'string','Saturation');

Hc_vsli = uicontrol(Hf_fig,'style','slider',...
  'pos',[.55 .30 .35 .05],...
  'min',0,'max',1,...
  'val',inithsv(3),...
  'callback',['rb=hsv2rgb(',...
      '[get(Hc_hsli,''val''),get(Hc_ssli,''val''),get(Hc_vsli,''val'')]);',...
    'set(Hc_nfr,''backgroundcolor'',rb),',...
    'set(Hc_ncur,''string'',sprintf(''[%.2f %.2f %.2f]'',rb)),',...
    'set(Hc_rsli,''val'',rb(1)),',...
    'set(Hc_rcur,''string'',sprintf(''%.2f'',rb(1))),',...
    'set(Hc_gsli,''val'',rb(2)),',...
    'set(Hc_gcur,''string'',sprintf(''%.2f'',rb(2))),',...
    'set(Hc_bsli,''val'',rb(3)),',...
    'set(Hc_bcur,''string'',sprintf(''%.2f'',rb(3))),',...
    'set(Hc_vcur,''string'',sprintf(''%.2f'',get(Hc_vsli,''val'')))']);
  
Hc_vcur = uicontrol(Hf_fig,'style','text',...
  'pos',[.91 .30 .08 .05],...
  'string',sprintf('%.2f',get(Hc_vsli,'val')));

Hc_vlabel = uicontrol(Hf_fig,'style','text',...
  'pos',[.55 .24 .35 .05],...
  'string','Value');

%======================================================================
% Define the 'initial' color selector popup, and label it.
% The callbacks update the 'initial' color frame and value
% from the appropriate userdata entry.
%======================================================================

Hc_pcolor = uicontrol(Hf_fig,'style','popupmenu',...
  'pos',[.05 .05 .20 .10],...
  'backgroundcolor',[.7 .7 .8],...
  'string','Black|Red|Yellow|Green|Cyan|Blue|Magenta|White',...
  'userdata',[[0 0 0];...
              [1 0 0];...
              [1 1 0];...
              [0 1 0];...
              [0 1 1];...
              [0 0 1];...
              [1 0 1];...
              [1 1 1]],...
  'callback',[...
     'ud=get(Hc_pcolor,''userdata'');',...
     'set(Hc_ifr,''backgroundcolor'',ud(get(Hc_pcolor,''val''),:)),',...
     'set(Hc_icur,''string'',',...
       'sprintf(''[%.2f %.2f %.2f]'',get(Hc_ifr,''backgroundcolor'')))']);

Hc_pclabel = uicontrol(Hf_fig,'style','text',...
  'pos',[.05 .15 .20 .05],...
  'string','Initial Color');

%======================================================================
% Define the buttons for 'Copy', 'Cancel', and 'Done'.
% 'Copy' copies the 'initial' color to the 'new' color, and
% updates all the sliders and values appropriately.
%======================================================================

Hc_copypb = uicontrol(Hf_fig,'style','push',...
  'pos',[.55 .05 .12 .10],...
  'backgroundcolor',[.7 .7 .8],...
  'string','Copy',...
  'callback',[...
    'rb=(get(Hc_ifr,''backgroundcolor''));',...
    'set(Hc_nfr,''backgroundcolor'',rb),',...
    'set(Hc_ncur,''string'',sprintf(''[%.2f %.2f %.2f]'',rb)),',...
    'set(Hc_rsli,''val'',rb(1)),',...
    'set(Hc_rcur,''string'',sprintf(''%.2f'',rb(1))),',...
    'set(Hc_gsli,''val'',rb(2)),',...
    'set(Hc_gcur,''string'',sprintf(''%.2f'',rb(2))),',...
    'set(Hc_bsli,''val'',rb(3)),',...
    'set(Hc_bcur,''string'',sprintf(''%.2f'',rb(3))),',...
    'hv=rgb2hsv(rb);',...
    'set(Hc_hsli,''val'',hv(1)),',...
    'set(Hc_hcur,''string'',sprintf(''%.2f'',hv(1))),',...
    'set(Hc_ssli,''val'',hv(2)),',...
    'set(Hc_scur,''string'',sprintf(''%.2f'',hv(2))),',...
    'set(Hc_vsli,''val'',hv(3)),',...
    'set(Hc_vcur,''string'',sprintf(''%.2f'',hv(3)))']);
  
Hc_cancelpb = uicontrol(Hf_fig,'style','push',...
  'pos',[.70 .05 .12 .10],...
  'backgroundcolor',[.7 .7 .8],...
  'string','Cancel',...
  'callback',[...
    'close,return']);

Hc_donepb = uicontrol(Hf_fig,'style','push',...
  'pos',[.85 .05 .12 .10],...
  'backgroundcolor',[.7 .7 .8],...
  'string','Done',...
  'callback',[...
    'disp(sprintf(''Selected color: [%.4f %.4f %.4f]'',',...
      'get(Hc_nfr,''backgroundcolor''))),',...
    'close,return']);

