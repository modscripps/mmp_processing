% plot_Vspec_mmp


ch='v1';
drop=326;

spec_len=512;
FS=400;
df=FS/spec_len;
f=(df:df:df*spec_len/2)';

data=read_rawdata_mmp(ch,drop,'[]','[]');
data=atod1_mmp(data);
data=data(10000:length(data)); 

nspec=fix(length(data)/spec_len);
P=NaN*ones(spec_len/2,nspec);
for i=1:nspec
	start=(i-1)*spec_len+1;
	stop=start+spec_len-1;
	spec=psd(data(start:stop),spec_len,FS);
	P(:,i)=spec(2:length(spec));
end
P=P/(FS/2);

figure
loglog(f,P,'.')
xlabel('f / Hz'), ylabel('volts^2 / Hz')
str=['mmp' num2str(drop) ', ' ch];
title(str)
