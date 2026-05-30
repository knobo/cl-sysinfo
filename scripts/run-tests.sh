#!/usr/bin/env bash
# Run the cl-sysinfo test suite from a clean Lisp image.
#
# Requires Roswell (https://roswell.github.io/) on PATH. Override the
# implementation with e.g. LISP=ccl-bin ./scripts/run-tests.sh
set -euo pipefail

cd "$(dirname "$0")/.."

LISP="${LISP:-sbcl-bin}"
ros use "$LISP" >/dev/null 2>&1 || true

exec ros -e "(handler-case
                (progn (push (truename \".\") asdf:*central-registry*)
                       (ql:quickload :cl-sysinfo/test)
                       (asdf:test-system :cl-sysinfo)
                       (uiop:quit 0))
                (error (e)
                  (format *error-output* \"~&Test run failed: ~A~%\" e)
                  (uiop:quit 1)))"
