%vac_spec.m


vac1=atod1_mmp(read_rawdata_mmp('vac1',drop));
vac2=atod1_mmp(read_rawdata_mmp('vac2',drop));

vac=[vac1 vac2];  clear vac1 vac2

ivac=1500:2800;
[Pvac1,f]=psd(vac(ivac,1),256,50);
Pvac1=Pvac1/25;
[Pvac2,f]=psd(vac(ivac,2),256,50);
Pvac1=Pvac1/25;

loglog(f,[Pvac1 Pvac2])