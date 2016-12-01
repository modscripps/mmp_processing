function hdg2=kvh1_mmp(drop,test_kvh1)
% Usage: hdg=kvh1_mmp(drop,test_kvh1);
%  inputs:
%    drop:integer drop number
%    test_kvh1: optional string.  Set to 'y' to plot.
% Function: Reads data for kvh sensor in mmp3.  The data are
%   shifted forward 2 samples to compensate for the delay in
%   the the data system relative to the A/D channels.  Two NaNs
%   are put at the end to retain one sample per scan.  The data are
%   then scaled as heading in degrees clockwise from magnetic north,
%   using the magnetic variation for the cruise, which is in a
%   file in the the cal folder of the mmp database.
%   The samples where the output is updated, every third sample,
%   are identified and retained.  Samples in between are replaced
%   with linear interpolations between successive updated samples.
%   	If the test plot is selected, the original data, after
%   being shifted, are plotted as dots with the updated values circled
%   in red.  The interpolated values are plotted as green crosses.
%   Use zoom to see individual points.
% M.Gregg, 24jul96

SHIFT=2;  % Number of samples to shift signal forward to
          % align it in time with signals sampled with the A/D
if nargin<2
  test_kvh1='n';
end

% Scale to magnetic heading
hdg0=0.1*read_rawdata_mmp('kvh',drop);

% Shift signal ahead and put equivalent number of NaNs at the end
n=length(hdg0);
hdg0=hdg0(:);
hdg1=[hdg0(SHIFT+1:n); NaN*ones(SHIFT,1)];

% Find values where signal was updated and put these into hdg2
i_update=1:3:n;
hdg2=NaN*ones(size(hdg1));
hdg2(i_update)=hdg1(i_update);

% Find samples where signal is held constant
i_cst=find(isnan(hdg2));

% Fill spaces between updated samples with linear interpolations
% between successive updated samples.
hdg2(i_cst)=interp1(i_update,hdg2(i_update),i_cst);

% Plot if specified
if strcmp(test_kvh1,'y')
  figure
  mmpid=read_mmpid(drop);
  Hl_original=plot(hdg1,'.');
  set(Hl_original,'linewidth',2)
  hold on
  plot(i_update,hdg2(i_update),'or')
  plot(i_cst,hdg2(i_cst),'xg')
  xlabel('scan number')
  ylabel('heading / degrees')
  title_str=['drop=' int2str(drop) ', ' mmpid];
  title(title_str)
end
