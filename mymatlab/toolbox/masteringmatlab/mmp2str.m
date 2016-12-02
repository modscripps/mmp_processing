function s=mmp2str(p,v,ff)
%MMP2STR Polynomial Vector to String Conversion.
% MMP2STR(P) converts the polynomial vector P into string representation.
% For example: P = [2 3 4] becomes the string '2s^2 + 3s + 4'
%
% MMP2STR(P,V) generates the string using the variable V as the parameter
% instead of s. MMP2STR([2 3 4],'z') becomes '2z^2 + 3z + 4'
%
% MMP2STR(P,V,1) factors the polynomial into the product of a constant and
% a monic polynomial. MMP2STR([2 3 4],[],1) becomes '2(s^2 + 1.5s + 2)'

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/4/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

if nargin<3,ff=0;end
if nargin<2,v='s';end
if isempty(v),v='s';end
v=v(1);
p=mmpsim(p);n=length(p);
if ff		% put in factored form
	K=p(1);Ka=abs(K);p=p/K;
	if abs(K-1)<1e-4
 		pp=[];pe=[];
	elseif abs(K+1)<1e-4
		pp='-(';pe=')';
	elseif abs(Ka-round(Ka))<=1e-5*Ka
		pp=[sprintf('%.0f',K) '*('];pe=')';
	else
 	pp=[sprintf('%.4g',K) '*('];pe=')';
	end
else		% not factored form
	K=p(1);pp=sprintf('%.4g',K);pe=[];
end
if n==1,s=sprintf('%.4g',K);return,end
s=[pp v '^' sprintf('%.0f ',n-1)];
for i=2:n-1
 if p(i)<0,pm='- ';else,pm='+ ';end
 if p(i)==1,pp=[];else,pp=sprintf('%.4g',abs(p(i)));end
 if p(i)~=0,s=[s pm pp v '^' sprintf('%.0f ',n-i)];end
end
if p(n)~=0,pp=sprintf('%.4g',abs(p(n)));else,pp=[];end
if p(n)<0,pm='- ';elseif p(n)>0,pm='+ ';else,pm=[];end
s=[s pm pp pe];
