
   function yorn=is_vector(f);

   [row,col]=size(f);

   if (row > 1 & col > 1);
      yorn = 0;
   else
      yorn = 1;
   end
