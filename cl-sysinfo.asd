;;;; cl-sysinfo.asd

(asdf:defsystem #:cl-sysinfo
  :description "CFFI bindings for the Linux sysinfo(2) syscall"
  :long-description "Thin CFFI wrapper around the Linux sysinfo(2) syscall,
exposing uptime, load averages and memory/swap usage as Lisp data."
  :author "Knut Olav Bøhmer <bohmer@gmail.com>"
  :maintainer "Knut Olav Bøhmer <bohmer@gmail.com>"
  :license  "LLGPL"
  :version "0.0.1"
  :homepage "https://github.com/knobo/cl-sysinfo"
  :bug-tracker "https://github.com/knobo/cl-sysinfo/issues"
  :source-control (:git "https://github.com/knobo/cl-sysinfo.git")
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
