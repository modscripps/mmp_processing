function compareSW_tstc_mmp(mmpdrops,SWydays,type,dopause,str)

% function compareSW_tstc(mmpdrops,SWydays,type,dopause)
%
% Draws TS ot TC plots for a range of ampdrops and gridded SWIMS yearday ranges.
% Uses the problems files to correct for bad data and offsets before 
% ploting.
%
% Inputs
%   ampdrops: drops to use
%   SWydays: triplets of [year, yearday limits], multirows
%   type: either 'ts' (default) or 'tc'
%   dopause: pause for return key after plotting each profile
%   str: additional title str, title already includes drop numbers and colours
%
% Glenn Carter Jan 2001 (rev for SWIMS 9/02, DPW)

% default inputs
if nargin < 5
   str = '';
end
if nargin < 4
   dopause = 'y';
end
if nargin < 3
   type = 'ts';
end

figure
hold on

% loop over ampdrops and plot
mmpfolders
for ido = 1:length(mmpdrops)
   mmpid = read_mmpid(mmpdrops(ido));
   [pr,temp,temp_raw,sal,sal_raw,cn,cn_raw]=salinity2a_mmp(mmpdrops(ido));
   if strcmp(type,'tc')
      var1 = cn;
   else
      var1 = sal*1000;
   end
   lh = []; Cont = 'x';
   if strcmp(dopause,'y')
      lh = plot(var1,temp,'y');
      title(['Current drop = ' mmpid ' ' int2str(mmpdrops(ido))])
       Cont = questdlg('Erase plot of current drop? ', ...
           ['Plotting ' type ' by Drop'], 'Yes', 'No', 'Pause', 'No');
   end
   
   if strcmp(mmpid,'mmp1'), colour = 'g'; end
   if strcmp(mmpid,'mmp2'), colour = 'b'; end
   if strcmp(mmpid,'mmp3'), colour = 'm'; end
   if isempty(lh)
       plot(var1,temp,colour)
   else
       switch Cont
           case 'Yes'
               delete(lh);
           otherwise
               if strcmp(Cont,'Pause'), pause; end
               set(lh,'color',colour);
       end
   end
   title('')
end


% loop over SWIMS intervals and plot
set_swims_paths % edit swimsfolders for desired cruise, data locations
for ido = 1:size(SWydays,1)
   yr = SWydays(ido,1); ydb=SWydays(ido,2); yde=SWydays(ido,3);
   [CTD] = get_swims_data(ydb, yde, fullfile(swimsindex,'SWIMS_ps03_gridfiles.mat'), ...
       swimsgridded, {'t1','c1','s1','th1','updown'} );
   if strcmp(type,'tc')
      var1 = CTD.c1;
   else
      var1 = CTD.s1*1000;
   end
   
%    if strcmp(dopause,'y')
%       plot(var1,temp,'y')
%       title(['Current SWIMS = ' num2str(ydb) ':' num2str(yde)])
%       pause
%    end
iu=find(CTD.updown>0); id=find(CTD.updown<0);
for ii=1:min(length(iu),length(id))
    hhup=plot(var1(:,iu(ii)),CTD.t1(:,iu(ii)),'k-');
    hhdn=plot(var1(:,id(ii)),CTD.t1(:,id(ii)),'r-');
    if strcmp(dopause,'y')
        pause
        delete(hhup), delete(hhdn)
    end
end
   title('')
end

% drop strings
dd = diff(mmpdrops);
ii = find(dd > 1);
ampstr = [' MMPdrops = ' int2str(mmpdrops(1)) ':'];
for ido = 1:length(ii)
   ampstr = [ampstr int2str(mmpdrops(ii)) ' ' int2str(mmpdrops(ii+1)) ':'];
end
ampstr = [ampstr int2str(mmpdrops(end)) ';'];

mmpstr = [' SWIMS UP = bk, DN = rd'];

% labels etc
ylabel('T / ^{\circ}C')
if strcmp(type,'tc')
   xlabel('cn')
else 
   xlabel('salinity *1000')
end
title([str ampstr mmpstr]) % 'MMP1(g) MMP2(bu) MMP3(m)'])
set(gca,'box','on')
grid
