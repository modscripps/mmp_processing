% plot_tsbe_tl1.m
% Overlays plots of tsbe and tl1 using mmp processed
% data and a raw data file

drop=input('drop=');

% get Sea Bird temperature
[p,t,th,s,sgth]=get_thetasd2_mmp(drop,'t_uf','','','',0);

tl1=tl1_polyval_mmp(drop);
pr_tl1=pr_offset1_mmp(drop,'tl1',pr3_mmp(drop));

clf
plot(t,p,'r')
set(gca,'ydir','rev')
hold on
plot(tl1(1:16:length(tl1)),pr_tl1)