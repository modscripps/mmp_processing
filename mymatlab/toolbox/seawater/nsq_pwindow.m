function [n2,dthetadz,dsdz,p_nsq]=nsq_pwindow(s,t,p,p0);
% nsq
%   Usage: [n2,dthetadz,dsdz,p_nsq]=nsq_pwindow(s,t,p,p0);
%     inputs
%      s is salinity (concentration units) in a column array,
%      t is in-situ temperature (deg C) in a column array
%      p is pressure (MPa) of t and s, also in a column array
%      p0 is a vector of mid-point pressures at which nsq is to be computed
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

% compute pressures of upper and lower boundaries of all nsq windows
pb=pwindow(p0);

% reduce the range of pb if necessary to fall within the range of p
minp=min(p); maxp=max(p);
i=1;
while pb(i)<minp
  i=i+1;
end
j=length(pb);
while pb(j)>maxp
  j=j-1;
end
pb=pb(i:j);
diff_pb=diff(pb);

% make corresponding adjustments to compute p_nsq from p0
p_nsq=p0(i:j-1);
npts=length(p_nsq);

% low pass temp and salinity with a cutoff at the Nyquist wavenumber of
% the specified p_nsq array
dp=diff(p); % median pressure interval of t,s data
%[b,a]=butter(4,2*median(diff_pb)/median(dp));
%t=filtfilt(b,a,t);
%s=filtfilt(b,a,s);
%p=filtfilt(b,a,p);

% find and remove p inversions
dp=diff(p);
ineg=find(dp<=0);
if ~isempty(ineg)
  p(ineg+1)=NaN*ones(size(ineg));
  ig=find(~isnan(p));
  p=p(ig); t=t(ig); s=s(ig);
end

% check that p is monotonic
i=find(dp>=0);
len=length(p);
index=1:len;
if length(i)==len-1;

   % find temperature and salinity at pb
   ib=round(interp1(p,index,pb))';
	t=t(ib); s=s(ib);

	% compute potential density of shallower window pts at output, 
	% i.e. center, pressures
   i_s=(1:1:length(pb)-1);
   % convert to column vectors
   s=s(:); t=t(:); pb=pb(:); p_nsq=p_nsq(:); diff_pb=diff_pb(:);
   
   pt_s=sw_pden(s(i_s),t(i_s),pb(i_s),p_nsq);

	% compute potential density of deeper window pts at output pressures
	i_d=(2:1:length(pb));
	pt_d=sw_pden(s(i_d),t(i_d),pb(i_d),p_nsq);


	n2=G^2*(pt_d - pt_s)./(1e6*diff_pb); % dp must be in Pascals, not MegaPascals
	dthetadz=(potemp(s(i_s),t(i_s),pb(i_s)) - ...
                 potemp(s(i_d),t(i_d),pb(i_d)))./(100*diff_pb);
        dsdz=(s(i_s)-s(i_d))./(100*diff_pb);
else
	disp('  filtered pressure not monotonic')
	n2=NaN; pout=NaN; dthetadz=NaN; dsdz=NaN;
end
