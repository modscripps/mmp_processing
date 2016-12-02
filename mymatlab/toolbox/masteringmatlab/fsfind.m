function [Fn,nwo,f,t]=fsfind(fun,T,N,P)
%FSFIND Find Fourier Series Approximation.
% Fn=FSFIND(FUN,T,N) computes the Complex Exponential
% Fourier Series of a signal described by the function 'FUN'.
% FUN is the character string name of a user created M-file function.
% The function is called as f=FUN(t) where t is a vector over
% the range 0<=t<=T.
%
% The FFT is used. Choose sufficient harmonics to minimize aliasing.
%
% T is the period of the function. N is the number of harmonics.
% Fn is the vector of FS coefficients.
%
% [Fn,nWo,f,t]=FSFIND(FUN,T,N) returns the frequencies associated
% with Fn in nWo, and returns values of the function FUN
% in f evaluated at the points in t over the range 0<=t<=T.
%
% FSFIND(FUN,T,N,P) passes the data in P to the function FUN as
% f=FUN(t,P). This allows parameters to be passed to FUN.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 2/9/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

n=2*N;
t=linspace(0,T,n+1);
if nargin==3
 f=feval(fun,t);
else
 f=feval(fun,t,P);
end
Fn=fft(f(1:n));
Fn=[0 conj(Fn(N:-1:2)) Fn(1:N) 0]/n;
nwo=2*pi/T*(-N:N);

