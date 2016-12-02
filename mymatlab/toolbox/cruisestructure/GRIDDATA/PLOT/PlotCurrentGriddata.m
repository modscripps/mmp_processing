% PlotCurrentGriddata
% another line of comments

DT=1/24;  % Time interval to plot, in yeardays

T_OFFSET=0.03;  % Offset between successive plots in temperature waterfall
S_OFFSET=0.02;  % Offset between successive plots in salinity waterfall


vars={'s1', 'th1', 'z', 'flu', 'dox', 'obs'};
%index_file=['\\mimas\d\SWIMS_MHA\ps02\indexes\SWIMS_ps02_gridfiles.mat'];
index_file=['\\phobos\d\swims\ps03\indexes\SWIMS_ps03_gridfiles.mat'];
%data_path=['\\mimas\d\SWIMS_MHA\ps02\griddata'];
data_path=['\\phobos\d\swims\ps03\griddata'];

files=dir(data_path);
eval(['load ' fullfile(data_path, files(end).name)])

end_time=SWIMSgrid.yday(end);
beg_time=end_time - DT;

d = get_swims_data(beg_time, end_time, index_file, data_path, vars);
d.s1=d.s1*1000;

[i,j]=find(~isnan(d.s1) & ~isnan(d.th1));

d.s1=d.s1(1:max(i),:);
d.th1=d.th1(1:max(i),:);
d.z_ctd=d.z_ctd(1:max(i),:);
d.flu=d.flu(1:max(i),:);
d.dox=d.dox(1:max(i),:);
d.obs=d.obs(1:max(i),:);

[nr,nc]=size(d.s1);

x0=.1; y0=.05;
w=.6; h=.25; g=.05;
w1=.27; gx=0.01;
pos1=[x0 y0 w h];   % T waterfall at bottom left
pos2=[x0 y0+g+h w h]; % S waterfall at middle left
pos3=[x0 y0+2*(g+h) w h]; % TS diat at top left
pos4=[x0+w+gx y0 w1 h];  % DO at bottom right
pos5=[x0+w+gx y0+g+h w1 h]; % FLU in middle right
pos6=[x0+w+gx  y0+2*(g+h) w1 h]; % OBS in top right

figure

% Plot th1 in position 1
T_OFFSET=T_OFFSET*(0:nc-1);
offset=ones(nr,1)*T_OFFSET;
plot(d.th1+offset,d.z_ctd)
set(gca,'position',pos1,'ydir','rev')
ylabel('z / m')
t_min=min(d.th1(:)); t_max=max(d.th1(:))+max(T_OFFSET); t_span=t_max-t_min;
lim_th1=[t_min t_max];
lim_z=[0 max(d.z_ctd)];
set(gca,'xlim',lim_th1,'ylim',lim_z)
text(t_max-0.2*t_span,0.8*max(d.z_ctd),['\theta / {}^o C'])
hold on

% Plot s1 in position 2
axes('position',pos2)
S_OFFSET=S_OFFSET*(0:nc-1);
offset=ones(nr,1)*S_OFFSET;
plot(d.s1+offset,d.z_ctd)
set(gca,'ydir','rev')
xlabel('S')
ylabel('z / m')
s_min=min(d.s1(:)); s_max=max(d.s1(:)); s_span=s_max-s_min;
lim_s1=[s_min s_max+max(S_OFFSET)];
set(gca,'xlim',lim_s1,'ylim',lim_z)
text(s_max-0.2*s_span, 0.5*max(d.z_ctd),['S'])

% Plot Theta S in position 3
axes('position',pos3)
plot(d.s1,d.th1,'.')
set(gca,'xlim',lim_s1,'ylim',[min(d.th1(:)) max(d.th1(:))])
ylabel('\theta / {}^o C')

title(['Start: ' num2str(beg_time,7) ', End: ' num2str(end_time,7)])

% Plot DO in position 4
axes('position',pos4)
plot(d.dox,d.z_ctd)
dox_min=min(d.dox(:)); dox_max=max(d.dox(:)); dox_span=dox_max-dox_min;
set(gca,'ydir','rev','yticklabel','','xlim',[dox_min dox_max],'ylim',lim_z)
text(dox_max-0.6*dox_span, 0.8*max(d.z_ctd),['DO / ml l^{-1}'])

% Plot FLU in position 5
axes('position',pos5)
plot(d.flu,d.z_ctd)
flu_min=min(d.flu(:)); flu_max=max(d.flu(:)); flu_span=flu_max-flu_min;
set(gca,'ydir','rev','yticklabel','','xlim',[flu_min flu_max],'ylim',lim_z)
text(flu_max-0.6*flu_span, 0.8*max(d.z_ctd),['FLU / \mu g l^{-1}'])

% Plot OBS in position 6
axes('position',pos6)
plot(d.obs,d.z_ctd)
obs_min=min(d.obs(:)); obs_max=max(d.obs(:)); obs_span=obs_max-obs_min;
set(gca,'ydir','rev','yticklabel','','xlim',[obs_min obs_max],'ylim',lim_z)
text(obs_max-0.5*obs_span, 0.5*max(d.z_ctd),['OBS / FTU'])
