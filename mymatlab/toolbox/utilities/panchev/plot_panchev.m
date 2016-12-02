%plot_panchev.m  Plot the full range of universal turbulent
%spectra.

nu=1e-6;

clf
epsilon=1e-10;
[k,P]=panchev(epsilon,nu);
loglog(k,P);

axis([.2 2e3 1e-9 1e1])
hold on

for i=-9:-2;
	epsilon=10^i;
	[k,P]=panchev(epsilon,nu);
	loglog(k,P);
end

xlabel('k3 / cpm'), ylabel('Pshear / s^-2 cpm^-1')
title('Universal turbulent shear spectra')
text(.8,5e-7,'epsilon=10^-10');
text(70,.7,'epsilon=10^-2');
hold off
