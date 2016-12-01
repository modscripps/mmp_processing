function tl=tl1_polyval_mmp(drop)

mmpfolders

% read raw tl data
tl1V=read_rawdata_mmp('tl1',drop);

cruise=read_cruises_mmp(drop);
str=['load ' setstr(39) procdata ':' cruise ':tl1:tlfit' int2str(drop) '.mat' ...
     setstr(39) ];
eval(str);

tl1V=atod1_mmp(tl1V);
tl=polyval(tlfit,tl1V);
