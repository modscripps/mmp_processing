
   load /net/triton/export/home5/lien/tiwe/statistics/dclprop/dclprop

   bt = 308; et = 347;
   titext = ['Days ' int2str(bt) ' - ' int2str(et) ' Multitapered' ];
   good = find(jdays(1:914) >= bt & jdays(1:914) <= et);
   if (rem(length(good),2) == 1);
       good(length(good))= [];
   end

   epsilon = log10(dceps(good));
   S2 = dclS2(good);
   N2 = dclN2(good);
   Ri = N2./S2;

   load /net/triton/export/home5/lien/tiwe/combined/meteo/combmeteo
   taux = fituwosutaux((good));
   tauy = fituwosutauy((good));
   tau = fituwosutau((good))-mean(fituwosutau(good));
   Jb = fituwosujb(good);
   rho = 1000;
   simeps = tau.*(S2.^(1/2))/rho;
   simeps = log10(simeps);


%  [rainbow,mff]=prism(detrend(epsilon(:)),detrend(taux(:)),...
%       6/2/length(epsilon),1/24);
%   spx = rainbow(:,1); spy = rainbow(:,2);
%   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
%   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
%       'S_log_{10}({\symb e})','S_{{\symb t}_x}',...
%       'Frequency (cpd)',titext);

%   [rainbow,mff]=prism(detrend(tau(:)),detrend(S2(:)),...
%       6/2/length(tau),1/24);
%   spx = rainbow(:,1); spy = rainbow(:,2);
%   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
%   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
%       'S_{\symb t}','S_{S^2}',...
%       'Frequency (cpd)',titext);

   [rainbow,mff]=prism(detrend(Jb(:)),detrend(tau(:)),...
		       6/2/length(epsilon),1/24);
   spx = rainbow(:,1); spy = rainbow(:,2);
   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
       'S_{J_b}','S_{\symb t}',...
       'Frequency (cpd)',titext);
   print

   [rainbow,mff]=prism(detrend(epsilon(:)),detrend(simeps(:)),...
		       6/2/length(epsilon),1/24);
   spx = rainbow(:,1); spy = rainbow(:,2);
   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
       'S_{log_{10}({\symb e})','S_{log_{10}({\symb e}_{sim})',...
       'Frequency (cpd)',titext);
   pause

   [rainbow,mff]=prism(detrend(epsilon(:)),detrend(S2(:)),...
		       6/2/length(epsilon),1/24);
   spx = rainbow(:,1); spy = rainbow(:,2);
   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
       'S_{log_{10}({\symb e})','S_{S^2}',...
       'Frequency (cpd)',titext);
   print
   break

   [rainbow,mff]=prism(detrend(epsilon(:)),detrend(N2(:)),...
		       6/2/length(epsilon),1/24);
   spx = rainbow(:,1); spy = rainbow(:,2);
   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
       'S_{log_{10}({\symb e})','S_{N^2}',...
       'Frequency (cpd)',titext);
   print

   [rainbow,mff]=prism(detrend(epsilon(:)),detrend(Ri(:)),...
		       6/2/length(epsilon),1/24);
   spx = rainbow(:,1); spy = rainbow(:,2);
   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
       'S_{log_{10}({\symb e})','S_{Ri}',...
       'Frequency (cpd)',titext);
   print

   [rainbow,mff]=prism(detrend(epsilon(:)),detrend(taux(:)),...
		       6/2/length(epsilon),1/24);
   spx = rainbow(:,1); spy = rainbow(:,2);
   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
       'S_{log_{10}({\symb e})','S_{{\symb t}_x}',...
       'Frequency (cpd)',titext);
   print

   [rainbow,mff]=prism(detrend(epsilon(:)),detrend(tauy(:)),...
		       6/2/length(epsilon),1/24);
   spx = rainbow(:,1); spy = rainbow(:,2);
   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
       'S_{log_{10}({\symb e})','S_{{\symb t}_y}',...
       'Frequency (cpd)',titext);
   print

   [rainbow,mff]=prism(detrend(epsilon(:)),detrend(tau(:)),...
		       6/2/length(epsilon),1/24);
   spx = rainbow(:,1); spy = rainbow(:,2);
   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
       'S_{log_{10}({\symb e})','S_{\symb t}',...
       'Frequency (cpd)',titext);
   print

   [rainbow,mff]=prism(detrend(epsilon(:)),detrend(Jb(:)),...
		       6/2/length(epsilon),1/24);
   spx = rainbow(:,1); spy = rainbow(:,2);
   coh = rainbow(:,3); pha = rainbow(:,4)*180/pi;
   plspanalysis(mff,spx,spy,coh,pha,[0.02 20],...
       'S_{log_{10}({\symb e})','S_{J_b}',...
       'Frequency (cpd)',titext);
   print
