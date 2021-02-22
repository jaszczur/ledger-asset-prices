(in-package :ledger-asset-prices)

;;; Formating

(defun format-price (price)
  (format nil "P ~a \"~a\" ~f \"~a\""
          (assoc-value price :date)
          (assoc-value price :ticker)
          (assoc-value price :price)
          (assoc-value price :currency)))

(defun format-prices (prices)
  (mapcar #'format-price prices))

(defun format-prices-lines (prices) (join "
" (format-prices prices)))

;;; Configuration

(defparameter *stock-config*
  (list
   '((:ticker . "CDPROJECT")
     (:api . :marketstack)
     (:api-ticker . "CDR.XWAR"))
   '((:ticker . "DECORA")
     (:api . :marketstack)
     (:api-ticker . "DCR.XWAR"))))

;;; Data fetching

(defgeneric fetch-price (api stock date)
  (:documentation "Fetches asset price from given API at given date"))

(defun fetch-prices (date &optional (config *stock-config*))
  (mapcar #'(lambda (stock) (fetch-price (cdr (assoc :api stock)) stock date))
          config))

(defun ledger-prices-for-date (date)
  (format-prices (fetch-prices date)))

#+nil
(progn

  (asdf:load-system :ledger-asset-prices)

  (fetch-prices "2021-01-22")

  (ledger-prices-for-date "2021-01-22")
  
  (start '("2021-01-22"))
  
  )
