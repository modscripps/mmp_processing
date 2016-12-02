function contour_swims_group_vars(infile)
% Usage: contour_swims_group_vars(infile)
% Required fields of infile:
%   cruise: string cruise name, e.g. 'bs03' (mandatory)
%   group: integer number of swims group, e.g. 5 (mandatory)
%   vars: cell with one swims data name, e.g. {'eps1'} (mandatory)
%   V: vector with contour intervals, e.g. -10:2:-6 (mandatory)
% Optional fields of infile:
%   sub: A structure with fields
%       plot_subs = 'y' to plot group subs
%       i_subs = vector with integer sub numbers to plot only some
%   V: A structure with contouring levels, in fields with names
%       matching the variable names in vars e.g. V.t1 = [0:0.1:13];
%   print_format: string with format for printed plot, e.g. 'epsc'
%       (optional; default is 'pdf')
%   ylim: A vector with max and min

% Function: Contours swims variables for a group or for selected subs
%   in the group.  Plots are versus depth and horizontal distance in km.
%   yday is added as a second axis at the top, and the times of drops are
%   also plotted as red x's at the top.
%   mgregg, 15dec03
%   revised to allow chosing subs in the group, mgregg, 3mar04

% Note: <cruise>_folders must be in path and contain entries for
%   'swims_griddata_indexfile' and 'swims_griddata_datapath'

% Define positions of plot and colorbar
pos_cont = [0.1 0.25 0.8 0.65];
pos_cbar = [0.1 0.10 0.8 0.05];
    
%%%%%%%%%%%%%%%%%%%%% Check required fields of infile %%%%%%%%%%%%%%%%%%%%%
if ~isfield(infile, 'cruise')
    error(['infile must have field ''cruise'''])
else
    if isempty(infile.cruise)
        error(['infile.cruise is empty'])
    else
        cruise = infile.cruise;
    end
end

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

if ~isfield(infile, 'vars')
    error(['infile must have field ''vars'''])
else
    if isempty(infile.vars)
        error(['infile.group is empty'])
    else
        vars = infile.vars;
        if ~isa(vars, 'cell')
            error('infile.vars must be a cell array')
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eval([cruise '_folders'])

% Load final cruise log and find index number for swims data
eval(['load ' setstr(39) [cruise '_FinalCruiseLog.mat'] setstr(39)])
i_dat = 1;
while ~strcmp(char(cr.data_names(i_dat)), 'swims')
    i_dat = i_dat + 1;
end

%%%%%%%%%%%%%%%%%%%%%% Check optional fields of infile %%%%%%%%%%%%%%
if isfield(infile, 'sub')
    if isfield(infile.sub, 'plot_subs')
        if strcmp(infile.sub.plot_subs, 'y')
            plot_subs = 'y';
            if isfield(infile.sub, 'i_sub')
                i_sub = infile.sub.i_sub;
            else
                i_sub = cr.data(i_dat).group(i_gr).tag;
            end
        else
            i_sub = 1;
            plot_subs = 'n';
        end
    else
        i_sub = 1;
        plot_subs = 'n';
    end
else
    i_sub = 1;
    plot_subs = 'n';
end

if isfield(infile, 'V')
   if isempty(infile.V)
       rmfield(infile, 'V')
       display('V was an empty field of infile and was removed')
   end
end

if isfield(infile, 'print_format')
    if isempty(infile.print_format)
        display('No format is specified; figure will be printed as pdf.')
        print_format = 'dpdf';
    else
        print_format = infile.print_format;
    end
else
   print_format = 'pdf';
   display('No format is specified; figure will be printed as pdf.')
end
    
if isfield(infile, 'ylim')
    if isempty(infile.ylim)
        rmfield(infile, 'ylim')
        display('ylim was an empty field of infile and was removed')
   end
end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = i_sub % Loop for  subs
    for j = 1:length(infile.vars) % Loop for plot variables
        % Get the beginning and ending yday, based on plotting a whole group or
        % a sub
        if ~strcmp(plot_subs, 'y')
            yday_beg = cr.data(i_dat).group(i_gr).yday(1);
            yday_end  = cr.data(i_dat).group(i_gr).yday(end);
        elseif strcmp(cr.data(i_dat).group(i_gr).subunit, 'yday')
            yday_beg = cr.data(i_dat).group(i_gr).sub(i).tag(1);
            yday_end = cr.data(i_dat).group(i_gr).sub(i).tag(end);
        else
            error(['Could not get tag for subs because '' subunit' ' is not ''yday'])
        end
    
        % Read the data and give them standard names
        if strcmp(char(vars{j}), 'u_wat') | strcmp(char(vars{j}), 'v_wat')
            Veldata = get_adcp_data(yday_beg, yday_end, adcp_indexfile, ...
                adcp_datapath, {});
            eval(['data = Veldata.' vars{j} ';'])
            z = Veldata.z_adcp;
            lat = (Veldata.latFP + Veldata.latLP)/2;
            lon = (Veldata.lonFP + Veldata.lonLP)/2;
        else
            CTDdata = get_swims_data(yday_beg, yday_end, swims_griddata_indexfile, ...
                swims_griddata_datapath, {});
            eval(['data = CTDdata.' vars{j} ';'])
            z = CTDdata.z_ctd;
            lat = CTDdata.lat;
            lon = CTDdata.lon;
        end
    
        % Calculate distance
        [d, cd, b] = nav2(lat, lon);
        cum_dist = [0 nm2km(cd)];
    
        % Set ylim if it is in infile.  Otherwise calculate it
        if isfield(infile, 'ylim')
            ylim = infile.ylim;
        else
            y_avg = nanmean(data,2);
            i_data = find(~isnan(nanmean(data,2)));
            y_min = CTDdata.z_ctd(min(find(~isnan(i_data))));
            y_max = CTDdata.z_ctd(max(find(~isnan(i_data))));
            ylim = [y_min y_max];
        end
    
        % Set V if it is in infile.  Otherwise, calculate it
        if isfield(infile, 'V')
            eval(['V = infile.V.' vars{j} ';']);
        else
            data_min = min(data(:));
            data_max = max(data(:));
            V = [data_min:(data_max - data_min)/20:data_max];
        end
    
        % Select and adjust data
        if strcmp(vars{j}, 's1') | strcmp(vars{j}, 's2')
            data = 1000 * data;
        elseif strcmp(vars{j}, 'eps1') | strcmp(vars{j}, 'eps2') ...
                | strcmp(vars{j}, 'krho1') | strcmp(vars{j}, 'krho2')
            data = log10(data);
            i_inf = find(data == -Inf | data == Inf);
            if ~isempty(i_inf)
                data(i_inf) = NaN;
            end
        end

        Hf(i) = figure;
        H_cbar = axes('position', pos_cbar);
        H_cont = axes('position', pos_cont,'box','off',...
            'XAxisLocation','bottom');

        H.p = contourfill(cum_dist, z, data, V);
        hold on
        caxis([V(1) V(end)])
        if strcmp(char(vars{j}), 'u_wat') | strcmp(char(vars{j}), 'v_wat')
            cmp = redblue(192);
        else
            cmp = jet;
        end
        colormap(cmp)
        caxis([V(1) V(end)])
        set(gca, 'ydir','rev', 'xlim', [0 max(cum_dist)], 'ylim',ylim, 'layer','top',...
            'box','off')

        % Plot symbols marking each profile across the top axis.
        plot(cum_dist, 0.001,'+r')

        Hxl = xlabel('Distance / km'); Hyl = ylabel('Depth / m');
        title_str = [cruise ': SWIMS Group ' int2str(i_gr)];
        if strcmp(plot_subs, 'y')
            title_str = [title_str ', sub: ' int2str(i)];
        end
        if strcmp(char(vars{j}), 'u_wat')
            var_name = 'u_{wat}';
        elseif strcmp(char(vars{j}), 'v_wat')
            var_name = 'v_{wat}';
        else
            var_name = vars{j};
        end
        title_str = [title_str ', yday: ' num2str(yday_beg) ' - ' ...
            num2str(yday_end) ', var: ' var_name];
        %title(title_str)
        
        % Set the units
        switch char(vars{j})
            case {'t1', 't2'}
                units = ['{}^o C'];
            case {'s1', 's2'}
                units = [' ppt'];
            case {'sgth1', 'sgth2'}
                units = [' kg m^{-3}'];
            case {'dox'}
                units = [' ml l^{-1}'];
            case {'flu'}
                units = [' \mu l l^{-1}'];
            case {'eps1', 'eps2'}
                units = [' W kg^{-1}'];
            case {'obs'}
                units = [' FTU'];
            case {'u_wat', 'v_wat'}
                units = [' m s^{-1}'];
        end

        % Plot the colorbar horizontally below the contour
        Hc=colorbar(H_cbar);
        set(Hc,'fontweight','bold','fontsize',12)
        axes(H_cbar)
        Hxlcb=xlabel([var_name ' ' units]);
        pos_xlcb=get(Hxlcb,'position');
        set(Hxlcb,'position',[pos_xlcb(1) pos_xlcb(2)+1.5 pos_xlcb(3)])

        % Print the figure
        fig_folder = fullfile('C:\', cruise, 'figs', 'eps', 'swims');
        fig_name = [cruise '_swims_gr' int2str(i_gr)];
        if strcmp(plot_subs, 'y')
            fig_name = [fig_name '_sub' int2str(i)];
        end
        fig_name = [fig_name '_' vars{j}];
        fig_path = fullfile(fig_folder, fig_name);
        eval(['print -adobecset -' print_format ' ' fig_path])
        
        % Label the top xaxis with yday
        Hax2 = axes('position',get(H_cont,'position'), 'XAxisLocation','top',...
            'xlim',[yday_beg yday_end], 'YAxisLocation','right', 'ylim',ylim,...
            'yticklabel','');
        Hxl2 = xlabel('yday');
        
         % Print the figure
        fig_folder = fullfile('C:\', cruise, 'figs', 'eps', 'swims');
        fig_name = [cruise '_swims_gr' int2str(i_gr)];
        if strcmp(plot_subs, 'y')
            fig_name = [fig_name '_sub' int2str(i)];
        end
        fig_name = [fig_name '_' vars{j}];
        fig_path = fullfile(fig_folder, fig_name);
        eval(['print -adobecset -' print_format ' ' fig_path])
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%