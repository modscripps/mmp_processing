function [data_lim] = swims_LatLonDotPlot(infile);
% Usage: [data_lim] = swims_LatLonDotPlot(infile);
% Required fields of infile
%   cruise: String cruise name, e.g. 'ml04';
%   group: Integer data group number, e.g. 4;
%   vars: String names of CTDdata variables, within a cell if more than
%       one, e.g. {'t1', 's1'}.
%   fetch: A structure with fields defining how data are selected, usually
%       by pressure or depth
%       var: any variable returned by get_swims_data.  'p_ctd' or
%           'z_ctd' are usually used, but 'sgth1' and other variables can
%           usually be used.
%       lb: Number giving the lower bound of the fetch variable, e.g. 0.1
%       ub: Number giving the upper bound of the fetch variable, e.g. 0.3
%   operation: A string that may be 'avg', 'max', 'min'.  This operation
%           will be performed for every profile on all data returned by fetch.  
%           For instance,for 'avg' the specified region in each profile 
%           is averaged, and the plot shows the variability of the profile 
%           averages.
%   
% Optional fields of infile
%   plot_lim: A 2-element vector array with lower and upper plot, 
%       e.g. [12 14]   
%   contours: A structure with fields
%       draw: 'y' or something else (required if contours is a field of infile)
%       levels: A vector with the data levels to be contoured,
%           e.g. [12:.05:12.5];
%       n_levels: An integer with the number of contours to draw between
%           data_max and data_min.  If 'levels' is also specified, 
%           it will override n_levels.  If the length of vars > the number
%           of rows of n_levels, the last row of n_level will be replicated for
%           the rest of the variables.
%   adcp: Putting anything in this field causes velocity to be averaged
%       over the same z or p interval and the vectors overlaid on the plot.
%   print: A structure, the existence of which, i.e. an empty field, initiates 
%           printing the figure to disk.  It can have 3 optional fields
%     folder: String full path of folder to print figures to.  Default is
%           the current folder.
%     name: Figure will be named [infile.cruise '_swims_gr' int2str(infile.group) ...
%           '_dotplot_' vars{i}].  This field supplies a final part, e.g. '0to50'.  
%           If this field exists, a preceeding '_' will be added automatically.
%     format: String matlab expression for the graphic format.  Default is
%           '-depsc'.
%     
%   NOTE: specify salinity limits, i.e. for plot_lim or levels, in ppt
%
% Output:
%   data_lim: An n x 2 array of max and min data values for each profile,
%       where n is the number of plots.
% Function: Plots swims data characteristics as colored dots on a lat-lon
% grid.  Intervals in profiles can be specified by limits on any of the
% CTDdata returned by swims, but most often pressure or depth limits are
% used.
% mgregg, 1mar04

N_CONTOUR_LEVELS = 10; % Default number of levels for contouring

%%%%%%%%%%%%%%%%%%%%%%%%% Check required fields of infile %%%%%%%%%%%%%%%%%%%%%%%%%
% Check for field cruise
if ~isfield(infile, 'cruise')
    error(['infile must have field ''cruise'''])
else
    if isempty(infile.cruise)
        error(['infile.cruise is empty'])
    else
        cruise = infile.cruise;
    end
end

% Check for field group
if ~isfield(infile, 'group')
    error(['infile must have field ''group'''])
else
    if isempty(infile.group)
        error(['infile.group is empty'])
    else
        if length(infile.group) > 1
            display('contour_swims_group_var: Only the first group will be plotted.')
        end
        i_gr = infile.group(1);
    end
end

% Check for field vars
if ~isfield(infile, 'vars')
    error(['infile must have field ''vars'''])
else
    if isempty(infile.vars)
        error(['infile.group is empty'])
    else
        vars = infile.vars;
    end
end

% Check for field plot_lim and write it as a variable in the workspace.
if isfield(infile, 'plot_lim')
    if isempty(infile.plot_lim)
        error('infile.plot_lim exists but is empty')
    else
        plot_lim = infile.plot_lim;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Check optional fields of infile %%%%%%%%%%%%%%%%%%%%%% 
% Check field contours
if isfield(infile, 'contours')
    if isempty(infile.contours)
        error('infile.contours is optional, but it cannot be empty.')
    end
    if ~isfield(infile.contours, 'draw')
        error('If infile.contours is specified, it must have field ''draw''')
    end
    if isfield(infile.contours, 'levels')
        [n_row, n_col] = size(infile.contours.levels);
        if n_row < length(infile.vars)
            levels(1:n_row, :) = infile.contours.levels(1:n_row,:);
            for i = n_row+1:length(infile.vars)
                levels(i,:) = infile.contours.levels(n_row,:);
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cruise = infile.cruise;

eval([cruise '_folders'])

% Load final cruise log and find index number for swims data
eval(['load ' setstr(39) [cruise '_FinalCruiseLog.mat'] setstr(39)])
i_dat = 1;
while ~strcmp(char(cr.data_names(i_dat)), 'swims')
    i_dat = i_dat + 1;
end

% Load the full ctd data for the time of this group
CTDdata = get_swims_data(cr.data(i_dat).group(i_gr).yday(1), ...
    cr.data(i_dat).group(i_gr).yday(end), swims_griddata_indexfile, ...
    swims_griddata_datapath, {});

% If 'adcp' is a field on infile, get adcp data for the same yday interval
% and average u_wat and v_wat over the same p or z interval used for the
% ctd data
if isfield(infile, 'adcp')
    Veldata = get_adcp_data(cr.data(i_dat).group(i_gr).yday(1), ...
    cr.data(i_dat).group(i_gr).yday(end), adcp_indexfile, ...
    adcp_datapath, {});

    % Average 1st & last lat & lon of profile
    lon_adcp = nanmean([Veldata.lonFP; Veldata.lonLP]);
    lat_adcp = nanmean([Veldata.latFP; Veldata.latLP]);
    
    % Set fetch_adcp to match one used for swims ctd data
    if strcmp(infile.fetch.var, 'z_ctd')
        adcp_fetch = 'z_adcp';
    elseif strcmp(infile.fetch.var, 'p_ctd')
        adcp_fetch = 'p_adcp';
    else
        error('No equivalent fetch variable for adcp data')
    end
    
    % Find the row indices of the fetch variable
    eval(['i_fetch_adcp = find(Veldata.' adcp_fetch '>= ' num2str(infile.fetch.lb) ...
    ' & Veldata.' adcp_fetch ' <= ' num2str(infile.fetch.ub) ');']);

    % Calculate average velocity components over the selected z or p range'
    eval(['u_mean = nanmean(Veldata.u_wat(i_fetch_adcp,:));'])
    eval(['v_mean = nanmean(Veldata.v_wat(i_fetch_adcp,:));'])
end
    
% Set positions for plot and colorbar
pos_cont = [0.15 0.27 0.8 0.65];
pos_cbar = [0.15 0.12 0.8 0.05];

for i = 1:length(infile.vars)
    % Find the row indices of the fetch variable
    eval(['i_fetch = find(CTDdata.' infile.fetch.var '>= ' num2str(infile.fetch.lb) ...
    ' & CTDdata.' infile.fetch.var ' <= ' num2str(infile.fetch.ub) ');']);

    % Compute the data limits, i.e. max and min when the operation is performed on each
    % profile
    switch infile.operation
        case 'avg'
            eval(['data = nanmean(CTDdata.' infile.vars{i} '(i_fetch,:));'])
        case 'max'
            eval(['data = max(CTDdata.' infile.vars{i} '(i_fetch,:));'])
        case 'min'
            eval(['data = min(CTDdata.' infile.vars{i} '(i_fetch,:));'])
    end
    
    if strcmp(char(vars{i}), 's1') | strcmp(char(vars{i}), 'ss') 
        data = 1000 * data;
    end
    data_min = min(data);
    data_max = max(data);
    data_lim = [data_min data_max];
    
    x_lim = [min(CTDdata.lon) max(CTDdata.lon)];
    y_lim = [min(CTDdata.lat) max(CTDdata.lat)];
    
    figure
    H_cbar = axes('position', pos_cbar);
    H_cont = axes('position', pos_cont);
    
    % Set plot_lim.  If it is a field of infile, take the ith one, if it
    % exists.  Otherwise, use the first plot_lim
    if isfield(infile, 'plot_lim')
        if size(infile.plot_lim,1) >= i
            plot_lim = infile.plot_lim(i,:);
        else
            plot_lim = infile.plot_lim(1,:);
            display([vars{1} ' plot_lim used for ' vars{i}]);
        end
    else
        plot_lim = data_lim;
    end
    
    % Set the colormap and color axis
    cmp = jet(256);
    caxis(plot_lim);
    colormap(cmp);
    
    % Plot the data as dots filled with color that is proportional to their
    % value
    scatter(CTDdata.lon, CTDdata.lat, 8, data, 'filled')
    hold on
    
    set(gca, 'dataaspectratio',[1 abs(cos(pi*nanmean(CTDdata.lat)/180)) 5], ...
        'fontsize', 12, 'box', 'on', 'xlim',x_lim, 'ylim', y_lim)
    grid on
    Hyl=ylabel('Latitude'); Hxl=xlabel('Longitude');
    set([Hxl Hyl], 'fontsize', 12)
    caxis(plot_lim);
    
    if isfield(infile, 'contours')
        if strcmp(infile.contours.draw, 'y')
            % Setup lat & lon grids as input to griddata
            len_grid = 30;
            lon_min = min(CTDdata.lon); lon_max = max(CTDdata.lon);
            lon = ones(len_grid+1,1)*(lon_min:(lon_max-lon_min)/len_grid:lon_max);
            lat_min = min(CTDdata.lat); lat_max = max(CTDdata.lat); 
            lat = (lat_min:(lat_max-lat_min)/len_grid:lat_max)'*ones(1,len_grid+1); 
    
            % Run griddata
            gdata = griddata(CTDdata.lon, CTDdata.lat, data, lon, lat);
            
            % Determine the data values to contour
            if isfield(infile.contours, 'n_levels')
                n_levels = infile.contours.n_levels;
            else
                n_levels = N_CONTOUR_LEVELS;
            end
            if isfield(infile.contours, 'levels')
                V = infile.contours.levels;
            else
                V = data_min:(data_max-data_min)/(n_levels-1):data_max;
            end
            
            [C,H]=contour(lon, lat, gdata, V);
            set(H(:),'linewidth',2);
        end
    end
    
    % Overlay velocity vectors when 'adcp' is a field of infile
    if isfield(infile, 'adcp')
        quiver(lon_adcp, lat_adcp, u_mean, v_mean)
    end
    
    % Set var title in latex format
    switch infile.vars{i}
        case 'u_wat'
            var_title = 'u\_wat';
        case 'v_wat'
            var_title = 'v\_wat';
    end
    
    % Set fetch var title in latex form
    switch infile.fetch.var
        case 'z_ctd'
            fetchvar_title = 'z\_ctd';
        case 'p_ctd'
            fetchvar_title = 'p_\ctd';
    end
         
    title(['SWIMS - cruise: ' infile.cruise, ', data group: ' int2str(infile.group) ...
            ', data: ' infile.vars{i} ' ' infile.operation ', ' fetchvar_title ...
        ': ' num2str(infile.fetch.lb) '-' num2str(infile.fetch.ub)])
    
    % Plot the colorbar horizontally below the contour
    colorbar(H_cbar);
    set(H_cbar,'fontweight','bold','fontsize',12)
    axes(H_cbar)
    
    % Label the xaxis of the color bar to match vars{i}
    switch infile.vars{i}
        case {'t1', 't2'}
            Hxlcb = xlabel('Temperature / {}^oC');
        case {'s1', 's2'}
            Hxlcb = xlabel('Salinity / ppt');
        case {'sgth1', 'sgth2'}
            Hxlcb = xlabel('\sigma_{\theta} / kg m^{-3}');
        case {'dox'}
            Hxlcb = xlabel('O_2 / ml l^{-1}');
        case ('flu')
            HXlcb = xlabel('Flu / F.T.U.');
    end
    pos_xlcb=get(Hxlcb,'position');
    set(Hxlcb,'position',[pos_xlcb(1) pos_xlcb(2)+1. pos_xlcb(3)])
    
    % Print the figure
    if isfield(infile, 'print')
        % If infile.print contains field fig_folder use it.  Otherwise,
        % use the present folder
        if isfield(infile.print, 'folder')
            folder = infile.print.folder;
        else
            folder = pwd;
        end
        
        % If infile.print contains a name, use it.  Otherwise, use the standard
        % name
        if isfield(infile.print, 'name')
            fig_name = [infile.cruise '_swims_gr' int2str(infile.group) '_dotplot_' ...
              vars{i} '_' infile.print.name];
        else
            fig_name = [infile.cruise '_swims_gr' int2str(infile.group) '_dotplot_' ...
              vars{i}];
        end
        fig_path = fullfile(folder, fig_name);
        
        % If infile.print  contains a format, use it.  Otherwise, use '-depsc'
        if isfield(infile.print, 'format')
            format = infile.print.format;
        else
            format = '-depsc';
        end
        
        eval(['print -adobecset ' format ' ' fig_path])
    end
end