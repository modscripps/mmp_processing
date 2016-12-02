function [pgrid,zgrid]=p2z(s,t,p,dp_grid,lat)
% Usage: [pgrid,zgrid]=p2z(s,t,p,dp_grid,lat);
%  inputs:
%    s: salinity in concentration units (9/05 CHANGED!  Use psu.)
%    t: temperature in deg C
%    p: pressure in MPa (9/05 CHANGED: use dbar.) 
%    dp_grid: spacing of the output pressure grid
%  outputs:
%    pgrid: uniformly spaced pressures from 0 to within dp_grid
%      of the bottom of the record.
%    zgrid: depths on the pressure
% Function: Uses a densely sampled profile of t and s to determine
%    depths on a less densely grid.  The conversion is made
%    by calculating the cumulative average density with depth.
%    Depths are obtained by dividing G times the cumulative
%    average pressure into the pressure.
% M.Gregg, 7may96
%
%9/05: MHA modified to input and output normal units, and also to accept
%lat variation  of G from Saunders 81
if nargin < 5 
    lat=NaN;
end

if isnan(lat)
G=9.80655; % gravity used by Mike
else
Go=9.780318; %
G=Go*(1+5.3024e-3*sin(lat/180*pi).^2-5.9e-6*sin(2*lat/180*pi).^2); %saunders 81
end

%convert units to psu and MPa for Mike's calc
s=s/1000;
p=p/100;
dp_grid=dp_grid/100;

% find data without NaNs
igood=find(~isnan(t) & ~isnan(s) & ~isnan(p));
t=t(igood); s=s(igood); p=p(igood);
  
% Flip profile if pressure decreases along the array
p_max=max(p); p_min=min(p); dp=mean(diff(p));
if p(1) > p(length(p)) | dp<0
  p=fliplr(p); t=fliplr(t); s=fliplr(s);
  disp('profile flipped lr to increase along vector')
end

% Extrapolate shallowest points to the surface and add to
% front of arrays
if p_min<0
  error('p_min<0');
end
p_upper=(0:dp:p_min-dp)'; p=[p_upper; p];
t_upper=t(1)*ones(size(p_upper)); t=[t_upper; t];
s_upper=s(1)*ones(size(p_upper)); s=[s_upper; s];

% calculate density and compute its cumulative sum
rho=density(s,t,p);
cum_avgrho=cumsum(rho)./(1:length(rho))';

% Set up a uniformly spaced pressure grid and interpolate
% cum_avgrho onto it
pgrid=(0:dp_grid:p_max)'; ngrid=length(pgrid);
cumrhogrid=interp1(p,cum_avgrho,pgrid);

zgrid=1e6*pgrid./(G*cumrhogrid);

%convert units back to dbar
pgrid=pgrid*100;
