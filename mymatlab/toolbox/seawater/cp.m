function specific_heat=cp(s,t)
%cp:  cp=cp(s,t) - Specific heat at cst. pressure
%check values:            cp(0.040,40.0) = 3981.05
%                                 cp(0.035,15.0) = 3989.87
%(see cp.c for further details)

s=1000.*s;  % to ppt

% cp of fresh water
cp0= 4.2174 + t.*( -3.720283*10^(-3) + t.*(1.412855*10^(-4) + t ...
.*(-2.654387*10^(-6) + t.*2.093236*10^(-8) )));

%salinity correction
acp=-7.644e-3 + t.*(1.0727*10^(-4) - t.*1.38*10^(-6));
bcp=1.77e-4 + t.*(-4.08*10^(-6) + t.*5.35*10^(-8));
temp = cp0 + acp.*s + bcp.*s.*sqrt(s);

specific_heat=1000*temp;
