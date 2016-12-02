%------------------------------------------------------------------------------
%
%            MYMINMAX             12-29-92             Ren-Chieh Lien
%
%            Calculate minimum and maximum of time series containing 
%            NaN and Inf
%
%            function [minx,maxx]=myminmax(x);
%
%------------------------------------------------------------------------------
	 function [minx,maxx]=myminmax(x);
	 [nrow,ncol]=size(x);
	 for i=1:ncol;
	     nx = x(:,i);
             nx(isnan(nx) | isinf(nx) ) = [];
	     if ( isempty(nx) );
		minx(i) = NaN;
		maxx(i) = NaN;
             else
	        minx(i) = min(nx);
	        maxx(i) = max(nx);
             end
             clear bad nx
         end
