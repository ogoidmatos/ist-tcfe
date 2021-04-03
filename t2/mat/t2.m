close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

import=dlmread("../data.txt");

%%EXAMPLE NUMERIC COMPUTATIONS
%%Resistors Ohm
R1 = import(3,4)*1000
R2 = import(4,3)*1000
R3 = import(5,3)*1000
R4 = import(6,3)*1000
R5 = import(7,3)*1000 
R6 = import(8,3)*1000 
R7 = import(9,3)*1000
%%Voltage and Current Sources
Va = import(10,3)  %%V
Kb = import(12,3)*0.001  %%S
Kc = import(13,3)*1000 %%Ohm

%%Capacitor
C = import(11,3)*0.000001

%%Node analysis of the voltages in the circuit
A = [0, 1, 0, 0, 0, 0, 0, 0;
0, 1/R1, -1/R1-1/R2-1/R3, 1/R2, 1/R3, 0, 0, 0;
0, 0, 1/R2+Kb, -1/R2, -Kb, 0, 0, 0;
0, 0, 0, 0, 0, 0, -1/R6-1/R7, 1/R7;
0, 0, 0, 0, 1, 0, Kc*1/R6, -1;
0, 0, -Kb, 0, 1/R5+Kb, -1/R5, 0, 0;
1, 0, 0, 0, 0, 0, 0, 0;
0, 0, 1/R3, 0, -1/R3-1/R4-1/R5, 1/R5, 1/R7, -1/R7]
B = [Va; 0; 0; 0; 0; 0; 0; 0]

a=A\B

b=[(a(3,1)-a(2,1))*1/R1,(a(4,1)-a(3,1))*1/R2,(a(3,1)-a(5,1))*1/R3,(a(5,1)-a(1,1))*1/R4,(a(6,1)-a(5,1))*1/R5,(a(7,1)-a(1,1))*1/R6,(a(8,1)-a(7,1))*1/R7]

tab=fopen("volt_tab1.tex","w");
fprintf(tab, "$V_0$ & %f \\\\ \\hline \n", a(1,1))
fprintf(tab, "$V_1$ & %f \\\\ \\hline \n", a(2,1))
fprintf(tab, "$V_2$ & %f \\\\ \\hline \n", a(3,1))
fprintf(tab, "$V_3$ & %f \\\\ \\hline \n", a(4,1))
fprintf(tab, "$V_5$ & %f \\\\ \\hline \n", a(5,1))
fprintf(tab, "$V_6$ & %f \\\\ \\hline \n", a(6,1))
fprintf(tab, "$V_7$ & %f \\\\ \\hline \n", a(7,1))
fprintf(tab, "$V_8$ & %f \\\\ \\hline \n", a(8,1))
fclose(tab);

tab=fopen("current_tab1.tex","w");

fprintf(tab, "@$I_1$ & %f \\\\ \\hline \n", b(1))
fprintf(tab, "@$I_2$ & %f \\\\ \\hline \n", b(2))
fprintf(tab, "@$I_3$ & %f \\\\ \\hline \n", b(3))
fprintf(tab, "@$I_4$ & %f \\\\ \\hline \n", b(4))
fprintf(tab, "@$I_5$ & %f \\\\ \\hline \n", b(5))
fprintf(tab, "@$I_6$ & %f \\\\ \\hline \n", b(6))
fprintf(tab, "@$I_7$ & %f \\\\ \\hline \n", b(7))
fclose(tab);

Vx=a(6,1)-a(8,1)
D = [1, 0, 0, 0, 0, 0, 0, 0, 0; 0, 1/R1, -1/R1-1/R2-1/R3, 1/R2, 1/R3, 0, 0, 0, 0; 0, 0, -1/R2+Kb, 1/R2, -Kb, 0, 0, 0, 0; 0, 0, 1/R1, 0, 1/R4, 0, 1/R6, 0, 0; 0, 0, 0, 0, 0, 0, 1/R6+1/R7, -1/R7, 0; 0, 0, 0, 0, 1, 0, Kc*1/R6, -1/R7, 0; 0, 0, 0, 0, 0, 1, 0, -1, 0; 0, 1, 0, 0, 0, 0, 0, 0, 0; 0, 0, Kb, 0, -Kb+1/R5, -1/R5, 0, 0, 1]
E = [0; 0; 0; 0; 0; 0; Vx; 0; 0]

d=D\E

Req=Vx/d(9,1)

tab=fopen("point2_tab.tex","w");

fprintf(tab, "@$I_x$ & %f \\\\ \\hline \n", d(9,1))
fprintf(tab, "$V_x$ & %f \\\\ \\hline \n", Vx)
fprintf(tab, "$R_eq$ & %f \\\\ \\hline \n", Req)
fclose(tab)

t=0:1e-6:20e-3; %s

Vc=Vx*exp(-t/(Req*C));

cpic = figure ();
plot (t*1000, Vc, "g");


xlabel ("t[ms]");
ylabel ("V_c(t) [V]");
print (cpic, "natural_c.eps", "-depsc");

f=1000
w=2*pi*f;
Zc = 1/(j*w*C)

F = [1, 0, 0, 0, 0, 0, 0, 0;
0, 1, 0, 0, 0, 0, 0, 0;
0, 1/R1, -1/R1-1/R2-1/R3, 1/R2, 1/R3, 0, 0, 0;
0, 0, 1/R2-Kb, -1/R2, Kb, 0, 0, 0;
0, 0, Kb, 0, -Kb-1/R5, 1/R5+1/Zc, 0, -1/Zc;
0, 0, 0, 0, 0, 0, 1/R6-1/R7, 1/R7;
0, 0, 0, 0, 1, 0, -Kc*1/R6, -1;
0, -1/R1, 0, 0, 1/R4, 0, 1/R6, 0]

G = [0; exp(-j); 0; 0; 0; 0; 0; 0]
f=F\G

tab=fopen("volt_tab4.tex","w");
fprintf(tab, "$V_0$ & %f+%fi \\\\ \\hline \n", real(f(1,1)), imag(f(1,1)))
fprintf(tab, "$V_1$ & %f+%fi \\\\ \\hline \n", real(f(2,1)), imag(f(2,1)))
fprintf(tab, "$V_2$ & %f+%fi \\\\ \\hline \n", real(f(3,1)), imag(f(3,1)))
fprintf(tab, "$V_3$ & %f+%fi \\\\ \\hline \n", real(f(4,1)), imag(f(4,1)))
fprintf(tab, "$V_5$ & %f+%fi \\\\ \\hline \n", real(f(5,1)), imag(f(5,1)))
fprintf(tab, "$V_6$ & %f+%fi \\\\ \\hline \n", real(f(6,1)), imag(f(6,1)))
fprintf(tab, "$V_7$ & %f+%fi \\\\ \\hline \n", real(f(7,1)), imag(f(7,1)))
fprintf(tab, "$V_8$ & %f+%fi \\\\ \\hline \n", real(f(8,1)), imag(f(8,1)))
fclose(tab);

Vt=Vc+abs(f(6,1))*cos(w*t+acos(real(f(6,1))/abs(f(6,1))));
%%Vt=Vc+abs(f(6,1))*sin(w*t-pi);

Vs=sin(w*t);
t1=-5e-3:5e-5:0;

theo_4 = figure ();
plot (t*1000, Vt, "b");
hold on;
plot (t1*1000, Vx, "b");
plot (t*1000, Vs, "r");
plot (t1*1000, Va, "r");

xlabel ("t[ms]");
ylabel ("V_t(t)/V_s(t) [V]");
print (theo_4, "theo_4.eps", "-depsc");

fz=-1:0.1:6
Zc=1./(j*2*pi*power(10,fz)*C);
V8 = R7*(1./R1+1./R6)*f(7,1);
V6 = ((1./R5+Kb)*f(5,1)-Kb*f(3,1)+(V8./Zc))./(1./R5 + 1./Zc);
Vc = V6 - V8;
Vs = exp(j*pi/2) + 0*(2*pi*power(10,fz));

%%Vc=1./(sqrt(1+(2*pi*fz).^2*Req.^2*C.^2));
%%Vc=1./(1+j*2*pi*power(10,fz)*C*Req);
%%Vc=abs(Vc);


theo_5 = figure ();
plot (fz, 20*log10(abs(Vc)), "y");
hold on;
plot (fz, 20*log10(abs(V6)), "b");
plot (fz, 20*log10(abs(Vs)), "r");
xlabel ("log_{10}(f) [Hz]");
ylabel ("v_c(f), v_6(f), v_s(f) [dB]");
print (theo_5, "theo_5.eps" ,"-depsc");



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Export files to ngspice

file=fopen("ngspice1.cir","w");
fprintf(file,".OP\nVa 1 0 %f\nCd 6 8 %fu\nRr1 1 2 %f\nRr2 3 2 %f\nRr3 2 5 %f\nRr4 5 0 %f\nRr5 5 6 %f\nRr6 9 7 %f\nRr7 7 8 %f\nVdu 0 9 0\nHvc 5 8 Vdu %f\nGib 6 3 (2,5) %fm\n.END\n", Va, import(11,3), R1, R2, R3, R4, R5, R6, R7, Kc, import(12,3));
fclose(file);

file=fopen("ngspice2.cir","w");
fprintf(file,".OP\nVa 1 0 0\nVd 6 8 %f\nRr1 1 2 %f\nRr2 3 2 %f\nRr3 2 5 %f\nRr4 5 0 %f\nRr5 5 6 %f\nRr6 9 7 %f\nRr7 7 8 %f\nVdu 0 9 0\nHvc 5 8 Vdu %f\nGib 6 3 (2,5) %fm\n.END\n", Vx, R1, R2, R3, R4, R5, R6, R7, Kc, import(12,3));
fclose(file);

file=fopen("ngspice3.cir","w");
fprintf(file,".OP\nVa 1 0 0\nCd 6 8 %fu\nRr1 1 2 %f\nRr2 3 2 %f\nRr3 2 5 %f\nRr4 5 0 %f\nRr5 5 6 %f\nRr6 9 7 %f\nRr7 7 8 %f\nVdu 0 9 0\nHvc 5 8 Vdu %f\nGib 6 3 (2,5) %fm\n.IC v(6)=%f v(8)=%f\n.END\n", import(11,3), R1, R2, R3, R4, R5, R6, R7, Kc, import(12,3), a(6,1), a(8,1));
fclose(file);

file=fopen("ngspice4.cir","w");
fprintf(file,".OP\nVa 1 0 0.0 ac 1.0 sin(0 1 1000)\nCd 6 8 %fu\nRr1 1 2 %f\nRr2 3 2 %f\nRr3 2 5 %f\nRr4 5 0 %f\nRr5 5 6 %f\nRr6 9 7 %f\nRr7 7 8 %f\nVdu 0 9 0\nHvc 5 8 Vdu %f\nGib 6 3 (2,5) %fm\n.IC v(6)=%f v(8)=%f\n.END\n", import(11,3), R1, R2, R3, R4, R5, R6, R7, Kc, import(12,3), a(6,1), a(8,1));
fclose(file);
