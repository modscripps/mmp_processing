% volt_spec_mmp
%   Usage: volt_spec_mmp
%   Function: plots a full drop of high-frequency data and
%      computes and displays one or more spectra of the
%      voltage signal spectrum versus frequency.  Uses inputs
%      to obtain drop number, channel, and sample numbers
%      for computing spectra.

% primary parameters
FS=400; % sample frequency
DT = 1/ FS;
NFFT=512;

% secondary parameters
df=FS/NFFT;
f=(df:df:df*NFFT/2);

% plotting limits
PVMAX=1e-3;
PVMIN=1e-10;
fMAX=max(f);
fMIN=min(f);

% get drop and channel as inputs
drop_str=input('Drop: ', 's');
drop=str2num(drop_str);
ch=input('Channel: ', 's');

mmpid=read_mmpid(drop);
%cruise=read_cruises_mmp(drop);
[scanid,voffsetid]=read_config_mmp(mmpid,drop);


% get data with samplenos in idata
[sensorid,electronicsid,filter,fc,scanpos] = ...
   read_chconfig_mmp(ch,mmpid,drop);	
data=read_rawdata_mmp(ch, drop, scanid,scanpos);
data=atod1_mmp(data);

% plot data?
plot_data=input('Plot data? ', 's');
if strcmp(plot_data,'y')==1 | strcmp(plot_data,'yes')==1
   figure
   plot(data)
   xlabel('sample number')
   str=[ch ' / volts'];
   ylabel(str)
   str=['mmp' int2str(drop)];
   title(str)
end


DoSpec=input('Compute and Display Spectrum? ', 's');
if strcmp(DoSpec,'y')  == 1 | strcmp(DoSpec,'yes')==1
   while strcmp(DoSpec,'yes')==1 | strcmp(DoSpec,'y')==1
      start_str=input('Start at sample number: ', 's');
      start=str2num(start_str);
      stop_str=input('Stop at sample number: ', 's');
      stop=str2num(stop_str);
      
      % calculate  spectra
      [P,f]=psd(data(start:stop), 512, FS,[],256);
      P = P / (FS/2);
      
      % plot spectra
      figure
      loglog(f,P)
      fmax=FS/2; fmin=min(f);
      axis([fMIN fMAX PVMIN PVMAX])
      xlabel('f / Hz')
      str=['P' ch ' / volts^2 / Hz'];
      ylabel(str)
      grid on
      str=['mmp' drop_str ', channel: ' ch ', samples: ' start_str ' - ' stop_str];
      title(str)
      
      print_str=input('Print the spectrum? ', 's');
      if strcmp(print_str,'y')==1 | strcmp(print_str,'yes')==1
         print
      end
      
      DoSpec=input('Compute Another Spectrum? ', 's');
   end		
end
