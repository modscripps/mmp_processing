% calc_fiber_mmp.m%Use within batchprocessing routines to calculate crg and related%refractometer variables.if drop_flag==1 & strcmp(mmpid,'mmp2s')	%Need nscans * 2 since we sample at 50 Hz	fiber.i1=NaN*ones(nscans*2,1);	fiber.i2=NaN*ones(nscans*2,1);	fiber.i3=NaN*ones(nscans*2,1);	fiber.i4=NaN*ones(nscans*2,1);	%These are just at 25 Hz	fiber.tld=NaN*ones(nscans,1);	fiber.trc=NaN*ones(nscans,1);	%And this is at 800 Hz	fiber.crg=NaN*ones(nscans*2*hfperscan,1);	%Output the 25 Hz pressure, offset properly.	fiber.pr=NaN*ones(nscans,1);	%Get i1-i4	for i=1:4		ch=['i' int2str(i)];		%		% Read & apply the algorithm		algorithm=read_algorithm_mmp(ch,drop);		x_str=['fiber.i' num2str(i) '=' algorithm '_mmp(ch,drop);'];		eval(x_str)	end	%temperatures -laser diode and reference coupler	ch='tld';	algorithm=read_algorithm_mmp(ch,drop);	x_str=['fiber.tld=' algorithm '_mmp(ch,drop);'];	eval(x_str)	ch='trc';	algorithm=read_algorithm_mmp(ch,drop);	x_str=['fiber.trc=' algorithm '_mmp(ch,drop);'];	eval(x_str)	%Coupling ratio gradient	ch='crg';	algorithm=read_algorithm_mmp(ch,drop);	x_str=['fiber.crg=' algorithm '_mmp(drop);'];	eval(x_str)	%Compute offset pressure - same as airfoils	fiber.pr=pr_offset1_mmp(drop,'v1',pr_scan);	%fiber.pr=pr_scan;	%Save the structure	sv_file=[procdata filesep cruise filesep 'fiber' filesep 'fiber' int2str(drop) '.mat'];	sv_str=['save ' setstr(39) sv_file setstr(39) ' fiber'];	eval(sv_str)end