function avg=scanavg1_mmp(hfdata)
% scanavg1_mmp
%   Usage: avg=scanavg1_mmp(hfdata)
%      hfdata is vector of 400 Hz data in first scan config
%      avg is an average of hfdata by scan
%   Function: average 400 Hz data by data scan

SCANLEN=16;

noscans=length(hfdata)/SCANLEN;

for i=1:noscans
	scanstart=1+(i-1)*SCANLEN;
	x=hfdata(scanstart:scanstart+SCANLEN-1);
	avg(i)=mean(x);
end
avg=avg'; 
