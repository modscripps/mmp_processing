%------------------------------------------------------------------------------
%        mystair              03-27-94          Ren-Chieh Lien
%
%        The same as stairs, but centering the x grid
%
%      [xx,yy,h]=mystairs(x,y,linetype,xory);
%
%      Ex. [stairx,stairy,hobj]=mystairs(x,y,'r-','x');
%
%------------------------------------------------------------------------------

         function [xx,yy,h]=mystairs(x,y,linetype,xory);

x=x(:)'; y=y(:)';

if (nargin >= 4 ); 
	if (xory == 'y');
    l = length(y);
	  y = [y(1) (y(2:l)+y(1:l-1))/2 y(l)];
    x(l+1) = x(l);
	else
    l = length(x);
	  x = [x(1) (x(2:l)+x(1:l-1))/2 x(l)];
    y(l+1) = y(l);
  end
else
  l = length(x);
	x = [x(1) (x(2:l)+x(1:l-1))/2 x(l)];
  y(l+1) = y(l);
end

[xx,yy]=stairs(x,y);

if (nargin == 3);
	h = plot(xx,yy,linetype);
else
	h = plot(xx,yy);
end
