function [prlb,prub]=pr_windows(p);
% Usage: [prlb,prub]=pr_windows(p);
%  p: vector of sequential pressures
%  prlb, prub: vectors of upper and lower bounds of p sequence
% Function: Calculates the upper and lower bounds of data
%  windows centered on p.  For example, using pr_eps to
%  determine the pressure window over which epsilon was averaged.
%  For p=(1:5), prlb=(0.5:4.5) and prub=(1.5:5.5);
% M.Gregg, 15sep96

p=p(:);
n=length(p);

dp0=(p(2)-p(1))/2;
dp=diff(p)/2;
dpn=(p(n)-p(n-1))/2;

prlb=[p(1)-dp0; p(2:n)-dp];
prub=[p(1:n-1)+dp; p(n)+dpn];
