function z = zofp(p);
%zofp: z=zofp(p) -  depth of z in m as a function of p for a std ocean. 
 
z0 = p .* 100;
n = 0; % number of iterations
dp = 1;
while (abs(dp) > 0.000005 & n < 20),
	n = n + 1;
	dpdz = 1.0076e-2 + (2 * 2.3484e-8) .* z0 ...
           - (3 * 1.2887e-11) .* z0.^2;
	p0 = pofz(z0);
	dp = p - p0;
	z = z0 + dp ./ dpdz;
end

 
