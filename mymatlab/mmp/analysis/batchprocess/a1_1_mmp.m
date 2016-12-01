function ac=a1_1_mmp(drop)
% a1_1_mmp
%   Usage: ac=a1_1_mmp(drop)
%      drop is the integer drop number
%      ac is a vector array of acceleration in m/s^2
%   Function: read raw a1 data for drop and convert to acceleration units

Sa=1; % nominal sensitivity, volt per G

% set electronics gainif drop<=761
   Gac=100;
else
   Gac=21;
end

ac=read_rawdata_mmp('a1',drop); % read raw data in counts
ac=atod1_mmp(ac); % convert to volts

% convert to acceleration, m^2/s
ac=1/(Gac*Sa)*ac;