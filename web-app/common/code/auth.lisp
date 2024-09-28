;;;; functions for auth related to this web app; usually called from a page handler
(cl:in-package #:hokima-web-app)

(defun on-auth-hook ()
  "Run this when authorization is successful."
  (multiple-value-bind (authenticated-user-id present-p)
      (auth:get-authenticated-user)
    (when present-p
      (format nil "~A is logged in." authenticated-user-id))))
