function stairplot_bins(xlb,xub,y)

nargin

% assume matrix with 
if nargin==3
	xlb=xlb(:); xub=xub(:); y=y(:); % make inputs column vectors
	lxlb=length(xlb); lxub=length(xub); ly=length(y);
	if lxlb~=lxub | lxub~ly
		error('The three input vectors differ in length');
end

%x=x(:)'; y=y(:)';

%l=length(x); ly=length(y);

%xx=ones(1,2*l); yy=ones(1,2*l);

%xx(1:2:2*l)=x; xx(2:2:2*l)=x;

%dy=diff(y);

%yy(1)=y(1)-dy(1)/2;
%yy(3:2:2*l)=y(2:l)-dy/2;

%yy(2:2:2*(l-1))=y(1:l-1)+dy/2;
%yy(2*l)=y(l)+dy(l-1)/2;

%plot(xx,yy)
