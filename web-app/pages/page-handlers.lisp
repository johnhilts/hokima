;;;; Web pages for hokima
(cl:in-package #:hokima-web-app)

(tbnl:define-easy-handler (root :URI "/") ()
  "root route handler"
  ;; (break)
  (who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent t)
    (:html
     (who:str (common-header "Home"))
     (:body
      (:div
       "Welcome to the Secrets Safe!")
      (:div :style "float:right"
	    (:a :href "/logout" "Logout"))
      (:div "&nbsp;")
      (multiple-value-bind (authenticated-user-login present-p)
          (auth:get-authenticated-user)
	(when present-p
          (let ((web-user (get-web-user-info authenticated-user-login)))
            (who:htm
             (:div (who:fmt "Welcome, ~A." (user-name web-user)))
             (:div "Get Started")
             (:div
              (:a :href "/list" "Your Secrets"))
             (:div
              (:a :href "/add" "Add More"))
	     (:div
              (:a :href "/search" "Search."))))))))))

(auth:define-protected-page (admin-page "/admin") ()
  (let ((web-user (get-web-user-info auth:authenticated-user)))
    (who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent t)
    (:html
     (who:str (common-header "Admin"))
     (:body
      (:h2 (who:fmt "Welcome to the Admin Page, ~A!" (user-name web-user)))
      (:div "You're supposed to be logged in to see this!")
      (:div
       (:a :href "/logout" "Click here to logout!")))))))


(tbnl:define-easy-handler (version-page :uri "/version") ()
  (who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent t)
    (:html
     (who:str (common-header "Version"))
     (:body
      (:div "Version")
      (:div (who:str(get-version)))))))
