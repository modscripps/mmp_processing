function plotPressureTimeSeries(drop)

% load raw timeseries of pressure
dataPath = '/Users/mmp/Documents/MATLAB/mmp/FLEAT16/pr/';
fileName = ['pr' num2str(drop,'%d') '.mat'];

load([dataPath fileName])

figure; clf
plot(time,pr_scan), grid minor
