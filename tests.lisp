;;;; tests.lisp

(in-package #:accounting.tests)
;;; "tests" go here. Hacks and glory await!

(setf *print-failures* t
      *print-errors* t
      )
(defparameter +company-name+ "Acme")
(defun new-ledger ()
  (make-account :name +company-name+))
(define-test |Empty Ledger|
  (let ((ledger (new-ledger))
	)
    (assert-equal +company-name+ (name ledger))
    (assert-equal 0 (number-of-subaccounts ledger))
    )
  )
(define-test |Account|
  (let ((account (make-account :name "Cash"))
        (ledger (new-ledger))
        )
    (assert-equal "Cash" (name account))
    (add-account-to-parent :account account :parent ledger)
    (assert-equal 1 (number-of-subaccounts ledger))
    )
  )
