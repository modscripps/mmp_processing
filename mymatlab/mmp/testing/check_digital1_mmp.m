% check_digital1_mmp.m
% Function: Plots raw data from pr, tsbe, and csbe for an
%  mmp drop.  The drop number is requested as an input.

drop=input('drop ');
mmpid=read_mmpid(drop);

% Get raw digital data in counts
pr=read_rawdata_mmp('pr',drop);
tsbe=read_rawdata_mmp('tsbe',drop);
csbe=read_rawdata_mmp('csbe',drop);

title_str=[mmpid ' drop ' int2str(drop)];
figure
orient tall

subplot(3,2,1)
plot(pr(:,1))
ylabel('pr N_s / counts')
title(title_str)

subplot(3,2,2)
plot(pr(:,2))
ylabel('pr N_r / counts')

subplot(3,2,3)
plot(tsbe(:,1))
ylabel('tsbe N_s / counts')

subplot(3,2,4)
plot(tsbe(:,2))
ylabel('tsbe N_r / counts')

subplot(3,2,5)
plot(csbe(:,1))
ylabel('csbe N_s / counts'), xlabel('sample number')

subplot(3,2,6)
plot(csbe(:,2))
ylabel('csbe N_r / counts'), xlabel('sample number')