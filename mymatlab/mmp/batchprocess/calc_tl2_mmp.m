% calc_tl2_mmp.m
%   Usage: called by batchprocess4_mmp
%   Function: calc & keep tl1V as avg voltage at center of chi windows,
%      select & keep tref, temp at center of chi windows.
%      fit tl1V to tref with 2nd order poly & save coef as
%      MMP:<cruise>:tl1:tl1fit<drop>.mat.  Also save
%      std_residual<drop>.mat in same folder. Calc & keep
%      beta array of change in voltage across thermistor at
%      window center.
%  13jul96, revised to process tl2 and tl1, M.Gregg

if drop_flag==1 | drop_flag==2
   %
   data_flag=1;
   %
   % Check that tl1 and tl2 had sensors for this drop and set up
   % data arrays and channels to process ones with sensors
   [sensorid1,dum1,dum2,dum3,dum4]=read_chconfig_mmp('tl1',mmpid,drop);
   [sensorid2,dum1,dum2,dum3,dum4]=read_chconfig_mmp('tl2',mmpid,drop);
   if ~isempty(sensorid1) & ~isempty(sensorid2)
      tlch=1:2;
   elseif ~isempty(sensorid1) & isempty(sensorid2)
      tlch=1;
      %disp('  calc_tl2_mmp: no tl2 sensor')
   elseif isempty(sensorid1) & ~isempty(sensorid2)
      tlch=2;
      %disp('  calc_tl2_mmp: no tl1 sensor')
   else
      disp('  calc_tl2_mmp: no tl1 or tl2 sensors')
      tlch=[];
      data_flag=0;
   end
   if data_flag==1
      %
      n_tlch=length(tlch);
      %
      % Set up data arrays
      tlfit=NaN*ones(tlpoly_degree+1,n_tlch);
      std_residual=NaN*ones(1,n_tlch);
      tlV=NaN*ones(nchi,n_tlch);
      %
      for i=tlch
         ch=['tl' int2str(i)]; thch=['th' int2str(i)];
         
         % read configuration of tl1 electronics, filter, etc.
         % read sensorid is specified for thi because
         % thi config also has sensorid and electronics id for tli
         [sensorid,electronicsid,x,y,z] = read_chconfig_mmp(thch,mmpid,drop); 
         [x,y,filter,fc,scanpos] = read_chconfig_mmp(ch,mmpid,drop);
         if strcmp(sensorid,'[]')==1
            str=['   no th' int2str(i) ' sensor, hence no tl or th data'];
            disp(str);
            data_flag=0;
         else
            data_flag=1;
            rawdata=read_rawdata_mmp(ch,drop,scanid,scanpos);
            tl_scan_avg=scanavg1_mmp(rawdata); clear rawdata;
            algorithm = read_algorithm_mmp(ch,drop);
         end	
         %
         if data_flag==1
            % Select tl1 scan averages matching cntr_scans
            tlV(:,i)=atod1_mmp(tl_scan_avg(cntr_scan));
            %		
            % fit tlV to tref and display residuals
            tlfit(:,i)=polyfit(tlV(:,i),t,tlpoly_degree)';	
            tcalc=polyval(tlfit(:,i),tlV(:,i));
            residual=tcalc-t;
            std_residual(i)=std(residual);
            mr=max(residual);
            str=['  calc_tl2_fit: rms & max deviations of residual to tl' int2str(i) ...
                  ' fit = ' num2str(std_residual(i)) ' & ' num2str(mr) ' deg C'];
            %disp(str)
            %
            clear tl1 polydegree tcalc residual mr str tl_scan_avg
         end
      end
      
      % save tlfit  and std_residual
      sv_str=['save ' setstr(39) procdata '/' cruise '/tl/tlfit' int2str(drop) ...
            '.mat' setstr(39) ' tlfit std_residual'];
      eval(sv_str)
      %
      clear sensorid1 sensorid2 e fc sc data_flag sensor id ...
      electronicsid x y z filter fc scanpos rawdata str ...
      dum1 dum2 dum3 dum4
      %
      % don't clear tlV; it is needed to calculate chi
   end
end