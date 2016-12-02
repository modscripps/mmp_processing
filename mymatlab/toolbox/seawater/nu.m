function y = nu(s,t,p)
%nu: kvis=nu(s,t,p) - kinematic viscosity
%  Inputs: s: salinity, in concentration units or psu
%          t: temperature, in deg C
%          p: pressure, in MPa
%  Output: y: kinematic viscosity in m^2/s
%
%	Check value	:	mu (.02891, 30) = 8.499e-4
%	check values	:	nu (0.035, 15.0, 0.0) = 1.19343e-6
%				nu (0.040, 40.0, 100.0) = 6.13058e-7

% M.Gregg: modified 21dec96

% make all inputs into column vectors and check lengths
s=s(:); t=t(:); p=p(:);
if (length(s)~= length(t)) | (length(t)~=length(p))
  disp('nu: inputs must be same length')
end

% check salinity magnitude
ig=find(~isnan(s));
s_avg=mean(s);
if s_avg > 1
  s=s/1000;
  disp('nu: input s vector > 1, divided by 1000 to compute nu')
end
 
mu = (1.779e-3 - t.*(5.9319e-5 - t.*(1.2917e-6 - t * 1.3402e-8))) ...
      + s.*(2.8782e-3 - t.*(3.0553e-6 + t * 1.1835e-6));
rho = density(s,t,p);
y = mu./rho; 
