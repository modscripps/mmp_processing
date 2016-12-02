function [ub,lb]=conf_limits(pcent,edof);
% Usage: [ub,lb]=conf_limits(pcent,edof);
%  inputs
%   pcent is the percentage conf limit: .90, .95, or .99
%   edof is a number giving the equivalent degrees of freedom
%  outputs
%   ub is the upper confidence limit, to be mult. by expected value
%   lb is the lower confidence limit, to be mult. by expected value
% Function:
%  To obtain the Gaussian confidence limits, using the table
%  and expressions in section 6.10 of "Spectral Analysis for
%  Physical Applications" by Percival and Walden, Cambridge
%  1993
% M.Gregg, 19oct95

% Percentage points for 2<=edof<=7 from Table 256
ppts_u=[NaN 5.9915 7.8147 9.4877 11.0705 12.5916 14.0671; ... % for p=.95 in 
Table 256
NaN 7.3778 9.3484 11.1433 12.8325 14.4494 16.0128; ...        % for p=.975 in 
Table 256
NaN 10.5966 12.8382 14.8603 16.7496 18.5476 20.2777]';        % for p=.995 in 
Table 256

ppts_l=[NaN .1026 .3518 .7107 1.1455 1.6354 2.1673; ...       % for p=.05 in 
Table 256
NaN .0506 .2158 .4844 .8312 1.2373 1.6899; ...                % for p=.025 in 
Table 256
NaN .0100 .0717 .2070 .4117 .6757 .9893]';                    % for p=.005 in 
Table 256

% determine the percentage points for the standard Gaussian 
% distribution from the bottom row of Table 256.
if pcent==0.90 
  GPpts=1.6449;
elseif pcent==0.95
  GPpts=1.9600;
elseif pcent==0.99
  GPpts=2.5758;
else
  error('GPpts defined only for pcent=0.90, 0.95, and 0.99')
end

if edof==1
  error('Condidence limits not defined for edof=1')
elseif edof>=2 & edof<=7 % look them up in Table 256
  if pcent==0.90 
    p_u=ppts_u(edof,1); p_l=ppts_l(edof,1);
  elseif pcent==0.95 
    p_u=ppts_u(edof,2); p_l=ppts_l(edof,2);
  else 
    p_u=ppts_u(edof,3); p_l=ppts_l(edof,3);
  end
else
  x=2./(9*edof);
  p_u=edof.*(1-x+GPpts*sqrt(x)).^3; % Q_nu(1-p)
  p_l=edof.*(1-x-GPpts*sqrt(x)).^3; % Q_nu(p)
end

lb=edof./p_u;
ub=edof./p_l;
