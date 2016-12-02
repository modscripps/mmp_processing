function [month,month_day,hour,minute,second]=yday_to_caltime(year,yday);
% Usage: [month,month_day,hour,minute,second]=yday_to_caltime(year,yday);
%  inputs:
%    year: integer year
%    yday: decimal year day as elapsed time from midnight on 1 Jan
%  outputs:
%    month: integer month
%    month_day: integer day of month
%    hour: integer hour
%    minute: integer minute
%    second: decimal second
% Function: To determine standard calender date and time
%   from decimal year day.
% M.Gregg, 17sep96

% Set up a vector containing the number of days per month
month_days=[31 28 31 30 31 30 31 31 30 31 30 31];
if rem(year,4)==0 & year ~= 2000 % allow for leap years
	month_days(2)=29;
end
cum_mdays=cumsum(month_days); % cum days elapsed at end of each month

% Find the month
month=min(find(yday<cum_mdays));

% Find the day
year_days=floor(yday);  % # complete days elapsed this year
if month==1
  month_day=year_days+1;
else
  month_day=year_days-cum_mdays(month-1)+1; % subtract cum days in earlier months
end

% Find the hour
fday=yday-year_days; % fractional part of day elapsed
hour=floor(fday*24); % integer # hours elapsed

% Find the minute
fday=fday-hour/24; % fraction of day remaining in present hour
minute=floor(fday*(60*24));

% Find the decimal second
fday=fday-minute/(60*24); % fraction of day remaining in present minute
second=fday*(3600*24);
