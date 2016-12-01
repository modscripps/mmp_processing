function pr=pr_offset_mmp(prG,ch,drop)
% pr=pr_offset_mmp(prG,'ch',drop)

% read appropriate offset file
mmpfolders;
[mmpno, prno, calid, offsetid]=read_pr_config_mmp(drop);
source_file=[mmpcals '\pr\offsets\' mmpno '_' offsetid '.mat'];
load(source_file)

% select which offset to apply
offset=['offset_' ch];

% Determine whether profile is upward or downward
if prG(1) < prG(length(prG)) % downward
	pr=prG + 0.01 .* eval(offset);
elseif prG(1) >= prG(length(prG)) % upward
 	pr=prG - 0.01 .* eval(offset);
end
