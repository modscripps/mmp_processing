function f=coriolis(lat)
%   Usage: f=coriolis(lat);
%     lat is the latitude in degrees
%     f is the Coriolis parameter in radians per second

f=2 * ((2*pi)/(24*3600)) * sin(lat*pi/180);
