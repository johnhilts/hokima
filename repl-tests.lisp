;;; ideas
#|
- get rid of "store" as exported thing
- replace "label" with CLASS-NAME ".sexp" to derive file name inside user-store
- the derived file name can be added to the serialized list '__file-name
 - Do this part inside of JFH-STORE:SERIALIZE-OBJECT->LIST
- do similar with index - make sure there are classes to represent the different kinds, such as USER-INDEX-ENTRY (already exists, add more if necessary)
- replace key with logic to GETF :user-id from the serialized list inside user-store

|#

;; derive file name example
(let ((obj (make-instance 'jfh-user:application-meta-user :user-id "20250201-2" :user-login "m4@here.com")))
  (string-downcase (symbol-name (class-name (class-of obj)))))

(let ((list (list :one "one" :two "two" 'jfh-store::__file-name "application-meta-user")))
               (format t "Everything 1: ~S~%" list)
               (format t "~A, ~A~%" (getf list :one) (getf list 'jfh-store::__file-name))
               (remf list 'jfh-store::__file-name)
               (format t "Everything 2: ~S~%" list))

;; save user login index
(let ((jfh-store:*app-data-path* "/root/code/lisp/source/chasi"))
  (jfh-store:save-data 
   (make-instance 'jfh-store:user-index-store :label "user-login-index")
   (make-instance 'jfh-store:user-index-data :serialized-data 
                  (jfh-store:serialize-object->list
                   (jfh-user::make-user-index-entry (make-instance 'jfh-user:application-user :user-login "me2@here.com" :user-id "20250131-2"))
                   (list 'jfh-user:user-id 'jfh-user:user-login)))))

(jfh-store:save-data 
 (make-instance 'jfh-store:user-index-store :label "user-login-index")
 (make-instance 'jfh-store:user-index-data :serialized-data 
                (jfh-store:serialize-object->list
                 (jfh-user::make-user-index-entry (make-instance 'jfh-user:application-user :user-login "me2@here.com" :user-id "20250131-2"))
                 (list 'jfh-user:user-id 'jfh-user:user-login))))

;; save meta-user
;; call the method
(let ((jfh-store:*store-root-folder* "/root/code/lisp/source/chasi"))
  (jfh-user::save-application-user (make-instance 'jfh-user:application-meta-user :user-login "you@there.com" :user-id "20250126-0913")))

;; call the inside of the method
(let* ((application-user (make-instance 'jfh-user:application-meta-user :user-id "20250201-1" :user-login "m3@here.com"))
       (store (make-instance 'jfh-store:user-config-store :label "user" :key (jfh-user:user-id application-user)))
       (serialized-data (jfh-store:serialize-object->list application-user (list 'jfh-user:user-id 'jfh-user:user-login 'jfh-user::create-date 'jfh-user::disable)))
       (data (make-instance 'jfh-store:user-config-data :serialized-data serialized-data)))
  (jfh-store:save-data store data))

(let ((jfh-store:*app-data-path* "/root/code/lisp/source/chasi"))
  (let* ((application-user (make-instance 'jfh-user:application-meta-user :user-id "20250201-2" :user-login "m4@here.com"))
         (store (make-instance 'jfh-store:user-config-store :label "user" :key (jfh-user:user-id application-user)))
         (serialized-data (jfh-store:serialize-object->list application-user (list 'jfh-user:user-id 'jfh-user:user-login 'jfh-user::create-date 'jfh-user::disable)))
         (data (make-instance 'jfh-store:user-config-data :serialized-data serialized-data)))
    (jfh-store:save-data store data)))

  
;; save secure-user - TODO update
(let ((jfh-store:*store-root-folder* "/root/code/lisp/source/chasi"))
  (jfh-user::save-application-user (make-instance 'jfh-user:application-secure-user :user-id "20250126-1410" :user-api-key "the-api-key" :user-fingerprint #(1 2 3 4) :user-password "the secret password")))

;; save web-user - TODO update
(let ((jfh-store:*store-root-folder* "/root/code/lisp/source/chasi"))
  (jfh-user::save-application-user (make-instance 'hokima-web-app::web-app-user :user-id "20250126-1421" :user-name "Mr Web User" :user-login "you@web.com" :user-password "password-not-set")))

;; (make-instance 'hokima-web-app::web-app-user :user-login "you@web.com" :user-password "password-not-set" :user-id user-id)
