function y=mmn2px(x,Hf)
%MMN2PX Normalized to Pixel Coordinate Transformation.
% MMN2PX(X) converts the position vector X from
% normalized coordinates to pixel coordinates w.r.t.
% the computer screen.
%
% MMN2PX(X,H) converts the position vector X from
% normalized coordinates to pixel coordinates w.r.t.
% the figure window having handle H.
%
% X=[left bottom width height] or X=[width height]

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/10/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

lx=length(x);

sz='Position';
if nargin==1,Hf=0;sz='ScreenSize';end

if any(x>1)|any(x<0)|(lx~=4&lx~=2)
	error('Input is not a normalized position vector.')
end

if lx==2,x=[0 0 x(:)'];end  % [width height] input format
u=get(Hf,'Units');
set(Hf,'Units','pixels');
s=get(Hf,sz);
y=x.*([s(3:4) s(3:4)]-1)+1;
set(Hf,'Units',u);
if lx==2,y=y(3:4);end  % [width height] output format

