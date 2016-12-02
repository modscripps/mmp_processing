%isopyccprop: 
%------------------------------------------------------------------------------
%
%           ISOPYCPROP             03-22-94            Ren-Chieh Lien
%
%           properties on the isopycnal surface
%
%------------------------------------------------------------------------------


%   load /ue/lien/tiwe/combined/theta_sd/combsigma1m
%   load /ue/lien/tiwe/combined/theta_sd/combsalin1m
%   load /ue/lien/tiwe/combined/theta_sd/combtheta1m

    
    givendepth = [60 70 80];

    axes('pos',[0.1 0.3 0.8 0.4]);

    linetype = [' -';'--';' :'];
    for k = 1:length(givendepth);

        sigma = mymean(fituwosusigma1m(givendepth(k),:)',20,30,NaN);
        depth = isopycnal(fituwosusigma1m,sigma);
        for i=1:915;
            theta(i) = fituwosutheta1m(depth(i),i);
            salin(i) = fituwosusalin1m(depth(i),i);
        end
        plot(fituwosujday,salin,linetype(k,:));
        axis([330 347 34.9 35.5]);
        hold on
    end
%   [mins,maxs]=myminmax(salin');
%   axis([308 347 mins maxs]);
    xlabel('Day')
    ylabel('Salinity')
    titext = [' On Density Surface (sigma_theta = ' num2str(sigma) ...
      ' , mean depth at ' int2str(givendepth) ' m)'];
%   title(titext)
