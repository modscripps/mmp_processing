% plot_batchelor.m 
%   Function: Plot Batchelor's tgrad spectrum for chi=1e-8
%   and eps=1e-10 to 1e-10

kvis=1e-6;
ktemp=1.4e-7;
q=3.2;
chi=1e-8;

clf
epsilon=1e-10;
[k,P]=batchelor(epsilon,chi,kvis,ktemp,q);
loglog(k,P);

axis([.2 7e3 1e-8 1e-3])
hold on

for i=-9:-2;
	epsilon=10^i;
	[k,P]=batchelor(epsilon,chi,kvis,ktemp,q);
	loglog(k,P);
end

sxlabel('k / cpm'), sylabel('Ptgrad / (K/m)^2 cpm^{-1}')
title('Gradient Form of the Batchelor Universal Turbulent Temperature Spectrum')
hold off

