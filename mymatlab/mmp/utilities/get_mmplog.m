function mmplog=get_mmplog(display,cruise)
% Usage: mmplog=get_mmplog(display,cruise);
%  Inputs:
%    display: Set to 1 to display format of mmplog
%             Set to 0 to return log of cruise
%    cruise: string cruise name, e.g. 'mar96'
%  Function: to display
%  Source: matlab:mmp:utilities:get_mmplog.m


if display==1
  disp_str=['Format of mmplog:\n' ...
  				'   column 1: drop,   column 2: year,   column 3: yday\n' ...
				'   column 4: lat,    column 5: lon,    column 6: burst\n' ...
				'   column 7: pmin,   column 8: pmax,   column 9: hmin\n' ...
				'  column 10: hmax,  column 11: mmpid\n'];
  fprintf(disp_str)
elseif display==0 & isstr(cruise)
  mmpfolders
  ld_str=['load ' setstr(39) procdata '\' cruise '\mmplog' setstr(39)];
  eval(ld_str)
end
