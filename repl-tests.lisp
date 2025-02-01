;; save user login index
(let ((jfh-store:*store-root-folder* "/root/code/lisp/source/chasi"))
  (let* ((data (jfh-store:serialize-object->list (jfh-user::make-user-index-entry (make-instance 'jfh-user:application-meta-user :user-login "you@there.com" :user-id "20250126-0934")) (list 'jfh-user:user-id 'jfh-user:user-login)))
         (store-data (make-instance 'jfh-store:user-index-store-data :data data :label "user-login-index")))
    (jfh-store:save-user-data store-data)))

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

;; update user login index
(let ((jfh-store:*store-root-folder* "/root/code/lisp/source/chasi"))
  (let* ((data (jfh-store:serialize-object->list (jfh-user::make-user-index-entry (make-instance 'jfh-user:application-meta-user :user-login "you@there.com" :user-id "20250126-1027")) (list 'jfh-user:user-id 'jfh-user:user-login)))
         (store-data (make-instance 'jfh-store:user-index-store-data :data data :label "user-login-index"))
         (store-object (make-instance 'jfh-store:user-index-store-object :label (jfh-store::label store-data) :location (format nil "~A/users" jfh-store::*store-root-folder*))))
    (let ((file-contents (jfh-store:get-data store-object store-data))
          (file-path (format nil "~A/~A.sexp" (jfh-store::location store-object) (jfh-store::label store-object))))
      (format nil "File path: ~A~%Updated Data:~A~%" file-path (push (jfh-store::data store-data) file-contents)))))
