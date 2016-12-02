%swims_griddata_course.m

clear
close all

cruise = 'ml04';
yday = [310.6343 310.7381];

eval([cruise '_folders'])


ctd=get_swims_data(yday(1), yday(end), swims_griddata_indexfile, swims_griddata_datapath);

[dist, cum_dist, course] = nav2(ctd.lat, ctd.lon);

plot(ctd.yday(2:end), course, '.')