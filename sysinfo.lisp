;;;; sysinfo.lisp

(in-package #:sysinfo)

(defcfun (c-sysinfo "sysinfo") :int
  (info (:pointer (:struct sysinfo))))

(declaim (inline decode-loads))

(defconstant +load-shift+ (float (ash 1 si-load-shift)))

(defun decode-loads (loads)
  (let ((1min  (/ (mem-aref loads :ulong 0) +load-shift+))
        (5min  (/ (mem-aref loads :ulong 1) +load-shift+))
        (15min (/ (mem-aref loads :ulong 2) +load-shift+)))
    (list 1min 5min 15min)))

(defun sysinfo ()
  "Return sysinfo as a plist"
  (with-foreign-object (info '(:struct sysinfo))
    (if (>= (c-sysinfo info) 0)
        (with-foreign-slots ((uptime loads totalram freeram sharedram bufferram
                                     totalswap freeswap procs totalhigh freehigh
                                     mem-unit)
                             info (:struct sysinfo))
          (list :uptime uptime
                :loads (decode-loads loads)
                :totalram totalram
                :freeram freeram
                :sharedram sharedram
                :bufferram bufferram
                :totalswap totalswap
                :freeswap freeswap
                :procs procs
                :totalhigh totalhigh
                :freehigh freehigh
                :mem-unit mem-unit))
        (error "error getting sysinfo"))))
