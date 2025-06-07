;;;; Web pages for hokima
(cl:in-package #:hokima-web-app)

(tbnl:define-easy-handler (root :URI "/") ()
  "root route handler"
  (tbnl:redirect "/admin"))

(tbnl:define-easy-handler (version-page :uri "/version") ()
  (who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent t)
    (:html
     (who:str (common-header "Version"))
     (:body
      (:div "Version")
      (:div (who:str(get-version)))))))
