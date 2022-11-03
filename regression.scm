;; step 5 - LITERALS
(check-type 3 int)
(check-type #t bool)
(check-type 'hello sym)

;; step 6 - IFEXP
(check-type (if #t 3 4) int)
(check-type (if #f #t #f) bool)
(check-type-error (if #t 3 #f))
(check-type-error (if 3 #t #f))

;; step 7 - VAR
(check-type + (int int -> int))
(check-type cons (forall ['a] ('a (list 'a) -> (list 'a))))
(check-type-error (VAR _))

;; step 9 - VAL / EXP
(val louis +)
(val brett cons)
(val brettint 5)
(check-type brettint int)
(check-type louis (int int -> int))
(check-type brett (forall ['a] ('a (list 'a) -> (list 'a))))
(check-type-error not_brett)

;; step 10 - APPLY
(check-type (+ 3 4) int)
(check-type ((if #t + -) 3 5) int)
(check-type ([@ cons int] 5 '(6)) (list int))
(check-type (- 7 (+ 3 4)) int)
(check-type-error ((if #f + 3) 3 5))
(check-type-error (+ 1 #t)) 

;; step 11 - LET
(check-type (let ((x 3) (y 3)) x) int)
(check-type (let ((x 3) (y 3)) (* x y)) int)
(check-type-error (let ((x 4)) y))

;; step 12 - LAMBDA
(check-type (lambda ([x : int] [y : int]) (if #t x y)) (int int -> int))
(check-type (lambda ([x : int] [y : int]) (+ x y)) (int int -> int))
(check-type-error (lambda ([x : int] [y : bool]) (if #t x y)))
(check-type-error (lambda ([x : int] [y : sym]) (+ x y)))

;; step 13 - SET, WHILE, BEGIN
(val brettset 0)
(val louisset 'abc)
(check-type (set brettset 9) int)
(check-type (set louisset 'xyz) sym)
(check-type-error (set brettset louisset))

(check-type (while #t (+ 3 4)) unit)
(check-type (while #f (if #t #t #f)) unit)
(check-type-error (while 3 (- 4 1)))

(check-type (begin) unit)
(check-type (begin (+ 3 4) (- 5 1)) int)
(check-type (begin (+ 3 4) (if #t 'abc 'xyz)) sym)
(check-type-error (begin (set brettset louisset)))

;; step 14 - LETSTAR
(check-type (let* [] (+ 3 4)) int)
(check-type (let* ((x 3) (y 3)) (+ x y)) int)
(check-type-error (let* ((x 5) (y #t)) (+ x y)))

;; step 15 - LETREC
(check-type
    (letrec ([(plus : (int int -> int)) (lambda ([a : int] [b : int]) (+ a b))]
             [(minus : (int int -> int)) (lambda ([a : int] [b : int]) (- a b))]
            ) 
            (minus 7 (plus 3 4))
    )
int)

(check-type-error
    (letrec ([(double : (int -> int)) 3]) (double 3)))

(check-type
    (letrec ([(double : (int -> int)) (lambda ([a : int]) (* a 2))]) (double 3))
int)

;; step 16 - VALREC, DEFINE
(define int functionname ([x : int]) (+ x 3))
(define int functionname2 ([x : int] [y : int]) (* x y))
(check-type functionname (int -> int))
(check-type functionname2 (int int -> int))
(check-type-error (lambda ([a : int] [b : sym]) (+ a b)))

;; step 17 - TYAPPLY, TYLAMBDA
(check-type ([@ cons int] 5 '(6)) (list int))
(check-type ([@ = int] 5 5) bool)
(check-type-error ([@ = faketype] 5 5))

(val equals?
    (type-lambda ('a)
        (lambda ([x : 'a] [y : 'a])
            ([@ = 'a] x y))))
(check-type equals?  (forall ['a] ('a 'a -> bool)))
(check-type-error (type-lambda ('a 'b)
                    (lambda ([x : 'a] [y : 'b])
                        ([@ = 'a] x y))) )

;; step 18 - LITERAL(PAIR), LITERAL(NIL)
(check-type '(a b c d e f g h) (list sym))
(check-type '(1) (list int))
(check-type ([@ cons int] 5 '(6 7 8)) (list int))
(check-type '() (forall ['a] (list 'a)))
(check-type-error ([@ cons int] 5 '()))
(check-type-error ([@ cons sym] 5 '(a)))