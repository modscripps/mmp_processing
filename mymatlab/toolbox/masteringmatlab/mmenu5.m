% mmenu5.m

Hm_control = uimenu('Label','Control');
Hm_extra = uimenu('Label','Extra');
Hm_limit = uimenu(Hm_control,'Label','Limited Menus',...
                'CallBack','set(Hm_extra,''Visible'',''off'')');
Hm_full = uimenu(Hm_control,'Label','Full Menus',...
                'CallBack','set(Hm_extra,''Visible'',''on'')');
