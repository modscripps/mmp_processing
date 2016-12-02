function C=mmsetf(H,S)
%MMSETF Choose Font Characteristics Interactively.
% MMSETF displays a dialog box for the user to select
% font characteristics.
%
% X = MMSETF returns the handle of the text object or 0 
%     if an error occurs or 'Cancel' is pressed.
%
% MMSETF(H) where the input argument H is the handle of
% a valid text or axes object, uses the font characteristics
% of the object as the initial values.
%
% MMSETF select   -or- 
% MMSETF('select') waits for the user to click on a valid 
% graphics object, and uses the font characteristics
% of the object as the initial values.
%       
% If the initial values were obtained from an object or
% object handle, the 'Done' pushbutton will apply the 
% resulting text properties to the selected object.
%
% If no initial object handle is specified, a zero is returned in X.
%
% Examples:
%        mmsetf
%        mmsetf(H)
%        mmsetf select
%        Hx_obj=mmsetf('select')
%

%   The second argument S is used internally to execute the callbacks.

% B.R. Littlefield, University of Maine, Orono ME 04469
% 5/24/95
% Copyright (c) 1996 Prentice Hall, Inc.

%======================================================================
% define some strings, and start error checking.
%======================================================================

global MMSETF_OUT MMSETF_DONE FNAME FSIZE FWEIGHT FANGLE

ermsg1 = 'Too many input arguments.';
ermsg2 = 'Input argument must be ''select'' or a text or axes handle.';

if nargin > 2, error(ermsg1); end

%======================================================================
%  This section handles the 'no argument' case and sets the defaults.
%======================================================================

if nargin == 0 
  FNAME = get(0,'DefaultTextFontName');
  FSIZE = get(0,'DefaultTextFontSize');
  FWEIGHT = get(0,'DefaultTextFontWeight');
  FANGLE = get(0,'DefaultTextFontAngle');
  Hx_obj = 0;
end

%======================================================================
% Here the function was called with a single argument.  Check for 
% a valid string or object handle and bail out if invalid.
% Set the initial values if H is valid.
%======================================================================

if nargin == 1 

  %-------------------------------------------------------------------- 
  %  If H is 'select', get the handle of the selected object.
  %-------------------------------------------------------------------- 

  if isstr(H)
    if strcmp(H,'select')
      waitforbuttonpress;
      Hx_obj = get(gcf,'CurrentObject');
    else
      error(ermsg2); 
    end 

  %-------------------------------------------------------------------- 
  %  Get the properties of the selected object and use them for the 
  %  initial values.
  %-------------------------------------------------------------------- 

  else
    Hx_obj = H;
  end

  if strcmp(get(Hx_obj,'Type'),'text') | strcmp(get(Hx_obj,'Type'),'axes')
    FNAME = get(Hx_obj,'FontName');
    FSIZE = get(Hx_obj,'FontSize');
    FWEIGHT = get(Hx_obj,'FontWeight');
    FANGLE = get(Hx_obj,'FontAngle');
  else
    error('Not a valid text or axes object.');
  end
end
  
%======================================================================
% Do the initialization if this is a user call (zero or one arguments).
%======================================================================

if nargin < 2 

  MMSETF_OUT = Hx_obj;
  MMSETF_DONE = 0;

  fslist = [10 12 14 18 24];
  fsstring = '10|12|14|18|24';
  fwlist = ['Normal';'Bold  '];
  fwstring = 'Normal|Bold';
  falist = ['Normal';'Italic'];
  fastring = 'Normal|Italic';
  fnlist = ['Courier  '
            'Fixed    '
            'Helvetica'
            'Symbol   '
            'Times    '];
  fnstring = 'Courier|Fixed|Helvetica|Symbol|Times';

  [m,n] = size(fnlist);
  fnstart = 0;
  for k=1:m
    if strcmp(strtok(fnlist(k,:)),strtok(FNAME))
      fnstart = k;
    end
  end
  if fnstart == 0
    fnstring = [fnstring,'|',strtok(FNAME)];
    FNAME = [FNAME,blanks(n-length(FNAME))];
    FNAME = FNAME(1:n);
    fnlist = [fnlist;FNAME];
    m = m+1;
    fnstart = m;
  end
  fsstart = find(fslist==FSIZE);
  if isempty(fsstart)
    fsstart = 2;
  end
  if lower(FWEIGHT(1)) == 'n'
    fwstart = 1;
  else
    fwstart = 2;
  end
  if lower(FANGLE(1)) == 'n'
    fastart = 1;
  else
    fastart = 2;
  end

  %--------------------------------------------------------------------
  % First, get a figure window, and set some properties.
  %--------------------------------------------------------------------

  ftitle = get(Hx_obj,'Type');
  ftitle(1) = upper(ftitle(1));
  if strcmp(ftitle,'Root')
    ftitle = 'Sample';
  end
  ftitle = [ftitle ' Font Selector'];
  scr = get(0,'screensize');
  Hf_fig = figure('pos',[(scr(3)/2)-220 (scr(4)/2)-165 440 230],...  
    'color',[.70 .70 .70],...
    'numbertitle','off',...
    'name',ftitle);

  %--------------------------------------------------------------------
  % Set some default properties for uicontrols in this figure.
  %--------------------------------------------------------------------

  set(Hf_fig,'DefaultUicontrolUnits','normalized',...
    'DefaultUicontrolBackgroundColor',get(Hf_fig,'color'));

  %--------------------------------------------------------------------
  % Define the font name popup, and label it.
  %--------------------------------------------------------------------

  Hc_name = uicontrol(Hf_fig,'style','popupmenu',...
    'pos',[.05 .75 .20 .10],...
    'backgroundcolor',[.7 .7 .8],...
    'string',fnstring,...
    'val',fnstart,...
    'userdata',fnlist,...
    'callback','mmsetf(0,''setname'')');

  Hc_namelabel = uicontrol(Hf_fig,'style','text',...
    'pos',[.05 .87 .20 .07],...
    'string','Font Name');

  %--------------------------------------------------------------------
  % Define the font size popup, and label it.
  %--------------------------------------------------------------------

  Hc_size = uicontrol(Hf_fig,'style','popupmenu',...
    'pos',[.05 .45 .20 .10],...
    'backgroundcolor',[.7 .7 .8],...
    'string',fsstring,...
    'val',fsstart,...
    'userdata',fslist,...
    'callback','mmsetf(0,''setsize'')');

  Hc_sizelabel = uicontrol(Hf_fig,'style','text',...
    'pos',[.05 .57 .20 .07],...
    'string','Font Size');

  %--------------------------------------------------------------------
  % Define the font weight popup, and label it.
  %--------------------------------------------------------------------

  Hc_weight = uicontrol(Hf_fig,'style','popupmenu',...
    'pos',[.35 .75 .20 .10],...
    'backgroundcolor',[.7 .7 .8],...
    'string',fwstring,...
    'val',fwstart,...
    'userdata',fwlist,...
    'callback','mmsetf(0,''setweight'')');

  Hc_weightlabel = uicontrol(Hf_fig,'style','text',...
    'pos',[.35 .87 .20 .07],...
    'string','Font Weight');

  %--------------------------------------------------------------------
  % Define the font angle popup, and label it.
  %--------------------------------------------------------------------

  Hc_angle = uicontrol(Hf_fig,'style','popupmenu',...
    'pos',[.35 .45 .20 .10],...
    'backgroundcolor',[.7 .7 .8],...
    'string',fastring,...
    'val',fastart,...
    'userdata',falist,...
    'callback','mmsetf(0,''setangle'')');

  Hc_anglelabel = uicontrol(Hf_fig,'style','text',...
    'pos',[.35 .57 .20 .07],...
    'string','Font Angle');

  %--------------------------------------------------------------------
  % Define the frame and buttons for 'Cancel' and 'Done'.
  %--------------------------------------------------------------------

  Hc_bframe = uicontrol(Hf_fig,'style','frame',...
    'pos',[.70 .42 .22 .50]);

  Hc_cancelpb = uicontrol(Hf_fig,'style','push',...
    'pos',[.75 .71 .12 .15],...
    'backgroundcolor',[.7 .7 .8],...
    'string','Cancel',...
    'callback','mmsetf(0,''cancel'')');

  Hc_donepb = uicontrol(Hf_fig,'style','push',...
    'pos',[.75 .49 .12 .15],...
    'backgroundcolor',[.7 .7 .8],...
    'string','Done',...
    'callback','mmsetf(0,''done'')');

  %--------------------------------------------------------------------
  % Define the axis and sample text box.
  %--------------------------------------------------------------------

  Ha_axis = axes(...
    'visible','off');
  
  if strcmp(get(Hx_obj,'Type'),'text')
    tstring = get(Hx_obj,'String');
  else
    tstring = 'This is a sample text string.';
  end

  Ht_text = text(.05,.10,tstring);

  set(Ht_text, 'color',[0 0 0],...
    'Visible','on',...
    'FontName',strtok(FNAME),...
    'FontSize',FSIZE,...
    'FontWeight',FWEIGHT,...
    'FontAngle',FANGLE,...
    'horizontalalignment','left');

  %--------------------------------------------------------------------
  % In order to pass the uicontrol handles to the callback section,
  % create a vector of object handles, and store it in the figure's
  % 'userdata' property.
  %--------------------------------------------------------------------

  Z = [Hc_name, Hc_size, Hc_weight, Hc_angle, Ht_text, Hf_fig];
  
  set(gcf,'userdata',Z);

  %--------------------------------------------------------------------
  % Now we wait for the user to select a color and return the new value. 
  % The 'drawnow' command flushes the event queue on most platforms.
  % The PC is an exception and requires 'waitforbuttonpress' instead.
  % Status values for MMSETF_DONE: 2=cancel; 1=done; 0=wait.
  %--------------------------------------------------------------------

  arch = computer;
  PC = strcmp(arch(1:2),'PC');

  while MMSETF_DONE == 0
    if PC, waitforbuttonpress; 
    else,  drawnow; 
    end
  end

  if MMSETF_DONE == 1    
    if nargout == 1
      C = MMSETF_OUT; 
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
  Hc_name = Z(1);
  Hc_size = Z(2);
  Hc_weight = Z(3);
  Hc_angle = Z(4);
  Ht_text = Z(5);
  Hc_fig = Z(6);

  %--------------------------------------------------------------------
  % If 'cancel' was pressed, set the MMSETF_DONE flag to bail out.
  %--------------------------------------------------------------------

  if strcmp(S,'cancel')
    MMSETF_DONE = 2;

  %--------------------------------------------------------------------
  % If 'done' was pressed, save the new values and set the 
  % MMSETF_DONE flag. If the input arg was a valid object handle, 
  % apply the properties to the object. 
  %--------------------------------------------------------------------

  elseif strcmp(S,'done')
    MMSETF_DONE = 1;
    if MMSETF_OUT > 0
      fnlist = get(Hc_name,'UserData');
      fslist = get(Hc_size,'UserData');
      fwlist = get(Hc_weight,'UserData');
      falist = get(Hc_angle,'UserData');
      set(eval('MMSETF_OUT'),...
         'FontName',strtok(FNAME),...
         'FontSize',FSIZE,...
         'FontWeight',FWEIGHT,...
         'FontAngle',FANGLE);
    end


  %--------------------------------------------------------------------
  % Set the font name.
  %--------------------------------------------------------------------

  elseif strcmp(S,'setname')
    fnlist = get(Hc_name,'userdata');
    FNAME = strtok(fnlist(get(Hc_name,'Value'),:));
    set(Ht_text,'FontName',FNAME);

  %--------------------------------------------------------------------
  % Set the font size.
  %--------------------------------------------------------------------

  elseif strcmp(S,'setsize')
    fslist = get(Hc_size,'userdata');
    FSIZE = fslist(get(Hc_size,'Value'));
    set(Ht_text,'FontSize',FSIZE);

  %--------------------------------------------------------------------
  % Set the font weight.
  %--------------------------------------------------------------------

  elseif strcmp(S,'setweight')
    fwlist = get(Hc_weight,'userdata');
    FWEIGHT = fwlist(get(Hc_weight,'Value'));
    set(Ht_text,'FontWeight',FWEIGHT);

  %--------------------------------------------------------------------
  % Set the font angle.
  %--------------------------------------------------------------------

  elseif strcmp(S,'setangle')
    falist = get(Hc_angle,'userdata');
    FANGLE = falist(get(Hc_angle,'Value'));
    set(Ht_text,'FontAngle',FANGLE);

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

