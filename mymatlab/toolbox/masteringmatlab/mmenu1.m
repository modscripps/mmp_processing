% mmenu1.m

Hm_ex = uimenu(gcf,'Label','Example');
Hm_grid = uimenu(Hm_ex,'Label','Grid','CallBack','grid');
Hm_view = uimenu(Hm_ex,'Label','View');
Hm_2d = uimenu(Hm_view,'Label','2-D','CallBack','view(2)');
Hm_3d = uimenu(Hm_view,'Label','3-D','CallBack','view(3)');
Hm_close = uimenu(gcf,'Label','Close');
Hm_clf = uimenu(Hm_close,'Label','Close Figure','CallBack','close');
m_destroy = uimenu(Hm_close,'Label','Remove Menus',... 
              'CallBack','delete(Hm_ex); delete(Hm_close); drawnow');
