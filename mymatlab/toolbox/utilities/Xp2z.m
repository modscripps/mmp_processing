function z=p2z(s,t,p);
% Usage: z=p2z(s,t,p);
%  inputs:
%    s: salinity in concentration units, e.g. .035
%    t: temperature in deg C
%    p: sea pressure in MPa
%  output:
%    z: depth in meters
% Function: To convert measured sea pressure to depth using
%  temperature and salinity from the profile.
%error('routine not completed')
G=980.655;

% Parameters for examining pressure
p_len=length(p); 
p_max=max(p); imax=find(p==p_max);
p_min=min(p); imin=find(p==p_min);
dp=diff(p); dp_avg=mean(diff(p));
idown=find(dp>0); iup=find(dp<0);

% Abort if any pressures are negative
if p_min<0
  error('p contains negative values')
end

% Determine if profile ascends or descends on average
if dp_avg>0 & p(p_len)>p(1)
  direction='down';
elseif dp_avg<0 & p(p_len)<p(1)
  direction='up';
else
  error('pressure gradient confused')
end

% Determine if profile is monotonic
monotonic='n';
if strcmp(direction,'down')
  if imin==1 & imax==p_len & isempty(iup)
    monotonic='y';
  else
    n_opposite=length(iup);
  end
elseif strcmp(direction,'up')
  if imin==p_len & imax==1 & isempty(idown)
    monotonic='y';
  else
    n_opposite=length(idown);
  end
end
if strcmp(monotonic,'n')
	msg=[direction 'ward profile with ' int2str(p_len) ' points' ...
	     ' has p_min at point ' int2str(imin) ', and p_max at' ...
		 ' point ' int2str(imax) '.  Also, ' int2str(n_opposite) ...
		 ' points are in the opposite direction.'];
	disp(msg)
end

rho=density(s,t,p);

