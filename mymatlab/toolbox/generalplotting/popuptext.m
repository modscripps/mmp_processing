  function popuptext(z);

  if ~exist('z');
     z = 1;
  end
  htext = findobj('type','text');
  for i = 1:length(htext);
      pos = get(htext(i),'position');
      set(htext(i),'position',[pos(1:2) z]);
  end

