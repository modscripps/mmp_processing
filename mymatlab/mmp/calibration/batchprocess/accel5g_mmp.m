function a=accel5g_mmp(ch,drop,mmpid)
% Usage: a=accel5g_mmp(ch,drop,mmpid);
%  inputs
%    ch: string channel name:'a1', 'a2', 'a3', 'a4'
%    drop: integer drop number
%    mmpid: string instrument id, e.g. 'mmp1', use optional
% Function: reads raw acceleration data and returns it
%    in m s^{-2}.  It now uses standard gains for all
%    units.
% M.Gregg, 11jul96  
% Corrected conversion to acceleration units by removing G.
% This reduces a by a factor of 9.8. M.Gregg, 5mar98
% accel5g_mmp.m for new 5G units on MMP4, couldn't buy 2G units (2-2-09,dpw)

Sa=0.0408; % nominal sensitivity volt/(m s^{-2}) (for 5G unit, NOT 2G)
% init cals: a1,a2(A026231,A026229) = 379.2,394.6 mV/g (400 is nominal)
V0=0; % possible offset, not yet measured

mmpfolders;

if nargin<2
  disp('   accel1_mmp: two input arguments required')
  return
elseif nargin<3
  mmpid=read_mmpid(drop);
end

% Test ch
if exist(ch)
  if ~strcmp(ch,'a1') & ~strcmp(ch,'a2') & ~strcmp(ch,'a3') & ~strcmp(ch,'a4')
    disp('   accel1_mmp: ch must be a1, a2, a3, or a4')
    return
  end
end

% Read raw data and convert from counts to volts
aV=read_rawdata_mmp(ch,drop);
aV=atod1_mmp(aV);

[sensorid,electronicsid,filter,fc,scanpos]= ...
    read_chconfig_mmp(ch,mmpid,drop);

% Get the gain by evaluating electronicsid
if strcmp(electronicsid,int2str(1)) | strcmp(electronicsid,int2str(2))
  gain=100; % mmp1 drops 1-2130
elseif strcmp(electronicsid,int2str(3))
  gain=21;  % mmp1,mmp2: drops 2131- , mmp3: drops 2262-, mmp4: 18668-
else
  disp_str=['   accel1_mmp: gain not specified for ' mmpid ', ch=' ...
    ch ', electronicsid=' electronicsid];
  disp(disp_str)
end

a=(aV-V0)/(Sa*gain);
