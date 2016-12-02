function h = bounded_image(X,x,y,minX,maxX)
% BOUNDED_IMAGE: make a plot of an image with colorbar to match...
%
%  Usage:  h = bounded_image(X,x,y,minX,maxX)
%
%  X is the matrix of image data.  optional x and y specify the x and y
%  axes, minX and maxX specify the bounds of X wrt the colormap.
%

if nargin<1 | nargin==2 | nargin==4
  error('Usage: h = bounded_image(X,x,y,minX,maxX)');
end;

if nargin <3
  x=[];y=[];
end;
if nargin<5
  ind = find(~isnan(X(:)));
  minX = min(X(ind)),maxX = max(X(ind))
end;
if isempty(x)
  [m,n] = size(X);
  x = [1:n];
end;
if isempty(y)
  [m,n] = size(X);
  y=[1:m];
end;

h=image(x,y,(X-minX)./(maxX-minX)*length(colormap));
caxis([minX maxX]);
colorbar2;
