function y=shiftlr(a,n,cs)
%SHIFTLR Shift or Circularly Shift Matrix Columns.
% SHIFTLR(A,N) with N>0 shifts the columns of A to the RIGHT N columns.
% The first N columns are replaced by zeros and the last N
% columns of A are deleted.
% 
% SHIFTLR(A,N) with N<0 shifts the columns of A to the LEFT N columns.
% The last N columns are replaced by zeros and the first N
% columns of A are deleted.
% 
% SHIFTLR(A,N,C) where C is nonzero performs a circular
% shift of N columns, where columns circle back to the
% other side of the matrix. No columns are replaced by zeros.
%

% D.C. Hanselman, University of Maine, Orono ME 04469
% 1/24/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

if nargin<3,cs=0;end
y=(shiftud(a.',n,cs)).';
