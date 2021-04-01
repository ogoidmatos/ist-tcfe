close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

%%EXAMPLE NUMERIC COMPUTATIONS
%%Resistors Ohm
R1 = 1.00119192001e3
R2 = 2.05601051164e3
R3 = 3.14238437911e3
R4 = 4.10348141952e3 
R5 = 3.04851993814e3 
R6 = 2.04484641193e3 
R7 = 1.00542115789e3
%%Voltage and Current Sources
Va = 5.04499704365  %%V
Kb = 7.29043495344e-3  %%S
Kc = 8.08788113416e3 %%Ohm

%%Capacitor
C = 1.01848690215e-6

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
fprintf(tab, "$R_e_q$ & %f \\\\ \\hline \n", Req)
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
0, 0, Kb, 0, -Kb-1/R5, 1/R5+Zc, 0, -Zc;
0, 0, 0, 0, 0, 0, 1/R6-1/R7, 1/R7;
0, 0, 0, 0, 1, 0, -Kc*1/R6, -1;
0, -1/R1, 0, 0, 1/R4, 0, 1/R6, 0]

G = [0; exp(j); 0; 0; 0; 0; 0; 0]
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

Vt=Vc+abs(f(6,1))*sin(w*t+acos(real(f(6,1))/abs(f(6,1))))
Vs=sin(w*t)
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

%%Vc=f(6,1)-f(8,1)
%%Vc=abs(Vc)*sin(
