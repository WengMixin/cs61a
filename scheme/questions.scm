(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cdar x) (cdr (car x)))
(define (cddr x) (cdr (cdr x)))

; Some utility functions that you may find useful to implement.

(define (cons-all first rests)
  (map (lambda (x) (if (list? x)  (append (cons first nil) x)x)) rests))

(define (zip pairs)
    (cond 
        ((null? pairs)
            '(()()))
        ((null? (car pairs))  ; if the first list is empty
            nil)          ; then return the empty list 
        (else          ; otherwise
            (cons
                (map (lambda (x) (car x)) pairs)
                (zip (map (lambda (x) (cdr  x)) pairs)))
        )
    )
)

; (zip (map (lambda (x) (cdr  x)) pairs))
(define (map_lst s) (map list s))


(define (zip_two lst1 lst2)
  (cond ((null? lst1)  ; if the first list is empty
         nil)          ; then return the empty list 
        ((null? lst2)  ; if the second list is empty
         nil)          ; then also return the empty list 
        (else          ; otherwise
         (cons (list   ; cons a list with two elements:
                (car lst1)  ; the first from the first list
                (car lst2)) ; and the first from the second list
               (zip_two (cdr lst1) (cdr lst2))))))

(define (comb pairs)
    (if (null? (cdr pairs))
        (append (car pairs) nil)
        (append (car pairs) (comb (cdr pairs)))
    )
)

;; Problem 16
;; Returns a list of two-element lists
(define (enumerate s)
  ; BEGIN PROBLEM 16
  (define (helper s count)
    (if (null? s)
      nil
      (cons (cons count (cons (car s) nil)) (helper (cdr s) (+ count 1)))
    )
  )
  (helper s 0)
)
  ; END PROBLEM 16

;; Problem 17
;; List all ways to make change for TOTAL with DENOMS
(define (list-change total denoms)
  ; BEGIN PROBLEM 17
    (if 
      (= total 0)
        (cons 'nil nil)
        (if 
        (null? denoms)
          nil
          (if 
          (< total 0)
            nil
            (append
              (cons-all (car denoms) (list-change (- total (car denoms)) denoms))
              (list-change total (cdr denoms))
            )
         )
        ) 
    )
  ;###inverted output implement####
  ; (define (lst_partitions n m lst)
  ; (if 
  ;   (= n 0)
  ;     (cons lst nil)
  ;     (if
  ;     (null?  m)
  ;       nil
  ;       (if
  ;       (< n 0)
  ;         nil
  ;         (append
  ;           (lst_partitions (- n (car m)) m (cons (car m) lst))
  ;           (lst_partitions n (cdr m)  lst)
  ;         )
  ;       )
  ;     )
  ;   )
  ; )
  ; (lst_partitions total denoms  nil) 
)
  ; END PROBLEM 17

;; Problem 18
;; Returns a function that checks if an expression is the special form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (let-to-lambda expr)
  (cond ((atom? expr)
         ; BEGIN PROBLEM 18
          expr
         ; END PROBLEM 18
         )
        ((quoted? expr)
         ; BEGIN PROBLEM 18
        (list 'quote (cadr expr))
         ; END PROBLEM 18
         )
        ((or (lambda? expr)
             (define? expr))
         (let ((form   (car expr))
               (params (cadr expr));car cdr expr
               (body   (cddr expr)));cdr cdr expr
           ; BEGIN PROBLEM 18  
           (if (equal? form 'define)
              (if (list? params)
                  (let-to-lambda (list 'define (car params) (let-to-lambda (list 'lambda (cdr params) (car body)))) )
                  (list 'define (let-to-lambda params) (let-to-lambda (car body)))
              )
              (if (null? (cdr body))
                (begin (list 'lambda params (let-to-lambda (car body))))
                (begin (list 'lambda params (let-to-lambda (car body)) (let-to-lambda (cadr body))))
              )
           )
           ; END PROBLEM 18
           ))
        ((let? expr)
         (let ((values (cadr expr))
               (body   (cddr expr)))
           ; BEGIN PROBLEM 18
           (begin  (cons (let-to-lambda (list 'lambda (car (zip values)) (let-to-lambda (car body)))) (map (lambda (x) (let-to-lambda x)) (cadr (zip values)))))
           ; END PROBLEM 18
           ))
        (else
         ; BEGIN PROBLEM 18
         (begin (map (lambda (x) (let-to-lambda x))  expr))
         ; END PROBLEM 18
         )))
