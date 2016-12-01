% calc_chi2_mmp.m%   Usage: called by batchprocess1_mmp%   Function: process th1 and th1 for chi%MHA added lines to detrend and demean data before computing spectra.%NOTE there are still errors somewhere in the cals that make the%chis and the spectra a factor of ~68 too high!!!!!%if drop_flag==1 & ~isempty(tlch) % start outer loop   %   data_flag=1;   %   % set up output arrays   chi=NaN*ones(nchi,n_tlch);    kcth=NaN*ones(nchi,n_tlch);    %   % arrays for saving th1 tgrad spectra   if strcmp(save_chi_spec,'y')==1 | strcmp(save_chi_spec,'yes')==1      Ptg1=NaN*ones(eps_step/2,neps); ktg1=NaN*ones(eps_step/2,neps);   end   %   for i=tlch % start loop for th1 and th2      % Set channel      ch=['th' int2str(i)];      %      % read configuration      [sensorid,electronicsid,filter,fc,scanpos] = ...         read_chconfig_mmp(ch,mmpid,drop);	      if strcmp(sensorid,'[]')==1         disp_str=['   calc_chi2_mmp: scanpos null for th' int2str(i)];         disp(disp_str)         data_flag=0;      else         % calculate frequency-dependent circuit functions         %         % calculate electronics transfer fcn of th circuit and get parameters         % of the tl circuit that are needed to compute beta         str1=['[helectronics,Gtl,E1]=h' electronicsid '_mmp(f);'];         eval(str1);         %         % calculate the amplitude-squared response of the th anti-alias filter         % (the phase is empty)         str1=['[hfilt,pfilt]=' filter '(f,fc);'];         eval(str1)         %         % calcuate an array with the thermistor sensitivity for all chi windows         str1=['beta_thermistor=beta_' electronicsid '_mmp(t,tlV(:,i),Gtl,E1);'];         eval(str1)         beta_thermistor_sq=beta_thermistor.^2;          %         hth=helectronics .* hfilt; % all of response except thermistor         algorithm = read_algorithm_mmp(ch,drop);      end            % read raw data & convert to volts      rawdata=read_rawdata_mmp(ch,drop,scanid,scanpos);      rawdata=atod1_mmp(rawdata);            % start loop for chi estimates      for j=1:nchi         if w_eps(j)>0            speed=w_eps(j);         else            speed=NaN;         end         start_sample=(j-1)*(eps_step/2)+1;         stop_sample=start_sample+eps_step-1;                  % select rawdata and take spectrum         data=rawdata(start_sample:stop_sample);		 %MHA change: inserted the following line to get rid of the mean and 		 %the trend		 data=detrend(data);         [Pth,fth]=psd(data,eps_step,FS_hf);         Pth=Pth/(0.5*FS_hf); % normalize to preserve variance         Pth=Pth(2:length(Pth))'; % drop 0 frequency estimate         fth=fth(2:length(fth))';                   % determine cutoff frequency for integration         str=['fc_index=' algorithm '_' electronicsid '_mmp' ...               '(fth,Pth,displ_chi_spec,pr_chi(j),j,speed);'];         eval(str)                  % scale with wavenumber         kcth(j,i)=fth(fc_index)/speed;         k=fth./speed; dk=df/speed;         [hsq_thermistor,phase_thermistor]=h_fp07(fth,speed);         h_th_total=hth .* hsq_thermistor(:) * beta_thermistor_sq(j);         Ptempk=(Pth*speed)./h_th_total';         Ptgradk=(2*pi*k).^2 .* Ptempk;         chi(j,i)=6*ktemp(j)*dk.*sum(Ptgradk(1:fc_index));         if strcmp(save_chi_spec,'yes')==1 | strcmp(save_chi_spec,'y')==1            Ptg1(:,j)=Ptgradk'; ktg1(:,j)=k';         end      end % end loop for chi estimates   end % end for i loop for th1 and th2      out_file=[procdata filesep cruise filesep 'chi' filesep 'chi' num2str(drop) '.mat'];   str=['save ' setstr(39) out_file  setstr(39) ' pr_chi chi kcth'];   eval(str)      % write th1 spectra and cutoffs to disk if specified		   if strcmp(save_chi_spec,'yes')==1 | strcmp(save_chi_spec,'y')==1      out_file=[procdata filesep cruise filesep 'chi' filesep 'Ptg1' num2str(drop) '.mat'];      str=['save ' setstr(39) out_file  setstr(39) ' Ptg1 ktg1'];      eval(str)      clear Ptg1 ktg1   end      clear sensorid electronicsid filter fc scanpos calid str str1 ...      hfilt pfilt beta_thermistor_sq helectronics hfilt hth ...      algorithm rawdata data start_sample stop_sample P speed ...      k dk h_th_total Ptempk Ptgradk kcth Gtl E1 beta_thermistor ...      phase_thermistor hsq_thermistor end % end outer loop