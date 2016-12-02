function contour_swims_group_vars(infile)
% Usage: contour_swims_group_vars(infile)
% Input fields:
%   cruise: string cruise name, e.g. 'bs03' (mandatory)
%   group: integer number of swims group, e.g. 5 (mandatory)
%   vars: cell with one swims data name, e.g. {'eps1'} (mandatory)
%   V: vector with contour intervals, e.g. -10:2:-6 (mandatory)
%   print_format: string with format for printed plot, e.g. 'epsc'
%       (optional; default is 'pdf')
% Function: Plots one swims variables for a group or for all group subs
%   mgregg, 15dec03

% Note: <cruise>_folders must be in path and contain entries for
%   'swims_griddata_indexfile' and 'swims_griddata_datapath'

% Check for infile.cruise'
if ~isfield(infile, 'cruise')
    error(['infile must have field ''cruise'''])
else
    if isempty(infile.cruise)
        error(['infile.cruise is empty'])
    else
        cruise = infile.cruise;
    end
end

% Check for infile.group
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

% Check for infile.vars
if ~isfield(infile, 'vars')
    error(['infile must have field ''vars'''])
else
    if isempty(infile.vars)
        error(['infile.group is empty'])
    else
        vars = infile.vars(1);
        if ~isa(vars, 'cell')
            error('infile.vars must be a cell array')
        end
        if length(vars) > 1
            display(['Only the first variable in vars will be plotted'])
        end
    end
end

% Check for infile.V.  
if ~isfield(infile, 'V')
    error(['Infile must have field ''V'''])
elseif isempty(infile.V)
    error('V.infile is empty')
end
    
% Check for infile.print_format
if isfield(infile, 'print_format')
    if isempty(infile.print_format)
        display('No format is specified; figure will be printed as pdf.')
        print_format = 'pdf';
    else
        print_format = infile.print_format;
    end
else
   print_format = 'pdf';
   display('No format is specified; figure will be printed as pdf.')
end
    
eval([cruise '_folders'])

% Load final cruise log and find index number for swims data
eval(['load ' setstr(39) [cruise_logs filesep cruise '_FinalCruiseLog.mat'] setstr(39)])
i_dat = 1;
while ~strcmp(char(cr.data_names(i_dat)), 'swims')
    i_dat = i_dat + 1;
end

% Determine the number of plots to make.  If group.sub is empty,
% make one plot for the group; otherwise, make a plot for each sub.
if isempty(cr.data(i_dat).group(i_gr).sub)
    n_plots = 1;
    plot_group = 'y';
else
    n_plots = length(cr.data(1).group(i_gr).sub);
    plot_group = 'n';
end

for i = 1:n_plots
    % Get the ctd data, either for the group or the ith sub 
    if strcmp(plot_group, 'y')
        CTDdata = get_swims_data(cr.data(i_dat).group(i_gr).yday(1), ...
            cruise.group(i_gr).yday(end), swims_griddata_indexfile, ...
            swims_griddata_datapath, {});
    elseif strcmp(cr.data(i_dat).group(i_gr).subunit, 'yday')
        CTDdata = get_swims_data(cr.data(i_dat).group(i_gr).sub(i).tag(1), ...
            cr.data(i_dat).group(i_gr).sub(i).tag(end), swims_griddata_indexfile, ...
            swims_griddata_datapath, {});
    end

    data = eval(['CTDdata.' vars{1}]);
   
    % Calculate distance
    [d, cd, b] = nav2(CTDdata.lat, CTDdata.lon);
    cum_dist = [0 nm2km(cd)];
    %MHA substitution until I get Mike's nav2
    %[x,y]=LatLonToXY(CTDdata.lat,CTDdata.lon,nanmean(CTDdata.lat));
    %cum_dist=sqrt(x.^2+y.^2)/1000;
    pos_cont = [0.1 0.25 0.8 0.65];
    pos_cbar = [0.1 0.10 0.8 0.05];

    Hf(i) = figure;
    H_cbar = axes('position', pos_cbar);
    H_cont = axes('position', pos_cont);

    if strcmp(vars{1}, 'eps1') | strcmp(vars{1}, 'eps2') | strcmp(vars{1}, 'krho1') ...
            | strcmp(vars{1}, 'krho2')
        H.p = contourfill(cum_dist, CTDdata.z_ctd, log10(data), infile.V);
    else
        H.p = contourfill(cum_dist, CTDdata.z_ctd, data, infile.V);
    end
    hold on
    colormap(jet)
    set(gca, 'ydir','rev', 'xlim', [0 max(cum_dist)], 'ylim',ylim, 'layer','top')

    % Plot symbols marking each profile across the top axis.
    plot(cum_dist, 0.001,'+k')

    Hxl = xlabel('Distance / km'); Hyl = ylabel('Depth / m');
    Htl = title([cruise ': SWIMS Group ' int2str(i_gr)  ', ' ...
        num2str(CTDdata.yday(1)) ' - ' num2str(CTDdata.yday(end)) ', ' ...
        vars{1}]);

    % Plot the colorbar horizontally below the contour
    Hc=colorbar(H_cbar);
    set(Hc,'fontweight','bold','fontsize',12)
    axes(H_cbar)
    Hxlcb=xlabel(vars{1});
    pos_xlcb=get(Hxlcb,'position');
    set(Hxlcb,'position',[pos_xlcb(1) pos_xlcb(2)+1.5 pos_xlcb(3)])

    % Print the figure
    fig_file = fullfile(swims_data, 'figs', print_format, ...
        ['swims_gr' int2str(i_gr) '_' vars{1}]);
    eval(['print -adobecset -d' print_format ' ' fig_file])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%