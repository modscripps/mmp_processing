function columnfill(x,y,c,y0,v)
% Usage: columnfill(x,y,c,y0,v)
%  Inputs: 
%    x: vector of length n with x-coord of column centers
%    y: vector of length n with column heights
%    c: vector of length n with column colors
%    y0: optional scalar for minimum column height
%    v: 0 for x along the horizontal axis
%       1 for x along the vertical axis with y increasing upward
%      -1 for x along the vertical axis with y decreasing upward
%
% Function: Creates a stairstep plot of centered columns
%  on the
% Check for minimum number of inputs and set defaults for y0 & v
if nargin<3
  error('At least three input arguments are required')
elseif nargin==3
  ig=find(~isnan(y));
  y0=min(y(ig)); % default value for base of columns
  v=0; % default setting with graph along x-axis
elseif nargin==4
  v=0; % default setting with graph along x-axis
end

if isstr(x) | isstr(y)
  error('x, y, and y0 cannot be strings')
end

if nargin<4
  y0=min(y);
end

% Check dimensions.
[mx,nx]=size(x); [my,ny]=size(y); %[mc,nc]=size(c);
if min(mx,nx)>1 | min(my,ny)>1 % | min(mc,nc)>1
  error('Input arguments must be vectors, not matrices')
end
if max(mx,nx)~=max(my,ny) 
  error('Input x and y vectors must have the same dimensions')
end
%if max(mc,nc)>1 & max(mc,nc)~=max(mx,nx)
%  error('If c has more than 1 character, it must equal x & y')
%end
if min(size(y0)>1)
  error('y0 must be a scalar')
end

% Transpose if x & y are column vectors
if (nx==1 & mx>1) x=x'; end
if (ny==1 & my>1) y=y'; end
npts=length(x);

% Set up polygon matrices to use in calling fill
xcol=NaN*ones(4,npts); ycol=NaN*ones(4,npts);

% Fill xcol
dx=diff(x);
xcol(1,:)=[x(1)-dx(1)/2 x(2:npts)-dx/2];
xcol(2,:)=[x(1)-dx(1)/2 x(2:npts)-dx/2];
xcol(3,:)=[x(1:npts-1)+dx/2 x(npts)+dx(npts-1)/2];
xcol(4,:)=[x(1:npts-1)+dx/2 x(npts)+dx(npts-1)/2];

% Fill ycol
ycol(1,:)=y0*ones(1,npts); 
ycol(2,:)=y;
ycol(3,:)=y;
ycol(4,:)=y0*ones(1,npts);

% Make plot with orientation specified by v
if v==0
  fill(xcol,ycol,c)
elseif v==1
  fill(ycol,xcol,c)
elseif v==-1
  fill(ycol,xcol,c)
  set(gca,'ydir','reverse')
end

% Bring axes on top of plot
set(gca,'layer','top')

caxis([-.1 1.1])
