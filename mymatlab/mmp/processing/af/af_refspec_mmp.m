function [f_ref,phi_ref]=af_refspec_mmp(ch,drop,w)
%  af_refspec_mmp 
%   Usage: [f_ref,phi_ref]=af_refspec_mmp('ch',drop,f,w);
%      ch is v1 or v2
%      drop is the sequential mmp drop number
%      w is a scalar for the fall rate
%   Function: Loads panchev.mat from mmp\:af_proc and applies
%      transfer functions to produce recorded spectra in
%      volts^2/Hz.

G=9.80665;

load panchev.mat

f_ref=k_panchev .*w;

% get info about electronics and probe
[case,case_config,Sv,Cs]=get_afinfo_mmp(ch,drop);

% call the appropriate circuit algorithm
if strcmp(case,'af1')==1 | strcmp(case,'af2')==1
	if strcmp(case_config,'1')==1
		h=haf_circuit1_mmp(Cs,f_ref);
	end
else
	msgstr=['af processing undefined for ch: ' ch '  and drop ' num2str(drop)]
	disp(msgstr); 
end

load panchev.mat

f_ref=k_panchev .*w;

h=h .* ((Sv*w)/(2*G))^2 .* haf_oakey(f_ref,w);

phi_vel=phi_panchev ./ (2*pi.*k_panchev).^2;
phi_ref=(phi_vel ./ w) .* h;
