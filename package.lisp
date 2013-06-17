;;;; package.lisp

(defpackage #:accounting
  (:use #:cl
        #:iter
        #:wu-decimal
        #:local-time
        )
  (:export #:name
           #:number-of-subaccounts
           #:make-account
           #:make-ledger
           #:account-number
           #:account-named
           #:balance
           #:make-account-entry
           #:make-batch
           #:hash
           #:post-entry
           #:make-transaction
           #:in-balance
           #:add
           )
  )
(defpackage #:accounting.tests
  (:use #:cl
        #:accounting
        #:lisp-unit
        #:wu-decimal
        )
  )

