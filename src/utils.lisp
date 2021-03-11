(in-package :ledger-asset-prices)

(defun alist-str-get (al k)
  (cdr (assoc k al :test 'equal)))

(defmacro alist-str-get* (al &rest ks)
  "TODO")

(defun alist-get (al k)
  (cdr (assoc k al)))

(defun read-new-value ()
   (format t "Enter a new value: ")
   (multiple-value-list (eval (read))))
