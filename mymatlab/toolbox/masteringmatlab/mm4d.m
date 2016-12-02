% mm4d

echo on
x=-7.5:.5:7.5;          % create a data set - the famous sombrero
y=x;

[X Y]=meshgrid(x,y);      % create plaid data

R=sqrt(X.^2+Y.^2)+eps;

Z=sin(R)./R;

figure(1)
colormap(hot)

surf(X,Y,Z,Z)             % default color order
title('Default color')

% press any key to continue
pause
surf(X,Y,Z,-Z)            % plot and reverse the default color order
title('Flip color upside-down')

% press any key to continue
pause
surf(X,Y,Z,X)             % color varies along the X axis
title('Vary color along X-axis')

% press any key to continue
pause
surf(X,Y,Z,X+Y)           % color varies along the XY diagonal
title('Vary color along X-Y diagonal')


% press any key to continue
pause
surf(X,Y,Z,R)   	      % color varies radially from the center
title('Vary color radially in x-y plane')


% press any key to continue
pause
surf(X,Y,Z,abs(del2(Z)))  % color varies with absolute value of Laplacian
title('Vary color by Laplacian')

% press any key to continue
pause
[dZdx,dZdy]=gradient(Z);

surf(X,Y,Z,abs(dZdx))     % color varies with absolute slope in x-direction
title('Vary color with absolute slope in X-direction')

% press any key to continue
pause
surf(X,Y,Z,abs(dZdy))     % color varies with absolute slope in y-direction
title('Vary color with absolute slope in Y-direction')

% press any key to continue
pause
dZ=sqrt(dZdx.^2 + dZdy.^2);

surf(X,Y,Z,dZ)            % color varies with magnitude of slope
title('Vary color with magnitude of slope')

echo off
