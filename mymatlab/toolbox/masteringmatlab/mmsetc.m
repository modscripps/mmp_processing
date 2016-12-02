function C=mmsetc(H,S)
%MMSETC Obtain an RGB Triple Interactively from a Color Sample.
% MMSETC displays a dialog box for the user to select
% a color interactively and displays the result.
%
% X = MMSETC returns the selected color in X.
%
% MMSETC([r g b]) uses the RGB triple as the initial
% RGB value for modification.
%
% MMSETC C  -or-
% MMSETC('C') where C is a color spec (y,m,c,r,g,b,w,k), uses 
% the specified color as the initial value.
%
% MMSETC(H) where the input argument H is the handle of
% a valid graphics object that supports color, uses the color
% property of the object as the initial RGB value.
%
% MMSETC select   -or- 
% MMSETC('select') waits for the user to click on a valid 
% graphics object that supports color, and uses the color
% property of the object as the initial RGB value.
%       
% If the initial RGB value was obtained from an object or
% object handle, the 'Done' pushbutton will apply the 
% resulting color property to the selected object.
%
% If no initial color is specified, black will be used.
%
% Examples:
%        mmsetc
%        mycolor=mmsetc
%        mmsetc([.25 .62 .54])
%        mmsetc(H)
%        mmsetc g
%        mmsetc red
%        mmsetc select
%        mycolor=mmsetc('select')
%

%   The second argument S is used internally to execute the callbacks.

% B.R. Littlefield, University of Maine, Orono, ME 04469
% 3/2/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

%======================================================================
% define some strings, and start error checking.
%======================================================================

global MMSETC_OUT MMSETC_DONE

ermsg1 = 'Too many input arguments.';
ermsg2 = 'Input argument if used must be an RGB triple or valid handle.';

if nargin > 2, error(ermsg1); end

%======================================================================
%  This section handles the 'no argument' case and sets the defaults.
%======================================================================

if nargin == 0 
  m = 0; 
  initrgb = [0 0 0];
  Hx_obj = 0;
end

%======================================================================
% Here the function was called with a single argument.  Check for 
% a valid RGB triple or an object handle and bail out if invalid.
% Set the initial color value if H is valid.
%======================================================================

if nargin == 1 

  %-------------------------------------------------------------------- 
  %  If H is 'select', get the color property of the selected object
  %  and use it for the initial color.
  %-------------------------------------------------------------------- 

  if isstr(H)
    m = 1;
    Hx_obj = 0;
    if strcmp(H,'select')
      waitforbuttonpress;
      Hx_obj = get(gcf,'CurrentObject');
      initrgb = get(Hx_obj,'Color');
      if isstr(initrgb)
        initrgb = [0 0 0];
      end
    elseif strcmp(H(1:1),'r'), initrgb = [1 0 0];
    elseif strcmp(H(1:1),'y'), initrgb = [1 1 0];
    elseif strcmp(H(1:1),'g'), initrgb = [0 1 0];
    elseif strcmp(H(1:1),'m'), initrgb = [0 1 1];
    elseif strcmp(H(1:1),'b'), initrgb = [0 0 1];
    elseif strcmp(H(1:1),'w'), initrgb = [1 1 1];
    elseif strcmp(H(1:1),'k'), initrgb = [0 0 0];
    else
      error(ermsg2); 
    end 
 
  %-------------------------------------------------------------------- 
  %  Otherwise H should be an RGB triple or an object handle.
  %-------------------------------------------------------------------- 

  else
    [n m]=size(H);
    if n ~= 1, error(ermsg2); end  
 
    %-------------------------------------------------------------------- 
    %  If H is a valid RGB row vector, use it for the initial color.
    %-------------------------------------------------------------------- 

    if m == 3 & max(H) <= 1 & min(H) >= 0  
      Hx_obj = 0;
      initrgb = H;
 
    %-------------------------------------------------------------------- 
    %  If H is a single number, it should be an object handle.
    %  If the object has no 'color' property, get() will exit 
    %  with an error message.
    %-------------------------------------------------------------------- 

    elseif m == 1   
      Hx_obj = H;
      initrgb = get(Hx_obj,'color');
      if isstr(initrgb)
        initrgb = [0 0 0];
      end
   
    %-------------------------------------------------------------------- 
    %  Otherwise, H is invalid, so bail out.
    %-------------------------------------------------------------------- 
  
    else
      error(ermsg2);
    end
  end
end
  
%======================================================================
% Do the initialization if this is a user call (zero or one arguments).
%======================================================================

if nargin < 2 

  MMSETC_OUT = initrgb;
  MMSETC_DONE = 0;

  %--------------------------------------------------------------------
  % First, get a figure window, and set some properties.
  %--------------------------------------------------------------------

  scr = get(0,'screensize');
  Hf_fig = figure('pos',[(scr(3)/2)-220 (scr(4)/2)-165 440 330],...  
    'color',[.75 .75 .75],...
    'numbertitle','off',...
    'name','Color Selector');

  %--------------------------------------------------------------------
  % Set some default properties for uicontrols in this figure.
  %--------------------------------------------------------------------

  set(Hf_fig,'DefaultUicontrolUnits','normalized',...
    'DefaultUicontrolBackgroundColor',get(Hf_fig,'color'));

  %--------------------------------------------------------------------
  % Now that we have an initial RGB value, get the initial HSV value
  % so we can initialize the sliders.
  %--------------------------------------------------------------------

  inithsv = rgb2hsv(initrgb);

  %--------------------------------------------------------------------
  % Define the 'initial' and 'new' color frames, and label them.
  %--------------------------------------------------------------------

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

  %--------------------------------------------------------------------
  % Get the color values, and display them under the frames.
  %--------------------------------------------------------------------

  Hc_icur = uicontrol(Hf_fig,'style','text',...
    'pos',[.25 .64 .25 .05],...
    'string',sprintf('[%.2f %.2f %.2f]',get(Hc_ifr,'backgroundcolor')));

  Hc_ncur = uicontrol(Hf_fig,'style','text',...
    'pos',[.50 .64 .25 .05],...
    'string',sprintf('[%.2f %.2f %.2f]',get(Hc_nfr,'backgroundcolor')));

  %--------------------------------------------------------------------
  % Define the sliders with labels and current value displays.
  %--------------------------------------------------------------------

  Hc_rsli = uicontrol(Hf_fig,'style','slider',...
    'pos',[.10 .55 .35 .05],...
    'min',0,'max',1,'val',initrgb(1),...
    'callback','mmsetc(0,''rgb2new'')');
    
  Hc_rcur = uicontrol(Hf_fig,'style','text',...
    'pos',[.01 .55 .08 .05],...
    'string',sprintf('%.2f',get(Hc_rsli,'val')));

  Hc_rlabel = uicontrol(Hf_fig,'style','text',...
    'pos',[.10 .49 .35 .05],...
    'string','Red');

  Hc_gsli = uicontrol(Hf_fig,'style','slider',...
    'pos',[.10 .43 .35 .05],...
    'min',0,'max',1,'val',initrgb(2),...
    'callback','mmsetc(0,''rgb2new'')');
    
  Hc_gcur = uicontrol(Hf_fig,'style','text',...
    'pos',[.01 .43 .08 .05],...
    'string',sprintf('%.2f',get(Hc_gsli,'val')));

  Hc_glabel = uicontrol(Hf_fig,'style','text',...
    'pos',[.10 .37 .35 .05],...
    'string','Green');

  Hc_bsli = uicontrol(Hf_fig,'style','slider',...
    'pos',[.10 .30 .35 .05],...
    'min',0,'max',1,'val',initrgb(3),...
    'callback','mmsetc(0,''rgb2new'')');
    
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
    'callback','mmsetc(0,''hsv2new'')');
    
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
    'callback','mmsetc(0,''hsv2new'')');
    
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
    'callback','mmsetc(0,''hsv2new'')');
    
  Hc_vcur = uicontrol(Hf_fig,'style','text',...
    'pos',[.91 .30 .08 .05],...
    'string',sprintf('%.2f',get(Hc_vsli,'val')));

  Hc_vlabel = uicontrol(Hf_fig,'style','text',...
    'pos',[.55 .24 .35 .05],...
    'string','Value');

  %--------------------------------------------------------------------
  % Define the 'initial' color selector popup, and label it.
  %--------------------------------------------------------------------

  Hc_pcolor = uicontrol(Hf_fig,'style','popupmenu',...
    'pos',[.05 .05 .20 .10],...
    'backgroundcolor',[.7 .7 .8],...
    'string','Black|Red|Yellow|Green|Cyan|Blue|Magenta|White|Initial',...
    'val',9,...
    'userdata',[[0 0 0];...
                [1 0 0];...
                [1 1 0];...
                [0 1 0];...
                [0 1 1];...
                [0 0 1];...
                [1 0 1];...
                [1 1 1];...
                    [0 0 0]],...
    'callback','mmsetc(0,''setinit'')');

  Hc_pclabel = uicontrol(Hf_fig,'style','text',...
    'pos',[.05 .15 .20 .05],...
    'string','Initial Color');

  %--------------------------------------------------------------------
  % Define the buttons for 'Copy', 'Cancel', and 'Done'.
  %--------------------------------------------------------------------

  Hc_copypb = uicontrol(Hf_fig,'style','push',...
    'pos',[.55 .05 .12 .10],...
    'backgroundcolor',[.7 .7 .8],...
    'string','Copy',...
    'callback','mmsetc(0,''copy'')');

  Hc_cancelpb = uicontrol(Hf_fig,'style','push',...
    'pos',[.70 .05 .12 .10],...
    'backgroundcolor',[.7 .7 .8],...
    'string','Cancel',...
    'callback','mmsetc(0,''cancel'')');

  Hc_donepb = uicontrol(Hf_fig,'style','push',...
    'pos',[.85 .05 .12 .10],...
    'backgroundcolor',[.7 .7 .8],...
    'string','Done',...
    'callback','mmsetc(0,''done'')');

  %--------------------------------------------------------------------
  % If an initial color was supplied, insert it into the popup data.
  %--------------------------------------------------------------------

  if m > 0
    tempdata = get(Hc_pcolor,'userdata');
    tempdata(get(Hc_pcolor,'val'),:) = initrgb;
    set(Hc_pcolor,'userdata',tempdata)
  end

  %--------------------------------------------------------------------
  % In order to pass the uicontrol handles to the callback section,
  % create a vector of object handles, and store it in the figure's
  % 'userdata' property.
  %--------------------------------------------------------------------

  Z = [Hx_obj, Hc_ifr, Hc_nfr, Hc_icur, Hc_ncur, Hc_rsli, Hc_rcur,...
       Hc_gsli, Hc_gcur, Hc_bsli, Hc_bcur, Hc_hsli, Hc_hcur, Hc_ssli,...
       Hc_scur, Hc_vsli, Hc_vcur, Hc_pcolor, Hf_fig];
  
  set(gcf,'userdata',Z);

  %--------------------------------------------------------------------
  % Now we wait for the user to select a color and return the new value. 
  % The 'drawnow' command flushes the event queue on most platforms.
  % The PC is an exception and requires 'waitforbuttonpress' instead.
  % Status values for MMSETC_DONE: 2=cancel; 1=done; 0=wait.
  %--------------------------------------------------------------------

  arch = computer;
  PC = strcmp(arch(1:2),'PC');

  while MMSETC_DONE == 0
    if PC, waitforbuttonpress; 
    else,  drawnow; 
    end
  end

  if MMSETC_DONE == 1    
    if nargout == 1
      C = MMSETC_OUT; 
    else
      disp(sprintf('Selected color: [%.4f %.4f %.4f]',MMSETC_OUT));
    end
  end
  close
  return
end

%======================================================================
% This section handles the callbacks.  Do some error checking,
% extract the object handles, and execute the callbacks.
%======================================================================

if nargin == 2
  if ~isstr(S), error(ermsg1); end

  %--------------------------------------------------------------------
  % Since the uicontrol handles were stored in the figure 'userdata'
  % property, extract them for use in the callback routines.
  %--------------------------------------------------------------------
  
  Z = get(gcf,'userdata');
  Hx_obj = Z(1);
  Hc_ifr = Z(2);
  Hc_nfr = Z(3);
  Hc_icur = Z(4);
  Hc_ncur = Z(5);
  Hc_rsli = Z(6);
  Hc_rcur = Z(7);
  Hc_gsli = Z(8);
  Hc_gcur = Z(9);
  Hc_bsli = Z(10);
  Hc_bcur = Z(11);
  Hc_hsli = Z(12);
  Hc_hcur = Z(13);
  Hc_ssli = Z(14);
  Hc_scur = Z(15);
  Hc_vsli = Z(16);
  Hc_vcur = Z(17);
  Hc_pcolor = Z(18);
  Hf_fig = Z(19);

  %--------------------------------------------------------------------
  % If 'cancel' was pressed, set the MMSETC_DONE flag to bail out.
  %--------------------------------------------------------------------

  if strcmp(S,'cancel')
    MMSETC_DONE = 2;

  %--------------------------------------------------------------------
  % If 'done' was pressed, save the new RGB triple and set the 
  % MMSETC_DONE flag. If the input arg was a valid object handle, 
  % change the color of the object. 
  %--------------------------------------------------------------------

  elseif strcmp(S,'done')
    MMSETC_OUT = get(Hc_nfr,'backgroundcolor');
    MMSETC_DONE = 1;
    if Hx_obj > 0
      set(eval('Hx_obj'),'color',get(Hc_nfr,'backgroundcolor')) 
    end

  %--------------------------------------------------------------------
  % If 'copy' was pressed, copy the color from the 'initial' frame
  % to the 'new' frame, and update the sliders and color values.
  %--------------------------------------------------------------------

  elseif strcmp(S,'copy')  
    set(Hc_nfr,'backgroundcolor',get(Hc_ifr,'backgroundcolor'))
    mmsetc(0,'setsli');

  %--------------------------------------------------------------------
  % This routine sets the sliders and color values from the 'new' frame.
  %--------------------------------------------------------------------

  elseif strcmp(S,'setsli') 
    rb=(get(Hc_nfr,'backgroundcolor'));
    set(Hc_ncur,'string',sprintf('[%.2f %.2f %.2f]',rb))
    set(Hc_rsli,'val',rb(1))
    set(Hc_rcur,'string',sprintf('%.2f',rb(1)))
    set(Hc_gsli,'val',rb(2))
    set(Hc_gcur,'string',sprintf('%.2f',rb(2)))
    set(Hc_bsli,'val',rb(3))
    set(Hc_bcur,'string',sprintf('%.2f',rb(3)))
    hv=rgb2hsv(rb);
    set(Hc_hsli,'val',hv(1))
    set(Hc_hcur,'string',sprintf('%.2f',hv(1)))
    set(Hc_ssli,'val',hv(2))
    set(Hc_scur,'string',sprintf('%.2f',hv(2)))
    set(Hc_vsli,'val',hv(3))
    set(Hc_vcur,'string',sprintf('%.2f',hv(3)))

  %--------------------------------------------------------------------
  % After an RGB slider has changed, update the 'new' frame from
  % the RGB slider values, and update sliders and text displays.
  %--------------------------------------------------------------------

  elseif strcmp(S,'rgb2new')   % set 'new' color from rgb sliders
    set(Hc_nfr,'backgroundcolor',...
      [get(Hc_rsli,'val'),get(Hc_gsli,'val'),get(Hc_bsli,'val')])
    mmsetc(0,'setsli');

  %--------------------------------------------------------------------
  % After an HSV slider has changed, update the 'new' frame from
  % the HSV slider values, and update sliders and text displays.
  %--------------------------------------------------------------------

  elseif strcmp(S,'hsv2new')
    rb=hsv2rgb([get(Hc_hsli,'val'),get(Hc_ssli,'val'),get(Hc_vsli,'val')]);
    set(Hc_nfr,'backgroundcolor',rb) 
    mmsetc(0,'setsli');

  %--------------------------------------------------------------------
  % Set the 'initial' frame color from the popup selection.
  %--------------------------------------------------------------------

  elseif strcmp(S,'setinit')
    ud=get(Hc_pcolor,'userdata');
    set(Hc_ifr,'backgroundcolor',ud(get(Hc_pcolor,'val'),:))
    set(Hc_icur,'string',...
      sprintf('[%.2f %.2f %.2f]',get(Hc_ifr,'backgroundcolor')))

  %--------------------------------------------------------------------
  % If the string S is not one of the above, it is in error.
  %--------------------------------------------------------------------

  else
    error(ermsg1);
  end

  %--------------------------------------------------------------------
  % Since this is a callback, return to the calling function.
  %--------------------------------------------------------------------

  return
end

