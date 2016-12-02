function [k,Pxx] = panchev_logspace(epsilon,kvis) 
% panchev
%   Usage: [k,Pxx] = panchev_logspace(epsilon,nu)
%      epsilon is the turbulent dissipation rate in W/kg
%      kvis is the kinematic viscosity in m^2/s
%      k is the one-dimensional wavenumber in cpm, with 30 values 
%         logarithmly spaced between (0.001-5)*k_nu
%      Pxx is the 1d shear spectrum of transverse velocities
%   Function: evaluate the 1d spectrum for universal
%        turbulence as derived by Panchev (1969), Comptes rendus 
%        de l'Academie bulgare des Sciences, 22, 627--630.

% set values for constants and zeta integration
eta=(kvis^3/epsilon)^(1/4); % Kolmogoroff length scale, in meters
a = 1.6;
delta = 0.1;
conv = 1/(eta*2*pi);
c32 = 3/2;
sc32 = sqrt(c32);
c23 = 2./3.;
ac32 = a^c32;
c43 = 4./3.;

% set wavenumber range, in cpm, based on eta
k0=1/(1000*eta);
kmax=1/(5*eta);
k=logspace(log10(k0),log10(kmax),30);

%  do the computation:
scale=2*pi*(epsilon*kvis^5.)^(0.25);
for j=1:length(k)
	kn=k(j)/conv;
	integral=0.;
	for zeta = delta/2. : delta : 1.0
		integral = integral + delta*(1+zeta^2)* ... 
		(a*zeta^c23+(sc32*ac32)*kn^c23)* exp(-c32*a*(kn/zeta)^c43 ...
		- (sc32*ac32*(kn/zeta)^2.));	
	end
	phi = 0.5*kn^(-5./3.)*integral;
	Pxx(j) = scale*(kn/eta)^2*phi;
end

k=k';
Pxx=Pxx';

