function [x]=regrid2(xold,yold,y,dy);
%
% function [x]=regrid2(xold,yold,y,binsize);
% created as an alternative to regrid.m with
% epsilon data in mind.  No filtering is done,
% a simple mean of xold values located within
% overlapping bins centered at y and of size
% dy is used to produce x
%
% all hallows eve, 1998
x=NaN*ones(size(y));
for i=1:length(y)
   ig=find((yold>=(y(i)-dy/2))&(yold<=(y(i)+dy/2)));
   if length(ig)>=1
      x(i)=nanmean(xold(ig));
   else
      x(i)=NaN;
   end
   
end
