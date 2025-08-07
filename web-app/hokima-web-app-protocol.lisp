(cl:in-package #:hokima-web-app)

(defclass external-application-configuration (jfh-store:config-data)
  ((%name
    :reader name
    :initarg :name)
   (%display-name
    :reader display-name
    :initarg :display-name)
   (%root-path
    :reader root-path
    :initarg :root-path
    :initform "")
   (%application-auth-type
    :reader application-auth-type
    :initarg :application-auth-type
    :initform nil) ;; other choices: "login," "api-key"
   (%certificate-config-path
    :reader certificate-config-path
    :initarg :certificate-config-path
    :initform nil)
   (%certificate-path
    :reader certificate-path
    :initarg :certificate-path
    :initform nil)))
