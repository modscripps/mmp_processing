function theta_ref = potempref(s0,t0,p0,p_ref)
% potempref
%   Usage: theta_ref = potempref(s,t,p,p_ref);
%      s0 = in-situ salinity in concentration units
%      t0 = in-situ temperature in deg C
%      p0 = in-situ pressure in MPa
%      p_ref = reference pressure for potential temperature
%      theta_ref = potential temperature at the reference pressure
%   Function: compute potential temperature on a specified presssure surface
%
%	Source		:	N.Fofonoff, 1977, Deep-Sea Res., 24,489-491.
%					The paper contains several errors
%					which have been corrected according
%					to E.D'Asaro.
%	Units		:	deg C
%	Input		:	s(conc. units), t(deg C), p(Mpa), p_ref(MPa)
%	Check value	:	theta_ref(.035,0,100,0)=-1.097477, compared
%					to -1.09757 from thetab.
%	Coded		:	M.Gregg 10/14/83
%			:	B Hess   6/24/86 call c version of gammab
%------------------------------------------------------------------------------



 SQR2 = 1.414214;


	theta0 = t0;

	dp = (p_ref - p0) / 2;
	p = p0; 

	for i=1:2;
		dtheta1 = dp .* gammab (s0, theta0, p);
		q1 = dtheta1;
		theta1 = theta0 + dtheta1 / 2;

		p1 = p + dp / 2;
		dtheta2 = dp .* gammab (s0, theta1, p1);
		q2 = (2 - SQR2) * dtheta2 + (-2 + 3 / SQR2) * q1;
		theta2 = theta1 + (1 - 1 / SQR2) * (dtheta2 - q1);

		dtheta3 = dp .* gammab (s0, theta2, p1);
		q3 = (2 + SQR2) * dtheta3 + (-2 - 3 / SQR2) * q2;
		theta3 = theta2 + (1 + 1 / SQR2) * (dtheta3 - q2);

		p2 = p + dp;
		dtheta4 = dp .* gammab (s0, theta3, p2); 
		theta4 = theta3 + (dtheta4 - 2 * q3) / 6;

		theta0 = theta4;
		p = p0 + dp;
        end
	theta_ref = theta4;
