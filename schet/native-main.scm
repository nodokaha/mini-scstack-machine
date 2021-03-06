;;         schet
;; - scheme text editor -
;; (import (scheme base) (scheme file) (scheme read) (scheme write) (scheme repl) (scheme eval))
;;(import (gauche base))
;; (cond-expand (guile (begin (use-modules (ice-9 readline)) (activate-readline)))
;;	     (gauche (import (gauche base))))
(module repl
	(main main))


(define (main x) 
  (display "Hello, editor.\n")
  (if (file-exists? ".tmp") (delete-file ".tmp") #f)
  (close-output-port (open-output-file ".tmp"))
  (repl)
  (newline)
  (begin (if (null? f-r) #t (close-input-port f-r)) (if (null? f-w) #t (close-output-port f-w)))
  (display "Bye\n"))
(define f-r '())
(define f-w '())
(define bracket-mode #f)
(define depth 0)
(define user-input '())
(define count 0)
(define register '())
(define buffer "")
(define (push x) (set! register (append (list x) register)))
;; (define f)
;; (define (capture x) (call/cc (lambda (cc) (set! f cc) (cc x))))
(define (output-safe-read) (let*
			((str (read))
			 (file-name (if (symbol? str) (symbol->string str)  (begin (display "error! set .tmp\n") (delete-file ".tmp") ".tmp"))))
		      (if file-name (if (file-exists? file-name) (begin (display "error! set .tmp\n") (delete-file ".tmp") ".tmp") file-name) (begin (display "error! set .tmp\n") (delete-file ".tmp") ".tmp"))))
(define (input-safe-read) (let*
			((str (read))
			 (file-name (if (symbol? str) (symbol->string str)  (begin (display "error! set .tmp\n") ".tmp"))))
		      (if file-name (if (file-exists? file-name)  file-name (begin (display "error! set .tmp\n") ".tmp")) (begin (display "error! set .tmp\n") ".tmp"))))
(define (repl) (if (not (or (eq? 'exit user-input) (eq? 'q user-input)))
		 (begin (display "f-w:")
		 	(display f-w)
			(newline)
		 	(display "f-r:")
		 	(display f-r)
		 	(newline)
		 	(display "-*-schet-*-")
			(newline)
			(set! user-input (read))
			(command user-input)
			(repl))))
(define (command op)
  (cond
   ;; ((eq? op 'edit) (let
   ;; 		       ((file-name (symbol->string (read))))
   ;; 		     (if (symbol? file-name)
   ;; 			 (if (file-exists?) 
   ((eq? op 'bracket) (set! bracket-mode #t))
   ((eq? op 'help) (map (lambda (x) (display x)(newline)) (list
							   "-*-help text-*-\n"
							   "help: This text."
							   "eval: S-exp eval."
							   "write-buffer: Writing buffer mode."
							   "\n")))
   ;;   ((eq? op 'new) (display "new>\n") (let ((str (read))) (if (symbol? str) (close-output-port (open-output-file (symbol->string str))) (display "Error"))))
   ((eq? op 'eval) (display "-*-eval-*-\n") (display (eval (read) (interaction-environment))) (display "\n"))
   ;;   ((eq? op 'ready-edit) (command 'open-input-file) (command 'copy-buffer) (set! f-w (open-output-string)))
   ((or (eq? op 'write-buffer) (eq? op 'wb)) (set! register (reverse (string->list (get-output-string f-w)))))
   ((or (eq? op 'delete-file) (eq? op 'df)) (display "-*-delete-*-\n") (delete-file (input-safe-read)))
   ((or (eq? op 'read-buffer) (eq? op 'rb)) (display (list->string (reverse register))))
   ((or (eq? op 'copy-buffer) (eq? op 'cb)) (if (null? f-r)
			      (display "please, run. open-input-file\n")
			      (let loop
				  ((i (read-char f-r)))
				(when (not (eof-object? i))
				  (push i) (loop (read-char f-r))))))
   ((or (eq? op 'open-input-file) (eq? op 'er)) (display "-*-read-file-*-\n") (begin (if (null? f-r) #t (close-input-port f-r)) (set! f-r (open-input-file (input-safe-read)))))
   ((or (eq? op 'open-output-file) (eq? op 'ew)) (display "-*-write-file-*-\n") (begin (if (null? f-w) #t (close-output-port f-w)) (set! f-w (open-output-file (output-safe-read)))))
   ((or (eq? op 'open-input-buffer) (eq? op 'eib)) (set! f-r (open-input-string buffer)))
   ((or (eq? op 'open-output-buffer) (eq? op 'eob)) (set! f-w (open-output-string)))
   ((or (eq? op 'save-file) (eq? op 'sf)) (display "-*-save-file-*-\n") (call-with-output-file (output-safe-read) (lambda (file) (display (list->string (reverse register)) file))))
   ((or (eq? op 'finish-write) (eq? op 'ex)) (close-output-port f-w) (set! f-w '()))
   ((or (eq? op 'read-all) (eq? op 'ht)) (if (null? f-r)
					     (display "please, run. open-input-file\n")
					     (let loop
						 ((i (read-char f-r)))
					       (when (not (eof-object? i))
						 (display i) (loop (read-char f-r))))))
   ((or (eq? op 'write) (eq? op 'i)) (display "-*-write-*- (end key is Ctrl and d (C-d) (linux) or Ctrl and z (C-z) after return)\n") (read-char)
    (if (null? f-w)
	(display "please, run. open-output-file\n")
	(begin (let loop ((i (read-char))) (when (not (eof-object? i)) (write-char i f-w) (loop (read-char)))))))
   ((eof-object? op) (set! count (+ 1 count)) (if (>= count 3) (begin (set! count 0) (display "\nIf you want to exit, please type \"exit\".\n")) (display "\n")))))


