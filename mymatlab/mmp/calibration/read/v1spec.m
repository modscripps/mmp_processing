%drop=6605;

if strcmp(ch,'a1');
   offsets = [14 15 34 35 54 55 74 75 94 95 114 115 134 135 154 155 174 175 194 195 214 215 234 235 254 255 274 275 294 295 314 315];
elseif strcmp(ch,'a2')	
   offsets = [16 17 36 37 56 57 76 77 96 97 116 117 136 137 156 157 176 177 196 197 216 217 236 237 256 257 276 277 296 297 316 317];
elseif strcmp(ch,'v1')
   offsets = [10 11 30 31 50 51 70 71 90 91 110 111 130 131 150 151 170 171 190 191 210 211 230 231 250 251 270 271 290 291 310 311];
end

% test the dmx function
dmx(['d:\mmp\data\' int2str(drop)], 'c:\junk', 320, offsets);
% read and display the extracted data as short integers
fid = fopen('c:\junk','r','ieee-be');
x = fread(fid,inf,'int16');
fclose(fid);
plot(x)

figure
Fs=400;
[Pxx,f]=psd(x(1e4:1.5e4),512,Fs);  
Pxx=Pxx/(Fs/2);
Hp=loglog(f,Pxx);
set(Hp,'linewidth',2)
grid on
title_str=['MMP1 drop=' int2str(drop) ' , ch=' ch ', 24feb98'];
title(title_str)
xlabel('f / Hz'), ylabel('counts^2 / Hz')