function cev=epsilon_correct(epsilon,kvis,kc)
% correps
%   Usage: cev=epsilon_correct(epsilon,kvis,k)
%      epsilon is the dissipation rate in W/kg
%      kvis is the kinematic viscosity in m^2/s
%      kc is cut-off wavenumber in cpm
%      cev is the multiplicative factor for correcting epsilon   
%   Function: correct high eps for probe attenuation.  The
%      algorithm is described in the appendix to Wesson and Gregg
%      (1994), JGR, 99, 9847-9878, and is accurate to 2% for 
%      log(k/ks) in [-5,0].  

A0=51.98815;	B0=0.6654175;
A1=50.77240;	B1=1.542088;
A2=17.647112;	B2=1.340238;
A3=2.545768;	B3=0.527434;
A4=0.132784;	B4=0.081875;

ks= epsilon^(.25) * kvis^(-.75);
lk=log(kc/ks);

if lk <= -4.536   % severe underestimates only
 	cev = 30.703;
elseif lk >= -1.455
 	cev = 1.0;
elseif lk > -4.536 & lk < -3.0
 	cev = exp( A0 + lk*(A1 + lk*(A2 + lk*(A3 + lk*A4))));
elseif lk >= -3.0 & lk < -1.455
 	cev = exp( B0 + lk*(B1 + lk*(B2 + lk*(B3 + lk*B4))));
end
