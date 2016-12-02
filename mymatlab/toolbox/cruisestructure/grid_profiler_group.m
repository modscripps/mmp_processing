function grid_profiler_group(cruise, data, groups, dp)
% Useage: grid_profiler_group(cruise, data, groups, dp)
% Inputs:
%   cruise: string name of cruise, e.g. 'bs03'
%   data: string name of profiler, 'amp' or 'mmp'
%   groups: row vector with cruise group numbers, e.g. 1:3
%   dp: size of pressure bin for gridded data.  Default is dp = 0.005 MPa.
% Function:
%   Averages processed data for all profiles in a range of groups for a
%   specified cruise.  Presently, variables are only t, s, sgth.  The
%   averages are put in a structure and stored in the griddata folder for
%   the profiler and cruise.
%   mgregg, 20oct03
%   22nov03, added year and yday to output, mcg
%   8dec03, changed structure name to gr, mcg

if nargin < 4 dp = 0.005; end

eval([cruise '_folders'])

% Load the final cruise log
eval(['load ' setstr(39) cruise '_FinalCruiseLog.mat' setstr(39)])

% Find the data number, i_dat, in the cruise log
for i_dat = 1:length(cr.data_names)
    if strcmp(cr.data_names(i_dat), data) break, end;
end

% Load the amp or mmp log
datalog_str = fullfile(eval([data '_procdata']), [ data 'log.mat']);
%[eval([data '_procdata']) '\' data 'log.mat'];
eval(['load ' setstr(39) datalog_str setstr(39)])
eval(['datalog = ' data 'log;'])

for i_gr = groups(1):groups(end)

    more_data = 1;
    i_sub = 0;
    drops = [];
    while more_data == 1
        % Get vector of amp drop numbers 
        % If this group has no subs
        if isempty(cr.data(i_dat).group(i_gr).sub) ...
                & strcmp(cr.data(i_dat).group(i_gr).unit, 'drop')
            drops = cr.data(i_dat).group(i_gr).tag;
            more_data = 0;
        % Or, if this group has subs, continue cycling through getting
        % drops in the subs
        else
            i_sub = i_sub + 1;
            drops = [drops cr.data(i_dat).group(i_gr).sub(i_sub).tag];
            if i_sub == length(cr.data(i_dat).group(i_gr).sub) more_data = 0; end
        end
    
        % Get vectors of lat, lon and max_pr for the drops
        lat = []; lon = []; max_pr = []; year = []; yday = [];
        for i = 1:length(drops)
            i_drop = find(datalog(:,1) == drops(i));
            if ~isempty(i_drop) 
                year = [year datalog(i_drop, 2)];
                yday = [yday datalog(i_drop, 3)];
                lat = [lat datalog(i_drop, 5)];
                lon = [lon datalog(i_drop, 4)];
                max_pr = [max_pr datalog(i_drop, 8)];
            else
                display(['Drop ' int2str(drops(i)) ' is not in datalog.'])
            end
        end
    
    
        % Setup arrays for potential temperature, salinity, and potential
        % density
        p_out = (.02:dp:max(max_pr))';  % Setup depth array at 0.5 m increments to max 
                                        %depth of any drop
        theta = NaN*ones(length(p_out), length(drops)); temp = theta;
        sal = theta; sgtheta = theta; npts = theta;
    
        % Get potential temperature, salinity, and potential density, average vertically, 
        % and put in
        % arrays
        for i_drop = 1:length(drops)
            
            % Get the thetasd profiles
            if strcmp(data, 'amp')
                [pr_tsd,t,th,s,sgth]=get_thetasd3_amp(drops(i_drop));
            elseif strcmp(data, 'mmp')
                [s,t,th,sgth,pr_tsd]=get_thetasd_mmp(drops(i_drop));
            end
            
            % Average temp (t), potential temperature (th), salinity (s),  
            % and potential density (sgth) for one profile to fit the depth grid
            p_lower = p_out(1) - dp/2;
            p_upper = p_out(end) + dp/2;
            [p_tavg, t_avg ,t_npts]=avg_pointdata(t, pr_tsd, p_lower, dp, p_upper, ...
                'o' , 'c');
            [p_thavg, th_avg ,th_npts]=avg_pointdata(th, pr_tsd, p_lower, dp, p_upper, ...
                'o' , 'c');
            [p_savg, s_avg ,s_npts]=avg_pointdata(s, pr_tsd, p_lower, dp, p_upper, ...
                'o' , 'c');
            [p_sgthavg, sgth_avg ,sgth_npts]=avg_pointdata(sgth, pr_tsd, p_lower, dp, ...
                p_upper, 'o' , 'c');
        
            % Put averages for this profile into arrays for contouring
            i_p = find(p_out >= p_thavg(1) & p_out <= p_thavg(end));
            if isequal(p_out(i_p), p_thavg)
                temp(i_p, i_drop) = t_avg;
                theta(i_p, i_drop) = th_avg;
                sal(i_p, i_drop) = s_avg;
                sgtheta(i_p, i_drop) = sgth_avg;
                npts(i_p, i_drop) = min(th_npts, s_npts);
            else
                display(['Averaged profiles for drop ' int2str(drops(i_drop)) ...
                        ' do not match arrays.'])
            end
        end
    end

    % Put averages in structure and write to disk if averages were
    % calculated.
    if length(lat) > 1
        gr.data = data;
        gr.cruise = cruise;
        gr.group = i_gr;
        gr.drops = drops;
        gr.date = datestr(now);
        gr.script = 'C:\mymatlab\profiler\grid\grid_profiler_group.m';
        gr.pr = p_out;
        gr.t = temp;
        gr.th = theta;
        gr.s = sal;
        gr.sgth = sgtheta;
        gr.year = year;
        gr.yday = yday;
        gr.lat = lat;
        gr.lon = lon;

        out_file = fullfile('C:', data, cruise, 'griddata', ...
            [data '_' cruise '_gr' int2str(i_gr) '_thetasd']);
        eval(['save ' setstr(39) out_file setstr(39) ' gr'])
    end
end