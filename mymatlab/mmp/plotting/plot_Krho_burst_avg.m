% plot_Krho_burst_avg

d=[5 7030 7040;
   7 7043 7052;
   8 7053 7063;
   9 7064 7075;
   10 7076 7085;
   11 7086 7094;
   12 7095 7103];

[m,n]=size(d);
figure

for i=m:m
   clf
	[epsilon,nsq,Krho,p]=Krho_drops(d(i,2):d(i,3),.1,3,.1);
   Hp=stair_plot(log10(Krho),p,'y','y');
   set(gca,'ydir','rev')
   ylabel('p / MPa')
   xlabel('K_{\rho} / m^2 s^{-1}')
   title_str=['MMP burst ' num2str(d(i,1)) ', average of unedited epsilons'];
   title(title_str)
   print -dwin
end

   