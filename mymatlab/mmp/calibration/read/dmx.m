function dmx(inputFileName, outputFileName, scanSize, offsetList)

% check number of arguments %
if nargin ~= 4
   error('DMX requires four arguments: (input file name, output file name, scan size, byte offset array).');
end

% file names %
if isa(inputFileName, 'char') == false
   error('DMX requires the first argument to be a row vector string specifying the input file name.');
end
if isa(outputFileName, 'char') == false
   error('DMX requires the second argument to be a row vector string specifying the output file name.');
end

% scan size %
if isa(scanSize, 'numeric') == false || isscalar(scanSize) == false
   error('DMX requires the third argument to be a scalar which specifies the scan size of the data.');
end
if scanSize < 2
   error('DMX requires third argument to specify a scan size greater than 1.');
end

% offsets %
if isa(offsetList, 'numeric') == false
   error('DMX requires the fourth argument to be a vector containing byte offsets');
end
if isreal(offsetList) == false
   error('DMX requires the fourth argument not to be a complex vector');
end
if issparse(offsetList) == true
   error('DMX requires the fourth argument to be a full vector containing byte offsets');
end
if isfloat(offsetList) == false
   error('DMX requires the fourth argument to be a double-precision vector');
end
[m,n] = size(offsetList);
if m > 1 && n > 1
   error('DMX requires the fourth argument to be a vector containing byte offsets');
end
% can utilize row or column vector but not matrix % 

% open files %
inputFileID = fopen(inputFileName, 'r');
if inputFileID == -1
   error('DMX unable to open input file');
end
outputFileID = fopen(outputFileName, 'w');
if outputFileID == -1
   fclose(inputFileName);
   error('DMX unable to open output file');
end

% demux the data %
if dmxProcess(inputFileID, outputFileID, offsetList, scanSize) ~= 0
   fclose(inputFileID);
   fclose(outputFileID);
   error('DMX processing function failed to complete normally');
end

% close files %
fcloseStatus = fclose(inputFileID);
if fcloseStatus ~= 0
   fclose(outputFileID);
   error('DMX unable to close input file');
end
fcloseStatus = fclose(outputFileID);
if fcloseStatus ~= 0
   error('DMX unable to close output file');
end

return;
end % dmx %

function [scanCounterValue] = GetScanCounter(data, index)
msb = uint8(data(index+1));
lsb = uint8(data(index+2));
msbWord = uint16(msb);
lsbWord = uint16(lsb);
msbWord = bitshift(msbWord, 8);
scanCounterValue = bitor(msbWord, lsbWord);
return;
end % GetScanCounter %

function [scanCounterOKStatus] = ScanCounterOK(value)
%verifyTheZeros = value & 0xc003;
verifyTheZeroBits = bitand(uint16(value), uint16(32768+16384+3));
if verifyTheZeroBits ~= uint16(0)
   scanCounterOKStatus = false;
   return;
end
scanCounterOKStatus = true;
return;
end % ScanCounterOK %

function [scanOKStatus] = ScanOK(data, index, scanSize)
scanOKStatus = false;
scanCounter1 = uint16(GetScanCounter(data, index));
if ScanCounterOK(scanCounter1) == false
   return;
end
scanCounter2 = uint16(GetScanCounter(data, index + scanSize));
if ScanCounterOK(scanCounter2) == false
   return;
end
scanCounterTarget = bitand(uint16(scanCounter1+4), uint16(16380));
%scanCounterTarget = ((scanCounter1+4) & 037774));
if scanCounter2 ~= scanCounterTarget
   return;
end
%fprintf('%04X %04X\n', scanCounter1, scanCounter2);
scanOKStatus = true;
return;
end % ScanOK %

function [SyncedToDataStatus] = SyncedToData(data, index, scanSize)
i = 0;
SyncedToDataStatus = false;
while i < (5 * scanSize)
   % check through five scans %
   if ScanOK(data, index+i, scanSize) == true
      i = i + scanSize;
      continue;
   else
      return;
   end
end
SyncedToDataStatus = true;
return;
end % SyncedToData %

function [dmxProcessStatus] = dmxProcess(inputFileID, outputFileID, offsetList, scanSize)
scanCounterSize = 2;
scanBufSize = 32768; % make array large to improve speed %
dataBufSize = 32768;
scanBufSynced = false;
scanBufCount = 0;
i = 0;
totalScans = 0;
scanBuf = zeros(1, scanBufSize, 'uint8');
dataBuf = zeros(1, dataBufSize, 'uint8');
totalBytes = 0;

[m,n] = size(offsetList);
if m < 1 || n < 1
   offsetCount = 0;
else
   if n > 1
      offsetCount = n;
   else
      offsetCount = m;
   end
end

while true
   if scanBufSynced == true
      % synced
      % process through the data
      if (i + scanSize + scanCounterSize) > scanBufCount
         % move bytes to beginning of buffer %
         scanBuf(1:scanBufCount-i) = scanBuf(i+1:scanBufCount);
         scanBufCount = scanBufCount - i;
         i = 0;
         % read in more bytes %
         [A, readCount] = fread(inputFileID, scanBufSize-scanBufCount, 'uint8');
         if readCount < 1
            %fprintf('readCount is %d\n', readCount);%
            %fprintf('a total of %d bytes read\n', totalBytes);%
            %fprintf('%d scans\n', totalScans);%
            dmxProcessStatus = 0;
            return;
         end
         totalBytes = totalBytes + readCount;
         scanBuf(scanBufCount+1:scanBufCount+readCount) = A(1:readCount);
         scanBufCount = scanBufCount + readCount;
         %fprintf('%d bytes read\n', readCount);
         continue;
      end
      if ScanOK(scanBuf, i, scanSize) == true
         totalScans = totalScans + 1;
         % pick out bytes if offsets are specified %
         if offsetCount > 0
            j = 0;
            while j < offsetCount
               dataBuf(1+j) = scanBuf(i+1+offsetList(j+1));
               j = j + 1;
            end
            % write bytes out %
            writeCount = fwrite(outputFileID, dataBuf(1:j), 'uint8');
            if writeCount ~= j
               fprintf('DMX unable to write to output file\n');
               dmxProcessStatus = 1;
               return;
            end
         end
         % fprintf('write bytes out\n');
         i = i + scanSize;
      else
         % sync has been lost %
         %fprintf('sync lost, i = %d\n', i);
         scanBufSynced = false;
      end
   else
      % not synced
      % attempt to sync with the data
      while true
         searchBlockSize = 5 * scanSize + scanCounterSize + i;
         if searchBlockSize > scanBufCount
            % shuffle bytes to beginning of buffer %
            %fprintf('scanBufCount is %d\n', scanBufCount);
            %fprintf('i is %d\n', i);
            % shift array elements
            scanBuf(1:scanBufCount-i) = scanBuf(i+1:scanBufCount);
            scanBufCount = scanBufCount - i;
            i = 0;
            % read in additional bytes %
            [A, readCount] = fread(inputFileID, scanBufSize-scanBufCount, 'uint8');
            if readCount < 1
               dmxProcessStatus = 0;
               %fprintf('a total of %d bytes read\n', totalBytes);
               return; % end of data while attempting to sync %
            end
            totalBytes = totalBytes + readCount;
            % move new bytes into scanBuf %
            %fprintf('%d bytes read\n', readCount);
            scanBuf(scanBufCount+1:scanBufCount+readCount) = A(1:readCount);
            scanBufCount = scanBufCount + readCount;
            continue;
         end
         if SyncedToData(scanBuf, i, scanSize) == true
            scanBufSynced = true;
            %fprintf('sync established, i = %d, total bytes %d\n', i, totalBytes);
            break; % exit sync attempt loop %
         else
            i = i + 1;
         end 
      end % sync attempt loop %
   end % synced conditional %
end % infinite function loop %
      
return;
end % dmxProcess %


