% merge two
load mmp_burst3
last=8;
Epsilon1=Epsilon(:,1:last); Sal1=Sal(:,1:last); 
Sigmat1=Sigmat(:,1:last); Theta1=Theta(:,1:last); 
Obs1=Obs(:,1:last); 
drops1=drops(1:last);
mmp1=mmp(1:last);
yday1=yday(1:last);

load mmp_burst3b
Epsilon=[Epsilon1 Epsilon];
Obs=[Obs1 Obs];
Sal = [Sal1 Sal];
Sigmat=[Sigmat1 Sigmat];
Theta=[Theta1 Theta];
drops=[drops1; drops];
mmp=[mmp1;mmp];
yday=[yday1;yday];

save mmp_burst3_full Obs Epsilon pr_obs Sal Sigmat Theta drops mmp yday pr_eps pr_theta
