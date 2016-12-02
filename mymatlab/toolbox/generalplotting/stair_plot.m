function Hp=stair_plot(x,y,refaxis,extend,testing)
% Usage: Hp=stair_plot(x,y,refaxis,extend,testing);
%  inputs:
%    x,y: data vectors of equal length
%    refaxis: specify 'x' or 'y' as reference axis for stairs.
%      default is 'y'
%    extend: optional 'y' to extend stair step for first and
%      last points, assuming they are centered averages
%    testing: optional 'y' to overlay input data on stair steps
%  output:
%    Hp: handle to data plot
% Function:
%   To plot averaged data with stairsteps giving constant
%   values over the averaging interval.  The input data
%   are assumed to be centered averages, e.g. if y is specified
%   as the reference axis, the y values are taken as the centers
%   of the averaging intervals.
% M.Gregg, 31oct96 
%          09nov96: revised to make y the default reference axis
%            and to suppress the plot when each channel doesn't
%            have at least two data points

% Set defaults
if nargin<5
  testing='n';  % no testing
end
if nargin<4
  extend='n';   % 1st & last stairs not extended
end
if nargin<3
  refaxis='y';  % y axis
end

% Make inputs into column vectors
y=y(:); x=x(:);
xlen=length(x);
if xlen~=length(y)
  dispstr1=[' stair_plot: x and y vectors have different lengths'];
	disp(dispstr1)
	break
end

if xlen<2
  dispstr2=[' stair_plot: xlen < 2'];
	disp(dispstr2)
	break
end

if strcmp(refaxis,'y')
  % create x2 vector in which each x value is 
  % followed by a second sample with the same value
  x2=zeros(2*xlen,1); 
  x2(1:2:2*xlen)=x; x2(2:2:2*xlen)=x;
  %
	% create y2 vector with values midway between the original
	% y values
	y2=zeros(2*xlen,1);
	y2(1)=y(1); y2(2*xlen)=y(xlen);
	y2(2:2:2*xlen-2)=(y(1:xlen-1)+y(2:xlen))/2;
	y2(3:2:2*xlen-1)=(y(1:xlen-1)+y(2:xlen))/2;
	% 
	% if specified, extend first and last y values assuming
	% they represent averages over the distance y(2)-y(1) etc
	if strcmp(extend,'y')
	  y2(1)=y(1)-(y(2)-y(1))/2;
		y2(2*xlen)=y(xlen)+(y(xlen)-y(xlen-1))/2;
	end
elseif strcmp(refaxis,'x')
  % create y2 vector in which each y value is 
  % followed by a second sample with the same value
  y2=zeros(2*xlen,1); 
  y2(1:2:2*xlen)=y; y2(2:2:2*xlen)=y;
  %
	% create x2 vector with values midway between the original
	% x values
	x2=zeros(2*xlen,1);
	x2(1)=x(1); x2(2*xlen)=x(xlen);
	x2(2:2:2*xlen-2)=(x(1:xlen-1)+x(2:xlen))/2;
	x2(3:2:2*xlen-1)=(x(1:xlen-1)+x(2:xlen))/2;
	% 
	% if specified, extend first and last x values assuming
	% they represent averages over the distance x(2)-x(1) etc
	if strcmp(extend,'y')
	  x2(1)=x(1)-(x(2)-x(1))/2;
		x2(2*xlen)=x(xlen)+(x(xlen)-x(xlen-1))/2;
	end
else
  error('refaxis not setstr(39) y setstr(39) or setstr(39) x setstr(39) ')
end

Hp=plot(x2,y2);

if strcmp(testing,'y')
  hold on
  plot(x,y,'ow')
end
