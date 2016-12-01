function c = csbe_cal_mmp(f,p,t,drop)
% csbe_cal_mmp:
%   Usage: c=csbe_cal_mmp(f,p,t,drop), where f is an array with
%      Sea Bird cond. in freq., p  for SBE sensor on mmp
% 	   f in kHz, p in MPa,  t in deg C., drop no. as integer
%   Function: converts csbe from Hz to S/m.	

cal = [1.18828817e-3 5.38355432e-1 -4.13529688  ...
      -9.89470585e-4 2.8];

c1 = cal(1).*f.^cal(5) + cal(2) .* f.^2 + cal(3)  + cal(4) .* t;
c2 = 10 .* (1 - 9.57e-6 .* p);
	
c = c1 ./ c2;
