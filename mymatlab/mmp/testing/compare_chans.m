% compare_chans.m - check for timing and extent of spikes in mmp2 channels
%drop=12302;
load(['C:\mmp\WaWaves14\pr\pr' num2str(drop)])
%load(['c:\mmp\feb02\pr\pr' num2str(drop)])
%load(['C:\mmp\mc09\pr\pr' num2str(drop)])
cruise=read_cruises_mmp(drop);
mmpid=read_mmpid(drop);

figure(1); clf
plot(pr_scan); title(['pressure, ' mmpid ' drop ' num2str(drop)])
cruise=read_cruises_mmp(drop);
mmpid=read_mmpid(drop);

% scan rate channels:
fpr = pr_freq_mmp(drop);
ft = tsbe_freq_mmp(drop);
fcn = csbe_freq_mmp(drop);
prt = atod1_mmp(read_rawdata_mmp('prt',drop));
vb = atod1_mmp(read_rawdata_mmp('vb',drop))*4;
sg = atod1_mmp(read_rawdata_mmp('sg',drop));
ac = atod1_mmp(read_rawdata_mmp('ac',drop));
idw = read_rawdata_mmp('id',drop);
scLO=1:length(fpr);
chLO={'fpr';'ft';'fcn';'idw';'vb';'sg';'prt';'ac'};
% could add more for mmp3, some at 2/scan (a3,a4, mx,my,mz, kvh, vac1,vac2)

% high-freq channels:
chHI={'a1','a2','v1','v2'};
scHI=[1:length(scLO)*16]/16 + 1/2;
switch mmpid
    case {'mmp1','mmp2'}
        %chHI = {'obs','tl1','th1',chHI{1:end}}; % aesop (2006)
        chHI = {'dox','tl2','th2',chHI{1:end}}; % EPIC 01, ML04(lk)
        %chHI = {'tl1','th1','tl2','th2',chHI{1:end}}; % feb02
    case 'mmp4'
        chHI = {'tl1','th1','tl2','th2',chHI{1:end}};
    case 'mmp3'
        chHI = {'obs','tl1','th1',chHI{1:end}}; % EPIC 01
end

for ic=1:length(chHI)
   str=[chHI{ic} '= atod1_mmp(read_rawdata_mmp(''' chHI{ic} ''',drop));'];
   eval(str)
end

%% Find where selected channel exceeds threshold, mark on other channels:
%iprs=find(abs(diff(fpr))>.0015); % pres spike threshold (may miss smaller ones)
iprs=find(diff(fcn)>3e-4*10 | diff(fcn)<-3e-3*10);
iprH=iprs*16-8;

%iprH = find(scHI(2:end)'>2000 & abs(diff(a1))>0.01);
%iprs = round(iprH/16);
%ix = find(iprs-length(scLO)>-1);
%iprs(ix)=[];
if isempty(iprs), iprs = 1; end
if isempty(iprH), iprH = 1; end

figure(2)
for ic=1:length(chLO)
   figure(2); clf; eval(['dch=diff(' chLO{ic} ');']);
   xx=['plot(scLO,' chLO{ic} ',''-'',scLO(iprs),' chLO{ic} '(iprs),''r.'')'];
   subplot(2,1,2); eval(xx),ylabel('ch');xlabel('scanno'), zoom on
   subplot(2,1,1); plot(scLO(2:end),dch,'-',scLO(iprs),dch(iprs),'g.');
   ylabel('d(ch)'); zoom on
   title([mmpid ' drop ' num2str(drop) ' ch=' chLO{ic}])
   pause  
end

%return
for ic=1:length(chHI)
   figure(2); clf; eval(['dch=diff(' chHI{ic} ');']);
   xx=['plot(scHI,' chHI{ic} ',''-'',scHI(iprH),' chHI{ic} '(iprH),''r.'')'];
   subplot(2,1,2); eval(xx),ylabel('ch');xlabel('scanno'), zoom on
   subplot(2,1,1); plot(scHI(2:end),dch,'-',scHI(iprH),dch(iprH),'g.');
   ylabel('d(ch)'); zoom on
   title([mmpid ' drop ' num2str(drop) ' ch=' chHI{ic}])
   pause
end
