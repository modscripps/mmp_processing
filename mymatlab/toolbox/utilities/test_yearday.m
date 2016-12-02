%test.m

clear
format short
days_per_month=[31 28 31 30 31 30 31 31 30 31 30 31];
day_per_sec=1/(24*3600);
year=1966;

last_yday=0;

for month=1:12
  ndays=days_per_month(month);
  for day=1:ndays
	  for hour=0:23
		  for minute=0:59
			  for second=0:59
	        [yday]=yearday(day,month,year,hour,minute,second);
					err=abs(last_yday-yday)-day_per_sec;
          if err>day_per_sec/10
					    format long
						  str1=['yday=' num2str(yday) ', last_yday=' num2str(last_yday)];
							disp(str1)
			        error
					else
					    last_yday=yday;
	        end
	      end
	    end
	  end
	end
end
