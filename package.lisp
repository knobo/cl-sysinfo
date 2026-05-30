;;;; package.lisp

(defpackage #:sysinfo
  (:use #:cl #:cffi)
  (:export
   ;; Queries
   #:sysinfo
   #:sysinfo-list
   #:sysinfo-alist
   #:uptime-duration
   ;; Conditions
   #:sysinfo-error
   #:sysinfo-error-code))
