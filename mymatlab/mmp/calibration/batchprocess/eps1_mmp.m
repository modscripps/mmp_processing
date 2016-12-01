function [epsilon,kc]=eps1_mmp(k,Psheark,kvis,w,dk,kmax);
% eps1_mmp
%   Usage: epsilon=eps1_mmp(k,Psheark,kvis,w);
%      k is a vector array with wavenumber in cpm
%      Psheark is a vector array with the shear spectrum
%      kvis is the kinematic viscocity, in m^2/s
%      w is the vehicle speed, in m/s
%      dk is the elementary wavenumber bandwidth, in cpm
%      kmax is the maximum wavenumber determined by eps1_mmp
%      epsilon is the estimated dissipation rate, in W/kg
%      kc is the wavenumber at which integration is cutoff, in cpm
%   Function: To integrate airfoil shear versus k spectra to
%      obtain epsilon.  The algorithm is similar to that of
%      Wesson & Gregg, 1994, JGR, 99, -9877, but uses Panchev's
%      universal spectrum for reference and stops integration to 
%      avoid vibration peaks.  This limit, kmax, is determined by eps2_mmp.

%    Epsilon is determined iteratively, in three stages.
%    (1) integration between 2 and 10 cpm, eps1
%          The observed spectrum is interpolated onto a wavenumber grid
%       between 2 and 10 cpm, with 0.2 cpm steps.  The integral, shear 10,
%       is compared with an integral of Panchev's universal spectrum over
%       the same grid.  If log10(shear10)>-3, 2 to 10 cpm lies solely in
%       the inertial subrange, which does not depend on viscosity.  Epsilon
%       is obtained directly from a polynomial fit of epsilon to shear10 for
%       the Panchev spectrum.  If log10(shear10)<=-3, 2 to 10 cpm contains at
%       least some of the viscous rolloff and epsilon/7.5 nu is obtained from
%       a polynomial fit to minimize errors due to viscosity.
%
%    (2) integration to the wavenumber containing 90% variance of Panchev's
%       spectrum evaluated with eps1 and nu, eps2
%         The upper limit for integration is reduced if it exceeds kmax, the limit
%       determined for noise-free spectra by script eps2_mmp.m.  The lower bound
%       is at 1 cpmk.  If fewer than 4 spectral estimates are in the wavenumber band, 
%       no integration is done and epsilon is set to 1e-10, taken as the base level.  
%       The estimate is raised by script epsilon_correct.m if the signal has been 
%       reduced by probe attenuation.  
%
%    (3) repeat of (2) with wavenumber determined from eps2    

KI=(2:0.2:10); % wavenumber array for interpolation
epsintflag=1;  % reset to 0 to terminate processing

eps_fit_shear10=[8.6819e-04, -3.4473e-03, -1.3373e-03, 1.5248, -3.1607];
shtotal_fit_shear10=[6.9006e-04, -4.2461e-03, -7.0832e-04, 1.5275, 1.8564];

% first estimate, using Psheark between 2 & 10 cpm
%
% Interpolate Psheark onto 0.2 cpm grid & integrate
% Only this estimate is interpolated, as it is the only one input to
% a polynomial integrated with the same grid
krange=find(k>=1 & k<15); 
P_interpolated=interp1(k(krange),Psheark(krange),KI);
shear10=sum(P_interpolated)*0.2;
%
% estimate epsilon using poly fits to log10(shear10)
x=log10(shear10);
if x>-3 % 2-10 cpm lies entirely in inertial subrange
	log10eps=polyval(eps_fit_shear10,x);
	eps1=10^log10eps;
else
	log10_sheartotal=polyval(shtotal_fit_shear10,x);
	eps1=7.5*kvis*10^log10_sheartotal;
end

% second estimate
kc2 = 0.0816*( eps1  / kvis^3 )^(1/4);  % k for 90% variance of Panchev spectrum
if kc2>kmax
	kc2=kmax; % limit set by noise spectrum
end
krange=find(k>=1 & k<=kc2);
eps2=7.5*kvis*sum(Psheark(krange))*dk/.9;
eps_corr=epsilon_correct(eps2,kvis,kc2);
eps3=eps_corr*eps2; % adjust for probe attenuation

% third estimate
kc=0.0816*( eps2 / kvis^3 )^(1/4);
if kc > kmax
	kc=kmax;
end
krange=find(k>=1 & k<=kc);
eps3 = 7.5*kvis*sum(Psheark(krange))*dk; 

if eps3<1e-10 | length(krange) < 4
	epsilon=1e-10;
%elseif kmax>100 & eps3>1e-6
else
  mf=epsilon2_correct(eps3,kvis);
	epsilon=mf*eps3;
%else
%  epsilon=eps3;
end
