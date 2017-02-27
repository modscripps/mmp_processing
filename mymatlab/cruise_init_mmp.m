% cruise_init_mmp.m  -  initialize folders, mmplog for cruise;
%	For now, edit drop range, perhaps columns for mmplog - DPW 8-00

cr_dir=pwd;

drops=21442:22999;
ncols=16;

cr_flds={'ac';'accel';'chi';'eps';'obs';'pr';'problems';...
      'tc';'tl';'dox';'logs';'gridded';'figs';'figs/fig';'figs/pdf'};

disp(['SET UP for new cruise in: ' cr_dir '  -  ']);
disp(['  mmplog.mat with ' num2str(ncols) ' columns for drops ' ...
      num2str(min(drops)) ':' num2str(max(drops))]);
disp('  and Folders =');
disp(cr_flds); disp('');

x = input('Ready to proceed? ', 's');
switch x
case {'yes'}
   disp('Okay, starting ...');
   more = 1;
otherwise
   disp('Abort Set Up !');
   more = 0;
end

if more
   mmplog = NaN*ones(length(drops),ncols);
   mmplog(:,1) = drops';
   save mmplog mmplog
   
   for id=1:length(cr_flds)
      %mkdir(cr_flds{id})
   end
   
   disp('  Done making mmplog.mat and folders.')
end
