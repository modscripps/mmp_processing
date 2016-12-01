function h=ht1_1_mmp(f,tref,tl1V)
% ht1_1_mmp
%   Usage: h=ht1_1_mmp(f)
%      f is a column vector of frequencies
%      t and V are column arrays of tref and tl1V for computing beta
%      h is the magnitude-squared response of the th circuit in
%      case t1, mod1

% circuit parameters
R1=1.0e4;	R9=1.0e4;
R2=1.0e6;	R10=2.5e4;
R3=1.5e3;	R11=5.00e5;
R4=1.5e3;	R12=5.0e4;
R5=4.99e5;	C3=2.0e-6;
R6=1.0e6;	C8=2.0e-6;
R7=1.3e3;	C9=2.0e-6;
R8=4.99e5;	C10=2.0e-6;
E0=9.992; % measured voltage reference

% secondary circuit parameters
Gth=(R7+R8)/R7; % gain
E1=(E0*R12)/(R9+R10);
Gtl=1+R12/R11+R12/(R9+R10);

% calculate beta=dET/dtreg, the change in voltage across the thermistor per deg C
ET=(tl1V+E1)./ Gtl; % voltage across thermistor
ETfit=polyfit(tref,ET,2);
ETcalc=polyval(ETfit,tref);
residual = ETcalc - ET;
str=['     rms residual to tl1V fit = ' num2str(std(residual)) ' volt'];
disp(str)
beta=diff(ETcalc) ./ diff(tref);
beta=[beta(1), beta(1:length(beta))']; % duplicate the first value
beta=beta';
clear tl1Vfit tl1Vcalc residual str

% numerator
N=(2*pi).*f .* (C8*R4*Gth); 
N=N.^2;

% denominator
D1=1+(R3/(R5+R6)) - f.^2 .* (2*pi)^2*C8*C9*R3*R4;
D2=(2*pi.*f).*(C8*R3+(C8+C9)*R4+R3*R4/(R5+R6)*(C9+C8*(1-Gth)));
D=D1.^2 + D2.^2;

h=N./D;
