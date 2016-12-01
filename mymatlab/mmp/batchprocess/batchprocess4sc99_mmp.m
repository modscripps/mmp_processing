% batchprocess4sc99_mmp
% 	A revision of batchprocess3_mmp, written in October 1996 to
% process data from the rebuilt mmp1 and mmp2 vehicles and the
% new mmp3.  Revised to take into account new altimeter calculations.
% J. MacKinnon

%		Calls m-scripts and functions to process a list of drops.
%	Before executing: 
%		1. Make a list of the drops to be processed as a column 
%	 		vector labeled droplist.  Save droplist in 
%			droplist.mat in this folder.
%		2. Set up cruise subfolder under MMP on large disk 
%		 	accessible from this program. Processed data goes 
%			there.
%		3. Create mmplog.mat in cruise folder.  It should have 11 columns
%		4. Edit mmp\mmpdatabase to include drops being processed
%		5. Edit mymatlab\mmp\mmpfolders to define source of raw data
%			and destination of processed data
%		6. Execute set_mmp_paths so needed scripts can be found
%		7. Check and edit adjustable parameters below.
%          a. If low epsilon's are expected, set eps_step so lowest
%             wavenumber is 0.5 cpm or less
%
%	Files written are:
%		1. MMP\<cruise>\timeplace.mat is updated with year & yday of drop
%		2. MMP\<cruise>\thetasd\thetasd<drop>.mat
%		3. MMP\<cruise>\eps\eps<drop>.mat
%		4. MMP\<cruise>\chi\chi<drop>.mat
%

% This script used used for:
% cruise: sc99, drops>=7700
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
more=1;
disp('Must verify that all config files have been updated !!')
x = input('Have they been? ', 's');
switch x
case {'y','yes'}
   disp('Okay, starting ...');
otherwise
   disp('Well, edit them and try again!');
   more = 0;
end

while more==1
   clear
   t0=clock;
   close all
      
   mmpfolders; 	% brings in path names of key directories
     
   
   % 	Get number of drop to process and delete that number from
   %	droplist in droplist.mat
   [drop,more]=getdrop_mmp;
   

   % Constants
   global G
   G=9.80655;
   MAG_DECLINATION=0; % for nowhere
   
   % adjustable parameters
   start_scan=2;     	   % first scan to keep (scan 1 is bad for SeaBird data)
   cond_shift=1;     	   % no of scans to shift csbe forward & remove from end of 
   % other ch
      
   eps_step=512; 	  	      % number of samples per epsilon & estimate
   % Use smaller window for higher resolution in sc99,
   % but increase for slower falling drops (0.25-0.3m/s)
   if drop>8182
      eps_step=1024;
   end

   tcp_fc=3;			   	% cutoff freq for low-pass filter applied to temp,cond,pr
   chi_step=eps_step;	   % number of samples per chi estimate
   cond='normal'; 	       % 'normal' for normal data in salt water, 
   % 'fresh' for fresh water,  csbe=zeros(size(tsbe))
   % 'bad' , set csbe=[]
   default_salinity=0.035;	   % For use in evaluating viscocity and diffusivity
   % when salinity is bad.
   displ_shear_spec='no'; % plot each af shear spec with universal overlay
   save_eps_spec='no';   % save all Pshear spec
   displ_chi_spec='no';   % plot each th volt spec on screen
   save_chi_spec='no';    % save all Ptgrad spec
   %
   % parameters fixed by data structure
   FS_hf=400; 		  % sample rate of high-frequency channels
   FS_lf=25;		  % sample rate of low-frequency channels
   hfperscan=16; 	  % number of samples per scan in high-freq channels
   tlpoly_degree=2;  % Degree of polynomial fitted to tl
   %
   % secondary parameters
   dt_hf=1/FS_hf; 	  % sample period of high-frequency channels 
   scans_per_eps=fix(eps_step/hfperscan); % # scans per eps estimate
   df=FS_hf/eps_step; % elementary frequency bandwidth
   f=(df:df:df*eps_step/2)'; % frequency vector for spectra
   %
   global G
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
   msg=['drop=' int2str(drop)]; disp(msg)
   drop_flag=1; 			% continue processing while drop_flag==1
   
   get_dropinfo1_mmp 		% gets & keeps mmpid, cruise, scanid, voffsetid for drop
   %   then loads & keeps offset_ch where ch is v1,v2, etc.
   msg=[' by ' mmpid]; disp(msg)

   write_droptime2_mmp		% Reads year and yday from raw hdr and updates mmplog
   
   calc_prscan2_mmp
   
   calc_thetasd2_mmp
   
   calc_kvh1_mmp
   
   calc_accel1_mmp			% Reads accelerometers
   
   calc_hofp2_mmp      % Writes (height,pressure) pair nearest bottom into mmplog
   
   calc_vacm1_mmp			% Converts acoustic current meter data, channels vac1 & vac2,
   % to m/s, but does not correct for vehicle orientation							
   
   calc_obs1_mmp			% If obs is installed in one of the 400 Hz channels,
   % the data are low-passed, converted to FTUs, and
   % subsampled to one per scan.
   setup_epschi2_mmp
   
   calc_eps3_mmp
   
   if 1==0  % skip chi, plotting for now (sc99) (also mag for mmp3)
      calc_tl2_mmp
      
      calc_chi2_mmp
      
      mainplot1_mmp
      %print -dwinc
      pause(1)
      
      motionplot1_mmp
      %print -dwinc
      pause(1)
      
      dstr=['  processing time = ' num2str(etime(clock,t0),3) ' seconds'];
      disp(dstr)
   end
end %%%%%%%%%%% end of droplist while loop %%%%%%%%%%%%%