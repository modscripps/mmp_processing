function y = hBessel4(f,fc)  
% Power transfer function of the 4-pole bessel filter with 3db pt at fc.

b0=105;
b1=105;
b2=45;
b3=10;
b4=1;
	
c = 2.115/fc;
x = f';
den1 = b0 - b2 .* (c^2 .* x.^2) + b4 .* (c^4 .* x.^4);
den2 = b1 .* (c .* x) - b3 .* (c^3 .* x.^3);
y = (b0 * b0) ./ (den1 .* den1 + den2 .* den2);

