function rho = density(s,t,p)
% density
%   Usage: rho = density(s,t,p)
%      s is salinity in concentration units
%      t is temperature in deg C
%      p is sea pressure in MPa
%      rho is density in kg/m^3
%
%
%	Coded from: Landolt-Bornstein,
%	"Numerical Data and Fundamental Relationships in Science
%	and Technology, New Series V/3a, Oceanography", pp 238-239.
%
%	Check Values:
%	Inputs:
%		S = .040 CU
%		T = 40 deg C
%		P = 100 MPa
%
%	Outputs:
%
%		Intermediate Values:
%
%		Bw   = -7.536450e-6 dbar^-1
%		A    =  3.446154
%		B    = -2.311202e-6 dbar^-1
%		A    =  3.465376
%		Kw   =  2.260440e5 dbar
%		K0   =  2.434421e5 dbar
%		K    =  2.778648e5 dbar
%
%		Return Values:
%
%		rhow = rho(0, T, 0)
%		rho0 = rho(S, T, 0)
%
%		rhow =  992.2204 kg m^-3
%		rho0 = 1021.6788 kg m^-3
%		rho  =  1059.8204 kg m^-3
%
% 
%------------------------------------------------------------------------------

	s = s*1000;	
	p = p*100;	

	t2 = t.*t;
	t3 = t2.*t;
	t4 = t3.*t;
	t5 = t4.*t;

	s2 = s.*s;
	s32 = s.*sqrt(s);
	rhow = 999.842594 + 6.793952e-2*t - 9.095290e-3*t2 +  ... 
	       1.001685e-4*t3 -1.120083e-6*t4 + 6.536332e-9*t5;

	A1 = 8.24493e-1 - 4.0899e-3*t + 7.6438e-5*t2 -8.2467e-7*t3 +  ...
	    5.3875e-9*t4;
	rho0 = rhow+(A1.*s) ...
	       + (-5.72466e-3 + 1.0227e-4*t - 1.6546e-6*t2).*s32 ...
	       + 4.8314e-4*s2;

	if (p < 0) 
	   !echo out of sea water
	   return
	end
	Kw = 1.965221e5 + 1484.206*t - 23.27105*t2 + 1.360477e-1*t3 ...
	     -5.155288e-4*t4;
	Aw = 3.239908 + 1.43713e-3*t + 1.16092e-4*t2 - 5.77905e-7*t3;
	Bw = 8.50935e-6 - 6.12293e-7*t + 5.2787e-9*t2;

	K0 = Kw+(546.746 - 6.03459*t + 1.09987e-1*t2 - 6.1670e-4*t3).*s ...
	        + (7.944e-1 + 1.6483e-1*t - 5.3009e-3*t2).*s32;
	A = Aw + (2.2838e-3 - 1.0981e-5*t -1.6078e-6*t2).*s ...
	       + 1.91075e-4*s32;
	B = Bw + (-9.9348e-8 +  2.0816e-9*t + 9.1697e-11*t2).*s;

	K = K0 + A.*p + B.*(p.*p);

	rho = rho0./(1.0-p./K);
