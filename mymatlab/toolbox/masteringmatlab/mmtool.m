function mmtool(z1,z2,z3,z4,z5,z6,z7)
% MMTOOL user-interactive visualization of 2-D data.
%
% MMTOOL(Y) plots the data in the columns of the matrix Y
%           versus the data in the first column of Y.
% MMTOOL(x,Y) plots the data in the columns of the matrix Y
%             versus the data in the vector x.
% MMTOOL(x,y1,y2,y3,y4,y5,y6) plots up to six y data vectors
%                             versus the data in the vector x.
%
% Column oriented data analysis is assumed. That is, data
% is assumed to vary down the columns of matrices and each
% column is a separate variable. All vectors and matrices must
% have identical maximum dimensions.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 2/1/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

rc=zeros(nargin,2);
for i=1:nargin
	si=int2str(i);
	eval(['z=z' si ';']);
	rc(i,:)=size(z);
	if rc(i,1)~=max(rc(i,:))
		rc(i,:)=rc(i,[2 1]);eval(['z' si '=z.'';']);
	end
end
if any(diff(rc(:,1)))
	error('Some input data vectors are not the same length.')
end
if nargin==1
	if rc(1,2)==1, error('Not enough input data.')
	else, x=z1(:,1);y=z1(:,2:min(rc(1,2),6));
	end
elseif nargin==2, 
	x=z1(:,1);y=z2(:,1:min(rc(2,2),6));
else
	x=z1(:,1);y=zeros(rc(2,1),nargin-1);
	for i=2:nargin,eval(['y(:,i-1)=z' int2str(i) '(:,1);']);end
end
[ry,cy]=size(y);X=x;Y=y;cY=cy;rY=ry;
M=[...
'----------- MMTOOL -----------'
' Y select         Label       '
' Restore          Hold  OFF   '
' Plot Y           Grid        '
' Integral Y       Truncate Y  '
' Derivative Y     Spline  Y   '
' Manipulate Y     Curve fit Y '
' FFT Y            Explore Y   '
' Quit             ?-help      '
'------------------------------'];
msg='using mouse and mouse button.';
paktc='Press any key to continue';
m='a';ctp=1:cY;Lctp=length(ctp);close all
Hp=[];Ha=[];pflag=0;hflag=0;yflag=0;
Num=['One  ';'Two  ';'Three';'Four ';'Five ';'Six  '];
while m~='q'
	if m=='$'
		home,clc,disp(M)
		disp(['Y columns: ' sprintf('%.0f ',ctp)])
		m=input('Your Choice? > ','s');
		if ~isempty(m),
			MM=m(2:length(m));
			Ma=lower(MM(~isspace(MM)));
			m=lower(m(1));
		else,m='$';
		end
	elseif m=='r'
		if input('Restore original data as Y? (y/n) [y] > ','s')~='n' 
			X=x;Y=y;rY=ry;cY=cy;,m='p';yflag=0;
			hold off;M(3,25:27)='OFF';hflag=0;
		else,m='$';
		end
	elseif m=='a'
		if isempty(Ha)
			ss=get(0,'ScreenSize');
			Pa=get(0,'DefaultFigurePosition');
			Ha=figure('Position',[5 ss(4)-40-.6*Pa(4) .6*Pa(3:4)],...
						'NumberTitle','off','Name','INPUT DATA');
			plot(x,y)
			Cord=get(gca,'ColorOrder');
			zoom on,a=axis;dx=(a(2)-a(1))/(cY+1);xp=a(1)-dx/2;yp=a(3)+(a(4)-a(3))/20;
			for i=1:cy
				text(xp+i*dx,yp,Num(i,:),'Color',Cord(i,:),'HorizontalAlignment','center')
			end
		else,figure(Ha);
		end
		m='$';
	elseif m=='p'
		if isempty(Hp)
			Hp=figure('Position',[min(ss(3)-5-Pa(3),5+.6*Pa(3)) ss(4)-40-Pa(4) Pa(3:4)]);
		end
		figure(Hp)
		set(Hp,'NumberTitle','off','Name',['Y columns: ' sprintf('%.0f ',ctp)])
		Hpl=plot(X,Y(:,ctp));
		for i=1:Lctp,set(Hpl(i),'Color',Cord(ctp(i),:));end
		zoom on;pflag=1;m='$';
	elseif m=='y'
		if yflag,
			disp('After Splines or FFT, the X-axis data has changed.')
			disp('Therefore selecting other columns is not appropriate.')
			disp('Use Restore option to restore all original data.')
			disp(paktc),pause,m='$';
		else
			if isempty(Ma),s=input('Enter desired Y columns > ','s');else,s=Ma;end
			if ~isempty(s)
				s(s<'1'|s>'6')=[];
				if isempty(s),s='1:6';end,c='[';
				for i=1:length(s),c=[c s(i) ' '];end;c=[c ']'];
				eval(['ctp=' c ';']);ctp(ctp>cY)=[];
				if isempty(ctp),ctp=1:cY;end
				Lctp=length(ctp);pflag=0;
			end
			m='p';
		end
	elseif m=='e'
		if isempty(Ma)
			c=input('Explore using X or Y? [y] > ','s');c=[c 'y'];
		else,c=Ma;
		end
		if c(1)=='x'
			disp(['Max value: ' sprintf('%.4g',max(X))])
			disp(['Min value: ' sprintf('%.4g',min(X))])
			xi=input('Enter desired X value > ');
			if ~isempty(xi)
				yi=mminterp([X Y(:,ctp)],1,xi(1));
				if isempty(yi),	disp('No interpolated values found.')
				else,			disp('Values found are:')
								disp('    X        Y'),disp(yi)
				end
				disp(paktc),pause
			end
		else
			c(c<'1'|c>'6')=[];
			if isempty(c)
				disp(['Y columns available: ' sprintf('%.0f ',ctp)])
				c=input('Explore using which column? > ');m='$';
			else, c=abs(c(1)-'0');
			end
			if isempty(c)|isempty(find(c==ctp)),c=ctp(1);end
			disp(['Column chosen: ' sprintf('%.0f ',c)])
			disp(['Max value: ' sprintf('%.4g',max(Y(:,c)))])
			disp(['Min value: ' sprintf('%.4g',min(Y(:,c)))])
			xi=input('Enter desired Y value > ');
			if ~isempty(xi)
				yi=mminterp([X Y],c+1,xi(1));
				if isempty(yi),	disp('No interpolated values found.')
				else,			disp('Values found are:')
								disp('    X        Y'),disp(yi(:,[1 ctp+1]))
				end
				disp(paktc),pause
			end
		end
		m='$';  
	elseif m=='m'
		m='$';
		disp('Manipulations Available:'),disp(['abs   dB    invdB';'+K    *K    -mean'])
		i=input('Your choice? > ','s');
		if ~isempty(i)
			if i(1)=='a', Y(:,ctp)=abs(Y(:,ctp));
			elseif i(1)=='d', Y(:,ctp)=20*log10(abs(Y(:,ctp)));
			elseif i(1)=='i', Y(:,ctp)=10.^(Y(:,ctp)/20);
			elseif i(1)=='-', K=mean(Y(:,ctp));Y(:,ctp)=Y(:,ctp)-K(ones(size(X)),:);
			elseif i(1)=='+'|i(1)=='='
				K=input('Enter K > ');if isempty(K),K=1;end,Y(:,ctp)=K(1)+Y(:,ctp);
			elseif i(1)=='*'|i(1)=='8'
				K=input('Enter K > ');if isempty(K),K=1;end,Y(:,ctp)=K(1)*Y(:,ctp);
			end
			m='p';
		end
	elseif m=='c'
		n=input('Desired polynomial order?  > ');
		if n>0&n<min(10,rY-1)
			disp('Curve fit polynomials are:')
			for i=1:Lctp
				cf=polyfit(X,Y(:,ctp(i)),n);
				pstring=['Y' int2str(ctp(i)) '(x)=' polystr(cf,'x')];
				disp(pstring),disp(' ')
				Y(:,ctp(i))=polyval(cf,X);
			end
			m='p';hold on,M(3,25:27)='ON!';hflag=1;disp(paktc),pause
		else, disp('Improperly chosen order. No action taken.')
			disp(paktc),pause,m='$';
		end
	elseif m=='i'
		Y(:,ctp)=mmintgrl(X,Y(:,ctp));
		m='p';
	elseif m=='d'
		Y(:,ctp)=mmderiv(X,Y(:,ctp));
		m='p';
	elseif m=='t'
		disp('Choose X-axis bounds for Truncation'),disp(msg)
		zoom off,[xg,yg]=ginput(2);xg=[min(xg) max(xg)];
		xg=find(x>=xg(1)&x<=xg(2));
		if length(xg)>1
			X=X(xg(:));Y=Y(xg,:);[rY,cY]=size(Y);m='p';
			disp('All data columns have been Truncated.')
		else
			disp('Invalid data selected, no action taken'),m='$';
		end
		disp(paktc),pause
	elseif m=='s'
		Ef=input('Choose X-axis expansion factor (2-10) > ');m='$';
		if ~isempty(Ef)
			Ef=fix(min(max(Ef,2),10)*rY);Xi=linspace(X(1),X(rY),Ef).';
			Z=zeros(Ef,Lctp);
			for i=1:Lctp
				Z(:,i)=spline(X,Y(:,ctp(i)),Xi);
			end
			X=Xi;Y=zeros(Ef,cY);Y(:,ctp)=Z;[rY,cY]=size(Y);m='p';yflag=1;
		end
	elseif m=='f'
		dX=diff(X);Ts=dX(1);
		if max(abs(dX-Ts))>1e-6
			disp('X axis data is not linearly spaced. FFT not possible.'),m='$';
		else
			np=2^nextpow2(X);
			c=input(['Choose frequency resolution in Hz [' num2str(1/(np*Ts)) '] > ']);
			if ~isempty(c),np=min(2^fix(log(1/(c(1)*Ts))/log(2)),np);end
			if input('Apply Hamming window to data? (y/n) [n] > ','s')=='y'
				w=0.54-0.46*cos(2*pi*(0:rY-1)'/(np-1)); %Hamming window
				Y(:,ctp)=Y(:,ctp).*w(:,ones(size(ctp)));
			end
			X=((0:np/2).')/(np*Ts);
			Z=abs(fft(Y(:,ctp),np));rY=np/2+1;Z=Z(1:rY,:);
			Y=zeros(rY,cY);Y(:,ctp)=Z;
			m='p';yflag=1;
			disp(['Frequency resolution used is ' num2str(1/(np*Ts))])
			disp('X-axis now has units of Hz'),disp(paktc),pause
		end
	elseif m=='g'&pflag
		figure(Hp),grid,m='$';
	elseif m=='h'&pflag
		figure(Hp),hold,m='$';
		if ishold,	M(3,25:27)='ON!';hflag=1;
		else,		M(3,25:27)='OFF';hflag=0;
		end
	elseif m=='l'&pflag
		figure(Hp)
		xl=input('Enter X-axis Label > ','s');if isempty(xl),xl=' ';end
		yl=input('Enter X-axis Label > ','s');if isempty(yl),yl=' ';end
		zl=input('Enter X-axis Label > ','s');if isempty(zl),zl=' ';end
		xlabel(xl),ylabel(yl),title(zl)
		m='$';
	elseif m=='@'&pflag
		tt=input('Enter text to put on plot > ','s');
		if ~isempty(tt)
			figure(Hp),zoom off
			disp('Identify the left edge for text placement'),disp(msg),gtext(tt)
			zoom on
		end
		m='$';
	elseif m=='-'&pflag
		hvf=input('Horizontal, Vertical, or Free Line? [f] > ','s');
		if hvf=='v'|hvf=='h'
			disp(['Choose Three points: ';'1 is point to cross, ';'2 and 3 are Endpoints'])
			disp(msg),
			figure(Hp),zoom off,[xg,yg]=ginput(3);
			if hvf=='v',hh=line([xg(1) xg(1)],yg(2:3),'Clipping','off');
			else,       hh=line(xg(2:3),[yg(1) yg(1)],'Clipping','off');
			end
			set(hh,'Linestyle',':','Color','w'),figure(Hp)
		else
			disp('Choose the ENDpoints of the line to be drawn')
			disp(msg),figure(Hp),zoom off
			[xg,yg]=ginput(2);hh=line(xg,yg,'Clipping','off');
			set(hh,'Linestyle',':','Color','w'),figure(Hp)
		end,m='$';zoom on
	elseif m=='!'
		eval(MM),disp(paktc),pause,m='$';
	elseif m=='?'|m=='/'
		if isempty(MM)
			disp('For help enter: Your Choice? > ?L')
			disp('where L is the letter of the command you want help on.')
			disp('Hidden commands: @ ! -'),disp(paktc),pause,m='$';
		else
			mm=lower(MM(1));mm(isspace(mm))=[];
			if isempty(mm),mm='$';m='?';MM=[];end
			if mm=='a'
				disp('All plot: plot all input data.')
			elseif mm=='p'
				disp('Plot Y: plot current selected data.')
			elseif mm=='r'
				disp('Restore all: restore input data as selected data.')
			elseif mm=='y'
				disp('Y select: select data columns for analysis.')
			elseif mm=='i'
				disp('Integrate: compute integral of selected columns of Y.')
			elseif mm=='d'
				disp('Derivative: compute derivative of selected columns of Y.')
			elseif mm=='m'
				disp('Manipulate: manipulate selected columns of Y.')
			elseif mm=='f'
				disp('FFT Y: compute FFT of selected columns in Y.')
			elseif mm=='l'
				disp('Label: place labels and title on the current plot.')
			elseif mm=='h'
				disp('Hold: hold the current plot.')
			elseif mm=='g'
				disp('Grid: add or remove a grid on the current plot.')
			elseif mm=='t'
				disp('Truncate: selects a subrange of X axis further examination.')
			elseif mm=='s'
				disp('Smooth: applies splines smoothing to selected columns in Y.')
			elseif mm=='c'
				disp('Curve fit: fits a polynomial to selected columns of Y.')
			elseif mm=='e'
				disp('Explore: interpolates X or Y data to find specific values.')
			elseif mm=='@'
				disp('@: places text on the current plot at a user-selected point.')
			elseif mm=='-'
				disp('-: places a line on the current plot at a user-selected location.')
			elseif mm=='!'
				disp('!: passes the rest of the line to MATLAB for processing.')
			end
			disp(paktc),pause,m='$';
		end
	else
		disp('Command unknown or not available at this time.')
		pause(2),m='$';
	end   
end
if input('Close figure windows? (y/n) [y] > ','s')~='n',close all,end
