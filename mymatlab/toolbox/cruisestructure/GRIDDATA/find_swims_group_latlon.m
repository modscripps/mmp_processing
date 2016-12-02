% find_swims_group_latlon
% Usage: find_swims_group_latlon
%       First, edit file to edit cruise and yday.  If all griddata up to
%       present time are wanted, leave yday with only start time; script
%       will take present time.
% Function: Plots aides to defining yday between legs of a swims group.
%   Plots are   1) lat, lon of each profile, from griddata
%               2) lat vs yday, from griddata
%               3) lon vs yday, from griddata
%               4) depth vs yday, from rawdata
%               5) course completed vs yday, from griddata
% Note: One way of using this script is to write a file containing indices
% of 1st and last profiles in a leg, e.g. i=[1 9 10 28 29 45];  Then
% execute CTDdata.yday(i) to list the ydays and copy pairs into appropriate
% entries in the raw cruise log.
% mgregg, 9nov03

clear
close all
cruise = 'ml04';
yday = [316.96363];

eval([cruise '_folders'])

UTC = 8;
% If yday has only one number ask for UTC correction
if length(yday) == 1
    %UTC = input('Hours to change local time to UTC? ');
    yday(2) = yearday_now(UTC);
end

CTDraw = get_swims_rawdata(yday(1), yday(end), swims_rawdatamat_indexfile, ...
    swims_rawctddatamat);

CTDdata = get_swims_data(yday(1), yday(end), swims_griddata_indexfile, ...
    swims_griddata_datapath);

Hfig_latlon = figure;
plot(CTDdata.lon, CTDdata.lat, '.')
hold on
plot(CTDdata.lon(10:10:end), CTDdata.lat(10:10:end), 'o')
grid on
xlabel('Longitude'), ylabel('Latitude')
title(['swims griddata yday = ' num2str(yday(1)) ' to ' num2str(yday(end))])

Hfig_ydaylat = figure;
plot(CTDdata.yday, CTDdata.lat, '.')
hold on
plot(CTDdata.yday(10:10:end), CTDdata.lat(10:10:end), 'o')
grid on
xlabel('yday'), ylabel('Latitude')
title(['swims griddata yday = ' num2str(yday(1)) ' to ' num2str(yday(end))])

Hfig_ydaylon = figure;
plot(CTDdata.yday, CTDdata.lon, '.')
hold on
plot(CTDdata.yday(10:10:end), CTDdata.lon(10:10:end), 'o')
grid on
xlabel('yday'), ylabel('Longitude')
title(['swims griddata yday = ' num2str(yday(1)) ' to ' num2str(yday(end))])

Hfig_ydayp = figure;
plot(CTDraw.yday_adj, CTDraw.Pr)
hold on
p_start = interp1(CTDraw.yday_adj, CTDraw.Pr, CTDdata.yday);
plot(CTDdata.yday, p_start, '.r')
plot(CTDdata.yday(10:10:end), p_start(10:10:end), 'or')
grid on
xlabel('yday_adj'), ylabel('p / MPa')
title(['swims griddata yday = ' num2str(yday(1)) ' to ' num2str(yday(end))])

Hfig_course = figure;
[dist, cum_dist, course] = nav2(CTDdata.lat, CTDdata.lon);
plot(CTDdata.yday(2:end), course, '.')
grid on
xlabel('yday'), ylabel('course')
title(['swims griddata yday = ' num2str(yday(1)) ' to ' num2str(yday(end))])

% List relevant data on the command line
course = [0 course];
i=1:length(CTDdata.yday);
[i(:) CTDdata.yday(:) CTDdata.lat(:) CTDdata.lon(:) course(:)]