function beta=beta_thcircuit1_mmp(RT,alphaT)
%   Usage: beta=beta_thcircuit1_mmp(RT,alphaT)
%      RT is the thermistor resistance, in ohms
%      alphaT=(1/RT)(d RT /dT)
%	Function: beta is the voltage change per degree C across
%      the thermistor.

R1=1e-4;	R2=1e6;	E0=10;

beta=(alphaT*(R1+R2)*RT*E0)/(R1+R2+RT)^2;	
