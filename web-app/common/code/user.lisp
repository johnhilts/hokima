;;;; functions to support web app users.
(cl:in-package #:hokima-web-app)

(defmethod print-object ((web-app-user web-app-user) stream)
  "Print web app user."
  (call-next-method)
  (print-unreadable-object (web-app-user stream :type t)
    (with-accessors ((user-name user-name)) web-app-user
      (format stream
       	      "User Name: ~A" user-name))))

(defun add-user (user-name user-login user-password)
  "Add new user."
  (user:save-new-application-user (make-web-app-user user-name user-login user-password) store:*data-store-location*))

(defun make-web-app-user (user-name user-login user-password &optional (user-id ""))
  "Constructor for web-app-user."
  (make-instance 'web-app-user :user-name user-name :user-login user-login :user-password user-password :user-id user-id))

(defmethod user:save-application-user ((web-app-user web-app-user) (data-store-location jfh-store:data-store-location))
  "Input: web-app-user and app-configuration. Output: serialized web-app-user (sub-class specific fields only) . Persist application user info."
  (call-next-method)
  (let ((file-name "web-app-user.sexp")
        (user-info-list (list
                         :user-name (user-name web-app-user))))
    (user:save-user file-name user-info-list web-app-user data-store-location)))

(defun get-web-user-info (user-login)
  "Derive web-user info from app-user."
  (let* ((application-user (user:get-user-info user-login))
         (user-id (user:user-id application-user))
         (web-user-info (user:read-user-info user-id "web-app-user.sexp"))
	 (secure-user-info (user:read-user-info user-id "hash.sexp"))) ;; TODO make the file name an exported string
    (make-web-app-user (getf web-user-info :user-name) user-login (getf secure-user-info :user-password) user-id)))
