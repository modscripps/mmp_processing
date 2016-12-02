function p=z2p(S,T,z,lat);
% Usage: p=p2z(s,t,z,lat);
%  inputs:
%    s: salinity in concentration units - CHANGED to psu 9/05
%    t: temperature in deg C
%    z: depth in m
%  outputs:
%    pgrid: pressure at each input depth consistent with specified S and T
%
%MHA, 03/04
%modified 9/05 to include lat-dependence and use normal units
if nargin < 4
    lat=NaN;
end

%make a lookup p in dbar
    dp_grid=1;
    ig=find(~isnan(S) & ~isnan(T));
    if ~isempty(ig)
    [pgrid,zgrid]=p2z(S(ig),T(ig),z(ig),dp_grid,lat); 
    %This is now the pressure-to-depth relation given the observed T
    %and S, ignoring the (small) error resulting from the depth offset in
    %the profiles since they were sampled at the depths not the pressures.
    
    %plot(zgrid,pgrid)
    p=interp1(zgrid,pgrid,z);
    else
        p=NaN*z;
    end