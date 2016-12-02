function p = mypower(fev,evl)
% p = power(fev,evl)
%    Compute the power spectrum of a time series using the
% eigenspectra estimate in fev.  The columns of fev are the
% independent spectral estimates, and evl is a column vector
% of eigenvalues corresponding to the eigenvectors (windows)
% used the compute the columns of fev.
% By John Kuehne, June 1990.
a=fev.*conj(fev);
p=(a*evl)/sum(evl);
