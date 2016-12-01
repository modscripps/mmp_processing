%function vacmv1spec_mmp(drop,cruise,mmpid)
% Usage: a1a2v1v2spec_mmp(drop, prstart, prstop,cruise,mmpid)
%   inputs:
%     drop:integer mmp drop number
%     prstart, prstop: pressure limits of data to be analyzed
%     cruise: string cruise name, optional
%     mmpid: string vehicle id, optional
% Function: plots data, spectra, and coherence-squared for
%  a1, a2, v1, v2.  Spectra are computed for blocks of 1024 values.
% M.Gregg, 20jul96

HF_PER_SCAN=16; % # of high-frequency samples per scan
V1sps=200; % sample rate of airfoil channels, v1 & v2
VACsps=25; % sample rate of vac data written to disk
G=9.90655; % gravity

mmpfolders

if nargin<2
   cruise=read_cruises_mmp(drop);
end
if nargin<3
   mmpid=read_mmpid(drop);
end

% Load vac<drop>.mat
vac_file=[procdata '\' cruise '\vac\vac' int2str(drop) '.mat'];
if exist(vac_file)==2
   ldvac_str=['load ' setstr(39) vac_file setstr(39)];
   eval(ldvac_str)
else
   vac_msg=['vacmv1spec_mmp: ' vac_file ' not found.'];
   disp(vac_msg)
   vac_flag='n';
end

% Read v1 & v2
v1=atod1_mmp(read_rawdata_mmp('v1', drop));
v2=atod1_mmp(read_rawdata_mmp('v2', drop));

% To select v1 & v2 samples, load pr<drop>.mat if it exists
pr_file=[procdata '\' cruise '\pr\pr' int2str(drop) '.mat'];
if exist(pr_file)==2
   ldpr_str=['load ' setstr(39) pr_file setstr(39)];
   eval(ldpr_str)
   pr_v1=pr_offset1_mmp(drop,'v1',pr_scan);
else
   pr_msg=['vacmv1spec_mmp: ' pr_file ' not found.'];
   disp(pr_msg)
   do_spectra='n';
end

do_spectra='y';
while strcmp(do_spectra,'y')
   prstart=input('Enter prstart, or a negative number to stop processing ');
   if prstart<0 
      break 
   end;
   prstop=input('Enter prstop, or a negative number to stop processing ');
   if prstop<0 
      break 
   end;
   %
   % Take spectra of vac1 and vac2 and convert to wavenumber
   ivac=find(pr_vac>=prstart & pr_vac<=prstop);
   [Pvac1,fvac]=psd(vac(ivac,1),512,VACsps); Pvac1=Pvac1/(VACsps/2);
   Pvac2=psd(vac(ivac,2),512,VACsps); Pvac2=Pvac2/(VACsps/2);
   speed=100*(pr_vac(ivac(length(ivac)))-pr_vac(ivac(1)))/(length(ivac)/VACsps);
   kvac=fvac/speed;  Pvack1=speed*Pvac1; Pvack2=speed*Pvac2;
   % 
   % Take spectra of v1 & v2
   iv1=find(pr_v1>=prstart & pr_v1<=prstop);
   istart_v1=HF_PER_SCAN*iv1(1);
   istop_v1=HF_PER_SCAN*iv1(length(iv1));
   [Pv1f,fv1]=psd(v1(istart_v1:istop_v1),512,V1sps); Pv1=Pv1/(V1sps/2);
   Pv2f=psd(v2(istart_v1:istop_v1),512,V1sps); Pv2=Pv2/(V1sps/2);
   kv1=fv1/speed;  %
   % Scale Pv1 to velocity spectrum
   [sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('v1',mmpid,drop);
   if strcmp(sensorid,'[]')==1
      str=['  no airfoil probe for ' ch ]; disp(str);
      data_flag=0; % Will affect only current channel, i.e. i value
   else
      data_flag=1;
      calid=read_whichcal_mmp('af',sensorid,drop);
      [Sv,Cs]=read_af_cal(sensorid, calid);
      str1=['helectronics=helectronics_' electronicsid '(Cs,fv1);'];
      eval(str1); % evaluate electronics transfer function
      str1=['[hfilt,pfilt]=' filter '(fv1,fc);'];
      eval(str1)  % evaluate anti-alias filter transfer fcn
      h_freq=helectronics .* hfilt;
      htotal=(Sv*speed/(2*G))^2 * h_freq .* haf_oakey(fv1,speed);
      Pv1k=(Pv1f*speed) ./ htotal; % vel spec as function of k	
   end
   
   break
   % Calculate box positions
   Hf_mp=figure;
   orient tall
   wysiwyg
   x0=0.122; xgap=.03; width=(0.95-x0-xgap)/2;
   y0=0.08; ygap=.005; height=(0.92-y0-4*ygap)/4;
   a_pos=[x0 y0+3*(height+ygap) width height]; % a1, a2 time series
   v_pos=[x0+width+xgap y0+3*(height+ygap) width height]; % v1, v2 time series
   v1sp_pos=[x0 y0+2*(height+ygap) width height]; % v1 spectrum
   v2sp_pos=[x0+width+xgap y0+2*(height+ygap) width height]; % v2 spectrum
   a1sp_pos=[x0 y0+(height+ygap) width height]; % a1 spectrum
   a2sp_pos=[x0+width+xgap y0+(height+ygap) width height]; % a2 spectrum
   a1v1sp_pos=[x0 y0 width height]; % a1v1 cross-spectrum
   a1v2sp_pos=[x0+width+xgap y0 width height]; % a2v2 cross-spectrum
   
   % plot a1 & a2
   axes('position',a_pos,'box','on','xticklabel','','ticklength',[.03 .025])
   hold on
   Hl_a1=plot(a1,'r');
   set(Hl_a1,'linewidth',[1.5])
   Hl_a2=plot(a2,'g');
   yamax=max([a1(:); a2(:)]); yamin=min([a1(:); a2(:)]);
   xmax=length(a1);axis([1 xmax yamin yamax])
   ylabel('a1(thick) ,a2 / V')
   title_str=[mmpid ', drop=' int2str(drop) ', ' num2str(prstart,4) ' to ' ...
         num2str(prstop,4) ' MPa'];
   title(title_str)
   
   % plot v1 & v2
   axes('position',v_pos,'box','on','yticklabel','', ...
      'xticklabel','','ticklength',[.03 .025])
   hold on
   stdv1=std(v1); stdv2=std(v2);
   vshift=3*max(stdv1,stdv2);
   Hl_v1=plot(v1-vshift,'r');
   set(Hl_v1,'linewidth',[1.5])
   Hl_v2=plot(v2+vshift,'g');
   yvmax=max([v1(:)-vshift; v2(:)+vshift]); yvmin=min([v1(:)-vshift; v2(:)+vshift]);
   xmax=length(v1);
   axis([1 xmax yvmin yvmax])
   ylabel('v1 ,v2 / V')
   title_str=['v1 offset down, v2 offset up'];
   title(title_str)
   
   % calculate  spectra & cross-spectra
   [Pv1,f]=psd(v1,1024,400);
   Pv1 = Pv1 / 200;
   [Pa1,f]=psd(a1,1024,400);
   Pa1 = Pa1 / 200;
   Ca1v1=cohere(a1,v1,1024,400);
   [Pv2,f]=psd(v2,1024,400);
   Pv2 = Pv2 / 200;
   [Pa2,f]=psd(a2,1024,400);
   Pa2 = Pa2 / 200;
   Ca1v2=cohere(a1,v2,1024,400);
   
   fmin=f(2); fmax=200;
   minPv=1e-8; maxPv=1e-2;
   minPa=1e-9; maxPa=1e-4;
   
   % Plot v1 spectrum
   axes('position',v1sp_pos,'box','on','xticklabel','', ...
      'xscale','log','yscale','log','ticklength',[.03 .025])
   hold on
   plot(f,Pv1,'r')
   axis([fmin fmax minPv maxPv])
   ylabel('Pv1 / V^2 / Hz')
   grid on
   
   % Plot a1 spectrum
   axes('position',a1sp_pos,'box','on','xticklabel','','xscale', ...
      'log','yscale','log','ticklength',[.03 .025])
   hold on
   plot(f,Pa1,'r')
   axis([fmin fmax minPa maxPa])
   ylabel('Pa1 / V^2/Hz')
   grid on
   
   
   % Plot a1v1 cross-spectrum
   axes('position',a1v1sp_pos,'box','on','xscale','log', ...
      'yscale','linear','ticklength',[.03 .025])
   hold on
   plot(f,Ca1v1,'r')
   axis([fmin fmax 0 1])
   xlabel('f / Hz'), 
   label('Coh^2 (a1, v1)')
   grid
   
   % Plot v2 spectrum			
   axes('position',v2sp_pos,'box','on','yticklabel','','xticklabel','', ...
      'xscale','log','yscale','log','ticklength',[.03 .025])
   hold on
   loglog(f,Pv2,'g')
   axis([fmin fmax minPv maxPv])
   ylabel('Pv2 / V^2 / Hz')
   grid on
   %title(['MMP ' , num2str(drop), ' : ' prstart ' - ' prstop ' MPa'])
   
   % Plot a2 spectrum
   axes('position',a2sp_pos,'box','on','yticklabel','','xticklabel','', ...
      'xscale','log','yscale','log','ticklength',[.03 .025])
   hold on
   loglog(f,Pa2,'g')
   axis([fmin fmax minPa maxPa])
   ylabel('Pa2 / V^2 / Hz')
   grid on
   % Plot a1v2 cross-spectrum
   axes('position',a1v2sp_pos,'box','on','yticklabel','', ...
      'xscale','log','yscale','linear','ticklength',[.03 .025])
   hold on
   semilogx(f,Ca1v2,'g')
   axis([fmin fmax 0 1])
   xlabel('f / Hz'), ylabel('Coh^2 (a1, v2)')
   grid
   
   print -dwinc
   pause(10)
end