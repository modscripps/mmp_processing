function m=fsmsv(kn)
%FSMSV Fourier Series Mean Square Value.
% FSMSV(Kn) uses Parseval's theorem to compute the mean
% square value of a function given its FS coefficients Kn.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

m=sum(real(kn.*conj(kn)));
