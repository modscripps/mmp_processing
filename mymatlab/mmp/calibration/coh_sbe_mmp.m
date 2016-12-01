% coh_sbe_mmp.m
%   Function: m-script to compute and plot coherence-squared
%      and phase between SeaBird temperature and conductivity.
%      Need c and t arrays in memory.

FS=25;

[P,f]=spectrum(t,c,256,0,[],FS);
phase=angle(P(:,4)).*(180/(2*pi));

subplot(2,1,1)
semilogx(f,P(:,5))
axis([.1,(FS/2),0,1])
grid on
xlabel('f / Hz'), ylabel('Coh_sq')

subplot(2,1,2)
semilogx(f,phase)
axis([.1,(FS/2),-180,180])
grid on
xlabel('f / Hz'), ylabel('Phase / degrees')

