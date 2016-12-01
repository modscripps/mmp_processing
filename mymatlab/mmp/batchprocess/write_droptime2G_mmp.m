% write_droptime2G_mmp
%  Usage: called within batchprocess4G_mmp
%  Function: writes year, yday, and mmp vehicle number of drop
%    into mmplog file for cruise
%  jun2000: doesn't alter valid mmplog entry if drop_flag=2 (Dave W)


if drop_flag==1 | drop_flag==2

   % load current mmplog, check year,yday columns for drop

   load([procdata filesep cruise filesep 'mmplog'])

   irow=find(mmplog(:,1)==drop);

   year=mmplog(irow,2); yday=mmplog(irow,3);

   mmpno=mmplog(irow,11);

   if isnan(year) | isnan(yday)

      year=[]; yday=[];

   end

   % Update mmplog record for drop

   if isempty(year) | isempty(yday) | drop_flag==1
      % read drop time from raw data
      source_file=[rawmmp filesep  int2str(drop)];
      [year,yday]=read_time_stamp(source_file);
      %
      if ~isempty(year) & ~isempty(yday)
         mmplog(irow,2)=year;
         mmplog(irow,3)=yday;
         %
         % Write mmp vehicle number into mmplog array
         n=length(mmpid);
         mmpno=fix(str2num(mmpid(4))); % :n))); edited for mmp2s
         mmplog(irow,11)=mmpno;

         % save updated mmplog file

         save([procdata filesep  cruise filesep 'mmplog'], 'mmplog');
      else
         drop_flag=0;
      end

   end

   clear mmplog source_file
end


%pause(2);
