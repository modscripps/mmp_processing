function beta=beta_t1_1_mmp(tref,tl1V,Gtl,E1)
% beta_t2_1_mmp(tref,tl1V)
%   Usage: beta=beta_t1_1_mmp(tref,tl1V)
%      tref is column array of temps at cntrs of chi windows
%      tl1V is column array of meas voltages at cntrs of chi windows
%      Gtl is the gain of the tl circuit
%      E1 is an intermediate gain in the tl circuit
%   Function: calculates array of beta values using circuit
%      parameters for tl circuit in case t1, mod1
% Revised to set zeros of diff(tref) to NaNs before dividing
%   mgregg, 3mar98

% calculate beta=dET/dtreg, the change in voltage across the thermistor per deg C
ET=(tl1V+E1)./ Gtl; % voltage across thermistor
ETfit=polyfit(tref,ET,2);
ETcalc=polyval(ETfit,tref);
residual = ETcalc - ET;
str=['  rms residual to tl1V fit = ' num2str(std(residual)) ' volt'];
disp(str)

d_tref=diff(tref);
iz=find(d_tref==0);
if ~isempty(iz)
   d_tref(iz)=NaN*ones(size(iz));
end
beta=diff(ETcalc) ./ d_tref;
beta=[beta(1), beta(1:length(beta))']; % duplicate the first value
beta=beta';
