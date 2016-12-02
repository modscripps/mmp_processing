function [y_mono,displ,p_out,i]=sort_profile2(y,p,change_w_p)
% Usage: [y_mono, displ,p_out,i]=sort_profile2(y,p,change_w_p)
%   y is the variable to be sorted
%   p is input pressure
%   change_w_p is a string stating how y is to be sorted: 
%      'incr' for y increasing w p, 'decr' for y decreasing w p
%   y_mono is the sorted array
%   displ is vert dist from position in the monotonic profile to 
%     the position in the observed profile
%   p_out is pressure of the sorted array
%   i is an array with the sorted indices
% Function: sort profile variable into monotonic sequence and
%   compute vertical displacements between original & monotonic
%   profiles.  Upward profiles are first rearranged so pressure
%   increases along the array

G=9.80655;

% invert order of upward profiles
if p(1)>p(length(p)) 
		y=flipud(y); p=flipud(p);
end

if strcmp(change_w_p,'decr')
	y=flipud(y); p=flipud(p);
	[y_mono,i]=sort(y);
	p_sort=p(i);
	dp=-10^6 .* (p - p_sort);
	y_mono=flipud(y_mono); dp=flipud(dp); p_out=flipud(p);
elseif strcmp(change_w_p,'incr')
	[y_mono,i]=sort(y);
	p_sort=p(i);
	dp=-10^6 .* (p - p_sort);
	p_out=p;
end

displ = dp ./ (1025 * G); % vert. dist. from posit. in mono. incr. profile
                          % to posit. in obs. profile
