function T = tempsbe(f).m
% tempwbo(f).m - compute temperature of Sea-Bird probe as a 
% 	function of frequency.

cal = [3.68104711e-3 6.01090425e-4 1.53053484e-5  ...
      2.29900585e-6 6170.48];

fprintf(1,'%g\t',cal(5));  
	  
x= log(cal(5) ./ f);

fprintf(1,'%g\t', x);

c = cal(1) + cal(2) .* x + cal(3) .* x.^2 + cal(4) .* x.^3;
	
T = 1 ./ c - 273.15;
