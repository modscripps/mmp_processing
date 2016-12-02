function p=z2p(S,T,z);
% Usage: p=p2z(s,t,z);
%  inputs:
%    s: salinity in concentration units
%    t: temperature in deg C
%    z: depth in m
%  outputs:
%    pgrid: pressure at each input depth consistent with specified S and T
%
%MHA, 03/04

%z=depthWOA;
%S=SWOA;
%T=TWOA;

%make a lookup p in dbar
    dp_grid=.01;
    ig=find(~isnan(S) & ~isnan(T));
    if ~isempty(ig)
    [pgrid,zgrid]=p2z(S(ig),T(ig),z(ig)/100,dp_grid); 
    %This is now the pressure-to-depth relation given the observed T
    %and S, ignoring the (small) error resulting from the depth offset in
    %the profiles since they were sampled at the depths not the pressures.
    
    %plot(zgrid,pgrid)
    p=interp1(zgrid,pgrid,z);
    else
        p=NaN*z;
    end