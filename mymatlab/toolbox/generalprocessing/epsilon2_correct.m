function f=epsilon2_correct(eps_res,kvis)

pf=[-3.12067617e-05, -1.31492870e-03, -2.29864661e-02, -2.18323426e-01, ...
      -1.23597906, -4.29137352,-8.91987933, -9.58856889, -2.41486526];

ler=log10(eps_res);
	
if ler <= -6 % no correction needed
	lf_eps=0;
elseif ler>-6 & ler<=-1 % range of fit
	lf_eps=polyval(pf,ler);	
	if ler < -2 % apply viscosity correction
 		lf_eps=lf_eps+0.05*(ler+6)*(1.3e-6-kvis)/(0.3e-6);
	end
elseif ler>-1
	lf_eps=polyval(pf,-1);
end

f=10.^lf_eps;

