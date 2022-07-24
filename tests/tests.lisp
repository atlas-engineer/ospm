;;;; SPDX-FileCopyrightText: Atlas Engineer LLC
;;;; SPDX-License-Identifier: BSD-3-Clause

(uiop:define-package ospm/tests
  (:use #:common-lisp #:lisp-unit2)
  (:import-from #:ospm))
(in-package :ospm/tests)

(defvar *test-package-name* "hello")
(defvar *test-complex-package-name* "sbcl")
(defvar *test-multi-version-package-name* "linux-libre")

(define-test package-list ()
  (assert-true (< 0 (length (ospm:list-packages))))
  (assert-typep 'ospm:os-package
                (first (ospm:list-packages))))

;; change name
(define-test test-find-package ()
  (assert-equal *test-package-name*
                (ospm:name (first (ospm:find-os-packages *test-package-name*)))))

(define-test find-multiple-package-versions ()
  (assert-true (<= 2 (length (ospm:find-os-packages *test-multi-version-package-name*)))))

(define-test package-inputs ()
  (let* ((pkg (first (ospm:find-os-packages *test-complex-package-name*)))
         (all-inputs (append
                      (ospm:inputs pkg)
                      (ospm:propagated-inputs pkg)
                      (ospm:native-inputs pkg))))
    (assert-true (mapc #'ospm:find-os-packages all-inputs))))

(define-test list-profiles ()
  (assert-true (uiop:directory-exists-p (first (ospm:list-profiles)))))
