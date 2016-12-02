function [magsq,phase]=hthermistor(f,w)
% Dynamic transfer function of FP07 thermistor

tau=0.005 * w^0.32; % thermistor time constant
magsq=1 ./ (1+((2*pi*tau).*f).^2).^2; %magnitude-squared

phase=-2*atan( (2*pi*tau).*f);
