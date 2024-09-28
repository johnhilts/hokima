;;;; web-specific utility
(cl:in-package #:hokima-web-app)

(defun format-for-web (string)
  "Replace line-breaks \n with the HTML <br /> element."
  (cl-ppcre:regex-replace-all (string #\Newline) string "<br />"))
