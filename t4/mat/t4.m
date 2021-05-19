%gain stage
format long

VT=25e-3;
BFN=178.7;
VAFN=69.7;
RE1=100;
RC1=1000;
RB1=80000;
RB2=20000;
VBEON=0.7;
VCC=12;
RS=100;
c1 = 0.001;
c2 = 0.001;
c3 = 10^-6;

RB=1/(1/RB1+1/RB2);
VEQ=RB2/(RB1+RB2)*VCC;
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1);
IC1=BFN*IB1;
IE1=(1+BFN)*IB1;
VE1=RE1*IE1;
VO1=VCC-RC1*IC1;
VCE=VO1-VE1;


gm1=IC1/VT;
rpi1=BFN/gm1;
ro1=VAFN/IC1;

AV1 = RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);

AV1simple = gm1*RC1/(1+gm1*RE1);

RE1=0;
AV1 = RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);
AV1simple = gm1*RC1/(1+gm1*RE1);

RE1=100;

ZI1 = ((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1);

ZX = ro1*((RB+rpi1)*RE1/(RB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RB)+1/RE1+gm1*rpi1/(rpi1+RB)));

ZO1 = 1/(1/ZX+1/RC1);

tab=fopen("gain.tex","w");

fprintf(tab, "Gain & %f \\\\ \\hline \n", AV1simple);
fprintf(tab, "Input Impedance & %fk \\\\ \\hline \n", ZI1/1000);
fprintf(tab, "Output Impedance & %f \\\\ \\hline \n", ZO1);

fclose(tab);


%ouput stage
BFP = 227.3;
VAFP = 37.2;
RE2 = 100;
VEBON = 0.7;
VI2 = VO1;

IE2 = (VCC-VEBON-VI2)/RE2;
IC2 = BFP/(BFP+1)*IE2;
VO2 = VCC - RE2*IE2;


gm2 = IC2/VT;
go2 = IC2/VAFP;
gpi2 = gm2/BFP;
ge2 = 1/RE2;

AV2 = gm2/(gm2+gpi2+go2+ge2);

ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2);

ZO2 = 1/(gm2+gpi2+go2+ge2);


vin=0.01;
Rpi2 = 1/ gpi2;
Ro2 = 1 / go2;
Load=8;


%Ib Ic Id Ie
for t=1:0.1:8

	Zc1 = 1 ./(j* power(10,t) * 2 * pi * c1);
	Zc2 = 1 ./(j* power(10,t) * 2 * pi * c2);

	A = [RS + Zc1 + RB + rpi1 + RE1, 0, 0, -RE1;
	-RE1, 0, -Zc2, RE1 + Zc2;
	gm1 * rpi1, 1, 0, 0;
	0, -ro1, ro1 + RC1 + Zc2, -Zc2]; 

	B = [vin; 0; 0; 0];
	x=A\B;

	gain = - x(3) * RC1 / vin; 

	Vin2 = x(3) * RC1;

	%Ib Ic Id

	Zc3 = 1 ./(j* power(10,t) * 2 * pi * c3);

	C = [Rpi2 + RE2, 0, -RE2;
	-gm2 * Rpi2, 1, 0;
	-RE2, -Ro2, RE2 + Ro2 + Zc3 + Load];

	D = [Vin2; 0; 0];

	y= C\D;

	gain2 = (y(3)-y(1)) * RE2 / Vin2;

	%Ib Ic Id Ie

	E = [ rpi1 + RE1, 0, 0, -RE1;
	-RE1, 0, -Zc3 - Load, RE1 + Zc2 + Load;
	gm1 * rpi1, 1, 0, 0;
	0, -ro1, ro1+ Load + Zc3, -Zc3 - Load]; 

	F = [Vin2; 0; 0; 0];
	z=E\F;

	gain3 = (z(4)-z(1)) * RE2 / Vin2;
endfor





tab=fopen("output.tex","w");

fprintf(tab, "Gain & %f \\\\ \\hline \n", AV2);
fprintf(tab, "Input Impedance & %fk \\\\ \\hline \n", ZI2/1000);
fprintf(tab, "Output Impedance & %f \\\\ \\hline \n", ZO2);

fclose(tab);
