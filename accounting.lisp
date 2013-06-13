;;;; accounting.lisp

(in-package #:accounting)

;;; "accounting" goes here. Hacks and glory await!

(defclass named-entry ()
  ((name :accessor name :initarg :name)
   )
  )
(defclass account (named-entry)
  ((children :accessor children :initform nil)
   (parent :accessor parent :initform nil)
   )
  )
(defmethod number-of-subaccounts ((account account))
  (length (children account))
  )
(defun make-account (&key name &allow-other-keys)
  (make-instance 'account :name name)
  )
(defun add-account-to-parent (&key account parent)
  (setf (children parent)
        (push account (children parent)))
  )
