close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

%%EXAMPLE NUMERIC COMPUTATIONS
%%Resistors Ohm
R1 = 1.03835624717e3
R2 = 2.03980117275e3
R3 = 3.02589288375e3
R4 = 4.04965870654e3 
R5 = 3.11837790188e3 
R6 = 2.06517135248e3 
R7 = 1.01138577854e3
G1=1/R1
G2=1/R2
G3=1/R3
G4=1/R4
G5=1/R5
G6=1/R6
G7=1/R7
 
%%Voltage and Current Sources
Va = 5.10355691205  %%V
Kb = 7.20092310025e-3  %%S
Kc = 8.24825537187e3 %%Ohm

%%Capacitor
C = 1.0126488524e-6

%%Node analysis of the voltages in the circuit
A = [0, 1, 0, 0, 0, 0, 0, 0; 0, G1, -G1-G2-G3, G2, G3, 0, 0, 0; 0, 0, -G2+Kb, G2, -Kb, 0, 0, 0; 0, 0, 0, 0, 0, 0, G6-G7, G7; 0, 0, 0, 0, 1, 0, -Kc*G6, -1; 0, 0, -Kb, 0, G5+Kb, -G5, 0, 0; 1, 0, 0, 0, 0, 0, 0, 0; 0, -G1, 0, 0, G4, 0, G6, 0]
B = [Va; 0; 0; 0; 0; 0; 0; 0]

a=A\B

b=[(a(3,1)-a(2,1))*G1,(a(4,1)-a(3,1))*G2,(a(3,1)-a(5,1))*G3,(a(5,1)-a(1,1))*G4,(a(6,1)-a(5,1))*G5,(a(7,1)-a(1,1))*G6,(a(8,1)-a(7,1))*G7]

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
D = [1, 0, 0, 0, 0, 0, 0, 0, 0; 0, G1, -G1-G2-G3, G2, G3, 0, 0, 0, 0; 0, 0, -G2+Kb, G2, -Kb, 0, 0, 0, 0; 0, 0, G1, 0, G4, 0, G6, 0, 0; 0, 0, 0, 0, 0, 0, G6+G7, -G7, 0; 0, 0, 0, 0, 1, 0, Kc*G6, -G7, 0; 0, 0, 0, 0, 0, 1, 0, -1, 0; 0, 1, 0, 0, 0, 0, 0, 0, 0; 0, 0, Kb, 0, -Kb+G5, -G5, 0, 0, 1]
E = [0; 0; 0; 0; 0; 0; Vx; 0; 0]

d=D\E

Req=Vx\d(9,1)

tab=fopen("point2_tab.tex","w");

fprintf(tab, "@$I_x$ & %f \\\\ \\hline \n", d(9,1))
fprintf(tab, "$V_x$ & %f \\\\ \\hline \n", Vx)
fprintf(tab, "$R_e_q$ & %f \\\\ \\hline \n", Req)
fclose(tab)

t=0:1e-6:20e-3; %s

Vc=Vx*exp(-t\(Req*C));

cpic = figure ();
plot (t*1000, Vc, "g");


xlabel ("t[ms]");
ylabel ("V_c(t) [V]");
print (cpic, "natural_c.eps", "-depsc");

f=1000
w=2*pi*f;
Zc = 1/(j*w*C)

F = [1, 0, 0, 0, 0, 0, 0, 0; 0, 1, 0, 0, 0, 0, 0, 0; 0, G1, -G1-G2-G3, G2, G3, 0, 0, 0; 0, 0, G2-Kb, -G2, Kb, 0, 0, 0; 0, 0, Kb, 0, -Kb-G5, G5+Zc, 0, -Zc; 0, 0, 0, 0, 0, 0, G6-G7, G7; 0, 0, 0, 0, 1, 0, -Kc*G6, -1; 0, -G1, 0, 0, G4, 0, G6, 0]
G = [0; Va; 0; 0; 0; 0; 0; 0]
f=F\G

tab=fopen("volt_tab4.tex","w");
fprintf(tab, "$V_0$ & %f \\\\ \\hline \n", f(1,1))
fprintf(tab, "$V_1$ & %f \\\\ \\hline \n", f(2,1))
fprintf(tab, "$V_2$ & %f \\\\ \\hline \n", f(3,1))
fprintf(tab, "$V_3$ & %f \\\\ \\hline \n", f(4,1))
fprintf(tab, "$V_5$ & %f \\\\ \\hline \n", f(5,1))
fprintf(tab, "$V_6$ & %f \\\\ \\hline \n", f(6,1))
fprintf(tab, "$V_7$ & %f \\\\ \\hline \n", f(7,1))
fprintf(tab, "$V_8$ & %f \\\\ \\hline \n", f(8,1))
fclose(tab);
