function FiberSetup=fib_elec1_mmp(FiberSetup);
%return all of the electronics parameters in the refractometer circuitry.
%This function is called by calc_fiber_mmp.  It is specified in the "electronicsid"
%field in the mmp2s config directory.
%This function should be redefined with a new name whenever the electronics settings are changed, and the
%config file modified to reflect this.

%Which module was in use
FiberSetup.moduleSN=1;

%What type of circuit did we use? 
FiberSetup.circuittype='divider';

%gains on i1-i4
FiberSetup.i1g=1;
FiberSetup.i2g=1;
FiberSetup.i3g=1;
FiberSetup.i4g=1;

FiberSetup.S=0.9; %sensitivity in A/W of the photodiodes

%differentiator settings
FiberSetup.K=212150;
FiberSetup.F1=398.6;
FiberSetup.F2=540.4;

%final gain stage was set to 2 beginning with drop 12111
FiberSetup.fgain=2;
FiberSetup.divgain=10;
FiberSetup.diffgain=2;

%Feedback resistance for sample channels
FiberSetup.Rf_s=10000;
%Feedback resistance for reference channels
FiberSetup.Rf_r=100000;

%divider output noise spectrum in V^2/Hz
FiberSetup.Sdiv=1e-12;

FiberSetup.dum1=NaN;
FiberSetup.dum2=NaN;
FiberSetup.dum3=NaN;
FiberSetup.dum4=NaN;
FiberSetup.dum5=NaN;
