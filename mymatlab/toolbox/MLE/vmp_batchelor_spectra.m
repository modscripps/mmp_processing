function P_B = vmp_batchelor_spectra(kB,k,chi,kappa,q)

% P_B = vmp_batchelor_spectra(kB,k,chi,kappa,q)
%
% Routine for calculating the Batchelor spectra. This follows the equations
% in Ruddick et al. 2000, JTECH and Oakey 1981, JPO
%
% Inputs
%   kB: The batchelor wavenumber (units of radians per meter which is what
%          the equation kB = (epsilon/nu*(kappa)^2)^0.25 gives.
%   k: Wavenumber vector.
%   chi: Scalar dissipation rate
%   nu: Kinematic viscosity, m^2/s
%   kappa: Scalar diffusivity, K^2/s or (c.u.)^2/s
%   q: 'universial' stain parameter. Default q = 3.7
%
% Outputs
%   P_B: Power spectrum of scalar gradient, e.g. (K/m)^2/cpm if the
%          scalar is temperature and (c.u./m)^2/cpm if scalar is salinity.
%
% G. Carter Aug-12

% Defaults
if ~exist('q','var') || isempty(q)
    q = 3.7;
end

% calulation
alpha = sqrt(2*q)*2*pi*k/kB;  % Batchelor wavenumber has units of radians per meter
upper_alpha = nan*ones(size(alpha));
for ido = 1:length(alpha);
    upper_alpha(ido) = erfc(alpha(ido)/sqrt(2))*sqrt(pi/2);
end
g = 2*pi*alpha.*(exp(-alpha.^2/2) - alpha.*upper_alpha);
P_B = sqrt(q/2)*(chi/kB/kappa)*g;