function h=multixaxis(X,Y,xlabeltext,ylabeltext,titletext,linetype,position,dy,limits,reverse,yticklabel);
% Usage: h=multixaxis(X,Y,xlabeltext,ylabeltext,titletext,linetype,position,dy, ...
%         limits,reverse,yticklabel);
%   inputs
%     X, Y: matrices of the same size with data to plot
%           4 data pairs maximum
%     xlabeltext: matrix for the xlabel (default no xlabel)
%     ylabeltext: matrix for the ylabel (default no ylabel)
%     titletext: string title for entire plot
%     linetype: specifies the color and line type (optional)
%               default ([' y-';'r--';' b:';'g-.']);
%     position: position of the plot (default [0.2 0.2 0.6 0.6])
%     dy : vertical separation of xlabels (default dy = 0.03)
%     limits: matrix of max and mins for the plots
%     reverse: string set to 'y' to reverse y direction
%     yticklabels: number set to 0 to suppress yticklabels
%
%      example:
%        X = [temperature(:) salinity(:) sigma_theta(:)];
%        Y = pressure(:) * ones(1,3);
%        xlabeltext= ['temperature';
%                     'salinity   ';
%                     'sigma_theta'];
%        ylabeltext='pressure [MPa]';
%        titletext='your title here';
%        linetype = [' y-';'r--';' g:';'b-.'];
%        position = [0.2 0.2 0.6 0.6]; % rectangle for plot
%        dy = 0.06; % height of rectangle for additional axes below plot 
%        limits=[ Tlimits; Slimits; STlimits ]; % plotting limits, 
%               e.g. Tlimits=[10 11 0 .5]; to plot temp from 10 to 11 deg and
%                       0 to 0.5 MPa
%	       reverse=1 if y axis is to be reversed
% 	     yticklabels=0 if yticklabels are to be supressed
% 

if ~exist('reverse')
  reverse=1;
end
thick=[1.5 1.5 1.5 1.5];
[nnpts,nseries]=size(X);
   
% set lower axis spacing based on number of variables being plotted
[mX,nX]=size(X);
%   if (nX <= 4);
%      dy = 0.04;
%   end
%   if (nX <= 4);
%      position = [0.2 0.2 0.6 0.6];
%   end
%  if (nX <= 3);
%     linetype = [ 'w-';'g-';'b-';'c-'];
%  end
%   if (nX <=2);
%      xlabeltext = [' ']*ones(1,nseries);
%   end
   
% plot first variable
axes('position',position,'box','on','ticklength',[.05 .025]);
ha=plot(X(:,1),Y(:,1),str2mat(linetype(1,:)));
set(ha,'linewidth',thick(1))
axis(limits(1,:))
h=gca;
if reverse==1
  set(gca,'YDir','reverse')
end
if yticklabels==0
	set(gca,'yticklabels',' ')
end
hxl1=xlabel(xlabeltext(1,:));
%set(hxl1,'color',
   
ylabel(ylabeltext)
title(titletext)
hold on;
bottomposition = position;
bottomposition(4) = dy/4;

% plot remaining variables
for i=2:nseries;
  lt = rem(i,length(linetype)+1);
  axes('position',position,'box','off','ticklength',[.05 .025]);
  set(gca,'visible','off','xticklabel',[],'yticklabel',[]);
  hold on
       
	h1=plot(X(:,i),Y(:,i),str2mat(linetype(lt,:)));
	
	%get(h1,'color')
	set(h1,'LineWidth',thick(i));
  axis(limits(i,:))
  if reverse==1
    set(gca,'YDIR','reverse')
  end
  bottomaxis(bottomposition,(i-1)*dy);
  xlabel(xlabeltext(i,:))
  hold on
end

% release current plot
hold off;
