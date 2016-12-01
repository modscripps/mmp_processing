function badflag1_v1v2_mmp(drop)
% Function: To aide editing of spikes from raw v1 and v2.  The editing is done
%    by defining the pressure limits of the spikes and writing problems files
%    containing those limits.
% Usage: v1 and v2 are plotted versus pressure and overlaid, in red and green.
%    `ginput' is used for selecting spikes by clicking on either side of them.
%    `input' then asks whether: 
%                  tighter limits should be selected: 't' 
%                  to add the current limits to badvx: 's1', to badvy: 's2', or
%                  to both: 's12'
%            Any other response leaves the current limits out of the array.  
%    'input is then used to ask whether another spike should be edited.  If 'y', the
%    plot is redrawn with previously edited spikes deleted.  Any other response
%    causes the output array to be written to disk, provided it is not empty,
%    and the program to exit.
%
%    The script begins by loading existing badvx and badvy files for the drop
%    and setting the marked pressure ranges to NaNs before making the first plot
%    of v1 and v2.
% m. gregg 28oct98

cruise=read_cruises_mmp(drop);
mmpid=read_mmpid(drop);
scanlen=16;
mmpfolders

disp0_str=['Editing v1 and v2 for MMP' int2str(drop)];
disp(disp0_str)

% if problem files exist load them
vx_file=[procdata '\' cruise '\problems\vx\' 'badvx' int2str(drop) '.mat'];
if exist(vx_file)==2
   vx_load_str=['load ' setstr(39) vx_file setstr(39)];
   eval(vx_load_str)
   badvx
   [mx,nx]=size(badvx); 
   i1=mx+1; % index of next badvx row to be written
else
   disp('No badvx file')
   badvx=[]; i1=1;
end
%
vy_file=[procdata '\' cruise '\problems\vy\' 'badvy' int2str(drop) '.mat'];
if exist(vy_file)==2
   vy_load_str=['load ' setstr(39) vy_file setstr(39)];
   eval(vy_load_str)
   badvy
   [my,nx]=size(badvx); 
   i2=my+1; % index of next badvy row to be written
else
   disp('No badvy file')
   badvy=[]; i2=1;
end

% Get airfoil data
v1=atod1_mmp(read_rawdata_mmp('v1',drop));
v2=atod1_mmp(read_rawdata_mmp('v2',drop));
%
% Shorten v1, v2 to match lengths of interpolated pressure
v1len=length(v1);
v1=v1(scanlen/2:v1len-scanlen/2);
v2=v2(scanlen/2:v1len-scanlen/2);

% Get pressure.  Because there is only one pressure value per data scan,
% interpolate to produce a pressure value for every v1, v2 value.
% Ignore the first and last scanlen/2 samples of v1, v2,  so v1 and v2 will
% have the same time intervals as pr
pr=pr_offset1_mmp(drop,'v1',pr3_mmp(drop));
p=interp1(scanlen/2:16:v1len-scanlen/2,pr,scanlen/2:v1len-scanlen/2);

% Set data with badvx and badvy to NaNs
if ~isempty(badvx)
   [mx,nx]=size(badvx);
   for i=1:mx
      ip=find(p>=badvx(i,1) & p<=badvx(i,2));
      v1(ip)=NaN*ones(size(ip));
   end
end
if ~isempty(badvy)
   [my,ny]=size(badvy);
   for i=1:my
      ip=find(p>=badvy(i,1) & p<=badvy(i,2));
      v2(ip)=NaN*ones(size(ip));
   end
end

% Plot v1 in red and overlay v2 in green. 
Hf1=figure;
Hl1=plot(p,v1,'.r');
hold on
Hl2=plot(p,v2,'.g');
xlabel('p / MPa'), ylabel('v1(red), v2(green) / volts')
title_str=[mmpid ', drop=' int2str(drop)];
title(title_str)
x0=get(gca,'xlim'); y0=get(gca,'ylim');

edit=input('Edit spikes? ','s');
while strcmp(edit,'y') %%%%%%%%%% outer loop, one circuit per spike edited %%%%%%%
     
   select='t';
   while strcmp(select,'t') %%%%% inner loop, one circuit per xlim %%%%%%%%%%%%%%%
      disp('Click on the screen on either side of the spike to be edited')
      [x,y]=ginput(2);
      set(gca,'xlim',[min(x) max(x)])
      select=input('Reply t for tighter xlim, or s1, s2, s12 to save limits ','s');
   end %%%%%%%%%%%%%%%%%%%%%%%%%% end inner loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % Put current xlim into badvx and replot v1 without this spike
   if strcmp(select,'s1') | strcmp(select,'s12')
      badvx(i1,1)=min(x); badvx(i1,2)=max(x); i1=i1+1;
      ip=find(p>=min(x) & p<=max(x));
      v1(ip)=NaN*ones(size(ip));
      delete(Hl1)
      Hl1=plot(p,v1,'.r');
   end
   
   % Put current xlim into badvy and replot v2 without this spike
   if strcmp(select,'s2') | strcmp(select,'s12')
      badvy(i2,1)=min(x); badvy(i2,2)=max(x); i2=i2+1;
      ip=find(p>=min(x) & p<=max(x));
      v2(ip)=NaN*ones(size(ip));
      delete(Hl2)
      Hl2=plot(p,v2,'.g');
   end
   
   % Input to edit another spike
   set(gca,'xlim',x0,'ylim',y0)
   edit=input('Edit another spike? ','s');
end %%%%%%%%%%%%%%%%%%% end outer loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% With no more spikes to edit, write out badvx and badvy if the arrays are
% not empty

if ~isempty(badvx)
   if length(badvx(:,1)>1)
      % Sort badvx by increasing values of its lower limits
      [badvx(:,1),ix] = sort(badvx(:,1));
      badvx(:,2)=badvx(ix,2);
      
      sv1_str=['save ' setstr(39) vx_file setstr(39) ' badvx'];
      eval(sv1_str)
   end  
end

if ~isempty(badvy)
   if length(badvy(:,1)>1)
      % Sort badvy by increasing values of its lower limits
      [badvy(:,1),iy] = sort(badvy(:,1));
      badvy(:,2)=badvy(iy,2);
      
      sv2_str=['save ' setstr(39) vy_file setstr(39) ' badvy'];
      eval(sv2_str)
   end  
end

close(Hf1)