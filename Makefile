scheme=guile

run.scm:
	cat 01main.scm 0[2-9]*.scm > run.scm

run: run.scm
	${scheme} run.scm

clean:
	rm run.scm
