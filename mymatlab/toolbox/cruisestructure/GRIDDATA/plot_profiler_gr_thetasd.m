function plot_profiler_gr_thetasd(cruise, data, i_gr)
% Useage: plot_amp_profiler_thetasd(cruise, data, i_gr)
%   cruise: string cruise name, e.g. 'bs03'
%   data: string data name, 'amp' or 'mmp'
%   i_gr: integer group number
% Function: 
%   Plots gridded profiler thetasd data, producing separate plots for theta,
% salinity, sigma_theta, and a ts diagram.  Each plot is printed to a
% pdf file in the current directory.  Plot names are
% <data>_gr<i_gr>_<variable>.pdf.
% MGregg, 21oct03.
%   Before executing be certain that 'set_<cruise>_paths has been executed.

% load amplog or mmplog
eval(['load ' setstr(39) data 'log.mat' setstr(39)])

% Load the final cruise log
eval(['load ' setstr(39) cruise '_FinalCruiseLog.mat' setstr(39)])

% Find the data number, i_dat, in the cruise log
for i_dat = 1:length(cr.data_names)
    if strcmp(cr.data_names(i_dat), data) break, end;
end

% Load the group average structure
gravg_file = fullfile('C:', data, cruise, 'griddata', [data '_' cruise '_gr' int2str(i_gr) '_thetasd.mat']);
if exist(gravg_file) == 2
    eval(['load ' setstr(39) gravg_file setstr(39)])
else
    error([gravg_file ' does not exist'])
end

pos_cbar = [0.12 0.12 0.8 .03];
pos_plot = [0.12 0.25 .8 .7];

%%%%%%%%%%%%%%%%%%%%%%%%% Plot theta %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hcf_th = figure;
Hax_thcb = axes('position', pos_cbar);
Hax_th = axes('position', pos_plot, 'box','on');

% Find max th depth
th_mean = nanmean(gravg.th, 2);
pr_max = gravg.pr(max(find(~isnan(th_mean))));


Hp_th = pcolor(gravg.drops, gravg.pr, gravg.th);
hold on
shading interp
set(gca, 'ydir','rev', 'ylim', [0 pr_max], 'layer', 'top', ...
    'xtick',[gravg.drops(1):5:gravg.drops(end)], ...
    'xticklabel',gravg.drops(1):5:gravg.drops(end), 'ticklength',[.02 .02]);
ylabel('p / MPa'), xlabel('Drop number')
title(['bs03, amp group ' int2str(i_gr)])

% Put ticks across top of page at drop numbers
plot(gravg.drops, 0, '+r', 'linewidth',1.5)

% Plot vertical lines at the ends of subs
if ~isempty(cr.data(i_dat).group(i_gr).sub)
    for i_sub = 1:length(cr.data(i_dat).group(i_gr).sub)
        last_drop = cr.data(i_dat).group(i_gr).sub(i_sub).tag(end);
        axis(Hax_th);
        plot([last_drop last_drop], [0 pr_max], 'k')
    end
end

Hc_th=colorbar(Hax_thcb);
set(Hc_th,'fontweight','bold','fontsize',10)
axes(Hax_thcb)
Hxlcb_th=xlabel('Theta');
pos_xlcb=get(Hxlcb_th,'position');
set(Hxlcb_th,'position',[pos_xlcb(1) pos_xlcb(2)+1.5 pos_xlcb(3)])

eval(['print -adobecset -dpdf ' data '_gr' int2str(i_gr) '_th'])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

%%%%%%%%%%%%%%%%%%%%%%%%% Plot salinity %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hcf_s = figure;
Hax_scb = axes('position', pos_cbar);
Hax_s = axes('position', pos_plot, 'box','on');

% Find max s depth
s_mean = nanmean(gravg.s, 2);
pr_max = gravg.pr(max(find(~isnan(s_mean))));

Hp_s = pcolor(gravg.drops, gravg.pr, gravg.s);
hold on
shading interp
set(gca, 'ydir','rev', 'ylim', [0 pr_max], 'layer', 'top', ...
    'xtick',[gravg.drops(1):5:gravg.drops(end)], ...
    'xticklabel',gravg.drops(1):5:gravg.drops(end), 'ticklength',[.02 .02]);
ylabel('p / MPa'), xlabel('Drop number')
title(['bs03, amp group ' int2str(i_gr)])

% Put ticks across top of page at drop numbers
plot(gravg.drops, 0, '+r', 'linewidth',1.5)

% Plot vertical lines at the ends of subs
if ~isempty(cr.data(i_dat).group(i_gr).sub)
    for i_sub = 1:length(cr.data(i_dat).group(i_gr).sub)
        last_drop = cr.data(i_dat).group(i_gr).sub(i_sub).tag(end);
        axis(Hax_th);
        plot([last_drop last_drop], [0 pr_max], 'k')
    end
end

Hc_s=colorbar(Hax_scb);
set(Hc_s,'fontweight','bold','fontsize',10)
axes(Hax_scb)
Hxlcb_s=xlabel('Salinity');
pos_xlcb=get(Hxlcb_s,'position');
set(Hxlcb_s,'position',[pos_xlcb(1) pos_xlcb(2)+1.5 pos_xlcb(3)])

eval(['print -adobecset -dpdf ' data '_gr' int2str(i_gr) '_s'])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% Plot sigma_theta %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hcf_sgth = figure;
Hax_sgthcb = axes('position', pos_cbar);
Hax_sgth = axes('position', pos_plot, 'box','on');

% Find max sgth depth
sgth_mean = nanmean(gravg.sgth, 2);
pr_max = gravg.pr(max(find(~isnan(sgth_mean))));

Hp_sgth = pcolor(gravg.drops, gravg.pr, gravg.sgth);
hold on
shading interp
set(gca, 'ydir','rev', 'ylim', [0 pr_max], 'layer', 'top', ...
    'xtick',[gravg.drops(1):5:gravg.drops(end)], ...
    'xticklabel',gravg.drops(1):5:gravg.drops(end), 'ticklength',[.02 .02]);
ylabel('p / MPa'), xlabel('Drop number')
title(['bs03, amp group ' int2str(i_gr)])

% Put ticks across top of page at drop numbers
plot(gravg.drops, 0, '+r', 'linewidth',1.5)

% Plot vertical lines at the ends of subs
if ~isempty(cr.data(i_dat).group(i_gr).sub)
    for i_sub = 1:length(cr.data(i_dat).group(i_gr).sub)
        last_drop = cr.data(i_dat).group(i_gr).sub(i_sub).tag(end);
        axis(Hax_th);
        plot([last_drop last_drop], [0 pr_max], 'k')
    end
end

Hc_sgth=colorbar(Hax_sgthcb);
set(Hc_sgth,'fontweight','bold','fontsize',10)
axes(Hax_sgthcb)
Hxlcb_sgth=xlabel('Sigma Theta');
pos_xlcb=get(Hxlcb_sgth,'position');
set(Hxlcb_sgth,'position',[pos_xlcb(1) pos_xlcb(2)+1.5 pos_xlcb(3)])

eval(['print -adobecset -dpdf ' data '_gr' int2str(i_gr) '_sgth'])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot ts diag %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hcf_ts = figure;
Hts = tsplot(gravg.s, gravg.th, gravg.pr, .5);

xlabel('Salinity'); ylabel('Theta');
title(['bs03, amp group ' int2str(i_gr)])

eval(['print -adobecset -dpdf ' data '_gr' int2str(i_gr) '_ts'])