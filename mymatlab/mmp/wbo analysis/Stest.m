% Stest.m
%   Usage: execute from MATLAB:mmp:wboanalysis after executing
%      batchprocess1_mmp and stopping it just before 
%      calc_thetasd_mmp to create temp, cond, and prscan
%   Function: a script for testing salinity calculations after
%      filtering temp and cond.  It shifts conductivity forward,
%	   calculates and applies the filter to temp and cond,
%      and computes salinity.  T, C, and S are plotted over
%      a range set within the script.

%   Function: 
% shift conductivity
cshift=1; % no pts to shift cond forward
t=temp(1:length(temp)-cshift);
p=prscan(1:length(prscan)-cshift);
c=cond(cshift+1:length(cond));

[b,a]=butter(4,3/25);
tlp=filtfilt(b,a,t);
clp=filtfilt(b,a,c);

slp=salinityfcn(clp,tlp,p);
S=1000*slp;

clf
pl0=450;
pl1=479;
tfile=tlp(pl0:pl1);
cfile=clp(pl0:pl1);
sfile=S(pl0:pl1);

% plot temp
rect=[.15, .1, .75, .25];
axes('position',rect)
plot(tfile)
hold on
plot(tfile,'+')
hold off
axis([0 length(tfile) min(tfile) max(tfile) ])
str=['sample no - ' num2str(pl0)];
xlabel(str);

% plot cond
rect=[.15, .4, .75, .25];
axes('position',rect)
plot(cfile)
hold on
plot(cfile,'+')
hold off
ylabel('c')
axis([0 30 min(cfile) max(cfile) ])

% calculate & plot salinity
rect=[.15, .7, .75, .25];
axes('position',rect)
plot(sfile)
hold on
plot(sfile,'+')
hold off
ylabel('sfile')
axis([0 30 min(sfile) max(sfile) ])
sfiletr=['mmp242, cond shifted ' num2str(cshift) ' pt forward'];
title(str)
