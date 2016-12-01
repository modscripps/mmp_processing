function [h,Gtl,E1]=ht3_1_mmp(f)
% ht1_1_mmp
%   Usage: h=ht1_1_mmp(f)
%      f is a column vector of frequencies
%      h is the magnitude-squared response of the th circuit in
%         case t1, mod1
%      Gth is the gain of the tl circuit
%      E1 is an intermediate voltage in the tl circuit

%nominal circuit parameters
R1=1e4;		R2=1e6;		R3=1.5e3;	R4=1.5e3;	R5=4.99e5;
R6=1e6;		R7=1.3e3;	R8=4.99e5;	R9=1e4;		R10=2.5e4;	
R11=5e5;	R12=5e4;	C3=2e-6;	C8=2e-6;	C9=2e-6;	
C10=2e-6;
E0=10.0;	% nominal value


E1=(R12 * E0) / (R9 + R10);

Gtl=1 + R12/R11 + R12/(R9+R10);

Gth=(R7+R8)/R7; % gain of th circuit

% numerator
N=(2*pi).*f .* (C8*R4*Gth); 
N=N.^2;

% denominator
D1=1+(R3/(R5+R6)) - f.^2 .* (2*pi)^2*C8*C9*R3*R4;
D2=(2*pi.*f).*(C8*R3+(C8+C9)*R4+R3*R4/(R5+R6)*(C9+C8*(1-Gth)));
D=D1.^2 + D2.^2;

h=N./D;
