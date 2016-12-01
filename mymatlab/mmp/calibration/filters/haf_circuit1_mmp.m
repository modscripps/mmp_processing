function h=haf_circuit1_mmp(Cs,f)
% haf_circuit1_mmp
%   Usage: h=haf_circuit1_mmp(Cs,f)
%	   Cs is probe capacitance, in picofarads, e.g. 980
%	   f is a column vector of frequencies to be evaluated
%   Function: returns total electronic transfer fcn of the
%      first airfoil circuit configuration used in mmp.

G=9.80665; % gravitational acceleration

% hca(Cs,f) --- power transfer function of MMP charge amplifier circuit
ccf=1.0e-9; % Farad
fl=0.0479; % Hz
fh=1592; % Hz
Cs = 1e-12 * Cs; % convert Cs from picofarads to farads
yn = (Cs / ccf ).^2 .* (f' / fl ).^2;
yd = (1 + (f' / fl ).^2) .* (1 + (f' / fh ).^2);
hca = yn ./ yd;

% hdiff(f) --- power transfer function of MMP differentiator circuit
k=81895; % Hz
f1=203.5; % Hz
f2=408.6; % Hz
hdiff = (k^2 .* f'.^2) ./ ( (f1^2 + f'.^2 ) .* (f2^2 + f'.^2) );

% hgain(f) --- power transfer function of mmp shear probe gain amplifier
Rgf = 37400; % ohms
Rg1 = 12100; % ohms
gain=(1 + Rgf/Rg1)^2;
hgain = gain .* ones(size(f))';

% hcheby6(f) --- power transfer  fcn. of 6-pole Cheby filter used with vg
% channel.  Uses Williams (1981) to convert from 3db freq to Wn used by matlab
fc=140.3815;
epsilon=0.2171;
x =f'./fc;
hcheby6 = 1 ./ (1+epsilon^2 .* (32 .* x.^6 - 48 .* x.^4 + 18 .* x.^2 - 1));

h = hca .* hdiff .* hgain .* hcheby6;
h=h';
