% plot_acceleration.m
% plot_acceleration.m is a script for examining a1 and a2
% records during instrument testing.  It plots low-passed records
% as tilt and plots spectra of the full acceleration profiles,
% outside the extreme ends of the profiles.
% M.Gregg, 11jul96

FS_a1=400;
FS_a2=400;
FS_a3=50;
FS_a4=50;
SCAN=16; % number of data cycles in a scan
SS=8; % subsample factor to match a3 & a4 on mmp3
S1=7; % first subsample in scan

mmpfolders

drop=input('drop number: ','s');
drop=fix(str2num(drop));

mmpid=read_mmpid(drop);

[a1,tilt1]=accel1_mmp('a1',drop,mmpid);
[a2,tilt2]=accel1_mmp('a2',drop,mmpid);
n=length(tilt1);
t=(1:n)/FS_a1; t=t(:); % elapsed time

[b,a]=butter(4,SS/FS_a1);

% Remove sections of data with NaNs, assuming that
% they occur at the beginning and end, i.e. during launch
% and turn-aroundinan=find(isnan(tilt1) | isnan(tilt2));
if ~isempty(inan)
   max_nan=max(inan); min_nan=min(inan);
   if t(max_nan)< 10   % NaNs only at the start
      new_start=ceil(max_nan+1/SCAN); % start at the start of a scan
      tilt1=tilt1(new_start:n); a1=a1(new_start:n);
      tilt2=tilt2(new_start:n); a2=a2(new_start:n);
      t=t(max_nan+1:n);
   elseif min_nan>0.9*n; % NaNs only at the end
      tilt1=tilt1(1:min_nan-1); a1=a1(1:min_nan-1);
      tilt2=tilt2(1:min_nan-1); a2=a2(1:min_nan-1);
      t=t(1:min_nan-1);
   end
end   

% Low-pass the tilts and subsample rows 7 & 15 of a scan to
% select a1 & a2 simultaneous with a3 and a4 for mmp3
tilt1lp=filtfilt(b,a,tilt1);
tilt2lp=filtfilt(b,a,tilt2);
tilt1lp=tilt1(S1:SS:length(tilt1));
tilt2lp=tilt2(S1:SS:length(tilt2));
tlp=t(S1:SS:length(t)); tlp=tlp(:);
tlpmax=max(tlp); tlpmin=min(tlp);
nlp=length(tilt1lp);

% Set up plotting scales for tilt profiles
tstart=0; tstop=tlpmax;
std_1=std(tilt1lp); std_2=std(tilt2lp);
stdt=max(std_1,std_2);
cntr_1=median(tilt1lp); cntr_2=median(tilt2lp);
axis1=[cntr_1-2*stdt cntr_1+2*stdt tstart tstop];
axis2=[cntr_2-2*stdt cntr_2+2*stdt tstart tstop];

% Compute standard deviations in the center of the record
ic=find(tlp>0.2*tlpmax & tlp<0.8*tlpmax);
std_tilt1lp=std(tilt1lp(ic));
std_tilt2lp=std(tilt2lp(ic));


% Calculate largest spectrum possible in data away from
% surface and bottom jerksitspec=find(t>tstart & t<tstop);
n2=fix(log10(length(itspec))/log10(2));
[Pa1,f]=psd(a1(itspec),2^(n2),FS_a1);
Pa1=Pa1/(FS_a1/2);
Pa2=psd(a2(itspec),2^(n2),FS_a2);
Pa2=Pa2/(FS_a2/2);
fmin=f(2); fmax=max(f);

% Plot
f1=figure;
wysiwyg
subplot(2,2,1)
plota1=plot(tilt1lp,tlp);
axis(axis1)
set(gca,'ydir','reverse')
title_str=[mmpid ', drop=' int2str(drop) ', data subsampled by' ...
      ' factor of ' int2str(SS)];
title(title_str)
xlabel('tilt1 / \degrees'), ylabel('time / seconds')

subplot(2,2,2)
plota2=plot(tilt2lp,tlp);
axis(axis2)
set(gca,'ydir','reverse')

xlabel('tilt2 / \degrees'), ylabel('time / seconds')
title2_str=['std_tilt1lp=' num2str(std_tilt1lp,3) ...
      ', std_tilt2lp=' num2str(std_tilt2lp,3)];
title(title2_str)

subplot(2,2,3)
plotPa1=loglog(f,Pa1);
axis([fmin fmax 1e-10 1e0])
grid on
xlabel('f / Hz')
ylabel('\12\times\Phi_{a1} / (m s^{-2})^2 /Hz')
title_str=['full a2, a2 between ' num2str(tstart,4) ' and ' ...
      num2str(tstop,4)];
title(title_str)

subplot(2,2,4)
plotPa2=loglog(f,Pa2);
axis([fmin fmax 1e-10 1e0])
grid on
xlabel('f / Hz')
ylabel('\12\times\Phi_{a2} / (m s^{-2})^2 /Hz')