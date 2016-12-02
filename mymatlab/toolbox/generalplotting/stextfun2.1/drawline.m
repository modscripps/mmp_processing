
   function [x,y,h]=drawline();

   [x,y,button]=ginput(2);

   x = x'; y = y';
   h = plot(x,y);

   while button~=3;

	 [nx,ny,button]=ginput(1);
	 x = [x nx];
	 y = [y ny];

         delete(h)
         h = plot(x,y);
   end
