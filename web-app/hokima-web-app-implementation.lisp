(cl:in-package #:hokima-web-app)

(defmethod initialize-instance :after ((external-application-configuration external-application-configuration) &key)
  "Initializations:
- Properly hydrate ROOT-PATH and CERTIFICATE-PATH
Assumptions:
- This information is READ ONLY"
  (let ((name (progn
                #1=(slot-value external-application-configuration '%root-path)
                (slot-value external-application-configuration '%name)))
        (certificate-path (and
                           (slot-boundp external-application-configuration '%certificate-path)
                           #2=(slot-value external-application-configuration '%certificate-path))))
    (setf #1# (format nil (format nil "~A/~A" cl-user::*jfh-app/home-folder* name)))
    (when #2#
      (setf #2# (format nil (format nil "~A/~A" cl-user::*jfh-app/home-folder* certificate-path))))))

(defmethod print-object ((external-application-configuration external-application-configuration) stream)
  "Print external application configuration."
  (print-unreadable-object (external-application-configuration stream :type t)
    (with-accessors
          ((name name) (display-name display-name) (root-path root-path) (application-auth-type application-auth-type)
           (certificate-config-path certificate-config-path) (certificate-path certificate-path))
        external-application-configuration
      (format stream
	      "App Name: ~A (~A), App Path: ~A, Auth Type: ~A~:[~:;, Cert Config Path: ~:*~A, ~]~:[~:;Cert Path: ~:*~A ~]"
              name display-name root-path application-auth-type certificate-config-path certificate-path))))
