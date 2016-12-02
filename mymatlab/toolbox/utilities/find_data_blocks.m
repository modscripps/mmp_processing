function gd=find_data_blocks(d,len)
% Usage: gd=find_data_blocks(d,len)
%  inputs: 
%    d: a data vector
%    len: an integer stating the minimum number of consecutive
%         non-NaN values in a block
%  outputs:
%    gd: a 2-column matrix with the start & stop indices of
%        blocks of good data
% Function: To determine the start & stop indices of blocks of
%   good data.  A block is a sequence of length 'len' without NaNs.
% M.Gregg, 8jul96

if isempty(d) 
  gd=[];
  disp('  find_data_blocks: d is a null vector')
  return
end

if nargin<2
  len=1;
  disp('  find_data_blocks:  len not specified, set to 1')
end

n=length(d);
inan=find(isnan(d));
d_inan=diff(inan);
igaps=find(d_inan>len);

if isempty(inan)
  gd=[1 n];
  disp('  find_data_blocks: d has no NaNs')
  return
elseif length(inan)==n
  gd=[];
  disp('  find_data_blocks:  d contains only NaNs')
  return
end
  
% Find start and stop indices of good blocks between NaNs
start=inan(igaps)+1;
stop=start+d_inan(igaps)-2;

% Determine if the initial data are a good block and add
% to the start of the block list
if inan(1)>len
  start=[1 start];
  stop=[inan(1)-1 stop];
end

% Determine if the last data are a good block and add
% to the end of the block list
if n-max(inan)>=len
  start=[start max(inan)+1];
  stop=[stop n];
end

% Put start and stop indices of good blocks into 2-column matrix
gd=[start(:) stop(:)];
