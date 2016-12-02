function [yday]=yearday(day,month,year,hours,minutes,sec)
% Usage: [yday]=yearday(day,month,year,hours,minutes,sec), e.g. year_day(3,7,1994,7,40,3)
%  inputs:
%    day: day of month, e.g. 1 for first day, 31 for last day of August
%    month: month as an integer
%    year:
%    hours: integer hours elapsed in this day, 0 for 1230 am, 23 for 1130 pm 
%    minutes: integer minutes elapsed in this hour
%    sec: decimal seconds elapsed in this minute
%  output:
%    yday: Fraction of year elapsed to present moment.  Hence,
%     1201 am on 31 Jan is yday=1/(365*24*60) when the new year is 
%     not a leap year.
%  M.Gregg, revised 16sep96 to make  1 Jan day 0.  Previously,
%    1 Jan was day 1.

% Set up vector with the number of days in each month
%
%4/06: modified to take a single argument with the year, etc as columns, as
%output by datevec - MHA
%4/09: fixed a bug that caused leapyears to be done incorrectly for vector
%inputs.  Please note this will still be wrong by a day if a vector extends into a
%leap year past Feb 28, since it only checks the first entry for a leap year
if nargin < 6
    sec=0;
end
if nargin < 5
    minutes=0;
end
if nargin < 4
    hours=0;
end
if nargin == 1
    [m,n]=size(day);
    if m==6
        day=day';
    end
    
    sec=day(:,6)';
    minutes=day(:,5)';
    hours=day(:,4)';
    year=day(:,3)';
    month=day(:,2)';
    day=day(:,1)';
    
end

month_days=[31 28 31 30 31 30 31 31 30 31 30 31]; 
if (rem(year(1),4)==0 & year(1) ~= 2000) | rem(year(1),400)==0
	month_days(2)=29;
end
%OLD CODE pre 4/30/2011
%if (rem(year,4)==0 & year ~= 2000) | rem(year(1),400)==0
%	month_days(2)=29;
%end

% Calc days elapsed at start of each month
cumdays=cumsum(month_days); 
cumdays=[0 cumdays(1:11)];
%cumdays=[0 cumdays(1:11)]'; % 6/2010: transpose.

% Calc # of complete days elapsed
yday=cumdays(month) + day-1;

% Add fraction of day elapsed	
yday = yday + hours/24 + minutes/(24*60) + sec/(24*3600);

