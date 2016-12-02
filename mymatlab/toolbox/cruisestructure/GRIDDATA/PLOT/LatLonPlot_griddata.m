% LatLonPlot_griddata.m

% Edit griddata file name and location
fname='SWIMSgrid-2002-124-1647';
floc='C:\swims\ps02\Intrusions\griddata\';

load([fullfile(floc,fname)]);

% Load isobath contours
eval(['load ' setstr(39) 'C:\bathy\pugetsound\NMainBasin\PSsub_isobaths' setstr(39)])

ib=find([IsoBath(:).depth] == 0);

plot(IsoBath(ib).lon,IsoBath(ib).lat,'.')
hold on
set(gca,'PlotBoxAspectRatio',[cos(median(Isobath(ib).lat)) 1 1])