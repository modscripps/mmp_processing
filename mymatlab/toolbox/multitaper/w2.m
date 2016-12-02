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
