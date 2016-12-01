% tl1_thetasd_compare.m
%   Function: Overlay plots of thetasd and tl1 for the same mmp drop

mmpfolders;

drop=input('drop: ','s');
drop_int=str2num(drop);

% load thetasd
cruise=read_cruises_mmp(drop_int);
str=['load ' setstr(39) procdata ':' cruise ':thetasd:thetasd' drop '.mat' setstr(39)];
eval(str)

% calculate pressure and temp for tl1
tl1=tl1_polyval_mmp(drop_int);
pr=pr_mmp(drop_int,'tl1',3);

% do plots
clf
plot(temp,pr_thetasd)
hold on
plot(tl1,pr)
set(gca,'YDIR','reverse')
xlabel('T / deg C'), ylabel('p / MPa')
str=['tl1 and thetasd for mmp' drop];
title(str)
hold off
