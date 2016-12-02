    function popup(h,layer);

    if ~exist('layer');
       layer = 1;
    end
    for i= 1: length(h);
        set(h(i),'zdata',layer*ones(size(get(h(i),'xdata'))));
    end

