% Dox_lag_est.m - find oxygen sensor lag by trial and error

drop = 14404;
dr = int2str(drop);

%% Filter and subsample at 25 Hz
FS_hf=400; 		  % sample rate of high-frequency channels
FS_lf=25;		  % sample rate of low-frequency channels
hfperscan=16; 	  % number of samples per scan in high-freq channels
dt_hf=1/FS_hf; 	  % sample period of high-frequency channels 

if ~exist(['doxV' dr '.mat'])
    doxV=atod1_mmp(read_rawdata_mmp('dox',drop));
    
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

%load(['C:\mmp\bs03\pr\pr' dr])
load(['C:\mmp\ml04\pr\pr' dr])
[m,im] = max(pr_scan);
ii = 1:im; jj = im+1;
clf

dNH = 3; % for dVolts/dt, center-difn using points +/-dNH away
dNH = min( dNH, floor( length(doxV)/2 - .49) ); % in case of too few points
Tau = 3.2; % response time scale, seconds
doxdt = 0; 
if dNH > 0 % compute dV/dt for response-time correction
    clear vx tx 
    vx = doxV'; tx = [1:length(vx)] / FS_lf;
    fp = dNH+1; lp = length(vx)-dNH;
    dv = ( vx(fp+dNH:lp+dNH) - vx(fp-dNH:lp-dNH) );
    dt = ( tx(fp+dNH:lp+dNH) - tx(fp-dNH:lp-dNH) );
    for i = dNH-1:-1:1 % use fewer points near ends
        x(1)=( vx(2*i+1)-vx(1) ); x(2)=( vx(end)-vx(end-2*i) );
        y(1)=( tx(2*i+1)-tx(1) );  y(2)=( tx(end)-tx(end-2*i) );
        dv = [x(1), dv, x(2)];  dt = [y(1), dt, y(2)];
    end
    % fwd/bwd difn at ends
    dv = [ (vx(2)-vx(1)), dv, (vx(end)-vx(end-1)) ];
    dt = [ tx(2)-tx(1), dt, tx(end)-tx(end-1) ];
    doxdt = dv ./ dt;
end

% extra response lag step:
doxV = doxV + Tau*doxdt';
lgs = [0 25 32]; % compare these scan lags
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
