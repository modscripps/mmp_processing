
run('/Volumes/public/Cruises/SKQ201511S/data/swims/mfiles/visualization/olavo_plot_SWIMS_3D_CTD.m');
disp('gridding MMP files')
grid_mmp_ArcticMix
data_path = '/Users/mmp/Documents/MATLAB/mmp/ArcticMix15/gridded/MMPgrid.mat';
met_path = '/Volumes/public/Cruises/SKQ201511S/data/underway_data/combinedmet.mat';
load(data_path)
mmpin = 1;
for i = 1:length(MMP.yday)
    if MMP.yday(i) > datenum(2015,9,16)-datenum(2015,1,1)
        mmpin = i;
        break;
    end
end
if isnan(MMP.lat(end))
    MMP = addLatLon(MMP,met_path,data_path);
end
hold on;

    surf(ones(length(MMP.p(1:800)),1)*MMP.lon(mmpin:end), ...
         ones(length(MMP.p(1:800)),1)*MMP.lat(mmpin:end), ...
         -MMP.p(1:800)'*ones(1,length(MMP.yday(mmpin:end))), ...
          MMP.t(1:800,mmpin:end));
      shading flat;
      caxis([-1 6]);
      alpha(0.8);
      
      
      figure(2); clf
          surf(ones(length(MMP.p(1:800)),1)*MMP.lon(mmpin:end), ...
         ones(length(MMP.p(1:800)),1)*MMP.lat(mmpin:end), ...
         -MMP.p(1:800)'*ones(1,length(MMP.yday(mmpin:end))), ...
          log10(MMP.eps(1:800,mmpin:end)));
      shading flat;
      caxis([-10 -8]);
      alpha(0.8);