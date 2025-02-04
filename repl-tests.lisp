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

;; get user login index
(progn
  (format t "~&*** Get User Login Index ***~%")
  (jfh-store:get-data 'jfh-store:user-index-data))

(progn
  (format t "~&*** Get User Login Index, using user class ***~%")
  (jfh-store:get-data 'jfh-user::user-index-entry))

(progn
  (format t "~&*** Get User Login Index, using user class ***~%")
  (jfh-store:make-instance* 'jfh-user::user-index-entry :key "no-match"))

(progn
  (format t "~&*** Get User Login Index, using user class ***~%")
  (jfh-store:make-instance* 'jfh-user::user-index-entry :key "20250203"))

(progn
  (let ((jfh-store:*app-data-path* "/root/code/lisp/source/chasi"))
    (format t "~&*** Get User Login Index, using user class ***~%")
    (jfh-store:get-data 'jfh-user::user-index-entry)))

;; save user login index
(progn
  (let ((jfh-store:*app-data-path* "/root/code/lisp/source/chasi"))
    (format t "~&*** Save User Login Index ***~%")
    (jfh-store:save-object
     (make-instance 'jfh-user::user-index-entry :user-login "20250203@test.com" :user-id "20250203")
     (list 'jfh-user:user-login 'jfh-user:user-id))))

(progn
  (format t "~&*** Save User Login Index ***~%")
  (jfh-store:save-object
   (make-instance 'jfh-user::user-index-entry :user-login "20250203@test.com" :user-id "20250203-2")
   (list 'jfh-user:user-login 'jfh-user:user-id)))

;; save meta-user
;; call the method
(let ((jfh-store:*store-root-folder* "/root/code/lisp/source/chasi"))
  (jfh-user::save-application-user (make-instance 'jfh-user:application-meta-user :user-login "you@there.com" :user-id "20250126-0913")))

(progn
  (format t "~&*** Save Meta User ***~%")
  (jfh-store:save-object
   (make-instance 'jfh-user:application-meta-user :user-login "20250203@test.com" :user-id "20250203-2")
   (list 'jfh-user:user-login 'jfh-user:user-id 'jfh-user::disable 'jfh-user::create-date)
   :key "20250203-2"))


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

  
;; save secure-user
(progn
  (format t "~&*** Save Secure User ***~%")
  (let ((jfh-store:*app-data-path* "/root/code/lisp/source/chasi"))
    (jfh-store:save-object
     (make-instance 'jfh-user:application-secure-user :user-login "20250203@test.com" :user-id "20250203-2" :user-fingerprint #(1 2 3) :user-password "the secret password" :user-api-key "abc123-chasi")
     (list 'jfh-user:user-fingerprint 'jfh-user:user-password 'jfh-user:user-api-key)
     :key "20250203-2")))

(progn
  (format t "~&*** Save Secure User ***~%")
  (jfh-store:save-object
   (make-instance 'jfh-user:application-secure-user :user-login "20250203@test.com" :user-id "20250203-2" :user-fingerprint #(1 2 3) :user-password "the secret password" :user-api-key "abc123")
   (list 'jfh-user:user-fingerprint 'jfh-user:user-password 'jfh-user:user-api-key)
   :key "20250203-2"))

;; save web-user
(progn
  (format t "~&*** Save Web User ***~%")
  (let ((jfh-store:*app-data-path* "/root/code/lisp/source/chasi"))
    (jfh-user:save-new-application-user (hokima-web-app::make-external-app-user "Mr Web User" "20250203@test.com" #(2 3 69) "20250203-2"))))

;; (make-instance 'hokima-web-app::web-app-user :user-login "you@web.com" :user-password "password-not-set" :user-id user-id)
