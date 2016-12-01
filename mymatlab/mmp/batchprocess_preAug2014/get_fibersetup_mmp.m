function FiberSetup=get_fibersetup_mmp(drop)
%get_fibersetup_mmp
%Get the electronics settings, etc, for the specified drop.
%The electronicsid column of the crg file in the config directory contains the filename of a function
%fib_elec*_mmp.m which fills in all of the needed fields.
%
%This function reads the filename from the config/crg file, and calls the named
%function.  The values are returned in a structure called FiberSetup.
%
%12/01 MHA
%
%2/02 change: electronicsid now has the format:
%[module][T1][T2][diffgain][electronicssettingsfunction]
%i.e. 3112fib_elec2_mmp specifies module #1, T1 = T2=1, diffgain=2 and 
%use function fib_elec2_mmp to set the rest of the settings.
%
%5/02 changes: added code to do the diffgain right given the new circuit with the 4x gain
%in the denominator, and also to put physical constants and sample rates, etc, in FiberSetup as well.

%specify 
[sensorid,electronicsid,filter,fc,scanpos]= read_chconfig_mmp('crg','mmp2s',drop);

%Set other parameters specified in electronicsid
FiberSetup.moduleSN=str2num(electronicsid(1));
FiberSetup.i1g=str2num(electronicsid(2));
FiberSetup.i2g=str2num(electronicsid(3));
FiberSetup.diffgain=str2num(electronicsid(4));

%Now do a kluge for the ps02 cruise - specify 1-5 for nominal difference
%gains of 1,6,11,13 and 16.  These are divided by 4 to account for
%the additional gain placed on the denominator.
if drop >=13600 & drop <=14000
    if FiberSetup.diffgain==1
        FiberSetup.diffgain=1/4;
    elseif FiberSetup.diffgain==2
        FiberSetup.diffgain=6/4;
    elseif FiberSetup.diffgain==3
        FiberSetup.diffgain=11/4;
    if FiberSetup.diffgain==4
        FiberSetup.diffgain=13/4;
    elseif FiberSetup.diffgain==5
        FiberSetup.diffgain=16/4;
    end
end 
end

%str1='[moduleSN,circuittype,i1g,i2g,i3g,i4g,S,K,F1,F2,fgain,divgain,diffgain,Rf_s,Rf_r,Sdiv,dum1,dum2,dum3,dum4,dum5]=';
str1='FiberSetup=';
eval([str1 electronicsid(5:length(electronicsid)) '(FiberSetup);'])



%Constants etc
%# of 400-Hz scans in a 25-Hz scan
FiberSetup.hfperscan=16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Physical constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FiberSetup.kvis=1e-6;
FiberSetup.ktemp=1.4e-7;
FiberSetup.ksal=FiberSetup.ktemp/100;
FiberSetup.q=3.2;

%
FiberSetup.dnds=1.78e-4; %n/psu
FiberSetup.dndt=-.5e-4; %n/degC
FiberSetup.wavelength=1550; %in nm

%dt's
FiberSetup.dtsbe=1/25;
FiberSetup.dtth=1/400;
FiberSetup.dti=1/50;
FiberSetup.dtcrg=1/800;
