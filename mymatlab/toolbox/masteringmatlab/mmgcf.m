function Hf=mmgcf
%MMGCF Get Current Figure if it Exists.
% MMGCF returns the handle of the current figure if it exists.
% If no current figure exists, MMGCF returns an empty handle.
%
% Note that the function GCF is different. It creates a figure
% and returns its handle if it does not exist.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/10/95
% Copyright (c) 1996 by Prentice Hall, Inc.

Hf=get(0,'Children');
if isempty(Hf)
	return
else
	Hf=get(0,'CurrentFigure');
end
