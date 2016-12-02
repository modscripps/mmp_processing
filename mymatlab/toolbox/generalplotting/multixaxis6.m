function H = multixaxis6(in)
% Usage: H = multixaxis6(in);
% Input: in is a structure with no more than 4 elements
%
% Input fields:
%   in(i).xdata: i=1:4, must be vectors.  At least one set is mandatory.
%       Matching axes are: i=1, bottom; i=2, top; i=3, off-axis lower, and
%       i=4, off_axis, upper.
%   in(i).ydata: i=1:4, must be vectors. Set with i=1 is mandatory,
%       and it must be same length as in(1).xdata.  Other sets are
%       optional, but they must be same length as matching xdata.  If
%       omitted, the ith xdata must be same length as in(1).ydata.
%   in(i).color: Color of data line and matching xaxis.  Must have 
%       standard form, e.g., 'r' or [1 0 0].  Color is optional; default
%       sequence is 'r', 'b', 'g', 'm'.
%   in(i).axes
%           position: Can be specified only for i=1; otherwise, defaults
%             are calculated based on the number of elements in 'in'
%             Defaults are: [0.13 0.11 0.775 0.78] for 1,2 profiles
%                           [0.13 0.25 0.775 0.63] for 3 profiles
%                           [0.13 0.25 0.775 0.50] for 4 profiles
%           ylim: Can be specified only for i=1.  Default includes all
%               ydata.
%           ydir: Can be specified only for i=1. Default = 'normal'.
%           fontweight: Can be specified only for i=1. Default = 'bold'.
%           fontsize: Can be specified only for i=1. Default = 10;
%           for i=1:4) 'linewidth'=1; 
%                      'fontweight'='bold'; 
%                      'ticklength'=[.02 .025];
%                      'ylim' Can be specified only for i=1; otherwise, 
%                         it is calculated to include all ydata
%           for i>=2) 'yticklabel'='';
%           for i>=3) 'ytick'=[];
%                     'xticklabel'='';
%                     'visible'='off';
%                     'xaxislocation'='left';
%   in(i).line.<std parameter>: any standard line parameter
%   in(i).xlabel: i=1:4, xaxis label for this variable, in standard form
%   in(1).ylabel: Can be on left (in(1).ylabel) or right (in(2).ylabel) but
%     not both.
%       
% Outputs:
%   H:  A structure containing vectors of handles
%   H.line:  Vector of handles to the data plot.  To add diamond markers
%       to the second line use set(H.line(2), 'marker','d')
%   H.xlabel:  Vector of handles to the xlabels.
%   H.ylabel:  Handle to the ylabel.
% Function: Plots up to four data pairs having a common y axis.  The sequence
%   of xlabels is: lower xaxis, upper xaxis, below lower xaxis, above upper
%   xaxis.  If they have the same length, all data can be plotted using
%   only in(1).ydata.
%     Axes, line, xlabel, ylabel, and color fields can be added.
%
% EXAMPLE: 
%   in(1).xdata = 1:10; 
%   in(1).ydata = 1:10;
%   in(2).xdata = (1:10).^2;
%   in(1).ylabel = 'p / MPa';
%   in(1).xlabel = '\theta / {}^oC';
%   in(2).xlabel = 'Test';
%   in(1).line.linewidth = 2;
%   in(1).axes.ydir = 'rev';
%   25sep01, mgregg
%   4dec03, revised, mgregg

PBORDER=.55; % Border between xaxes and xticklabels axes, as a fraction of the
             % the the ticklabel fontsize
LABEL_GAP = .02;  %  Gap to be set between axes labels and ticklabels, norm units
DATA_MARGIN = 0.03; % Margin between data plots and xlimits of plot, e.g. 
                    % xmin=xmin-DATA_MARGIN*(xmax-xmin);

%%%%%%%%%%%%%%%%% PUT STANDARD PLOT PARAMETERS IN STRUCTURE "std" %%%%%%%%%%%%%%%%
% These are set as defaults, but can be changed by inserting parameters into "in"
%
n_std=4;  % Number of sub-structures in std
%
% Set positions of plot axis
if length(in) <= 2
  std(1).axes.position = [0.13 0.11 0.775 0.78]; % use standard axes
elseif length(in) == 3
  std(1).axes.position = [0.13 0.25 0.775 0.63];
elseif length(in) == 4
  std(1).axes.position = [0.13 0.25 0.775 0.50];
end
%
% Set parameters that depend on axes number
std(1).axes.xaxislocation = 'bottom';     std(1).axes.yaxislocation = 'left';
std(2).axes.xaxislocation = 'top';        std(2).axes.yaxislocation = 'right';
std(3).axes.xaxislocation = 'bottom';     
std(4).axes.xaxislocation = 'top';        
std(1).color = 'r'; std(2).color = 'b'; std(3).color = 'g'; std(4).color = 'm';
%
% Set parameter values common to several axes
for i = 1:n_std
  std(i).axes.xcolor = std(i).color;
  std(i).line.color = std(i).axes.xcolor';
  std(i).axes.linewidth=1;
  std(i).axes.fontweight='bold';
  std(i).axes.ticklength=[.02 .025];
  std(i).xlabel=['Data pair ' int2str(i)];
  if i>=2
    std(i).axes.position = std(1).axes.position;
    if i>=3
      std(i).axes.ytick=[];
      std(i).axes.visible = 'off';
      std(i).axes.yaxislocation='left';
      std(i).axes.xticklabel='';
    end
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHECK "in" AND FILL IN BLANKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%
%
% Check input length
if length(in)>4
  error(['multixasis6: "in" has more sub-structures than the four allowed'])
end
%
% Check that xdata and ydata are fields of input
if ~isfield(in,'xdata') | ~isfield(in,'ydata')
  error('multixaxis6: "in" must have fields xdata and ydata')
end
%
% Insure that only one ylabel is input.  If there are two or more
% keep only the first
if isfield(in, 'ylabel')
  if length(in) >= 2
    if ~isempty(in(1).ylabel) & ~isempty(in(2).ylabel)
      in(2).ylabel = '';
      in(2).axes.yticklabel = '';
      display(['multixaxis6: Only one ylabel can be used;' ...
          ' in(1).ylabel will be used.'])
    elseif isempty(in(1).ylabel) & ~isempty(in(2).ylabel)
      in(1).axes.yticklabel = '';
    end
    if length(i) >=3
      for i = 3:length(in)
        in(i).ylabel = '';
        in(i).axes.ytick = [];
        in(i).axes.yticklabel = '';
      end
    end
  end
end
% Check existence & dimensions of  xdata & ydata
for i=1:length(in);
  % Check that in(i).xdata is a vector
  if isempty(in(i).xdata) | min(size(in(i).xdata))>2
    error(['in(' int2str(i) ').xdata is not a vector array'])
  end
  % Check that in(1).ydata has same length as in(1).xdata
  if i==1 & length(in(i).xdata) ~= length(in(i).ydata)
    error('in(1).ydata must have same length as in(1).xdata')
  % Check case of i>1 & in(i).ydata is input
  elseif ~isempty(in(i).ydata) 
    % Check that ydata is a vector
    if min(size(in(i).ydata))>2
      error(['in(' int2str(i) ').ydata is neither null nor a vector'])
    % Check that in(i).ydata is same length as in(i).xdata
    elseif length(in(i).ydata) ~= length(in(i).xdata)
      error(['in(' int2str(i) ').ydata is neither null nor of same length as in(' ...
          int2str(i) ').xdata'])
    end
  % Check case of i>1 & no ydata is input
  elseif length(in(i).xdata) ~= length(in(1).ydata)
    error(['in(' int2str(i) ') has no ydata and its xdata ' ...
        'is not the same length as in(1).ydata'])
  end
  
end
%
% If only one data pair are input turn the box on and make it visible
if length(in)==1
  in(1).axes.visible='on';
  in(1).axes.box='on';
end
% If in(1).axes.ylim is not specified, calculate it to include all inputs
set_ylim = 'y';
if isfield(in(1), 'axes')
  if isfield(in(1).axes, 'ylim')
    if ~isempty(in(1).axes.ylim)
      set_ylim = 'n';
    end
  end
end
if strcmp(set_ylim, 'y')
  y_max=[]; y_min=[];
  for i=1:length(in)
    y_max = [y_max max(in(i).ydata)];
    y_min = [y_min min(in(i).ydata)];
  end
  in(1).axes.ylim = [min(y_min) max(y_max)];
end
% Fill in blanks in "in.axes".  That is, if a field that must be identical in all
% substructures is specified in in(1) put it in the other substructures.
axes_ident_fields={'position'; 'ydir'; 'ylim'; 'fontsize'; 'fontweight'}; 
if isfield(in,'axes');
  if ~isempty(in(1).axes)
    for i=2:length(in)
      % Identical fields
      for j=1:length(axes_ident_fields)
        % If one of the axes_identical_fields is in in(1).axes, put it in the other
        % substructures
        if isfield(in(1).axes, axes_ident_fields(j))
          eval(['in(i).axes.' axes_ident_fields{j} '=in(1).axes.' axes_ident_fields{j} ';'])
        end
      end % j loop
    end % i loop
  end % isempty
end % isfield

% If in(i).color exists, assign it to properties that will let the plot line
% and corresponding axes be the same color
for i = 1:length(in)
  if isfield(in(i),'color') 
    in(i).axes.xcolor=in(i).color;
    in(i).line.color=in(i).color;
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Add fields and subfields of std to 'in' if those fields are missing
%%%%% or empty &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
infields=fieldnames(in); % Cell array containing the fields in "in"
stdfields=fieldnames(std);  % Cell array containing the fields in std

% Step through the fields of std
for i = 1:length(stdfields)
  % If in does not have this field, add it element-by-element
  if ~isfield(in, stdfields{i})
    for j = 1:length(in) 
      eval(['in(j).' stdfields{i} ' = std(j).' stdfields{i} ';'])
    end
  % If in has this field, but some subfields are missing, add them to 'in'
  else
    % Step through the elements of 'in'
    for j = 1:length(in)
      % If in(j).stdfields(i) is empty add it
      if isempty(eval(['in(j).' stdfields{i}]))
        eval(['in(j).' stdfields{i} '= std(j).' stdfields{i} ';'])
       
      % if in(j).stdfields{i} is a structure, step through the subfields 
      % of std(j).stdfields{i} and add in ones that are missing or empty
      % in in(j).
      elseif isa(eval(['std(j).' stdfields{i}]), 'struct') %& ...     
        subfields=fieldnames(eval(['std(j).' stdfields{i}]));
        % Step through the subfields
        for k = 1:length(subfields)
          % If in(j) does not have this subfield, add it
          if ~isfield(eval(['in(j).' stdfields{i}]), subfields{k})
            eval(['in(j).' stdfields{i} '.' subfields{k} ...
                '= std(j).' stdfields{i} '.' subfields{k} ';'])
          % If in(j) has the subfield but it is empty, add it
          elseif isempty(eval(['in(j).' stdfields{i} '.' subfields{k}]))
            eval(['in(j).' stdfields{i} '.' subfields{k} ...
                '= std(j).' stdfields{i} '.' subfields{k} ';'])
          end
        end
      end
    end
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%CREATE AXES & SET THEIR PARAMETERS, PLOT & SCALE DATA %%%%%%%%%%%%%%
for i=1:length(in)
  % Create an axis for each sub-structure, give them the same position, and set  
  % the x and y axes for the plot.  If the position or axes locations have been
  H.axes(i)=axes;
  hold on
  %
  % Plot the data and reuse ydata(1) if none are supplied for ydata(i) and 
  % xdata(i) has the same dimension as ydata(1)
  if length(in(i).xdata)==length(in(i).ydata)
    H.line(i)=plot(in(i).xdata,in(i).ydata);
  elseif i>1 & isempty(in(i).ydata) & length(in(i).xdata)==length(in(1).ydata)
    H.line(i)=plot(in(i).xdata,in(1).ydata);
  else
    disp(['multixaxis6: No plot made for in(' int2str(i) ')'])
  end
  hold on
  if i == 2
    in(i).axes.ytick = get(H.axes(1), 'ytick');
  end
  % Set all axes subfields for H.axes(i)
  subfields=fieldnames(in(i).axes);
  field_values=struct2cell(in(i).axes);
  n_subfields=length(subfields);
  for j=1:n_subfields
    set(H.axes(i),char(subfields{j}),field_values{j})
  end
  %
  
  %
  % Set the properties of this line
  % First, check that H.line(i) was created, i.e. if data were really plotted
  if isfield(H, 'line')
    if length(H.line)==i
      % Second, check that line properties exist for this data pair
      if isfield(in(i),'line')
        linefields=fieldnames(in(i).line);
        if ~isempty(linefields)
          n_linefields=length(linefields);
          field_values=struct2cell(in(i).line);
          for j=1:n_linefields
            set(H.line(i),char(linefields{j}),field_values{j})
          end
        end
      end
    end
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL AXES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add y and x labels for first two data pairs
for i=1:min(2,length(in))
  axes(H.axes(i))
  % Add only in(1).ylabel
  if i==1 
    H.ylabel(i)=ylabel(in(i).ylabel,'VerticalAlign','bottom'); % Keep it off tick labels 
  elseif i==2
    H.ylabel(i)=ylabel(in(i).ylabel,'VerticalAlign','top'); % Keep it off tick labels 
  end
  if isfield(in(i),'xlabel') 
    H.xlabel(i)=xlabel(in(i).xlabel); 
  end
end
% Calculate ticklength in cm to use in setting vertical positions of
% Hax(3) & Hax(4)
set(H.axes(1),'units','cent')
pos_ax1=get(H.axes(1),'position');
tick_ax1=get(H.axes(1),'ticklength');
h_tick=tick_ax1(1)*max(pos_ax1(3:4)); % ticklength in cm
set(H.axes(1),'units','norm')
%
% Move xlabel(1) up to reduce blank space between it and xticklabels
set(H.axes(1),'fontunits','points','units','cent')
set(H.xlabel(1),'units','cent')
pos_xl1=get(H.xlabel(1),'pos');
ext_xl1=get(H.xlabel(1),'extent');
h_xticklabel=get(H.axes(1),'fontsize')*2.54/72; % height of xticklabels in cm
gap=-h_xticklabel*PBORDER - (ext_xl1(2)+ext_xl1(4));
% Reduce the gap to 2mm
set(H.xlabel(1),'pos',[pos_xl1(1) pos_xl1(2)+gap-.2 pos_xl1(3)]);
%
% Move xlabel(2) down
if length(in)>=2
  set(H.axes(2),'units','cent','fontunits','points')
  pos_ax2=get(H.axes(2),'position'); % 2nd coord is position of top axis
  set(H.xlabel(2),'units','cent');
  pos_xl2=get(H.xlabel(2),'pos'); % Position relative to bottom xaxis
  ext_xl2=get(H.xlabel(2),'ext'); % Position relative to bottom xaxis
  h_xticklabel=get(H.axes(2),'fontsize')*2.54/72; % % height of xticklabels in cm
  gap=ext_xl2(2)-(pos_ax2(4)+h_xticklabel*PBORDER);
  % Reduce the gap to 2mm
  set(H.xlabel(2),'pos',[pos_xl2(1) pos_xl2(2)-(gap-.2) pos_xl2(3)]);
end

% Add axis and xlabel for the third data pair below the label for the 1st pair.
if length(in)>=3 
  axes(H.axes(3))
  set(H.xlabel(1),'units','cent'); ext_xl1=get(H.xlabel(1),'extent');
  % Calculate ypos of ax(3) to be just below xl(1).  
  % ext_xl1 is relative to ax(1) and therefore negative.
  % ax(3) will be relative to figure grid.
  set(H.axes(3),'units','cent','fontunits','points')
  pos_ax3=get(H.axes(3),'pos');
  h_ticklabel=get(H.axes(3),'fontsize')*2.54/72;
  ticklength=get(H.axes(3),'ticklength');
  h_tick=max(pos_ax3(3:4))*ticklength(1);
  ypos=pos_ax3(2)+ext_xl1(2)-h_tick;
  pos=[pos_ax3(1) ypos pos_ax3(3) h_tick];
  H.axes(5)=axes('units','cent','pos',pos,...
    'units','norm','fontsize',get(H.axes(3),'fontsize'),...
    'xcolor',get(H.axes(3),'xcolor'),...
    'ycolor',get(H.axes(3),'xcolor'),...    % in case xticks coincide with y axis
    'box','off',...
    'xtick',get(H.axes(3),'xtick'),...
    'ytick',get(H.axes(3),'ytick'));
  set(gca,'xlim',get(H.axes(3),'xlim'))
  if isfield(in(3),'xlabel') 
    axes(H.axes(5))
    H.xlabel(3)=xlabel(in(3).xlabel); 
    % Move label up to reduce gap from ax(5) ticklabels
    set(H.xlabel(3),'units','cent','VerticalAlign','top')
    h_ticklabel=get(H.axes(5),'fontsize')*2.54/72;
    ext_xl3=get(H.xlabel(3),'extent'); % Relative to ax5
    pos_xl3=get(H.xlabel(3),'pos');
    gap=abs(ext_xl3(2)+ext_xl3(4))-(h_ticklabel*PBORDER);
    set(H.xlabel(3),'pos',[pos_xl3(1) pos_xl3(2)+(gap-.2) pos_xl3(3)])
  end
end

% Add axis and xlabel for the fourth data pair above the label for the 2nd pair.
% The additional axes is #6
if length(in)==4
  set(H.xlabel(2),'units','cent'); 
  set(H.axes(4),'units','cent')
  pos_ax4=get(H.axes(4),'pos');
  ext_xl2=get(H.xlabel(2),'extent');
  ypos=pos_ax4(2)+ext_xl2(2)+ext_xl2(4); %+h_tick;
  ticklength=get(H.axes(4),'ticklength');
  h_tick=max(pos_ax4(3:4))*ticklength(1);
  pos=[pos_ax4(1) ypos pos_ax4(3) h_tick];
  H.axes(6)=axes('units','cent','pos',pos,...
    'fontsize',get(H.axes(4),'fontsize'),...
    'xcolor',get(H.axes(4),'xcolor'),...
    'ycolor',get(H.axes(4),'xcolor'),...
    'box','off',...
    'xtick',get(H.axes(4),'xtick'),...
    'ytick',get(H.axes(4),'ytick'),...
    'xaxislocation','top');
  set(gca,'xlim',get(H.axes(4),'xlim'))
  if isfield(in(4),'xlabel') 
    axes(H.axes(6))
    H.xlabel(4)=xlabel(in(4).xlabel); 
    % Move the label down to reduce the gap from the ax6 ticklabels
    set(H.xlabel(4),'units','cent','VerticalAlign','bottom','fontunits','points')
    pos_ax6=get(H.axes(6),'pos');
    h_ticklabel=get(H.axes(6),'fontsize')*2.54/72;
    ext_xl4=get(H.xlabel(4),'extent'); % Relative to ax6
    pos_xl4=get(H.xlabel(4),'pos');
    gap=ext_xl4(2)-h_ticklabel*PBORDER-pos_ax6(4);
    set(H.xlabel(4),'pos',[pos_xl4(1) pos_xl4(2)-(gap-.2) pos_xl4(3)])
  end
end

% Set handle units to normalized
for i=1:length(H.axes)
  set(H.axes(i), 'units','normalized')
end
for i=1:length(H.xlabel)
  set(H.xlabel(i), 'units','normalized')
end
set(H.ylabel(1), 'units','normalized')