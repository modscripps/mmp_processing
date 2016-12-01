function problems1_mmp(ch,drop,cruise)
% Usage: problems1_mmp(ch,drop,cruise)
%  inputs:
%   ch: string channel designation, e.g. 'v1'
%   drop: integer drop number
%   cruise: string cruise name, e.g. 'cmo96'
% Function: Loads problems file for channel, prompts for 
%  additions to problems file, and saves file with revisions.  
%    Prompts for pr_lb and then pr_ub, lower and upper bounds
%  of section to be deleted from analysis by being set to NaNs
%  in output data.  Set pr_lb and or pr_ub to -1 to end inputs
%  and have file

mmpfolders

if nargin<3
  cruise=read_cruises_mmp(drop)
end

% Load problems file if it exists
problems_file=[procdata '\problems\' ch '.mat'];
if exist(problems_file)==2
  load_str=['load ' setstr(39) problems_file setset(39)];
	eval(load_str)
	size_str=['[m,n]=size(bad' ch ');'];
	eval(size_str)
else
  bad_str=['bad' ch '=[];'];
	eval(bad_str)
end

% Start array to hold pressures boundaries of bad data.
pr=[];

% Prompt for inputs
disp('Give pr_lb and pr_ub of bad data sections. Respond with')
disp('-1 to end session and incorporate changes to problems.')
disp('Respond with -2 to end session and discard updates.')
pr_lb=0; pr_ub=0;
while pr_lb>=0 & pr_ub>=0
  pr_lb=input('pr_lb ');
  if pr_lb>=0
    pr_ub=input('pr_ub ');
		pr=[pr; pr_lb pr_ub]
	end
end

if pr_lb==-1 | pr_lb==-1


