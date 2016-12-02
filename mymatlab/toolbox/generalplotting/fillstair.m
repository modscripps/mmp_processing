function h=fillstair(x,y,base,value,color,edgecolor);

%
%    FILLSTAIR                Ren-Chieh Lien             12/16/93
%
%   function fillstair(x,y,base,value,color,edgecolor);
%
%   Ex. fillstair(time,sst,'x',25,'r','r')
%
%       shading sst (in y axis) relative to 25 degree c with a red color
%
%       fill stair(epsilon,pr,'y',1.0e-13,'b')
%     
%       shading epsilon (in x axis)  relative to 1.0e-13 with a blue color
%
%

x=x(:)'; y=y(:)';

bk = 1- get(gcf,'color');
if (base~='y');
 	x = [x(1) (x(2:length(x))+x(1:length(x)-1))/2 x(length(x))];
      	y(length(y)+1) = y(length(y));
      	[x,y]=stairs(x,y);
      	nx = [x(1) x' x(length(x))];
      	ny = [value y' value];
      	bad = find(isnan(nx.*ny));
      	if (length(bad) > 0);
         	ny(bad) = value*ones(1,length(bad));
      	end
else
      	y = [y(1) (y(2:length(y))+y(1:length(y)-1))/2 y(length(y))];
      	x(length(x)+1) = x(length(x));
      	[x,y]=stairs(y,x);
      	ny = [x(1) x' x(length(x))];
      	nx = [value y' value];
      	bad = find(isnan(nx.*ny));
      	if (length(bad) > 0);
         	nx(bad) = value*ones(1,length(bad));
      	end
end

h = fill(nx,ny,color);

if exist('edgecolor');
      	if ~strcmp(edgecolor,'none');
          	set(h,'edgecolor',edgecolor);
          	hline = get(h,'children');
          	set(hline,'edgecolor',edgecolor);
      	else
      		set(h,'edgecolor','none');
      	end
else
      	set(h,'edgecolor','none');
end
