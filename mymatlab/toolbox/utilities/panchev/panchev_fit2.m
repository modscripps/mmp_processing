% panchev_fit2
%   Usage: panchev_fit2
%   Function: integrate Panchev shear spectrum for transverse
%      velocities from 2 to 10 cpm and fit with polynomial.l
%      Save output in array pf, which is used to make first 
%      epsilon estimate by integrating observed shear spectra
%      from 2 to 10 cpm.  Script also makes plots of functions
%      and residuals.

clear
clf
epsilon=logspace(-10,0,20);
kvis=(1e-6:.2e-6:1.6e-6);

shear10=NaN*ones(length(epsilon),length(kvis));
sheartotal=NaN*ones(length(epsilon),length(kvis));

for i=1:length(epsilon)
	for j=1:length(kvis)
		[k,P]=panchev2(epsilon(i),kvis(j));
		dk=mean(diff(k));
		shear10(i,j)=dk*sum(P);
		sheartotal(i,j)=epsilon(i)/(7.5*kvis(j));
	end
end

% take log10 of both arrays
ls10=log10(shear10);
lst=log10(sheartotal);

% fit 4th order polynomial to log10(sheartotal) as fcn of
% log10(shear10)
shtotal_fit_shear10=polyfit(ls10,lst,4);
save shtotal_fit_shear10.mat shtotal_fit_shear10
f=polyval(shtotal_fit_shear10,ls10);

plot(lst,ls10,'o')
ylabel('log10(integral Panchev shear spectrum from 2 - 10 cpm)')
xlabel('log10(epsilon/7.5 nu)')
hold on
loglog(f,ls10)
hold off

% fit 4th order polynomial to log10(epsilon) as fcn of
% log10(shear10)
e=log10(epsilon'*ones(1,4));
eps_fit_shear10=polyfit(ls10,e,4);
save eps_fit_shear10.mat eps_fit_shear10
g=polyval(eps_fit_shear10,ls10);

figure
plot(log10(epsilon),ls10,'o')
xlabel('log10(epsilon)'),ylabel('log10(shear10)')
hold on
plot(g,ls10)
