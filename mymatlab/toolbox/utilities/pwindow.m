function pout=pwindow(pin);
%   Usage: pout=pbounds(pin);
%     in
%      pin is a vector of n pressures at the centers of data windows
%     out
%      pout is a vector of n+1 pressures at the upper and lower boundaries
%         of the same data windows
%   Function: to convert a vector of pressures at the centers of data
%      windows to pressures at the window boundaries.  For example, epsilon
%      is usually computed over data windows of 512 points and tagged with
%      pressure at the center of the window.  This script returns the
%      boundary pressures to use in computing nsq matching the epsilons.

n=length(pin);
pout=zeros(1,n+1);

pout(2:n)=(pin(1:n-1)+pin(2:n))/2;
pout(1)=pin(1)-(pin(2)-pin(1))/2;
pout(n+1)=pin(n)+(pin(n)-pin(n-1))/2;
