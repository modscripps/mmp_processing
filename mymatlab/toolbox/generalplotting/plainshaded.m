%
%     shaded.m                   06/30/94           Ren-Chieh Lien
%    
%     SHDED BETWEEN TWO CURVES
%
%     example:
%
%         function plainshaded(x1,y1,x2,y2,g):
%
%        x1 = 0:pi/200:2*pi;
%        y1 = cos(x1);
%        x2 = 0:pi/20:2*pi;
%        y2 = sin(x2);
%        shaded(x1,y1,x2,y2,'r')
%
    function plainshaded(x1,y1,x2,y2,g):
    x1 = x1(:); y1 = y1(:); x2 = x2(:); y2 = y2(:);
    bad1 = find(isnan(x1.*y1));
    if ~isempty(bad1); 
	x1(bad1) = [];
	y1(bad1) = [];
    end
    bad2 = find(isnan(x2.*y2));
    if ~isempty(bad2); 
	x2(bad2) = [];
	y2(bad2) = [];
    end

    x = [x1 ; flipud(x2)];
    y = [y1 ; flipud(y2)];
    h = fill(x,y,g);
    set(h,'edgecolor','none')
