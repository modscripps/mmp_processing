function [xout,yout]=xy_expand(xl,xu,y,ybase)
% Usage: [xout,yout]=xy_expand(xl,xu,y,ybase);
%  inputs
%    xl, xu: vectors of lower & upper bounds of the independent
%      varible, e.g. pressure
%    y: vector of the dependent variable, with the same
%      dimension as xl & xu
%    ybase: Minimum value of y, for use in plotting
% Function: To expand input vectors representing an input 
%  vector, y, that has been averaged between lower, xl, and 
%  upper, yl, limits of the independent variable, x.  Needed
%  for plotting, the expansion is need to plot the averages.
%  Both output vectors are 4 times as long as the input
%  vectors.  The sequence for xout is xl(1) xl(1) xu(1) xu(1) 
%  xl(2) xl(2) ... .  The sequence for yout is ybase y(1) y(1)
%  ybase ybase y(2) ... .
% M.Gregg, 15dec96

npts=length(xl);
xout=NaN*ones(4*npts,1); yout=NaN*ones(4*npts,1); 

i=1:npts;
xout(4*(i-1)+1)=xl(i); 
xout(4*(i-1)+2)=xl(i);
xout(4*(i-1)+3)=xu(i); 
xout(4*(i-1)+4)=xu(i); 
yout(4*(i-1)+1)=ybase*ones(npts,1);
yout(4*(i-1)+2)=y(i);
yout(4*(i-1)+3)=y(i);
yout(4*(i-1)+4)=ybase*ones(npts,1);
