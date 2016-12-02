function [kout,specout,kc,kb,k_iwt,eps_predict]=gmfrspeckc(N,E_ratio,kvis)
%   Usage: [kout,specout,kc,kb,k_iwt,eps_predict]=gmfrspeckc(N,E_ratio,kvis);
%     inputs
%      N is the scalar buoyancy frequency, in rad/sec
%      E_ratio is the scalar internal wave energy ratio
%      kvis is the scalar kinematic viscosity, m^2/s
%     output
%      kout is a vector of wavenumbers, cpm
%      specout is a vector of matching Froude spectra
%      kc is the scalar cutoff wavenumber of the i.w. spectrum
%      kb is the the scalar buoyancy wavenumber
%      k_iwt is the scalar wavenumber where Panchev and internal
%        wave spectra intersect
%      eps_predict is a scalar with the predicted dissipation rate in W/kg
%     Note: kout is spaced uniformly to kc, has no points
%       in the linear rolloff, and is spaced logarithmically 
%       in the the turbulent range
%     Function:
%      frspec=Froude spectrum for GM76 model with k3^-1 rolloff
%         at kc, where kc is calculated using Frsq_gm * 0.1 =
%         cst. epsilon calculated using (<Phi_Fr>/<Phi_Fr^GM>)^2
%         and (N/N0)^2 scaling
%   M.Gregg, 22 July 95

global N

% constants
N0=2*pi*(3/3600); % reference buoyancy frequency, radians/sec
kc_gm=0.1; % cutoff wavenumber, cpm
Frsq_kc=0.6607; % universal Fr^2 at kc

% check that k3 extends to kb
eps_predict=7e-10*(N/N0)^2*E_ratio^2;
kb=sqrt(N^3/eps_predict)/(2*pi);

% calculate kc as wavenumber where frspec=Frsq_kc 
kc=kc_gm/E_ratio; % initial estimate, assuming kc decr. linearly
%frint_kc=E_ratio*quad8('gmfrspec',0,kc); % spec amplitude is lin.
%MHA 10/09: replace quad8 with quadl.
frint_kc=E_ratio*quadl('gmfrspec',0,kc); % spec amplitude is lin.
err=(frint_kc-Frsq_kc)/Frsq_kc;
i=0;
while abs(err) > 0.001 
      i=i+1;
	  if i < 10
        kc=kc*(1-err);
        frint_kc=E_ratio*quad8('gmfrspec',0,kc);
	    err=(frint_kc-Frsq_kc)/Frsq_kc;
	  elseif i>=10
	    str=[' Iteration limit for kc exceeded: ' ...
	         int2str(i) ' iterations'];
		error(str)
	  end   
end

% calculate gmfrspec, add rolloff, and truncate at k3 just
% smaller than kb
k3=logspace(-3,log10(kc));
frspec=E_ratio * gmfrspec(k3);
fr_kc=max(frspec);

% find where the panchev spectrum crosses frspec
ki=NaN*ones(1,10);
fr_ki=NaN*ones(1,10); % array for frspec near intersection
p_ki=NaN*ones(1,10); % array for panchev spec near intersection
ki(1)=kb;
fr_ki(1)=fr_kc*kc/kb;
p_ki(1)=panchev1(eps_predict,kvis,kb)/N^2;
err_i=(p_ki(1)-fr_ki(1))/fr_ki(1);
i=1;
while abs(err_i) > 0.001
    i=i+1;
	if i < 10
      ki(i)=(1-err_i)*ki(i-1);
	  fr_ki(i)=max(frspec)*kc/ki(i);
	  p_ki(i)=panchev1(eps_predict,kvis,ki)/N^2;
	  err_i=(p_ki(i)-fr_ki(i))/fr_ki(i);
	elseif i>=10
	  str=['  Iteration limit for ki exceeded: ' ...
	       ' int2str(i) ' iterations'];
	  error(str)
	end
end
k_iwt=ki(i);
frspec_iwt=fr_ki(i);

% calculate the Panchev spectrum
eta=(kvis^3/eps_predict)^(1/4); % Kolmogoroff length scale, in meters
[kt,tspec]=panchev_logspace(eps_predict,kvis);
kt=kt(:)'; tspec=tspec(:)';
tspec=tspec/N^2;
it=find(kt>=ki(i) & kt <.08/eta);


% form the composite spectrum
kout=[k3 k_iwt kt(it)];
specout=[frspec frspec_iwt  tspec(it)];

