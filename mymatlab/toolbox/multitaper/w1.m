function [evc,evl] = w1(l,f)
% [evc,evl] = window1(l,f)
%    Generate the window functions using the toeplitz eigenvalue 
% matrix equation given by Thomson in Proc. of the IEEE, September
% 1987. evc is a matrix whose columns are the eigenvectors 
% (windows) with corresponding eigenvalues in the column vector 
% evl.  Only the first 2lf eigenvectors are returned.  l is the
% number of window terms to compute, and f is the bandwidth. evl
% is sorted from small to large eigenvalues.
%   By John Kuehne, June 1990.  
a=sin(-2*pi*f*(0:(l-1))); % Set-up first row of toeplitz matrix;
b=-pi*(0:(l-1));          % A is numerator, b denominator.
b(1)=1;                   % Temporarily avoid divide-by-zero.
c=a./b;                   % c is now the first row of matrix.
c(1)=2*f;                 % Because sin(2*pi*f*(0))/pi*(0)=2*f.
d=toeplitz(c);            % Make matrix.
[tevec,teval]=eig(d);     % Diagonalize the symmetric matrix.
g=diag(teval);            % Extract eigenvalues.
[h,i]=sort(g);            % Sort eigenvalues.
nt=l-round(2*l*f)+1;      % Starting index into h and i.
evl=h(nt:l);              % Save 2lf largest eigenvalues
evc=tevec(1:l,i(nt:l));   % and re-arrange their eigenvectors.
for t=1:l-nt+1,           % Normalize eigenvectors.
  evc(:,t)=evc(:,t)/norm(evc(:,t));
end
