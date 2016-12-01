function dox=dox2_mmp(drop,tsbe,sal,prsbe)
% dox2_mmp
%   Usage: dox=dox2_mmp(drop,tsbe,ssbe,prsbe)
%      drop: drop number (integer)
%      tsbe,sal,prsbe: temperature (degC, in situ), salinity (C.U.),
%				pressure(MPa) - at 25 Hz
%      dox: dissolved oxygen (ml/l)
%   Function: For mmp1,mmp2 from drops 12100 onward, with 'dox'
%     mounted in a 400 Hz sensor port.  Script reads raw dox 
%     output in counts and converts ml/l at 25 Hz.
%   dox2_mmp implements revised SeaBird calibration formula,
%       with boc=0 and -0.03 temp response folded into 'offset'
%   D.Winkel, January 30, 2002

% get dox calibration (same coeffs as for dox1)
mmpfolders;
mmpid=read_mmpid(drop);
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('dox',mmpid,drop);	
calid=read_whichcal_mmp('dox',sensorid,drop);
[soc,boc,offset,tcor,pcor,tau]=read_doxcal_mmp(sensorid, calid);

% read raw data and convert to volts
doxV=atod1_mmp(read_rawdata_mmp('dox',drop));

%% Filter and subsample at 25 Hz
FS_hf=400; 		  % sample rate of high-frequency channels
FS_lf=25;		  % sample rate of low-frequency channels
hfperscan=16; 	  % number of samples per scan in high-freq channels
dt_hf=1/FS_hf; 	  % sample period of high-frequency channels 

dox_lag = 0; % in seconds;
% these values are for BS03, based on drops 14078,14096
cruise=read_cruises_mmp(drop);
switch mmpid
    case 'mmp1'
        switch lower(cruise)
            case 'epic01'
                dox_lag = 3.6;
            case 'bs03'
                dox_lag = 3.6;
            case 'ml04'
                dox_lag = 1.6;
        end
    case 'mmp2'
        switch lower(cruise)
            case 'epic01'
                dox_lag = 3.36;
            case 'bs03'
                dox_lag = 4.4;
            case 'ml04'
                dox_lag = 1.5;
        end
end
dox_lag = round(dox_lag * FS_lf); % scan counts

inan=find(isnan(doxV));
if ~isempty(inan)
   disp_str=['  dox has NaNs and was decimated w/o low-passing'];
   disp(disp_str)
   dox_lp=doxV;
else
   % Low-pass to produce one value per scan
   [b_dox,a_dox]=butter(4,(FS_lf/4)/(FS_hf/2));
   dox_lp=filtfilt(b_dox,a_dox,doxV);
end
%keyboard % do not use this keyboard for getting doxV
%
% Take one value per scan, at time of pr
doxV = dox_lp(4:hfperscan:end);
nd = length(doxV);
if nd<dox_lag+2
    dox_lag=0;  % too short a drop to shift correctly
end
%keyboard
doxV = [doxV(1+dox_lag:end)];

% prepare data for SeaBird calibration formula
nd = min(length(tsbe),length(doxV));
doxV = doxV(1:nd);
tsbe = tsbe(1:nd);
sal = sal(1:nd)*1000; % parts/thousand
pr = prsbe(1:nd)*100; % decibars
doxdt = (doxV(3:end)-doxV(1:end-2)) / (2/FS_lf); % center difn d(doxV)/dt
doxdt = [doxdt(1); doxdt; doxdt(end)];

dox = ( soc * ((doxV+offset)+(tau*doxdt)) + 0 ) ...
   .* exp(tcor*tsbe + pcor*pr) .* sw_oxsat(tsbe,sal/1000);

