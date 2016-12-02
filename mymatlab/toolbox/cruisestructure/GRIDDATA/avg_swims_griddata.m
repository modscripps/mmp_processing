function outfile = avg_swims_griddata(infile)
% Usage: outfile = avg_swims_griddata(infile);
% Infile fields:
%   cruise: string name, e.g. 'bs03' (mandatory)
%   yday: 2-element real vector. (mandatory)
%       The interval can exceed the 2-day limit allowed 
%       by get_swims_data, but the first 2-day interval
%       must contain some data.
%   vars: cell array of strings with variable names, in
%       the same format as vars of 'get_swims_data' (optional)
% Function: 
%   Average profiles of swims griddata.  If vars is not
% specified, the full list will be used, except for some, e.g. 'starts' and
% 'ends'.
% mgregg, 9nov03

YDAY_LIM = 2;

outfile.script = fullfile('C:', 'mymatlab', 'swims', 'griddata', ...
    'avg_swims_griddata.m');
outfile.date = datestr(now);

% Check that infile contains mandatory fields
if isfield(infile, 'cruise')
    cruise = infile.cruise;
else
    error(['infile does not contain field ''cruise'])
end   
if isfield(infile, 'yday')
    yday = infile.yday;
    if length(yday) ~= 2
        error('infile.yday must have two elements');
    end
    if yday(1) >= yday(2)
        error('yday(1) >= yday(2)')
    end
else
    error(['infile does not contain field ''yday']);
end

% If infile contains field 'vars' put it in variable 'vars'.  
% Otherwise, set vars to take all variables
if isfield(infile, 'vars')
    vars = infile.vars;
else
    vars = {};
end
    
% Execute <cruise>_folders
folders_file = [cruise '_folders.m'];
if exist(folders_file) == 2
    eval([cruise '_folders'])
else
    error([folders_file ' not found'])
end

% Load cruise index file for griddata and check zgrids.  If zgrids are
% identical, that grid is taken for the average.  If not, the zgrid is
% defined as the min upper bound and max increment and bottom of the
% zgrids.
eval(['load ' setstr(39) 'SWIMS_' cruise '_gridfiles.mat' setstr(39)])
i_yd = find(Index.yday_beg<=yday(2) & Index.yday_end>= yday(1));
if isempty(i_yd)
    display('avg_swims_griddata: no griddata in specified range')
    break
else
    if sum(diff(Index.zgrid(i_yd,1)))==0 & sum(diff(Index.zgrid(i_yd,2)))==0 ...
          & sum(diff(Index.zgrid(i_yd,3)))==0 
        zgrid = [];
    else
        zgrid = [min(Index.zgrid(i_yd,1)) max(Index.zgrid(i_yd,2)) max(Index.zgrid(i_yd,3))];
    end
end
    
% Add divisions within yday if the range exceeds that allowed
% by get_swims_data
if yday(2)-yday(1) > YDAY_LIM
    yday = yday(1):YDAY_LIM:yday(2);
end
if yday(end)<infile.yday(2)
    yday = [yday infile.yday(2)];
end

% Get vars variables from the gridded swims ctd data
CTD = get_swims_data(yday(1), yday(2), swims_griddata_indexfile, ...
    swims_griddata_datapath, vars);

outfile.data = 'swims';
outfile.z_ctd = CTD.z_ctd;
outfile.p_ctd = CTD.p_ctd;
outfile.yday = [yday(1) yday(2)];
outfile.n_profiles = length(CTD.yday);
fields = fieldnames(CTD);

% Average for the first YDAY_LIM within yday
for i_field = 1:length(fields)
    field = char(fields(i_field,:));
    if ~strcmp(field, 'z_ctd') & ~strcmp(field, 'p_ctd') & ~strcmp(field, 'starts') ...
            & ~strcmp(field, 'ends') & ~strcmp(field, 'updown') & ~strcmp(field, 'yd_byz') ...
            & ~strcmp(field, 'yday_LDbeg') & ~strcmp(field, 'yday_LDend') & ~strcmp(field, 'yday')
        
        % If zgrid is empty, i.e. if all gridfiles have identical zgrids, 
        if isempty(zgrid)
            eval(['outfile.' field ' = nanmean(CTD.' field ',2);'])
        else
        end
    end
end

% If the range of yday exceeds YDAY_LIM average in the remainder
if length(yday)>2
    for i_yday = 3:length(yday)
        outfile.yday = [yday(1) yday(i_yday)];
        
        CTD = get_swims_data(yday(i_yday-1), yday(i_yday), swims_griddata_indexfile, ...
            swims_griddata_datapath, vars);
        n_profiles = length(CTD.yday);
        
        for i_field = 1:length(fields)
            field = char(fields(i_field,:));
    
            if ~strcmp(field, 'z_ctd') & ~strcmp(field, 'p_ctd') & ~strcmp(field, 'starts') ...
                & ~strcmp(field, 'ends') & ~strcmp(field, 'updown') & ~strcmp(field, 'yd_byz') ...
                & ~strcmp(field, 'yday_LDbeg') & ~strcmp(field, 'yday_LDend') & ~strcmp(field, 'yday') 
        
                % Put the existing average into tmp1
                eval(['tmp1 = outfile.' field ';'])
                % Put the new average into tmp2
                eval(['tmp2 = nanmean(CTD.' field ',2);'])
                
                % Average tmp1 and tmp2         
                tmp3 = [outfile.n_profiles*tmp1 + n_profiles*tmp2] ...
                    /(outfile.n_profiles + n_profiles);
                eval(['outfile.' field ' = tmp3;'])
            end
       end
       outfile.n_profiles = outfile.n_profiles + n_profiles;
    end
end

