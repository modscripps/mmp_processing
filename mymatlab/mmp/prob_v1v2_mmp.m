function prob_v1v2_mmp(drop,cruise)
% Usage: prob_v1v2_mmp(drop,cruise)
%  inputs:
%   ch: string channel designation, e.g. 'v1'
%   drop: integer drop number
%   cruise: string cruise name, e.g. 'cmo96'
% Function: Displays v1 and v2, loads problems file for
%  channel, prompts for additions to problems file, and
%  saves file with revisions.  Loads raw data files in volts
%  for analog channels and computes computed data for digital
%  channels.
%    Prompts for pr_lb and then pr_ub, lower and upper bounds
%  of section to be deleted from analysis by being set to NaNs
%  in output data.  Set pr_lb and or pr_ub to -1 to end inputs
%  and have file

mmpfolders
global FSP

if nargin<3
  cruise=read_cruises_mmp(drop)
end

% Load v1 and v2
v1=atod1_mmp(read_rawdata_mmp('v1',drop));
v2=atod1_mmp(read_rawdata_mmp('v2',drop));


% Plot data and turn zoom on
clf
plot(v1,'g')
hold on
plot(v2,'r')
title('green: v1, red, v2')
zoom on
break

% Prompt for inputs
pr_lb=0; pr_ub=0;
while pr_lb>=0 & pr_ub>=0
  disp('Give pr_lb and pr_ub of bad data sections or:  -1 to end session and write');
  disp('problems file, or -2 to end session and not update problems file.');
  pr_lb=input('pr_lb ');
  if pr_lb<0
	  break
	else
    pr_ub=input('pr_ub ');
	end
	if pr_ub<0
	  break
	else
	  update_str=['bad' ch '=[bad' ch '; pr_lb pr_ub]']
		eval(update_str)
	end
end

