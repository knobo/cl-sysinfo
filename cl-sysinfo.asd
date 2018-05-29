;;;; cl-sysinfo.asd

(asdf:defsystem #:cl-sysinfo
  :description "cffi bindings for sysinfo"
  :author "Knut Olav Bøhmer <bohmer@gmail.com>"
  :license  "LLGPL"
  :version "0.0.1"
  :defsystem-depends-on ("cffi-grovel")
  :depends-on ("cffi"
               "local-time-duration")
  :serial t
  :components ((:file "package")
               (:cffi-grovel-file "grovel")
               (:file "sysinfo")))
