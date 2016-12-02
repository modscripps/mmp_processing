% PlotCurrentGriddata
% another line of comments

T_OFFSET=0.03;
S_OFFSET=0.02;

end_time=127.99;
beg_time=127.9025;
vars={'s1', 'th1', 'z', 'flu', 'dox', 'obs'};
index_file=['\\mimas\d\SWIMS_MHA\ps02\indexes\SWIMS_ps02_gridfiles.mat'];
data_path=['\\mimas\d\SWIMS_MHA\ps02\griddata'];

files=dir(data_path);
[n_files,x]=size(files);


break
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

figure
plot(d.s1,d.th1,'.')

figure
T_OFFSET=T_OFFSET*(0:nc-1);
offset=ones(nr,1)*T_OFFSET;
plot(d.th1+offset,d.z_ctd)
set(gca,'ydir','rev')
xlabel('\theta / {}^o C')
ylabel('z / m')

lim_th1=[min(d.th1(:,1)) max(d.th1(:,nc))+max(offset(:))];
set(gca,'xlim',lim_th1)

figure
S_OFFSET=S_OFFSET*(0:nc-1);
offset=ones(nr,1)*S_OFFSET;
plot(d.s1+offset,d.z_ctd)
set(gca,'ydir','rev')
xlabel('S')
ylabel('z / m')

lim_s1=[min(d.s1(:,1)) max(d.s1(:,nc))+max(offset(:))];
set(gca,'xlim',lim_s1)