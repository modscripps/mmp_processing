function T = tsbe_cal_mmp(f, calid)
% tsbe_cal_mmp(f, 'calid') Temp. from freq. for Sea Bird sensor on mmp 
%    f in kHz and drop no. as integer

mmpfolders;
calfile=[HD ':probecals:tsbe:' calid]

eval(calfile)
	  
x= log(f0 ./ f);

cc = a + b .* x + cal(3) .* c.^2 + d .* x.^3;
	
T = 1 ./ cc - 273.15;
