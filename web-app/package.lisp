#|
code/lisp/source/jfh/
├── configuration
├── internal
├── remoting
├── store
├── testing
├── tests
│   └── jfh-user
├── user
├── utility
├── web-auth
└── web-server
|#

(in-package #:cl-user)

(defpackage #:hokima-web-app
  (:use #:common-lisp)
  (:local-nicknames
   (#:config #:jfh-configuration) ;; not using?
   (#:remoting #:jfh-remoting) ;; not using?
   (#:store #:jfh-store)
   (#:user #:jfh-user)
   (#:util #:jfh-utility)
   (#:auth #:jfh-web-auth)
   (#:web #:jfh-web-server))
  (:export
    #:*web-configuration*
    #:*static-paths-maps*
  ;;  #:setup-dispatch-for-all-html-files
  ;;  #:signup-page
  ;;  #:login-page
  ;;  #:find-user-info
  ;;  #:show-auth-failure
    ;;  #:on-auth-hook
    )
  )
