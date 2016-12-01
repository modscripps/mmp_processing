% test.m

plb=.1; start=plb;
pub=.3; stop=pub;
ref='v1';
speclen=512;
overlap=speclen/2;
drop=6605;
ch='v1';

clf
va_spec_mmp(drop, 'pr', start, stop)

