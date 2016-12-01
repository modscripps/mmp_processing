%% Revised on 08-Sep-2001 specifically for EPIC01
%
%		Calls m-scripts and functions to process a list of drops.
%	Before executing: 
%		0. cd to this folder (mymatlab/mmp/batchprocess).
%		1. Make a list of the drops to be processed as a vector named
%			'droplist', then '>> save droplist droplist' (in this folder).
%		2. Set up cruise subfolders under MMP on large disk 
%		 	accessible from this program. Processed data goes there.
%		3. Create mmplog.mat in cruise folder.  It should have 11 columns
%		4. Edit mmp\database for mmpid,sensors,etc. of drops being processed
%		5. Edit mymatlab\mmp\mmpfolders to define source of raw data
%			and destination of processed data
%		6. Execute set_mmp_paths so needed scripts can be found
%		7. Check and edit adjustable parameters below.
%          a. If low epsilon's are expected, set eps_step so lowest
%             wavenumber is 0.5 cpm or less
%
%	Files written are:
%		 1. MMP\<cruise>\mmplog.mat is updated for each drop
%		 2. MMP\<cruise>\pr\pr<drop>.mat  [pressure]
%		 3. MMP\<cruise>\tc\tc<drop>.mat  [temp,cond]
%		 4. MMP\<cruise>\ac\ac<drop>.mat  [altimeter]
%		 5. MMP\<cruise>\obs\obs<drop>.mat
%		 6. MMP\<cruise>\accel\a<drop>.mat
%		 7. MMP\<cruise>\kvh\kvh<drop>.mat  [hdg, mmp3]
%		 8. MMP\<cruise>\mag\mag<drop>.mat  [magnetometer, mmp3]
%		 9. MMP\<cruise>\vac\vac<drop>.mat  [ACM, mmp3]
%		10. MMP\<cruise>\eps\eps<drop>.mat
%		11. MMP\<cruise>\chi\chi<drop>.mat
%		12. MMP\<cruise>\fiber\fiber<drop>.mat [fiber-optic refractometer, mmp2s]
%

% This script used used for:
% cruise: EPIC01, drops>=12300
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
more=1;
%disp('Must verify that all config/printing files have been updated !!')
%x = input('Have they been? ', 's');
x='y';
switch x
case {'y','yes'}
   % disp('Okay, starting ...');
otherwise
   disp('Well, edit them and try again!');
   more = 0;
end

while more==1
   clear
   t0=clock;
   close all
      
   mmpfolders; 	% brings in path names of key directories
   warning off MATLAB:break_outside_of_loop
     
   % 	Get number of drop to process and delete that number from
   %	droplist in droplist.mat
   [drop,more]=getdrop_mmp;
   
   drop_LKWA = 0;
   if drop>14653 & drop<14800
       drop_LKWA = 1;
   end
   %% Parameters fixed by data structure
   FS_hf=400; 		  % sample rate of high-frequency channels
   FS_lf=25;		  % sample rate of low-frequency channels
   hfperscan=16; 	  % number of samples per scan in high-freq channels
   dt_hf=1/FS_hf; 	  % sample period of high-frequency channels 
   
   %% Adjustable parameters, for frequency-counted channels
   start_scan=2;		% first scan to keep (scan 1 is bad for SeaBird data)
   cond_shift=1; 		% no of scans to shift csbe forward & remove from end of others
   tcp_fc=3;			% cutoff freq for low-pass filter applied to temp,cond,pr
   cond='normal'; 	       % 'normal' for normal data in salt water, 
   % 'fresh' for fresh water,  csbe=zeros(size(tsbe))
   if drop_LKWA, cond='fresh'; end
	% 'bad' , set csbe=[]
   default_salinity=0.035;	   % For use in evaluating viscosity and diffusivity
   % when salinity is bad.
   
   %% Parameters for processing of microstructure data (epsilon and chi):
   %	Assignment to these variables has been moved down further in this
   %	program, just before 'setup_epschi3_mmp' in case any of them were
   %	re-set or cleared in the previous processing steps - Dave W
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   msg=['Processing drop=' int2str(drop)]; disp(msg)
   
   % drop_flag:  continue processing drop if drop_flag>0;
   %     drop_flag=1 => Create new processed data files and mmplog entries
   %			for drop, regardless of prior processing;
   %     drop_flag=2 => Extract info for subsequent batchprocessing from any
   %			existing data files or mmplog entries, create new ones only if
   %			they don't already exist.  (Added June 2000, Dave W)
   drop_flag=1; 			% continue processing while drop_flag==1
   
   get_dropinfo1G_mmp 	% gets & keeps mmpid, cruise, scanid, voffsetid for drop
   
   msg=['       by ' mmpid]; disp(msg); % to help operator verify mmpid setting

   write_droptime2G_mmp		% Reads year and yday from raw hdr and updates mmplog
   
   calc_prscan3G_mmp
   %% At this point, pr_scan,time,w,nscans,pmin,pmax,stop_scan are available,
   %		and mmplog.mat has been updated for drop limits (pr,time), data_quality.
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   calc_thetasd2G_mmp
   %% Returns: temp(in situ,low-passed), salinity(from lp'd t,c), pr_thetasd,
   %		tsbe(NOT lp'd), ss(sound speed), nthetasd(length of these vectors)
   
   %calc_dox1G_mmp % DOX sensors oozing brown goo on arrival in Istanbul.
   % 27-Mar-03 - repaired (at SeaBird) sensors put into use.
   % Returns:  dox(ml/l), pr_dox  - if installed, subsampled to one per scan.
   
   calc_hofp3G_mmp;
   %h_tsbe=[]; prh_tsbe=[]; pbot=[]; hout=[]; pout=[]; last_pbot=[]; 
   %% Returns: h_tsbe,prh_tsbe(ht,pr at SB sensors), pbot, hout,pout, last_pbot;
   %	hout,pout [vectors] = height,pres (at altimeter) saved in ac<drop>.mat,
   %	from which the deepest good record is chosen (and kept as scalars)
   %	to determine last_pbot [scalar], which is saved in mmplog.mat
  
   %calc_obs1G_mmp			% If obs is installed in one of the 400 Hz channels,
   % the data are low-passed, converted to FTUs, and subsampled to one per scan.
   
   % calc_accel1G_mmp
   % Returns: a, tilt = nscan-by-nch matrices of accel, tilt(degrees);
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%    %% The next three process data collected only by mmp3:
%    calc_kvh1G_mmp
%    % Returns hdg (degrees CW from North), magnetic_variation
%    calc_mag1G_mmp
%    % Returns: mag, nscan-by-3 matrix of sensor components (nT)
%    calc_vacm1G_mmp
%    % Returns: vac, nscan-by-2 matrix of acoustic current meter data (m/s),
%    % 	and pr_vac (pr at ACM); NO corrections for vehicle orientation or motion.
   %calc_fiber_mmp % mmp2s only
	%returns: fiber, a struct containing i1,i2,i3,i4 (output power from the photodiodes),
	%tld and trc (temp inside can) and crg (coupling ratio gradient).
	
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %% Parameters for processing of microstructure data (epsilon and chi)
   %eps_step=512; 	  	      % number of samples per epsilon estimate
   % use smaller window for higher resolution in sc99, but only prior to
   % configuring for slower fall rates after drop 8182 (0.25-0.3m/s)
   %if (drop>8182 & drop<11341) | (drop>12120 & drop<12126) 
   %   eps_step=1024; % drops slower than 0.39 m/s
  % end
   %eps_step=512+512; % test aug00 vs jul01 (orig used larger window)
   %chi_step=eps_step;	   % number of samples per chi estimate
   %tlpoly_degree=2;  % Degree of polynomial fitted to tl (part of chi calc)
   %scans_per_eps=fix(eps_step/hfperscan); % # scans per eps/chi estimate
   %df=FS_hf/eps_step; % elementary frequency bandwidth
  % f=(df:df:df*eps_step/2)'; % frequency vector for spectra
   % flags for microstructure spectra (require 'yes' to activate):
   %displ_shear_spec='no'; % plot each af shear spec with universal overlay
   %save_eps_spec='no';   % save all Pshear spec
   %displ_chi_spec='no';   % plot each th volt spec on screen
   %save_chi_spec='no';    % save all Ptgrad spec

   %% Prepare for epsilon and chi calculations   
  % setup_epschi3_mmp
   % Gathers the following quanities for each of neps (or nchi) data windows:
   %	cntr_scan, pr_eps, w_eps, t,s,kvis,ktemp, pr_chi [vectors]

  % calc_eps3G_mmp
   
   if 1==1  % skip chi, plotting for now (sc99) % try again, EPIC01>13461
      %calc_tl2_mmp
      
      %calc_chi3G_mmp
      
      %mainplot1_mmp
%       if mod(drop,1) == 2 % every 3rd one during home01, P.Bank
%          print -dwinc
%       end
     % print('-dpdf', fullfile(procdata,cruise,'figs','pdf',[num2str(drop) '_PL1.pdf']));
     % pause(2); fff1 = gcf;
      
     % motionplot1_mmp
    %  if mod(drop,1) == 2
    %     print -dwinc
    %  end
    %  print('-dpdf', fullfile(procdata,cruise,'figs','pdf',[num2str(drop) '_PL2.pdf']));
    %  pause(1)
      
    %  dstr=['  processing time = ' num2str(etime(clock,t0),3) ' seconds'];
      %disp(dstr)
    %  figure(1);pause
      %pause(2), figure(fff1); % to look before continuing during tests
   end
   
end %%%%%%%%%%% end of droplist while loop %%%%%%%%%%%%%

