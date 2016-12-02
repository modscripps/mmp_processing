function y = haf_oakey(f,w)
% haf_oakey
%   Usage: y = haf_oakey(f,w)
%	   f is frequency in a column vector, 
%      w is the fall rate
%   Function: Power transfer function of airfoil probe according
%   to Oakey

lc=0.02;
y = 1 ./ (1 + (lc .* (f' / w) ).^2 );
y=y';
