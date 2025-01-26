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

