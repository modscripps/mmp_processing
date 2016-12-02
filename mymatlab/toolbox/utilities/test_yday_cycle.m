%test_yday_cycle.m
% Tests conversion of calendar days and standard time to
% decimal yeardays and then back.
% M.Gregg, 17sep96

clear

year=1996;

days_per_month=[31 28 31 30 31 30 31 31 30 31 30 31];
if rem(year,4)==0 & year ~= 2000 % allow for leap years
	days_per_month(2)=29;
end

errtol=0.1/(365*24*3600); % 0.1 sec in terms of yday

for month=1:12
  ndays=days_per_month(month);
  for day=1:ndays
	  for hour=0
		  for minute=0
			  for second=0
	        yday=yearday(day,month,year,hour,minute,second);
          [mo,d,h,mi,s]=yday_to_caltime(year,yday);
					yy=yearday(d,mo,year,h,mi,s);
	        if abs(yday-yy)>errtol
						  str1=['month=' num2str(month) ', day=' num2str(day) ', hour=' num2str(hour) ...
							      ', minute=' num2str(minute) ', second=' num2str(second)];
							disp(str1)
							str2=['mo=' num2str(mo) ', d=' num2str(d) ', h=' num2str(h) ...
							      ', mi=' num2str(mi) ', s=' num2str(s)];
							disp(str2)
							format long
							str3=['yday=' num2str(yday) ', yy=' num2str(yy)];
							disp(str3)
	            error
	        end
	      end
	    end
	  end
	end
end
