function h=haf2_1(Sv, Cs, f, w, coef_file)
% haf1_1
%   Usage: h=haf1_1(Sv, Cs, f, w, 'coef_file')
%	   Sv is airfoil probe sensitivity, e.g. 24.5, 
%      Cs is airfoil probe capacitance, in pico farads, e.g. 1000 
%	   w is instrument fall rate in m/s.
%	   coef_file is the name of the file containing the 
%        electronic coefficients for af case 2, mod1, 
%        e.g. coef_af2_1
%   Function: returns total transfer function of af case 2, mod 1

G=9.80665; % gravitational acceleration

% scaling for probe sensitivity
scale=( (Sv*w)/(2*G) )^2;

% probe transfer function
hprobe=haf_oakey(f,w);

% electronics power transfer function
helec=haf_af2elec_1(Cs, f, coef_file);

h=scale .* hprobe .* helec;
