;;;; Configure settings for this web app
(cl:in-package #:hokima-web-app)

(defvar *web-configuration* (make-instance 'web:web-configuration))

(defparameter *static-paths-maps*
  '(("/favicon.ico" "ez-favicon.ico")
    ("/styles.css" "static/styles.css")
    ("/robots.txt" "static/robots.txt")))

;; (defun setup-dispatch-for-all-html-files ()
;;   (push
;;    (tbnl:create-regex-dispatcher
;;     ".*\.html"
;;     (lambda () (tbnl:handle-static-file (format nil "/home/jfh/code/lisp/source/org2html/html/~A" (tbnl:script-name tbnl:*request*)))))
;;    tbnl:*dispatch-table*))
