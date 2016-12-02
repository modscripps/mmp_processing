function CTD = plot_swims_griddata_profiles(infile)
% Useage: CTD = plot_swims_griddata_profiles(infile);
% Infile fields
%   cruise: string cruise name (mandatory)
%   yday: yday range, at lest one value is mandatory.
%       If only one variable is specified, it will be assumed to
%       be the start time, and the present time will be used for the
%       stop time.  yday interval cannot exceed 2 days.
%   vars: cell array of standard swims string names 
%       of variables to be plotted.  If it is not a field,
%       vars = {'th1', 's1', 'sgth1', 'dox', 'flu', 'obs', 'eps1', 'krho1'};
% Function: Plots all profiles within a specified yday range, providing
% that the interval is less than 2 days.  The variables to be plotted can
% be specified. Otherwise, all of the standard variables will be plotted.
% mgregg, 21nov03

cruise = infile.cruise;
yday = infile.yday;

% Execute <cruise>_folders
folders_file = [cruise '_folders.m'];
if exist(folders_file) == 2
    eval([cruise '_folders'])
else
    error([folders_file ' not found'])
end

% If yday has only one number ask for UTC correction
UTC = 8;
if length(infile.yday) == 1
    %UTC = input('Hours to change local time to UTC? ');
    yday(2) = yearday_now(UTC);
end

if isfield(infile, 'vars')
    vars = infile.vars;
else
    vars = {'th1', 's1', 'sgth1', 'dox', 'flu', 'obs', 'eps1', 'krho1'};
end

CTD = get_swims_data(yday(1), yday(2), swims_griddata_indexfile, ...
    swims_griddata_datapath, {});
 p = CTD.p_ctd;
 
for i = 1:length(vars)
    Hf(i) = figure;
    
    switch char(vars(i))
        case    {'s1', 's2'}
            eval(['data = 1000*CTD.' char(vars(i)) ';'])
        case {'eps1', 'eps2', 'krho1', 'krho2'}
            eval(['data = log10(CTD.' char(vars(i)) ');'])
        otherwise
            eval(['data = CTD.' char(vars(i)) ';'])
    end
    
    if isfield(infile, 'plim')
        ylim = infile.plim;
    else
        ylim = [0 p(max(find(~isnan(nanmean(data,2)))))];
    end
    
    eval(['plot(data, p)'])   
    set(gca, 'ydir', 'rev', 'ylim', ylim)
    
    % Make axis labels and plot title
    ylabel('p / MPa')
    switch char(vars(i))
        case {'th1', 'th2'}
            xl = '\theta / {}^oC';
        case {'s1', 's2'}
            xl = ' S / ppt';
        case {'sgth1', 'sgth2'}
            xl = '\sigma_{\theta} / kg m^{-3}';
        case {'eps1', 'eps2'}
            xl = '\log10 (\epsilon / W kg^{-1})';
        case {'krho1', 'krho2'}
            xl = '\log10 (\K_{\rho} / m^2 s^{-1})';
        case {'dox'}
            xl = 'O_2 / ml l^{-1}';
        case {'flu'}
            xl = '';
        case {'obs'}
            xl = 'Optical Backscatter / Formazin Turbidity Units';
    end
    xlabel(xl)
      
    title_str = [cruise, char(vars(i)) ', yday = ' int2str(yday(1)) ' - ' int2str(yday(2))];
    title(title_str)
end
