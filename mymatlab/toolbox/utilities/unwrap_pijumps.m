function phiu=unwrap_pijumps(phi);
% unwrap_pijumps
%   Usage: phiu=unwrap_pijumps(phi);
%      phi is a vector of phase angles in radians that may have
%         jumps of +/- pi
%      phiu is the vector after removal of jumps with magnitudes
%         close to +/- pi.  Other jumps are not removed

TOL=0.3; % tolerance for defining jumps as pi +/- TOL

lenphi=length(phi);

% Find jumps with magnitudes within +/- TOL of  pi.
dphi=diff(phi);
mag_dphi=abs(dphi);

% find indices where jumps occur
i=find(mag_dphi>pi-TOL & mag_dphi<pi+TOL); % indices in dphi
j=i+1; % jump indices in phi

% form vector of corrections to be added to phi
cumjumps=-cumsum(dphi(i)); % corrections are cumulative
correct=zeros(size(phi)); % vector of corrections
for k=1:length(j)-1
	lenk=j(k+1) - j(k);	
	correct(j(k):j(k+1)-1)=cumjumps(k)*ones(1,lenk);
end
% section from last jump to end of record
correct(j(k+1):lenphi)=cumjumps(length(j))*ones(1,lenphi-j(length(j))+1);

phiu=phi + correct;
