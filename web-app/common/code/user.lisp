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
  "Add new user.
NOTE: This is not used in hokima."
  (let*  ((application-user (user:get-user-info (make-instance 'jfh-user:application-user-id :user-id "")))
	  (secure-user-info (make-instance 'jfh-user:application-secure-user :user-id (jfh-store:user-id application-user) :user-password user-password)))
    (user:save-new-application-user secure-user-info)
    (user:save-application-user (make-web-app-user user-name user-login))))

(defun make-web-app-user (user-name user-login &optional (user-id ""))
  "Constructor for web-app-user."
  (make-instance 'web-app-user :user-name user-name :user-login user-login :user-id user-id))

(defmethod user:save-application-user ((web-app-user web-app-user))
  "Input: web-app-user and app-configuration. Output: serialized web-app-user (sub-class specific fields only) . Persist application user info."
  (jfh-store:save-object web-app-user))

(defun get-web-user-info (user-id) ;; TODO (maybe?) this has to be converted into a function specializing on user-identifier
  "Derive web-user info from app-user."
  (let* ((application-user (user:get-user-info (make-instance 'jfh-user:application-user-id :user-id user-id)))
         (user-login (user:user-login application-user))
         (web-user-info (jfh-store:make-instance* 'web-app-user :user-id (jfh-store:user-id application-user)))
	 ;; (secure-user-info (jfh-store:make-instance* 'jfh-user:application-secure-user :user-id (jfh-store:user-id application-user)))
         )
    (make-web-app-user (user-name web-user-info) user-login user-id)))
