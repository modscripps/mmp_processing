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
%   plot_lim: A 2-element vector on n x 2 array with lower and upper plot
%       limits.
%   contours: A structure with fields
%       draw: 'y' or something else (required if contours is a field of infile)
%       levels: A vector with the data levels to be contoured,
%           e.g. [12:.05:12.5];
%       n_levels: An integer with the number of contours to draw between
%           data_max and data_min.  If 'levels' is also specified, 
%           it will override n_levels.  If the length of vars > the number
%           of rows of n_levels, the last row of n_level will be replicated for
%           the rest of the variables.
% Output:
%   data_lim: An n x 2 array of max and min data values for each profile,
%       where n is the number of plots.
% Function: Plots swims data characteristics as colored dots on a lat-lon
% grid.  Intervals in profiles can be specified by limits on any of the
% CTDdata returned by swims, but most often pressure or depth limits are
% used.
% mgregg, 1mar04

if nargin < 1
    infile.cruise = 'ml04';
    infile.group = 19;
    infile.vars = {'t1', 't2'};
    infile.operation = 'avg';
    infile.plot_lim = [16.5 19.2];
    infile.fetch.var = 'z_ctd';
    infile.fetch.lb = 10:5:40;
    infile.fetch.ub = infile.fetch.lb+5;
    infile.n_levels=length(infile.fetch.ub);
    infile.contours.draw = 'y';
    %infile.contours.n_levels = 15;
end

N_CONTOUR_LEVELS = 10;

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
% If it exists and has fewer rows than the
% length of infile.vars, replicate the last plot_lim so plot_lim has a row
% for every variable.
plot_lim(1,:)=infile.plot_lim;
% 
% if isfield(infile, 'plot_lim')
%     if isempty(infile.plot_lim)
%         error('infile.plot_lim exists but is empty')
%     else
%         [n_row, n_col] = size(infile.plot_lim);
%         
%         if n_row < length(infile.vars)   
%             plot_lim(1:n_row,:) = infile.plot_lim(1:n_row,:);
%             for i = n_row+1:length(infile.vars)
%                 plot_lim(i,:) = infile.plot_lim(n_row,:);
%             end
%         else
%             plot_lim = infile.plot_lim;
%         end
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%eval(['load ' setstr(39) [cruise '_FinalCruiseLog.mat'] setstr(39)])
eval(['load ' setstr(39) [cruise_logs filesep cruise '_FinalCruiseLog.mat'] setstr(39)])

i_dat = 1;
while ~strcmp(char(cr.data_names(i_dat)), 'swims')
    i_dat = i_dat + 1;
end

% Load the full ctd data for the time of this group
CTDdata = get_swims_data(cr.data(i_dat).group(i_gr).yday(1), ...
    cr.data(i_dat).group(i_gr).yday(end), swims_griddata_indexfile, ...
    swims_griddata_datapath, {});

% Set positions for plot and colorbar
pos_cont = [0.15 0.27 0.8 0.65];
pos_cbar = [0.15 0.12 0.8 0.05];

for i = 1:length(infile.vars)
    figure
    H_cbar = axes('position', pos_cbar);
    H_cont = axes('position', pos_cont);
    
    
    %W = GRIDDATA3(X, Y, Z, V, XI, YI, ZI)
    len_grid = 30;
    lon_min = min(CTDdata.lon); lon_max = max(CTDdata.lon);
    z_min=0;
    z_max=150;
    lon = (lon_min:(lon_max-lon_min)/len_grid:lon_max);
    lat_min = min(CTDdata.lat); lat_max = max(CTDdata.lat); 
    lat = (lat_min:(lat_max-lat_min)/len_grid:lat_max);
    z=z_min:10:z_max;
    % Run griddata
    [lon_g,lat_g,z_g]=meshgrid(lon,lat,z);
    eval(['data = nanmean(CTDdata.' infile.vars{i} '(:,:));'])
    %need to use reshape to make these triplets of data and
    %coords
    gdata = griddata3(CTDdata.lon, CTDdata.lat,CTDdata.z_ctd, data, lon_g, lat_g,z_g);
    
    
    
    
    for level=1:infile.n_levels
        
        % Find the row indices of the fetch variable
        eval(['i_fetch = find(CTDdata.' infile.fetch.var '>= ' num2str(infile.fetch.lb(level)) ...
                ' & CTDdata.' infile.fetch.var ' <= ' num2str(infile.fetch.ub(level)) ');']);
        
        zpl=0.5*(infile.fetch.lb(level)+infile.fetch.ub(level));
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
        data_min = infile.plot_lim(1);
        data_max = infile.plot_lim(2);
        data_lim(i,:) = [data_min data_max];
        plot_lim(i,:) = data_lim(i,:);
        
        % Set the colormap and color axis
        cmp = jet(256);
        
        
        caxis(plot_lim(i,:));
        colormap(cmp);
        
        % Plot the data as dots filled with color that is proportional to their
        % value
        %scatter3(CTDdata.lon, CTDdata.lat,zpl*ones(size(CTDdata.lat)), 8, data, 'filled')
        
        %set(gca, 'dataaspectratio',[1 cos(pi*nanmean(CTDdata.lat)/180) 1], ...
        %    'fontsize', 12, 'box', 'on')
        %caxis(plot_lim(i,:));
        
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
                
                h=surf(lon, lat, zpl*ones(size(lon)),gdata);
                shading interp
                alpha(0.5)
                if level==1
                    %caxis(plot_lim(i,:));
                    %colormap(cmp);
                    hold on
                end
                %               [C,H]=contour3(lon, lat, zpl*ones(size(lon)),gdata, V);
                %                set(H(:),'linewidth',2)
            end
        end
    end %end 1:n_levels
    
    set(gca,'zdir','reverse')
    title(['SWIMS - cruise: ' infile.cruise, ', data group: ' int2str(infile.group) ...
            ', data: ' infile.vars{i} ' ' infile.operation])
    Hyl=ylabel('Latitude'); Hxl=xlabel('Longitude');
    set([Hxl Hyl], 'fontsize', 12)
    
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
        case {'sgth', 'sgth2'}
            Hxlcb = xlabel('\sigma_{\theta} / kg\ m^{-3}');
    end
    pos_xlcb=get(Hxlcb,'position');
    set(Hxlcb,'position',[pos_xlcb(1) pos_xlcb(2)+1. pos_xlcb(3)])
end