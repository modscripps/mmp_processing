function y=fsresp(num,den,un,wo)
%FSRESP Fourier Series Linear System Response.
% FSRESP(N,D,Un,Wo) returns the complex exponential FS of the
% output of a linear system when the input is given by a FS.
% N and D are the numerator and denominator coefficients
% respectively of the system transfer function.
% Un is the complex exponential Fourier Series of the system input.
% Wo is the fundamental frequency associated with the input.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

if nargin<4,wo=1;end
N=(length(un)-1)/2;
jNwo=sqrt(-1)*(-N:N)*wo;
y=(polyval(num,jNwo)./polyval(den,jNwo)).*un;
