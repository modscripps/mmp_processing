function af_compare_mmp(drop,prlb,prub,ref,speclen,overlap)
% Usage: af_compare_mmp(drop,prlb,prub,ref,speclen,overlap)
%  Inputs:
%    drop: integer mmp drop number
%    prlb, prub: lower and upper pressure bounds for analysis
%    ref: reference channel, 'v1' or 'v2'
%    speclen: integer # samples per FFT, e.g. 512
%    overlap: integer # samples to overlapp successive FFTs
% Function:
%     Compares 'v1' and 'v2' spectra as raw volts and as
%   shear.  Plots 4 panels: 1) overlay of the raw spectra;
%   2) coherence^2 between raw spectra corrected for differences
%   in Sv, the probe sensitivity; 3) Overlay of shear spectra
%   and of the Panchev spectrum (dotted) for the integral of
%   'v1'; 4) ratio of the shear spectra.  In computing epsilon,
%   kvis=1e-6;
% M.Gregg, 24nov96
% revised for matlab 5.1 on PC, 25feb98

dof=50;  % a dummy because dof isn't implemented

G=9.8065; % gravity
Fs=400;  % mmp sample rate
AF_PER_PR=16; % number of af samples per pr sample
KVIS=1e-6; % kinematic viscosity for calculating epsilon
KC=40; % cutoff wavenumber for calculating epsilon

dt=1/Fs; % sample period in seconds

figure
wysiwyg
wygiwys

% Calculate pressure for the airfoils
data=read_rawdata_mmp('v1',drop);
pr=pr3_mmp(drop);
pr=pr_offset1_mmp(drop,'v1',pr);

% Find indices of pressure in the range selected,
% avoiding any pressures in the range when the profiler was 
% being pulled up.
igp=find(~isnan(pr));
maxpr=max(pr(igp));
if maxpr<prub
   disp_str=['prub > maximum pr = ' num2str(maxpr)];
   disp(disp_str)
end
imaxpr=find(pr==maxpr);
%
ipr=find(pr>=prlb & pr<=prub);
ipr=ipr(find(ipr<imaxpr)); % indices before maxpr
idata=AF_PER_PR*ipr(1):AF_PER_PR*ipr(length(ipr)); % indices of af data
speed=100*(pr(ipr(length(ipr)))-pr(ipr(1)))/(dt*length(idata));

% Get af data over selected pr range
data1=atod1_mmp(read_rawdata_mmp('v1',drop));
data1=data1(idata);
data2=atod1_mmp(read_rawdata_mmp('v2',drop));
data2=data2(idata);

% Take spectra, delete f=0, and normalize
[Pv1,f]=psd(data1,speclen,Fs,speclen,overlap);
Pvolts1=Pv1(2:length(Pv1))'/(0.5*Fs);
[Pv2,f]=psd(data2,speclen,Fs,speclen,overlap);
Pvolts2=Pv2(2:length(Pv2))'/(0.5*Fs);
f=f(2:length(f));

% Apply transfer functions for velocity
k=f/speed; % calculate wavenumber
mmpid=read_mmpid(drop);
% for v1
[sensorid1,electronicsid1,filter1,fc1,scanpos]= ...
   read_chconfig_mmp('v1',mmpid,drop);
calid1=read_whichcal_mmp('af',sensorid1,drop);
[Sv1,Cs1]=read_af_cal(sensorid1, calid1);
str1=['helectronics1=helectronics_' electronicsid1 '(Cs1,f);'];
eval(str1); % evaluate electronics transfer function
str2=['[hfilt1,pfilt1]=' filter1 '(f,fc1);'];
eval(str2);  % evaluate anti-alias filter transfer fcn
h_freq1=helectronics1 .* hfilt1;
htotal1=(Sv1*speed/(2*G))^2 * h_freq1 .*haf_oakey(f,speed);
Pvel1=(Pvolts1*speed) ./ htotal1'; % velocity spectrum
% for v2
[sensorid2,electronicsid2,filter2,fc2,scanpos]= ...
   read_chconfig_mmp('v2',mmpid,drop);
calid2=read_whichcal_mmp('af',sensorid2,drop);
[Sv2,Cs2]=read_af_cal(sensorid2, calid2);
str3=['helectronics2=helectronics_' electronicsid2 '(Cs2,f);'];
eval(str3); % evaluate electronics transfer function
str4=['[hfilt2,pfilt2]=' filter2 '(f,fc2);'];
eval(str4);  % evaluate anti-alias filter transfer fcn
h_freq2=helectronics2 .* hfilt2;
htotal2=(Sv2*speed/(2*G))^2 * h_freq2 .*haf_oakey(f,speed);
Pvel2=(Pvolts2*speed) ./ htotal2'; % velocity spectrum

% Calculate epsilon and corresponding Panchev spectrum
% First, calculate dk, the elementary bandwidth
dk=1/(speclen*dt*speed);
[eps1,kmax]=eps1_mmp(k,(2*pi*k).^2.*Pvel1',KVIS,speed,dk,KC);
[kpan,Ppan]=panchev(eps1,KVIS);

% Compute cross-spectrum
if strcmp(ref,'v1')
   Pv1v2=csd(data1,data2,speclen,Fs,speclen,overlap);
   [coh,pha,sig] = cohpha(.95,Pv1v2,Pv1,Pv2,dof);
elseif strcmp(ref,'v2')
   Pv2v1=csd(data2,data1,speclen,Fs,speclen,overlap);
   [coh,pha,sig] = cohpha(.95,Pv2v1,Pv2,Pv1,dof);
else
   disp('af_compare_mmp: ref must be ''v1'' or ''v2'' ')
end 

% Calculate plotting limits
fmin=min(f(2:length(f))); fmax=max(f(2:length(f)));
kmin=min(k); kmax=max(k);
Pvolts_max=max(max(Pvolts1),max((Sv1/Sv2)^2*Pvolts2));
ifreq=find(f<100);
Pvolts_min=min(min(Pvolts1(ifreq)),min(Pvolts2(ifreq)));
Pshear_max=max(max((2*pi*k).^2.*Pvel1'),max((2*pi*k).^2.*Pvel2'));
ik=find(k>0 & k<100);
Pshear_min=min(min((2*pi*k(ik)).^2.*Pvel1(ik)'),min((2*pi*k(ik)).^2.*Pvel2(ik)'));

hdg_panel=[.1 .9 .8 .01];
panel1=[.12 .52 .35 .35];
panel2=[.57 .52 .35 .35];
panel3=[.12 .12 .35 .35];
panel4=[.57 .12 .35 .35];

% Write heading info
axes('position',hdg_panel,'xticklabel',' ','box','off')
hold on
axis off
hdg=[mmpid ', drop=' int2str(drop) ', prlb=' num2str(prlb) ...
      ', prub=' num2str(prub) ', v1=' sensorid1 ', v2=' sensorid2];
title(hdg)

% Plot volts spectra in panel 1, upper left
axes('position',panel1,'box','on','yscale','log','xscale','log', ...
   'xticklabel','','ticklength',[.02 .025])
hold on
Hp1=plot(f,Pvolts1,'r');
set(Hp1,'linewidth',[2])
Hp2=plot(f,(Sv1/Sv2)^2*Pvolts2,'g');
set(Hp2,'linewidth',[2])   
axis([fmin fmax 0.5*Pvolts_min 2*Pvolts_max])
title1=[ref ' (red), (Sv_1/Sv_2)^2 * v_{other} (green)'];
title(title1)
ylabel('\Phi_{volts} / volts^2 Hz^{-1}')
grid on

% Plot shear spectra in panel 2, upper right
axes('position',panel2,'box','on','yscale','log','xscale','log', ...
   'xticklabel','','ticklength',[.02 .025])
hold on
Hp3=plot(k,(2*pi*k).^2.*Pvel1','r','linewidth',[2]);
Hp4=plot(k,(2*pi*k).^2.*Pvel2','g','linewidth',[2]);
Hpan=plot(kpan,Ppan,'b','linewidth',[2]);
axis([kmin kmax 0.5*Pshear_min 2*Pshear_max])
if strcmp(ref,'v1')
   set(Hp3,'linewidth',[2])
elseif strcmp(ref,'v2')
   set(Hp4,'linewidth',[2])
end   
title2=[ref ' (r),  other (g), panchev (b), eps1=' num2str(eps1,3)];
title(title2)
ylabel('\Phi_{shear} / s^{-2} cpm^{-1}')
grid on

% Plot coherence of volts spectra in panel 3, lower left
axes('position',panel3,'box','on','yscale','linear','xscale','log', ...
   'ticklength',[.02 .025])
hold on
Hp5=plot(f,coh(2:length(coh)));
axis([fmin fmax 0 1])
xlabel('f / Hz')
ylabel('Coherence^2')
title3=['Coh of volts spec, ' ref ' is ref'];
title(title3)
grid on

% Plot ratio of shear spectra in panel 4, lower right
axes('position',panel4,'box','on','yscale','log','xscale','log', ...
   'ticklength',[.02 .025])
hold on
if strcmp(ref,'v1')
   Hp6=loglog(k,Pvel2./Pvel1);	
   ylstr=['\Phi_{shear} (v2) / \Phi_{shear} (v1)'];
elseif strcmp(ref,'v2')
   Hp6=loglog(k,Pvel1./Pvel2);	
   ylstr=['\Phi_{shear} (v1) / \Phi_{shear} (v2)'];
end
axis([kmin kmax 0.5*min(Pvel2./Pvel1) 2*max(Pvel2./Pvel1)])

xlabel('k_3 / cpm')
ylabel(ylstr)
grid on
