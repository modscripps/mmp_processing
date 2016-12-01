% calc_chi3G_mmp.m
%	Called from batchprocess4G_mmp to estimate chis, from th1/th2 spectra
%	integrated to cutoff based on voltage noise floor.
%	Intervals thinner than 0.5m or with w_eps<0.2m/s are skipped (chi1,2=NaN).
%	Does NOT re-compute if drop_flag=2 and chi<drop>.mat already exists.
%	REQUIRES the following, set up in batchprocess4G_mmp.m, setup_epschi3_mmp.m:
%		drop,procdata,cruise,mmpid, hfperscan,dt_hf,eps_step,FS_hf, f,df;
%		nchi,cntr_scan,pr_chi,w_eps, t,s,ktemp;  save_chi_spec,displ_chi_spec;
%	CREATES file chi<drop>.mat, saving:  chi,kcth [nchi-by-n_tlch matrices],
%		pr_chi,w_eps,t,s [vectors(1:nchi)], tlch [1 and/or 2], eps_step
%		Optionally, Ptg1<drop>.mat,Ptg2<drop>.mat save the temp.grad spectra.
%	Returned for later plotting are:  chi, pr_chi, tlch, n_tlch;
% REVISED  Sept-2001 by Dave Winkel,
%		from 02sep96 M.Gregg version calc_chi2_mmp.m

if (drop_flag==1 | drop_flag==2) & ~isempty(tlch)
   chi_fil = [procdata filesep cruise filesep 'chi' filesep 'chi' num2str(drop) '.mat'];
   chi=[];
   data_flag=1; % Set to 0 when further chi processing impossible or unnecessary
   %
   % When drop_flag=2, if chi-file already exists, retrieve data and stop
   if data_flag==1 & drop_flag==2 & exist(chi_fil)==2
      load(chi_fil); % retrieve existing chi data
      n_tlch = size(chi,2);
      if n_tlch ~= length(tlch)
         disp(['Mismatch in existing data: size(chi,2)~=length(tlch)'])
      end
      data_flag=0;
   end
  %
  if data_flag==1
    n_tlch=length(tlch);
    %
    % Set up data arrays
    chi=NaN*ones(nchi,2); kcth=NaN*ones(nchi,2);
    % arrays for saving temp grad spectra
    if strcmp(save_chi_spec,'yes')
       Ptg1=NaN*ones(eps_step/2,nchi); ktg1=NaN*ones(eps_step/2,nchi);
       Ptg2=Ptg1; ktg2=ktg1;
    end	
    % 
  end % of arrays set up
  %
  if data_flag==1 %AAAAAAA Inside this if, processing will be attempted for
                  % v1 & v2 even if data_flag set to 0 for th1  AAAAAAAAA
    for i=tlch % bbbbbbbbbbb loop for th1 and th2 bbbbbbbbbbbbbbb
      ch=['th' int2str(i)];
	    %	
	    % read configuration
	    [sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp(ch,mmpid,drop);	
       [scanid,voffsetid]=read_config_mmp(mmpid,drop);
       if isempty(sensorid)
	      disp(['  no thermistor probe for ' ch ])
	      data_flag=0; % Will affect only current channel, i.e. i value
	    else
	      data_flag=1;
         % calculate frequency-dependent circuit functions
         %
         % calculate electronics transfer fcn of th circuit and get parameters
         % of the tl circuit that are needed to compute beta
         str1=['[helectronics,Gtl,E1]=h' electronicsid '_mmp(f);'];
         eval(str1);
         %
         % calculate the amplitude-squared response of the th anti-alias filter
         % (the phase is empty)
         str1=['[hfilt,pfilt]=' filter '(f,fc);'];
         eval(str1)
         %
         % calcuate an array with the thermistor sensitivity for all chi windows
         str1=['beta_thermistor=beta_' electronicsid '_mmp(t,tlV(:,i),Gtl,E1);'];
         eval(str1)
         beta_thermistor_sq=beta_thermistor.^2; 
         %
         hth=helectronics .* hfilt; % all of response except thermistor
         algorithm = read_algorithm_mmp(ch,drop);
       end
      %
      if data_flag==1 %ccccccccccccccccccccccccccccccccccccccccc
	      % read raw data & convert to volts
	      rawdata=read_rawdata_mmp(ch,drop,scanid,scanpos);
         rawdata=atod1_mmp(rawdata); % convert to volts
         
         % loop to estimate chi 	
         for j=1:nchi %dddddd j is index of chi window dddddd
            if w_eps(j)>0.01
               speed = w_eps(j);
            else
               speed = NaN;
            end
            
            cntr_sample=cntr_scan(j)*hfperscan; % sample just before window cntr
            start_sample=cntr_sample-fix(eps_step/2)+1; % 1st sample in window
            stop_sample=cntr_sample+fix(eps_step/2); % last sample in window
            %
            % select rawdata and take spectrum
            data=rawdata(start_sample:stop_sample);
            data = data-mean(data); % revised for EPIC01
            [Pth,fth]=psd(data,eps_step,FS_hf);
            fth=fth(2:end)';
            Pth=Pth(2:end)'/(0.5*FS_hf); % delete f=0; normalize to preserve variance
            %
            % determine cutoff frequency for integration
            str=['fc_index=' algorithm '_' electronicsid '_mmp' ...
                  '(fth,Pth,displ_chi_spec,pr_chi(j),j,speed);'];
            eval(str)
            
            % scale with wavenumber
            kcth(j,i)=fth(fc_index)/speed;
            k=fth./speed; dk=df/speed;
            [hsq_thermistor,phase_thermistor]=h_fp07(fth,speed);
            h_th_total=hth .* hsq_thermistor(:) * beta_thermistor_sq(j);
            Emp_Corr_fac = 1/30; % empirical correction factor, until figured out
            Ptempk = Emp_Corr_fac * (Pth*speed)./h_th_total';
            Ptgradk=(2*pi*k).^2 .* Ptempk ;
            chi(j,i)=6*ktemp(j)*dk.*sum(Ptgradk(1:fc_index));
            %	
            if strcmp(save_chi_spec,'yes')
               ir=int2str(i);
               x=Ptgradk';
               str=['Ptg' ir '(:,j)=x; ktg' ir '(:,j)=k'';'];
               eval(str);
            end
        end % dddddddddddd for j=1:nchi    dddddddddddddddddddd
        %% Save spectra, if requested
        if strcmp(save_chi_spec,'yes')
           ir=int2str(i);
           out_file=[procdata  filesep cruise  filesep 'chi'  filesep 'Ptg' ir '_' num2str(drop) '.mat'];
           save(out_file, ['Ptg' ir], ['ktg' ir], 'cntr_scan');
        end
      end %ccccccccccccccc if data_flag==1 (th1 or th2) cccccccccccccccccccc
    end %bbbbbbbbbb for i=1:2 loop for th1 and th2 bbbbbbbbbbbb
    %
    % Reduce output arrays to one column if tlch has only one column
    chi=chi(:,tlch); kcth=kcth(:,tlch);
    %
    save(chi_fil, 'pr_chi', 'kcth', 'chi', 'w_eps','t','s','tlch','eps_step');
    %
  end %AAAAAAAA if data_flag==1 (chis computed) AAAAAAAA
  %
  clear sensorid* electronicsid filter fc scanpos calid helectronics Gt1 E1 ...
   	str1 str hfilt pfilt h_freq algorithm rawdata data cntr_sample beta_thermistor ...
      start_sample stop_sample Pth fth hth speed k dk htotal Ptempk Ptgradk ir kcth ...
      Ptg1 Ptg2 ktg1 ktg2 out_file chi_fil data_flag beta_thermistor_sq fc_index ...
      phase_thermistor h_th_total
      
end
