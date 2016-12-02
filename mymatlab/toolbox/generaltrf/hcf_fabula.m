function Hsq=hcf_fabula(f,w,D)
% hcf_fabula
%   Usage: h=hcf_fabula(f,w,D);
%      f is a vector of frequencies
%      w is speed in m/s
%      D is the thermal diffusivity
%      Hsq is the amplitude-squared response

Delta=(.0023*D)^0.5 * (w/1.7)^(-.32);

H=exp(-Delta .* (f.*(pi/D)).^(0.5) );
Hsq=H.*H;
