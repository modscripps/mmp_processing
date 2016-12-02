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
