function [rainbow,ff]= prism(x1,x2,f,dt)
% RAINBOW = FUNCTION PRISM(X1,X2,F,dt)
%    Estimate power, coherence, and phase spectra for two column
% vectors X1 and X2 using the multiple taper spectral analysis
% method.  F is the bandwidth i.e. K=2NF where K is the number
% of windows, and N is the length of the time series.  The power
% spectra of X1 and X2 are returned in the first two columns of
% RAINBOW.  Column three is the squared coherence and column four
% is the phase spectrum.  All vectors in RAINBOW are FFTSHIFTed
% so that zero frequency is the central value.
% By John Kuehne, June 1990.

[t1,t2]=size(x1);
[a,b]=w2(t1,f);
f1=spectra(x1,a);
f2=spectra(x2,a);
p1=power(f1,b);
p2=power(f2,b);
c12=cross(f1,f2,b);
co=coherence(p1,p2,c12);
ph=angle(c12);
rainbow(:,1)=fftshift(p1)*dt*2;
rainbow(:,2)=fftshift(p2)*dt*2;
rainbow(:,3)=fftshift(co);
rainbow(:,4)=fftshift(ph);
nfft = length(x1)/2;
rainbow(1:nfft,:) = [];
ff = (1:nfft)/(2*nfft*dt);
