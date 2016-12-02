%
%    [hlines,hpatches]=getallline(hf);
%
%    get line and patches objects in hf
%
%    Ren-Chieh Lien            1996
%

    function [hlines,hpatches] = getallline(hf);

    for i = 1:length(hf);
        hl = findobj(hf(i),'type','line');
        hp = findobj(hf(i),'type','patch');
        if exist('hlines');
           hlines = [hlines(:)' hl(:)'];
        else
           hlines = [hl(:)'];
        end
        if exist('hpatches');
           hpatches = [hpatches(:)' hp(:)'];
        else
           hpatches = [hp(:)'];
        end
    end


