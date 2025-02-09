(in-package #:hokima-main)

(defun application-start ()
  "Use this to start the application."
  (flet ((map-static-paths ()
	   (mapc
	    (lambda (pair)
	      (jfh-web-server:add-static-path-map (car pair) (cadr pair)))
	    hokima-web-app:*static-paths-maps*)))

    (let ((application-configuration (jfh-configuration:bind-configuration 'jfh-configuration:application)))
      ;; NOTE - assuming user settings are in "./users" with no way to override
      (setf jfh-store:*app-data-path* (jfh-configuration:settings-file-path application-configuration)))
    
    (map-static-paths)

    (jfh-remoting:start-swank (jfh-configuration:bind-configuration 'jfh-remoting:remoting))
    
    (jfh-web-server:web-application-shell (jfh-configuration:bind-configuration 'jfh-web-server:web))))

(defun application-stop (&optional (stop-swank t) (web-application jfh-web-server:*web-application*))
  "Use this to stop the application. Stopping swank is optional."
  (jfh-web-server:stop-web-app web-application)
  (let ((remoting-configuration (jfh-configuration:get-configuration 'jfh-remoting:remoting)))
    (when (and stop-swank remoting-configuration)
      (jfh-remoting:stop-swank remoting-configuration))))
