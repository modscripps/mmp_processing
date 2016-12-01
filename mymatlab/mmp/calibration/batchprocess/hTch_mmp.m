function y = hTch(f)
% hTch(f) Transfer func. of MMP Tchebyschev filter

fc=150;
alpha=1.068517;
eps=0.2170911;

f0 = (fc / alpha);
x = (f' / f0);
y=1 ./ (1 + eps.^2 .* (32 .* x.^6 - 48 .* x.^4 + 18 .* x.^2 - 1).^2);
