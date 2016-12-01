%   ComputeEpsilon_chi.m
%   MMH 9/6/2015
%   compute epsilon based on previously computed chi
%   requires variables salinity (cu), temp (degrees C), and pr_thetasd (MPa
%   in order to compute stratification and temperature gradient
%   requires pr_chi in order to map these to the chi grid
%   Mixing efficiency is assumed to be 0.2
%
%   compute n2 and dTdz using mgregg's nsqfcn function
%   NOTE: uses Mike units (MPa and c.u., so if the nsqfcn function has been
%   changed, this needs to be addressed)
dz_1 = 2;
idg = find(~isnan(salinity) & ~isnan(temp) & ~isnan(pr_thetasd));
[n2_1, pout_1,dthethadp_1,~] = nsqfcn(salinity(idg),temp(idg),pr_thetasd(idg),dz_1/100,dz_1/100);

dz2 = 5;
[n2_1, pout_1,dthethadp_1,~] = nsqfcn(salinity(idg),temp(idg),pr_thetasd(idg),dz_2/100,dz_2/100);
%   convert dp in MPa to dz
dthetadz = dthetadp/100;

%interpolate onto grid
n2 = abs(nonmoninterp1(pout,n2,pr_chi));
dthetadz = abs(nonmoninterp1(pout,dthetadz,pr_chi));

gamma = 0.2;    %Assumed mixing efficiency
for ii = 1:size(chi,2)
    eps_chi(:,ii) = n2.*chi(:,ii)./(2*gamma.*dthetadz);
end

clear idg dz_bfrq