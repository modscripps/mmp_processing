% run_a1a2v1v2spec_mmp.m

drops=[6601 6607 6609 6611 6614 6616 6619 6621 6623 6625 6627 ...
   6629 6631];
plb=0.1; pub=0.3;

for i=1:length(drops)
   a1a2v1v2spec_mmp(drops(i),plb,pub)
   print -dwinc
   pause(10)
   close
end