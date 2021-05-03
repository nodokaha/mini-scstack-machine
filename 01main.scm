(define buffer '())
(define (push a) (set! buffer (append (list a) buffer)))
(define (pop) (let ((a (car buffer))) (begin (set! buffer (cdr buffer)) a)))
(define (number-sequence a) (if (< a 1) (list a) (append (list a) (number-sequence (- a 1)))))
(define (add) (push (+ (pop) (pop))))
(define (sub) (let ((a (car buffer)) (b (cadr buffer))) (begin (pop) (pop) (push (- b a)))))
(define (fib-buffer) (begin (push (cadr buffer)) (push (+ (pop) (car buffer)))))
(define (type-check) (cond ((number? (car buffer)) (display "current is Number")) ((string? (car buffer)) (display "current is String"))))
