function avg=rowavg(data,avglen) 
% rowavg 
%   Usage: avg=rowavg(data,avglen);
%      data is an array with data arranged in columns
%      avglen is the integer number of points to average along the rows
%   Function: average data in rows

[nrows,ncols]=size(data);

nout=fix(nrows/avglen);

if nout<1
	str=[' nrows= ' int2str(nrows) ' is too few for averaging over ' int2str(avglen) ' points'];
	error(str)
end

avg=NaN*ones(nout,ncols);

j=0;
for i=1:avglen:nout*avglen
	j=j+1;
	x=data(i:i+avglen-1,:);
	avg(j,:)=mean(x);
end
