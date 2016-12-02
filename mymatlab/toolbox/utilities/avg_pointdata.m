function [xout,davg,npts]=avg_pointdata(data,x,x_lower,dx,x_upper,lb,ub);
% avg_pointdata
%   Usage: [xout,davg,npts]=avg_pointdata(data,x,x_lower,dx,x_upper,lb,ub);
%     input
%      data is the data vector to be averaged
%      x is a vector the same length as data.  It contains data positions
%         e.g. for ocean profiles x would be pressure or time
%      x_lower is the lower bound for averaging
%      x_upper is the upper bound for averaging
%      lb is 'o'  for open (x_lower excluded) or 'c' for closed (x_lower
%         included) lower bounds.  Default is 'o'.
%      ub is 'o' for open (x_lower excluded) or 'c' for closed (x_lower
%         included) lower bounds.  Default is 'c'.
%      dx is the size of averaging intervals
%     output
%      xout is position at the centers of the averaging windows
%      davg is the averaged data
%      npts is the number of points used to compute the average.
%   Function: bin-average data that are point samples, i.e. the data
%      are not averages over a range of x.  Examples are temperature
%      and salinity. 
%         Bins are centered at (x_lower+dx/2) + i dx.
%	  NOTE: in general one bound should be open and the other closed.

% check that data and x are vectors of the same length
[rd,cd]=size(data); [rx,cx]=size(x);
if rd > 1 & cd > 1
	error('data is an array, not a vector')
elseif rx > 1 & cx > 1
	error('x is an array, not a vector')
elseif length(data)~=length(x) 
	error('data and x vectors are not same length')
end

% insure that input vectors are column vectors
data(:); x(:);

if nargin<6 lb='o'; end;
if nargin<7 ub='c'; end;

% set up output vectors
xout=[x_lower+dx/2: dx : x_upper-dx/2]; xout=xout(:);
nout=length(xout);
davg=NaN*ones(nout,1); npts=zeros(nout,1);

% average data and determine the number of pts per average
for i=1:nout
	% find indices of x values in the ith bin
 	if strcmp(lb,'o') & strcmp(ub,'c')
     ix=find(x>xout(i)-dx/2 & x<=xout(i)+dx/2);
	elseif strcmp(lb,'c') & strcmp(ub,'o')
	   ix=find(x>=xout(i)-dx/2 & x<xout(i)+dx/2);
	elseif strcmp(lb,'c') & strcmp(ub,'c')
	   ix=find(x>=xout(i)-dx/2 & x<=xout(i)+dx/2);
	else 
	   ix=find(x>xout(i)-dx/2 & x<xout(i)+dx/2);
	end

	ixd=find(~isnan(data(ix))); % ix indices not NaNs
	if ~isempty(ixd)
	  davg(i)=mean(data(ix(ixd)));
	  npts(i)=length(ixd);
	end
end
