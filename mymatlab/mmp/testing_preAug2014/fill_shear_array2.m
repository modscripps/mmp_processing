% fill_shear_array2.m

kvis=(0.8:0.2:2)*1e-6;

% set up wavenumbers for integration
dk=.5;
k=dk:dk:200;

logeps=[-11:0];
shearsq=zeros(12,7);

for i=1:12
   epsilon=10^logeps(i); 
   for j=1:7
      ik=find(k>=2 &  k<=10);
      [kp,Pp] = panchev(epsilon,kvis(j),k(ik));
      shearsq(i,j)=dk*sum(Pp);
   end
end