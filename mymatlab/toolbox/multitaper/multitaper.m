

From kuehne@sleepy.cc.utexas.edu Mon Jun  5 09:32:40 PDT 1995
Article: 13905 of comp.soft-sys.matlab
Path: news.u.washington.edu!news.alt.net!news.net99.net!news.fc.net!news.io.com!uunet!cs.utexas.edu!geraldo.cc.utexas.edu!sleepy.cc.utexas.edu!not-for-mail
From: kuehne@sleepy.cc.utexas.edu (kuehne)
Newsgroups: comp.soft-sys.matlab
Subject: Re: multitaper spectra
Date: 2 Jun 1995 16:48:10 -0500
Organization: The University of Texas at Austin; Austin, Texas
Lines: 403
Message-ID: <3qo0uq$45t@sleepy.cc.utexas.edu>
NNTP-Posting-Host: sleepy.cc.utexas.edu


                 OCTAVE program for Multitaper spectral analysis.

A good reference for this problem is  

Thomson, D.J., Spectrum estimation and harmonic analysis, Proc. of the
IEEE, 70 (9), 1055-1096, 1982.

Thomson provides two methods for determining the spectral windows,
or "eigenfunctions".  The first and most accurate method is simply to
find the eigenvectors of a certain Toeplitz matrix. This is feasible
when the time series are short, because the matrix dimension is n-by-n,
where n is the time-series length. So, solving a 300x300 eigenvalue
problem is no problem, but 10000x10000 is right out. The second method
is an approximation based on Gaussian quadrature of an algebraic eigen-
value problem. This method can handle n=10000 with ease, but there are
some restrictions due to roundoff error. 64-bit precision seems to limit
the number of tapers to about 12. In either method, the effect of matrix
balancing preliminary to determing the eigenvectors may not be optimal,
but you should check this out for yourself.

The following works in OCTAVE. It should work for matlab too with
few changes.

Below are three routines for determining the windows, as well as a simple
set of spectral analysis routines for determing power, coherence, and
phase. Note that I do not attempt to use Thomson's adaptive weighting
scheme, which attempts to minimize the broadband bias at each Fourier
freqency. Such schemes may be useful for your application, or may be
unimportant. At any rate, they complicate the interpretation of coherence
and phase, because the confidence levels are probably not constants in
adaptive weighting.

Please don't use these routines blindly. I believe they are correct, but
you must verify this yourself. Watch out for the way I normalize the
DFT, etc. I got the Legendre zeros and quadrature weights out of book,
but you'll want to make sure I typed them in right. Or generate your own.
I also don't do any fancy checking for input arguments. Prism requires
column vectors with zero mean. The spectral bandwidth parameter is
stupid, but you can change it as easily as I. Just the number of tapers
will cut it.

The routines are:
w1.m          % brute force solution for small n
w2.m          % Approximation suitable for large n, but less than about
                12 tapers. You'll know when this method bombs because
                the eigenvalues will exceed 1, and the eigenvectors won't
                be orthogonal. In any event, orthgonality won't be perfect,
                but it's good enough. That's what approximation means.
w3.m          % Same thing with 24 point quadrature instead of 32.
prism.m       % Spectral analysis routine that calls several short routines
                not listed here, but included below.

Example of how to use prism:

ts1 is time series 1, as a column vector
ts2 is time series 2, as a column vector

rainbow=prism(detrend(ts1),detrend(ts2),8/2/length(ts1)); % 8 tapers

plot(rainbow(:,3));  % coherence spectrum


This is free software with ABSOLUTELY NO WARRANTY.
Copyright (C) 1995 John Kuehne

Cut here
---------------------------------------------------------------------------

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
endfunction


function [evc,evl] = w2(l,f)
% [evc,evl] = window2(l,f)
%   Generate the window functions using the approximation method outlined
% in Appendix A of Thomson in Proc. of the IEEE, September 1987.  evc is
% a matrix whose columns are the eigenvectors (windows) with corresponding
% eigenvalues in the column vector evl.  Only the first 2lf eigenvectors
% are returned.  l is the number of window terms to compute, and f is the
% bandwidth.  evl is sorted from small to large eigenvalues.
%   This program uses a 32-point Gauss-Legendre quadrature (c.f. Appendix A).
%   By John Kuehne, August 1990.

% Zeros of Legendre(32) polynomial and weights for quadrature.
gq = [-.997263861849481563545  .007018610009470096600
      -.985611511545268335400  .016274394730905670605
      -.964762255587506430774  .025392065309262059456
      -.934906075937739689171  .034273862913021433103
      -.896321155766052123965  .042835898022226680657
      -.849367613732569970134  .050998059262376176196
      -.794483795967942406963  .058684093478535547145
      -.732182118740289680387  .065822222776361846838
      -.663044266930215200975  .072345794108848506225
      -.587715757240762329041  .078193895787070306472
      -.506899908932229390024  .083311924226946755222
      -.421351276130635345364  .087652093004403811143
      -.331868602282127649780  .091173878695763884713
      -.239287362252137074545  .093844399080804565639
      -.144471961582796493485  .095638720079274859419
      -.048307665687738316235  .096540088514727800567
       .048307665687738316235  .096540088514727800567
       .144471961582796493485  .095638720079274859419
       .239287362252137074545  .093844399080804565639
       .331868602282127649780  .091173878695763884713
       .421351276130635345364  .087652093004403811143
       .506899908932229390024  .083311924226946755222
       .587715757240762329041  .078193895787070306472
       .663044266930215200975  .072345794108848506225
       .732182118740289680387  .065822222776361846838
       .794483795967942406963  .058684093478535547145
       .849367613732569970134  .050998059262376176196
       .896321155766052123965  .042835898022226680657
       .934906075937739689171  .034273862913021433103
       .964762255587506430774  .025392065309262059456
       .985611511545268335400  .016274394730905670605
       .997263861849481563545  .007018610009470096600];

c=l*pi*f;

% Set-up Legendre-zeros matrix
xmj=(gq(:,1)*ones([1 32])) - (ones([32 1])*gq(:,1)');

% Set-up dbz, the matrix that avoids divide-by-zero.
dbz=(abs(xmj)<=(zeros(32)+eps));

% Calculate weightless K(m,j) except for removable singularities.
kmj=((sin(c*xmj))./(pi*(xmj+dbz)));

% Removable singularities.
kmj=kmj+(dbz*(l*f));

% Set-up weight matrix.
wmj=sqrt(gq(:,2)*gq(:,2)');

% Multiply weights to complete K(m,j).
kmj=kmj.*wmj;

% Diagonalize (symmetric) kmj.
[tevec,teval]=eig(kmj);

g=diag(teval);            % Extract eigenvalues.
[h,i]=sort(g);            % Sort eigenvalues.
nt=33-round(2*l*f);       % Starting index into h and i.
evl=h(nt:32);             % Save largest 2lf eigenvalues
psi=tevec(:,i(nt:32));    % and re-arrange their eigenvectors.

% Set-up matrix snj.
cn=((2/l)*(1:l))' - 1;
for i=1:32,
   snj(:,i)=cn-gq(i,1);
end

% Calculate weightless final matrix (no singularities here).
fmj=sin(c*snj)./(pi*(snj));

% Multiply weights.
for i=1:32,
fmj(:,i)=fmj(:,i)*sqrt(gq(i,2));
end
 
% Answer; matrix-matrix multiply and normalize.
evc=fmj*psi;
for i=1:(round(2*l*f)),
   evc(:,i)=evc(:,i)/norm(evc(:,i));
end
endfunction


function [evc,evl] = w3(l,f)
% [evc,evl] = window2(l,f)
%   Generate the window functions using the approximation method outlined
% in Appendix A of Thomson in Proc. of the IEEE, September 1987.  evc is
% a matrix whose columns are the eigenvectors (windows) with corresponding
% eigenvalues in the column vector evl.  Only the first 2lf eigenvectors
% are returned.  l is the number of window terms to compute, and f is the
% bandwidth.  evl is sorted from small to large eigenvalues.
%   This program uses a 24-point Gauss-Legendre quadrature (c.f. Appendix A).
%   By John Kuehne, August 1990.

% Zeros of Legendre(24) polynomial and weights for quadrature.
gq = [.064056892862605626085  .127938195346752156974
      .191118867473616309159  .125837456346828296121
      .315042679696163374387  .121670472927803391204
      .433793507626045138487  .115505668053725601353
      .545421471388839535658  .107444270115965634783
      .648093651936975569252  .097618652104113888270
      .740124191578554364244  .086190161531953275917
      .820001985973902921954  .073346481411080305734
      .886415527004401034213  .059298584915436780746
      .938274552002732758524  .044277438817419806169
      .974728555971309498198  .028531388628933663181
      .995187219997021360180  .012341229799987199547
     -.064056892862605626085  .127938195346752156974
     -.191118867473616309159  .125837456346828296121
     -.315042679696163374387  .121670472927803391204
     -.433793507626045138487  .115505668053725601353
     -.545421471388839535658  .107444270115965634783
     -.648093651936975569252  .097618652104113888270
     -.740124191578554364244  .086190161531953275917
     -.820001985973902921954  .073346481411080305734
     -.886415527004401034213  .059298584915436780746
     -.938274552002732758524  .044277438817419806169
     -.974728555971309498198  .028531388628933663181
     -.995187219997021360180  .012341229799987199547];

c=l*pi*f;

% Set-up Legendre-zeros matrix
xmj=(gq(:,1)*ones([1 24])) - (ones([24 1])*gq(:,1)');

% Set-up dbz, the matrix that avoids divide-by-zero.
dbz=(abs(xmj)<=(zeros(24)+eps));

% Calculate weightless K(m,j) except for removable singularities.
kmj=((sin(c*xmj))./(pi*(xmj+dbz)));

% Removable singularities.
kmj=kmj+(dbz*(l*f));

% Set-up weight matrix.
wmj1=sqrt(gq(:,2)*gq(:,2)');

% Multiply weights to complete kmj.
kmj=kmj.*wmj1;

% Diagonalize (symmetric) kmj.
[tevec,teval]=eig(kmj);

g=diag(teval);            % Extract eigenvalues.
[h,j]=sort(g);            % Sort eigenvalues.
nt=25-round(2*l*f);       % Starting index into h and j;
evl=h(nt:24);             % Save largest 2*l*f eigenvalues and
psi=tevec(:,j(nt:24));    % re-arrange their eigenvectors.

% Set-up matrix snj.
cn=((2/l)*(1:l))' - 1;
for i=1:24,
   snj(:,i)=cn-gq(i,1);
end

% Calculate weightless final matrix (no singularities here).
fmj=sin(c*snj)./(pi*(snj));

% Multiply weights.
for i=1:24,
fmj(:,i)=fmj(:,i)*sqrt(gq(i,2));
end

% Answer; matrix-matrix multiply and normalize.
evc=fmj*psi;
for i=1:(round(2*l*f)),
   evc(:,i)=evc(:,i)/norm(evc(:,i));
end
endfunction


function rainbow = prism(x1,x2,f)
% RAINBOW = FUNCTION PRISM(X1,X2,F)
%    Estimate power, coherence, and phase spectra for two column
% vectors X1 and X2 using the multiple taper spectral analysis
% method.  F is the bandwidth i.e. K=2NF where K is the number
% of windows, and N is the length of the time series.  The power
% spectra of X1 and X2 are returned in the first two columns of
% RAINBOW.  Column three is the squared coherence and column four
% is the phase spectrum.  All vectors in RAINBOW are FFTSHIFTed
% so that zero frequency is the central value.
% By John Kuehne, June 1990.

[t1,t2]=size(x1);
[a,b]=w2(t1,f);
f1=spectra(x1,a);
f2=spectra(x2,a);
p1=power(f1,b);
p2=power(f2,b);
c12=cross(f1,f2,b);
co=coherence(p1,p2,c12);
ph=angle(c12);
rainbow(:,1)=fftshift(p1);
rainbow(:,2)=fftshift(p2);
rainbow(:,3)=fftshift(co);
rainbow(:,4)=fftshift(ph);
endfunction


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
endfunction


function p = power(fev,evl)
% p = power(fev,evl)
%    Compute the power spectrum of a time series using the
% eigenspectra estimate in fev.  The columns of fev are the
% independent spectral estimates, and evl is a column vector
% of eigenvalues corresponding to the eigenvectors (windows)
% used the compute the columns of fev.
% By John Kuehne, June 1990.
a=fev.*conj(fev);
p=(a*evl)/sum(evl);
endfunction


function c = cross(fev1,fev2,evl)
% c= cross(fev1,fev2,evl)
%   Compute the cross spectrum from two eigenspectra fev1 and fev2.
% fev1 and fev2 may be produced from spectra(x,evc).  evl is
% the column vector of eigenvalues from window(l,f).
% By John Kuehne, June 1990.
a=fev1.*conj(fev2);
c=(a*evl)/sum(evl);
endfunction


function c = coherence(p1,p2,c12)
% c= coherence(p1,p2,c12)
%  Compute the simple squared coherence between two time series.
% p1 is the power spectrum of one times series, p2 is the power
% spectrum of the other time series, and c12 is the cross spectrum.
% p1 and p2 are computed from power(fev,evl) and c12 is computed
% from cross(fev1,fev2,evl).
%   By John Kuehne, June 1990.
a=c12.*conj(c12);
b=p1.*p2;
c=a./b;
endfunction


function [fs]=fftshift(f)
% swap fft for conventional spectrum plot
[row,column]=size(f);
if (is_vector(f))
   L=length(f);
   Ld1=fix(L/2);
   Ld2=fix(L/2)+rem(L,2);
   fs(1:Ld1)=f(Ld2+1:L);
   fs(Ld1+1:L)=f(1:Ld2);
else
   L=row;
   Ld1=fix(L/2);
   Ld2=fix(L/2)+rem(L,2);
   fs(1:Ld1,:)=f(Ld2+1:L,:);
   fs(Ld1+1:L,:)=f(1:Ld2,:);
endif
endfunction


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
  endif 
  x=y-(m*(m\y));
  if (column-1)
    x=x.';
  endif
else
  for a=1:column,
     x(:,a)=detrend(y(:,a)); % recursion
  endfor
endif
endfunction


