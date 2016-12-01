function[epsilon_avg,pr_eps_avg,yday_avg] = contour_eps(drops)
%	overall function: load processed epsilon data for a range of drops, 
%	do some smoothing over different pressure values and over different
%	drops, and mesh and contour plot the results
%	inputs:  drops=range of drop numbers to be included
%	outputs: epsilon_avg=matrix of epsilon values
%			 pr_eps_avg = pressure values for epsilon values 
%			 yday_avg = average yday values used for time bins
%  Created 23 Aug 1996 by J. MacKinnon


% load processed epsilon data and put into average pressure bins

eps=1:36;

for drop=drops
	[epsilon,pr]=get_epsilon1_mmp(drop);
	for prindex=0:.02:.7;
		i=find((pr>=prindex-.03)&(pr<=prindex+.03));
		j=prindex*50 + 1;
		temp=epsilon(i);
		igood=find(~isnan(temp));
		temp=temp(igood);
		if (length(temp)~=0)
			eps(j)=sum(temp)/length(temp);
		else
			eps(j)=NaN;
		end	
	end	
	eps=eps(:);
	epsilon_avg=[epsilon_avg,eps];
end

epsilon_avg=log10(epsilon_avg);
epsilon_avg=real(epsilon_avg);

pr_eps_avg=0:.02:.7;


%  Convert from drop # to yday values


dataloc=['deimos2:mmp:cmo96:mmplog.mat'];
str1=['load ' setstr(39) dataloc setstr(39) ];
eval(str1)
for drop=drops
	iday=[iday;find(mmplog==drop)];
end
yday=mmplog(iday,3);	

%	Average over time bins

ind=1;
for dayindex=min(yday):.01:max(yday)
	% i=find((yday>dayindex-.02)&(yday<dayindex+.02));
	i=find((yday>dayindex-.01)&(yday<dayindex+.01));

	if length(i)~=0
		for j=1:length(pr_eps_avg)
			temp=epsilon_avg(j,i);
			igood=find(~isnan(temp));
			temp=temp(igood);
			if length(temp)~=0
				epsilon_time_avg(j,ind)=sum(temp)/length(temp);
			else
				epsilon_time_avg(j,ind)=NaN;
			end		
		end
	else
		epsilon_time_avg(:,ind)=NaN*ones(length(pr_eps_avg),1);	
	end	
	ind=ind+1;
end		
yday_avg=min(yday):.01:max(yday);

%	make some plots

figure
mesh(yday_avg,pr_eps_avg,epsilon_time_avg)
axis('ij')
xlabel('yday')
ylabel('pressure')

figure
extcontour(yday_avg,pr_eps_avg,epsilon_time_avg,'label');
axis('ij')
xlabel('yday')
ylabel('presure')
title('Epsilon')

hold on;
plot(yday,zeros(size(yday)),'x');
hold off;










