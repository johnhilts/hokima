(cl:in-package #:asdf-user)

(defsystem #:hokima-web-app
  :description "Web interface for safe secrets."
  :author "John Hilts <johnhilts@gmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:hunchentoot #:parenscript #:cl-json #:cl-who #:jfh-utility #:jfh-web-server)
  :components ((:file package)
               (:file common/code/configure)
               (:file common/code/web-app-protocol)
               (:file common/code/utility)
               (:file common/code/user)
               (:file common/ui/page-include)
	       (:file common/ui/auth/auth)))

