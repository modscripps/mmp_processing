function rawdata=read_rawdata_mmp(ch,drop,scanid,scanpos)
% read_rawdata_mmp:
%   Usage: rawdata = read_rawdata_mmp('ch',drop,scanid,scanpos)
%      ch: short name of a data channel, e.g. pr
%      drop: sequential mmp drop number
%      scanid: byte configuration in a data scan, optional. 
%      scanpos:  position of ch data in a scan, optional.
%   Function: Reads one channel of a raw mmp file
%	   all channels are output without being converted

% Modified 4 July 1995 to read data from Paros pressure gauges
% Modified 12jul96 to test existence of source_file
% Modified 16jul96 to add FSP and provide logic so script does
%   not bomb when data file or scaninfo do not exist

% read in location of data base and raw data
mmpfolders; 


% get scanid & scanpos if scanid or scanpos are empty
if nargin<4
	mmpid=read_mmpid(drop);
	[scanid,voffsetid]=read_config_mmp(mmpid,drop);
	[sensorid,electronicsid,filter,fc,scanpos] ...
	  =read_chconfig_mmp(ch,mmpid,drop);
end

% get byte positons of data channel selected
[scanlen,byteoffsets]=byteoffsets_mmp(scanid,scanpos);

% read data & write as short integers to temporary file
%source_file=[rawmmp '\' int2str(drop)];
source_file=['F:\Mmp\' int2str(drop)];
%
% Determine if source file exists and read it
if exist(source_file)~=2
  disp_str=['  read_rawdata_mmp: ' source_file ' does not exist'];
  disp(disp_str)
  rawdata=[];
elseif ~isempty(byteoffsets)
  dmx(source_file,'junk',scanlen,byteoffsets)
  %
  %  open the data file in read only mode
  fid = fopen('junk','r','ieee-be');
  %
  % select data format depending on channel
  if strcmp(ch,'id')==1
	rawdata=fread(fid,inf,'uint16');
  elseif strcmp(ch,'tsbe') | strcmp(ch,'csbe') | (strcmp(ch,'pr') & drop>=2099)
     rawdata=fread(fid,[3 inf], 'uint8');
     r1=16*rawdata(1,:)+fix(rawdata(2,:)/16);
     r2=256*rem(rawdata(2,:),16)+rawdata(3,:);
     rawdata=[r1;r2];
  else
 	rawdata=fread(fid,inf,'short'); 
  end
  %
  % close and delete intermediate file
  fclose(fid);
  delete junk
  %
  % convert to column vector or 2-column matrix for tsbe, csbe,
  % and pr with Paros gauge
  if strcmp(ch,'tsbe') | strcmp(ch,'csbe') | (strcmp(ch,'pr') & drop>=2099)
	rawdata=rawdata';
  end
end
