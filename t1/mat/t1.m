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
Id = 1.0126488524e-3  %%A
Kb = 7.20092310025e-3  %%S
Kc = 8.24825537187e3 %%Ohm

%%Mesh analysis of currents in the circuit
A=[R1+R3+R4,-R3,-R4,0;-R3*Kb,R3*Kb-1,0,0;-R4,0,R4+R6+R7-Kc,0;0,0,0,1]
B=[Va;0;0;Id]

a=A\B

%%Node analysis of the voltages in the circuit
C = [G7, 0, 0, 0, 0, 0, G6, 0; 1, -1, 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 1, -1, 0; 0, 0, 0, -G2, G1+G2+G3, -G1, 0, -G3; 0, 0, G5, 0, G3, 0, G4+G6, -G3-G4-G5; 1, 0, 0, 0, 0, 0, Kc*G6, -1; 0, 0, 0, 0, G1, -G1, -G4-G6, G4; 0, 0, 0, -G2, Kb+G2, 0, 0, -Kb]
D = [0; 0; Va; 0; Id; 0; 0; 0]

c=C\D

tab=fopen("current_tab.tex","w");

fprintf(tab, "@$I_x$ & %f \\\\ \\hline \n", a(1,1))
fprintf(tab, "@$I_y$ & %f \\\\ \\hline \n", a(2,1))
fprintf(tab, "@$I_z$ & %f \\\\ \\hline \n", a(3,1))
fprintf(tab, "@$I_w$ & %f \\\\ \\hline \n", a(4,1))
fclose(tab);

tab=fopen("volt_tab.tex","w");
fprintf(tab, "$V_1$ & %f \\\\ \\hline \n", c(6,1))
fprintf(tab, "$V_2$ & %f \\\\ \\hline \n", c(5,1))
fprintf(tab, "$V_3$ & %f \\\\ \\hline \n", c(4,1))
fprintf(tab, "$V_4$ & %f \\\\ \\hline \n", c(7,1))
fprintf(tab, "$V_5$ & %f \\\\ \\hline \n", c(8,1))
fprintf(tab, "$V_6$ & %f \\\\ \\hline \n", c(3,1))
fprintf(tab, "$V_7$ & %f \\\\ \\hline \n", c(1,1))
fprintf(tab, "$V_8$ & %f \\\\ \\hline \n", c(2,1))
fclose(tab);
