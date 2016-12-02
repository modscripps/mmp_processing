function [k,Pxx] = panchev(epsilon,kvis,kin) 
% panchev
%   Usage: [k,Pxx]=panchev(epsilon,kvis,kin);
%     inputs
%      epsilon is the dissipation rate in W/kg
%      kvis is the kinematic viscosity in m^2/s
%      kin, vector of wavenumbers in cpm, is an optional argument
%     outputs
%      k, a vector of wavenumbers,  is kin if it is specified.  Otherwise
%         it is uniformly spaced between 1/(1000*eta) and 1/(5*eta)
%      Pxx is Panchev's theoretical spectrum of transverse shear 
%   Function: evaluate and return Panchev's universal turbulent
%      spectrum for a specified wavenumber vector, if specified, or
%      for one uniformly spaced to span the lower inertial subrange and
%      the dissipation range.

%   Rewritten in function form by kw 8/5/94, modified by mg 1/16/95, 4/25/95,
%     9/15/95
%   Revised to partially vectorize calculation, decreasing cpu
%     time 18-fold for no kin. 12/16/96

% set values for constants and zeta integration
eta=(kvis^3/epsilon)^(1/4); % Kolmogoroff length scale, in meters
a = 1.6;
delta = 0.1;
conv = 1/(eta*2*pi);
c32 = 3/2;
sc32 = sqrt(c32);
c23 = 2/3;
ac32 = a^c32;
c43 = 4/3;

% if kin is not given,set wavenumber range, in cpm, based on eta
if nargin < 3
	k0=1/(1000*eta);
	kmax=1/(5*eta);
	dk=(kmax-k0)/200;
	kin=k0:dk:kmax;
end

%  do the computation:
scale=2*pi*(epsilon*kvis^5)^0.25;
sum=zeros(size(kin));
kn=kin/conv;
zeta=delta/2:delta:1;
nzeta=length(zeta);
for i=1:nzeta
  z=zeta(i);
	sum=sum ...
	+ delta .* (1+z.^2) ...
	.* (a.*z.^c23 + (sc32.*ac32) .* kn.^c23) ...
	.* exp(-c32.*a.*(kn/z).^c43 - (sc32.*ac32.*(kn/z).^2));	
end
phi = 0.5.*kn.^(-5/3).*sum;
Pxx = scale.*(kn/eta).^2.*phi;

k=kin(:); Pxx=Pxx(:);

