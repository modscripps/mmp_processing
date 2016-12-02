function y = haf_ninnis(f,w)
% haf_ninnis
%   Usage: y=haf_ninnis(f,w)
%      f is array of frequencies
%      w is fall rate in m/s	
%   Function: 	Returns hp(f,w)^2 where hp(f,w) is the
%      electronic transfer function of the airfoil probe freq. 
%      response according to R. Ninnis, Ph.D dissertation, 
%      Univ. British Columbia, Oct. 1984, "The effects of spatial
%      averaging on airfoil probe measurements of oceanic 
%      velocity measurements."

%	"The large-scale transfer function has been truncated at the first
%	zero crossing, K0, and fitted to a quartic polynomial over the
%	domain, 0 < k/K0 < 1.  The transfer function is very well
%	approximated as T(k/K0), where

%		T(k/K0) = SUM (n=0,1,2,3,4) A<n> * (k/K0)^n


K0=140.0; % Wavenumber of first zero-crossing, in cpm
A0=1.000;
A1=-0.165;
A2=-4.763;
A3=5.900;
A4=-1.986;
mninnis=0.0001;

x=(f' / w) / K0; % normalized wavenumber
ig=find(x>1); % Indices of wavenumbers exceeding where the fit applies

y=A0 + A1*x + A2*x.^2 + A3*x.^3 + A4*x.^4;

small = find(y < mninnis);
y(small) = mninnis * ones(size(small));
y=y';

y(ig)=NaN*ones(size(ig));
