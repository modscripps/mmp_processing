function [Pvolts,f,Pvel,k,dof]=af_spec1_mmp(ch,drop,prlb,prub,speclen,overlap);
% Usage: [Pvolts,f,Pvel,k,dof]=af_spec1_mmp(ch,drop,prlb,prub,speclen,overlap);
%  inputs:
%   ch is the string name of the channel, 'v1', or 'v2'
%   drop is the integer drop number
%   prlb, prub are the lower and upper pressure limits to use
%   speclen is the integer length for taking FFTs
%  outputs:
%   Pvolts is a vector with the raw spectrum in Volts^2/Hz
%   f is a vector with frequency in Hz
%   Pvel is a vector with the corrected spectrum in (m/s)^2/cpm
%   k is a vector with cyclic wavenumber in cpm
%   dof is a number giving the degrees of freedom per estimate
%   DOF NOT IMPLEMENTED
% Function: to compute the spectrum of an airfoil channel
% M.Gregg, 23nov96

G=9.8065; % gravity
Fs=400;  % mmp sample rate
AF_PER_PR=16; % number of af samples per pr sample

dt=1/Fs; % sample period in seconds

%ADD ALGORITHM FOR DEGREES OF FREEDOM

% Calculate pressure for the airfoils
data=read_rawdata_mmp(ch,drop);
pr=pr3_mmp(drop);
pr=pr_offset1_mmp(drop,ch,pr);

% Find indices of pressure in the range selected,
% avoiding any pressures in the range when the profiler was 
% being pulled up.
igp=find(~isnan(pr));
maxpr=max(pr(igp));
if maxpr<prub
   disp_str=['prub > maximum pr = ' num2str(maxpr)];
   disp(disp_str)
end
imaxpr=find(pr==maxpr);
%
ipr=find(pr>=prlb & pr<=prub);
ipr=ipr(find(ipr<imaxpr)); % indices before maxpr
idata=AF_PER_PR*ipr(1):AF_PER_PR*ipr(length(ipr)); % indices of af data
speed=100*(pr(ipr(length(ipr)))-pr(ipr(1)))/(dt*length(idata));

% Get af data over selected pr range
data=atod1_mmp(read_rawdata_mmp(ch,drop));
data=data(idata);

% take spectrum, delete f=0, and normalize
[Pvolts,f]=psd(data,speclen,Fs,speclen,overlap);
f=f(2:length(Pvolts));
Pvolts=Pvolts(2:length(Pvolts))'/(0.5*Fs);

% apply transfer functions for velocity
k=f/speed; % calculate wavenumber
mmpid=read_mmpid(drop);
[sensorid,electronicsid,filter,fc,scanpos]=read_chconfig_mmp(ch,mmpid,drop);
calid=read_whichcal_mmp('af',sensorid,drop);
[Sv,Cs]=read_af_cal(sensorid, calid);
str1=['helectronics=helectronics_' electronicsid '(Cs,f);'];
eval(str1); % evaluate electronics transfer function
str2=['[hfilt,pfilt]=' filter '(f,fc);'];
eval(str2);  % evaluate anti-alias filter transfer fcn
h_freq=helectronics .* hfilt;
htotal=(Sv*speed/(2*G))^2 * h_freq .*haf_oakey(f,speed);
Pvel=(Pvolts*speed) ./ htotal'; % velocity spectrum

dof=[];