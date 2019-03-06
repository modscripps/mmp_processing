function [chi, pr_chi, MLEout]=get_chi1_mmp(drop);% Usage: function [chi, pr_chi]=get_chi1_mmp(drop);%   drop is the integer drop number%   pr_eps is the pressure at the center of the epsilon window.%   Edited by ECF 6/28/18 to return MLEchi too %   Edited by ECF 7/2/18 to parallel get_eps in deciding what chi to returnmmpfolderscruise=read_cruises_mmp(drop);RATIO=4; % max allowable ratio between MLE1 & MLE2 for them to be averaged% set up string names of files to openfstr1=[procdata cruise filesep 'chi' filesep 'chi' int2str(drop) '.mat'];chi = [];pr_chi = [];MLEchi = [];% load eps<drop>if exist(fstr1)~=2	nodata_str=['get_chi1_mmp: ' fstr1 ' does not exist'];	disp(nodata_str)else	ld_str=['load ' setstr(39) fstr1 setstr(39)];	eval(ld_str)end% Decide which MLE to returnMLE1=MLEchi(:,1);MLE2=MLEchi(:,2);  % Take MLEchi as the nan mean of  MLE1 and  MLE2.  MLEout = nanmean(MLEchi,2);  % If  MLE1 &  MLE2 are not NaNs and one is more than RATIO  % times the other, take the lower assuming that the higher  % level was produced by a plankton impact.  i=find( MLE1<RATIO* MLE2);  MLEout(i)= MLE1(i);  i=find( MLE2<RATIO* MLE1);  MLEout(i)= MLE2(i);