(in-package :ledger-asset-prices)

(define-condition stock-not-found-error (error)
  ((stock :initarg :stock :reader stock)))

(define-condition stock-fetch-error (error)
  ((stock :initarg :stock :reader stock)
   (cause :initarg :cause :reader cause)))

(defun return-nonexisting-stock (c)
  (let ((ticker (alist-get (stock c) :ticker)))
    (use-value (list (cons :ticker ticker)
                     '(:error . "Not found")))))

(defun return-failed-stock (c)
  (let ((ticker (alist-get (stock c) :ticker)))
    (use-value (list (cons :ticker ticker)
                     '(:error . "Failed to fetch stock")))))

(defun skip-nonexisting-stock (c)
  (invoke-restart 'skip-nonexisting-stocks))
