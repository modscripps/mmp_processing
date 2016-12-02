function allaxes = multixaxis3(X,Y,xlabels,ylabels,titletext,fontsizes,lstyle,lcolor,marker,stair,position,dy,limits,reverse,yticks);
% Usage: 
%  multixaxis3(X,Y,xlabels,ylabels,titletext,fontsizes,lstyle,lcolor,marker,stair,position,dy,limits,reverse,yticks);
%  The routine will set all defaults if only X and Y are input, i.e. H=multixaxis(X,Y).  
%  The same result can also be obtained by using nulls for the other inputs, i.e.
%  multixaxis3(X,Y,[],[],[],[],[],[],[],[],[],[],[],[],[]);
%
%  Inputs:
%  X, Y: matrices of the same size with data to plot 4 data pairs maximum
%  xlabels: matrix for the xlabel (default no xlabel)
%  ylabels: vector for the ylabel (default no ylabel)
%  titletext: string title for entire plot
%  lstyle: matrix of linestyles
%  lcolor: matrix of rgb matrices of colors
%  marker: vector of vertex markers
%  stair: vector of 1's & 0's, 1's for stair_plot
%  position: position of the plot (default [0.2 0.2 0.6 0.6])
%  dy : vertical separation of xlabels (default dy = 0.03)
%  limits: matrix of max and mins for the plots
%  reverse: integer set to 1 to reverse y direction
%  yticks: integer set to 0 to suppress yticklabels
%
%  Outputs:
%  Ha & Hl are vectors of handles to the axes and lines
%
%  Example:
%  X = [temperature(:) salinity(:) sigma_theta(:)];
%  Y = pressure(:) * ones(1,3);
%  xlabels= ['temperature';  % # columns must be same in each row
%            'salinity   ';
%            'sigma_theta'];
%  ylabels='p / MPa';
%  titletext='your title here';
%  fontsizes=[xlabelsize; ylabelsize; titlesize]; Default=[12; 12; 12];
%  lstyle=[' -';'--';' :';'-.']; Default is ['-';'-';'-';'-'];
%  lcolor=[[1 0 0]; [0 1 0]; [0 0 1]; [1 0 1]]; (red, green, blue, magenta)
%  marker=['*'; 'o'; '+'; 'x'];  Default is none
%  stair=[1; 1; 0; 0];           Default is all zeros
%  position=[0.2 0.3 0.6 0.6];   Default value
%  dy=0.06;                      Default value
%  limits=[ Tlimits; Slimits; STlimits ]; % plotting limits, 
%     e.g. Tlimits=[10 11 0 .5]; to plot temp from 10 to 11 deg and 0 to 0.5 MPa.
%          Default calculates limits reverse=1 to be reverse y axis. Default is 0
% 	yticks=0                   Default value
%
% Function:
% To plot up to 4 profiles with differing units or magnitudes versus y.  The 
% xlabels are stacked below the bottom of the plot.  Only the left y axis is 
% labeled.  Input variable 'stair' allows plotting as stair steps.
% Adapted from the original multixaxis of RC Lien, M. Gregg 1nov96
% Modified for Matlab 5.1, 18aug97, M.Gregg

nin=nargin;
% check inputs and set defaults
[nnpts,nseries]=size(X); % nseries is # of variables
if nseries>4 error('too many input pairs'); end

% If only X and Y are input, set remaining inputs to nulls
% so defaults will be set
if nin==2
   xlabels=[]; ylabels=[]; titletext=[]; fontsizes=[]; lstyle=[]; lcolor=[]; marker=[];
	stair=[]; position=[]; dy=[]; limits=[]; reverse=[]; yticks=[];
end

% Set defaults
if isempty(xlabels) xlabels=[' '; ' '; ' '; ' ']; end
if isempty(ylabels) ylabels=[' '; ' '; ' '; ' ']; end
if isempty(titletext) titletext=' '; end
if isempty(fontsizes) fontsizes=[12; 12; 12]; end
if isempty(lstyle) lstyle=['-';'-';'-';'-']; end
if isempty(lcolor) lcolor=[[1 0 0]; [0 1 0]; [0 0 1]; [1 0 1]]; end
if isempty(marker) marker=['none';'none';'none';'none']; end
if isempty(stair) stair=[0; 0; 0; 0]; end
if isempty(position) position=[0.2 0.3 0.6 0.6]; end
if isempty(dy) dy=.06; end
if isempty(limits)
   igy=find(~isnan(Y));
	ymin=min(Y(igy)); ymax=max(Y(igy));
   for i=1:nseries	 
      igx=find(~isnan(X(:,i)));
		xmin=min(X(igx,i)); xmax=max(X(igx,i));
		xspan=xmax-xmin;
		xmin=xmin-.05*xspan; xmax=xmax+.05*xspan;
		limits=[limits; [xmin xmax ymin ymax]];
	end
end
if isempty(reverse) reverse='n'; end
if isempty(yticks) yticks=0; end

% set line thicknesses
thick=[1.5 1.5 1.5 1.5];

% set fontsizes
xlabelsize=fontsizes(1); ylabelsize=fontsizes(2); titlesize=fontsizes(3);

% plot first variable
Ha1=axes('position',position,'box','on','ticklength',[.02 .025]);
hold on
[mX,nX]=size(X);
if stair(1)==1 & mX>1
  h(1)=stair_plot(X(:,1),Y(:,1),'y','y');
else
  h(1)=plot(X(:,1),Y(:,1));
end
%
set(h(1),'linewidth',thick(1),'linestyle',lstyle(1,:),'color',lcolor(1,:), ...
   'marker',marker(1,:))
ha1=getallaxes;
set(ha1(1),'xcolor',lcolor(1,:))
if ~isempty(limits) axis(limits(1,:)); end 
%if ~isempty(limits) xlim(limits(1,:)); end %MHA change for R12
h=gca;
if reverse==1 set(gca,'YDir','reverse'); end
if yticks==0	set(gca,'yticklabel',' '); end
hxl1=xlabel(deblank(xlabels(1,:)));
set(hxl1,'color',lcolor(1,:),'fontsize',xlabelsize)
 
hyl1=ylabel(ylabels);
set(hyl1,'fontsize',ylabelsize)
ht1=title(titletext);
set(ht1,'fontsize',titlesize)
bottomposition = position;
bottomposition(4) = dy/4;

% combine axes for linkaxes
allaxes = Ha1;

% plot remaining variables
for i=2:nseries;
  lt = rem(i,length(lstyle)+1);
  allaxes(i) = axes('position',position,'box','off','ticklength',[.02 .025]);
  hold on
  set(gca,'visible','off','xticklabel',[],'yticklabel',[]);
       
  if stair(i)~=1
     h(i)=plot(X(:,i),Y(:,i));
  else
	  h(i)=stair_plot(X(:,i),Y(:,i),'y','y');
  end
  
  set(h(i),'linewidth',thick(1),'linestyle',lstyle(i,:),'color',lcolor(i,:), ...
     'marker',marker(i,:))
  
  %get(h1,'color')
  set(h(i),'LineWidth',thick(i));
  if ~isempty(limits) axis(limits(i,:)); end 
%  if ~isempty(limits) xlim(limits(i,:)); end %MHA change for R12
  if reverse==1 set(gca,'YDIR','reverse'); end
  bottomaxis(bottomposition,(i-1)*dy)
  hxli=xlabel(deblank(xlabels(i,:)));
  set(hxli,'color',lcolor(i,:),'fontsize',xlabelsize)
end


hold off