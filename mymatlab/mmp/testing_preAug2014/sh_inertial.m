% sh_inertial.m

k0=2;
kvis=2e-6;
epsilon=3.1e-6;

knu=(epsilon/kvis^3).^(1/4)/(2*pi);
kinertial=10;

shear_sq=8.34*(3/4)*(kinertial.^(4/3)-k0^(4/3)).*epsilon.^(2/3);