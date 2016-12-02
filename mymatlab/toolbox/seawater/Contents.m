% seawater toolbox
%     Inputs and outputs in SI units
%        salinity in concentration units, e.g. 0.035 kg_salt/kg_seawater
%        temperature in deg C
%        pressure in MPa, relative to atmospheric pressure
%
%                 PROPERTIES OF SEAWATER
% cp:  cp=cp(s,t) - Specific heat at cst. pressure
% density: rho = density(s,t,p) - density of standard seawater
% k: k=k(s,t,p) - thermal conductivity
% kt: kt=kt(s,t,p) - thermal diffusivity
% nu: kvis=nu(s,t,p) - kinematic viscosity
% pofz; p=pofz(z) - p as a function of z for the world ocean 
% potemp: theta = potemp(s,t,p) - potential temperature
% potempref: theta_r = potempref(s, t, p, p_ref) - pot. temp. at ref. temp.
% Rrhofun: angle=Rrhofun(s,t,p) - density ratio as angle
% salinity: s = sal(c,t,p) - Salinity for world ocean
% zofp: z=zofp(p) -  depth of z in m as a function of p for a std ocean. 
%
%                 SORTING BASED ON SEAWATER PROPERTIES
% isopycnal: z = isopycnal(sigt_file,sigt_given) - depth of sigmat value
% isopyccprop: 
% isopycpropfun: [sigt,s,theta]=isoycpropfun(lct,z_given) - ?
% isotherm: z=isotherm(D) - depth of isotherm
% sortsigma: ss=sortsigma(sigma_profile) - sorts density ??
%
%                 SPECIAL PLOTS
% stsplot: tsplot(s,t)
