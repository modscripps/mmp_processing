function [magsq,phase]=h_fp07(f,w)
%   Usage: [h,phase]=h_fp07(f,w)
%      f is a column vector of frequencies to be evaluated
%      w is the fall rate in m/s
%   Function: returns the dynamic transfer function of the
%      FP07 thermistor.

tau=0.005 * w^(-0.32); % thermistor time constant
magsq=1 ./ (1+((2*pi*tau).*f).^2).^2; % magnitude-squared
phase=-2*atan( 2*pi*f*tau);