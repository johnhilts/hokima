;;;; Web page sections to include in other pages
(cl:in-package #:hokima-web-app)

(defun get-version () "1")

(defun common-header (title)
  (who:with-html-output-to-string
      (*standard-output* nil :indent t)
    (:head
     (:meta :charset "utf-8")
     (:meta :name "viewport" :content "width=device-width, initial-scale=1.0")
     (:title (who:str (format nil "Secrets Safe - ~A" title)))
     (:link :type "text/css"
            :rel "stylesheet"
            :href (format nil "~A~A~D" (web:static-root (jfh-configuration:get-configuration 'web:web)) "/styles.css?v=" (get-version))))))
