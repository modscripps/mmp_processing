
er=ones(20,4);
nutest=ones(20,4);
f=NaN*ones(20,4);

epsilon=logspace(-10,0,20);
kvis=(1.0e-6:0.2e-6:1.6e-6);

for i=1:s(1)
	for j=1:s(2)
		er(i,j)=epsilon(i);
		nutest(i,j)=kvis(j);
		f(i,j)=epsilon2_correct(er(i,j),nutest(i,j));
		
	end
end

