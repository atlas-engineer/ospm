;;;; SPDX-FileCopyrightText: Atlas Engineer LLC
;;;; SPDX-License-Identifier: BSD-3-Clause

(defsystem "ospm"
  :version "0.0.0"
  :author "Atlas Engineer LLC"
  :description "OS package manager interface"
  :license "BSD 3-Clause"
  :depends-on (alexandria
               calispel
               cl-ppcre
               hu.dwim.defclass-star    ; Latest version required.
               local-time
               named-readtables
               #-sbcl
               osicat
               serapeum
               str
               trivia)
  :serial t
  :components ((:file "package")
               (:file "scheme-syntax")
               (:file "guix-backend")
               (:file "ospm")
               (:file "ospm-guix"))
  :in-order-to ((test-op (test-op "ospm/tests"))))

(defsystem "ospm/tests"
  :depends-on (ospm prove)
  :components ((:file "test-package"))
  :perform (test-op (op c)
                    (funcall (read-from-string "prove:run")
                             (system-relative-pathname c "tests/tests.lisp"))))
