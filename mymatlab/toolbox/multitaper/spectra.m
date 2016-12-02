function fev = spectra(x,evc)
% fev = spectra(x,evc)
%    Compute complex-valued eigenspectra of column vector x
% using eigenvectors (windows) in evc.  The eigenvectors are
% in the columns of evc, which can be supplied by a window function.
% By John Kuehne, June 1990.
[n,k]=size(evc);
for t=1:k,
  ev(1:n,t)=evc(1:n,t).*x;
end
fev=fft(ev);
