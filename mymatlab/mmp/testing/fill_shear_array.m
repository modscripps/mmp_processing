% fill_shear_array.m

dk=.5;
k=dk:dk:100;
kvis=.8e-6;

logeps=[-11:.5:0];
shearsq=zeros(23,200);

%clf
%wysiwyg
%wygiwys

for i=1:23
   epsilon=10^logeps(i); 
   [kp,Pp] = panchev(epsilon,kvis,k);
   shearsq(i,:)=dk*cumsum(Pp);
end

% plot shearsq as fcn of logeps for selected k
%figure
%ks=[1:10:100];
%semilogy(logeps,shearsq(1:23,ks))
%xlabel('log_{10}\epsilon / W kg^{-1}')
%ylabel('Shear^2')

% plot log10(epsilon) as function of shearsq for selected k
%figure
ks=[1:10:100];
semilogx(shearsq(1:23,ks),logeps,'b')
ylabel('log_{10}\epsilon / W kg^{-1}')
xlabel('Shear^2')