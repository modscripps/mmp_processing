function [mag,dir]=xy2magdir(x,y);
% mag_dir.m
% Usage: [mag,dir]=xy2magdir(x,y);
%  inputs
%   x, y are any orthogonal components in an x,y system
%  outputs
%   mag is the absolute value of each x,y pair as a vector
%   dir is the direction of the vector, in degrees, as a 
%   positive angle clockwise from north.

mag=NaN*ones(size(x)); dir=NaN*ones(size(x));
ig=find(~isnan(x) & ~isnan(y));
mag(ig)=abs(x(ig)+i*y(ig));

i1=find(x>=0 & y>=0);     % quad 1
dir(i1)=angle(y(i1)+i*x(i1));

i2=find(x<0 & y>=0); % quad 2
dir(i2)=2*pi*ones(size(i2))+angle(abs(y(i2))+i*x(i2));
  
i3=find(x<=0 & y<0); % quad 3
dir(i3)=3*pi*ones(size(i3))/2-angle(abs(x(i3))+i*abs(y(i3)));

i4=find(x>0 & y<0); % quad 4
dir(i4)=pi*ones(size(i4))/2+angle(x(i4)+i*abs(y(i4)));

i2pi=find(dir==2*pi);
dir(i2pi)=zeros(size(i2pi));

dir=dir*180/pi;

%reshape(dir,m,n);
