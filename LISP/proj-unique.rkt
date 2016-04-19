 
#|///////////////////////////////////////////////////////////////////////////////
# 2) Write a function which uniquely lists all of the input VARIABLES

# Start racket in terminal, run:
 (load "proj-unique.rkt")

# Examples and output: 

 (UNIQUE '(OR (AND A1 A2) 1))
  Output: '(A1 A2 1)
 (UNIQUE '(NOT (AND 0 (OR B C))))
   Output: '(0 B C)
 (UNIQUE '(OR (AND (NOT A1) A2) (AND A1 (NOT (OR (AND A1 A2) 1)))))
   Output: '(A1 A2 1)

///////////////////////////////////////////////////////////////////////////////|#

#| Function 1: Main entry |#
(define (UNIQUE L)
  (remove-dup (flatt L))
)

#| Function 2: Flatten the CD, ommiting the logical operators (AND, OR, NOT) |# 
(define (flatt L)
    (cond ((null? L) '())
          ; come to single variable: return a list containing that variable 
          ((not (pair? L)) (list L))
          ; skip logical operators
          ((eq? 'AND (car L)) (flatt (cdr L)))
          ((eq? 'OR (car L)) (flatt (cdr L)))
          ((eq? 'NOT (car L)) (flatt (cdr L)))
          ; first element of L is a list: flatten that element and the rest  
          (else (append (flatt (car L))
                        (flatt (cdr L))))
    )
)

#| Function 3: Remove duplicates from the list produced by flatten function |#
(define (remove-dup L)
  (cond ((null? L) '())
        ((member (car L) (cdr L)) (remove-dup (cdr L)))
        (else (cons (car L) (remove-dup (cdr L))))
  )
)
 
