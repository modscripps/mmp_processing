function [y,u,v]=get_refvel2(file,numfiles,day,month,year);

numdiv=floor(numfiles/50);
for i=1:numdiv
   minfile=50*(i-1);
   maxfile=50*i-1;
   [yday,uref,vref]=get_refvel(file,minfile,maxfile,day,month,year);
   y=[y,yday]; u=[u,uref']; v=[v,vref'];
   % save intermediary results
   eval(['save ' file 'mat u v y'])
   disp('saving some results')
end
minfile=50*numdiv;
maxfile=numfiles;
[yday,uref,vref]=get_refvel(file,minfile,maxfile,day,month,year);
y=[y,yday]; u=[u,uref']; v=[v,vref'];
eval(['save ' file 'mat u v y'])