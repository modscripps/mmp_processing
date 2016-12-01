function[sal_time_avg,pr_sal_avg,yday_avg] = contour_sal(drops);
%	overall function: load processed salinity data for a range of drops, 
%	do some smoothing over different pressure values and over different
%	drops, and mesh and contour plot the results
%	inputs:  drops=range of drop numbers to be included
%	outputs: sal_avg=matrix of salinity values
%			 pr_sal_avg = pressure values for salinity values 
%			 yday_avg = average yday values used for time bins
%  Created 27 Aug 1996 by J. MacKinnon


% load processed salinity data and put into average pressure bins

for drop=drops
	[pr,t,salin]=salinity2_mmp(drop);
	for prindex=0:.005:.7;
		i=find((pr>=prindex-.005)&(pr<=prindex+.005));
		j=prindex*200 + 1;
		temp=salin(i);
		igood=find(~isnan(temp));
		temp=temp(igood);
		if (length(temp)~=0)
			sal(j)=sum(temp)/length(temp);		
		else
			sal(j)=NaN;
		end	
	end	
	sal=sal(:);
	sal_avg=[sal_avg,sal];
end

pr_sal_avg=0:.005:.7;

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
		for j=1:length(pr_sal_avg)
			temp=sal_avg(j,i);
			igood=find(~isnan(temp));
			temp=temp(igood);
			if length(temp)~=0
				sal_time_avg(j,ind)=sum(temp)/length(temp);
			else
				sal_time_avg(j,ind)=NaN;
			end		
		end
	else
		sal_time_avg(:,ind)=NaN*ones(length(pr_sal_avg),1);	
	end	
	ind=ind+1;
end		
yday_avg=min(yday):.01:max(yday);
size(yday_avg)
size(pr_sal_avg)
size(sal_time_avg)



%	make some plots

figure
mesh(yday_avg,pr_sal_avg,sal_time_avg)
view(0,90)
axis('ij')
xlabel('yday')
ylabel('pressure')


figure
extcontour(yday_avg,pr_sal_avg,sal_time_avg,'label');
axis('ij')
xlabel('yday')
ylabel('presure')
title('Salinity')
hold on;
plot(yday,zeros(size(yday)),'x');
hold off;

