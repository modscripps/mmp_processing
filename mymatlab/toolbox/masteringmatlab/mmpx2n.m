function y=mmpx2n(x,Hf)
%MMPX2N Pixel to Normalized Coordinate Transformation.
% MMPX2N(X) converts the position vector X from
% pixel coordinates to normalized coordinates w.r.t.
% the computer screen.
%
% MMPX2N(X,H) converts the position vector X from
% pixel coordinates to normalized coordinates w.r.t.
% the figure window having handle H.
%
% X=[left bottom width height] or X=[width height]


% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/10/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

msg='Input is not a pixel position vector.';
lx=length(x);

sz='Position';
if nargin==1,Hf=0;sz='ScreenSize';end

if any(x<1)|(lx~=4&lx~=2)
	error(msg)
end

if lx==2,x=[1 1 x(:)'];end  % [width height] input format
u=get(Hf,'Units');
set(Hf,'Units','pixels');
s=get(Hf,sz);
y=(x-1)./([s(3:4) s(3:4)]-1);
set(Hf,'Units',u);
if any(y>1)
	error(msg)
end
if lx==2,y=y(3:4);end  % [width height] output format
