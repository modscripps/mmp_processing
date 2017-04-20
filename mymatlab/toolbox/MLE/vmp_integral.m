function y = vmp_integral(P,k,kmin,kmax)

% y = vmp_integral(P,k,kmin,kmax)
%
% Integrate spectrum (or function) in specified wavenumber range.
%
% Integrates the spectrum P in the frequency (or wavenumber) space k
% between kmin and kmax. Uses trapezoidal integration. 
%
% Usage: y = integral(P,k,k1,k2);
%
% Input parameters:
%   P     Spectrum or signal to be integrated
%   k     Abscissa vector for which P is defined, i.e., P=P(k)
%   k1    Lower integration limit
%   k2    Upper integration limit
%
% Ouput parameters:
%   y     Value of the integral

% (C) 2002 Rockland Oceanographic Services Inc.
% Author: Fabian Wolk
% Revision: 2002/08/01
%
% Modified G. Carter  Dec-2010
% Now interpolates the end points so that integrating in sections  and
% summing gives the same answer as integrating the whole. Also modified to
% work on matrices and well as vectors.

error(nargchk(2,4,nargin));
if nargin == 2
   y = trapz(k,P);
   return
end
if ~exist('kmax','var') || isempty(kmax)
   kmax = max(k);
end
if ~exist('kmin','var') || isempty(kmin)
   kmin = 0;
end
if size(P,1) ~= length(k)
   error('P and k must have same number of rows.');
end

Nk = length(k);

% the integration range
dk = kmax-kmin;
if dk<=0,
   warning('vmp_integral: kmax must be strictly greater than kmin')
   y = 0;
   return
end

% integration range must straddle at least one point k vector
if (kmin > k(Nk) || kmax < k(1)),
   warning('Integration limits are out of range');
   y = zeros(size(P,1));
   return;
end

if Nk == 1; % there is only one point in the vector and it is within dk
   y = P(1,:)*dk;
else
   index = find(k>=kmin & k<=kmax);
   if kmin < k(1)
       kmin = k(1);
   end
   if kmax > k(Nk)
       kmax = k(Nk);
   end
   P1 = interp1(k,P,kmin,'linear');
   P2 = interp1(k,P,kmax,'linear');
   k = [kmin; k(index); kmax];
   P = [P1; P(index,:); P2];
   % check that kmin or kmax didn't actually line up with a k value
   [k,I] = unique(k);
   P = P(I,:);
   
   y = trapz(k,P);
end
