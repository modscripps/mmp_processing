function edof=edof_95pcent(cl,type)
% Usage: edof=edof_95pcent(cl,type);
%  inputs
%   cl is a vector of 95% confidence limits.  The limits are
%   factors to be multiplied by the expected value.
%   type='ub' or 'lb' if cf is the upper or lower 95% conf. limit
%  output
%   edof is a number or vector of equivalent degrees of freedom
% Function:
%  To compute the equivalent degrees of freedom from the
%  upper or lower 95% confidence limits for a Gaussian variable
%  using the results of conf_limits.m
% M.Gregg, 19oct95

% compute reference edof spanning full range of conf_limits.m
x=[2:1000]; 

% compute bounds for full range of conf_limits.m
[ub_ref,lb_ref]=conf_limits(0.95,x);

% obtain edof by interpolation
if strcmp(type,'ub')
  edof=interp1(ub_ref,x,cl);
elseif strcmp(type,'lb')
  edof=interp1(lb_ref,x,cl);
else
  error('type must be 'ub' or 'lb')
end
