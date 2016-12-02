function frspec=gmfrspec_nokc(k3)
%   Usage: frspec=gmfrspec_nokc(k3);
%     inputs
%      k3=vertical wavenumbers in cpm
%      N must be global and have a value when this script is called.
%     output
%      frspec=Froude spectrum, Shear spectrun / N^2, for
%         GM76 model without the k3^-1 rolloff,
%         as in eqn. 14 of Gregg, et al. (1992), J. Phys. Ocean.
%         vol 23, p 129.k
%   M.Gregg, 16 July 95

global N

% constants
E0=6.3e-5; % dimensionless energy density
b=1300; % scale depth of thermocline, meters
N0=2*pi*(3/3600); % reference buoyancy frequency, radians/sec
jstar=3; % vertical mode number
kc=0.1*2*pi; % cutoff wavenumber, radian/meter

% derived parameter
k3star=(pi*jstar/b)*(N/N0);

npts=length(k3);

k3rad=2*pi*k3; % vertical wavenumbers in radians/meter

% compute the dependence on vertical wavenumber
k3fcn=k3rad.^2 ./ (1+k3rad/k3star).^2;

% compute the Froude spectrum
frspec=((3*E0*b^3)/(2*jstar*pi))*(N0/N)^2*k3fcn;

% convert to cyclic units
frspec=2*pi*frspec;

