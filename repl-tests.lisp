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
(let ((jfh-store:*store-root-folder* "/root/code/lisp/source/chasi"))
  (jfh-user::save-application-user (make-instance 'jfh-user:application-meta-user :user-login "you@there.com" :user-id "20250126-0913")))

;; save secure-user
(let ((jfh-store:*store-root-folder* "/root/code/lisp/source/chasi"))
  (jfh-user::save-application-user (make-instance 'jfh-user:application-secure-user :user-id "20250126-1410" :user-api-key "the-api-key" :user-fingerprint #(1 2 3 4) :user-password "the secret password")))

;; save web-user
(let ((jfh-store:*store-root-folder* "/root/code/lisp/source/chasi"))
  (jfh-user::save-application-user (make-instance 'hokima-web-app::web-app-user :user-id "20250126-1421" :user-name "Mr Web User" :user-login "you@web.com" :user-password "password-not-set")))

;; (make-instance 'hokima-web-app::web-app-user :user-login "you@web.com" :user-password "password-not-set" :user-id user-id)
