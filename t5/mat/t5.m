C1=220e-9;
C2=110e-9;
R1=1e3;
R2=1e3;
R3=130e3;
R4=1e3;

f=1000;

w=2*pi*f;

Zc1=1/(j*w*C1);
Zc2=1/(j*w*C2);

Zin=abs(Zc1+R1);
Zout=abs(1/(1/R2+1/Zc2));

vp=R1/(R1+Zc1);
amp=(1+R3/R4)*vp;
gain=abs(Zc2/(Zc2+R2)*amp);
gain_db=20*log10(gain);

gain_dev=gain_db-40;

t=1:0.1:8;
w=2*pi*power(10,t);

Zc1=1./(j*w*C1);
Zc2=1./(j*w*C2);

vp=R1./(R1+Zc1);
amp=(1+R3/R4).*vp;
fgain=abs(Zc2./(Zc2+R2).*amp);
fgain_db=20*log10(fgain)

max_gain=max(fgain_db);

x=0;

for i=1:length(fgain_db)
	if (fgain_db(i) >= max_gain-3 && !x)
		lowerCOF=power(10,t(i-1));
		x=1;
	endif
	if (fgain_db(i) <= max_gain-3 && x)
		higherCOF=power(10,t(i-1));
		x=0;
	endif
endfor

central_freq=sqrt(lowerCOF*higherCOF);

theo = figure();
plot (t, fgain_db, "g");
legend("Gain");
xlabel ("log_{10}(f) [Hz]");
ylabel ("dB");
print (theo, "theo.eps", "-depsc");
	
tab=fopen("gain.tex","w");
fprintf(tab, "Gain & %f V \\\\ \\hline \n", gain);
fprintf(tab, "Gain dB & %f dB \\\\ \\hline \n", gain_db);
fprintf(tab, "Central Frequency & %f Hz \\\\ \\hline \n", central_freq);
fprintf(tab, "Lower Cut Off Frequency & %f Hz \\\\ \\hline \n", lowerCOF);
fprintf(tab, "Higher Cut Off Frequency & %f Hz \\\\ \\hline \n", higherCOF);
fprintf(tab, "Gain Deviation & %f dB \\\\ \\hline \n", gain_db-40);
fprintf(tab, "Frequency Deviation & %f Hz \\\\ \\hline \n", abs(central_freq-1000));

fprintf(tab, "Bandwidth & %f Hz \\\\ \\hline \n", higherCOF-lowerCOF);
fclose(tab);	
	
tab=fopen("imp_octave.tex", "w");
fprintf(tab, "Input Impedance & %f Ohm \\\\ \\hline \n", Zin);
fprintf(tab, "Output Impedance & %f Ohm \\\\ \\hline \n", Zout);
fclose(tab);
