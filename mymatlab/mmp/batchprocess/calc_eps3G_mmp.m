% calc_eps3G_mmp.m
%	Called from batchprocess4G_mmp to estimate epsilons, from v1/v2 spectra
%	integrated to cutoff chosen with help from Panchev spectra.
%	Intervals thinner than 0.5m or with w_eps<0.2m/s are skipped (eps1,2=NaN).
%	Does NOT re-compute if drop_flag=2 and eps<drop>.mat already exists.
%	REQUIRES the following, set up in batchprocess4G_mmp.m, setup_epschi3_mmp.m:
%		drop,procdata,cruise,mmpid, hfperscan,dt_hf,eps_step,FS_hf, f,df;
%		neps,cntr_scan,pr_eps,w_eps, t,s,kvis;  save_eps_spec,displ_shear_spec;
%	CREATES file eps<drop>.mat, saving:  epsilon,kc [neps-by-n_epsch matrices],
%		pr_eps,w_eps,t,s [vectors(1:neps)], epsch [1 and/or 2], eps_step
%		(Stopped saving eps1,eps2,kmax with this version);
%		Optionally, Psh1<drop>.mat,Psh2<drop>.mat save the shear spectra.
%	Returned for later plotting are:  epsilon, pr_eps, epsch, n_epsch;
%	Left for chi processing are:  eps_step,w_eps,cntr_scan, and many REQUIREDS
% REVISED  June-2000 by Dave Winkel,
%		from 02sep96 M.Gregg version calc_eps3_mmp.m

if drop_flag==1 | drop_flag==2
   eps_fil = [procdata filesep cruise filesep 'eps' filesep 'eps' num2str(drop) '.mat'];
   epsilon=[];
   data_flag=1; % Set to 0 when further eps processing impossible or unnecessary
   %
   % Check that v1 and v2 had sensors for this drop and set up
   % data arrays and channels to process ones with sensors
   [sensorid1,dum1,dum2,dum3,dum4]=read_chconfig_mmp('v1',mmpid,drop);
   [sensorid2,dum1,dum2,dum3,dum4]=read_chconfig_mmp('v2',mmpid,drop);
   clear dum1 dum2 dum3 dum4
   if ~isempty(sensorid1) & ~isempty(sensorid2)
      epsch=1:2;
   elseif ~isempty(sensorid1) & isempty(sensorid2)
      epsch=1;
      disp('   calc_eps3G_mmp: no v2 sensor')
   elseif isempty(sensorid1) & ~isempty(sensorid2)
      epsch=2;
      disp('   calc_eps3G_mmp: no v1 sensor')
   else
      disp('   calc_eps3G_mmp: no v1 or v2 sensors')
      epsch=[];
      data_flag=0;
   end
   % When drop_flag=2, if eps-file already exists, retrieve data and stop
   if data_flag==1 & drop_flag==2 & exist(eps_fil)==2
      load(eps_fil); % retrieve existing epsilon data
      n_epsch = size(epsilon,2);
      if n_epsch ~= length(epsch)
         disp(['Mismatch in existing data: size(epsilon,2)~=length(epsch)'])
      end
      data_flag=0;
   end
  %
  if data_flag==1
    n_epsch=length(epsch);
    %
    % Set up data arrays
    epsilon=NaN*ones(neps,2); kc=NaN*ones(neps,2);
    % arrays for saving shear spectra
    if strcmp(save_eps_spec,'yes')
       Psh1=NaN*ones(eps_step/2,neps); ksh1=NaN*ones(eps_step/2,neps);
       Psh2=Psh1; ksh2=ksh1;
    end	
    % 
  end % of arrays set up
  %
  if data_flag==1 %AAAAAAA Inside this if, processing will be attempted for
                  % v1 & v2 even if data_flag set to 0 for v1  AAAAAAAAA
    for i=epsch % bbbbbbbbbbb loop for v1 and v2 bbbbbbbbbbbbbbb
      ch=['v' int2str(i)];
	    %	
	    % read configuration
	    [sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp(ch,mmpid,drop);	
       [scanid,voffsetid]=read_config_mmp(mmpid,drop);
       if isempty(sensorid)
	      disp(['  no airfoil probe for ' ch ])
	      data_flag=0; % Will affect only current channel, i.e. i value
	    else
	      data_flag=1;
 	      calid=read_whichcal_mmp('af',sensorid,drop);
	      [Sv,Cs]=read_af_cal(sensorid, calid);
	      str1=['helectronics=helectronics_' electronicsid '(Cs,f);'];
	      eval(str1); % evaluate electronics transfer function
	      str1=['[hfilt,pfilt]=' filter '(f,fc);'];
	      eval(str1)  % evaluate anti-alias filter transfer fcn
	      h_freq=helectronics .* hfilt;
	      % algorithm = read_algorithm_mmp('af',drop); % Not used
       end
      %
      if data_flag==1 %ccccccccccccccccccccccccccccccccccccccccc
	      % read raw data & convert to volts
	      rawdata=read_rawdata_mmp(ch,drop,scanid,scanpos);
         rawdata=atod1_mmp(rawdata); % convert to volts
         
         %str1=['raw' int2str(i) '=rawdata;']; eval(str1); %% not used?
         
         % loop to estimate eps 	
	      for j=1:neps %dddddd j is index of eps window dddddd
		      cntr_sample=cntr_scan(j)*hfperscan; % sample just before window cntr
		      start_sample=cntr_sample-fix(eps_step/2)+1; % 1st sample in window
		      stop_sample=cntr_sample+fix(eps_step/2); % last sample in window
		      %
		      % select rawdata and take spectrum
            data=rawdata(start_sample:stop_sample);
            data = data-mean(data); % revised for EPIC01
		      P=psd(data,eps_step,FS_hf);
		      P=P(2:length(P))'/(0.5*FS_hf); % delete f=0;, normalize to preserve variance
		      %
		      % convert frequency to wavenumber
			   speed=w_eps(j);
			   if speed > 0.2 %eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
		        k=f/speed;
		        dk=df/speed;
                
%                 if j==238
%                     keyboard
%                 end
		        %	
		        % evaluate and apply transfer function
		        htotal=(Sv*speed/(2*G))^2 * h_freq .* haf_oakey(f,speed);
		        Pvelk=(P*speed) ./ htotal'; % vel spec as function of k
		        Pshear=(2*pi*k').^2 .* Pvelk; % shear spec  as function of k
		        %	
              if strcmp(save_eps_spec,'yes')
                 ir=int2str(i);
                 x=Pshear';
                 str=['Psh' ir '(:,j)=x; ksh' ir '(:,j)=k;'];
                 eval(str);
              end
		        %
		        % calc epsilon by integrating to k with 90% variance of Panchev spec
		        % unless spectrum is noisy at lower k.	
			     % 
			     % Set kmax for integration to highest bin below pump spike,
			     % which is between 49 and 52 Hz in a 1024-pt spectrum
		        kmax=49./speed; % Lowest estimate below pump spike in 1024-pt record
				  kmax = min(kmax,100);
			     %
		        % Check that data window > 0.5 m, as needed for initial estimate
		        if eps_step*speed*dt_hf>0.5
		   		    [epsilon(j,i),kc(j,i)]=eps1_mmp(k,Pshear,kvis(j),speed,dk,kmax);		
              end
              %
		        % display each spectrum if displ_shear_spec='yes'
		        if strcmp(displ_shear_spec,'yes')
		          ref(1,1)=max(Pshear); ref(2,1)=min(Pshear);
                kcref(1,1)=kc(j,i); kcref(2,1)=kc(j,i);
		          kmaxref(1,1)=kmax; kmaxref(2,1)=kmax;
		          loglog(k,Pshear);
		          hold on
		          loglog(kcref,ref,'r'); %loglog(kcref,ref,'x')
		          loglog(kmaxref,ref,'r'); %loglog(kmaxref,ref,'+')
                title(['i=' int2str(i) ', j=' int2str(j) ', pr=' ...
                      num2str(pr_eps(j)) ', epsilon=' num2str(epsilon(j,i)) ]);
		          [kpan,Ppan] = panchev(epsilon(j,i),kvis(j));
		          loglog(kpan,Ppan,'bo');
		          pause(.2); clear ref kcref kmaxref kpan Ppan
		          hold off
	          end % display
			  end	% eeeeeeeeee if speed > 0.2  eeeeeeeeeeeeeeeeeeee		
        end % dddddddddddd for j=1:neps    dddddddddddddddddddd
        %% Save spectra, if requested
        if strcmp(save_eps_spec,'yes')
           ir=int2str(i);
           out_file=[procdata  filesep cruise  filesep 'eps'  filesep 'Psh' ir '_' num2str(drop) '.mat'];
           save(out_file, ['Psh' ir], ['ksh' ir], 'cntr_scan');
        end
      end %ccccccccccccccc if data_flag==1 (v1 or v2) cccccccccccccccccccc
    end %bbbbbbbbbb for i=1:2 loop for v1 and v2 bbbbbbbbbbbb
    %
    % Put calculations in output arrays to match format of previous data.
    % eps1=epsilon(:,1); eps2=epsilon(:,2);  % Discontinue after SC99
    %
    % Reduce output arrays to one column if epsch has only one column
    epsilon=epsilon(:,epsch); kc=kc(:,epsch);
    %
    save(eps_fil, 'pr_eps', 'kc', 'epsilon', 'w_eps','t','s','epsch','eps_step');
    %
  end %AAAAAAAA if data_flag==1 (epsilons computed) AAAAAAAA
  %
  clear sensorid* electronicsid filter fc scanpos calid Sv Cs helectronics ...
   	str1 str hfilt pfilt h_freq algorithm rawdata data cntr_sample ...
      start_sample stop_sample P speed k dk htotal Pvelk Pshear ir kmax kc ...
      Psh1 Psh2 ksh1 ksh2 out_file eps_fil data_flag
      
end
