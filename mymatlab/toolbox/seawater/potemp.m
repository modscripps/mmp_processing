function theta = potemp(s,t,p);
% potemp
%   Usage: theta = potemp(s,t,p);
%      s is salinity in concentration units
%      t is temperature in deg C
%      p is sea pressure in MPa
%      theta is potential temperature referred to sea surface
%       potemp.m        modified from theta.c
%
%	modified from "theta.c"
%
%	Parameter : theta
%	Source    : Caldwell and Eide (1980)
%		    Deep-Sea Res. Vol 27a, pp 71-78
%	Units     : deg C
%	Inputs    : s (concentration units), t (deg C), p (MPa)
%	range     : s (0 to 0.040), t (-2 to 40), p (0 to 138)
%	ck value  : theta (0.035, 40, 100) = 36.9334
%	Coded	  : Ngoc Dang, July 1982
%------------------------------------------------------------------------------



%*  convert inputs to form of algorithm */

	s1 = 1000.0*s/20.0 - 1.0;
	tt = t/ 20.0 - 1.0;
	p1 = 10.0*p/500.0 - 1.0;

%*  compute groups of terms of increasing order */

	f0 = 0.92634;
	f1 = 0.09438*s1 + 0.60582*tt + 1.00774*p1;
	f2 = -0.00344*s1.^2 - 0.03884*tt.^2 + 0.07302*p1.^2 ...
 	     - 0.06639*s1.*tt + 0.08022*s1.*p1 +  ...
	     0.50438*tt.*p1;
	f3 = 0.01242*tt.^3 - 0.00825*p1.^3 + 0.00961*(s1.^2).*tt +  ...
	     0.01794*s1.*(tt.^2) - 0.01522 *s1.*(p1.^2);
	tmp = -0.032*(tt.^2).*p1 - 0.0901 *tt.*(p1.^2) - ...
	      0.05241* (s1.*tt).*p1;
	f3 = f3 + tmp;
	A = 0.01346*p1.^3 + 0.00984*(s1.^2).*p1 +0.01378*s1.*(p1.^2);
	
	B = 0.02155*p1.^2 +  0.01455*s1.*p1;
	C = 0.01061*p1 - tt*0.01368;
	f4= tt.*(A + tt.*(B + tt.*C));

	theta = t - (f0 + f1 + f2 + f3 + f4);
