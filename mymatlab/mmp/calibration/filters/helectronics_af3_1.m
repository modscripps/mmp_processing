function h=helectronics_af3_1(Cs, f)
% helectronics_af3_1
%   Usage: h=helectronics_af3_1(Cs, f)
%	   Cs is probe capacitance, in picofarads, e.g. 980
%	   f is a column vector of frequencies to be evaluated
%	Function: Power transfer function of airfoil electronics 
%      in case af3, mod1

G=9.80665; % gravitational acceleration
Cs = 1e-12 * Cs; % convert Cs from picofarads to farads

% circuit components
RC1=1.0e6;
RC2=3.01e3;
RC3=1.0e7;
CCF=1.0e-9;
RD1=2.37e3;
CD1=3.3e-7;
RDF=4.75e5;
CDF=8.2e-10;
RG1=1.21e4;
RGF=3.74e4;
RCS=1.0e5;

% calculated circuit parameters for charge amplifier circuit
Rf=RC1*RC3/RC2;
fL=1/(2*pi*Rf*CCF);
fH=1/(2*pi*RCS*Cs);

% calculated circuit parameters for differentiator circuit
K=1/(2*pi*RD1*CDF);
f1=1/(2*pi*RD1*CD1);
f2=1/(2*pi*RDF*CDF);

% calculated circuit parameters for gain circuit
Hsq_gain=(1 + RGF/RG1)^2;

% hca(Cs,f) --- power transfer function of MMP charge amplifier circuit
yn = (Cs / CCF ).^2 .* (f' / fL ).^2;
yd = (1 + (f' / fL ).^2) .* (1 + (f' / fH ).^2);
hca = yn ./ yd;

% hdiff(f) --- power transfer function of MMP differentiator circuit
hdiff = (K^2 .* f'.^2) ./ ( (f1^2 + f'.^2 ) .* (f2^2 + f'.^2) );

% hgain(f) --- power transfer function of mmp shear probe gain amplifier
gain=(1 + RGF/RG1)^2;
hgain = gain .* ones(size(f))';

% hcheby6(f) --- power transfer  fcn. of 6-pole Cheby filter used with vg
% channel.  Uses Williams (1981) to convert from 3db freq to Wn used by matlab
%fc=150;
%x =f'./fc;
%hcheby6 = 1 ./ (1+epsilon^2 .* (32 .* x.^6 - 48 .* x.^4 + 18 .* x.^2 - 1));

h = hca .* hdiff .* hgain;
h=h';
