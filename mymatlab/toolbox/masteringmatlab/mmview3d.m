function mmview3d(cmd)
%MMVIEW3D GUI Controlled Azimuth and Elevation Adjustment.
% MMVIEW3D adds sliders and text boxes to the current figure window
% for adjusting azimuth and elevation using the mouse.
%
% The 'Revert' pushbutton reverts to the original view.
% The 'Done' pushbutton removes all GUIs.

% The 'cmd' argument executes the callbacks.

% B.R. Littlefield, University of Maine, Orono, ME 04469
% 4/11/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

global Hc_asli Hc_acur Hc_esli Hc_ecur CVIEW

%======================================================================
% If this is a user call, create the uicontrols.
%======================================================================

if nargin == 0

  %--------------------------------------------------------------------
  % Assign a handle to the current figure window.
  % Get the current view for slider initial values.
  % If the view is out of range, adjust as best we can.
  % Use normalized uicontrol units rather than the default 'pixels'.
  %--------------------------------------------------------------------

  Hf_fig = gcf;
  CVIEW = get(gca,'View');
  if abs(CVIEW(1))>180, CVIEW(1)=CVIEW(1)-(360*sign(CVIEW(1))); end
  set(Hf_fig,'DefaultUicontrolUnits','normalized');

  %--------------------------------------------------------------------
  % Define azimuth and elevation sliders.
  % The position is in normalized units (0-1).  
  % Maximum, minimum, and initial values are set.
  %--------------------------------------------------------------------
  
  Hc_asli = uicontrol( Hf_fig,'style','slider',...
    'position',[.09 .02 .3 .05],...
    'min',-180,'max',180,'value',CVIEW(1),...
    'callback','mmview3d(991)');
  
  Hc_esli = uicontrol( Hf_fig,'style','slider',...
    'position',[.92 .5 .04 .42],...
    'min',-90,'max',90,'val',CVIEW(2),...
    'callback','mmview3d(992)');
  
  %--------------------------------------------------------------------
  % Place the text boxes showing the minimum and max values at the
  % ends of each slider.  These are text displays, and cannot be edited.
  %--------------------------------------------------------------------
  
  uicontrol(Hf_fig,'style','text',...
    'pos',[.02 .02 .07 .05],...
    'string',num2str(get(Hc_asli,'min')));
  
  uicontrol(Hf_fig,'style','text',...
    'pos',[.39 .02 .07 .05],...
    'string',num2str(get(Hc_asli,'max')));
  
  uicontrol(Hf_fig,'style','text',...
    'pos',[.915 .45 .05 .05],...
    'string',num2str(get(Hc_esli,'min')));
  
  uicontrol(Hf_fig,'style','text',...
    'pos',[.915 .92 .05 .05],...
    'string',num2str(get(Hc_esli,'max')));
  
  %--------------------------------------------------------------------
  % Place labels for each slider
  %--------------------------------------------------------------------
  
  uicontrol(Hf_fig,'style','text',...
    'pos',[.095 .08 .15 .05],...
    'string','Azimuth');
  
  uicontrol(Hf_fig,'style','text',...
    'pos',[.885 .39 .11 .05],...
    'string','Elevation');
  
  %--------------------------------------------------------------------
  % Define the current value text displays for each slider.
  %--------------------------------------------------------------------
  % These are editable text displays to display the current value
  % of the slider and at the same time allow the user to enter
  % a value using the keyboard.
  %
  % Note that on the text is centered on X Window Systems, but is
  % left-justified on MS-Windows and Macintosh machines.
  %
  % The initial value is found from the value of the sliders.
  % When text is entered into the text area and the return key is
  % pressed, the callback string is evaluated.
  %--------------------------------------------------------------------
  
  Hc_acur = uicontrol(Hf_fig,'style','edit',...
    'pos',[.25 .08 .13 .053],...
    'string',num2str(get(Hc_asli,'val')),...
    'callback','mmview3d(993)');
  
  Hc_ecur = uicontrol(Hf_fig,'style','edit',...
    'pos',[.885 .333 .11 .053],...
    'string',num2str(get(Hc_esli,'val')),...
    'callback','mmview3d(994)');
  
  %--------------------------------------------------------------------
  % Place a 'Done' button in the lower right corner.
  % When clicked, all of the uicontrols will be erased.
  %--------------------------------------------------------------------
  
  uicontrol(Hf_fig,'style','push',...
    'pos',[.88 .02 .10 .08],...
    'backgroundcolor',[.7 .7 .8],...
    'string','Done',...
    'callback','delete(findobj(gcf,''Type'',''uicontrol''))');
  
  %--------------------------------------------------------------------
  % Place a 'Revert' button next to the 'Done' button.
  % When clicked, the view reverts to the original view.
  %--------------------------------------------------------------------
  
  uicontrol(Hf_fig,'style','push',...
    'pos',[.77 .02 .10 .08],...
    'backgroundcolor',[.7 .7 .8],...
    'string','Revert',...
    'callback','mmview3d(995)');
  
else

%======================================================================
% This is the callback section.
%======================================================================

  %--------------------------------------------------------------------
  % The callbacks for the azimuth and elevation sliders will:
  %--------------------------------------------------------------------
  %   1) get the value of the slider and display it in the text window
  %   2) set the 'View' property to the current values of the azimuth 
  %        and elevation sliders.
  %--------------------------------------------------------------------
  
  if cmd == 991
    set(Hc_acur,'string',num2str(get(Hc_asli,'val')));
    set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);

  elseif cmd == 992
    set(Hc_ecur,'string',num2str(get(Hc_esli,'val')));
    set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
  
  %--------------------------------------------------------------------
  % The 'slider current value' text display callbacks:
  %--------------------------------------------------------------------
  % When text is entered into the text area and the return key is
  % pressed, the entered value is compared to the limits.
  %
  % If the limits have been exceeded, the display is reset to the 
  % value of the slider and an error message is displayed.
  %
  % If the value is within the limits, the slider is set to the 
  % new value, and the view is updated.
  %--------------------------------------------------------------------
  
  elseif cmd == 993
    if str2num(get(Hc_acur,'string')) < get(Hc_asli,'min')...
      | str2num(get(Hc_acur,'string')) > get(Hc_asli,'max')
        set(Hc_acur,'string',num2str(get(Hc_asli,'val')));
        disp('ERROR - Value out of range');
    else
      set(Hc_asli,'val',str2num(get(Hc_acur,'string')));
      set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
    end

  elseif cmd == 994
    if str2num(get(Hc_ecur,'string')) < get(Hc_esli,'min')...
      | str2num(get(Hc_ecur,'string')) > get(Hc_esli,'max')
        set(Hc_ecur,'string',num2str(get(Hc_esli,'val')));
        disp('ERROR - Value out of range');
    else
      set(Hc_esli,'val',str2num(get(Hc_ecur,'string')));
      set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
    end

  %--------------------------------------------------------------------
  % Revert to the original view.
  %--------------------------------------------------------------------
  
  elseif cmd == 995
    set(Hc_asli,'val',CVIEW(1));
    set(Hc_esli,'val',CVIEW(2));
    set(Hc_acur,'string',num2str(get(Hc_asli,'val')));
    set(Hc_ecur,'string',num2str(get(Hc_esli,'val')));
    set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
  
  %--------------------------------------------------------------------
  % Must be bad arguments.
  %--------------------------------------------------------------------
  
  else
    disp('mmview3d: Illegal argument.')
  end
end
