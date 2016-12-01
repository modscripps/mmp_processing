for i=1:129
subplot(2,1,1)
plot(pr,log10(pv1(i,:)))
hold on
plot(pr,log10(pv2(i,:)),'r')
title(num2str(f(i)))
subplot(2,1,2)
plot(pr,log10(pa1(i,:)))
hold on
plot(pr,log10(pa2(i,:)),'r')
pause
clf
end


for i=1:26
subplot(2,1,1)
loglog(f,pv1(:,i))
hold on
loglog(f,pv2(:,i),'r')
title(num2str(pr(i)))
subplot(2,1,2)
loglog(f,pa1(:,i))
hold on
loglog(f,pa2(:,i),'r')
pause
clf
end



for i=1:51
[Pa1,Pa2,Pv1,Pv2,f]=a1a2v1v2spec_mmp(6677, pr(i), pr(i)+.01);
pa1(:,i)=Pa1(:); pa2(:,i)=Pa2(:); pv1(:,i)=Pv1(:); pv2(:,i)=Pv2(:); F(:,i)=f(:);
i
end