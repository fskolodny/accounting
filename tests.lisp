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
    (assert-equal 0 (balance account))
    (assert-true (empty account))
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
    (assert-equal cash (account-named ledger "Cash"))
    (assert-equal (format nil "11Cash~%")
                  (remove-if #'noise-char (format nil "~a" cash)))
    )
  )
(define-test |Posting|
  (let* (
         (ledger (new-ledger))
         (assets (account-named ledger "Assets"))
         (cash (make-account :name "Cash" :parent assets))
         (now (local-time:parse-timestring "2013-06-12T12:00:00"))
         (next-month (local-time:timestamp+ now 1 :month))
         (debit-entry (make-account-entry :debitp t
                                          :amount 20
                                          :date now
                                          :legend "Borrow"))
         (credit-entry (make-account-entry :debitp nil
                                           :amount 20
                                           :date next-month
                                           :legend "Repay"))
         )
    (assert-equal 20
                  (progn
                    (post-entry cash debit-entry)
                    (balance cash)
                    ))
    (assert-error 'error (post-entry cash debit-entry))
    (assert-equal (format nil "11Cash~%~%2013-06-12Borrow20.00|")
                  (remove-if #'noise-char (format nil "~a" cash)))
    (assert-equal 0
                  (progn
                    (post-entry cash credit-entry)
                    (balance cash)
                    ))
    (assert-equal (format nil "11Cash~%~%2013-06-12Borrow20.00|2013-07-12Repay20.00")
                  (remove-if #'noise-char (format nil "~a" cash)))
    (assert-false (empty cash))
    )
  )
(define-test |Batch|
  (let* ((ledger (make-ledger))
         (cash (make-account :name "Cash"
                             :parent (account-named ledger "Assets")))
         (capital (make-account :name "Capital"
                                :parent (account-named ledger "Equity")))
         (now (local-time:parse-timestring "2013-06-12T12:00:00"))
         (batch (make-batch :ledger ledger :legend "Initial investment"
                            :date now))
         (debit-transaction (make-transaction :account "Cash" :debitp t :amount 20))
         (credit-transaction (make-transaction :account "Capital" :debitp nil :amount 20))
         )
    (assert-false (posted batch))
    (assert-equal 0 (hash batch))
    (assert-true (in-balance batch))
    (add :transaction debit-transaction :batch batch)
    (assert-equal 20 (hash batch))
    (assert-false (in-balance batch))
    (assert-error 'error (post-batch batch ledger))
    (assert-error 'error (add :transaction (make-transaction :account "Cash"
                                                             :debitp nil
                                                             :amount 5)
                              :batch batch))
    (add :transaction credit-transaction :batch batch)
    (assert-equal 40 (hash batch))
    (assert-true (in-balance batch))
    (post-batch batch ledger)
    (assert-true (posted batch))
    (assert-equal 20 (balance cash))
    (assert-equal 20 (balance capital))
    )
  )
(define-test |Empty journal|
  (let* ((ledger (make-ledger))
         (journal (make-journal :ledger ledger))
         )
    (assert-true (empty journal))
    (assert-equal ledger (ledger journal))
    )
  )

