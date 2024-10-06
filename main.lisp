(in-package #:cl-user)

(defun jfh-app-main ()
  (hokima-main::application-start)
  (sb-impl::toplevel-repl nil))
