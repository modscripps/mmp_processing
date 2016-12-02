function c=fgenfit(func,x,y)
% Usage: c=fgenfit(func,x,y)
%  inputs: 
%    func: string name of the function to be evaluated
%    x: row vector of independent variables
%    y: row vector of dependent variables
%  output:
%    c: a vector of fit coefficients
% Function: To do a least squares fit to an arbitrary function.
%  Code from page 258 of "Numerical Methods Using Matlab" by
%  Lindfield & Penny, Ellis Horwood, New York 1995

% Function:
if any(size(x)~=size(y))
  disp('x and y vectors must be the same size')
end
n=length(y);
[p,junk]=feval(func,x(1));
A=zeros(p,p); b=zeros(p,1);
for i=1:n
  [junk,f]=feval(func,x(i));
  for j=1:p
    for k=1:p
	  A(j,k)=A(j,k)+f(j)*f(k);
	end
    b(j)=b(j)+y(i)*f(j);
  end
end
c=A\b;
