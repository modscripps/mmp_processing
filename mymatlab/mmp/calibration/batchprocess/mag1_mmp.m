function mxyz=mag1_mmp(drop,mmpid,rawV)
% Usage: mxyz=mag1_mmp(drop,mmpid,rawV);
%  inputs
%    drop: integer drop number
%    mmpid: string instrument id, e.g. 'mmp3' [optional]
%	  rawV: 0 - apply calibrations [default], 1 - return RAW voltages
%	output
%	  mxyz: magnetometer data mx,my,mz in 3 columns
% Function: reads raw magnetometer data and returns it
%    in volts (rawV=1) or nanoTeslas (rawV=0) 
% Dave Winkel June-2000 (based on code of Matthew Alford, 9/9/99)  

mmpfolders;

if nargin<1
  disp('   mag1_mmp: drop number required')
  break
elseif nargin<2
   mmpid = []; rawV = 0;
elseif nargin<3
   rawV = 0;
end
if isempty(mmpid)
   mmpid = read_mmpid(drop);
end

chS = ['mx';'my';'mz'];
for ic=1:size(chS,1)
   ch = chS(ic,1:2);
   % Read raw data and convert from counts to volts
   mV=read_rawdata_mmp(ch,drop);
   mxyz(:,ic)=atod1_mmp(mV);
end

% if rawV=1, stop here and return untreated voltages
if rawV>0
   return
end

% Apply calibrations to orthogonalize axes and convert to nT.
% Coefficients are for specific sensor (APS534); if another unit
%	is acquired, or this one is re-calibrated, either copy this
%	function to create another (and log in 'algorithm/mmp3/{mx,my,mz}'),
%	or put cal's in an ascii file.  (Note that these cal's apply to
%	the entire unit, rather than just to its individual channels/axes)

% Initial cals from manufacturer, Summer 1999:
cx1=.9959;
cx2=0;
cx3=.012040;
cx4=0;
cx5=-.00476;
cx6=1;
cx7=-.00046;
cy1=1.0001;
cy2=0;
cy3=.018640;
cy4=0;
cy5=1;
cy6=.00280;
cy7=.00364;
cz1=1.0004;
cz2=0;
cz3=.016390;
cz4=0;
cz5=-.00668;
cz6=-.00145;
cz7=1;

deltat=0; % temperature dependencies not requested/supplied

mV = mxyz;
% First correct each for scale and offset
mV(:,1) = mV(:,1)*(cx1+cx2*deltat)	+	cx3	+	cx4*deltat;
mV(:,2) = mV(:,2)*(cy1+cx2*deltat)	+	cy3	+	cy4*deltat;
mV(:,3) = mV(:,3)*(cz1+cx2*deltat)	+	cz3	+	cz4*deltat;

% Then orthogonalize axes (small adjustments)
mxyz(:,1) = cx5*mV(:,1)	+ cx6*mV(:,2) + cx7*mV(:,3);
mxyz(:,2) = cy5*mV(:,1)	+ cy6*mV(:,2) + cy7*mV(:,3);
mxyz(:,3) = cz5*mV(:,1)	+ cz6*mV(:,2) + cz7*mV(:,3);

% And finally magnetic flux density in nT is given by
mxyz = 25000 * mxyz;

%% NOTE that similar corrections still must be made for (mmp3)
%% instrument-related effects on the mag field; THESE cals are
%% are just for the magnetometer unit in isolation.
