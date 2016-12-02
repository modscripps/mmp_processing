function [k,Pxx] = panchev2(epsilon,nu) 
% panchev
%   Usage: [k,Pxx] = panchev(epsilon,nu)
%      epsilon is the dissipation rate in W/kg
%      nu is the kinematic viscosity in m^2/s
%      k=(2:0.1:10); is wavenumber in .2 increments between 2 & 10 cpm
%      Pxx is Panchev's theoretical spectrum of transverse shear 
%   Function: evaluate and return Panchev's universal turbulent
%      spectrum between 2 and 10 cpm with uniformly spaced
%      wavenumbers for integrating when setting up background
%      data for epsilon integration scheme

%   rewritten in function form by kw 8/5/94, modified by mg 1/16/95

% set values for constants and zeta integration
eta=(nu^3/epsilon)^(1/4); % Kolmogoroff length scale, in meters
a = 1.6;
delta = 0.1;
conv = 1/(eta*2*pi);
c32 = 3/2;
sc32 = sqrt(c32);
c23 = 2./3.;
ac32 = a^c32;
c43 = 4./3.;

% set wavenumber range, in cpm, based on eta
k0=2;
kmax=10;
dk=.2;
k=k0:dk:kmax;

%  do the computation:
scale=2*pi*(epsilon*nu^5.)^(0.25);
for j=1:length(k)
	kn=k(j)/conv;
	integral=0.;
	for zeta = delta/2. : delta : 1.0
		integral = integral + delta*(1+zeta^2)*(a*zeta^c23+(sc32*ac32)*kn^c23)* exp(-c32*a*(kn/zeta)^c43 - (sc32*ac32*(kn/zeta)^2.));	
	end
	phi = 0.5*kn^(-5./3.)*integral;
	Pxx(j) = scale*(kn/eta)^2*phi;
end


