%Grid MMP data for PS02.
%Use a .25-m grid, grid log eps and log chi, use psu for s and m for depth.
mmpfolders
cruise='ArcticMix15';
%load([procdata filesep cruise filesep 'mmplog'])

%griddata='/Users/mmp/MATLAB/SharedProjects/WashingtonWaves/data/proc_mmp/';
griddata = '/Users/mmp/Documents/MATLAB/mmp/ArcticMix15/gridded/';
load(fullfile(procdata,cruise,'mmplog'))
%mmplog=load(fullfile(procdata,cruise,'mmplog'));

%%


%The deepest drop was to 220 m.  
dz=0.25; % revised by Effie for Arctic cruise
zmax=300;

zgrid=0:dz:zmax;

MMP.p=zgrid;

ig=find(~isnan(mmplog(:,2))); %assumes first drop is not a nan!
%19254 chi does not exist... ??
droplist = mmplog(ig,1)';
for c=1:length(ig)%length(mmplog(:,1))
    %drop=mmplog(c,1);
    drop = droplist(c);
    disp(['Drop ' num2str(drop) ', index ' num2str(c)]);
    %DisplayProgress(drop,1)
    [epsilon, pr_eps, w_eps]=get_epsilon2_mmp(drop);
    [pr_thetasd,t,theta,salinity,sgth]=get_thetasd2_mmp(drop,'t','th','s','sgth',0);
    salinity=salinity*1000;
    [chi, pr_chi]=get_chi1_mmp(drop);
    dox=get_dox_mmp(drop);
    if isempty(find(~isnan(dox)))
        dox=NaN*zeros(size(t));
    end
    
    %Now interpolate onto the grid
    MMP.dox(:,c)=nonmoninterp1(pr_thetasd*100,dox,zgrid);
    MMP.t(:,c)=nonmoninterp1(pr_thetasd*100,t,zgrid);
    MMP.th(:,c)=nonmoninterp1(pr_thetasd*100,theta,zgrid);
    MMP.s(:,c)=nonmoninterp1(pr_thetasd*100,salinity,zgrid);
    MMP.sgth(:,c)=nonmoninterp1(pr_thetasd*100,sgth,zgrid);
    MMP.eps(:,c)=10.^nonmoninterp1(pr_eps*100,log10(epsilon),zgrid);
    MMP.chi(:,c)=10.^nonmoninterp1(pr_chi*100,log10(chi),zgrid);
    MMP.w(:,c)=nonmoninterp1(pr_eps*100,w_eps,zgrid);
    
end

%%
%Final error checking

%Now put NaN's in where the dox is negative
ind1=find(MMP.dox(100,:)<0);
MMP.dox(:,ind1)=NaN;

%subtract 1000 from sgth
MMP.sgth=MMP.sgth-1000;


%Then fill in the easy ones
MMP.yday=mmplog(ig,3)';

MMP.lat=mmplog(1:ig,5)';
MMP.lon=mmplog(ig,4)';
MMP.floatrange=mmplog(ig,14)';
MMP.mmpid=mmplog(ig,11)';
MMP.drop=mmplog(ig,1)';

%MMP.dnum=yday2datenum(MMP.yday,mmplog(1,2)); %fill in year from mmplog - first drop - this would be a bug if we did a cruise spanning new year!
MMP.dnum = MMP.yday + datenum(2015,1,1,0,0,0);

cd(griddata)
save MMPgrid MMP
