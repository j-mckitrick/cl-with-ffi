(defpackage #:cl-with-cffi
  (:use #:cl #:cffi)
  (:export
   #:run))

(in-package #:cl-with-cffi)

(define-foreign-library libjcm
  (t (:default "/Users/jmckitrick/devel/jcm-lib/libjcm")))

(use-foreign-library libjcm)

(defcfun "jcm_do_nothing" :void)
(defcfun "jcm_return_int" :int)
(defcfun "jcm_process_int" :int (i :int))
(defcfun "jcm_access_pointer" :pointer (p :pointer))
(defcfun "jcm_access_string" :int (p :pointer))
(defcfun "jcm_process_doubles" :pointer (d :pointer))

(defun run ()
  (format t "Do nothing: ~A~%" (jcm-do-nothing))
  (format t "Return int: ~A~%" (jcm-return-int))
  (format t "Process int: ~A~%" (jcm-process-int 88))
  (with-foreign-pointer (my-int 1)
	(jcm-access-pointer my-int)
	(format t "Access pointer: ~A~%" (mem-ref my-int :int)))
  (with-foreign-string (buf "Hello, world!")
	(jcm-access-string buf)
	(format t "Access string: ~A~%" (foreign-string-to-lisp buf)))
  (with-foreign-pointer (my-double 1)
	(setf (mem-ref my-double :double) 1.414d0)
	(let ((retval (jcm-process-doubles my-double)))
	  (format t "Access pointer to double: ~A~%" (mem-ref my-double :double))
	  (format t "Access retval double: ~A~%" (mem-ref retval :double)))))
