(in-package :ledger-asset-prices)

;;; Formating

(defun format-price (price)
  (format nil "P ~a \"~a\" ~f \"~a\""
          (assoc-value price :time)
          (assoc-value price :ticker)
          (assoc-value price :price)
          (assoc-value price :currency)))

(defun format-prices (prices)
  (mapcar #'format-price prices))

(defun format-prices-lines (prices) (join "
" (format-prices prices)))

(defparameter *stock-config*
  (list
   '((:ticker . "CDPROJECT")
     (:api . :marketstack)
     (:api-ticker . "CDR.XWAR"))
   '((:ticker . "DECORA")
     (:api . :marketstack)
     (:api-ticker . "DCR.WAR"))))

(uiop:getenv "MARKETSTACK_API_KEY")
