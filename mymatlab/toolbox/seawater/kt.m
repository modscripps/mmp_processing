function thermal_diffusivity=kt(s,t,p)
% kt
%   Usage: kt=kt(s,t,p)
%      s is salinity in concentration units
%      t is temperature in deg C
%      p is pressure in MPa
%      kt is thermal diffusivity in m^2/s

thermal_diffusivity = thermometric_cond(s,t,p)./( density(s,t,p) .* cp(s,t) );
