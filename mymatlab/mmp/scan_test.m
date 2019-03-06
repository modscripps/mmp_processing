%scan_test.m

PLOTS='n';

mmpfolders
global FSP
ch = 'sc';
drop = 19707;
scan_err=[];

%for drop=2400:2588
  sc=read_rawdata_mmp(ch,drop);
	dsc=diff(sc);
	if strcmp(PLOTS,'y')
	  clf
	  plot(dsc)
	  xlabel('scan number'), ylabel('difference in scan counts')
	  title_str=['mmp' int2str(drop)];
	  title(title_str)
	end
	err=find(dsc~=4 & dsc~= -16380);
	if ~isempty(err)
	  %msg=['drop ' int2str(drop) ' has ' int2str(size(err)) ' scan errors'];
		%disp(msg)
		%disp(int2str(diff(err)))
		scan_err=[scan_err drop];
    else
        disp('no scan error! woohoo!')
	end
%end
