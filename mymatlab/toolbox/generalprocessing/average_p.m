function [yavg, navg, pavg]=average_p(y,p,prlb,prub,dp)
% [yavg, navg, pavg]=average_p(y,p,prlb,prub,dp); - avg y between prlb & prub in 
%   dp increments
% lower bound is closed, upper is open, e.g. 1st possible bin is [prlb<= p < 
%   prlb+dp

% M.Gregg. Revised to average only bins having some data, 30aug96
% D.Winkel - revised to retain requested pres grid, but place
% NaNs where no data were found

% Remove NaNs from y & p
ig=find(~isnan(y) & ~isnan(p));
y=y(ig); p=p(ig);

pavg=(prlb+dp/2:dp:prub); % maximum array of output pressures
n=length(pavg); % maximum number of output samples
yavg=zeros(n,1); navg=zeros(n,1); 

% do the averaging
i=1;
while i <= n
	idata=find(p>=pavg(i)-dp/2 & p<pavg(i)+dp/2);
	if ~isempty(idata)
	  yavg(i)=mean(y(idata));
	  navg(i)=length(idata);
	end
	i=i+1;
end

% place NaN's where no data were averaged
% (retain complete pressure grid with indexing)
yavg( find(navg<1) ) = NaN;
