;;;; accounting.asd

(asdf:defsystem #:accounting
  :serial t
  :depends-on (#:iterate
               #:local-time
               #:wu-decimal
               #:lisp-unit
              )
  :description "Simple accounting package"
  :author "Fila Kolodny <fskolodny@gmail.com"
  :license "GPL Version 3"
  :components ((:file "package")
               (:file "accounting")
               (:file "tests")
	       ))

