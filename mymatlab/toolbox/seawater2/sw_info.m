
% SW_INFO    Computational routines for the properties of sea water
%
%                  ****************************** 
%                  *      SEAWATER Library      * 
%                  *                            * 
%                  *        Version 1.2b        * 
%                  *                            * 
%                  *     Phillip P. Morgan      * 
%                  *           CSIRO            * 
%                  *                            *
%                  *     morgan@ml.csiro.au     *
%                  ****************************** 
%
% RELEASE:
%    SEAWATER Version 1.2b
%    $Revision: 1.4 $  $Date: 1994/10/11 01:24:24 $
%    Copyright (C) CSIRO, Phil Morgan 1993.
%
% DESCRIPTION:
%    SEAWATER is a toolkit of MATLAB routines for calculating the
%    properties of sea water. They are a self contained library and
%    are extremely easy to use.  
%

%
% DISCLAIMER
%   This software is provided "as is" without warranty of any kind.
%   See the file sw_copy.m for conditions of use and licence.
%
% REFERENCE:
%   Phillip P. Morgan, 1994. 
%   "SEAWATER: A Library of MATLAB Computational Routines for the 
%   Properties of Sea Water". CSIRO Marine Laboratories Report 222. 29pp.
%
%   The above reference is highly recommended as it fully describes
%   the sources of algorithms, conventions and also includes a
%   tutorial for oceanographers.
%
%   Reference is available from: 
%       The Librarian 
%       CSIRO Division of Oceanography
%       GPO Box 1536
%       Hobart Tasmania 7001
%       AUSTRALIA
%
% DATA FOR TUTORIAL
%   The data file sw_data.mat can be loaded into matlab using the commands
%      datafile = which('sw_data.mat');
%      eval(['load ' datafile])  
%   See the reference report for full description and tutorial.
% 
% IMPROVEMENTS AND SUGGESTIONS:
%   Please report any bugs so we update the master set of routines.
%   When reporting bugs please send a subset of the data you are
%   using, a diary of your matlab session and the results that you
%   think you should be getting.
%
%   If you have another routines that would be useful additions
%   then please send them to me.  Of course, copyright will stay 
%   with you (the author).
%
% COMMENTS:
%   We would also be interested in what areas of research and what
%   uses you have found for this library - very important for
%   resources to be made available to maintain the library.
%
% UPDATES:
%   The code will be placed on the anonymous ftp site aqueous.ml.csiro.au 
%   (192.67.12.100) under the directory /pub/morgan/seawater. Files 
%   are available individually or in one tar file seawater.tar
%   Update versions will be announced via the newsgroup
%   comp.soft-sys.matlab.  You may wish to periodically check the ftp
%   site for updates.
%
% INSTALLATION:
%   I suggest you place all the SEAWATER routines in a directory
%   called seawater and set your matlab path to that directory.  
%   See the matlab command "help path" for more details.
%
% LIST OF ROUTINES:
%
%     SW_ADTG    Adiabatic temperature gradient 
%     SW_ALPHA   Thermal expansion coefficient (alpha) 
%     SW_AONB    Calculate alpha/beta (a on b) 
%     SW_BETA    Saline contraction coefficient (beta) 
%     SW_BFRQ    Brunt-Vaisala Frequency Squared (N^2)
%     SW_COPY    Copyright and Licence file
%     SW_CP      Heat Capacity (Cp) of Sea Water 
%     SW_DENS    Density of sea water 
%     SW_DENS0   Denisty of sea water at atmospheric pressure 
%     SW_DIST    Distance between two lat, lon coordinates
%     SW_DPTH    Depth from pressure 
%     SW_F       Coriolis factor "f" 
%     SW_FP      Freezing Point of sea water 
%     SW_G       Gravitational acceleration 
%     SW_GPAN    Geopotential anomaly  
%     SW_GVEL    Geostrophic velocity 
%     SW_INFO    Information on the SEAWATER library. 
%     SW_PDEN    Potential Density 
%     SW_PRES    Pressure from depth 
%     SW_PTMP    Potential temperature 
%     SW_SALS    Salinity of sea water 
%     SW_SALT    Salinity from cndr, T, P 
%     SW_SVAN    Specific volume anomaly 
%     SW_SVEL    Sound velocity of sea water 
%     SW_SMOW    Denisty of standard mean ocean water (pure water) 
%     SW_TEMP    Temperature from potential temperature 
%
% LOW LEVEL ROUTINES CALLED BY ABOVE: (also available for you to use)
%
%     SW_C3515   Conductivity at (35,15,0) 
%     SW_CNDR    Conductivity ratio   R = C(S,T,P)/C(35,15,0) 
%     SW_SALDS   Differiential dS/d(sqrt(Rt)) at constant T. 
%     SW_SALRP   Conductivity ratio   Rp(S,T,P) = C(S,T,P)/C(S,T,0) 
%     SW_SALRT   Conductivity ratio   rt(T)     = C(35,T,0)/C(35,15,0) 
%     SW_SECK    Secant bulk modulus (K) of sea water 
%=========================================================================

more on
help sw_info
more off
return
%--------------------------------------------------------------------
