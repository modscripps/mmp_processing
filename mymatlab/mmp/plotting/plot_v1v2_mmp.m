function plot_v1v2_mmp(drop,cruise)
% Usage: plot_v1v2_mmp(drop,cruise)
%  inputs:
%   ch: string channel designation, e.g. 'v1'
%   drop: integer drop number
%   cruise: string cruise name, e.g. 'cmo96'
% Function: Overlays v1 and v2 in volts, as an aide for
%  identifying sections with simultaneous bad data.

mmpfolders
global FSP

if nargin<2
  cruise=read_cruises_mmp(drop)
end

% Load v1 and v2
v1=atod1_mmp(read_rawdata_mmp('v1',drop));
v2=atod1_mmp(read_rawdata_mmp('v2',drop));

% Plot data
clf
plot(v1,'g')
hold on
plot(v2,'r')
title_str=['drop' mmpid ': green: v1, red, v2')
