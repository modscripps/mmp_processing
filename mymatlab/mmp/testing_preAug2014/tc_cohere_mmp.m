function tc_cohere_mmp(drop,cruise,mmpid)
% Usage: tc_cohere_mmp(drop,cruise,mmpid)
%  Inputs:
%    drop: integer drop number
%    cruise: string cruise name, e.g. 'cmo96', optional
%    mmpid: string vehicle id, e.g. 'mmp3', optional
%  Function: Plots SBE temperature and conductivity between
%    more than 500 samples from either end of record and takes
%    and plots their coherence-squared and phase.
%  M.Gregg, aug96

NFFT=256;
FS=25;

mmpfolders

if nargin<2
   cruise=read_cruises_mmp(drop);
end
if nargin<3
   mmpid=read_mmpid(drop);
end

tc_file=[procdata '\' cruise '\tc\tc' int2str(drop) '.mat'];
if ~exist(tc_file)
   msg=['tc_cohere_mmp: ' tc_file ' does not exist.'];
   disp(msg)
else
   ld_str=['load ' setstr(39) tc_file setstr(39)];
   eval(ld_str)
   
   n=length(tsbe);
   
   [P,f]=spectrum(tsbe(500:n-500),csbe(500:n-500),NFFT,NFFT/2,NFFT,FS);
   phase=angle(P(:,4)).*(180/(2*pi));
   
   figure
   orient tall
   
   % Plot tsbe
   subplot(4,1,1)
   plot(tsbe)
   xlabel('sample number'), ylabel('tsbe / deg C')
   title_str=[mmpid ', drop=' int2str(drop)];
   title(title_str)
   
   % Plot csbe
   subplot(4,1,2)
   plot(csbe)
   xlabel('sample number'), ylabel('csbe / S/m')
   
   subplot(4,1,3)
   semilogx(f,P(:,5))
   axis([.1, (FS/2),0,1])
   grid on
   xlabel('f / Hz'), ylabel('Coh_sq')
   
   subplot(4,1,4)
   semilogx(f,phase)
   axis([.1, (FS/2),-180,180])
   grid on
   xlabel('f / Hz'), ylabel('Phase / degrees')
end