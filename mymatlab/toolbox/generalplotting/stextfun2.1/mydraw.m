%
%      Draw a box
%
%      mydraw(position,[xlimits ylimits])
%
%      ex. mydraw([0.2 0.3 0.6 0.3],[-1 1 -1 1])
%

    function hbox=mydraw(position,limits);

    if ~exist('limits');
	limits=[-1 1 -1 1];
    end
    xb = limits(1); xe = limits(2);
    yb = limits(3); ye = limits(4);

    clg

    axes('position',position,'box','off','visible','off','xlim',[xb xe],...
	 'ylim',[yb ye]);
    hold on
    axis('square')
    hbox = plot([xb xe xe xb xb],[yb yb ye ye yb]);
