;;;; sysinfo.lisp

(in-package #:sysinfo)

;; (defcstruct (sysinfo :size 112)
;;   (uptime :long :offset 0)
;;   (loads :long :count 3 :offset 8)
;;   (totalram :ulong :offset 32)
;;   (freeram :ulong :offset 40)
;;   (sharedram :ulong :offset 48)
;;   (bufferram :ulong :offset 56)
;;   (totalswap :ulong :offset 64)
;;   (freeswap :ulong :offset 72)
;;   (procs :ushort :offset 80)
;;   (totalhigh :ulong :offset 88)
;;   (freehigh :ulong :offset 96)
;;   (mem-unit :int :offset 104))

;; (defconstant size-of-sysinfo (foreign-type-size '(:struct sysinfo)))

(defcfun (c-sysinfo "sysinfo") :int
  (info (:pointer (:struct sysinfo))))

(defclass sysinfo ()
  ((uptime    :initarg :uptime    :reader uptime)
   (loads     :initarg :loads     :reader loads)
   (totalram  :initarg :totalram  :reader totalram)
   (freeram   :initarg :freeram   :reader freeram)
   (sharedram :initarg :sharedram :reader sharedram)
   (bufferram :initarg :bufferram :reader bufferram)
   (totalswap :initarg :totalswap :reader totalswap)
   (freeswap  :initarg :freeswap  :reader freeswap)
   (procs     :initarg :procs     :reader procs)
   (totalhigh :initarg :totalhigh :reader totalhigh)
   (freehigh  :initarg :freehigh  :reader freehigh)
   (mem-unit  :initarg :mem-unit  :reader mem-unit)))

(defun make-sysinfo-from-pointer (sysinfo)
  (with-foreign-slots ((uptime loads totalram freeram sharedram bufferram totalswap freeswap procs totalhigh freehigh mem-unit)
                       sysinfo (:struct sysinfo))
    (make-instance 'sysinfo
                   :uptime uptime
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
                   :mem-unit mem-unit)))

(declaim (inline decode-loads))

(defun decode-loads (loads)
  (let ((1min  (/ (mem-aref loads :ulong 0) 65536.0))
        (5min  (/ (mem-aref loads :ulong 1) 65536.0))
        (15min (/ (mem-aref loads :ulong 2) 65536.0)))
    (list 1min 5min 15min)))

(defun sysinfo ()
  (with-foreign-object (info '(:struct sysinfo))
    (if (>= (c-sysinfo info) 0)
        (make-sysinfo-from-pointer info)
        nil)))

(defun sysinfo-list ()
  (with-foreign-object (info '(:struct sysinfo))
    (if (>= (c-sysinfo info) 0)
        (with-foreign-slots ((uptime loads totalram freeram sharedram bufferram totalswap freeswap procs totalhigh freehigh mem-unit)
                             info (:struct sysinfo))
          (list uptime (decode-loads loads) totalram freeram sharedram bufferram totalswap freeswap procs totalhigh freehigh mem-unit))
        nil)))

(defun sysinfo-alist ()
  (with-foreign-object (info '(:struct sysinfo))
    (if (>= (c-sysinfo info) 0)
        (with-foreign-slots ((uptime loads totalram freeram sharedram bufferram totalswap freeswap procs totalhigh freehigh mem-unit)
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
        nil)))
