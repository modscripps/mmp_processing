function [deci_deg]=decimal_position(degree,minute,hemi)
% usage: [deci_deg]=decimal_position(degree,minute,'hemi')

deci_deg = degree + minute/60;
if strcmp(hemi,'S') | strcmp(hemi,'W')
	deci_deg = - deci_deg;
end
