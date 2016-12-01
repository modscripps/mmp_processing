% plot_cond_shifts
%   Usage: call after running batchprocessing1_mmp and stopping
%      processing after calc_csbe1_mmp.  This script needs
%      temp,cond, and pr_thetasd
%   Function: calculates salinity for a range of offsets
%      between temp and cond.  The for loop should be edited to
%      set the steps by which cond is moved toward the start of
%      the file.  Temp, cond, and salinity are plotted.
   
clf
orient tall

i0=450; % first temp value
i1=479; % last temp value
i=(i0:i1); % indices of temperature
tfile=temp(i);
p=pr_thetasd(i);

shift_start=0.9;
shift_step=0.05;
shift_stop=1.2;
i2=(i0:i1+ceil(shift_stop));

for shift=shift_start:shift_step:shift_stop
	ishift=i+shift; % indices to interpolate onto
	cfile=interp1(i2,cond(i2),ishift);
	S=1000*salinityfcn(cfile,tfile,p);

	% plot temp
	rect=[.15, .1, .75, .25];
	axes('position',rect)
	plot(tfile)
	hold on
	plot(tfile,'+')
	hold off
	axis([0 length(tfile) min(tfile) max(tfile) ])
	str=['sample no - ' num2str(i0)];
	xlabel(str);

	% plot cond
	rect=[.15, .4, .75, .25];
	axes('position',rect)
	plot(cfile)
	hold on
	plot(cfile,'+')
	hold off
	ylabel('c')
	axis([0 30 min(cfile) max(cfile) ])

	% calculate & plot salinity
	rect=[.15, .7, .75, .25];
	axes('position',rect)
	plot(S)
	hold on
	plot(S,'+')
	hold off
	ylabel('S')
	axis([0 30 min(S) max(S) ])
	str=['mmp242, cond shifted ' num2str(shift) ' pt forward'];
	title(str)
	
	pause
	clf
end

