function a=accel2_mmp(ch,drop,mmpid)
% Usage: a=accel2_mmp(ch,drop,mmpid);
%  inputs:
%    ch: string channel name.  Must be 'a1', 'a2', 'a3', or 'a4'.
%    drop: integer drop number
%    mmpid: string vehicle id
%  output:
%    a: acceleration in m/s^2
% Function: converts acceleration from volts to m/s^-2 for mmp3 with
%   positive values corresponding to tilts of the upper endcap toward the
%   positive x and y axes of the vehicle.
% M.Gregg, 24jul96  
%          18aug96: revised to expect Sa in volts / (m/s^2)  

mmpfolders;
global FSP

if nargin<2
  disp('   accel2_mmp: two input arguments required')
  break
elseif nargin<3
  mmpid=read_mmpid(drop);
end

% Test ch
if exist(ch)
  if ~strcmp(ch,'a1') & ~strcmp(ch,'a2') & ~strcmp(ch,'a3') & ~strcmp(ch,'a4')
    disp('   accel1_mmp: ch must be a1, a2, a3, or a4')
    break
  end
end

[sensorid,electronicsid,filter,fc,scanpos]=read_chconfig_mmp(ch,mmpid,drop);

% Get the sensitivity of the accelerometer and convert from mV/g to V/ms^{-2}
Sa_calid=read_whichcal_mmp('accel',sensorid,drop);
Sa=read_Sa1_mmp(sensorid, Sa_calid);

% Get the electronic gain id, and use it to get the electronics gain
El_str=[mmpid '_' ch 'elect'];
El_calid=read_whichcal_mmp('accel', El_str , drop);
gain=read_again1_mmp(mmpid,ch,electronicsid,El_calid);

aVolts=atod1_mmp(read_rawdata_mmp(ch,drop));
a=aVolts/(Sa*gain);

% Adjust signs so that tilts of upper endcap toward the positive axis,
% clockwise, give a positive acceleration.
if strcmp(ch,'a1') | strcmp(ch,'a2')
  a=-a;
end
