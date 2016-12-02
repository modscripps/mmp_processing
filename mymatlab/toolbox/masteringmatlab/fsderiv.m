function dk=fsderiv(kn,wo)
%FSDERIV Fourier Series Derivative.
% FSDERIV(Kn,Wo) returns the FS coeficients of the derivative
% of f(t) whose FS coeficients are given by Kn and whose
% fundamental frequency is Wo rad/s.
% If Wo is not given, Wo=1 is assumed.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

if nargin==1,wo=1;end
n=(length(kn)-1)/2;        % number of harmonics
dk=wo*sqrt(-1)*(-n:n).*kn; % jn*Wo*Kn is derivative
