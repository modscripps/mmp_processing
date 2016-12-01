dp=median(diff(pr_obs(10:100)));
filtl=2*floor(0.01/dp);
b=ones(1,filtl)/filtl;a=1;
good = find(~isnan(obs)&~isnan(pr_obs));
new_obs2=filtfilt(b,a,obs(good));
new_obs=medfilt1(obs(good),filtl);

new_pr=filtfilt(b,a,pr_obs(good));
