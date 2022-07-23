;;;; SPDX-FileCopyrightText: Atlas Engineer LLC
;;;; SPDX-License-Identifier: BSD-3-Clause

(uiop:define-package ospm
  (:use #:common-lisp)
  (:use #:trivia)
  (:import-from #:hu.dwim.defclass-star #:defclass*)
  (:import-from #:serapeum #:export-always))
(in-package :ospm)

(defvar ospm::scheme-reader-syntax nil)
(defvar ospm::scheme-writer-syntax nil)
