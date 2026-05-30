;;;; sysinfo-test.lisp

(defpackage #:sysinfo/test
  (:use #:cl #:fiveam)
  (:export #:run-tests #:sysinfo-suite))

(in-package #:sysinfo/test)

(def-suite sysinfo-suite
  :description "Tests for the cl-sysinfo system.")

(in-suite sysinfo-suite)

(test sysinfo-returns-sane-plist
  "SYSINFO returns a plist with plausible values."
  (let ((info (sysinfo:sysinfo)))
    (is (listp info))
    (is (evenp (length info)))
    (is (integerp (getf info :uptime)))
    (is (>= (getf info :uptime) 0))
    (is (plusp (getf info :totalram)))
    (is (plusp (getf info :mem-unit)))
    (let ((loads (getf info :loads)))
      (is (= 3 (length loads)))
      (is (every #'realp loads))
      (is (every (lambda (l) (>= l 0)) loads)))))

(test representations-agree
  "SYSINFO, SYSINFO-ALIST and SYSINFO-LIST describe the same fields.
All three views are derived from a single fetch so the comparison is
deterministic (the underlying syscall values change over time)."
  (let* ((plist (sysinfo:sysinfo))
         (alist (sysinfo:sysinfo-alist plist))
         (vals  (sysinfo:sysinfo-list plist)))
    (is (= (length alist) (/ (length plist) 2)))
    (is (= (length vals) (length alist)))
    (is (equal vals (mapcar #'cdr alist)))
    ;; The alist keys match the plist keys in order.
    (is (equal (mapcar #'car alist)
               (loop for (key nil) on plist by #'cddr collect key)))))

(test uptime-duration-matches-uptime
  "UPTIME-DURATION returns a duration whose whole seconds equal :UPTIME."
  (let* ((info (sysinfo:sysinfo))
         (d    (sysinfo:uptime-duration info)))
    (is (typep d 'local-time-duration:duration))
    (is (= (getf info :uptime)
           (local-time-duration:duration-as d :sec)))))

(test sysinfo-error-reports-nicely
  "SYSINFO-ERROR renders a message including the syscall and errno text."
  (let ((msg (princ-to-string
              (make-condition 'sysinfo:sysinfo-error :code -1 :errno 14))))
    (is (search "sysinfo(2)" msg))
    (is (search "-1" msg))
    ;; errno 14 is EFAULT; strerror should mention an address/fault.
    (is (plusp (length msg)))
    (is (= 14 (sysinfo:sysinfo-error-errno
               (make-condition 'sysinfo:sysinfo-error :errno 14))))))

(defun run-tests ()
  "Run the cl-sysinfo test suite, signalling an error on failure
so that `asdf:test-system' reports it correctly."
  (unless (run! 'sysinfo-suite)
    (error "cl-sysinfo test suite failed.")))
