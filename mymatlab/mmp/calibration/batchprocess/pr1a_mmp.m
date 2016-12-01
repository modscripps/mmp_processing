function pr=pr1a_mmp(prV,calid)
% pr1_mmp
%   Usage: pr=pr1_mmp(prV,calid) 
%      prV is a vector array of pressure data in volts
%      cal:pr:<calid>.mat in the database has the polynomial
%         coefficients for converting from volts to MPa.
%      pr is  pressure in MPa
%   Function: Converts  mmp pressure data taken with Lucas
%      Schaevitz strain gauge to sea pressure in MPa.  Different
%      calid's can contain different order polynomial fits.
%      Same as pr1_mmp but without low-pass filtering.

% load array pf containing polynomial calibration coef
mmpfolders;

cal_str=['load ' setstr(39) mmpdatabase ':cal:pr:' calid '.mat' setstr(39)];
eval(cal_str)

% evaluate polynomial and subtract residual at p=0 from cal
pr=polyval(pf,prV)-1.247612293401895e-03;
