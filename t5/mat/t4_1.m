%gain stage

VT=25e-3
BFN=178.7
VAFN=69.7
RE1=200
RC1=700
RB1=85000
RB2=20000
VBEON=0.7
VCC=12
RS=100
c1 = 16.25e-6;
c2 = 5e-3;
c3 = 3e-3;
Load=8;


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

RSB=RB*RS/(RB+RS);

AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);
AV1_DB = 20*log10(abs(AV1));
AV1simple = RB/(RB+RS) * gm1*RC1/(1+gm1*RE1);
AV1simple_DB = 20*log10(abs(AV1simple));

RE1=0;
AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);
AV1_DB = 20*log10(abs(AV1));
AV1simple =  RSB/RS * gm1*RC1/(1+gm1*RE1);
AV1simple_DB = 20*log10(abs(AV1simple));

RE1=200
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)));

ZX = ro1*(1/RE1+1/(rpi1+RSB)+1/ro1+gm1*rpi1/(rpi1+RSB))/(1/RE1+1/(rpi1+RSB));
ZO1 = 1/(1/ZX+1/RC1);

RE1=0
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)));
ZO1 = 1/(1/ro1+1/RC1);


tab=fopen("gain.tex","w");

fprintf(tab, "Gain DB & %fdB \\\\ \\hline \n", AV1simple_DB);
fprintf(tab, "Gain & %f \\\\ \\hline \n", AV1simple);
fprintf(tab, "Input Impedance & %f Ohm \\\\ \\hline \n", ZI1);
fprintf(tab, "Output Impedance & %f Ohm \\\\ \\hline \n", ZO1);

fclose(tab);


%ouput stage
BFP = 227.3
VAFP = 37.2
RE2 = 200
VEBON = 0.7
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2

AV2 = gm2/(gm2+gpi2+go2+ge2)
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)
ZO2 = 1/(gm2+gpi2+go2+ge2)

tab=fopen("output.tex","w");
fprintf(tab, "Gain & %f \\\\ \\hline \n", AV2);
fprintf(tab, "Input Impedance & %f Ohm \\\\ \\hline \n", ZI2);
fprintf(tab, "Output Impedance & %f Ohm \\\\ \\hline \n", ZO2);

fclose(tab);

%total
gB = 1/(1/gpi2+ZO1);
AV = -(gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1;
AV_DB = 20*log10(abs(AV));
ZI=ZI1;
ZO=1/(go2+gm2/gpi2*gB+ge2+gB);


RE1=137;
%Lower CutOff Freq
R1S = RS + (1/(1/RB + 1/rpi1));
R2S = Load + (1/(1/RC1 + 1/ro1));
R3S = 1/((1/RE1) + (1/(rpi1 + (1/(1/RS + 1/RB)))) + ((gm1*rpi1)/(rpi1 + (1/(1/RS + 1/RB)))));
wL = 1/(R1S*c1) + 1/(R2S*c2) + 1/(R3S*c3);
LowerFreq = wL/(2*pi);

%Higher CutOff Freq
Cpi = 16.1e-12;  %Valores retirados do modelo do ngspice
Co = 4.388e-12;
wH = 1/(Cpi*rpi1 + Co*ro1);
HigherFreq = wH/(2*pi);
band=HigherFreq-LowerFreq;

tab=fopen("total.tex","w");

fprintf(tab, "Gain DB & %fdB \\\\ \\hline \n", AV_DB);
fprintf(tab, "Gain & %f \\\\ \\hline \n", AV);
fprintf(tab, "Lower Cutoff Frequency & %f Hz \\\\ \\hline \n", LowerFreq);
fprintf(tab, "Higher Cutoff Frequency & %f Hz \\\\ \\hline \n", HigherFreq);
fprintf(tab, "Bandwidth & %f Hz \\\\ \\hline \n", band);
fprintf(tab, "Input Impedance & %f Ohm \\\\ \\hline \n", ZI);
fprintf(tab, "Output Impedance & %f Ohm \\\\ \\hline \n", ZO);
fclose(tab);

qualidade=band*AV/LowerFreq;
custo=8122.45;
merito=qualidade/custo;

tab=fopen("octave_merit.tex","w");

fprintf(tab, "Quality & %f \\\\ \\hline \n", qualidade);
fprintf(tab, "Cost & %f \\\\ \\hline \n", custo);
fprintf(tab, "Merit & %f \\\\ \\hline \n", merito);
fclose(tab);



vin=0.01;
Rpi2 = 1/ gpi2;
Ro2 = 1 / go2;
gain=[];
gain_DB=[];
i=1;

for t=1:0.1:8
	w=2*pi*power(10,t);
	Zc1 = 1 ./(j*w*c1);
	Zc2 = 1 ./(j*w*c2);
	Zc3 = 1 ./(j*w*c3);
	ZRe_C1=1/(1/RE1+1/Zc2);
	%ZRe2_Ro2=1/(1/Ro2+1/RE2);
	Zeq=1/(1/RE2+1/(Load+Zc3));
	
	A=[RS+Zc1+RB,-RB,0,0,0,0,0;
	-RB,RB+rpi1+ZRe_C1,0,-ZRe_C1,0,0,0;
	0,rpi1*gm1,1,0,0,0,0;
	0,-ZRe_C1,-ro1,ZRe_C1+ro1+RC1,-RC1,0,0;
	0,0,0,-RC1,Rpi2+RC1+Zeq,0,-Zeq;
	0,0,0,0,Rpi2*gm2,1,0;
	0,0,0,0,-Zeq,-Ro2,Zeq+Ro2;
	];

	B=[vin;0;0;0;0;0;0];
	
	X=A\B;
	Vout=(X(7)-X(5))*Zeq;
	
	gain(i)=Vout*Load/(Load+Zc3)/vin;
	gain_DB(i)=20*log10(abs(gain(i)));
	i=i+1;
endfor

gain_DB
t=1:0.1:8;
theo = figure();
plot (t, gain_DB, "g");
legend("Gain");
xlabel ("log_{10}(f) [Hz]");
ylabel ("V");
print (theo, "theo.eps", "-depsc");
