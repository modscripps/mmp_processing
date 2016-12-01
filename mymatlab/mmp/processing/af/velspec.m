function y = htotal(Sv,Cs,f,w)
% htotal(Sv,Cs,f,w) - total transfer function of mmp for velocity from volts

g=9.8;

%y =  ( ((w*Sv)/(2*g))^2 .* hv1(Cs,f,w) .* hprobe_ninnis(f,w)' );
y =  (  hv1(Cs,f,w) .* hprobe_ninnis(f,w)' );
