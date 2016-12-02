function y=mminterp(tab,col,val)
%MMINTERP 1-D Table Search by Linear Interpolation.
% Y=MMINTERP(TAB,COL,VAL) linearly interpolates the table
% TAB searching for the scalar value VAL in the column COL.
% All crossings are found and TAB(:,COL) need not be monotonic.
% Each crossing is returned as a separate row in Y and Y has as
% many columns as TAB. Naturally, the column COL of Y contains
% the value VAL. If VAL is not found in the table, Y=[].

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 1/26/94
% Copyright (c) 1996 by Prentice-Hall, Inc. 

[rt,ct]=size(tab);
if length(val)>1, error('VAL must be a scalar.'), end
if col>ct|col<1,  error('Chosen column outside table width.'), end
if rt<2, error('Table too small or not oriented in columns.'), end
above=tab(:,col)>val;
below=tab(:,col)<val;
equal=tab(:,col)==val;
if all(above==0)|all(below==0), % handle simplest case
	y=tab(find(equal),:);
	return
end
pslope=find(below(1:rt-1)&above(2:rt)); %indices where slope is pos
nslope=find(below(2:rt)&above(1:rt-1)); %indices where slope is neg

ib=sort([pslope;nslope+1]);	% put indices below in order
ia=sort([nslope;pslope+1]);	% put indices above in order
ie=find(equal);				% indices where equal to val

[tmp,ix]=sort([ib;ie]);		% find where equals fit in result
ieq=ix>length(ib);			% True where equals values fit
ry=length(tmp);				% # of rows in result y

y=zeros(ry,ct);				% poke data into a zero matrix

alpha=(val-tab(ib,col))./(tab(ia,col)-tab(ib,col));
alpha=alpha(:,ones(1,ct));
y(~ieq,:)=alpha.*tab(ia,:)+(1-alpha).*tab(ib,:);	% interpolated values

y(ieq,:)=tab(ie,:);			% equal values
y(:,col)=val*ones(ry,1);	% remove roundoff error



