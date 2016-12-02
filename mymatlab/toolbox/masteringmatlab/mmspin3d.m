function M=mmspin3d(n)
%MMSPIN3D Make Movie by 3D Azimuth Rotation of Current Figure.
% MMSPIN3D(N) captures and plays N frames of the current figure
% through one rotation about the Z-axis at the current elevation.
% M=MMSPIN3D(N) returns the movie in M for later playing with movie.
% If not given, N=18 is used.
% MMSPIN3D fixes the axis limits and issues axis off.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/4/95
% Copyright (c) 1996 by Prentice Hall, Inc.

if nargin<1, n=18; end
n=max(abs(round(n)),2);

axis(axis);
axis off
incaz=round(360/n);
[az,el]=view;

m=moviein(n);
for i=1:n
	view(az+incaz*(i-1),el)
	m(:,i)=getframe;
end
if nargout,	M=m;
else,		movie(m);
end
