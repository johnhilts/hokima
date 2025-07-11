;;;; Web pages for hokima
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

(defmethod initialize-instance :after ((external-application-configuration external-application-configuration) &key)
  "Initializations:
- Properly hydrate ROOT-PATH and CERTIFICATE-PATH
Assumptions:
- This information is READ ONLY"
  (let ((name (progn
                #1=(slot-value external-application-configuration '%root-path)
                (slot-value external-application-configuration '%name)))
        (certificate-path (and
                           (slot-boundp external-application-configuration '%certificate-path)
                           #2=(slot-value external-application-configuration '%certificate-path))))
    (setf #1# (format nil (format nil "~A/~A" cl-user::*jfh-app/home-folder* name)))
    (when #2#
      (setf #2# (format nil (format nil "~A/~A" cl-user::*jfh-app/home-folder* certificate-path))))))

(defmethod print-object ((external-application-configuration external-application-configuration) stream)
  "Print external application configuration."
  (print-unreadable-object (external-application-configuration stream :type t)
    (with-accessors
          ((name name) (display-name display-name) (root-path root-path) (application-auth-type application-auth-type)
           (certificate-config-path certificate-config-path) (certificate-path certificate-path))
        external-application-configuration
      (format stream
	      "App Name: ~A (~A), App Path: ~A, Auth Type: ~A~:[~:;, Cert Config Path: ~:*~A, ~]~:[~:;Cert Path: ~:*~A ~]"
              name display-name root-path application-auth-type certificate-config-path certificate-path))))

(defparameter *registered-apps* (jfh-store:make-instance-list 'external-application-configuration)
  "list of registred apps managed in admin")

(define-admin-page (admin-page "/admin") ()
  "Main Entry point for hokima admin."
  (:div (:a :href "/admin/app-manage-step1" "Start managing an App.")))

(defun render-app-info (app-info)
  (who:with-html-output-to-string
      (*standard-output* nil :indent t)
    (:div
     (who:fmt "<h2>Selected App</h2><table cellpadding='10' border='1'><tr><th>App Name</th><td>~A</td></tr><tr><th>App root</th><td>~A</td></tr><tr><th>Auth type</th><td>~A</td></tr>"
              (name app-info) (root-path app-info) (application-auth-type app-info))
     (when (string= "certificate" (application-auth-type app-info))
       (who:fmt "<tr><th>Cert config path</th><td>~A</td></tr><tr><th>Cert save path</th><td>~A</td></tr>"
                (certificate-config-path app-info) (certificate-path app-info)))
     (who:fmt "</table>"))))

(define-admin-page (admin-app-manage-step1 "/admin/app-manage-step1") ()
  "Manage an App - Step 1"
  (:div "Select app to manage")
  (:div
   (:form :action "/admin/app-manage-step2" :method "POST"
          (:select :name "app-name" :size "4"
                   (loop for app in *registered-apps* collect (who:htm (:option :value  (name app) (who:str (display-name app))))))
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

