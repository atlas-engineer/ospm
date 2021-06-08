;;;; SPDX-FileCopyrightText: Atlas Engineer LLC
;;;; SPDX-License-Identifier: BSD-3-Clause

(in-package :cl-user)

(uiop:define-package ospm
  (:use #:common-lisp)
  (:use #:trivia)
  (:import-from #:hu.dwim.defclass-star #:defclass*)
  (:import-from #:serapeum #:export-always))

(defvar ospm::scheme-reader-syntax nil)
(defvar ospm::scheme-writer-syntax nil)
