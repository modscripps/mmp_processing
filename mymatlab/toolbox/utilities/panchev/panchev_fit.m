% panchev_fit
%   Usage: panchev_fit
%   Function: integrate Panchev shear spectrum for transverse
%      velocities from 2 to 10 cpm and fit with polynomial.l
%      Save output in array pf, which is used to make first 
%      epsilon estimate by integrating observed shear spectra
%      from 2 to 10 cpm.  Script also makes plots of functions
%      and residuals.

clear
clf
epsilon=logspace(-11,0,22);
kvis=(1e-6:.2e-6:1.6e-6);

shear_integral=NaN*ones(length(epsilon),length(kvis));
PhiSk=NaN*ones(length(epsilon),length(kvis));
residual=NaN*ones(length(epsilon),length(kvis));

for i=1:length(epsilon)
	for j=1:length(kvis)
		[k,P]=panchev2(epsilon(i),kvis(j));
		dk=mean(diff(k));
		shear_integral(i,j)=dk*sum(P);
		PhiSk(i,j)=(epsilon(i)^3/kvis(j))^0.25;
	end
end

% take log10 of both arrays
ls=log10(shear_integral);
lP=log10(PhiSk);

% fit 4th order polynomial and evaluate
pf=polyfit(ls,lP,4);
f=polyval(pf,ls);
residual=lP-f;

figure
plot(ls,lP,'o',ls,f,'-')
xlabel('log10(integral Panchev spectrum from 2 - 10 cpm)')
ylabel('log10(epsilon^3/kvis)^1/4)')
title('output of panchev_fit')
text(-6.5,1,'epsilon=1e-11 to 1e-1 & kvis=1e-6 to 1.6e-6')


figure
plot(ls,residual,'o')
xlabel('log10(integral Panchev spectrum from 2 - 10 cpm)')
ylabel('fit residuals')
title('output of panchev_fit')
text(-6.5,1,'epsilon=1e-11 to 1e-1 & kvis=1e-6 to 1.6e-6')
		
