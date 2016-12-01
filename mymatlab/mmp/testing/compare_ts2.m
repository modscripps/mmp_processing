% compare_ts2.m - AMP and MMP T-S plots, by individual instruments
ampdrops = [17204:17228];
mmpdrops = [11405:11406];

%ampdrops=[17673:17698];
ampdrops=[17713:17720];
mmpdrops=[11446 11447 11449 11450];

ampdrops = [];
mmpdrops = [12638:12645];
%mmpdrops = [12577:12585];

mmpdrops = [12675:12678];
%mmpdrops = [12577:12585];

mmpdrops = [12782:12796];

mmpdrops = [12876:12878 12888:12900];
mmpdrops = [12950:12956];
mmpdrops = [13170:13174];
mmpdrops = [13316:13319 13345:13360];

figure
hold on
% loop over and plot amp tc
ampfolders
for ido = 1:length(ampdrops)
   ampid = read_ampid(ampdrops(ido));
   [pr,t,th,s,sgth] = get_thetasd1_amp(ampdrops(ido),'temp','theta','salinity','');
   if strcmp(ampid,'amp7'), colour = 'y'; end
   if strcmp(ampid,'amp8'), colour = 'c'; end
   plot(s*1000,th,'b-'); display(ampdrops(ido)); pause
   plot(s*1000,th,colour);
end

% loop over and plot mmp tc
mmpfolders
for ido = 1:length(mmpdrops)
   mmpid = read_mmpid(mmpdrops(ido));
   [p,t,th,s,sgth]=get_thetasd2_mmp(mmpdrops(ido),'t','th','s','sgth',0);
   if strcmp(mmpid,'mmp1'), colour = 'k'; end
   if strcmp(mmpid,'mmp2'), colour = 'r'; end
   if strcmp(mmpid,'mmp3'), colour = 'g'; end
   plot(s*1000,th,'b-'); display(mmpdrops(ido)); pause
   plot(s*1000,th,colour);
end



