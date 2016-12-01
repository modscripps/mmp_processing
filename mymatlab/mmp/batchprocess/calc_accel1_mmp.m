% calc_accel1_mmp.m
%  Function: A script in batchprocess2_mmp used for mmp1 through
%   mmp3 from their first drops through the present.  For the
%   drops processed, a1 and a2 are sampled at 400 Hz and for
%   mmp3 a3 and a4 are sampled at 50 Hz, i.e. twice per scan.
%   This processing reduces all of those channels to one sample
%   per scan and writes the data to matrices in acceleration units.
%
%  For mmp1:mmp3 from drops 2262:100000
G=9.80665;

if drop_flag==1
   %
   % Set channels to be processed as function of mmpid
   if strcmp(mmpid,'mmp1') | strcmp(mmpid,'mmp2')
      ch=['a1'; 'a2'];
   elseif strcmp(mmpid,'mmp3')
      ch=['a1'; 'a2'; 'a3'; 'a4'];
   end
   nch=length(ch);
   
   % Process a1 and a2, sampled at FS_hf=400 Hz
   a1a2=NaN*ones(hfperscan*nscans,2); % for initial data
   a1a2lp=NaN*ones(hfperscan*nscans,2); % for low-passed data
   a=NaN*ones(nscans,nch); % for final data
   for i=1:2
      %
      % Get data in acceleration units
      algorithm=read_algorithm_mmp(ch(i,:),drop);
      exec_str=['a1a2(:,i)=' algorithm '_mmp(ch(i,:),drop,mmpid);'];
      eval(exec_str)
      %
      % Low-pass with fc at 1/4 of subsample frequency and pick out
      % the 7th sample in each scan, to match the 1st a3,a4 pair
      [bfilt,afilt]=butter(4,(FS_lf/4)/(FS_hf/2));
      inan=find(isnan(a1a2(:,i)));
      if ~isempty(inan)
         disp_str=['   a' int2str(i) ' has NaNs and was left all NaNs'];
         disp(disp_str)
      else
         a1a2lp(:,i)=filtfilt(bfilt,afilt,a1a2(:,i));
         a(:,i)=a1a2lp(7:16:hfperscan*nscans,i);
      end
      clear a1a2 a1a2lp
   end
   
   % Process a3 & a4 for mmp3
   if strcmp(mmpid,'mmp3')
      a3a4=NaN*ones(2*nscans,2);
      a3a4lp=NaN*ones(2*nscans,2);
      %
      % Create ii index for the a3a4 and a3a4lp arrays
      for i=3:4
         if i==3
            ii=1;
         elseif i==4
            ii=2;
         end
         %
         % Get data in acceleration units
         algorithm=read_algorithm_mmp(ch(i,:),drop);
         exec_str=['a3a4(:,ii)=' algorithm '_mmp(ch(i,:),drop,mmpid);'];
         eval(exec_str)
         %
         % Low-pass with fc at 1/4 of subsample frequency and pick
         % out only 1st sample of each scan
         [bfilt,afilt]=butter(4,(FS_lf/4)/(FS_lf/2));
         inan=find(isnan(a3a4(:,ii)));
         if ~isempty(inan)
            disp_str=['   a' int2str(i) ' has NaNs and was left all NaNs'];
            disp(disp_str)
         else
            a3a4lp(:,ii)=filtfilt(bfilt,afilt,a3a4(:,ii));
            a(:,i)=a3a4lp(1:2:2*nscans,ii);
         end
      end
      %clear a3a4 a3a4lp
   end
   
   % Calculate tilts for display
   tilt=NaN*ones(size(a));
   % Replace accelerations larger than G with values
   % slightly smaller, so tilt calculation does not blow up
   ioffscale=find(abs(a)>=G);
   if ~isempty(ioffscale)
      a(ioffscale)=0.999*G*ones(size(ioffscale));
   end
   tilt=(180/pi)*asin(a/G);
   
   % Save the accelerations
   sv_str=['save ' setstr(39) procdata '\' cruise '\accel\a' ...
         int2str(drop) '.mat' setstr(39) ' a'];
   eval(sv_str)
end