

    function [x,y,h]=drawcircle();

    xlim = get(gca,'xlim');
    ylim = get(gca,'ylim');

    ratio = abs(diff(ylim)/diff(xlim));
    [x0,y0]=ginput(1);

    h = plot(x0,y0,'+');

    [rx,ry] = ginput(1);
    r = sqrt((rx-x0)^2+(ry-y0)^2);

    phi = 0:pi/20:2*pi;
    x = x0 + r*cos(phi);
    y = y0 + r*sin(phi)*ratio;

    delete(h);
    h = plot(x,y);
