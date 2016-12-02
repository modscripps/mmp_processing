function y=acosh(x)
%  Usage: y=acosh(x);
%      x is a vector of real values > 1;
%      y is a vector of outputs
%  Function:
%      to compute the inverse hyperbolic cosine

j=find(x<=1);
n=length(j);
y=NaN*ones(size(x));

if n>0
	str=['acosh: ' int2str(n) ' input values <= 1 are returned as NaNs'];
	disp(str)
end

i=find(x>1);
y(i)=log(x(i)+sqrt(x(i).^2 -1));
