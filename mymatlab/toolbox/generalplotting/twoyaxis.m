%
%        twoyaxis(x1,y1,x2,y2,position)
%
   function twoyaxis(x1,y1,x2,y2,position);

   axes('position',position,'box','off')
   hold on
   plot(x1,y1,'-')
   axis([min(x1) max(x1) 0.97*min(y1) 1.03*max(y1)])
   axes('position',position,'box','off')
   hold on
   plot(x2,y2,'r')
   axis([min(x1) max(x1) 0.95*min(y2) 1.05*max(y2)])
   hold on
   rightaxis(2)
