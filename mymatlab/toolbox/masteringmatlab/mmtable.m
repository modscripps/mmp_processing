function y=mmtable(a,b,c)
%MMTABLE 1-D Monotonic Table Search by Linear Interpolation.
% YI=MMTABLE(TAB,COL,VALS) linearly interpolates the table TAB
% searching for values VALS in the column COL.
%
% TAB(:,COL) must be monotonic, but need NOT be equally spaced.
% YI has as many rows as VALS and as many columns as TAB.
% NaNs are returned where VALS are outside the range of TAB(:,COL).
%
% YI=MMTABLE(TAB,VALS) interpolates using COL=1 and does not return 
% TAB(:,1) in Y. This matches the usage of TABLE1(TAB,X0).
%
% YI=MMTABLE(X,Y,XI) interpolates the vector X to find YI associated
% with XI. This matches the usage of INTERP1(X,Y,XI)
%
% This routine is 10X faster than TABLE1 which is called by INTERP1.
% For linearly spaced data, ILINEAR is 10X faster yet.

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 8/21/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 


if nargin==2          % MMTABLE(TAB,VALS) syntax
	tab=a;vals=b(:);col=1;cflag=1;
elseif length(b)>1    % MMTABLE(X,Y,XI) syntax
	[rb,cb]=size(b);
	a=a(:);
	la=length(a);
	if rb==la,tab=[a b];
	elseif cb==la,tab=[a b.'];
	end
	col=1;vals=c(:);cflag=1;
else                  % MMTABLE(TAB,COL,VALS) syntax
	tab=a;col=b(1);vals=c(:);cflag=0;
end

[rt,ct]=size(tab);
if col>ct|col<1,  error('Chosen column outside table width.'), end
if rt<2, error('Table too small or not oriented in columns.'), end
ict=1:ct;      % index for table columns
nv=length(vals);

dx=diff(tab);
dx=[dx;dx(rt-1,:)];  % differences within each column.
id=sign(dx(1,col));  % sign of differences in col

if any(sign(dx(:,col))~=id)
	error(sprintf('Column %.0f of table is not monotonic.',col))
end

inan=vals<min(tab(1,col),tab(rt,col)) | vals>max(tab(1,col),tab(rt,col));
xo=vals(~inan);  % pick values within range of tab(:,col)
nxo=length(xo);
if nxo==0  % all values are outside range of tab(:,col)!
	y=NaN*ones(nv,ct);
	y(:,col)=vals;
else  % interpolate using algorithm posted by Hans Olsson of Lund University

	
	[svals,sidx]=sort(id*[tab(2:rt-1,col);xo]);
	ttab=sidx<=rt-2;      % True at tab(:,col) values in svals
	cidx=1+cumsum(ttab);  % index of xo in svals
	sidx(ttab)=[];        % throw out indices of tab(:,col) values
	yidx=zeros(nxo,1);    % storage for xo index in tab(:,col)
	yidx(sidx-(rt-2))=cidx(~ttab);  % xo index in tab(:,col)
	ndx=(xo-tab(yidx,col))./dx(yidx,col); % normalized dx increment
	y=tab(yidx,ict)+ndx(:,ones(1,ct)).*dx(yidx,ict);
	if ~isempty(inan)  % must poke in NaNs where they belong
		yt=zeros(nv,ct);
		yt(~inan,:)=y;
		yt(inan,:)=NaN*ones(nv-nxo,ct);
		yt(:,col)=vals;
		y=yt;
	end
end
if cflag,y(:,col)=[];end




