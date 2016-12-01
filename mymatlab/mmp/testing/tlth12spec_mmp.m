function [Ptl1,Ptl2,Pth1,Pth2,f]=tlth12spec_mmp(drop, prstart, prstop, cruise, mmpid)
%   inputs:
%     drop:integer mmp drop number
%     prstart, prstop: pressure limits of data to be analyzed
%     cruise: string cruise name, optional
%     mmpid: string vehicle id, optional
% Function: plots data, spectra, and coherence-squared for
%  tl1, tl2, th1, th2.  Spectra are computed for blocks of 1024 values.
% M.Gregg, 20jul96 - revise mar02 for thinistor tests

HF_PER_SCAN=16; % # of high-frequency samples per scan
NFFT=1024; % Default length of spectrum.  Will be decreased
% if necessary to take at least two blocks.

   cruise=read_cruises_mmp(drop);
	mmpid=read_mmpid(drop);

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
   msg1=['tlth12spec_mmp: drop ' int2str(drop) ' has no pr_scan> 0.'];
   msg2=['   Check that database\config\mmpid has been updated.'];
   disp(msg1), disp(msg2)
end

% Find maximum pressure and the corresponding index for pr_scan
ig=find(~isnan(pr_scan));
maxpr=max(pr_scan(ig));
imaxpr=find(pr_scan==maxpr);

pr=pr_offset1_mmp(drop,'tl1',pr_scan(1:imaxpr(1)));

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

% Find start and stop sample numbers for 400-Hz data
istart=i0*HF_PER_SCAN;
istop=i1*HF_PER_SCAN;
ispectra=istart:istop;
npts=length(ispectra);

% Compare npts with NFFT and reduce if necessary 
while npts<2*NFFT
   NFFT=NFFT/2;
end

ch1='tl1'; ch2='tl2'; ch3='th1'; ch4='th2';
% get data between prstart & prstop
da1=atod1_mmp(read_rawdata_mmp(ch1, drop));
da1=da1(ispectra);
da2=atod1_mmp(read_rawdata_mmp(ch2, drop));
da2=da2(ispectra);
da3=atod1_mmp(read_rawdata_mmp(ch3, drop));
da3=da3(ispectra);
da4=atod1_mmp(read_rawdata_mmp(ch4, drop));
da4=da4(ispectra);

% Calculate box positions
Hf=figure;
set(Hf,'position',[158 77 634 631]);
orient tall
x0=0.122; xgap=.035; width=(0.95-x0-xgap)/2;
y0=0.08; ygap=.005; height=(0.92-y0-3*ygap)/4;
a_pos=[x0 y0+3*(height+ygap) width height]; % ch1,ch2 time series
v_pos=[x0+width+xgap y0+3*(height+ygap) width height]; % ch3,ch4 time series
v1sp_pos=[x0 y0+2*(height+ygap) width height]; % ch1 spectrum
v2sp_pos=[x0+width+xgap y0+2*(height+ygap) width height]; % ch2 spectrum
a1sp_pos=[x0 y0+(height+ygap) width height]; % ch3 spectrum
a2sp_pos=[x0+width+xgap y0+(height+ygap) width height]; % ch4 spectrum
a1v1sp_pos=[x0 y0 width height]; % ch1-ch2 cross-spectrum
a1v2sp_pos=[x0+width+xgap y0 width height]; % ch3-ch4 cross-spectrum

% plot ch1 & ch2
ha_a1a2=axes('position',a_pos);
set(ha_a1a2,'box','on','xticklabel','','ticklength',[.03 .025]);
hold on
da1=da1-mean(da1); da2=da2-mean(da2);
hl_a1=plot(da1,'r');
hl_a2=plot(da2,'g');
yamax=max(max(da1),max(da2)); yamin=min(min(da1),min(da2));
xmax=length(da1);
axis([1 xmax yamin yamax])
title_str=[mmpid ', dr=' int2str(drop) ', ' num2str(prstart,4) '-' ...
      num2str(prstop,4) ' MPa,\fontsize{8} NFFT=' ...
      int2str(NFFT) '/' num2str(length(da1)) '\rm            '];
title(title_str)
ylabel([ch1 '(rd) ,' ch2 '(gn) / V']);

% plot ch3 & ch4
ha_v1v2=axes('position',v_pos);
hold on
stda3=std(da3); stda4=std(da4);
vshift=3*max(stda3,stda4);
hl_v1=plot(da3-vshift,'r');
hl_v2=plot(da4+vshift,'g');
yvmax=max(max(da3-vshift),max(da4+vshift)); 
yvmin=min(min(da3-vshift),min(da4+vshift));
xmax=length(da3);
axis([1 xmax yvmin yvmax])
set(ha_v1v2,'box','on','xticklabel','','ticklength',[.03 .025]);
set(ha_v1v2,'yaxislocation','right');
title_str=['          w=' num2str(w,3) ' m/s, ymax=' num2str(yvmax,4) ...
      ',ymin=' num2str(yvmin,4) ' V'];
title(title_str)
set(ha_v1v2,'ytick',[],'xtick',[]);
ylabel([ch3 ',' ch4 ' / V'])

% Calculate  spectra
%dmflag='none';
dmflag='mean';
[Pch1,f]=psd(da1,NFFT,400,NFFT,NFFT/2, dmflag);
Pch1 = Pch1 / 200;
[Pch2,f]=psd(da2,NFFT,400,NFFT,NFFT/2, dmflag);
Pch2 = Pch2 / 200;
[Pch3,f]=psd(da3,NFFT,400,NFFT,NFFT/2, dmflag);
Pch3 = Pch3 / 200;
[Pch4,f]=psd(da4,NFFT,400,NFFT,NFFT/2, dmflag);
Pch4 = Pch4 / 200;
% coherences^2
Csq12=cohere(da1,da2,NFFT,400,NFFT);
Csq34=cohere(da3,da4,NFFT,400,NFFT);
Csq13=cohere(da1,da3,NFFT,400,NFFT);
Csq24=cohere(da2,da4,NFFT,400,NFFT);

maxPv=max(max(Pch1),max(Pch2));
maxfv=max(max(Pch1(find(f<40))),max(Pch2(find(f<40))));
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
% Plot ch1 (tl1) spectrum
ha_v1=axes('position',v1sp_pos);
loglog(f,Pch1,'r')
axis([frmin frmax 1e-11 1e-6])
%axis([frmin frmax minPv maxPv])
ylabel(['P' ch1 ' / V ^2 /Hz'])
set(ha_v1,'ytick',[10.^[-10:1:-6]]);
set(ha_v1,'box','on','xticklabel','','xscale','log')
set(ha_v1,'yscale','log','ticklength',[.03 .025]);
grid on

% Plot ch3 (th1) spectrum
ha_a1=axes('position',a1sp_pos);
loglog(f,Pch3,'r')
axis([frmin frmax 1e-10 1e-4])
ylabel(['P' ch3 ' / V ^2 /Hz'])
set(ha_a1,'ytick',[10.^[-9:1:-5]]);
set(ha_a1,'box','on','xticklabel','','xscale','log')
set(ha_a1,'yscale','log','ticklength',[.03 .025]);
grid on

% Plot ch1-ch2 cross-spectrum
ha_a1v1=axes('position',a1v1sp_pos);
semilogx(f,Csq12,'r',f,Csq13,'g--')
axis([frmin frmax 0 1])
xlabel('f / Hz')
ylabel(['Coh^2 (' ch1 '>' ch2 ',' ch3 ')'])
set(ha_a1v1,'box','on','xscale','log','ticklength',[.03 .025]);
grid on

% Plot ch2 (tl2) spectrum			
ha_v2=axes('position',v2sp_pos);
hold on
loglog(f,Pch2,'g')
loglog(f,Pch1,'r')
axis([frmin frmax 1e-11 1e-6])
%axis([frmin frmax minPv maxPv])
set(ha_v2,'ytick',[10.^[-10:1:-7]]);
set(ha_v2,'box','on','xticklabel','','xscale','log');
set(ha_v2,'yscale','log','ticklength',[.03 .025],'yticklabel','');
grid on
ylabel(['P' ch2 ' / V ^2 / Hz'])

% Plot ch4 (th2) spectrum
ha_a2=axes('position',a2sp_pos);
hold on
loglog(f,Pch3,'r')
loglog(f,Pch4,'g')
axis([frmin frmax 1e-10 1e-4])
set(ha_a2,'ytick',[10.^[-9:1:-5]]);
set(ha_a2,'box','on','xticklabel','','xscale','log')
set(ha_a2,'yscale','log','ticklength',[.03 .025],'yticklabel','');
grid on
ylabel(['P' ch4 ' / V ^2 / Hz'])

% Plot ch3-ch4 cross-spectrum
ha_a1v2=axes('position',a1v2sp_pos);
semilogx(f,Csq34,'g',f,Csq24,'r--')
axis([frmin frmax 0 1])
xlabel('f / Hz')
set(ha_a1v2,'box','on','ticklength',[.03 .025]);
set(ha_a1v2,'yticklabel','');
grid on
ylabel(['Coh^2 (' ch3 ',' ch2 '>' ch4 ')'])
