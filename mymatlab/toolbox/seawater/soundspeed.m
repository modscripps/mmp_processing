function svel = soundspeed(s,t,p);
% svel = soundspeed(s,t,p)
% s in c.u., t in deg C, p in MPa, svel in m/s
% Source: Chen and Millero (1977), J.  Acous. Soc. America, 62, 1129-1135
% Range: s(0.005-0.04), t(0-40 =), p(0-100)
% Check values:	soundspeed(0.035, 0, 10)=1465.54,
% soundspeed(0.035, 10, 20)=1522.96, soundspeed(0.035, 20, 30)=1571.34,
% soundspeed(0.035, 30, 50)=1628.97
% Coded in C by	Mark Prater, October 20, 1987
% Revised for matlab by Mike Gregg, Nov 5, 1994.

% initialize parameter coefficients

u1  =  1402.388;    u2  =  5.03711;     u3  = -5.80852e-2;
u4  =  3.3420e-4;   u5  = -1.47800e-6;  u6  =  3.1464e-9;
u7  =  0.153563;    u8  =  6.8982e-4;   u9  = -8.1788e-6;
u10 =  1.3621e-7;   u11 = -6.1185e-10;  u12 =  3.1260e-5;
u13 = -1.7107e-6;   u14 =  2.5974e-8;   u15 = -2.5335e-10;
u16 =  1.0405e-12;  u17 = -9.7729e-9;   u18 =  3.8504e-10;
u19 = -2.3643e-12;

d1  =  1.389;       d2  = -1.262e-2;    d3  =  7.164e-5;
d4  =  2.006e-6;    d5  = -3.21e-8;     d6  = -1.922e-2;
d7  = -4.42e-5;     d8  =  1.727e-3;

a1  =  9.4742e-5;   a2  = -1.2580e-5;   a3  = -6.4885e-8; 
a4  =  1.0507e-8;   a5  = -2.0122e-10;  a6  = -3.9064e-7; 
a7  =  9.1041e-9;   a8  = -1.6002e-10;  a9  =  7.988e-12; 
a10 =  1.100e-10;   a11 =  6.649e-12;   a12 = -3.389e-13;

b1  =  7.3637e-5;   b2  =  1.7945e-7;   c1  = -7.9836e-6;

% convert input units

s = 1000 * s; % from concentration units to parts per thousand
p = 10 * p;   % from megapascals to bars                  */

% compute the speed of sound in pure water 
 
u_pure =     u1  + t.*( u2  + t.*( u3  + t.*( u4  + t.*( u5 + t*u6)))) ...
            + ( u7  + t.*( u8  + t.*( u9  + t.*( u10 + t*u11)))).*p ...
            + ( u12 + t.*( u13 + t.*( u14 + t.*( u15 + t*u16)))).*p.*p ...
            + ( u17 + t.*( u18 + t*u19)).*p.*p.*p;

% compute the speed of sound in seawater relative to pure water */

del_u0 = ( d1 + t.*( d2 + t.*( d3 + t.*( d4 + t*d5 )))).*s ...
            + ( d6 + t*d7 ).*s.*sqrt( s ) + d8*s.*s;

% compute temperature and pressure dependent parameters */

A      = ( a1 + t.*( a2 + t.*( a3 + t.*( a4 + t*a5 )))).*p ...
            + ( a6  + t.*( a7  + t.*( a8 + t*a9))).*p.*p ...
            + ( a10 + t.*( a11 + t*a12 )).*p.*p.*p;

B = ( b1 + b2*t ) .* p;

C = c1 * p;

svel = u_pure + del_u0 + A.*s + B.*sqrt( s ).*s + C.*s.*s; 
