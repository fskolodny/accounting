;;;; accounting.asd

(asdf:defsystem #:accounting
  :serial t
  :depends-on (#:iterate
               #:local-time
               #:wu-decimal
               #:fiveam
              )
  :description "Simple accounting package"
  :depends-on ()
  :author "Fila Kolodny <fskolodny@gmail.com"
  :license "GPL Version 3"
  :components ((:file "package")
               (:file "accounting")
               (:file "tests")
	       ))

