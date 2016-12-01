function[sgth_time_avg,pr_sgth_avg,yday_avg] = contour_sgth(drops)
%	overall function: load processed sigma(theta) data for a range of drops, 
%	do some smoothing over different pressure values and over different
%	drops, and mesh and contour plot the results
%	inputs:  drops=range of drop numbers to be included
%	outputs: sgth_avg=matrix of epsilon values
%			 pr_sgth_avg = pressure values for epsilon values 
%			 yday_avg = average yday values used for time bins
%  Created 23 Aug 1996 by J. MacKinnon


% load processed sgima-theta data and put into average pressure bins


for drop=drops
	[sigma,pr]=get_sigmath_mmp(drop);
	for prindex=0:.005:.7;
		i=find((pr>=prindex-.005)&(pr<=prindex+.005));
		j=prindex*200 + 1;
		temp=sigma(i);
		igood=find(~isnan(temp));
		temp=temp(igood);
		if (length(temp)~=0)
			sgth(j)=sum(temp)/length(temp);		
		else
			sgth(j)=NaN;
		end	
	end	
	sgth=sgth(:);
	sgth_avg=[sgth_avg,sgth];
end

pr_sgth_avg=0:.005:.7;


%  Convert from drop # to yday values


dataloc=['deimos2:mmp:cmo96:mmplog.mat'];
str1=['load ' setstr(39) dataloc setstr(39) ];
eval(str1);
for drop=drops
	iday=[iday;find(mmplog==drop)];
end
yday=mmplog(iday,3);	


%	Average over time bins

ind=1;
for dayindex=min(yday):.01:max(yday)
	i=find((yday>dayindex-.01)&(yday<dayindex+.01));
	if length(i)~=0
		for j=1:length(pr_sgth_avg)
			temp=sgth_avg(j,i);
			igood=find(~isnan(temp));
			temp=temp(igood);
			if length(temp)~=0
				sgth_time_avg(j,ind)=sum(temp)/length(temp);
			else
				sgth_time_avg(j,ind)=NaN;
			end		
		end
	else
		sgth_time_avg(:,ind)=NaN*ones(length(pr_sgth_avg),1);	
	end	
	ind=ind+1
end		
yday_avg=min(yday):.01:max(yday);
size(yday_avg)
size(pr_sgth_avg)
size(sgth_time_avg)



%	make some plots

figure
mesh(yday_avg,pr_sgth_avg,sgth_time_avg)
view(0,90)
axis('ij')
xlabel('yday')
ylabel('pressure')


figure
extcontour(yday_avg,pr_sgth_avg,sgth_time_avg,'label');
axis('ij')
xlabel('yday')
ylabel('presure')
title('Sigma-theta')
hold on;
plot(yday,zeros(size(yday)),'x');
hold off;








