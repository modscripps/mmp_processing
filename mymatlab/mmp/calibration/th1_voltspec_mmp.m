% th1_voltspec_mmp.m
%   Usage: called by batchprocess1_mmp
%   Function: 

FS_hf=400; 		  % sample rate of high-frequency channels
spec_size=512; 	  	% number of samples per epsilon & estimate
df=FS_hf/spec_size; % elementary frequency bandwidth
f=(df:df:df*spec_size/2)'; % frequency vector for spectra

droplist=242;
ndrops=length(droplist);

for i=1:ndrops
	drop=droplist(i);
	rawdata=read_rawdata_mmp('th1',drop,[],[]);
	rawdata=atod1_mmp(rawdata);
	nraw=length(rawdata);
	nspec=fix(nraw/spec_size);
	spec=NaN.*ones(nspec,length(f));
	
	for j=1:nspec
		first_sample=(j-1)*spec_size+1;
		last_sample=first_sample+spec_size-1;
		data=rawdata(first_sample:last_sample);
		P=psd(data,spec_size,FS_hf);
		P=P./(0.5*FS_hf);
		P=P(2:length(P)); % drop estimate at f=0
		spec(j,:)=P';
		loglog(f,spec(j,:),'.')
		hold on
	end
	
	%loglog(f,spec,'.')
	specmin=min(min(spec)); specmax=max(max(spec));
	fmin=min(f); fmax=max(f);
	axis([fmin fmax specmin specmax])
	xlabel('f / Hz'), ylabel('P_th1 / volts^2 / Hz')

	
end




end
