% plot_wbotc

% plot wbo, tth, and cnb transfer functions

clf

cshot=910;
tshot=900;
nbshot=465;
w=0.26;

% set up wavenumber and frequency vectors
k=logspace(-2,log10(500),100);
f=k*w;

% calculate wbot amplitude-squared and phase
ht=wbo_shot_trf(tshot,k);
htsq=abs(ht).^2;
pht=angle(ht);
pht=180*unwrap(pht)/pi;

% calculate wboc amplitude-squared and phase
hc=wbo_shot_trf(cshot,k);
hcsq=abs(hc).^2;
phc=angle(hc);
phc=180*unwrap(phc)/pi;

% shift wboc phase to be relative to leading edge of cell
phc=phc-360*0.1083*k;

% obtain transfer function for fp07 thermistor
[h07,ph07]=h_fp07(f,w);
p07=180*ph07/pi;

% obtain the transfer function for the n brown cell
str=['load ' setstr(39) '/home/gregg/msp/th2sal/data/nbrown' int2str(nbshot) ...
      setstr(39)];
eval(str)
f_nb=k_nb*w;

% shift phase of nbrown cell to leading edge of cell
ph_nb=ph_nb-360*0.015*k_nb;

% find where wbo responses exceed their range
htmin=min(htsq);
iwbot=find(htsq==htmin);
hcmin=min(hcsq);
iwboc=find(hcsq==hcmin);

% plot htsq
position=[.2 .52 .5 .3];
axes('position',position,'xscale','log','yscale','log','xticklabels' ...
     ,' ','box','on','ticklength',[.02 .025]);
hold on
ht=plot(f(1:iwbot),htsq(1:iwbot));
set(ht,'linewidth',1.5);
axis([.01 100 .01 1])
sylabel('\14\times H^2')
title('Transfer functions at 0.26 m/s')

% overlay hcsq
plot(f(1:iwboc),hcsq(1:iwboc))

% overlay h07
plot(f,h07,'--')

% overlay hsq of nbrown cell
plot(f_nb,hsq_nb,'-.')



% plot pht
position=[.2 .2 .5 .3];
axes('position',position,'xscale','log','box','on','ticklength',[.02 .025]);
hold on
pt=plot(f(1:iwbot),pht(1:iwbot));
set(pt,'linewidth',1.5)
axis([.01 100 -360 0])

% overlay phc
plot(f(1:iwboc),phc(1:iwboc))

% overlay p07
plot(f,p07,'--')

% overlay phase of nbrown
plot(f_nb,ph_nb,'-.')

xlabel('f / Hz')
sylabel('\14\times {\14 \symb f} / deg');

% label curves on phase plot
text(4,-310,'sbe_c')
text(7,-190,'sbe_t')
text(25,-80,'fp07')
text(5,-100,'nb_c')

% add shot numbers
str=['sbe_t shot ' int2str(tshot)];
text(.02,-310,str)
str=['sbe_c shot ' int2str(cshot)];
text(.02,-260,str)
str=['nb_c shot ' int2str(nbshot)];
text(.02,-210,str)

% make an expanded scale of amplitude plot at low frequency
figure

ht=plot(f(1:iwbot),htsq(1:iwbot));
set(ht,'linewidth',1.5);
hold on
plot(f(1:iwboc),hcsq(1:iwboc));
plot(f,h07,'--')
plot(f_nb,hsq_nb,'-.')
axis([0 .2 0.9 1.001])
xlabel('f / Hz'); sylabel('\14\times H^2')
title('Amplitude-squared responses at 0.26 m/s')

text(0.16,0.995,'fp07')
text(0.12,0.99,'sbe_t')
text(0.1,0.95,'sbe_c')
