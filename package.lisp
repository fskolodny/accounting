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
           #:make-transaction
           #:in-balance
           #:add
           #:post-entry
           #:post-batch
           #:posted
           #:ledger
           #:make-journal
           #:empty
           )
  )
(defpackage #:accounting.tests
  (:use #:cl
        #:accounting
        #:fiveam
        #:wu-decimal
        )
  )

