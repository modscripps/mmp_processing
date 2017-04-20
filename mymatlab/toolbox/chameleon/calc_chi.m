function [chi,k,spec,k_batch,spec_batch]= ...
   calc_chi(fre, tp_power,fspd,epsilon,nu,thermal_diff, f_c)
% Ocean Mixing Group processing for chi from Chameleon, modified Apr-2017
% for use with MMP by ECF.

% fre = frequency for dT/dz power spectrum
% tp_power = dT/dz power spectrum
% fallspd = vertical speed m/s
% epsilon = measured eps
% nu
% thermal_diff
% f_c = cutoff frequency (for noise)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% function calc_chi(tp,fallspd,epsilon,nu,thermal_diff,f_c)
% program to calculate chi from tp data once we know epsilon.
% Optional output arguments are [chi,k,spec,k_batch,spec_batch]
% requires global head.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
filt_ord = 4; % not sure about this though...

% initialize all outs
chi = nan;
k = nan;
spec = nan;
k_batch = nan;
spec_batch = nan;

if any(isnan(tp_power))
  chi=NaN;
return
end

if ~exist('head','var')
  % Try getting it from global:
  global head
end

% slow_sample_rate=head.samplerate/32; THIS IS NOT CORRECT FOR MARLIN DATA, but calculated
% head.slow_samp_rate in raw_load routine is correct, though it could be used directly
% % and not calculate it again
% slow_sample_rate=head.slow_samp_rate;
% filt_ord=4;
% fspd=.01*mean(fallspd);
% 
% irep_tp=head.modulas(head_index_num);
% fcutoff=head.filter_freq(head_index_num);
% temp=deblank(head.sensor_id(head_index_num,:));

% The following are the cutoff frequencies for the the
% thermistor transfer function:
% if strcmp(temp,'TC97')
%    f_c=100;
% elseif strcmp(temp,'TP2')
%    f_c=20;
%    fcutoff=40;
%    filt_ord=2.3;
% elseif strcmp(temp,'T_prime')
%    f_c=14;
%    fcutoff=40;
%    filt_ord=1.7;
% else
%    f_c=32;% 12<f_c<21 for single pole (pole=1) and 25<f_c<37 for double pole (pole=2)
%    pole=2; % pole=2;
% end

ks = ((epsilon/(nu^3))^.25 )/2/pi;
k_start = 3; % old value k_start=1, but k_start=3 seems to be better for eq08
k_startb=1;
f_startb=k_startb*fspd;
kb=(ks*sqrt(nu/thermal_diff));
k_end = kb/2;
f_start= k_start * fspd;
f_stop = k_end * fspd;

if f_stop>15;
    f_stop=15;
end

if f_start<fre(1)
    f_start=fre(1);
end

%sss=invert_filt(fre,invert_filt(fre,tp_power,pole,f_c),filt_ord,fcutoff);
sss = invert_filt(fre,tp_power,filt_ord,f_c); % remove noise
chi_part= 6*thermal_diff* integrate(f_start,f_stop,fre,sss);
chi=chi_part;

if isnan(chi)
    chi=NaN;k=NaN;spec=NaN;k_batch=NaN;spec_batch=NaN;
    return
end

% AP 6/28/16 - This next while loop finds the value of chi for which the
% observed and theoretical spectra match between f_start and f_stop (I
% think)
chi_test=chi_part*2;
b_freq=(10.^(-2:.1:3.5))';
while abs(chi_part/chi_test-1)>.01
    b_spec= kraichnan(nu,b_freq/fspd,kb,thermal_diff,chi,7)/fspd;
    %   [chi 6*thermal_diff*integrate(min(b_freq),max(b_freq),b_freq,b_spec)]
    chi_test=6*thermal_diff*integrate(f_start,f_stop,b_freq,b_spec);
    chi=chi*chi_part/chi_test;
end

% AP 6/28/16 - Chi is then computed by integrating the theoretical spectra
% (for value of chi found above) out to kb. (I think)
chi=6*thermal_diff*integrate(f_startb,kb*fspd,b_freq,b_spec);
k_batch=b_freq/fspd;
spec_batch=b_spec*fspd;% to convert from K/[m^2*Hz] to K/[m^2*cpm]
k=fre/fspd;
spec=sss*fspd;% to convert from K/[m^2*Hz] to K/[m^2*cpm]

return