function h=haf_mmp(ch,drop,f)
%   haf_mmp
%   Usage: [h,Sv]=haf_mmp('ch',drop,f)
%      ch is v1 or v2
%      drop is the sequential mmp drop number
%      f is a column array of frequencies
%   Function: Power transfer function of airfoil circuit as fcn
%      of frequency.  Scripts are called to read circuit 
%      parameters and select appropriate algorithm
   
% get info about electronics and probe
[case,case_config,Sv,Cs]=get_afinfo_mmp(ch,drop);

% call the appropriate circuit algorithm
if strcmp(case,'af1')==1 | strcmp(case,'af2')==1
	if strcmp(case_config,'1')==1
		h=haf_circuit1_mmp(Cs,f)
	end
else
	disp('af processing undefined for ch: 'ch' ' and drop ' drop); 
end
