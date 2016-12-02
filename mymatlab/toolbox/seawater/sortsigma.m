function sortsigma = sortsigma(sigma);
%sortsigma: ss=sortsigma(sigma_profile) - sorts density ??

     [ndepth,nprof]=size(sigma);

     sortsigma = NaN*ones(ndepth,nprof);

     for i = 1:nprof;
	 [i nprof]
         good = find(sigma(:,i) ~= NaN & sigma(:,i) >= 20 & sigma(:,i) <= 28);
	 if (length(good) > 20);
  	    sortsigma(good,i) = sort(sigma(good,i));
         end
	 clear good
     end
