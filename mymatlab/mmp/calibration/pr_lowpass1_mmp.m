function prlp=pr_lowpass1_mmp(pr)


% apply lowpass filter
[b,a]=cheby1(8,.5,10/200);
prlp=filtfilt(b,a,pr);
