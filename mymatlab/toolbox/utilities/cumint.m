function z=cumint(x,y)
%   Usage: z=cumint(x,y);
%     x=a vector of evenly spaced independent variables
%     y=a vector of dependent variables and the same length as x
%     z=a vector of the cumulative integral of y as a fcn of x
%   Function:
%     To calculate a cumulative integral using trapz.

n=length(x);
z=NaN*ones(size(x));

for i=1:n
  z(i)=trapz(x(1:i),y(1:i));
end
