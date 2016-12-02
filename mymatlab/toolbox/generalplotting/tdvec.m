function tdvec(uvc, t, d, tlimits, dlimits, uscale, arrowlength, key)
% function tdvec(uvc, t, d, tlimits, dlimits, uscale, arrowlength, key)
%
%  Plots a complex matrix as a field of arrows.
%
%     uvc = u + i*v; row -> depth, column -> time
%     t = row vector with time of each column in uvc
%     d = column vector with depth of each row in uvc
%        (above 3 arrays are automatically transposed if necessary)
%     tlimits = [tmin tmax] for plot axes (x)
%     dlimits = [dmin dmax] for plot axes (y)
%     uscale = velocity units per time unit on x-axis;
%              e.g.,  (m/s) per day
%  optional:  (either, neither, or both)
%     arrowlength = length of arrowhead in velocity units
%              Note: set arrowlength = 0 to omit arrowheads;
%              this greatly reduces memory requirements.
%     key = [key_t key_d key_u];
%              key_t, key_d are location of key in t,d units;
%              key_u is length of key in velocity units
%

%           Eric Firing, Sat  08-19-1989

%  Set DeviceAspect for the particular output device, or set
%  to 1 to fit all devices (via the command "axis('square')").
%  DeviceAspect is the ratio of the y to the x dimension of the plot.

i = sqrt(-1);
DeviceAspect = 0.714;

if DeviceAspect == 1
   axis('square')
end

if nargin < 6, disp('ERROR: need at least 6 arguments'), return, end;

if nargin == 6
   arrowlength = 0;
   key = [0 0 0];
end

if nargin == 7
   if length(arrowlength) > 1
      key = arrowlength;
      arrowlength = 0;
   else
      key = [0 0 0];
   end
end

[nn,nt] = size(t);
if nn>nt, t=t';, nt=nn;, end;

[nd,nn] = size(d);
if nn>nd, d=d';, nd=nn;, end;

[m, n] = size(uvc);     % m is number of depth bins, n is number of times
if (m ~= nd | n ~= nt)
   if (m == nt & n == nd)
      uvc = uvc.';
      disp('input matrix has been transposed');
   else
      disp('ERROR: uvc dimensions should be length(d) rows b length(t) cols')
      return
   end
end

% Define corners of horizontal arrowhead when tip is at the origin.
if arrowlength > 0
   arrow1 = (-1 + i * 0.2) * arrowlength / uscale;
   arrow2 = (-1 - i * 0.2) * arrowlength / uscale;
end

trange = diff(tlimits);
drange = diff(dlimits);
uv_aspect = drange/(trange * DeviceAspect);
   % to mult by (v/uscale) to get depth units

axis([tlimits dlimits]);

tails = (ones(nd,1) * t)  + i * (d * ones(1,nt));
heads = (real(tails) + real(uvc) / uscale) ...
          + i * (imag(tails) + (imag(uvc) / uscale) * uv_aspect);
directions = uvc ./ abs(uvc);

if arrowlength > 0
   arrows1 =         real(arrow1 * directions)  ...
               + i * imag(arrow1 * directions) * uv_aspect;
   arrows2 =         real(arrow2 * directions)  ...
               + i * imag(arrow2 * directions) * uv_aspect;

   vectors = [tails(:) heads(:) ...
               (heads(:) + arrows1(:)) ...
               (heads(:) + arrows2(:)) heads(:)].';
else
   vectors = [tails(:) heads(:)].';
end

plot(real(vectors), imag(vectors), '-');
ylabel('Depth (m)');
hold on
ax = axis;
%for id = 1:length(d);
%    lincirc(t,d(id)*ones(1,length(t)),0.005,0.005,ax)
%end
hold off
%
if key(3) ~= 0
   % Adjust key length to have only 1 digit after decimal.
   key(3) = (fix( key(3)*10.0 ) ) / 10.0;
   hold on
   plot([key(1) (key(1)+key(3)/uscale)], [key(2) key(2)]);
%  text(key(1)+key(3)/uscale+0.02*trange, key(2)-0.025*drange, ...
%              sprintf('%3.1f m/s', key(3)));
   hold off
end
axis('normal');
axis;
