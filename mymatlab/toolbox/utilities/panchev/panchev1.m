function P = panchev1(epsilon,kvis) 
% panchev
%   Usage: P = panchev1(epsilon,nu,kin)
%      epsilon is the dissipation rate in W/kg
%      kvis is the kinematic viscosity in m^2/s 
%      P is Panchev's theoretical spectrum of transverse shear
%        at k 
%   Function: evaluate and return Panchev's universal turbulent
%      spectrum between (1/2000-1/5) eta,
%      where eta=(nu^3/epsilon)^(1/4), with uniformly spaced
%      wavenumbers.  The output is useful for integration
%      data for epsilon integration schemes

%   rewritten in function form by kw 8/5/94, modified by mg 1/16/95, 4/25/95
%   mg 7/25/95.

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

k0=1/(2000*eta);
kmax=1/(5*eta);
dk=(kmax-k0)/200;
k=k0:dk:kmax;
npts=length(k);

%  do the computation:
scale=2*pi*(epsilon*kvis^5.)^(0.25);
Pxx=zeros(size(k));
for j=1:npts
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

P=Pxx(npts);
