function w = fallrate_mmp(pr)

DECIMATE = 200;
DT=1/400; % mmp sample interval for pressure

p=pr(1:DECIMATE:length(pr));

fallrate=(100/(DECIMATE * DT)) .* diff(p);
prav=(p(1:length(p)-1) + p(2:length(p)))/2;

w(:,1)=prav';
w(:,2)=fallrate';
