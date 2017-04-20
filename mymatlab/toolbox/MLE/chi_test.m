
% read in the relavant info
out = read_vmp_netcdf('/Users/gscarter/Documents/VMP/SPAM/RR1209/VMP/processed/SPAM1030', ...
    [],{'T1_dT1','ub_idx','lb_idx','latitude','meanW','epsilon','fs_fast','nu'}); 
% need the A/D counts as well as the data in physical units
S = load('/Users/gscarter/Documents/VMP/SPAM/RR1209/VMP/SPAM1');
descent = S.Line_9.cast10.descent.fast;
[data,time] = vmp_read_channels('/Users/gscarter/Documents/VMP/SPAM/RR1209/VMP/raw/SPAM1030.P',5,descent);

% sampling frequency
fs = out.fs_fast;

% convert to double
T1_dT1 = double(out.T1_dT1);
pr = double(out.pres_f);

% convert db to meters
dep = sw_dpth(pr,out.latitude);

kappa = 1.4e-7;

n = length(out.pres_eps);
profile.chi = nan*ones(n,1);
profile.kB = nan*ones(n,1);
profile.delta95_kB = nan*ones(n,1);
profile.epsilon_chi = nan*ones(n,1);
profile.epsilon_chi_cf = nan*ones(n,2);
profile.k_noise_cutoff = nan*ones(n,1);
profile.k_batchelor = nan*ones(n,1025);
profile.S_batchelor = nan*ones(n,1025);


% choose window
for ido = 1:n
    ido
    idx = out.lb_idx(ido):out.ub_idx(ido);
    
    nu = out.nu(ido);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % calculating temperature gradient spectra by applying derivative to
    % temperature spectra
    [ST,f] = pmtm(detrend(T1_dT1(idx)),4,[],fs);
    Sgf = ST.*(2*pi*f).^2;
    
    % FP07 response
    fc = 20;
    response = 1./(1+(f/fc).^2);
    Sgfc = Sgf./response;
    
    % spectra of counts
    [Sc,fc] = pmtm(detrend(data.ch05(idx)),4,[],fs);
    
    % noise spectra (counts)
    Noise = vmp_noise_model('T1_dT1',fc,time,'VMP040','/Users/gscarter/Documents/VMP')';
    
    % find the frequency were signal and noise cross (ie all noise)
    ii = find(Noise-Sc >0,1);
    f_noise_cutoff = fc(ii);
    
    % convert to wavenumber
    k = f/out.meanW(ido);
    k_noise_cutoff = f_noise_cutoff/out.meanW(ido);
    Sgk = Sgfc.*out.meanW(ido);
    
    Chi = vmp_chi_MLE(k,Sgk,k_noise_cutoff,nu,kappa);
    
    profile.chi(ido) = Chi.chi;
    profile.kB(ido) = Chi.kB;
    profile.delta95_kB(ido) = Chi.delta95_kB;
    profile.epsilon_chi(ido) = Chi.epsilon_chi;
    profile.epsilon_chi_cf(ido,:) = Chi.epsilon_chi_cf;
    profile.k_noise_cutoff(ido) = Chi.k_noise_cutoff;
    profile.k_batchelor(ido,1:length(Chi.k_batchelor)) = Chi.k_batchelor(:)';
    profile.S_batchelor(ido,1:length(Chi.S_batchelor)) = Chi.S_batchelor(:)';
    
end


% % plot a bunch of bachelor spectra to see if we are on the right track
% nu = 1e-6;
% kappaT = 1.4e-7;
% q = 3.7; 
% 
% eps = [1e-13 1e-12 1e-10 1e-9 1e-8];
% chi = [1e-12 1e-11 1e-10 1e-9 1e-8];
% 
% batch = nan*ones(15,1001);
% k_batch = nan*ones(15,1001);
% chiT = nan*ones(15,1);
% epsilon = nan*ones(15,1);
% 
% count = 1;
% for ido = 1:length(eps)
%     for jdo = 1:length(chi)
%         [k_batch(count,:),batch(count,:)] = batchelor(eps(ido),chi(jdo),nu,kappaT,q);
%         chiT(count) = chi(jdo);
%         epsilon(count) = eps(ido);
%         count = count + 1;
%     end 
% end
% 
% % plot
% loglog(k_batch(1:5:25,:)',batch(1:5:25,:)','c')
% hold on
% loglog(k_batch(2:5:25,:)',batch(2:5:25,:)','m')
% loglog(k_batch(3:5:25,:)',batch(3:5:25,:)','y')
% loglog(k_batch(4:5:25,:)',batch(4:5:25,:)','g')
% loglog(k_batch(5:5:25,:)',batch(5:5:25,:)','k')
% 
% loglog(k,Sgk,'r',k,Sck,'b')
