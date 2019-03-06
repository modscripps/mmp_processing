% Grid MMP data for SODA2018.
% Use a .25-m grid, grid log eps and log chi, use psu for s and m for depth.
mmpfolders
cruise = 'SODA18';
year = 2018;

%% Change paths here!
path_local  = '/Users/ecfine/Documents/MATLAB/mmp_processing';
work_dir  = '/Users/ecfine/Documents/MATLAB/mmp_processing/mymatlab/mmp/batchprocess';
%path_server = '/Volumes/public/Cruises/SKQ201511S/data/mmp_data/processed/gridded/';

load(fullfile(procdata,cruise,'mmplog'))

%%
% The deepest drop was to 300 m.  
dz    = 0.25; % revised by Effie for Arctic cruise
zmax  = 300;

% ?
zgrid = 0:dz:zmax;

MMP.p = zgrid;  %JBM changed this...it is PRESSURE not DEPTH.  This is a very important distinction.

ig = find(~isnan(mmplog(:,7))); %assumes first drop is not a nan!
droplist = mmplog(ig,1)';
%19254 chi does not exist... ??
if exist([path_local 'MMPgrid.mat'])
    load([path_local 'MMPgrid.mat']);
    %cc = [1:78,80:158,160:549,551:length(ig)]; % 80th drop, 19773, doesn't exist! neither does 159 (19853)
    cc = length(MMP.yday):length(ig); 
    toinit = nan(length(MMP.p), length(cc));
else
    cc = 1:length(droplist);
end
% a for loop.
for c = cc %length(mmplog(:,1))
    %drop = mmplog(c,1);
    drop = droplist(c);
    disp([num2str(drop) ', index ' num2str(c)])
    %DisplayProgress(drop,1)
    % get dissipation (epsilon)
    try
        [epsilon, pr_eps, w_eps]            = get_epsilon2_mmp(drop);
    catch
        epsilon = nan;
        pr_eps = nan;
        w_eps = nan;
    end
    % get potential temperature, salinity, and other things...
    [pr_thetasd,t,theta,salinity,sgth]  = get_thetasd2_mmp(drop,'t','th','s','sgth',0);
    % change the units of salinity
    salinity                            = salinity*1000;
    % get temperature variance (chi)
    try
        [chi, pr_chi]                       = get_chi1_mmp(drop);
    catch 
        chi = nan;
        pr_chi = nan;
    end
    % get dissolved oxygen
    dox                                 = get_dox_mmp(drop);
    % set empty data points to NaN
    if isempty(find(~isnan(dox)))
        dox=NaN*zeros(size(t));
    end
    % Now interpolate onto the grid
    % dissolved oxygen
    MMP.dox (:,c)    = nonmoninterp1    ( pr_thetasd*100 , dox              , zgrid);
    % temperature
    MMP.t   (:,c)    = nonmoninterp1    ( pr_thetasd*100 , t                , zgrid);
    % potential temperature (theta)
    MMP.th  (:,c)    = nonmoninterp1    ( pr_thetasd*100 , theta            , zgrid);
    % salinity
    MMP.s   (:,c)    = nonmoninterp1    ( pr_thetasd*100 , salinity         , zgrid);
    % sigma-theta
    MMP.sgth(:,c)    = nonmoninterp1    ( pr_thetasd*100 , sgth             , zgrid);
    % dissipation (epsilon)
    MMP.eps (:,c)    = 10.^nonmoninterp1( pr_eps*100     , log10(epsilon)   , zgrid);
    % temperature variance (chi)
    MMP.chi (:,c)    = 10.^nonmoninterp1( pr_chi*100     , log10(chi)       , zgrid);
    % vertical velocity of mmp
    MMP.w   (:,c)    = nonmoninterp1    ( pr_eps*100     , w_eps            , zgrid);
    
end

%%
%Final error checking
%Now put NaN's in where the dox is negative
ind1            = find(MMP.dox(100,:)<0);
new.dox(:,ind1) = NaN;
%subtract 1000 from sgth
MMP.sgth        = MMP.sgth-1000;


%Then fill in the easy ones
MMP.yday        = mmplog(ig,3)';
MMP.lat         = mmplog(1:ig,5)';
MMP.lon         = mmplog(ig,4)';
MMP.floatrange  = mmplog(ig,14)';
MMP.mmpid       = mmplog(ig,11)';
MMP.drop        = mmplog(ig,1)';

%MMP.dnum=yday2datenum(MMP.yday,mmplog(1,2)); %fill in year from mmplog - first drop - this would be a bug if we did a cruise spanning new year!
MMP.dnum        = MMP.yday + datenum(year,1,1,0,0,0); 

% move to folder with gridded data
%cd(path_local)

% save mmp grid
disp('saving data...')
cd(path_local)
save MMPgridSODATEST MMP
cd(work_dir)
% 
% %% copy mmp data to server
%  disp('copying data to shared folder...')
%  eval([ '!cp ' path_local 'MMPgrid.mat ' path_server ])
