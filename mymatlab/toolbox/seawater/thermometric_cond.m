function k=thermometric_cond(s,t,p)
% thermometric_cond
%   Usage: k=thermometric_cond(s,t,p)
%      s is salinity in concentration units
%      t is temperature in deg C
%      p is pressure in MPa
%      thermo-metric conductivity has units of W/(m K)
%   Source:	Caldwell,D.R. (1974), Deep-Sea Res., 21, 131-137
%	Range:	s (0 to 0.063), t (0 to 62), p (0 to 100)
%	Coded:	Ngoc Dang, July 1982, Converted F77 to C, 23-Sep-85.
%           to matlab, M. Gregg, 06jan95


k = 0.001365 * 418.55 .* ...
			(1.0 + 0.003.*t - 1.025e-5.*t.^2 + 6.53e-4.*p - 0.29.*s);
