    function pushdown(h,value);

    if ~exist('value');
       value = -Inf;
    end
    for i= 1: length(h);
	x = get(h(i),'xdata');
        set(h(i),'zdata',value*ones(size(x)));
    end
