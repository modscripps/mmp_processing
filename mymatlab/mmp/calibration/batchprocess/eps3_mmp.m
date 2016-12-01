function [epsilon,kc]=eps3_mmp(k,Psheark,kvis,w,dk,kmax);
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


testing='y';

KI=(2:0.2:10); % wavenumber array for interpolation
epsintflag=1;  % reset to 0 to terminate processing

eps_fit_shear10=[8.6819e-04, -3.4473e-03, -1.3373e-03, 1.5248, -3.1607];
shtotal_fit_shear10=[6.9006e-04, -4.2461e-03, -7.0832e-04, 1.5275, 1.8564];

% first estimate, using Psheark between 2 & 10 cpm
%
% Interpolate Psheark onto 0.2 cpm grid & integrate
% Only this estimate is interpolated, as it is the only one input to
% a polynomial integrated with the same grid
krange1=find(k>=1 & k<15); 
P_interpolated=interp1(k(krange1),Psheark(krange1),KI);
shear10_1=sum(P_interpolated)*0.2
%
% estimate epsilon using poly fits to log10(shear10)
x=log10(shear10_1);
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
shear10_2=sum(Psheark(krange))*dk;
log10_sheartotal_2=polyval(shtotal_fit_shear10,log10(shear10_2));
eps2=7.5*kvis*10^log10_sheartotal_2;

% third estimate
kc3=0.0816*( eps2 / kvis^3 )^(1/4);
if kc > kmax
	kc=kmax;
end
krange3=find(k>=1 & k<=kc3);
shear10_3=sum(Psheark(krange3))*dk;
log10_sheartotal_3=polyval(shtotal_fit_shear10,log10(shear10_3));
eps3=7.5*kvis*10^log10_sheartotal_3;

epsilon=eps3; kc=kc3;

if strcmp(testing,'y')
  str1=['kc1=' num2str(10) ', shear10_1=' num2str(shear10_1) ', eps1=' num2str(eps1)];
  disp(str1)
  str2=['kc2=' num2str(kc2) ', shear10_2=' num2str(shear10_2) ', eps2=' num2str(eps2)];
  disp(str2)
  str3=['kc3=' num2str(kc3) ', shear10_3=' num2str(shear10_3) ', eps3=' num2str(eps3)];
  disp(str3)
end
