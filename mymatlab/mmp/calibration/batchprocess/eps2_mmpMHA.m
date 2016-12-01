function [epsilon,kmax]=eps2_mmpMHA(P,f,w,viscosity,Pshear,k,dk,Pnoise_i)
% eps2_mmpMHA
% Usage: [epsilon,kmax]=eps2_mmp(P,f,w,viscosity,Pshear,k,dk,Pnoise)
%   P is the airfoil spectral array in volts^2 / Hz
%   f is the frequency array
%   w is the fall rate
%   viscosity the the kinematic viscosity, in m^2/s
%   Pshear is the airfoil spectrum converted to shear vs k
%   k is wavenumber, in cpm
%   dk is the elementary bandwidth, in cpm
%   Pnoise is the noise spectrum for channels v1 and v2
%   epsilon is the dissipation rate
%   kmax is the upper limit for integrating the spectrum
% Function: determine epsilon by integrating to where the
%   raw voltage spectrum falls to twice the noise.

%     A noise spectrum (volts^2/Hz) observed in Lake Washington, is compared 
%   with the observed frequency spectrum run through a 5-point median
%   filter.  Observed estimates larger than the noise spectrum are selected. 
%   The lower bound for integration is 1 cpm.  The upper bound of the f range
%   for integration is:
%      (a) cut off at the lowest gap, i.e. where the spectrum first drops 
%          below the noise,
%      (b) cut off at the lowest peak of the pump vibration unless the
%          amplitude of the spectrum exceeds that of the pump spike.
%   The maximum frequency, fmax, is converted to wavenumber as kmax and
%   returned for use in later routines.
%
%I've modified the eps2_mmp routine to allow use of different lengths besides 256
%mha 6/17/99
%
% primary parameters
KSTART=1;  % lower limit for integrating spectrum, in cpm
KSTOP=100; % limit set by probe size, in cpm
FSTOP=48;  % limit set by peak of lowest pump vibration, in Hz

% secondary parameters
fstart=KSTART*w;
index_f=find(f>=fstart & f<FSTOP);
ISTOP=max(index_f);  % index of FSTOP in f array 
FS_hf=400; 		  % sample rate of high-frequency channels
dfnoise=FS_hf/512; % elementary frequency bandwidth for noise spec
fnoise=(dfnoise:dfnoise:dfnoise*256)'; % frequency vector for noise spectra
%interpolate the noise spectrum onto the specified freq vector
Pnoise=interp1(fnoise, Pnoise_i,f,'spline');

Pmed=medfilt1(P,5)'; % apply 5-pt median filter to spectrum
i_signal=find(Pmed>2*Pnoise & f>=fstart & f <FSTOP); % indices of noise-free Pmed
                                         % below peak of pump vibration

% find fmax, the highest f not affected by noise
if isempty(i_signal)==1
	fmax=0;
else
	% determine if i_signal has a gap
	di=find(diff(i_signal)>1); % indices of gaps
	if isempty(di) % no gap
		fmax=f(max(i_signal)); % for no gap take the highest f
	else % one or more gaps
		di_min=min(di); % for a gap take the highest f below the lowest gap
		fmax=f(di_min);
	end
end

% set to probe limit if spectal magnitude at ISTOP exceeds pump vibration level
if fmax==0;
	kmax=0;
elseif fmax==f(ISTOP) & P(ISTOP)>2e-4
	kmax= KSTOP;
elseif fmax/w>KSTOP
	kmax=KSTOP;
else
	kmax=fmax/w;
end

krange=find(k>=KSTART & k<=kmax);
if length(krange)<4
	epsilon=1e-10;
else
	epsilon=7.5*viscosity*sum(Pshear(krange))*dk;
	if epsilon>1e-6 & kmax==KSTOP
		epsilon=epsilon2_correct(epsilon,viscosity)*epsilon;
	end
end

if epsilon<1e-10
	epsilon=1e-10;
end
