% batterylife_mmp.m
%  Function: Plots battery voltage as a function of elapsed
%  time.  Use for a sequence of drops beginning with a fresh
%  battery and is used continuously until it died.

mmpfolders
cruise='cmo96';

first_drop=input('first_drop ');
last_drop=input('last_drop ');

ndrops=last_drop-first_drop+1;
vb_start=NaN*ones(1,ndrops);

% Load mmp log, get times at which drops started, and convert
% start_times to elapsed times in hours
log_file=[procdata '\' cruise '\mmplog'];
load_str=['load ' setstr(39) log_file setstr(39)];
eval(load_str)
idrops=find(mmplog(:,1)>=first_drop & mmplog(:,1)<=last_drop);
start_times=(mmplog(idrops,3)-mmplog(idrops(1),3))*24;

% Read battery voltages at start of drops in sequence
dropno=1;
for drop=first_drop:last_drop
   % read battery voltage at the start of each drop
   vb=read_rawdata_mmp('vb',drop);
   vb_start(dropno)=4*atod1_mmp(vb(1));
   dropno=dropno+1;
end

% Check mmpid
mmpid1=read_mmpid(first_drop);
mmpid2=read_mmpid(last_drop);
if strcmp(mmpid1,mmpid2)~=1
   msg=['error: first drop mmpid = ' mmpid1 ', last drop mmpid = ' mmpid2];
   disp(msg)
   break
end

figure
plot(start_times,vb_start)
xlabel('elapsed time / hours'), ylabel('vb / volts')
title_str=[mmpid1 ' drops ' int2str(first_drop) ' to ' int2str(last_drop)];
title(title_str)