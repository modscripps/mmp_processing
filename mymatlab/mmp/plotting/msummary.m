% multiple summary plots


drop1=[7275,7286,7296,7308,7320,7332,7344,];
drop2=[7285,7295,7307,7319,7331,7343,7355];
for i=1:length(drop1)
   close all
   summary_plot1_mmp(drop1(i),drop2(i));
   figure(1)
   print -dwinc
   figure(2)
   print -dwinc
   clf
   summary_plot2_mmp(drop1(i),drop2(i));
   print -dwinc
end