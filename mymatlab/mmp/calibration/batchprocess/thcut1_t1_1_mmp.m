function fc_index=thcut1_t1_1_mmp(f,spec,displ_chi_spec,pr_chi,j,speed)
% thcut1_t1_1_mmp
%   Usage: fc_index=thcut1_t1_1_mmp(f,spec)
%      f is a vector of frequencies
%      spec is a vector of th spectra, in volts^2/Hz
%      displ_chi_spec is a string specifying whether to plot spec
%      pr_chi is the center pressure of this spectrum
%      j in the index number of the chi estimate
%      speed is the vehicle speed, m/s
%      fc_index is the integer index of the kc, the maximum
%      frequency to which the spectrum is integrated
%   Function: determine the cut-off frequency for th spectra.
%      It is taken as the highest frequency for which a 5th-order
%      median filter exceeds the noise spectrum.  If displ_chi_spec='yes' the
%      volts^2 spectra are displayed, overlaid with the cutoff frequency and
%      the median filter.

f=f(:); spec=spec(:);
% fit coefficients for log10(noise spectrum) vs log10(f)
n0=-7.8; n1=-0.0634538; n2=0.3421899; n3=-0.3141283;

logf=log10(f);
noise=n0+n1.*logf+n2.*logf.^2+n3.*logf.^3;

logspec=log10(spec);
medspec=medfilt1(logspec,5); % 5th order median filter

noisy=find(medspec<log10(1.5)+noise);
if isempty(noisy)
	fc_index=length(f);
else
	fc_index=noisy(1);
end
if fc_index>1
	fc_index=fc_index-1;
end

% plot the spectrum if displ_chi_spec='yes'
if strcmp(displ_chi_spec,'yes')==1
	clf
	fc=f(fc_index)*ones(2,1);
	logfc=log10(fc);
	ref(1,1)=max(logspec); ref(2,1)=min(logspec);
	plot(logf,logspec)
	hold on
	plot(logf,noise,'o')
	plot(logf,medspec,'x')
	plot(logfc,ref,'-')
	str=['j=' int2str(j) ' , speed=' num2str(speed) ', p = ' num2str(pr_chi) ' MPa' ...
	     ', fc=' num2str(f(fc_index)) ' Hz'];
	title(str)
	xlabel('log10(f / Hz)'), ylabel('log10(P_th1 / volts^2 Hz^-1)')
	hold off
	pause
end
