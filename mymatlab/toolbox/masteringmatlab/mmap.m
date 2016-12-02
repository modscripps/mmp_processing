function map=mmap(c,m)
%MMAP Single Color Colormap.
% MMAP(C,M) makes a colormap of length M starting with the
% basic colorspec C. The map changes from dark to light.
% MMAP(C) is the same length as the current colormap.
%
% Example: mmap('y') is a yellow colormap
%          mmap([.49 1 .83]) is an auqamarine colormap
%          mmap('c',20) is a cyan colormap having length 20.
%          mmap('c') is the default if C can not be interpreted.
%
% Apply using: colormap(mmap(c,m))
%

% D. Hanselman, University of Maine, Orono, ME  04469
% 4/17/95
% Copyright (c) 1996 by Prentice Hall, Inc.

if nargin<=1, m=size(get(gcf,'colormap'),1); end
if nargin==0, c=[0 1 1]; end
colors='ymcrgb';
rgb=[1 1 0;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1];
if isstr(c)  % colorspec is a letter
	i=find(c==colors);
	if isempty(i), i=3;end
	c=rgb(i,:);  % convert it to an rgb vector
end
if all(c==0),c=rgb(3,:);end % don't allow a black colormap!

c=c./max(c); % normalize values
n=ceil(1.1*m); % throw out black end of gray colormap
map=gray(ceil(1.1*m)); % generate gray colormap to colorize

map=map(n-m+1:n,:)*diag(c);
