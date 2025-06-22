;;;; Web pages for hokima
(cl:in-package #:hokima-web-app)

(defclass application-info ()
  ((%name
    :reader name
    :initarg :name
    :initform "")
   (%root-path
    :reader root-path
    :initarg :root-path
    :initform "")
   (%application-auth-type
    :reader application-auth-type
    :initarg :application-auth-type
    :initform :certificate) ;; other choices: :login, :api-key
   (%certificate-config-path
    :reader certificate-config-path
    :initarg :certificate-config-path
    :initform "config")
   (%certificate-path
    :reader certificate-path
    :initarg :certificate-path
    :initform "certs")))

(defparameter *registered-apps*
  (list
   (make-instance 'application-info
                  :name "chasi"
                  :root-path (format nil (format nil "~A/~A" cl-user::*jfh-app/home-folder* "chasi"))
                  :application-auth-type :certificate
                  :certificate-config-path "config"
                  :certificate-path (format nil (format nil "~A/~A" cl-user::*jfh-app/home-folder* "cert-scripts/certs/openssl3/chasi-2025"))))
  "list of registred apps managed in admin") ;; TODO get all this info from a config file

(define-admin-page (admin-page "/admin") ()
  "Main Entry point for hokima admin."
  (:div (:a :href "/admin/app-manage-step1" "Start managing an App.")))

(defun render-app-info (app-info)
  (who:with-html-output-to-string
      (*standard-output* nil :indent t)
    (:div
     (who:fmt "<h2>Selected App</h2><table cellpadding='10' border='1'><tr><th>App Name</th><td>~A</td></tr><tr><th>App root</th><td>~A</td></tr><tr><th>Auth type</th><td>~A</td></tr>"
              (name app-info) (root-path app-info) (application-auth-type app-info))
     (when (eql :certificate (application-auth-type app-info))
       (who:fmt "<tr><th>Cert config path</th><td>~A</td></tr><tr><th>Cert save path</th><td>~A</td></tr>"
                (certificate-config-path app-info) (certificate-path app-info)))
     (who:fmt "</table>"))))

(define-admin-page (admin-app-manage-step1 "/admin/app-manage-step1") ()
  "Manage an App - Step 1"
  (:div "Select app to manage")
  (:div
   (:form :action "/admin/app-manage-step2" :method "POST"
          (:select :name "app-name" :size "3"
                   (:option :value "chasi" "Chasi"))
          (:br)
          (:button :type "submit" "Next"))))

(define-admin-page (admin-app-manage-step2 "/admin/app-manage-step2") ()
  "Manage an App - Step 2"
  (let* ((post-app-name (tbnl:post-parameter "app-name"))
         (app-info (find-if (lambda (app) (string= post-app-name (name app))) *registered-apps*)))
    (who:htm
     (who:str (render-app-info app-info))
     (:div
      (:h2 (who:fmt "Create a new user for ~A." (name app-info)))
      (:form :action "/admin/app-manage-step3" :method "POST"
             (:input :type "hidden" :name "app-name" :value (name app-info))
             (:input :type "text" :name "user-name" :placeholder "User Name" :autofocus "autofocus")
             (:br)
             (:input :type "email" :name "user-email" :placeholder "User Email")
             (:br)
             (:br)
             (:button :type "submit" "Next"))))))

(define-admin-page (admin-app-manage-step3 "/admin/app-manage-step3") ()
  "Manage an App - Step 3"
  (let* ((post-app-name (tbnl:post-parameter "app-name"))
         (app-info (find-if (lambda (app) (string= post-app-name (name app))) *registered-apps*))
         (post-user-name (tbnl:post-parameter "user-name"))
         (post-user-email (tbnl:post-parameter "user-email")))
    (who:htm
     (who:str (render-app-info app-info))
     (:div
      (:h2 (who:fmt "Create a new user for ~A - generate certificate." (name app-info)))
      (:div
       (who:fmt "<table cellpadding='10' border='1'><tr><th>Name</th><th>Email</th></tr><tr><td>~A</td><td>~A</td></tr></table>"
                post-user-name post-user-email))
      (:p (who:fmt "At this point, use the certificate scripts to create a client certificate for <b>~A</b>, then click the *Next* button." post-user-email))
      (:div
       (:p (:u "Copy/paste-able one-liner for convenience:")
           (:pre
            (who:fmt "(cd ~A && . ./generate-client.sh)" (certificate-path app-info)))))
      (:form :action "/admin/app-manage-step4" :method "POST"
             (:input :type "hidden" :name "app-name" :value (name app-info))
             (:input :type "hidden" :name "user-name" :value post-user-name)
             (:input :type "hidden" :name "user-email" :value post-user-email)
             (:br)
             (:button :type "submit" "Next"))))))

(define-admin-page (admin-app-manage-step4 "/admin/app-manage-step4") ()
  "Manage an App - Step 4"
  (let* ((post-app-name (tbnl:post-parameter "app-name"))
         (app-info (find-if (lambda (app) (string= post-app-name (name app))) *registered-apps*))
         (post-user-name (tbnl:post-parameter "user-name"))
         (post-user-email (tbnl:post-parameter "user-email"))
         ;; TODO - if AUTH:GET-CERTIFICATE-FINGERPRINT-FROM-FILE fails, handle gracefully!
         (fingerprint (auth:get-certificate-fingerprint-from-file (certificate-path app-info) post-user-email)))
    (who:htm
     (who:str (render-app-info app-info))
     (:div
      (:h2 (who:fmt "Create a new user for ~A - save user data." (name app-info)))
      (:p (who:fmt "At this point, the client certificate for <b>~A</b> should have been created.<br />Double check the info then click the *Next* button." post-user-email))
      (:div
       (:h3 (who:fmt "Client Certificate Fingerprint for ~A" post-user-email))
       (:h4 (who:str fingerprint)))
      (:form :action "/admin/app-manage-step5" :method "POST"
             (:input :type "hidden" :name "app-name" :value (name app-info))
             (:input :type "hidden" :name "user-name" :value post-user-name)
             (:input :type "hidden" :name "user-email" :value post-user-email)
             (:input :type "hidden" :name "user-fingerprint" :value fingerprint)
             (:br)
             (:button :type "submit" "Next"))))))

(define-admin-page (admin-app-manage-step5 "/admin/app-manage-step5") ()
  "Manage an App - Step 5"
  (let* ((post-app-name (tbnl:post-parameter "app-name"))
         (app-info (find-if (lambda (app) (string= post-app-name (name app))) *registered-apps*))
         (post-user-name (tbnl:post-parameter "user-name"))
         (post-user-email (tbnl:post-parameter "user-email"))
         (*read-eval* nil)
         (post-user-fingerprint (read-from-string (tbnl:post-parameter "user-fingerprint"))))

    (let* ((jfh-store:*app-data-path* (root-path app-info)))
      (add-external-user post-user-name post-user-email post-user-fingerprint))

    (who:htm
     (who:str (render-app-info app-info))
     (:div
      (:h2 (who:fmt "New user data for ~A save operation complete." (name app-info)))
      (:p (who:fmt "Now, the user data for <b>~A</b> should have been created, and that user should be able to access the site once their certificate is imported to their device(s)." post-user-email))
      (:div
       (:h3 (who:fmt "Client Certificate Fingerprint for ~A" post-user-email))
       (:h4 (who:str post-user-fingerprint)))
      (:a :href "/admin" "Return to Admin Home.")))))

