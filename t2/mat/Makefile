octave.log: t2.m
	octave $< > $@

python: 
	python2 ../t2_datagen.py 95849 > mat/data.txt

clean:
	@rm -f octave.log octave-workspace *.eps *~ *.tex

.PHONY: clean
