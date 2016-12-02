function [angle,pr_angle]=Rrhofun(s,th,p);
%Rrhofun: [angle,pr_angle]=Rrhofun(s,th,p) - density ratio as angle

	len=length(p);
	pr_angle=(p(1:len-1)+p(2:len))/2;
  s_avg=(s(1:len-1)+s(2:len))/2;
	th_avg=(th(1:len-1)+th(2:len))/2;
	alpha=sw_alpha(1000*s_avg,th_avg,100*pr_angle);
	beta=sw_beta(1000*s_avg,th_avg,100*pr_angle);
	
    dsdz = -diff(s)./diff(p)
    dthdz = -diff(th)./diff(p);
    bs = -beta.*dsdz;
    at = -alpha.*dthdz;
    angle = atan2(at,bs*0.001);

    Rrho= (beta.*dsdz) ./ (alpha.*dthdz);
