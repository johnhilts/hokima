;;;; protocol related to specific web app concerns.
(cl:in-package #:hokima-web-app)

(defclass web-app-user (user:application-meta-user user:application-secure-user)
  ((%user-name
    :reader user-name
    :initarg :user-name))
  (:documentation "Web Application user info."))

(defmethod print-object ((application-user web-app-user) stream)
  "Print application user."
  (print-unreadable-object (application-user stream :type t)
    (with-accessors ((user-name user-name)) application-user
      (format stream
	      "User Name: ~A" user-name))))
