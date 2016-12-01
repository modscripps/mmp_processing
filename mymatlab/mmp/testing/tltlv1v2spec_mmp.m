function [Pa1,Pa2,Pv1,Pv2,f]=tltlv1v2spec_mmp(drop, prstart, prstop, cruise, mmpid)
%   inputs:
%     drop:integer mmp drop number
%     prstart, prstop: pressure limits of data to be analyzed
%     cruise: string cruise name, optional
%     mmpid: string vehicle id, optional
% Function: plots data, spectra, and coherence-squared for
%  a1, a2, v1, v2.  Spectra are computed for blocks of 1024 values.
% M.Gregg, 20jul96
% revised for matlab 5.1 on PC, 25feb98
% e. macdonald, sep99, revised (a1a2v1v2spec_mmp.m)

HF_PER_SCAN=16; % # of high-frequency samples per scan
NFFT=1024; % Default length of spectrum.  Will be decreased
% if necessary to take at least two blocks.

%drop=7027;
%prstart=0.1;
%prstop=0.2;

%if nargin<4
   cruise=read_cruises_mmp(drop);
%end
%if nargin<5
	mmpid=read_mmpid(drop);
%end

% Load pr<drop>.mat if it exists
mmpfolders
pr_file=[procdata '\' cruise '\pr\pr' int2str(drop) '.mat'];
if exist(pr_file)==2
   ldpr_str=['load ' setstr(39) pr_file setstr(39)];
   eval(ldpr_str)
else
   algorithm=read_algorithm_mmp('pr',drop);
   str=['pr_scan=' algorithm '_mmp(drop);'];
   eval(str)
end

iscan=find(pr_scan>0);
if isempty(iscan)
   msg1=['a1a2v1v2spec_mmp: drop ' int2str(drop) ' has no pr_scan> 0.'];
   msg2=['   Check that database\config\mmpid has been updated.'];
   disp(msg1), disp(msg2)
end

% Find maximum pressure and the corresponding index for pr_scan
ig=find(~isnan(pr_scan));
maxpr=max(pr_scan(ig));
imaxpr=find(pr_scan==maxpr);

pr=pr_offset1_mmp(drop,'v1',pr_scan(1:imaxpr(1)));

%  Find start and stop scan numbers for pressure that are
% smaller than imaxpr, to avoid data coming up
ipr=find(pr>=prstart & pr<=prstop);
idata=find(ipr<imaxpr);
ipr=ipr(idata);

pr_scan=pr;
% Calculate the fall rate
w=100*(max(pr_scan(ipr))-min(pr_scan(ipr)))/(length(ipr)/25);

if ~isempty(ipr)
   i0=ipr(1); i1=ipr(length(ipr));
   pr=pr_scan(i0:i1);
else
   disp('no data in specified pressure range')
   break
end

% Find start and stop sample numbers for a1, a2, v1, v2
istart=i0*HF_PER_SCAN;
istop=i1*HF_PER_SCAN;
ispectra=istart:istop;
npts=length(ispectra);

% Compare npts with NFFT and reduce if necessary 
while npts<2*NFFT
   NFFT=NFFT/2;
end
% following is for epic01 configs
tlch='tl2';thch='th2';
if strcmp(mmpid,'mmp3')
   tlch='tl1';thch='th1';
end
tlch='tl1';thch='tl2'; % for fast tips vs fp07 tests
% get data between prstart & prstop
a1=atod1_mmp(read_rawdata_mmp(tlch, drop));
a1=a1(ispectra);
a2=atod1_mmp(read_rawdata_mmp(thch, drop));
a2=a2(ispectra);
v1=atod1_mmp(read_rawdata_mmp('v1', drop));
v1=v1(ispectra);
v2=atod1_mmp(read_rawdata_mmp('v2', drop));
v2=v2(ispectra);

% Calculate box positions
Hf=figure;
set(Hf,'position',[158 77 634 631]);
orient tall
x0=0.122; xgap=.035; width=(0.95-x0-xgap)/2;
y0=0.08; ygap=.005; height=(0.92-y0-3*ygap)/4;
a_pos=[x0 y0+3*(height+ygap) width height]; % tl,th time series
v_pos=[x0+width+xgap y0+3*(height+ygap) width height]; % v1, v2 time series
v1sp_pos=[x0 y0+2*(height+ygap) width height]; % v1 spectrum
v2sp_pos=[x0+width+xgap y0+2*(height+ygap) width height]; % v2 spectrum
a1sp_pos=[x0 y0+(height+ygap) width height]; % tl spectrum
a2sp_pos=[x0+width+xgap y0+(height+ygap) width height]; % th spectrum
a1v1sp_pos=[x0 y0 width height]; % tlv1 cross-spectrum
a1v2sp_pos=[x0+width+xgap y0 width height]; % thv2 cross-spectrum

% plot a1 & a2
ha_a1a2=axes('position',a_pos);
set(ha_a1a2,'box','on','xticklabel','','ticklength',[.03 .025]);
hold on
a1=a1-mean(a1); a2=a2-mean(a2);
hl_a1=plot(a1,'r');
hl_a2=plot(a2,'g');
yamax=max(max(a1),max(a2)); yamin=min(min(a1),min(a2));
xmax=length(a1);
axis([1 xmax yamin yamax])
title_str=[mmpid ', dr=' int2str(drop) ', ' num2str(prstart,4) '-' ...
      num2str(prstop,4) ' MPa,\fontsize{8} NFFT=' ...
      int2str(NFFT) '/' num2str(length(v1)) '\rm            '];
title(title_str)
ylabel([tlch '(red) ,' thch '(green) / V']);

% plot v1 & v2
ha_v1v2=axes('position',v_pos);
hold on
stdv1=std(v1); stdv2=std(v2);
vshift=3*max(stdv1,stdv2);
hl_v1=plot(v1-vshift,'r');
hl_v2=plot(v2+vshift,'g');
yvmax=max(max(v1-vshift),max(v2+vshift)); 
yvmin=min(min(v1-vshift),min(v2+vshift));
xmax=length(v1);
axis([1 xmax yvmin yvmax])
set(ha_v1v2,'box','on','xticklabel','','ticklength',[.03 .025]);
set(ha_v1v2,'yaxislocation','right');
title_str=['          w=' num2str(w,3) ' m/s, ymax=' num2str(yvmax,4)  ' V' ...
      ', ymin=' num2str(yvmin,4) ' V'];
title(title_str)

% plot axis for yticklabel on right of v1v2 data
ha1_v1v2=axes('position',get(ha_v1v2,'position'));
set(ha1_v1v2,'ytick',[],'xtick',[]);
ylabel('v1 ,v2 / V')

% text axis for epsilon value
% ha_t=axes('position',[0 0 1 1],'visible','off');
% aveps=eps_spec(cruise,drop,prstart,prstop);
% ht_eps=text(x0+width+(xgap/2),.9345,['\fontsize{8},  eps=' num2str(aveps) ',  \rm']);
% set(ht_eps,'horizontalalignment','center');

% Calculate  spectra
[Pv1,f]=psd(v1,NFFT,400,NFFT,NFFT/2);
Pv1 = Pv1 / 200;
[Pa1,f]=psd(a1,NFFT,400,NFFT,NFFT/2);
Pa1 = Pa1 / 200;
%Ca1v1=cohere(a1,v1,NFFT,400,NFFT);
Ca1v1=cohere(a2,v2,NFFT,400,NFFT);
[Pv2,f]=psd(v2,NFFT,400,NFFT,NFFT/2);
Pv2 = Pv2 / 200;
[Pa2,f]=psd(a2,NFFT,400,NFFT,NFFT/2);
Pa2 = Pa2 / 200;
%Ca1v2=cohere(a1,v2,NFFT,400,NFFT);
Ca1v2=cohere(a2,a1,NFFT,400,NFFT);

maxPv=max(max(Pv1),max(Pv2));
maxfv=max(max(Pv1(find(f<40))),max(Pv2(find(f<40))));
if maxPv<1e-6
   maxPv=1e-6;
elseif maxPv>1e-4 & maxfv<1e-6
   maxPv=(14*maxfv+maxPv)/15;
end
minPv=maxPv/3e4;
if minPv>1e-7
   minPv=1e-7;
end
maxPa=5e-4;
minPa=1e-9;
frmin=f(2); frmax=200;
yt_Pv=floor(log10(minPv));
ytl_Pv=[yt_Pv:yt_Pv+6];
yt_Pa=floor(log10(minPa));
ytl_Pa=[yt_Pa:yt_Pa+6];

minPv=1e-9; maxPv=1e-4;
% Plot v1 spectrum
ha_v1=axes('position',v1sp_pos);
loglog(f,Pv1,'r')
axis([frmin frmax minPv maxPv])
ylabel('Pv1 / V ^2 /Hz')
set(ha_v1,'ytick',[10.^ytl_Pv(1:end)]);
set(ha_v1,'box','on','xticklabel','','xscale','log')
set(ha_v1,'yscale','log','ticklength',[.03 .025]);
grid on

% Plot a1 spectrum
ha_a1=axes('position',a1sp_pos);
loglog(f,Pa1,'r')
axis([frmin frmax 1e-11 1e-6])
ylabel('Ptl / V ^2 /Hz')
set(ha_a1,'ytick',[10.^[-11:-7]]);
set(ha_a1,'box','on','xticklabel','','xscale','log')
set(ha_a1,'yscale','log','ticklength',[.03 .025]);
grid on

% Plot a1v1 cross-spectrum
ha_a1v1=axes('position',a1v1sp_pos);
semilogx(f,Ca1v1,'r')
axis([frmin frmax 0 1])
xlabel('f / Hz')
ylabel('Coh^2 (tl, v1)')
set(ha_a1v1,'box','on','xscale','log','ticklength',[.03 .025]);
grid on

% Plot v2 spectrum			
ha_v2=axes('position',v2sp_pos);
hold on
loglog(f,Pv2,'g')
loglog(f,Pv1,'r')
axis([frmin frmax minPv maxPv])
set(ha_v2,'ytick',[10.^ytl_Pv(1:end)]);
set(ha_v2,'box','on','xticklabel','','xscale','log');
set(ha_v2,'yscale','log','ticklength',[.03 .025],'yticklabel','');
grid on
ylabel('Pv2 / V ^2 / Hz')

% Plot a2 spectrum
ha_a2=axes('position',a2sp_pos);
hold on
loglog(f,Pa1,'r')
loglog(f,Pa2,'g')
axis([frmin frmax 1e-11 1e-3])
%set(ha_a2,'ytick',[10.^ytl_Pa(1:end)]);
set(ha_a2,'box','on','xticklabel','','xscale','log')
set(ha_a2,'yscale','log','ticklength',[.03 .025],'yticklabel','');
grid on
ylabel('Pth / V ^2 / Hz')

% Plot a1v2 cross-spectrum
ha_a1v2=axes('position',a1v2sp_pos);
semilogx(f,Ca1v2,'g')
axis([frmin frmax 0 1])
xlabel('f / Hz')
set(ha_a1v2,'box','on','ticklength',[.03 .025]);
set(ha_a1v2,'yticklabel','');
grid on
ylabel('Coh^2 (th, v2)')
