% th_voltsspec

% read configuration of tl1 electronics, filter, etc.
% read sensorid is one specified for th1, null for tl1
	[sensorid,electronicsid,x,y,z] = read_chconfig_mmp('th1',mmpid,drop); % th1 config has sensorid and electronics id for tl1 as well
	[x,y,filter,fc,scanpos] = read_chconfig_mmp(ch,mmpid,drop);
	if strcmp(sensorid,'[]')==1
	    str=['   no th1 sensor, hence no tl1 or th1 data'];
		disp(str);
		data_flag=0; drop_flag=0; break
	else
		data_flag=1;
tl1C=read_rawdata_mmp('th1',drop,scanid,scanpos);
    	algorithm = read_algorithm_mmp(ch,drop);
	end	
	
	if data_flag==1
		% pick tl1 scans to compensate for vertical separation from tsbe
		% find first tl scan to use
		dt_scan=hfperscan*dt_hf; % duration of one scan
		dz=offset_th1-offset_tsbe; % vertical distance between th1 and tsbe probes
		t_index=1; % index of t, w, and cntr_scan arrays
		flag=1;
		% find where tl1 and tsbe first pass through same depth
		while flag==1
			scan_offset=round(dz/(w(t_index)*dt_scan)); % # scans between tl1 and tsbe
														% while they sample same depth
			if scan_offset>cntr_scan(t_index)
				t_index=t_index+1; % go to next cntr_scan value
			else
				flag=0; break % current cntr_scan is it
			end
		end
		
		% drop t data taken before start of tl1 at same depths
		tref=t(t_index:length(t));
		
		% find remaining tl1 scans & average tl1C over those scans
		tl1_start=cntr_scan(t_index)-scan_offset;
		no_tl1_scans=length(cntr_scan)-t_index+1;
		tl1_avg=NaN*ones(no_tl1_scans,1); % set up array
		for i=1:no_tl1_scans
			scan_offset=round(dz/(w(t_index)*dt_scan));
			tl1_scan=cntr_scan(t_index)-scan_offset;
			sf=(tl1_scan-1)*hfperscan+1; % first tl1 sample in scan
			lf=sf+hfperscan-1; % last tl1 sample in scan
			tl1_avg(i)=mean(tl1C(sf:lf));
			t_index=t_index+1;
		end
		tl1V=atod1_mmp(tl1_avg); % convert averages to volts	
		clear tl1C tl1_avg t_index lf sf tl1_scan scan_offset no_tl1 tl1_start no_tl1_scans
		
		% fit tl1V to tref and save coef for future use
		polydegree=2;
		tlfit=polyfit(tl1V,tref,polydegree);	
		tcalc=polyval(tlfit,tl1V);
		residual=tcalc-tref;
		std_residual=std(residual);
		str=['  rms residual to tl1 fit = ' num2str(std_residual) ' deg C'];
		disp(str)
		mr=max(residual);
		str=['  maximum deviation of residual to tl1 fit = ' num2str(mr) ' deg C'];
		disp(str)
		% save fit
		str=['save ' setstr(39) procdata ':' cruise ':tl1:tlfit' int2str(drop) ...
		     '.mat' setstr(39) ' tlfit'];
		eval(str)
		% save standard deviation of the residual
		str=['save ' setstr(39) procdata ':' cruise ':tl1:std_residual' ...
		      int2str(drop) '.mat' setstr(39) ' std_residual'];
		eval(str)

		clear tl1 polydegree tlfit tcalc residual std_residual mr str	
	end
