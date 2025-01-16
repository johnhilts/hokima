;;;; Web pages for hokima
(cl:in-package #:hokima-web-app)

(defun add-external-user (user-name user-email user-fingerprint)
  "Add new user for a different app."
  (user:save-new-application-user (make-external-app-user user-name user-email user-fingerprint)))

(defun make-external-app-user (user-name user-login user-fingerprint &optional (user-id ""))
  "Constructor for a web-app-user for another application."
  (make-instance 'web-app-user :user-name user-name :user-login user-login :user-password "password-not-set" :user-fingerprint user-fingerprint :user-id user-id))
