;;;; tests.lisp

(in-package #:accounting.tests)
;;; "tests" go here. Hacks and glory await!

(setf *print-failures* t
      *print-errors* t
      )
(defparameter +company-name+ "Acme")
(defun new-ledger ()
  (make-ledger :name +company-name+))
(define-test |Empty Ledger|
  (let ((ledger (new-ledger))
        )
    (assert-equal +company-name+ (name ledger))
    (assert-equal 5 (number-of-subaccounts ledger))
    )
  )
(define-test |Account|
  (let* (
         (ledger (new-ledger))
         (assets (account-named ledger "Assets"))
         (account (make-account :name "Cash" :parent assets))
         )
    (assert-equal "Cash" (name account))
    (assert-equal "1" (account-number assets))
    (assert-equal 1 (number-of-subaccounts assets))
    (assert-equal "11" (account-number account))
    (assert-numerical-equal 0 (balance account))
    )
  )
(defun noise-char (c)
  (or (char= c #\ )
      (char= c #\_)
      )
  )
(define-test |Printing|
  (let* (
         (ledger (new-ledger))
         (assets (account-named ledger "Assets"))
         (cash (make-account :name "Cash" :parent assets))
         )
    (assert-equal "1.00" (format nil "~/wu-decimal:$/" 1))
    (assert-equal (format nil "11Cash~%")
                  (remove-if #'noise-char (format nil "~a" cash)))
    )
  )
(define-test |Posting|
  (let* (
         (ledger (new-ledger))
         (assets (account-named ledger "Assets"))
         (cash (make-account :name "Cash" :parent assets))
         (debit-entry (make-account-entry :debitp t
                                          :amount 20
                                          :date (local-time:parse-timestring "2013-06-12T12:00:00")
                                          :legend "Borrow"))
         (credit-entry (make-account-entry :debitp nil
                                           :amount 20
                                           :date (local-time:parse-timestring "2013-07-12T12:00:00")
                                           :legend "Repay"))
         )
    (assert-equal 20
                  (progn
                    (post-entry cash debit-entry)
                    (balance cash)
                    ))
    (assert-equal (format nil "11Cash~%~%2013-06-12Borrow20.00|")
                  (remove-if #'noise-char (format nil "~a" cash)))
    (assert-equal 0
                  (progn
                    (post-entry cash credit-entry)
                    (balance cash)
                    ))
    (assert-equal (format nil "11Cash~%~%2013-06-12Borrow20.00|2013-07-12Repay20.00")
                  (remove-if #'noise-char (format nil "~a" cash)))
    )
  )

