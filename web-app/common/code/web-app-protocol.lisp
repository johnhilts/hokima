;;;; protocol related to specific web app concerns.
(cl:in-package #:hokima-web-app)

(defclass web-app-user (user:application-meta-user)
  ((%user-name
    :reader user-name
    :initarg :user-name))
  (:documentation "Web Application user info."))
