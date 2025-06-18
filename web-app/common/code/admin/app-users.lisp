;;;; Web pages for hokima
(cl:in-package #:hokima-web-app)

(defun add-external-user (user-name user-email user-fingerprint)
  "Add new user for a different app."
  (let* ((secure-user (make-instance 'user:application-secure-user
                                     :user-login user-email
                                     :user-password "password-not-set"
                                     :user-fingerprint user-fingerprint
                                     :user-id ""))
         (web-user (make-external-app-user user-name user-email (jfh-store:user-id secure-user))))
    (user:save-new-application-user secure-user)
    (user:save-application-user web-user)))

(defun make-external-app-user (user-name user-login &optional (user-id ""))
  "Constructor for a web-app-user for another application."
  (make-instance 'web-app-user :user-name user-name :user-id user-id :user-login user-login)) ;; TODO can we remove user-login from this class hiearchy?
