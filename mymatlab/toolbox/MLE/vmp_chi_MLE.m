function out = vmp_chi_MLE(k_in,S_obs_in,k_noise_cutoff,nu,kappa)
% This is Glenn Carter's implementation of Ruddick et al. 2000's Maximum
% Likelihood Spectral Fitting for VMP, adapted Apr-2017 by ECF for use in 
% MMP processing.

% IN:
% k_in:             wavenumbers of input spectra (cpm)
% S_obs_in:         input spectra
% k_noise_cutoff:   wavenumber cut off of spectral noise
% nu:               viscosity
% kappa:            molecular K_T

% OUT:
% out.chi:          MLE chi estimate
% out.kB:           frequency cut off of fitted Batchelor spectrum (cpm)
% out.delta95_kb:   standard error on kB
% out.epsilon_chi:  Epsilon calculated from kB
% out.epsilon_
%          chi_cf:  standard error on epsilon
% out.k_batchelor:  wavenumbers of fitted Batchelor spectrum, same as k_in
% out.S_batchelor:  fitted Batchelor spectrum
% out.k_noise_...
%           cutoff: original noise cutoff of spectrum.

% Initialize output structure 
% output structure
out.chi = nan;
out.kB = nan;
out.delta95_kB = nan;   % cpm
out.epsilon_chi = nan;
out.epsilon_chi_cf = [nan nan];
out.k_batchelor = k_in;
out.S_batchelor = nan*ones(size(k_in));
out.k_noise_cutoff = k_noise_cutoff;

MLE_successful = 1;

% trim wavenumber and spectra vectors to the noise limit
k = k_in(k_in <= k_noise_cutoff);
S_obs = S_obs_in(k_in <= k_noise_cutoff);

% make a range of wavenumbers to test the fitting with. Start with 60
% values
maxk = 10*max(k);
mink = maxk/200;
range = (maxk - mink)/61;

% Calculate first attempt at chi
if k_noise_cutoff > k_in(3)
chi = 6*kappa*vmp_integral(S_obs_in,k_in,k_in(2),k_noise_cutoff); % why not use trimmed ones?
else
    disp(sprintf('k_noise_cutoff = %4.2f',k_noise_cutoff,length(k)))
         MLE_successful = 0;
end

% Loop until the value for chi converges
chi_prev = 1e6;


count = 0;
while MLE_successful && (chi > 1.2*chi_prev || chi_prev > 1.2*chi) && count <= 10
    % loopover these k values, assuming they are the batchelor wavenumber, for
    % a rough search for the most likely kB
    loopover = mink:range:maxk;
    C = nan*ones(size(loopover));
    for ido = 1:length(loopover)
        k1 = loopover(ido);
        S_theoretical = vmp_batchelor_spectra(k1,k,chi,kappa);  %,q);
        C(ido) = vmp_C11(S_obs,S_theoretical); % cost function for fit
    end
    
    % Maximum value of C is a rough estimate of where the true maximum is
    [~,I] = max(C);
    rough_max = loopover(I);
    
    % if I is the last point then there are probably not enough points in
    % the spectrum to work with, after the noise cutoff. Return NaNs
    if I == length(loopover)
        disp(sprintf('k_noise_cutoff = %4.2f, spectrum only has %d points', ...
            k_noise_cutoff,length(k)))
         MLE_successful = 0;
        break
    elseif I == 1
        disp('Maximum found at first point, returning')
        MLE_successful = 0;
        break
    end
        
    
    % Estimate the curvature of C at the rough maximum as an indication of the
    % range over which the fine resolution search should be done.
    delta_k = (2*range)/sqrt(2*C(I) - C(I-1) - C(I+1));
    
    % Find the maximum range for the fine search. Taking the maximum of delta_k
    % and range ensures the new range will cover the true maximum.
    tt = max(delta_k,range);
    loopover = linspace( (rough_max-tt),(rough_max+tt),60 );
    C_fine = nan*ones(size(loopover));
    for ido = 1:length(loopover)
        k1 = loopover(ido);
        S_theoretical = vmp_batchelor_spectra(k1,k,chi,kappa);  %,q);
        C_fine(ido) = vmp_C11(S_obs,S_theoretical);
    end
    [~,I] = max(C_fine);
    
    % Refine the estimate of KB by finding where the derivative of a 5th order
    % polynomial fit goes to zero.
    % Use 7 points on either side of the maximum that has been identified so
    % far.
    Y = C_fine(I-7:I+7);
    X = loopover(I-7:I+7);
    [P,~,mu] = polyfit(X,Y,5);
    % take the derivative of the 5th order polynomial
    der = polyder(P);
    
    % Calculate the derivative over many points (remember that the polyfit was
    % on a scaled x). The maximum likelihood will occur where the the slope is
    % closest, in absolute value, to zero.
    manypoints = loopover(I-7):0.01:loopover(I+7);
    manypoints_sc = (manypoints - mu(1))./mu(2);
    pp = polyval(der,manypoints_sc);
    [~,max_spot] = min(abs(pp));
    best_kB = manypoints(max_spot);
    S_batchelor = vmp_batchelor_spectra(best_kB,k,chi,kappa);  %,q);
    
    % Account for the missing variance in the chi calculation
    % Batchelor wavenumber in cpm
    kB_cpm = best_kB/(2*pi);
    missing.low = 6*kappa*vmp_integral(S_batchelor,k,0,k(2));
    del_k = mean(diff(k));
    if kB_cpm >= k_noise_cutoff + del_k
        ktmp = (k(end-1):del_k:kB_cpm)';
        S_tmp = vmp_batchelor_spectra(best_kB,ktmp,chi,kappa);
        missing.high = 6*kappa*vmp_integral(S_tmp,ktmp,k_noise_cutoff,kB_cpm);
    else
        missing.high = 0;
    end
    chi_prev = chi;
    chi = missing.low + chi + missing.high;
    
    count = count + 1;
    MLE_successful = 1;
end

if  MLE_successful
    % Make Batchelor spectra for final chi and kB estimates
    S_batchelor = vmp_batchelor_spectra(best_kB,k_in,chi,kappa);  %,q);
    % set the wavenumbers beyond kB to the value at kB so it plots on a
    % sensible scale
    S_batchelor(k_in > kB_cpm) = S_batchelor(find(k_in >= kB_cpm,1,'first'));
    
    % Calculate the standard error on the estimate of kB using Ruddick et al.
    % 2000's eqn 22. The approximate 95% confidence interval is given by
    % 1.96*sigma.
    der2 = polyder(der);
    pp2 = polyval(der2,manypoints_sc);
    var_kB = -1/(pp2(max_spot));
    sigma_kB = sqrt(var_kB);
    delta95_kB = 1.96 * sigma_kB;
    
    % From the definition of kB calculate epsilon_scalar. kB is already in
    % radians per meter, no need to another 2pi
    epsilon_chi = (best_kB^4)*nu*kappa^2;
    epsilon_chi_cf = [((best_kB-delta95_kB)^4)*nu*kappa^2 ((best_kB+delta95_kB)^4)*nu*kappa^2];
    
    % output structure
    out.chi = chi;
    out.kB = kB_cpm;
    out.delta95_kB = delta95_kB/(2*pi);   % cpm
    out.epsilon_chi = epsilon_chi;
    out.epsilon_chi_cf = epsilon_chi_cf;
    out.k_batchelor = k_in;
    out.S_batchelor = S_batchelor;
    out.k_noise_cutoff = k_noise_cutoff;
    
end


% % Generate a bad data flag based on whether the observed spectra is a
% % closer match to the Batchelor spectra or a straight line in loglog space.
% % See Ruddick et al. 2000.
% logS = log10(S_obs(2:end));
% logk = log10(k(2:end));
% coeffs = polyfit(logk,logS,1);
% Kfit = 10.^(logk*coeffs(1));
% intercept = 10^coeffs(2);
% S_line = Kfit*intercept;
% likelihood.line = vmp_C11(S_obs(2:end),S_line);
% 
% likelihood_ratio = log10(likelihood.theory/likelihood.line);