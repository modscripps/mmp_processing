
    function smoothedy = smoothing(y,order,beta);

    m = length(y);
    order = min([order m])  - 1;
    p = diff(eye(m),order);
    smoothedy = (eye(m) + beta* p' *p)\col(y);
