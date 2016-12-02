function [evc,evl] = w4(l,f)
% [evc,evl] = window4(l,f)
%    Generate the window functions by Riedel and Sidorenko (1995)
%   By Ren-Chieh Lien, 1995

k = 2*l*f;
a = sqrt(2/(l+1));
for i=1:k;
    evc(:,i) = a * sin((i)*pi*(1:l)'/(l+1));
end
evl = sum(evc.^2);
evl = evl(:);
