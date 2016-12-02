function beam = swims_tidal_beam(infile)
% Usage: beam = swims_tidal_beam(infile);
% Input fields:
%   cruise: string cruise name, e.g. 'bs03' (mandatory)
%   group: real group number, e.g. 1 (mandatory. Only one number is used.)
%   beam: a structure with fields
%       subs: = list of integer indexes of group subs
%       p0: starting pressures (MPa) of beam (Mandatory)
%       dx: distance increment (km) to compute the beam (optional)
%           default is 0.1 km
%       xend: distance to end beam (optional) default is end of array
%           Put NaNs for default if end is needed for only some subs.
%   sensor_pair: {'t1', 's1'} or {'t2', 's2'} (optional, 1st is default)
%   dp_nsq: pressure increment for computing nsq (optional)
% Function: Computes pressure vs distance of upper and lower tidal beams
% using swims griddata for a group sub.
% Note: cruise paths must be set for this script to work.
% Called scripts: get_swims_data, nav2, nm2km, swims_griddata_nsq, 
%   nanmean,
%   calc_ridge_position (for home02, swims groups 1 & 2.)
% Called data files: <cruise>_FinalCruiseLog.mat, <cruise>_folders
% 18dec03

% Check that infile has mandatory fields and they are not empty
reqd_infilefields = {'cruise', 'group', 'beam'};
for i = 1:length(reqd_infilefields)
    if ~isfield(infile, reqd_infilefields{i})
        error(['infile must have field: ' reqd_infilefields{i}])  
    elseif isempty(eval(['infile.' reqd_infilefields{i}]))
        error(['infile.' reqd_infilefields{i} ' is empty.'])
    end
end
% Check that beam structure has mandatory fields
reqd_beamfields = {'subs', 'x0', 'p0'};
for i = 1:length(reqd_beamfields)
    if ~isfield(infile.beam, reqd_beamfields{i})
        error(['infile.beam must have field: ' reqd_beamfields{i}])
    end
end

% Take info from infile fields
cruise = infile.cruise;
i_gr = infile.group;
if length(i_gr) > 1
    display('swims_tidal_beam: Only 1st group number is used.')
end

% Take info from infile.beam fields
subs = infile.beam.subs;
x0 = infile.beam.x0;
p0 = infile.beam.p0;
if isfield(infile.beam, 'dx')
   dx=infile.beam.xend;
else
    dx = 0.1*ones(size(subs));
end
if isfield(infile.beam, 'xend')
    xend=infile.beam.xend;
else
    xend = NaN * x0;
end
if (length(x0)~=length(subs) | length(p0)~=length(subs) ...
        | length(xend)~=length(subs))
    error(['infile.beam.x0, infile.beam.p0 and, ' ...
            'if present, infile.beam.xend & infile.beam.dx ' ...
            'must have same length as infile.beam.subs'])
end

% Execute <cruise>_folders
eval([cruise '_folders'])

% Load the cruise log
eval(['load ' setstr(39) cruise '_FinalCruiseLog.mat' setstr(39)])

% Find the data index in cruise log
i_dat = 1;
while ~strcmp('swims', cr.data_names{i_dat})
    i_dat = i_dat + 1;
end

% Set common fields for nsq infile
nsqin.swims_griddata_indexfile = swims_griddata_indexfile;
nsqin.swims_griddata_datapath = swims_griddata_datapath;
nsq_fields = {'sensor_pair', 'dp_nsq'};

% Loop through specified group subs
for i = 1:length(nsq_fields)  
    if isfield(infile, nsq_fields{i})
        if ~isempty(eval(['infile.' nsq_fields{i}]))
            nsqin.sensor_pair = eval(['infile.' nsq_fields{i}]);
        end
    end
end

% Start output structure
beam.script = fullfile('C:', 'mymatlab', 'swims', 'griddata', 'swims_tidal_beam');
beam.date = datestr(now);
beam.cruise = cruise;
beam.data = 'swims';
beam.group = i_gr;

for i = 1:length(subs)
    
    % Calculate nsq for this sub
    if strcmp(cr.data(i_dat).group(i_gr).subunit, 'yday')      
        nsqin.beg = cr.data(i_dat).group(i_gr).sub(subs(i)).tag(1);
        nsqin.end = cr.data(i_dat).group(i_gr).sub(subs(i)).tag(end);
    else
        error(['cr.data(' int2str(i_dat) ').group(' int2str(i_gr) ').subunit is not ''yday'])
    end
    nsqin.dp = .1;
    nsqout = swims_griddata_nsq(nsqin);
    
    % Get lat & lon for this sub
    ctddata = get_swims_data(nsqin.beg, nsqin.end, ...
        swims_griddata_indexfile, swims_griddata_datapath, {'lat', 'lon'});
    
    % Calculate distance from lat & lon
    switch cruise
        case 'home02' 
            sub_pos = calc_ridge_position(ctddata);
            switch i_gr
                case 1 
                    cum_dist = sub_pos.across_ridge;
                case 2
                    cum_dist = sub_pos.along_ridge;
            end
            dist = diff(cum_dist);
        otherwise
            [dist, cum_dist, bearing]=nav2(ctd.lat, ctd.lon);
            cum_dist = nm2km(cum_dist)       
    end
   
    % Insure that cum_dist goes from small to large
     if cum_dist(1) > cum_dist(end)
        cum_dist = fliplr(cum_dist);
        nsq = fliplr(nsqout.nsq);
     else
        nsq = nsqout.nsq;
     end
     nsq = nanmean(nsq, 2);
     p_nsq = nsqout.p_nsq;
     
    % Calculate slopes of m2_tidal beam for every nsq in sub array
    slopein.lat = nanmean(ctddata.lat);
    slopein.nsq = nsq;
    slope = m2_slope(slopein);
   
    % Set the end of the beam to the end of cum_dist unless a
    % different value was input
    if isnan(xend(i))
        xend(i) = cum_dist(end);
    end
    beam_dist = x0(i):dx(i):xend(i);
    
    % Calculate pressures of upper and lower beams by successively
    % integrating the beam position
    p_upperbeam = p0(i);
    p_lowerbeam = p0(i);
    for j = 2:length(beam_dist)
        % First estimate 
        upperslope_1 = interp1(p_nsq, slope, p_upperbeam(j-1));
        lowerslope_1 = interp1(p_nsq, slope, p_lowerbeam(j-1));
        p_upper = p_upperbeam(j-1) - (abs(upperslope_1) * 1000 * dx(i))/100;
        p_lower = p_lowerbeam(j-1) + (abs(lowerslope_1) * 1000 * dx(i))/100;
        % Second estimate
        upperslope_2 = interp1(p_nsq, slope, nanmean([p_upperbeam(j-1) p_upper]));
        lowerslope_2 = interp1(p_nsq, slope, nanmean([p_lowerbeam(j-1) p_lower]));
        p_upperbeam(j) = p_upperbeam(j-1) - (abs(upperslope_2) * 1000 * dx(i))/100;
        p_lowerbeam(j) = p_lowerbeam(j-1) + (abs(lowerslope_2) * 1000 * dx(i))/100;
    end
    
     beam.sub(i).number = subs(i);
     beam.sub(i).dist = beam_dist;
     beam.sub(i).p_upper = p_upperbeam;
     beam.sub(i).p_lower = p_lowerbeam;
end