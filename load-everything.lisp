(cl:in-package #:cl-user)

(defun load-local-everything ()
  (swank:set-default-directory "/home/jfh/code/lisp/source/jfh/store")
  (push #p"/home/jfh/code/lisp/source/jfh/store/" asdf:*central-registry*)
  (asdf:load-system "jfh-store")
  (print "jfh-store loaded")

  (swank:set-default-directory "/home/jfh/code/lisp/source/jfh/configuration/")
  (push #p"/home/jfh/code/lisp/source/jfh/configuration/" asdf:*central-registry*)
  (asdf:load-system "jfh-configuration")
  (print "jfh-configuration loaded")

  (swank:set-default-directory "/home/jfh/code/lisp/source/jfh/utility/")
  (push #p"/home/jfh/code/lisp/source/jfh/utility/" asdf:*central-registry*)
  (asdf:load-system "jfh-utility")
  (print "jfh-utility loaded")

  (swank:set-default-directory "/home/jfh/code/lisp/source/jfh/remoting/")
  (push #p"/home/jfh/code/lisp/source/jfh/remoting/" asdf:*central-registry*)
  (asdf:load-system "jfh-remoting")
  (print "jfh-remoting loaded")

  (swank:set-default-directory "/home/jfh/code/lisp/source/jfh/user/")
  (push #p"/home/jfh/code/lisp/source/jfh/user/" asdf:*central-registry*)
  (asdf:load-system "jfh-user")
  (print "jfh-user loaded")

  (swank:set-default-directory "/home/jfh/code/lisp/source/jfh/web-server/")
  (push #p"/home/jfh/code/lisp/source/jfh/web-server/" asdf:*central-registry*)
  (asdf:load-system "jfh-web-server")
  (print "jfh-web-server loaded")

  (swank:set-default-directory "/home/jfh/code/lisp/source/jfh/web-auth/")
  (push #p"/home/jfh/code/lisp/source/jfh/web-auth/" asdf:*central-registry*)
  (asdf:load-system "jfh-web-auth")
  (print "jfh-web-auth loaded")

  (swank:set-default-directory "/home/jfh/code/lisp/source/hokima/web-app/")
  (push #p"/home/jfh/code/lisp/source/hokima/web-app/" asdf:*central-registry*)
  (asdf:load-system "hokima-web-app")
  (print "hokima-web-app loaded")

  (swank:set-default-directory "/home/jfh/code/lisp/source/hokima/")
  (push #p"/home/jfh/code/lisp/source/hokima/" asdf:*central-registry*)
  (asdf:load-system "hokima-main")
  (print "hokima-main loaded")

  ;; (swank:set-default-directory "/home/jfh/code/lisp/source/org2html/")
  ;; (push #p"/home/jfh/code/lisp/source/org2html/" asdf:*central-registry*)
  ;; (asdf:load-system "org2html-main")
  ;; (print "main loaded")
  ;; (in-package #:org2html)
  ;; (load "internal.lisp")
  )
