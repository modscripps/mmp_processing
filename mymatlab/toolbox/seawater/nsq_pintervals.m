function [nsq,dthetadz,dsdz]=nsq_pintervals(s,t,p,po);
% nsq
%   Usage: [n2,dthetadz,dsdz,p_nsq]=nsq_pintervals(s,t,p,p0);
%     inputs
%      s is salinity (concentration units) in a column array,
%      t is in-situ temperature (deg C) in a column array
%      p is pressure (MPa) of t and s, also in a column array
%      po is two column arrays defining the pressures at which nsq is to 
%         be computed.  The first column contains the top boundaries
%         (lower pressures), and the second column contains the bottom
%         boundaries (higher pressures).
%     outputs
%      n2 is the square of the buoyancy frequency, in (rad/s)^2
%      dthetadz is the gradient of potential temperature
%      dsdz is the salinity gradient
%      n_sq is a vector of pressures matching the dependent variables 
%         and may differ from p0
%   Function: (a) low-pass filters t,s,p over dp, which is calculated from
%      in and out pressure arrays, (b) linearly interpolates
%      t and s onto pressures, p0, p0+dp, p0+2dp, ...., (c) computes
%      upper and lower potential densities at p0+dp/2, p0+3dp/2,...
%      (d) converts differences in potential density into nsq
%      (e) returns NaNs if the filtered pressure is not monotonic.
    

G=9.80655;

% delete negative presssures from input theta_sd data
i=find(p>=0);
p=p(i); s=s(i); t=t(i);

% reverse order of upward profiles
if p(length(p))<p(1)
	p=flipud(p); t=flipud(t); s=flipud(s);
end

% reduce the range of po if necessary to fall within the range of p
minp=min(p); maxp=max(p); len0=length(po);
i=1;
while po(i,1)<minp
  i=i+1;
end
j=len0;
while po(j,2)>maxp
  j=j-1;
end
po=po(i:j,1:2);
if i>1 | j<len0
   disp('po, output array, reduced to match input pressures')
end

% find and remove p inversions from input data
dp=diff(p);
ineg=find(dp<=0);
if ~isempty(ineg)
  p(ineg+1)=NaN*ones(size(ineg));
  ig=find(~isnan(p));
  p=p(ig); t=t(ig); s=s(ig);
end

% if p is monotonic, proceed to find points nearest to po by interpolation
% and use these to compute nsq
i=find(dp>=0);
len=length(p);
index=1:len;
if length(i)==len-1;

   % find temperature and salinity at the end pressures of the intervals
   t_u=interp1(p,t,po(:,1));
   s_u=interp1(p,s,po(:,1));
   t_l=interp1(p,t,po(:,2));
   s_l=interp1(p,s,po(:,2));
   
   % calculate the midpoints and dp of the pressure intervals
   pmid=(po(:,1)+po(:,2))/2;
   dp=(po(:,2)-po(:,1)); % in Pascals
   
   % compute potential temperatures at pmid
   th_u=sw_ptmp(s_u,t_u,po(:,1),pmid);
   th_l=sw_ptmp(s_l,t_l,po(:,2),pmid);
   
	% compute potential densities at pmin 
   pd_u=sw_pden(s_u,th_u,po(:,1),pmid);
   pd_l=sw_pden(s_l,th_l,po(:,2),pmid);
   
   nsq=-G^2*(pd_u - pd_l) ./ (1e6*dp); % dp must be in Pascals
   dthetadz=(th_u - th_l) ./ (dp/100);
   dsdz=(s_u - s_l) ./ (dp/100);
else
	disp('  input pressure not monotonic')
	n2=NaN; pout=NaN; dthetadz=NaN; dsdz=NaN;
end
