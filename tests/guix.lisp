;;;; SPDX-FileCopyrightText: Atlas Engineer LLC
;;;; SPDX-License-Identifier: BSD-3-Clause

(in-package :ospm/tests)

(define-test generate-database (:tags '(:functional :guix))
  "Ensure all packages can be parsed as expected.
In case of error, the default is to return \"\".
We use this test to check for such errors."
  ;; `*debug-on-error* is shared among threads, so we cannot let-bind it.
  (let ((old-debug ospm::*debug-on-error*))
    (unwind-protect (progn
                      (setf ospm::*debug-on-error* t)
                      (assert-no-error 'error
                                       (ospm::generate-database)))
      (setf ospm::*debug-on-error* old-debug))))
