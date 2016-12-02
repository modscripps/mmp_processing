function outfile = swims_griddata_nsq(infile);
% Usage: outfile = swims_griddata_nsq(infile);
% Infile: a structure with fields
%   cruise: string cruise name (mandatory)
%   beg: 1 number with the start yday (mandatory)
%   end: 1 number with the end yday (mandatory)
%   swims_griddata_indexfile: string path of this index file (mandatory)
%   swims_griddata_datapath: string path of these griddata (mandatory)
%   p_start: real pressure to start calculation (optional, default is
%       data start)
%   dp: real pressure interval for nsq (optional, default is grid spacing)
%   sensor_pair: cell string array of data pair to use (optional, default is
%       {'t1', 's1'}. {'t2', 's2'} is other allowed option
%   plot: 'y' will produce a filled contour plot of nsq
% Outfile: a structure with fields
%   script:
%   date:
%   sensor_pair:
%   swims_griddata_indexfile:
%   swims_griddata_datapath:
%   p_nsq:
%   nsq:
%   yday:
%   lat:
%   lon:
% Function: Computes nsq on a specified pressure grid, and will
%   plot the results if specified.
% 12dec03, mgregg

% Check infile fields
if ~isfield(infile, 'cruise')
    error(['infile must contain field ''cruise'''])
elseif isempty(infile.cruise)
    error(['infile.cruise is empty'])
else
    cruise = infile.cruise;
end
if ~isfield(infile, 'beg')
    error(['infile must contain field ''beg'''])
elseif (~isreal(infile.beg) | length(infile.beg)~=1)
        error('infile.beg must be real with 1 elements')
end
if ~isfield(infile, 'end')
    error(['infile must contain field ''end'''])
elseif (~isreal(infile.end) | length(infile.end)~=1)
    error('infile.end must be real with 1 elements')
elseif infile.beg >= infile.end
    error('infile.beg >= infile.end')
end
if ~isfield(infile, 'swims_griddata_indexfile')
    error(['infile must contain field ''swims_griddata_indexfile'''])
elseif ~isstr(infile.swims_griddata_indexfile)
    error('infile.swims_griddata_indexfile must be a string')
end
if ~isfield(infile, 'swims_griddata_datapath')
    error(['infile must contain field ''swims_griddata_datapath'''])
elseif ~isstr(infile.swims_griddata_datapath)
    error('infile.swims_griddata_datapath must be a string')
end
if isfield(infile, 'sensor_pair')
    if ~isempty(infile.sensor_pair)
        if ~isequal(infile.sensor_pair, {'t2', 's2'})
            infile.sensor_pair = {'t1', 's1'};
        end
    end
else
   infile.sensor_pair = {'t1', 's1'}; 
end
if isfield(infile, 'dp')
    if (isempty(infile.dp) | infile.dp<=0.005)
        error('If infile.dp is specified, it must be >= 0.005')
    end
end
    
% load cruise folders
eval([cruise '_folders'])

infile.vars = {};
ctddata = get_swims_data(infile.beg, infile.end, ...
    swims_griddata_indexfile, swims_griddata_datapath, {});
if isequal(infile.sensor_pair, {'t1', 's1'})
    t = ctddata.t1; s = ctddata.s1;
else
    t = ctddata.t2; s = ctddata.s2;
end

% Check that specified dp is no smaller than grid spacing and 
% set dp to swims grid spacing if no suitable value is specified.
if isfield(infile, 'dp')
    if infile.dp < mean(diff(ctddata.p_ctd))
        error(['infile.dp < ' mean(diff(ctddata.p_ctd)), ...
                ' , the swims grid spacing'])
    end    
    dp = infile.dp;
else
    dp = mean(diff(ctddata.p_ctd));
end

% Eliminate rows of t,s having only NaNs.
[i,j]=find(~isnan(s));
i_min = min(i); i_max = max(i); 
i_data = i_min:i_max;
p = ctddata.p_ctd(i_data); p = p(:);
s = s(i_data,:);
t = t(i_data,:);
p_min = ctddata.p_ctd(i_min); 
p_max = ctddata.p_ctd(i_max);

% Set p_start
if isfield(infile, 'p_start')
    p_start = infile.p_start;
else
    p_start = ctddata.p_ctd(1);
end

% Make p_start-dp/2 larger than p_min
while p_start-dp/2 < p_min
    p_start = p_start + dp;
end
p_nsq = p_start:dp:p_max-dp/2; p_nsq = p_nsq(:);

% Calculate nsq by columns
for i = 1:size(s, 2)
    pint = nsq_pintervals2(s(:,i), t(:,i), p, ...
        [p_nsq(1:end)-dp/2 p_nsq(1:end)+dp/2]);
    if max(p_nsq - pint.p)<1e-10
        nsq(:,i) = pint.nsq;
    else
        error([' pint.p not identical to p_nsq for profile ' int2str(i)])
    end
end

outfile.cruise = infile.cruise;
outfile.script = 'C:\mymatlab\swims\griddata\swims_griddata_nsq.m';
outfile.date = datestr(now);
outfile.p_nsq = p_nsq;
outfile.nsq = nsq;
outfile.yday = ctddata.yday;
outfile.lon = ctddata.lon;
outfile.lat = ctddata.lat;
outfile.swims_griddata_indexfile = infile.swims_griddata_indexfile;
outfile.swims_griddata_datapath = infile.swims_griddata_datapath;
outfile.sensor_pair = infile.sensor_pair;