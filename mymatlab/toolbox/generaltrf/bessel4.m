function [hsq,phi]=bessel(f,f3db)
% bessel4
%   Usage: 
%      [hsq,phi]=bessel4(f,f3db)
%         f is a column vector of frequences
%         f3b is the 3db frequency
%         hsq is the amplitude-squared response
%         phi is the phase response, in radians
%   Function: compute 4-pole low-pass Bessel filter

b0=105;
b1=105;
b2=45;
b3=10;
b4=1;

c=2.115/f3db;

hsq = b0^2 ./ ( (b0 - b2 * c^2 .* f.^2 + b4 * c^4 .* f.^4).^2 ...
               + (b1*c.*f - b3*c^3.*f.^3).^2);
phi = atan(-(b1*c.*f-b3*c^3.^f.^3) ...
            ./ (b0-b2*c^2.*f.^2 + b4*c^4.*f.^4));
