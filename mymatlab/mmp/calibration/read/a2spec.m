%drop=6605;

% test the dmx function
offsetsV1 = [10 11 30 31 50 51 70 71 90 91 110 111 130 131 150 151 170 171 190 191 210 211 230 231 250 251 270 271 290 291 310 311];
dmx(['d:\mmp\data\' int2str(drop)], 'c:\junk', 320, offsetsV1);
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
title_str=['MMP2 drop=' int2str(drop) ' , 24feb98'];
title(title_str)
xlabel('f / Hz'), ylabel('counts^2 / Hz')