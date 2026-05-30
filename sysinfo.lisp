;;;; sysinfo.lisp

(in-package #:sysinfo)

(defcfun (c-sysinfo "sysinfo") :int
  (info (:pointer (:struct sysinfo))))

(defcfun (c-strerror "strerror") :string
  (errnum :int))

(defun %errno ()
  "Best-effort retrieval of the current C errno, or NIL when the running
implementation does not expose it."
  #+sbcl (sb-alien:get-errno)
  #-sbcl nil)

(define-condition sysinfo-error (error)
  ((code  :initarg :code  :initform nil :reader sysinfo-error-code)
   (errno :initarg :errno :initform nil :reader sysinfo-error-errno))
  (:report (lambda (condition stream)
             (let ((errno (sysinfo-error-errno condition)))
               (format stream "The sysinfo(2) syscall failed~@[ (return code ~A)~]~@[: ~A~]."
                       (sysinfo-error-code condition)
                       (and errno (/= errno 0) (c-strerror errno))))))
  (:documentation "Signalled when the sysinfo(2) syscall returns a failure.
SYSINFO-ERROR-CODE holds the syscall's return value and SYSINFO-ERROR-ERRNO
holds the C errno at the time of failure (or NIL if it could not be read)."))

(declaim (inline decode-loads))

(defconstant +load-shift+ (float (ash 1 si-load-shift))
  "Scaling factor for the fixed-point load averages reported by the kernel.")

(defun decode-loads (loads)
  "Convert the three raw fixed-point load averages into single-floats
representing the 1-, 5- and 15-minute load averages."
  (list (/ (mem-aref loads :ulong 0) +load-shift+)
        (/ (mem-aref loads :ulong 1) +load-shift+)
        (/ (mem-aref loads :ulong 2) +load-shift+)))

(defun sysinfo ()
  "Return system statistics from the sysinfo(2) syscall as a plist.

The keys are :UPTIME (seconds since boot), :LOADS (a list of the 1-, 5-
and 15-minute load averages as single-floats), :TOTALRAM, :FREERAM,
:SHAREDRAM, :BUFFERRAM, :TOTALSWAP, :FREESWAP, :PROCS, :TOTALHIGH,
:FREEHIGH and :MEM-UNIT.

The memory and swap fields are expressed in units of :MEM-UNIT bytes;
multiply by :MEM-UNIT to obtain a value in bytes.

Signals a SYSINFO-ERROR if the syscall fails.  Linux only."
  (with-foreign-object (info '(:struct sysinfo))
    (let ((ret (c-sysinfo info)))
      (if (>= ret 0)
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
          (error 'sysinfo-error :code ret :errno (%errno))))))

(defun sysinfo-alist (&optional (info (sysinfo)))
  "Return the data in INFO (a plist as returned by SYSINFO, fetched fresh by
default) as an alist of (KEY . VALUE) pairs."
  (loop for (key value) on info by #'cddr
        collect (cons key value)))

(defun sysinfo-list (&optional (info (sysinfo)))
  "Return the values from INFO (a plist as returned by SYSINFO, fetched fresh
by default) as a list, in declaration order.  Note that the :LOADS value is
itself a list, so the result is not fully flat."
  (loop for (nil value) on info by #'cddr
        collect value))

(defun uptime-duration (&optional (info (sysinfo)))
  "Return the system uptime from INFO (fetched fresh by default) as a
LOCAL-TIME-DURATION:DURATION."
  (local-time-duration:duration :sec (getf info :uptime)))
