function ts_grid = plot_summaries_griddata(infile);
% Usage: ts_grid = plot_summaries_griddata(infile);
% Infile: a structure that must contain the following fields
%   yday: vector with at least two elements, the 2nd later than the 1st
%   vars: cell with names of variables to be plotted.
%   indexfile: Full path name of the index file for swims griddata
%   datapath: Full path of folder holding griddata files
% Ts_grid: a structure containing fields
%   yday: Column vector with yday at start of each profile
%   th1: 2d array of th1 for all profiles
%   s1: 2d array of s1 for all profiles
%   p_ctd: Row vector with pressures of data samples
%   z_ctd: Row vector with depths of data samples
% Function: Makes sequential theta S plots of all profiles between
% specified time limits and returns the data.  All data are overlaid as
% on one plot as black dots.  Then, a keyboard input asks whether the user
% wants to step through the profiles from the beginning sequentially
% overlaying each profile in red.  Execution pauses after each of these
% plots.
% 5apr02 mgregg, major revision 2apr03, mgregg

PANEL_SIZE = [0 0 .4 .2];
PANELS_PER_PAGE = 6;

ts_grid.script = 'C:\mymatlab\swims\griddata\plot\plot_summaries_griddata.m';
ts_grid.datestr = datestr(clock);

if ~isfield(infile, 'yday') 
    error('''yday'' must be be a field of infile.');
elseif infile.yday(end) <= infile.yday(1) error('yday(end) must exceed yday(1)');
end

if ~isfield(infile, 'swims_griddata_indexfile') error('''swims_griddata_indexfile''', ...
    ' must be a field of infile.'); end
if ~isfield(infile, 'swims_griddata_datapath') error('''swims_griddata_datapath''', ...
        ' must be a field of infile.'); end

if ~isfield(infile, 'vars')
    error('''vars' must be a field of infile.'};
else
    n_vars = {'s1', 'th1'};
end

if n_vars >= PANELS_PER_PAGE
   
n_pages = ceil(n_vars / PANELS_PER_PAGE);
panels_per_page = 
for i_page = 1:n_pages

ts_grid = get_swims_data(infile.yday(1), infile.yday(end), ...
    infile.swims_griddata_indexfile, infile.swims_griddata_datapath, vars);

figure
plot(1000*ts_grid.s1,ts_grid.th1,'.k')
xlabel('S'), ylabel('\theta / {}^o C')
hold on
set(gca,'xminortick','on','yminortick','on')

% Ask whether individual profiles should be overlaid
step_thru = input('Overlay individual profiles in sequence?', 's');
if strcmp(step_thru, 'y')
    for i=1:length(ts_grid.yday)
        Hp=plot(1000*ts_grid.s1(:,i),ts_grid.th1(:,i),'.r');
        title(['Profile ' , int2str(i) ', yday = ' num2str(ts_grid.yday(i))])
        pause
        delete(Hp(:))
    end
end

title(['swims, ' int2str(length(ts_grid.yday)) ' profiles, yday\_start = ', ...
        num2str(ts_grid.yday(1)) ', yday\_stop = ' num2str(ts_grid.yday(end))])