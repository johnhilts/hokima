(in-package #:hokima-main)

(defparameter *remoting-configuration* nil)

(defun application-start ()
  "Use this to start the application."
  (flet ((map-static-paths ()
	   (mapc
	    (lambda (pair)
	      (jfh-web-server:add-static-path-map (car pair) (cadr pair)))
	    hokima-web-app:*static-paths-maps*)))

    (setf jfh-store:*data-store-location*
          (make-instance 'jfh-store:data-store-location :settings-file-path "./" :user-path-root "./users/"))
    
    (map-static-paths)

    (let ((web-configuration (jfh-web-server:make-web-configuration jfh-store:*data-store-location*)))
      (setf web-app:*web-configuration* web-configuration)
      
      (let* ((remoting-configuration (jfh-remoting:make-remoting-configuration jfh-store:*data-store-location*))
             (actual-remoting-configuration (jfh-remoting:start-swank remoting-configuration)))
        (setf *remoting-configuration* actual-remoting-configuration))

      (jfh-web-server:web-application-shell web-configuration))))

(defun application-stop (&optional (stop-swank t) (web-application jfh-web-server:*web-application*) (remoting-configuration *remoting-configuration*))
  "Use this to stop the application. Stopping swank is optional."
  (jfh-web-server:stop-web-app web-application)
  (if (and stop-swank remoting-configuration)
      (jfh-remoting:stop-swank *remoting-configuration*)))
