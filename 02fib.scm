(push 0)
(push 1)
(let loop ((i 0)) (begin (fib-buffer) (if (= i 10) #t (loop (+ i 1)))))
(display buffer)
