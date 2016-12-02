%
%    PLAINFILL               Ren-Chieh Lien             8/1/95
%
%   function plainfill(x,y,base,value,fillcolor,linecolor);
%
%   Ex. plainfill(time,sst,'x',25,'r','w')
%
%
   function [mx,my,h]=plainfill(x,y,base,value,color,linecolor);
   if isnan(x(1)*y(1)); x(1) = []; y(1) = [];end
   if isnan(x(length(x))*y(length(y))); x(length(x))=[]; y(length(y))=[];end
   if (base=='x');
      nx = [x(1) x(:)' x(length(x))];
      ny = [value y(:)' value];
      k = 0;
      for i=1:length(nx);
	  k = k+1;
	  if (isnan(nx(i)*ny(i)));
	     mx(k) = nx(i-1);
	     my(k) = value;
             k = k+1;
	     mx(k) = nx(i+1);
	     my(k) = value;
          else
	     mx(k) = nx(i);
	     my(k) = ny(i);
          end
      end
   else
      ny = [y(1) y(:)' y(length(y))];
      nx = [value x(:)' value];
      k = 0;
      for i=1:length(ny);
	  k = k+1;
	  if (isnan(ny(i)*nx(i)));
	     my(k) = ny(i-1);
	     mx(k) = value;
             k = k+1;
	     my(k) = ny(i+1);
	     mx(k) = value;
          else
	     mx(k) = nx(i);
	     my(k) = ny(i);
          end
      end
   end
   h = fill(mx,my,color);

   if exist('linecolor')
      if ~strcmp(linecolor,'none');
	 set(getallline(h),'color',linecolor);
      else
         set(h,'edgecolor','none');
      end
   else
      set(h,'edgecolor','none');
   end

