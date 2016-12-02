function frspec=gmfrspec(N,k3)
%   Usage: frspec=gmfrspec(N,k3);
%     inputs
%      k3=vertical wavenumbers in cpm
%      N = buoyancy frequency in rad/s
%      frspec=Froude spectrum, Shear spectrun / N^2, for
%         GM76 model with k3^-1 rolloff for k3 > 0.1 cpm,
%         as in eqn. 14 of Gregg, et al. (1992), J. Phys. Ocean.
%         vol 23, p 129.k
%   M.Gregg, 16 July 95

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
i=find(k3rad>kc);
k3fcn(i)=k3fcn(i).*(kc./k3rad(i)); % apply cutoff

% compute the Froude spectrum
frspec=((3*E0*b^3)/(2*jstar*pi))*(N0/N)^2*k3fcn;

% convert to cyclic units
frspec=2*pi*frspec; 
