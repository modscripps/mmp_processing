% t2_1.m
% t2_1
%   Function: execute to load electronics configuration 1 of sensorcase t1

% circuit components
R1=1.0e4;	R5=4.99e5;	R9=1.0e4;	C3=2.0e-6;
R2=1.0e6;	R6=1.0e6;	R10=2.5e4;	C8=2.0e-6;
R3=1.5e3;	R7=1.3e3;	R11=5.00e5;	C9=2.0e-6;
R4=1.5e3;	R8=4.99e5;	R12=5.0e4;	C10=2.0e-6;
E0=9.992; % measured voltage reference

% calculated parameters for tl circuit
E1=(R12/(R9+R10))*E0;
Gtl=1+R12/R11+R12/(R9+R10);

% calculated parameters for th circuit
Gth=(R7+R8)/R7;
D1a=1+R3/(R5+R6);
D1b=(2*pi)^2*C8*C9*R3*R4;
D2a=2*pi*(C8*R3+(C8+C9)*R4+R3*R4/(R5+R6)*(C9+C8*(1-Gth)));
