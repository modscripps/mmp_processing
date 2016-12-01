% calc_dox1G_mmp_wREV.m
%   Usage: Called within batchprocess4G_mmp
%   Function: Calculate dissolved oxygen in ml/l
%	Input: drop,mmpid,cruise,procdata, tsbe,salinity,pr_thetasd
%	Output: dox, pr_dox
% D.Winkel - july, 2001

if (drop_flag==1 | drop_flag==2) & (strcmp(mmpid,'mmp1') | strcmp(mmpid,'mmp2'))
   do_fil = [procdata filesep  cruise filesep 'dox' filesep 'dox' int2str(drop) '.mat'];
   do_filC = [procdata filesep  cruise filesep 'dox' filesep 'dox' int2str(drop) '_wREV.mat'];
   dox=[]; pr_dox=[];
   
   if exist(do_fil)==2 & ~exist(do_filC)
       copyfile(do_fil, do_filC), disp(['Copied ' do_fil])
   end   
   if drop_flag==2 & exist(do_fil)==2 
      load(do_fil); % retrieve existing DOX data
   else
      %
      % Read channel config for mmpid to determine if dox sensor installed
      % and with what scanpos
      [sensorid,electronicsid,filter,fc,scanpos] = ...
         read_chconfig_mmp('dox',mmpid,drop);
      if isempty(scanpos)
         disp_str=['  calc_dox1G_mmp: no scanpos for drop ' int2str(drop) ...
               ' in config\' mmpid '\dox'];
         disp(disp_str)
      else
         % read dox algorithm and use it to calculate data (one per scan)
         algorithm=read_algorithm_mmp('dox',drop);
         exec_str=['dox=' algorithm '_mmp(drop,tsbe,salinity,pr_thetasd);'];
         eval(exec_str)
         % Offset pressure to dox
         pr_dox = pr_thetasd(1:length(dox)); % for now
         %pr_obs=pr_offset1_mmp(drop,'dox',pr_scan);
         %
         % Save data
         save(do_fil, 'pr_dox', 'dox');
      end % of processing and saving dox data
   end % of determining whether dox data exist for drop, then processing if so
   clear disp_str exec_str do_fil algorithm
end
