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
  "SYSINFO, SYSINFO-ALIST and SYSINFO-LIST describe the same fields."
  (let* ((plist (sysinfo:sysinfo))
         (alist (sysinfo:sysinfo-alist))
         (vals  (sysinfo:sysinfo-list)))
    (is (= (length alist) (/ (length plist) 2)))
    (is (= (length vals) (length alist)))
    (is (equal vals (mapcar #'cdr alist)))
    ;; The alist keys match the plist keys in order.
    (is (equal (mapcar #'car alist)
               (loop for (key nil) on plist by #'cddr collect key)))))

(test uptime-duration-is-a-duration
  "UPTIME-DURATION returns a LOCAL-TIME-DURATION:DURATION."
  (let ((d (sysinfo:uptime-duration)))
    (is (typep d 'local-time-duration:duration))
    (is (>= (local-time-duration:duration-as d :sec) 0))))

(defun run-tests ()
  "Run the cl-sysinfo test suite, signalling an error on failure
so that `asdf:test-system' reports it correctly."
  (unless (run! 'sysinfo-suite)
    (error "cl-sysinfo test suite failed.")))
