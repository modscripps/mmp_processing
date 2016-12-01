% Dox_lag_est.m - find oxygen sensor lag by trial and error

drop = 14486;
dr = int2str(drop);

if ~exist(['doxV' dr '.mat'])
    doxV=atod1_mmp(read_rawdata_mmp('dox',drop));
    %% Filter and subsample at 25 Hz
    FS_hf=400; 		  % sample rate of high-frequency channels
    FS_lf=25;		  % sample rate of low-frequency channels
    hfperscan=16; 	  % number of samples per scan in high-freq channels
    dt_hf=1/FS_hf; 	  % sample period of high-frequency channels 
    
    dox_lp=doxV;
    % Low-pass to produce one value per scan
    [b_dox,a_dox]=butter(4,(FS_lf/4)/(FS_hf/2));
    dox_lp=filtfilt(b_dox,a_dox,doxV);
    % Take one value per scan, at time of pr
    doxV = dox_lp(4:hfperscan:end);
    save(['doxV' dr], 'doxV')
else
    load(['doxV' dr]);
end

load(['d:\mmp\ML04\pr\pr' dr])
[m,im] = max(pr_scan);
ii = 1:im; jj = im+1;
clf
lgs = [0 30 50]; % compare these scan lags
for ip=1:3
subplot(1,3,ip)
doxL = doxV(1+lgs(ip):end); je=min( length(doxL), length(pr_scan) );
plot(doxL(ii),pr_scan(ii),'b',doxL(jj:je),pr_scan(jj:je),'r')
xlabel('doxV')
ylabel('P / MPa')
title(['MMP' dr ': ' num2str(lgs(ip)) ' scan lag'])
legend('Down','Up',4)
axis ij
end
