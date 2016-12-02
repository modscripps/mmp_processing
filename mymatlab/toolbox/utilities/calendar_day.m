function [month, day, hour, minute, sec]=calendar_day(yearday,year)
% [month, day, hour, minute, sec]=calendar_day(yearday,year)
% inputs and outputs are numbers, not strings

MIN_DAY=24*60;
SEC_DAY=24*3600;

% month_days is the number of days in the previous month offset
% by 1 month
month_days=[0 31 28 31 30 31 30 31 31 30 31 30 31];

% adjust feb month_days for a leap year
if rem(year,4)==0 & year ~= 2000 % year 2000 is not a leap year
	month_days(3)=29;
end

% calculate month by comparing yearday with cumulative days
% elapsed at first of each month
day = floor(yearday); % now an integer
elapsed_days = cumsum(month_days);
month = floor(elapsed_days/floor(yearday)); % set previous months to 0
i = find(month>=1);
month = min(i)-1;

% calculate day of month by subtracting sum of days in earlier months
day = day - elapsed_days(month);

% calculate hour by removing days from yearday and 'fixing' remainder
fracday = yearday - floor(yearday);
hour = fix(24*fracday);

% calculate minutes by removing hours from remday and fixing remainder
remday = fracday - hour/24;
minute = fix(MIN_DAY*remday);

% seconds are what's left of remday
sec = (remday - minute/MIN_DAY) * SEC_DAY;
