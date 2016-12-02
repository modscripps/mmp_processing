function [P,f]=psd_prewhiten(x,nfft,FS,window,noverlap)
% psd_prewhiten
%   Usage: [P,f]=psd_prewhiten(x,nfft,FS,window,noverlap);
%     inputs
%      x = data vector
%      nfft = integer length of fft
%      FS = sample frequency
%      window = optional argument
%      noverlap = optional argument
%     outputs
%      P = vector with power spectrum
%      f = vector with frequencies
%   Function: to pre-whiten input data with first-difference filter
%      and re-color output spectrum by dividing by power spectrum
%      of first-difference filter.
%   M.Gregg, 31 May 1995

T=1/FS; % sample interval
N=fix(nfft/2);

% pre-whiten x by first-differencing
du=diff(x)/T;

if nargin<=3 
	[P,f]=psd(du,nfft,FS);
elseif nargin==4
	[P,f]=psd(du,nfft,FS,window);
elseif nargin==5
	[P,f]=psd(du,nfft,FS,window,noverlap);
end
P=P/(FS/2); % nornalize variance

% compute magnitude-squared transfer function of first-difference
w=((2*pi)/(nfft*T))*(0:N)';
Hsqfd=(2/T^2)*(1-cos(w*T));

% recolor spectrum of first-differenced record
P=P./Hsqfd;
