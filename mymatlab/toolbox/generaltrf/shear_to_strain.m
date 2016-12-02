function [R,k3]=shear_to_strain(cruise,stn,depth,wbo)
%   Usage: [R,k3]=shear_to_strain(cruise,stn,depth,wbo);

% get Froude spectrum from acm
[k3_fr,frspec,frspec_u95,frspec_l95]=get_acmfrspec(cruise,stn,depth);

if nargin==4 & strcmp(wbo,'y')
	[k3_st,stspec,stspec_u95,stspec_l95]=get_wbostspec(cruise,stn,depth);
else
  	[k3_st,stspec,stspec_u95,stspec_l95]=get_tthstspec(cruise,stn,depth);
end

nfr=length(k3_fr);
nst=length(k3_st);
i=1:min(nfr,nst);
k3=k3_fr(i);
R=frspec(i) ./ stspec(i);
