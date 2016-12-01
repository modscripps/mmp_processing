function dataV=atod1_mmp(dataC)
% atod1_mmp
%   Usage: dataV=atod1_mmp(dataC)
%      dataC is a vector of mmp data in counts
%      dataV is a data vector in volts
%   Function: convert mmp data from counts to volts

volt_per_count=10/(2^16-1);
dataV=volt_per_count .* dataC;
