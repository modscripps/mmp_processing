function [hsq,phi] = cheby6(f,f3db)
% cheby6
%   Usage: [hsq,phi] = cheby6(f,f3db)
%      f is a vector of frequencies in Hz
%      fc is a number giving the cutoff frequency in Hz
%      hsq is the amplitude-squared response
%      phi is the phase response NOT IMPLEMENTED YET
%   Function: amplitude-squared response of 6-pole Chebyschev 
%      low-pass filter with Rbd=0.2.

coshA=1.068517;
epsilon=0.2170911;

omega = f' .* (coshA/f3db);
C6sq=32.*omega.^6 - 48.*omega.^4 + 18.*omega.^2 -1;
hsq=1./(1+epsilon^2 .* C6sq);
hsq=hsq';
phi=[];