% vspec_fmax_mmp
%   Usage: vspec_f_max_mmp
%   Function: plots a full drop of high-frequency data and
%      computes and displays one or more spectra of the
%      voltage signal spectrum versus frequency.  Uses inputs
%      to obtain drop number, channel, and sammple numbers
%      for computing spectra.

need to find Pnoise.mat

% primary parameters
FS=400; % sample frequency
DT = 1/ FS;
NFFT=512;

% secondary parameters
df=FS/NFFT;
f=(df:df:df*NFFT/2)';
f_lb=1;
f_ub=60;
clf
load Pnoise.mat

% get drop and channel as inputs
drop_str=input('Drop: ', 's');
drop=str2num(drop_str);
ch=input('Channel: ', 's');

% read datammpid=read_mmpid(drop);
[scanid,voffsetid]=read_config_mmp(mmpid,drop);
[sensorid,electronicsid,filter,fc,scanpos] = ...
   read_chconfig_mmp(ch,mmpid,drop);	
data=read_rawdata_mmp(ch, drop, scanid,scanpos);
data=atod1_mmp(data);

ldata=length(data);
drop_str=num2str(drop);

another='y';
for i=NFFT:NFFT:ldata
   dblock=data(i-NFFT+1:i);
   P=psd(dblock,NFFT,FS)/(FS/2);
   P=P(2:length(P)); % drop f=0 pt
   
   Pmed=medfilt1(P,5); % apply 5-pt median filter to spectrum
   i_signal=find(Pmed>2*Pnoise & f <48); % indices > 2*noise
   
   % find fmax
   % determine if i_signal has a gap
   di=find(diff(i_signal)>1);
   if isempty(di) % no gap
      fmax=f(max(i_signal));
   else % one or more gaps
      di_min=min(di);
      fmax=f(di_min);
      i_signal=i_signal(1:di_min); % drop pts at f > 1st gap
   end
   
   loglog(f,Pnoise,'o')
   hold on
   loglog(f,Pmed)
   loglog(f(i_signal),P(i_signal),'+')
   pmax=max(P); pmin=min(P);
   axis([f_lb f_ub pmin pmax])
   xlabel('f / Hz'), ylabel('volts^2 / Hz')
   title(['drop=', drop_str , ', i=' int2str(i) , ', fmax=' num2str(fmax)])
   hold off
   pause
   
end