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
  (user:save-new-application-user (make-web-app-user user-name user-login user-password)))

(defun make-web-app-user (user-name user-login user-password &optional (user-id ""))
  "Constructor for web-app-user."
  (make-instance 'web-app-user :user-name user-name :user-login user-login :user-password user-password :user-id user-id))

(defmethod serialize-object ((web-app-user web-app-user))
  "Input: object and its serialization type."
  (jfh-store:serialize-object->list web-app-user (list 'user-name)))

(defmethod user:save-application-user-OLD ((web-app-user web-app-user))
  "Input: web-app-user and app-configuration. Output: serialized web-app-user (sub-class specific fields only) . Persist application user info."
  (call-next-method)
  (let ((data (jfh-store:serialize-object->list web-app-user (list 'user-name)))
        (user-store-object (make-instance 'jfh-store:user-store-object :label "web-app-user" :key (jfh-user:user-id web-app-user) :location (format nil "~A/users" jfh-store:*store-root-folder*))))
    (jfh-store:save-user-data user-store-object data)))

(defmethod user:save-application-user ((web-app-user web-app-user))
  "Input: web-app-user and app-configuration. Output: serialized web-app-user (sub-class specific fields only) . Persist application user info."
  (call-next-method)
  (jfh-store:save-object web-app-user (list 'user-name) :key (jfh-user:user-id web-app-user)))

(defun get-web-user-info-OLD (user-login) ;; TODO this has to be converted into a function specializing on user-identifier
  "Derive web-user info from app-user."
  (let* ((application-user (user:get-user-info user-login))
         (user-id (user:user-id application-user))
         (web-user-info (user:read-user-info user-id "web-app-user.sexp"))
	 (secure-user-info (user:read-user-info user-id "hash.sexp"))) ;; TODO make the file name an exported string
    (make-web-app-user (getf web-user-info :user-name) user-login (getf secure-user-info :user-password) user-id)))

(defun get-web-user-info (user-id) ;; TODO (maybe?) this has to be converted into a function specializing on user-identifier
  "Derive web-user info from app-user."
  (let* ((application-user (user:get-user-info (make-instance 'jfh-user:application-user-id :user-id user-id)))
         (user-login (user:user-login application-user))
         (web-user-info (user:read-user-info user-id "web-app-user.sexp"))
	 (secure-user-info (user:read-user-info user-id "hash.sexp"))) ;; TODO make the file name an exported string
    (make-web-app-user (getf web-user-info :user-name) user-login (getf secure-user-info :user-password) user-id)))
