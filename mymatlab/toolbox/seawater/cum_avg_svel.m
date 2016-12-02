function [svelavg,pgrid,sgrid,tgrid]=cum_avg_svel(s,t,p)
% Usage: [cbar,p_cbar,s_bar,t_bar]=cum_avg_svel(s,t,p);
%  inputs:
%    s: salinity in concentration units
%    t: temperature in deg C
%    p: pressure in MPa
%  outputs:
%    cbar: average sound speed, in m/s, above pgrid values
%    pgrid: pressure in 0.01 MPa steps from 0 to max(p)
%    sgrid, tgrid: on the same pgrid
% Function: Use a densly sampled profile of t and s to calculate
%   the average sound speed above a uniformly-spaced pressure
%   grid.
% M.Gregg, 6may96, 
%          14may96, rev. to output sgrid & tgrid

G=9.80655;
dp=.01; % pressure spacing

% find data without NaNs
igood=find(~isnan(t) & ~isnan(s) & ~isnan(p));
t=t(igood); s=s(igood); p=p(igood);
  
% flip profile if pressure decreases along the array
if p(1) > p(length(p))
  p=fliplr(p); t=fliplr(t); s=fliplr(s);
end

% Sort p to increase monotonically
[p_mono,i_mono]=sort(p);
t_mono=t(i_mono); s_mono=s(i_mono);

% Set up evenly spaced pressure grid.  Extrapolate shallowest 
% values to the surface.  Then interpolate remaining values onto
% the grid and calculate the sound speed.
%% Set up grid
max_mono=max(p_mono); max_p=max(p);
min_mono=min(p_mono); min_p=min(p);
p_max=min(max_mono,max_p); p_min=max(min_mono,min_p);
pgrid=[0:dp:p_max]; ngrid=length(pgrid);
tgrid=NaN*ones(size(pgrid)); sgrid=NaN*ones(size(pgrid));
%% Extrapolate shallowest values to the surface.
i_shallow=find(pgrid<p_min);
if ~isempty(i_shallow)
  tgrid(i_shallow)=t(1)*ones(size(i_shallow));
  sgrid(i_shallow)=s(1)*ones(size(i_shallow));
  imax=max(i_shallow);
else
  imax=0;
end
%% Interpolate t and s onto the grid & compute sound speed
tgrid(imax+1:ngrid)=interp1(p_mono,t_mono,pgrid(imax+1:ngrid));
sgrid(imax+1:ngrid)=interp1(p_mono,s_mono,pgrid(imax+1:ngrid));
svel = soundspeed(sgrid,tgrid,pgrid);

% Calculate the average sound speed shallower than grid points
svelavg=cumsum(svel)./(1:ngrid);
