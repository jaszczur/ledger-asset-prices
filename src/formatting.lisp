(in-package :ledger-asset-prices)

;;; Formating

(defun format-price (price)
  (let ((err (assoc-value price :error)))
    (if err
        (format nil "; error for ~a: ~a"
                (assoc-value price :ticker)
                err)
        (format nil "P ~a \"~a\" ~f \"~a\""
                (assoc-value price :date)
                (assoc-value price :ticker)
                (assoc-value price :price)
                (assoc-value price :currency)))))

(defun format-prices (prices)
  (mapcar #'format-price prices))

(defun format-prices-lines (prices) (join "
" (format-prices prices)))
