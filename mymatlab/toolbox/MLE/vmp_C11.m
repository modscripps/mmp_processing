function costs = vmp_C11(S_obs,S_theoretical)% costs = C11(S_obs,S_theoretical)%% This m-file calculates the cost function value of a theoretical fit to a % real spectrum. Called from vmp_chi_MLE. Closely follows the code% acommpanying Ruddick et al, 2000, JTECH.%% INPUTS %	  k_obs: vector of wavenumbers from the observed spectra.%	  S_obs: vector of observed spectral values from the spectral data. %	  S_theoretical: vector of the theoretical spectra. Currently will be%	       the Batchelor spectrum.%%  OUTPUTS%     costs: the cost function value for the given observed spectrum%				and theoretical fitted spectrum. % % G. Carter Aug-12% degrees of freedom, is a Chi-squared parameter when modelling the errors.dof_c11 = 8;% the eps factor is a small matlab number (2.2204e-16) added to prevent the% log operation from producing errors by attempting to take the log of a% very small numberC11 = log( (chi2pdf((dof_c11.*S_obs)./ ...    (S_theoretical),dof_c11).*dof_c11./S_theoretical) +eps);costs = nansum(C11);