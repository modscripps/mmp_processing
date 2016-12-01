% calc_obs1G_mmp.m
%   Usage: Called within batchprocess4G_mmp
%   Function: Calculate optical backscatterance in ftu
%	Input: drop,mmpid,cruise,procdata, pr_scan, hfperscan,FS_lf,FS_hf
%	Output: obs, pr_obs
% M.Gregg, 13jul96; revised jun-2000 by Dave W

if drop_flag==1 | drop_flag==2
   ob_fil = [procdata filesep  cruise filesep 'obs' filesep 'obs' int2str(drop) '.mat'];
   obs=[]; pr_obs=[];
   
   if drop_flag==2 & exist(ob_fil)==2 % jun-2000 revision
      load(ob_fil); % retrieve existing OBS data
   else
      %
      % Read channel config for mmpid to determine if obs sensor installed
      % and with what scanpos
      [sensorid,electronicsid,filter,fc,scanpos] = ...
         read_chconfig_mmp('obs',mmpid,drop);
      if isempty(scanpos)
         disp_str=['  calc_obs1_mmp: no scanpos for drop ' int2str(drop) ...
               ' in config\' mmpid '\obs'];
         disp(disp_str)
     elseif ~isempty(sensorid)
         % read obs algorithm and use it to calculate data
         algorithm=read_algorithm_mmp('obs',drop);
         exec_str=['obs_raw=' algorithm '_mmp(drop);'];
         eval(exec_str)
         %
         inan=find(isnan(obs_raw));
         if ~isempty(inan)
            disp_str=['  obs has NaNs and was decimated w/o low-passing'];
            disp(disp_str)
         else
            % Low-pass to produce one value per scan
            [b_obs,a_obs]=butter(4,(FS_lf/4)/(FS_hf/2));
            obs_lp=filtfilt(b_obs,a_obs,obs_raw);
         end
         %
         % Take one value per scan, at time of pr
         obs=obs_lp(4:hfperscan:length(obs_lp)); 
         %
         % Offset pressure to obs
         pr_obs=pr_offset1_mmp(drop,'obs',pr_scan);
         %
         % Save data
         save(ob_fil, 'pr_obs', 'obs');
      end % of processing and saving obs data
   end % of determining whether obs data exist for drop, then processing if so
   clear disp_str exec_str a_obs b_obs obs_raw obs_lp ob_fil algorithm
end
