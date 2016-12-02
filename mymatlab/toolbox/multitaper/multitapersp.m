function [rainbow,ff,C]= multitapersp(x1,x2,f,dt,Riedel)
%
% [RAINBOW,ff,C] = FUNCTION multitapersp(X1,X2,F,dt,Riedel)
%
%  ex.
%  [rainbow,ff,C]=multitapersp(series1,series2,k/(2n),1/24,'R');
%
%  Input:
%
%   series1 and series2 are two input time series
%   F is the frequency bandwidth (= k /2n; n = length(series)  the number of
%     data points.)  k = number of tapers. For k >= 2nF, the resulted 
%     spectrum is biased at the high frequency regime.
%   dt is the sampling interval 
%   Riedel = 'R' use the Riedel filters (faster!), otherwise
%   use Thompson's approximated forms
%
%  Output:
%
%   Rainbow: as explained below 
%   ff : frequency
%   C= [sp1 sp2 co qd]: the first two column vectors are power spectra
%      of series 1 and 2, the third and fourth column vectors are co-
%      and quad spectra.
%
%    Estimate power, coherence, and phase spectra for two column
% vectors X1 and X2 using the multiple taper spectral analysis
% method.  F is the bandwidth i.e. K=2NF where K is the number
% of windows, and N is the length of the time series.  The power
% spectra of X1 and X2 are returned in the first two columns of
% RAINBOW.  Column three is the squared coherence and column four
% is the phase spectrum.  
% By John Kuehne, June 1990.
%
% modified by Ren-Chieh Lien 1995, C is the cross-spectrum
%
% WARNING: DON'T USE RAINBOW.

[t1,t2]=size(x1);
if exist('Riedel');
   if (Riedel=='R');
      [a,b]=w4(t1,f);
   else
      [a,b] = w2(t1,f);
   end
else
   [a,b] = w2(t1,f);
end
f1=spectra(x1,a);
f2=spectra(x2,a);
p1=mypower(f1,b);
p2=mypower(f2,b);
c12=crossp(f1,f2,b);
co=coherence(p1,p2,c12);
ph=angle(c12);
rainbow(:,1)=fftshift(p1)*dt*2;
rainbow(:,2)=fftshift(p2)*dt*2;
rainbow(:,3)=fftshift(co);
rainbow(:,4)=fftshift(ph);
nfft = length(x1)/2;
C(:,1:2) = rainbow(nfft+1:nfft*2,1:2);
cosp = fftshift(real(c12))*dt*2;
qasp = fftshift(imag(c12))*dt*2;


C(:,3) = cosp(nfft+1:nfft*2);
C(:,4) = qasp(nfft+1:nfft*2);

coh = (C(:,3).^2+C(:,4).^2)./(C(:,1).*C(:,2));
phase = angle(C(:,3)+sqrt(-1)*C(:,4));

rainbow(1:nfft,:) = [];
ff = (1:nfft)/(2*nfft*dt);
