;;;; SPDX-FileCopyrightText: Atlas Engineer LLC
;;;; SPDX-License-Identifier: BSD-3-Clause

(in-package :ospm/tests)

;; Tests for functional package managers.

(defvar *test-package-name* "hello")
(defvar *test-package-with-outputs* "sbcl-slynk")
(defvar *test-package-with-outputs-output* "image")

(defvar *test-profile* (uiop:resolve-absolute-location ; TODO: Can we generate a temp dir in Common Lisp?
                        (list (uiop:temporary-directory) "ospm-tests/profile")))
(defvar *test-manifest-file* (uiop:resolve-absolute-location
                              (list (uiop:temporary-directory) "ospm-tests/manifest.scm")))

(defvar *test-manifest* "(specifications->manifest '(\"hello\"))")

(define-test install-to-temp-profile (:tags :functional)
  (uiop:ensure-all-directories-exist
   (list (uiop:pathname-directory-pathname *test-profile*)))
  (let ((process-info (ospm:install (ospm:find-os-packages *test-package-name*)
                                    *test-profile*)))
    (uiop:wait-process process-info)
    (assert-equal *test-package-name*
                  (ospm:name (ospm:parent-package
                              (first (ospm:list-packages *test-profile*)))))
    (setf process-info (ospm:uninstall (list (first (ospm:list-packages *test-profile*)))
                                       *test-profile*))
    (uiop:wait-process process-info)
    ;; TODO: Delete *test-profile* afterwards?
    ;; final profile is empty
    (assert-false (ospm:list-packages *test-profile*))))

(define-test install-output (:tags :functional)
  (uiop:ensure-all-directories-exist
   (list (uiop:pathname-directory-pathname *test-profile*)))
  (let ((process-info (ospm:install (list (find *test-package-with-outputs-output*
                                                (ospm:outputs (first (ospm:find-os-packages *test-package-with-outputs*)))
                                                :key #'ospm:name
                                                :test #'string=))
                                    *test-profile*)))
    (uiop:wait-process process-info)
    (assert-equal *test-package-with-outputs-output*
                  (ospm:name (first (ospm:list-packages *test-profile*))))
    ;; TODO: Delete *test-profile* afterwards?
    ))

(defvar *test-package-with-versions* "libpng")
(defvar *test-package-with-versions-version* "1.2.59")

(define-test install-version (:tags :functional)
  (uiop:ensure-all-directories-exist
   (list (uiop:pathname-directory-pathname *test-profile*)))
  (let ((process-info (ospm:install (list (first (ospm:find-os-packages
                                                  *test-package-with-versions*
                                                  :version *test-package-with-versions-version*)))
                                    *test-profile*)))
    (uiop:wait-process process-info)
    ;; FIXME
    ;; (assert-equal *test-package-with-versions-version*
    ;;               (ospm:version (ospm:parent-package
    ;;                              (first (ospm:list-packages *test-profile*)))))
    ;; TODO: Delete *test-profile* afterwards?
    ))

(define-test install-manifest-to-temp-profile (:tags :functional)
  (uiop:ensure-all-directories-exist
   (list (uiop:pathname-directory-pathname *test-profile*)
         (uiop:pathname-directory-pathname *test-manifest-file*)))
  (uiop:with-output-file (f *test-manifest-file* :if-exists :overwrite)
    (write-string *test-manifest* f))
  (let ((process-info (ospm:install-manifest *test-manifest-file*
                                             *test-profile*)))
    (uiop:wait-process process-info)
    ;; TODO: Delete *test-profile* afterwards?
    (assert-equal *test-package-name*
                  (ospm:name (ospm:parent-package
                              (first (ospm:list-packages *test-profile*)))))))

(define-test list-files (:tags :functional)
  (let* ((output-list (ospm:outputs (first (ospm:find-os-packages *test-package-name*))))
         (file-list (ospm:list-files
                     (list (first output-list)))))
    (assert-equal "hello"
                  (pathname-name (first file-list)))
    (assert-equal "bin"
                  (first (last (pathname-directory (first file-list)))))))
