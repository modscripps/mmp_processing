function FiberSetup=fib_elec_mmp(FiberSetup);
%function FiberSetup=fib_elec_mmp;
%The first attempt at a naming convention is 
%[module][T1][T2][diffgain].
%return all of the electronics parameters in the refractometer circuitry.
%This function is called by calc_fiber_mmp.  It is specified in the "electronicsid"
%field in the mmp2s config directory for channel crg.
%This function should be redefined with a new name whenever the electronics settings are changed, and the
%config file modified to reflect this.

%Which module was in use
%FiberSetup.moduleSN=2;
%1 for lasermate, 2 for NEC laser and 3 for SLED

%gains on i1-i4
%FiberSetup.i1g=1;
%FiberSetup.i2g=1;

%FiberSetup.diffgain=2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameters below here are less likely to be changed
FiberSetup.i3g=1;
FiberSetup.i4g=1;

FiberSetup.fgain=1;
FiberSetup.divgain=10;

%What type of circuit did we use? 
FiberSetup.circuittype='divider';

FiberSetup.S=0.9; %sensitivity in A/W of the photodiodes

%differentiator settings
FiberSetup.K=212150;
FiberSetup.F1=398.6;
FiberSetup.F2=540.4;

%Specify feedback resistances based on module
if FiberSetup.moduleSN==1
    %Feedback resistance for sample channels
    FiberSetup.Rf_s=2000;
    %Feedback resistance for reference channels
    FiberSetup.Rf_r=50000;
elseif FiberSetup.moduleSN==2 %NEC
    %Feedback resistance for sample channels
    FiberSetup.Rf_s=3300;
    %Feedback resistance for reference channels
    FiberSetup.Rf_r=40000;
elseif FiberSetup.moduleSN==3
    %Feedback resistance for sample channels
    FiberSetup.Rf_s=10000;
    %Feedback resistance for reference channels
    FiberSetup.Rf_r=100000;
end

%divider output noise spectrum in V^2/Hz
FiberSetup.Sdiv=1e-12;

%Voltage offsets for zero light
FiberSetup.off1=0;
FiberSetup.off2=0;
FiberSetup.off3=0;
FiberSetup.off4=0;
FiberSetup.dum5=NaN;
