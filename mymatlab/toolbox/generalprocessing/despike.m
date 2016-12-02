function[dataout]=despike(datain,thresh,inter);
% [dataout]=despike(datain,thresh,inter);
%
% despike data by
%	-removing NaNs
%	-creating a smoothed version
% 	-replacing all data greater than thresh*1std >smoothed
%	interp to remove nans
ig=find(~isnan(datain));
datatemp=datain(ig);
b0=min(50,floor(length(datatemp)/3+1));
a=1; b=ones(1,b0)/b0;
datasmooth=filtfilt(b,a,datatemp);
datadiff=abs(datatemp-datasmooth);
ibig=find(datadiff>(thresh*std(datasmooth)));
datatemp(ibig)=NaN*ones(1,length(ibig));
ig1=find(~isnan(datatemp));
if strcmp(inter,'y')
   disp('interpolating')
   dataout=interp1(ig(ig1),datatemp(ig1),1:length(datain));
else
   dataout=NaN*ones(1,length(datain));
   dataout(ig)=datatemp;
end
