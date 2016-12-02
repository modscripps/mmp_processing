function gamma=gammab(s,t,p);
% gammab
%   Usage: 
%     inputs
%      s is a vector of salinities in c.u., e.g. .035
%      t is a vector of temperatures in deg C
%      p is a vector of pressures in MPa
%     output
%      gamma is the adiabatic lapse rate in deg C / MPa
%   Function: to evaluate the lapse rate given by Bryden (1973)
%      Deep-Sea Res., 20, 401--409.
%   Range: 0.03 <= s <- 0.04, -2 <= t <= 30, 0 <= p <= 100
%   Check value: gammab(0.025,10,100)=0.020687417 deg C / MPa
%   M. Gregg, May 25, 1995, adapted from C version.   

ss=s-.035;

% each set of coef arranged in descending powers of t
A00k=[6.6228e-08  -6.8360e-06   8.5258e-04   3.5803e-03];
A01k=[-4.2393e-03   1.8932e-01];
A10k=[-5.4481e-10   8.7330e-08  -6.7795e-06   1.8741e-04];
A11k=[2.7759e-05  -1.1351e-03];
A20k=[-2.1687e-10   1.8676e-08  -4.6206e-07];

gamma=polyval(A00k,t) + ss.*polyval(A01k,t) + ...
 p.*(polyval(A10k,t) + ss.*polyval(A11k,t) + p.*polyval(A20k,t));
