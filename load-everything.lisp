(cl:in-package #:cl-user)

(defparameter *jfh-app/home-folder*
  (with-open-file (input "/etc/hokima.conf") ;; TODO add some kind of nice error handling here
    (read-line input nil nil)))   ;; "/root/code/lisp/source" "/home/jfh/code/lisp/source"

(defparameter *jfh-app/library-root-folder*
"/jfh-lib"
;;  "/jfh" ?? I think that's right for my home machine
  )

(defparameter *jfh-app/web-app-root-folder*
"/hokima")

(defun load-one-system (root system-root system-folder system-name)
  (let ((system-fq (format nil "~A/~A/~A/" root system-root system-folder)))
    (swank:set-default-directory system-fq)
    (push (make-pathname :directory system-fq) asdf:*central-registry*)
    (asdf:load-system system-name)
    (format t "~&~A loaded.~%" system-name)))

(defun load-local-everything ()
  (load-one-system *jfh-app/home-folder* *jfh-app/library-root-folder* "store" "jfh-store")
  (load-one-system *jfh-app/home-folder* *jfh-app/library-root-folder* "configuration" "jfh-configuration")
  (load-one-system *jfh-app/home-folder* *jfh-app/library-root-folder* "utility" "jfh-utility")
  (load-one-system *jfh-app/home-folder* *jfh-app/library-root-folder* "remoting" "jfh-remoting")
  (load-one-system *jfh-app/home-folder* *jfh-app/library-root-folder* "user" "jfh-user")
  (load-one-system *jfh-app/home-folder* *jfh-app/library-root-folder* "web-server" "jfh-web-server")
  (load-one-system *jfh-app/home-folder* *jfh-app/library-root-folder* "web-auth" "jfh-web-auth")
  (load-one-system *jfh-app/home-folder* *jfh-app/web-app-root-folder* "web-app" "hokima-web-app")
  (load-one-system *jfh-app/home-folder* *jfh-app/web-app-root-folder* "" "hokima-main")

  ;; (swank:set-default-directory "/home/jfh/code/lisp/source/org2html/")
  ;; (push #p"/home/jfh/code/lisp/source/org2html/" asdf:*central-registry*)
  ;; (asdf:load-system "org2html-main")
  ;; (print "main loaded")
  ;; (in-package #:org2html)
  ;; (load "internal.lisp")
  )
