function [x]=detrend(y)
% FUNCTION [X]=DETREND(Y)
% Remove the offset and trend from y. If y is a matrix, detrend
% each column.
[row,column]=size(y);
if (is_vector(y))
  L=length(y);
  seq=(0:1:L-1)';
  m(:,1)=ones([L 1]);
  m(:,2)=seq;
  if (column-1)
    y=y.';
  end 
  x=y-(m*(m\y));
  if (column-1)
    x=x.';
  end
else
  for a=1:column,
     x(:,a)=detrend(y(:,a));        % recursion
  end
end


