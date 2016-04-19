
#|///////////////////////////////////////////////////////////////////////////////
# 1) Write a function which counts the number of times a logical operator is used
     in a a CD
 
# Start racket in terminal, run:
 (load "proj-count.rkt")

# Examples and output: 

(COUNT 'OR '((OR 1 (AND 1 A1))))
 Output: 1
(COUNT 'AND '(OR (AND A1 A2) 1))
 Output: 1
(COUNT 'OR '(NOT (AND 0 (OR B C))))
 Output: 1
(COUNT 'AND '(OR (AND (NOT A1) A2) (AND A1 (NOT (OR (AND A1 A2) 1))))) 
 Output: 3

///////////////////////////////////////////////////////////////////////////////|#

#| Function 1: Main entry |#
(define (COUNT X L)
  (cond
    ; empty list, return 0 
    ((null? L) 0)
    ; first element is not a list and its value equals to X: count + 1
    ((and (not (list? (car L))) (eq? X (car L))) (+ 1 (COUNT X (cdr L))))
    ; first element is a list, just COUNT that list and the rest of the list 
    ((list? (car L)) (+ (COUNT X (car L)) (COUNT X (cdr L))))
    ; otherwise, COUNT the rest of the list 
    (else (COUNT X (cdr L)))
  )
)
 