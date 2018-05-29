;;;; package.lisp

(defpackage #:sysinfo
  (:use #:cl #:cffi)
  (:export
   #:sysinfo
   #:uptime
   #:loads
   #:totalram
   #:freeram
   #:sharedram
   #:bufferram
   #:totalswap
   #:freeswap
   #:procs
   #:totalhigh
   #:freehigh
   #:mem-unit
   #:sysinfo-list
   #:sysinfo-alist))
