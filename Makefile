scheme=guile

run.scm:
	cat 01main.scm 0[2-9]*.scm > run.scm

repl:
	${scheme} -l ./01main.scm

run: run.scm
	${scheme} run.scm

schet-native:
	bigloo schet/native-main.scm -o schet/schet

racket-schet:
	raco exe -o schet/rschet schet/racket-main.scm 

racket-schet-win:
	raco cross --target x86_64-win32 exe -o schet/rschet.exe --embed-dlls schet/racket-main.scm 

dep:
	raco install raco-cross
	raco cross --target x86_64-win32 pkg install r7rs

clean:
	rm -f run.scm schet/schet schet/rschet*
