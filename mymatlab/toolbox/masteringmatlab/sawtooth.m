function f=sawtooth(t,T)
%SAWTOOTH Sawtooth Waveform Generation.
% SAWTOOTH(t,T) computes values of a sawtooth having a
% period T at the values in t.
%
% Used in Fourier series example.

f=10*rem(t,T)/T;
