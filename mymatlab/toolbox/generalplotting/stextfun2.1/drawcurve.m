
   function [smoothedx,smoothedy,h]=drawcurve();

   [x,y,button]=ginput(2);

   order = 3;
   beta = 2.0;
   x = x'; y = y';
   h = plot(x,y);

   while button~=3;

	 [nx,ny,button]=ginput(1);
	 x = [x nx];
	 y = [y ny];

         smoothedy = smoothing(y,order,beta);
         smoothedx = smoothing(x,order,beta);

         delete(h)
         h = plot(smoothedx,smoothedy);
   end
