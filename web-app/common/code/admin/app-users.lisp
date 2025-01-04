;;;; Web pages for hokima
(cl:in-package #:hokima-web-app)

(defclass external-app-user (web-app-user jfh-user:application-user-fingerprint)
  ()
  (:documentation "External Application user info."))

;; TODO - we need to make ADD-USER a generic function that specializes on user-identifier
(defun add-user (user-name user-email user-fingerprint app-root)
  "Add new user for a different app."
  (let ((data-store-location (make-instance 'jfh-store:data-store-location :user-path-root (format nil "~A/users/" app-root) :settings-file-path app-root)))
    (user:save-new-application-user (make-external-app-user user-name user-email user-fingerprint) data-store-location)))

(defun make-external-app-user (user-name user-login user-fingerprint &optional (user-id ""))
  "Constructor for external-app-user."
  (make-instance 'external-app-user :user-name user-name :user-login user-login :user-fingerprint user-fingerprint :user-id user-id))

(defmethod user:save-application-user ((external-app-user external-app-user) (data-store-location jfh-store:data-store-location))
  "Input: external-app-user and data-store-location. Output: serialized external-app-user. Persist application user info."
  (call-next-method)
  (let ((file-name "external-app-user.sexp") ;; TODO need to figure out the proper name for this
        (user-info-list (list
                         :user-name (user-name external-app-user)
                         :user-fingerprint (jfh-user:user-fingerprint external-app-user))))
    (user:save-user file-name user-info-list external-app-user data-store-location)))
