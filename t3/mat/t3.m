close all 
clear all

format long;


f=50;
w=2*pi*f;
R=70e3;
C=354e-6;
Ro=6.08e3;
nd=18;
v_on=12/nd;

%envelope detector
A=23;
t=linspace(0, 0.1, 2000);
vS = A * cos(w*t);
vOhr = zeros(1, length(t));
vOe = zeros(1, length(t));

tOFF = 1/w * atan(1/w/R/C);
vOnexp = A*cos(w*tOFF)*exp(-(t-tOFF)/R/C);

vOhr=abs(vS);

theo1=figure();

plot(t*1000, vOhr)
hold

for i=1:length(t)
  if t(i) < tOFF
    vOe(i) = vOhr(i);
  elseif vOnexp(i) > vOhr(i)
    vOe(i) = vOnexp(i);
  else
    tOFF = tOFF + 1/(2*f);
    vOnexp = A*abs(cos(w*tOFF))*exp(-(t-tOFF)/R/C);
    vOe(i) = vOhr(i);
  endif
endfor

avgenv=mean(vOe);
plot(t*1000, vOe)
title("Output voltage v_o(t)")
ylabel("V")
xlabel ("t[ms]")
legend("rectified","envelope")
print (theo1, "theo1.eps", "-depsc");


vOr = zeros(1, length(t));
vOrdc = v_on*nd;
vOrac = zeros(1, length(t));

vt = 0.025;
Is = 1e-14;

rd = vt/(Is*exp(v_on/vt));

vOrac = nd*rd/(nd*rd+Ro)*(vOe-avgenv);

vOr = vOrdc+vOrac;

theo2=figure();

plot(t*1000,vOr)
title("Output voltage V_O(t)")
ylabel("V")
xlabel("t[ms]")
print(theo2, "theo2.eps", "-depsc");


theo3=figure();

plot(t*1000, vOr-12)
title("Output V_O(t)-12")
ylabel("V")
xlabel("t[ms]")
print(theo3, "theo3.eps", "-depsc");

avgout=mean(vOr);
ripple=max(vOr)-min(vOr);

cost=R/1000+Ro/1000+C*(10^6)+nd*0.1+4*0.1;

merit=1/(cost*(ripple+abs(avgout-12)+10^-6));

tab=fopen("merit_tab.tex","w");

fprintf(tab, "Average Voltage & %f \\\\ \\hline \n", avgout);
fprintf(tab, "Ripple & %f \\\\ \\hline \n", ripple);
fprintf(tab, "Cost & %f \\\\ \\hline \n", cost);
fprintf(tab, "Merit & %f \\\\ \\hline \n", merit);

fclose(tab);
