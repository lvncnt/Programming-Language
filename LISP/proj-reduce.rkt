
#|///////////////////////////////////////////////////////////////////////////////
# 3) Write a function that given a CD, reduces, the CD to a simpler form
     by using tautologies.

# Start racket in terminal, run:
 (load "proj-reduce.rkt")

# Working Examples and output: 
(REDUCE '(AND X 1))                              => 'X
(REDUCE '(AND X (AND 1 X)))                      => '(and X X)
(REDUCE '(AND (AND 1 A1) (AND A2 1)))            => '(and A1 A2)
(REDUCE '(AND 1 (AND A1 A2) ))                   => '(and A1 A2)

(REDUCE '(OR X 1))                               => 1
(REDUCE '(OR (AND A1 A2) 1))                     => 1
(REDUCE '(OR 0 (AND A1 A2)))                     => '(and A1 A2)
(REDUCE '(OR (AND A1 0) (AND A1 A2)))            => '(and A1 A2)
(REDUCE '(OR (AND A1 0) (AND A1 1)))             => 'A1

(REDUCE '(NOT (OR (AND A1 A2) 1)))               => 0
(REDUCE '(NOT (OR (AND A1 0) (AND A1 A2))))      => '(not (and A1 A2))
(REDUCE '(OR (AND A1 0) (NOT (AND A1 1))))       => '(not A1)
(REDUCE '(OR (NOT (AND A1 0)) (AND A1 1)))       => 1
(REDUCE '(OR (NOT (NOT (AND A1 0))) (AND A1 1))) => 'A1
(REDUCE '(OR (NOT (NOT (AND A1 0))) (AND A1 (OR (NOT (AND A1 0)) (AND A1 1)))))
                                                 => 'A1

///////////////////////////////////////////////////////////////////////////////|#

#| Function 1: Returns true if X is of type atom |# 
(define (atom? X)
  (and (not (null? X)) (not (pair? X)))
)

#| Function 2: Main entry |#
(define (REDUCE L)
  (REDUCE-L null L)
)

#| Function 3: Recursively reduce L2 until L2 is atomic or L1 equals L2 |#
(define (REDUCE-L L1 L2)
  (cond
    ((or (atom? L2) (equal? L1 L2)) L2)
    (else (REDUCE-L L2 (REDUCE-CD L2)))
  )
)

#| Function 4: Reduce CD, depending on its first logical operator |#
(define (REDUCE-CD L)
(cond
  ; Reduce AND descriptor (descriptor whose first logical operator is AND)
  ((or (eq? 'and (car L)) (eq? 'AND (car L))) (REDUCE-AND (cdr L)))
  ; Reduce OR descriptor
  ((or (eq? 'or (car L)) (eq? 'OR (car L))) (REDUCE-OR (cdr L)))
  ; Reduce NOT descriptor
  ((or (eq? 'not (car L)) (eq? 'NOT (car L))) (REDUCE-NOT (cdr L)))
)
)

#| Function 5: Reduce AND descriptor |#
(define (REDUCE-AND L)
(cond
  ((null? L) '())  
  ; (AND 0 S) == 0
  ((member '0 L) '0)
  ; (AND 1 S) == S if S is of type atom 
  ((and (eq? (car L) '1)  (atom? (car (reverse L)))) (car (reverse L)))
  ((and (eq? (car (reverse L)) '1) (atom? (car L))) (car L))  
  ; If S is a list and L contains 1, then only need to process S 
  ((eq? (car L) '1) (REDUCE-L null (second L)))
  ((and (eq? (car (reverse L)) '1) (REDUCE-L null (car L))))  
  ; Otherwise recursively reduce operand L  
  (else (cons 'and (REDUCE-OP L)))
)
)

#| Function 6: Reduce OR descriptor |#
(define  (REDUCE-OR L)
(cond
  ((null? L) '())
  ; (OR 1 S ) == S
  ((member '1 L) '1)
  ; (OR 0 S) == S if S is of type atom
  ((and (eq? (car L) '0)  (atom? (car (reverse L)))) (car (reverse L)))
  ((and (eq? (car (reverse L)) '0) (atom? (car L))) (car L)) 
  ; If S is a list and L contains 0, then only need to process S 
  ((eq? (car L) '0)  (REDUCE-L null (second L)))
  ((and (eq? (car (reverse L)) '0) (REDUCE-L null (car L))))
  ; Otherwise recursively reduce operand L
  (else (cons `or (REDUCE-OP L)))
)
)

#| Function 7: Reduce NOT descriptor  |#
(define (REDUCE-NOT L)
  (cond
    ; (NOT O) == 1 (NOT 1) == 0 
    ((eq? (car L) '0) '1)
    ((eq? (car L) '1) '0)
    (else (cons 'not (REDUCE-OP L)))
  )
)

#| Function 8: Reduce operands recursively |#
(define (REDUCE-OP L)
  (cond  
    ((null? L) '())
    ; If first element of L is atom, reduce the rest of L 
    ((atom? (car L)) (cons (car L) (REDUCE-OP (cdr L))))
    ; If first element of L is list, reduce both the first and the rest of L 
    (else (cons (REDUCE-L null (car L)) (REDUCE-OP (cdr L))))
  )
)
