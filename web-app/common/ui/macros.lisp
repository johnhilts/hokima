;;;; Web page sections to include in other pages
(cl:in-package #:hokima-web-app)

(defmacro define-admin-page (name-and-end-point params &body body)
  "Macro to DRY pages requiring admin access"
  (let* ((name (car name-and-end-point))
         (end-point (cadr name-and-end-point))
         (possible-description (car body))
         (has-description (and (atom possible-description) (stringp possible-description)))
         (description (if has-description possible-description nil))
         (body-after-description (if has-description (cdr body) body))
         (web-user-var (gensym "web-user"))
         (authenticated-user-id-var (gensym "authenticated-user-id")))
    `(tbnl:define-easy-handler (,name :uri ,end-point) (,@params)
       ,(when description description)
       (multiple-value-bind (,authenticated-user-id-var present-p)
           (auth:get-authenticated-user)
         (if present-p
             (let ((,web-user-var (get-web-user-info ,authenticated-user-id-var)))
               (who:with-html-output-to-string
                   (*standard-output* nil :prologue t :indent t)
                 (:html
                  (who:str (common-header "Admin"))
                  (:body
                   (:div (:a :href "/admin" "Admin Home"))
                   (:h2 (who:fmt "Welcome to the Admin Page, ~A!" (user-name ,web-user-var)))
                   ,@body-after-description
                   (:div (:br) (:br))
                   (:div
                    (:a :href "/logout" "Click here to logout!"))))))
             (tbnl:redirect (format nil "/login?redirect-back-to=~a" (tbnl:url-encode ,end-point))))))))

