% panchev_fit3
%   Usage: panchev_fit3
%   Function: integrate Panchev shear spectrum for transverse
%      velocities from 1 to 100 cpm and plot.  Epsilon resolved
%      between 1 and 100 cpm is plotted along the x axis and
%      the ratio of epsilon to the resolved epsilon is along
%      the y axis.

clear
clf
epsilon=logspace(-10,0,20);
kvis=(1e-6:.2e-6:1.6e-6);

eps_resolved=NaN*ones(length(epsilon),length(kvis));
f=NaN*ones(length(epsilon),length(kvis));

for i=1:length(epsilon)
	for j=1:length(kvis)
		[k,P]=panchev(epsilon(i),kvis(j));
		dk=mean(diff(k));
		i_k=find(k>=1 & k<=100);
		eps_resolved(i,j)=7.5*kvis(j)*dk*sum(P(i_k));
		f(i,j)=epsilon(i)/eps_resolved(i,j);
	end
end

loglog(eps_resolved,f,'o')
xlabel('epsilon obtained between 1 and 100 cpm')
ylabel('epsilon/(epsilon between 1-100 cpm)')
