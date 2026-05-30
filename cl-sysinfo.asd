;;;; cl-sysinfo.asd

(asdf:defsystem #:cl-sysinfo
  :description "CFFI bindings for the Linux sysinfo(2) syscall"
  :author "Knut Olav Bøhmer <bohmer@gmail.com>"
  :license  "LLGPL"
  :version "0.0.1"
  :defsystem-depends-on ("cffi-grovel")
  :depends-on ("cffi"
               "local-time-duration")
  :serial t
  :components ((:file "package")
               (:cffi-grovel-file "grovel")
               (:file "sysinfo"))
  :in-order-to ((test-op (test-op "cl-sysinfo/test"))))

(asdf:defsystem #:cl-sysinfo/test
  :description "Tests for cl-sysinfo"
  :author "Knut Olav Bøhmer <bohmer@gmail.com>"
  :license "LLGPL"
  :depends-on ("cl-sysinfo"
               "fiveam")
  :components ((:module "test"
                :components ((:file "sysinfo-test"))))
  :perform (test-op (op system)
                    (uiop:symbol-call :sysinfo/test :run-tests)))
