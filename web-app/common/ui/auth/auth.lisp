;;;; functions for auth related to this web app; usually called from a page handler
(cl:in-package #:hokima-web-app)

(defmethod jfh-web-auth:show-auth-failure ()
  "Generate page contents to display when auth fails."
  (who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent t)
    (:html
     (who:str (common-header "Auth Failure"))
     (:body
      (:h2 "Authorization failed!")
      (:div "User or password didn't match"
            (:a :href "/login" "Click here to try again!"))))))

(defmethod jfh-web-auth:login-page (redirect-back-to)
  "Input: URL. Redirect back to the given URL once logged in."
  (who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent t)
    (:html
     (who:str (common-header "Login"))
     (:body
      (:h2 "Use this page to Login!")
      (:form :method "post" :action "auth"
             (:input :type "hidden" :name "redirect-back-to" :value (or redirect-back-to "/???")) ;; TODO where do we go?
             (:div :id "login-input-div"
              (:div (:input :name "user-login" :type "email" :placeholder "Login" :class "login-input" :autofocus "autofocus"))
              (:div (:input :name "password" :type "password" :placeholder "Password" :class "login-input"))
              (:div (:button "Login") (:span "&nbsp;") (:button :id "sign-up-button" :type "button" :onclick "javascript:location.href=\"/signup\";" "Sign-Up"))))))))

(defmethod jfh-web-auth:signup-page ()
  "No Input. Render and handle a signup form."
  (who:with-html-output-to-string
      (*standard-output* nil :prologue t :indent t)
    (:html
     (who:str (common-header "Signup"))
     (:body
      (let ((post-name (tbnl:post-parameter "name"))
            (post-user (tbnl:post-parameter "user"))
            (post-password (tbnl:post-parameter "password"))
            (post-confirm-password (tbnl:post-parameter "confirm-password")))
        (if (or post-name post-user post-password post-confirm-password)
            (multiple-value-bind (signup-validation-successful signup-validation-failure-reasons)
                (auth:validate-signup-parameters post-name post-user post-password post-confirm-password)
              (if signup-validation-successful
                  (progn
                    (add-user post-name post-user post-password)
                    (let ((user-login (make-instance 'user:application-user-login :user-login post-user)))
                      (jfh-web-server:fetch-or-create-user-session user-login))
                    (who:htm (:script :type "text/javascript"
                                      (who:str
                                       (ps:ps
                                         (alert "Signup Successful!")
                                         (setf (ps:@ location href) "???"))))))
                  (who:htm
                   (:div
                    (:span (who:fmt "Signup Failed, because <ul>~{<li>~a</li>~% ~}</ul>" signup-validation-failure-reasons)))
                   (:div
                    (:span "Please try again: ")
                    (:p (:a :href "/signup" "Back to Signup"))
                    (:p (:a :href "/login" "Back to Login"))))))
            (who:htm
             (:h2 "Use this page to sign-up!")
             (:div
              (:a :href "/login" "Back to Login"))
             (:form :method "post" :action "/signup"
                    (:div
                     (:div (:input :name "name" :type "text" :placeholder "Your Name" :class "login-input" :autofocus "autofocus"))
                     (:div (:input :name "user" :type "email" :placeholder "Login" :class "login-input"))
                     (:div (:input :name "password" :type "password" :placeholder "Password" :class "login-input"))
                     (:div (:input :name "confirm-password" :type "password" :placeholder "Confirm Password" :class "login-input"))
                     (:div (:button "Submit")))))))))))
