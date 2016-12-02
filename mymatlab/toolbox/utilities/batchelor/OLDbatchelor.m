function [k,Psg]=batchelor(epsilon,chi,nu,D,q)
% Usage: [k,Psg]=batchelor(epsilon,chi,nu,D,q);
%  inputs:
%    epsilon: turbulent dissipation rate, W/kg
%    chi: scalar dissipation rate, K^2/s or (c.u.)^2/s
%    nu: kinematic viscosity, m^2/s
%    D: scalar diffusivity, m^2/s
%    q: strain parameter, optional, q=3.7 is default
%  outputs:
%    k: wavenumber, cpm
%    Psg: power spectrum of scalar gradient, e.g. (K/m)^2/cpm if the
%     scalar is temperature and (c.u./m)^2/cpm if scalar is
%     salinity.
% Function: To evaluate the one-dimensional power spectrum of
%  scalar gradient using the theoretical form of Batchelor (1959).

%------------------------------------------------------------------------------
%
%        BATCHELOR              08-19-92               Ren-Chieh Lien
%
%        Batchelor temperature gradient spectrum
%
%        function batchelor(epsilon,chi,nu,D,q);
%
%        reference : 
%               Oakey, N. S., "Determination of the rate of dissipation of
%               turbulent energy from simultaneous temperature and velocity 
%               shear microstructure measurements", j.p.o., 12, 256-271, 1981.
%
%------------------------------------------------------------------------------
     
     eta=(nu^3/epsilon)^(1/4);  % Kolmogoroff length scale, in meters
%k = -1:0.1:3;
     
% set wavenumber range, in cpm, based on eta
     k0=1/(500*eta);
     kmax=3/(5*eta);
    dk=(kmax-k0)/1000;
    k=k0:dk:kmax;

     
     
%k = exp(k*log(10));
     if (nargin == 4);
	 q = 3.7;
     end
     kb = (epsilon/nu/D^2)^(1/4);
     a = sqrt(2*q)*2*pi*k/kb;
     for i=1:length(a);
         uppera(i) = erf(a(i)/sqrt(2),Inf)*sqrt(pi/2);
     end
     g = 2*pi*a.*(exp(-a.^2/2) - a.*uppera);
     Psg = sqrt(q/2)*(chi/kb/D)*g;
%     loglog(k,tempsp);
