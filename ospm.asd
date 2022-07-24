;;;; SPDX-FileCopyrightText: Atlas Engineer LLC
;;;; SPDX-License-Identifier: BSD-3-Clause

(defsystem "ospm"
  :version "0.0.0"
  :author "Atlas Engineer LLC"
  :description "OS package manager interface"
  :license "BSD 3-Clause"
  :depends-on (alexandria
               calispel
               hu.dwim.defclass-star    ; Latest version required.
               local-time
               moptilities
               named-readtables
               #-sbcl
               osicat
               serapeum
               trivia)
  :serial t
  :components ((:file "package")
               (:file "scheme-syntax")
               (:file "guix-backend")
               (:file "ospm")
               (:file "ospm-guix"))
  :in-order-to ((test-op (test-op "ospm/tests"))))

(defsystem "ospm/tests"
  :depends-on (ospm lisp-unit2)
  :pathname "tests/"
  :components ((:file "package")
               (:file "test-generic")
               (:file "test-functional"))
  :perform (test-op (op c)
                    (symbol-call :lisp-unit2 :run-tests :package :ospm/tests
                                 :run-contexts (find-symbol "WITH-SUMMARY-CONTEXT" :lisp-unit2))))
