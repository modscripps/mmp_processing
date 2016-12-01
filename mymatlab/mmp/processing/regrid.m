function [x]=regrid(xold,yold,y);
%
% REGRID regrid the data
%
% x=regrid(xold,yold,y)
%

% first check if yold is monotonic - if not make it so
good=find(~isnan(yold));
while ~isempty(find(diff(yold(good))<=0))
   good_=find(diff(yold(good))>0);
   good=good(good_);
end
xold=xold(good); yold=yold(good);
x=y*NaN;
if length(yold)<=0
  return;
end;

good = find(~isnan(xold) & ~isnan(yold));
xold=xold(good);yold=yold(good);

% Get the grid spacing and filter length...
dy=median(diff(y));
dyold = median(diff(yold));
filt_l = 	floor(dy/dyold);
if filt_l>1
  if length(xold)>6*filt_l
    b=hanning(2*filt_l);
  	b=b./sum(b);
  	a=1;
	  xold=filtfilt(b,a,xold);
	end;

end;

% Now only interpolate over the y that are withing yold...
okay = find(y>yold(1) & y<=yold(length(yold)));
x(okay)=interp1(yold,xold,y(okay));
