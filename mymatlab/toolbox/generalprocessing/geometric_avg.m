function [y,npts]=geometric_avg(x,n)
% Usage: [y,npts]=geometric_avg(x,n);
%   x is a data vector
%   n is an integer such that 2^n is the maximum number of points to average
%   y is a vector containing the average of x
%   npts contains the number of x values averaged into each y
% Function: to geometrically average a data vector to some maximum size
%   of averaging window and then to average uniformly
% M.Gregg, 18oct95 

sx=size(x);
if sx(1)>1 & sx(2)>1
  error('x is a matrix; geometric_avg is only for vectors')
end

n_x=length(x);

% apply exponential averaging until power of 2 equals n or x has no more pts
k=0; % exponent of 2 for averaging
l=0; % index of y and npts arrays
last_x=0; % last x value included in averages
while k<=n & last_x+2^k < n_x
  first_x=2^k;
  last_x=first_x + 2^k -1;
  l=l+1;
  y(l)=mean(x(first_x:last_x));
  npts(l)=2^k;
  k=k+1;
end

% average remaining pts in blocks of 2^n
navg=2^n;
n_more_x=floor((n_x-last_x)/navg);
y=[y zeros(1,n_more_x)]; 
npts=[npts navg*ones(1,n_more_x)];
for k=1:n_more_x
  first_x=last_x+1; 
  last_x=first_x+navg-1;
  l=l+1;
  y(l)=mean(x(first_x:last_x));
end

