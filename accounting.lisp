;;;; accounting.lisp

(in-package #:accounting)

;;; "accounting" goes here. Hacks and glory await!

(defun make-ledger (&key name &allow-other-keys)
  (cons :ledger (list (cons :name name) (list :accounts)))
  )

(defun ledgerp (ledger)
  (eq :ledger (car ledger)))

(defun ledger-name (ledger)
  (if (ledgerp ledger)
      (cdr (assoc :name (cdr ledger))))
  )

(defun add-account (&key ledger account &allow-other-keys)
  (if (and (ledgerp ledger) (accountp account))
      (let ((accounts (or (assoc :accounts (cdr ledger))
			  (setf (cdr ledger) (acons :accounts nil (cdr ledger)))))
	    (name (account-name account))
	    )
	(print accounts)
	(if name
	    (setf accounts (or (assoc name (cdr accounts))
			       (acons name account (cdr accounts)))))))
  )

(defun accountp (account)
  (eq :account (car account)))

(defun account-name (account)
  (if (accountp account)
      (cdr (assoc :name (cdr account))))
  )

(defun make-account (&key name debitp &allow-other-keys)
   (cons :account (list (cons :name name) (cons :debitp debitp)
			(list :entries)))
   )
