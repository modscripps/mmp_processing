%
%        LOGTICKS           07-25-94         Ren-Chieh Lien
%
%        create logarithm scale tickmarks
%
%        function ticks = logticks(lb,ub);
%
%        combine with myticks('x','y',ticks,0.7)
%

    function ticks = logticks(lb,ub);

    for i=lb:ub;
	ticks = [ticks (1:9)*exp(i*log(10))];
    end
