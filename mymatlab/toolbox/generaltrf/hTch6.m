function y = hTch6(f,fc)
% hTch6(f,fc)
% Power transfer function of 6-pole Tchebyschev filter with 3db pt at fc Hz.

alpha=1.068517;
f0 = (fc / alpha);
x = (f' / f0);
eeps=0.2170911;
y=1 ./ (1 + eeps.^2 .* (32 .* x.^6 - 48 .* x.^4 + 18 .* x.^2 - 1).^2);
