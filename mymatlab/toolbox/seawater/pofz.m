function p = pofz(z);
%pofz; p=pofz(z) - p as a function of z for the world ocean 
%from J. Reid, personal communication

p = 1.0076e-2 .* z + 2.3484e-8 .* z.^2 - 1.2887e-11 .* z.^3;

