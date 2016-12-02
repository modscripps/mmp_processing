function H = fillbar(x,y,c)
%  FILLBAR:     Creates a filled bar plot
%
%               FILLBAR(X) generates a bar plot of the
%               elements of X.  It fills the bins by cycling
%               through the colors defined by the AXES
%               ColorOrder.
%
%               FILLBAR(X,Y) draws a bar graph of the elements
%               of vector Y at the locations specified in vector
%               X.  The X-values must be in ascending order.  If
%               the X-values are not evenly spaced, the interval
%               chosen is not symmetric about each data point.
%               Instead, the bars are drawn midway between
%               adjacent X-values.  The endpoints simply adopt
%               the internal intervals for the external ones
%               needed.  The bins are filled using the same method
%               as defined above.
%
%               FILLBAR(X,Y,C) uses the colors specified in C.
%
%               H = FILLBAR(...) returns the handles of each
%               patch.%%               See BAR for details

%  Written by John L. Galenski 09/20/93
%  All Rights Reserved%  LDM092093jlg

if nargin == 1
        [xx,yy] = bar(x);
elseif nargin >= 2
		[xx,yy] = bar(x,y);
end

%  Remove the unwanted zeros
X = sort([xx(3:5:(length(xx)-1)) xx(4:5:length(xx))]);
Y = [yy(3:5:(length(yy)-1)) yy(4:5:length(yy))];

%  Add the patches
for i = 1:length(Y)
        if nargin ~= 3
		        colororder = get(gca,'colororder');
		        size_colororder = size(colororder);
				color = rem(i,size_colororder(1));
				if color == 0
				         color = size_colororder(1);
			    end                
				C = colororder(color,:);
		 elseif nargin == 3
				C = rem(i,size(c,1));
				if C == 0
				        C = size(c,1);
                end                
				C = c(C,:);
        end
        h(i) = fill([X(i,:),fliplr(X(i,:))],[0,0,Y(i,:)],C);
        hold on
end

%  Output
if nargout
        H = h';
end
hold off
