function list = find_a1a2_spike(beg_drop,end_drop,thrshld,pr_min,pr_max,len_rms)
%
% find_a1a2_spike(beg_drop,end_drop,thrshld,pr_min,pr_max,len_rms)
%
% finds a four-channel (a1, a2, v1, v2) spike in mmp data
%
%	where beg_drop and end_drop specify the mmp drop range and
%		are required fields.
%	thrshld is a multiplier that adjusts the algorithm's
%		sensitivity to a1 and a2 spikes which defaults to 1.3e-2
%	pr_min is a pressure minimum which defaults to 1.5e-1 MPa.
%	pr_max is an adjustment subtracted from the max pressure
%		of the drop which defaults to 1.5e-1 MPa.
%	len_rms is the length of the rms scan in data which defaults
%		to 20.
%
% e. macdonald 08sep99

set_mmp_paths

length_rms_scan=20;
adjust_to_max_pressure=1.5e-2;
pressure_min=1.5e-2;
threshold=1.3e-2;

if nargin<6
   len_rms=length_rms_scan;
   if nargin<5
      pr_max=adjust_to_max_pressure;
      if nargin<4
         pr_min=pressure_min;
         if nargin<3
            thrshld=threshold;
         end
      end
   end
end

scanlen=16;
list=[];

for i=beg_drop:end_drop
   disp(i);
   
   % Get raw v1 and v2 data
   v1=atod1_mmp(read_rawdata_mmp('v1',i));
	v2=atod1_mmp(read_rawdata_mmp('v2',i));
   
   % Shorten v1, v2 to match lengths of interpolated pressure
   v1len=length(v1);
   v1=v1(scanlen/2:v1len-scanlen/2);
   v2=v2(scanlen/2:v1len-scanlen/2);
   
   % Get raw a1 and a2 data
   a1=atod1_mmp(read_rawdata_mmp('a1',i));
   a2=atod1_mmp(read_rawdata_mmp('a2',i));
   
   % Shorten a1, a2 to match lengths of inerpolated pressure
   a1len=length(a1);
   a1=a1(scanlen/2:a1len-scanlen/2);
   a2=a2(scanlen/2:a1len-scanlen/2);
   
   % Get pressure data and interpolate to fit a1, a2, v1, and v2
   pr=pr_offset1_mmp(i,'v1',pr3_mmp(i));
   p=interp1(scanlen/2:16:a1len-scanlen/2,pr,scanlen/2:a1len-scanlen/2);
   p=p';
   
   [px,ix] = max(p);
   ip=find(~isnan(p)); ip=find(ip<ix(1)); % find only before deepest point
   a1=a1(ip);a2=a2(ip);p=p(ip);
   v1=v1(ip);v2=v2(ip);
   
   ip=find(p>pr_min & p<p(end)-pr_max);
   a1=a1(ip);a2=a2(ip);p=p(ip);
   v1=v1(ip);v2=v2(ip);
   
   diffa1=diff(a1(1:end-1));diffa2=diff(a2(1:end-1));
   diffa1=[0;diffa1;0];diffa2=[0;diffa2;0];
   diffv1=diff(v1(1:end-1));diffv2=diff(v2(1:end-1));
   diffv1=[0;diffv1;0];diffv2=[0;diffv2;0];
   
   mpts = [len_rms:floor(len_rms/2):length(diffa1)-len_rms];
   pr_mp = p(mpts);
   
   % calculate rms values for all four diff'd channels
   rmsa1=zeros(length(mpts),1);
   rmsa2=zeros(length(mpts),1);
   rmsv1=zeros(length(mpts),1);
   rmsv2=zeros(length(mpts),1);
   
   for ip=1:length(mpts)
      mp=mpts(ip);
      ptsa1=diffa1(mp-floor(len_rms/2):(mp+ceil(len_rms/2)-1));
      ptsa2=diffa2(mp-floor(len_rms/2):(mp+ceil(len_rms/2)-1));
      ptsv1=diffv1(mp-floor(len_rms/2):(mp+ceil(len_rms/2)-1));
      ptsv2=diffv2(mp-floor(len_rms/2):(mp+ceil(len_rms/2)-1));
       
      rmsa1(ip)=std(ptsa1,1);
      rmsa2(ip)=std(ptsa2,1);
      rmsv1(ip)=std(ptsv1,1);
      rmsv2(ip)=std(ptsv2,1);
   end
   
   irms=find(rmsa1>thrshld | rmsa2>thrshld);
   if length(irms)>0
      if length(irms)>1
         dirms=diff(irms);
         px = pr_mp(irms);
         ir = find(dirms<2 | diff(px)<0.02);
         if length(ir)>0
            irms(ir+1) = [];
         end
      end
      drop=ones(length(irms),1)*i;
      list = [list; drop pr_mp(irms) rmsa1(irms) rmsa2(irms)...
            rmsv1(irms) rmsv2(irms)];
      ilist=find(list(:,3)<1e-15 | list(:,4)<1e-15);
      list(ilist,:)=[];   
   end
   clear a1* a2* diff* drop ir* mp ptsa* p pr rmsa* v1*;
end
