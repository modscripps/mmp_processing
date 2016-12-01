function h=helectronics_af2_1(Cs, f, coef_file)
%   haf__af2elec_1
%   Usage: h=haf_af1elec_1(Cs, f, 'coef_file')
%	   Cs is probe capacitance, in picofarads, e.g. 980
%	   f is a column vector of frequencies to be evaluated
%	   coef_file is string name of file containing electronic
%         coef, e.g. af2coef_1.m
%	Function: Power transfer function of airfoil electronics 
%      in case af2, mod1

G=9.80665; % gravitational acceleration

eval(coef_file)

% hca(Cs,f) --- power transfer function of MMP charge amplifier circuit
Cs = 1e-12 * Cs; % convert Cs from picofarads to farads
yn = (Cs / ccf ).^2 .* (f' / fl ).^2;
yd = (1 + (f' / fl ).^2) .* (1 + (f' / fh ).^2);
hca = yn ./ yd;

% hdiff(f) --- power transfer function of MMP differentiator circuit
hdiff = (k^2 .* f'.^2) ./ ( (f1^2 + f'.^2 ) .* (f2^2 + f'.^2) );

% hgain(f) --- power transfer function of mmp shear probe gain amplifier
gain=(1 + Rgf/Rg1)^2;
hgain = gain .* ones(size(f))';

% hcheby6(f) --- power transfer  fcn. of 6-pole Cheby filter used with vg
% channel.  Uses Williams (1981) to convert from 3db freq to Wn used by matlab
x =f'./fc;
hcheby6 = 1 ./ (1+epsilon^2 .* (32 .* x.^6 - 48 .* x.^4 + 18 .* x.^2 - 1));

h = hca .* hdiff .* hgain .* hcheby6;
h=h';
