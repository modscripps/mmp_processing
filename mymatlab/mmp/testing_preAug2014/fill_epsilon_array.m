% fill_epsilon_array.m

kvis=0.8e-6;

logshsq=[-8:.5:6];
epsilon=zeros(29,100);

%clf
wysiwyg
wygiwys

for k=2:100
   for i=1:29
      epsilon=10^logeps(i); 
      [kp,Pp] = panchev(epsilon,kvis,k);
      shearsq(i,:)=dk*cumsum(Pp);
   end
end

% plot shearsq as fcn of logeps for selected k
figure
ks=[1:10:100];
semilogy(logeps,shearsq(1:23,ks))
xlabel('log_{10}\epsilon / W kg^{-1}')
ylabel('Shear^2')

% plot log10(epsilon) as function of shearsq for selected k
figure
ks=[1:10:100];
semilogx(shearsq(1:23,ks),logeps)
ylabel('log_{10}\epsilon / W kg^{-1}')
xlabel('Shear^2')