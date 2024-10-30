;; (cl:in-package #:asdf-user)

#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(defun read-complete-file (path)
  "read complete file all at once"
  (with-open-file (in path :if-does-not-exist :create)
    (read in nil)))

(defun load-everything (app-root lib-root)
  (flet ((locate-system-path-and-load-it (system-path system-name &optional (type 'library))
           (push (make-pathname :directory (concatenate 'string (if (eql type 'library) lib-root app-root) system-path)) asdf:*central-registry*)
           (asdf:load-system system-name)))
    (locate-system-path-and-load-it "store" "jfh-store")
    (locate-system-path-and-load-it "configuration" "jfh-configuration")
    (locate-system-path-and-load-it "utility" "jfh-utility")
    (locate-system-path-and-load-it "remoting" "jfh-remoting")
    (locate-system-path-and-load-it "user" "jfh-user")
    (locate-system-path-and-load-it "web-server" "jfh-web-server")
    (locate-system-path-and-load-it "web-auth" "jfh-web-auth")
    (locate-system-path-and-load-it "web-app" "hokima-web-app" 'app)
    ;; CIRCULAR DEPENDENCY (locate-system-path-and-load-it "" "hokima-main" 'app) ;; CIRCULAR DEPENDENCY
    ;; (asdf:load-system "hokima-main")
    )
  (print "dependencies loaded"))

(let* ((file (read-complete-file ".config"))
       (app-root (cdr (assoc :app-root file))) 
       (lib-root (cdr (assoc :lib-root file)))
       ;; (jfh-web-lib-path (make-pathname :directory (concatenate 'string lib-root "/web/jfh-web")))
       ;; (jfh-web-source-path (probe-file (concatenate 'string "/" lib-root "/web/jfh-web/jfh-web.lisp")))
       ;; (main-app-path (make-pathname :directory app-root))
       )

  (load-everything app-root lib-root)
  ;; (push jfh-web-lib-path asdf:*central-registry*)
  ;; (push main-app-path asdf:*central-registry*)
  ;; (asdf:load-system "jfh-web")
  ;; (compile-file jfh-web-source-path)
  )

(asdf:defsystem #:hokima-main
  :description "Password Safe"
  :author "John Hilts <johnhilts@gmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :components ((:file package)
               (:file application)
               (:file main))
  :depends-on (:hunchentoot :cl-who :cl-ppcre :hokima-web-app :jfh-web-server :jfh-store :jfh-configuration :jfh-remoting))

(defun buildapp ()
  (asdf:load-system :hokima-main)
  (sb-ext:save-lisp-and-die "hokima-app"
                     :toplevel 'cl-user::jfh-app-main
                     :executable t)
  (print "main loaded"))
