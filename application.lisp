(in-package #:hokima-main)

(defparameter *web-application* nil)
(defparameter *remoting-configuration* nil)

(defun application-start ()
  "Use this to start the application."
  (flet ((map-static-paths ()
	   (mapc
	    (lambda (pair)
	      (jfh-web-server:add-static-path-map (car pair) (cadr pair)))
	    hokima-web-app:*static-paths-maps*)))

    (map-static-paths)
    
    (let ((web-application (jfh-web-server:web-application-shell)))

      (setf web-app:*web-configuration* (jfh-web-server:web-configuration web-application))
      
      (let* ((remoting-configuration (jfh-remoting:make-remoting-configuration jfh-store:*data-store-location*))
             (actual-remoting-configuration (jfh-remoting:start-swank remoting-configuration)))
        (setf *remoting-configuration* actual-remoting-configuration))

      (setf *web-application* web-application))))

(defun application-stop (&optional (stop-swank t) (web-application *web-application*) (remoting-configuration *remoting-configuration*))
  "Use this to stop the application. Stopping swank is optional."
  (jfh-web-server:stop-web-app web-application)
  (if (and stop-swank remoting-configuration)
      (jfh-remoting:stop-swank *remoting-configuration*)))
